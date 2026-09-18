import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../../../core/network/platform_discovery.dart';
import '../../../core/network/vendor_lookup_service.dart';
import '../../devices/domain/device.dart';
import '../../devices/domain/device_event.dart';
import '../../intelligence/domain/identity_reconciler.dart';
import '../../intelligence/domain/identity.dart';
import '../../intelligence/domain/classifier.dart';
import '../../intelligence/domain/evidence_collector.dart';
import '../../intelligence/domain/device_learning_service.dart';

final databaseProvider = Provider((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
final scanProvider = NotifierProvider<ScanController, ScanView>(
  ScanController.new,
);
final networkInfoProvider = Provider((ref) => NetworkInfoService());
final discoveryProvider = Provider((ref) => AndroidDiscovery());
final vendorProvider = Provider((ref) => VendorLookupService());

class ScanView {
  const ScanView({
    this.network,
    this.networkId,
    this.devices = const [],
    this.phase = 'idle',
    this.scanned = 0,
    this.total = 0,
    this.found = 0,
    this.warnings = const [],
    this.lastScan,
  });
  final NetworkInfo? network;
  final String? networkId;
  final List<Device> devices;
  final String phase;
  final int scanned, total, found;
  final List<String> warnings;
  final DateTime? lastScan;
  bool get busy => [
    'preparing',
    'scanning',
    'resolving',
    'identifying',
    'classifying',
    'saving',
  ].contains(phase);
}

class ScanController extends Notifier<ScanView> {
  NetworkInfoService get info => ref.read(networkInfoProvider);
  AndroidDiscovery get bridge => ref.read(discoveryProvider);
  VendorLookupService get vendors => ref.read(vendorProvider);
  IdentityReconciler merger = IdentityReconciler();
  final classifier = DeviceClassifier();
  final collector = EvidenceCollector();
  final learning = const DeviceLearningService();
  final baseline = <String, Device>{};
  Timer? expiryTimer;
  StreamSubscription<Map<String, dynamic>>? subscription;
  Timer? timer;
  String? run;
  DateTime? started;
  int scanned = 0, total = 0;
  String phase = 'idle';
  bool terminal = false, cancelled = false, starting = false;
  final warnings = <String>[];
  final seen = <String>{};
  Future<void>? refreshPending;
  @override
  ScanView build() {
    final native = bridge;
    expiryTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => expireEvidence(),
    );
    ref.onDispose(() {
      timer?.cancel();
      expiryTimer?.cancel();
      subscription?.cancel();
      unawaited(native.cancel());
    });
    Future.microtask(refresh);
    return const ScanView();
  }

  void log(String event) {
    if (kDebugMode) debugPrint(jsonEncode({'event': event, 'phase': phase}));
  }

  Future<void> refresh() {
    if (state.busy) return Future.value();
    return refreshPending ??= detectAndLoad().whenComplete(
      () => refreshPending = null,
    );
  }

  Future<void> detectAndLoad() async {
    try {
      final n = await info.detect();
      final db = ref.read(databaseProvider);
      final id = await db.network(n);
      final rows = await db.loadDevices(id);
      for (final d in rows) {
        classifier.evaluate(d.fingerprint);
      }
      await db.saveIntelligence(rows);
      final sessions = await (db.select(
        db.scanSessions,
      )..where((s) => s.networkId.equals(id))).get();
      final completed =
          sessions
              .where((s) => s.status == 'completed')
              .map((s) => s.endedAt!)
              .toList()
            ..sort();
      state = ScanView(
        network: n,
        networkId: id,
        devices: rows,
        lastScan: completed.isEmpty ? null : completed.last,
        warnings: n.ssid == null
            ? [
                'Wi-Fi name unavailable. Optional location access and location services may be required.',
              ]
            : [],
      );
      log('network_detected');
    } catch (e) {
      state = ScanView(phase: 'error', warnings: [friendly(e)]);
    }
  }

  String friendly(Object e) => e is PlatformException
      ? e.message ?? 'Android could not complete this operation.'
      : e.toString().replaceAll('Exception: ', '');
  Future<void> permission() async {
    try {
      await info.requestWifiName();
      await refresh();
    } catch (e) {
      state = ScanView(
        network: state.network,
        devices: state.devices,
        warnings: [friendly(e)],
      );
    }
  }

  Future<void> start() async {
    if (state.busy || starting) return;
    starting = true;
    await refresh();
    starting = false;
    if (state.network == null || state.networkId == null) return;
    final n = state.network!;
    if (n.subnet.count > 4096) {
      state = ScanView(
        network: n,
        networkId: state.networkId,
        devices: state.devices,
        warnings: [
          'This subnet has ${n.subnet.count} addresses. This build limits scans to 4,096 hosts; no partial /24 scan is substituted.',
        ],
      );
      return;
    }
    run = const Uuid().v4();
    started = DateTime.now();
    terminal = false;
    cancelled = false;
    phase = 'preparing';
    scanned = 0;
    total = n.subnet.count;
    seen.clear();
    warnings.clear();
    merger = IdentityReconciler(scanStarted: started);
    baseline
      ..clear()
      ..addEntries(state.devices.map((d) => MapEntry(d.id, Device.fromJson(d.toJson()))));
    merger.devices.addAll(
      state.devices.map((d) => Device.fromJson(d.toJson())),
    );
    publish();
    try {
      await vendors.load();
      if (cancelled) return;
      await ref.read(databaseProvider).begin(run!, state.networkId!, total);
      if (cancelled) return;
      subscription = bridge.stream.listen(
        event,
        onError: (Object e) {
          warnings.add(friendly(e));
          unawaited(finish('error'));
        },
      );
      timer = Timer.periodic(
        const Duration(milliseconds: 180),
        (_) => publish(),
      );
      await bridge.start(n, run!);
      if (cancelled) await bridge.cancel();
      log('scan_started');
    } catch (e) {
      warnings.add(friendly(e));
      await finish('error');
    }
  }

  void event(Map<String, dynamic> e) {
    if (terminal || e['runId'] != run) return;
    switch (e['kind']) {
      case 'progress':
        scanned = e['scanned'] as int;
        phase = 'scanning';
      case 'phase':
        phase = e['phase'] as String;
      case 'warning':
        if (!warnings.contains(e['message'])) {
          warnings.add(e['message'] as String);
        }
      case 'device':
        final ip = e['ip'] as String;
        if (!state.network!.subnet.contains(ip)) return;
        final incoming = Device(
          networkId: state.networkId!,
          ipAddress: ip,
          macAddress: e['mac'] as String?,
          hostname: e['hostname'] as String?,
          mdnsName: e['mdns'] as String?,
          vendor: vendors.lookup(e['mac'] as String?),
          isGateway: ip == state.network!.gateway,
          sources: {e['source'] as String},
          services: e['service'] == null
              ? []
              : [Map<String, dynamic>.from(e['service'])],
        );
        collector.collect(incoming, e, run!);
        final learned = learning.learnedOverride(incoming, merger.devices);
        if (learned != null && incoming.fingerprint.override == null) {
          incoming.fingerprint.applyOverride(learned);
        }
        final d = merger.merge(incoming);
        seen.clear();
        seen.addAll(merger.observedIds);
        seen.add(d.id);
        log('device_merged');
      case 'completed':
        unawaited(finish('completed'));
      case 'cancelled':
        unawaited(finish('cancelled'));
      case 'error':
        warnings.add(e['message'] as String);
        unawaited(finish('error'));
    }
  }

  void publish() {
    for (final d in merger.devices) {
      if (d.fingerprint.dirty) classifier.evaluate(d.fingerprint);
    }
    state = ScanView(
      network: state.network,
      networkId: state.networkId,
      devices: List.unmodifiable(merger.devices),
      phase: phase,
      scanned: scanned,
      total: total,
      found: merger.devices.where((d) => seen.contains(d.id)).length,
      warnings: List.unmodifiable(warnings),
      lastScan: state.lastScan,
    );
  }

  Future<void> cancel() async {
    cancelled = true;
    try {
      await bridge.cancel();
      await finish('cancelled');
    } catch (e) {
      warnings.add(friendly(e));
      await finish('error');
    }
  }

  Future<void> setOverride(Device device, DeviceOverride? value) async {
    if (state.busy) return;
    final old = device.fingerprint.override;
    device.fingerprint.applyOverride(value);
    classifier.evaluate(device.fingerprint);
    device.events.insert(
      0,
      DeviceEvent(
        type: DeviceEventType.correctionChanged,
        message: value == null ? 'User correction cleared.' : 'User identity correction updated.',
      ),
    );
    _trimEvents(device);
    try {
      await ref.read(databaseProvider).saveDeviceProfile(device);
    } catch (_) {
      device.fingerprint.applyOverride(old);
      classifier.evaluate(device.fingerprint);
      rethrow;
    }
    await refresh();
  }

  Future<void> setTrust(Device device, DeviceTrustState value) async {
    if (state.busy || device.trustState == value) return;
    final old = device.trustState;
    device.trustState = value;
    device.events.insert(
      0,
      DeviceEvent(
        type: DeviceEventType.trustChanged,
        message: value == DeviceTrustState.trusted
            ? 'Marked as a trusted device.'
            : 'Marked as an unknown device.',
      ),
    );
    _trimEvents(device);
    try {
      await ref.read(databaseProvider).saveDeviceProfile(device);
    } catch (_) {
      device.trustState = old;
      rethrow;
    }
    await refresh();
  }

  Future<void> expireEvidence() async {
    if (state.busy || refreshPending != null) return;
    final now = DateTime.now();
    final expired = state.devices
        .where(
          (d) =>
              d.fingerprint.nextExpiry != null &&
              !d.fingerprint.nextExpiry!.isAfter(now),
        )
        .toList();
    if (expired.isEmpty) return;
    for (final d in expired) {
      classifier.evaluate(d.fingerprint, at: now);
    }
    try {
      await ref.read(databaseProvider).saveIntelligence(expired);
      await refresh();
    } catch (e) {
      log('evidence_expiry_save_failed');
    }
  }

  void _trimEvents(Device device) {
    device.events.sort((a, b) => b.at.compareTo(a.at));
    if (device.events.length > 200) {
      device.events.removeRange(200, device.events.length);
    }
  }

  void _event(Device device, DeviceEventType type, String message, {Map<String, dynamic>? metadata}) {
    if (device.events.any((e) => e.scanId == run && e.type == type && e.message == message)) return;
    device.events.insert(
      0,
      DeviceEvent(type: type, message: message, scanId: run, metadata: metadata),
    );
    _trimEvents(device);
  }

  void _recordScanEvents() {
    for (final d in merger.devices) {
      final old = baseline[d.id];
      if (old == null) {
        _event(d, DeviceEventType.discovered, 'Device discovered for the first time on this network.');
        continue;
      }
      if (old.isOnline != d.isOnline) {
        _event(
          d,
          d.isOnline ? DeviceEventType.online : DeviceEventType.offline,
          d.isOnline ? 'Device came online.' : 'Device was not seen in the completed scan.',
        );
      }
      if (old.ipAddress != d.ipAddress) {
        _event(
          d,
          DeviceEventType.ipChanged,
          'IP address changed from ${old.ipAddress} to ${d.ipAddress}.',
          metadata: {'from': old.ipAddress, 'to': d.ipAddress},
        );
      }
      if (old.hostname != d.hostname && d.hostname != null) {
        _event(d, DeviceEventType.hostnameChanged, 'Hostname changed to ${d.hostname}.');
      }
      final before = old.fingerprint.classification;
      final after = d.fingerprint.classification;
      if (before.manufacturer != after.manufacturer && after.manufacturer != null) {
        _event(d, DeviceEventType.manufacturerIdentified, 'Manufacturer identified as ${after.manufacturer}.');
      }
      if (before.category != after.category && after.category != DeviceCategory.unknown) {
        _event(d, DeviceEventType.typeIdentified, 'Device type identified as ${after.category.name}.');
      }
      if (before.model != after.model && after.model != null) {
        _event(d, DeviceEventType.modelIdentified, 'Model identified as ${after.model}.');
      }
      if (before.level != after.level || before.score != after.score) {
        _event(d, DeviceEventType.confidenceChanged, 'Identity confidence changed to ${after.level.name} (${after.score}/100).');
      }
      final oldServices = old.services.map((s) => '${s['type']}|${s['name']}|${s['port']}').toList()..sort();
      final newServices = d.services.map((s) => '${s['type']}|${s['name']}|${s['port']}').toList()..sort();
      if (oldServices.join(';') != newServices.join(';')) {
        _event(d, DeviceEventType.servicesChanged, 'Advertised or reachable services changed.');
      }
    }
  }

  Future<void> finish(String result) async {
    if (terminal) return;
    terminal = true;
    timer?.cancel();
    await subscription?.cancel();
    subscription = null;
    try {
      await bridge.cancel();
    } catch (_) {
      /* Original result remains useful. */
    }
    if (result == 'completed') {
      for (final d in merger.devices) {
        d.isOnline = seen.contains(d.id);
      }
      _recordScanEvents();
    }
    phase = 'saving';
    publish();
    try {
      await ref
          .read(databaseProvider)
          .save(
            run!,
            state.networkId!,
            merger.devices,
            result,
            scanned,
            state.found,
          );
      phase = result;
      if (result == 'completed') {
        state = ScanView(
          network: state.network,
          networkId: state.networkId,
          lastScan: DateTime.now(),
        );
      }
    } catch (e) {
      phase = 'error';
      warnings.add('Could not save scan history: ${friendly(e)}');
    }
    publish();
    log('scan_$result');
  }
}
