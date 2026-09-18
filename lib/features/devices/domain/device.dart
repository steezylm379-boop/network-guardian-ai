import 'package:uuid/uuid.dart';
import '../../intelligence/domain/identity.dart';
import 'device_event.dart';

enum DeviceTrustState { unknown, trusted }

class Device {
  Device({
    String? id,
    required this.networkId,
    required this.ipAddress,
    this.macAddress,
    this.hostname,
    this.mdnsName,
    this.vendor,
    DateTime? firstSeen,
    DateTime? lastSeen,
    this.isOnline = true,
    this.isGateway = false,
    Set<String>? sources,
    List<Map<String, dynamic>>? services,
    DeviceFingerprint? fingerprint,
    this.trustState = DeviceTrustState.unknown,
    List<DeviceEvent>? events,
  }) : id = id ?? const Uuid().v4(),
       firstSeen = firstSeen ?? DateTime.now(),
       lastSeen = lastSeen ?? DateTime.now(),
       sources = sources ?? {},
       services = services ?? [],
       events = events ?? [] {
    this.fingerprint = fingerprint ?? DeviceFingerprint(this.id);
  }
  final String id;
  final String networkId;
  String ipAddress;
  String? macAddress, hostname, mdnsName, vendor;
  DateTime firstSeen, lastSeen;
  bool isOnline, isGateway;
  final Set<String> sources;
  final List<Map<String, dynamic>> services;
  DeviceTrustState trustState;
  final List<DeviceEvent> events;
  late DeviceFingerprint fingerprint;
  String get name =>
      fingerprint.override?.userName ??
      protocolName ??
      hostname ??
      mdnsName ??
      (isGateway ? 'Router' : 'Unknown device');
  String? get protocolName => fingerprint.evidence
      .where(
        (e) =>
            e.source == 'upnp' &&
            e.key == 'friendlyName' &&
            e.activeAt(DateTime.now()),
      )
      .map((e) => e.value)
      .firstOrNull;
  Map<String, dynamic> toJson() => {
    'id': id,
    'networkId': networkId,
    'ip': ipAddress,
    'mac': macAddress,
    'hostname': hostname,
    'mdns': mdnsName,
    'vendor': vendor,
    'first': firstSeen.toIso8601String(),
    'last': lastSeen.toIso8601String(),
    'online': isOnline,
    'gateway': isGateway,
    'sources': sources.toList(),
    'services': services,
    'trustState': trustState.name,
    'events': events.map((e) => e.toJson()).toList(),
    'fingerprint': fingerprint.toJson(),
  };
  factory Device.fromJson(Map<String, dynamic> j) => Device(
    id: j['id'],
    networkId: j['networkId'],
    ipAddress: j['ip'],
    macAddress: j['mac'],
    hostname: j['hostname'],
    mdnsName: j['mdns'],
    vendor: j['vendor'],
    firstSeen: DateTime.parse(j['first']),
    lastSeen: DateTime.parse(j['last']),
    isOnline: j['online'],
    isGateway: j['gateway'],
    sources: Set<String>.from(j['sources']),
    services: (j['services'] as List? ?? const [])
        .map((e) => Map<String, dynamic>.from(e))
        .toList(),
    trustState: DeviceTrustState.values.byName(j['trustState']?.toString() ?? 'unknown'),
    events: (j['events'] as List? ?? const [])
        .map((e) => DeviceEvent.fromJson(Map<String, dynamic>.from(e)))
        .toList(),
    fingerprint: j['fingerprint'] == null
        ? null
        : DeviceFingerprint.fromJson(
            Map<String, dynamic>.from(j['fingerprint']),
          ),
  );
}
