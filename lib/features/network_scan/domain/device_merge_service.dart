import '../../devices/domain/device.dart';

/// Identity is scoped to a network. Conflicting MACs always remain separate.
class DeviceMergeService {
  DeviceMergeService({this.scanStarted});
  final DateTime? scanStarted;
  final List<Device> devices = [];
  static String? normalizeMac(String? value) {
    final mac = value?.toUpperCase().replaceAll('-', ':');
    if (mac == null ||
        !RegExp(r'^([0-9A-F]{2}:){5}[0-9A-F]{2}$').hasMatch(mac) ||
        mac == '00:00:00:00:00:00' ||
        mac == '02:00:00:00:00:00' ||
        (int.parse(mac.substring(0, 2), radix: 16) & 1) != 0) {
      return null;
    }
    return mac;
  }

  Device merge(Device incoming) {
    incoming.macAddress = normalizeMac(incoming.macAddress);
    incoming.hostname = incoming.hostname?.toLowerCase().replaceFirst(
      RegExp(r'\.$'),
      '',
    );
    final matches = devices.where((d) {
      if (d.networkId != incoming.networkId) return false;
      if (d.macAddress != null && incoming.macAddress != null) {
        return d.macAddress == incoming.macAddress;
      }
      // A hostname cannot merge two separately observed addresses in this scan.
      // A unique historical FQDN is only a fallback for DHCP changes.
      final sameName =
          incoming.hostname != null &&
          incoming.hostname!.contains('.') &&
          incoming.hostname == d.hostname &&
          scanStarted != null &&
          d.lastSeen.isBefore(scanStarted!) &&
          devices
                  .where((other) => other.hostname == incoming.hostname)
                  .length ==
              1;
      return d.ipAddress == incoming.ipAddress || sameName;
    }).toList();
    if (matches.isEmpty) {
      devices.add(incoming);
      return incoming;
    }
    // A MAC-less observation must not bridge two different physical identities.
    final macs = matches.map((d) => d.macAddress).whereType<String>().toSet();
    if (macs.length > 1) {
      return matches.firstWhere(
        (d) => d.ipAddress == incoming.ipAddress,
        orElse: () => incoming,
      );
    }
    matches.sort((a, b) => a.firstSeen.compareTo(b.firstSeen));
    final target = matches.first;
    for (final d in [...matches.skip(1), incoming]) {
      target.macAddress ??= d.macAddress;
      target.hostname = d.hostname ?? target.hostname;
      target.mdnsName = d.mdnsName ?? target.mdnsName;
      target.vendor = d.vendor ?? target.vendor;
      if (d.firstSeen.isBefore(target.firstSeen)) {
        target.firstSeen = d.firstSeen;
      }
      if (!d.lastSeen.isBefore(target.lastSeen)) {
        target.ipAddress = d.ipAddress;
        target.lastSeen = d.lastSeen;
        target.isOnline = d.isOnline;
        target.isGateway = d.isGateway;
      }
      target.sources.addAll(d.sources);
      for (final s in d.services) {
        target.services.removeWhere(
          (old) => old['type'] == s['type'] && old['name'] == s['name'],
        );
        target.services.add(s);
      }
    }
    devices.removeWhere((d) => matches.skip(1).contains(d));
    return target;
  }
}
