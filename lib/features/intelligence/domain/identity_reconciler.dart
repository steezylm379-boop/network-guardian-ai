import '../../devices/domain/device.dart';
import '../../network_scan/domain/device_merge_service.dart';
import 'identity.dart';

class IdentityReconciler extends DeviceMergeService {
  IdentityReconciler({super.scanStarted});
  final observedIds = <String>{};
  final Map<String, Device> _tentative = {};

  Set<String> _strong(Device d, String type) => d.fingerprint.identifiers
      .where((i) => i.strong && i.type == type)
      .map((i) => i.value)
      .toSet();
  bool conflict(Device a, Device b) {
    for (final type in [
      'upnp_udn',
      'mac',
      'protocol_identifier',
      'mdns_identity',
    ]) {
      final left = _strong(a, type), right = _strong(b, type);
      if (left.isNotEmpty &&
          right.isNotEmpty &&
          left.intersection(right).isEmpty) {
        return true;
      }
    }
    return false;
  }

  bool strongMatch(Device a, Device b) => a.fingerprint.identifiers.any(
    (i) =>
        i.strong &&
        b.fingerprint.identifiers.any(
          (j) => j.strong && i.signature == j.signature,
        ),
  );

  @override
  Device merge(Device incoming) {
    incoming.macAddress = DeviceMergeService.normalizeMac(incoming.macAddress);
    final scoped = devices
        .where((d) => d.networkId == incoming.networkId)
        .toList();
    // Roll back a provisional IP-only attachment when new protocol identity
    // proves that a DHCP lease now belongs to a different device.
    for (final d in scoped.where((d) => d.ipAddress == incoming.ipAddress)) {
      final original = _tentative[d.id];
      if (original != null && conflict(original, incoming)) {
        devices[devices.indexOf(d)] = original;
        observedIds.remove(d.id);
        _tentative.remove(d.id);
      }
    }
    final candidates = devices
        .where(
          (d) => d.networkId == incoming.networkId && !conflict(d, incoming),
        )
        .toList();
    final strong = candidates.where((d) => strongMatch(d, incoming)).toList();
    Device? target;
    if (strong.length == 1) target = strong.single;
    if (strong.length > 1) {
      // Existing contradictory records require review, never an automatic bridge.
      for (final d in strong) {
        _link(
          d,
          incoming,
          'Shared identifier matches multiple records; review required.',
        );
      }
    } else if (target == null) {
      final sameIp = candidates
          .where((d) => d.ipAddress == incoming.ipAddress)
          .toList();
      if (sameIp.length == 1) {
        target = sameIp.single;
        if (!observedIds.contains(target.id)) {
          _tentative[target.id] = Device.fromJson(target.toJson());
        }
      }
    }
    if (target == null) {
      for (final d in candidates) {
        final sameName =
            incoming.hostname != null && incoming.hostname == d.hostname;
        final privateMac =
            incoming.macAddress != null &&
            incoming.macAddress == d.macAddress &&
            StableIdentifier.isPrivateMac(incoming.macAddress!);
        if (sameName || privateMac) {
          _link(
            d,
            incoming,
            'Matching weak identity evidence; IP changes alone do not establish identity.',
          );
        }
      }
      devices.add(incoming);
      observedIds.add(incoming.id);
      return incoming;
    }
    // An address may have a provisional observation before a UDN identifies a
    // historical device at its new address. Consolidate only current weak rows.
    for (final weak
        in candidates
            .where(
              (d) =>
                  d != target &&
                  d.ipAddress == incoming.ipAddress &&
                  observedIds.contains(d.id),
            )
            .toList()) {
      if (weak.fingerprint.identifiers.any((i) => i.strong) ||
          weak.fingerprint.override != null) {
        continue;
      }
      target.fingerprint.absorb(weak.fingerprint);
      final old = _tentative.remove(weak.id);
      if (old == null) {
        devices.remove(weak);
      } else {
        devices[devices.indexOf(weak)] = old;
      }
      observedIds.remove(weak.id);
    }
    target.fingerprint.absorb(incoming.fingerprint);
    target.macAddress = incoming.macAddress ?? target.macAddress;
    target.hostname = incoming.hostname ?? target.hostname;
    target.mdnsName = incoming.mdnsName ?? target.mdnsName;
    target.vendor = incoming.vendor ?? target.vendor;
    target.ipAddress = incoming.ipAddress;
    target.lastSeen = incoming.lastSeen;
    target.isOnline = incoming.isOnline;
    target.isGateway = incoming.isGateway;
    target.sources.addAll(incoming.sources);
    for (final s in incoming.services) {
      target.services.removeWhere(
        (v) => v['type'] == s['type'] && v['name'] == s['name'],
      );
      target.services.add(s);
    }
    observedIds.add(target.id);
    return target;
  }

  void _link(Device a, Device b, String reason) {
    a.fingerprint.possibleSameDevices[b.id] = reason;
    b.fingerprint.possibleSameDevices[a.id] = reason;
  }
}
