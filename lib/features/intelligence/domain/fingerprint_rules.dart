import 'identity.dart';

class FingerprintRule {
  const FingerprintRule({
    required this.id,
    required this.source,
    required this.key,
    this.contains,
    this.regex,
    this.category,
    this.manufacturer,
    this.modelFromEvidence = false,
    required this.weight,
  });
  final String id, source, key;
  final String? contains;
  final RegExp? regex;
  final DeviceCategory? category;
  final String? manufacturer;
  final bool modelFromEvidence;
  final int weight;

  bool matches(IdentityEvidence e) {
    if (e.source != source || e.key != key) return false;
    final value = e.normalizedValue;
    if (contains != null && !value.contains(contains!.toLowerCase())) return false;
    if (regex != null && !regex!.hasMatch(value)) return false;
    return true;
  }
}

/// Data-driven offline rules. The classifier consumes this collection rather
/// than burying device signatures inside UI code.
class DeviceFingerprintDatabase {
  const DeviceFingerprintDatabase();

  List<FingerprintRule> get rules => [
    const FingerprintRule(id: 'gateway', source: 'network', key: 'gateway', category: DeviceCategory.router, weight: 90),
    const FingerprintRule(id: 'upnp-router', source: 'upnp', key: 'deviceType', contains: 'internetgatewaydevice', category: DeviceCategory.router, weight: 90),
    const FingerprintRule(id: 'upnp-printer', source: 'upnp', key: 'deviceType', contains: 'printer', category: DeviceCategory.printer, weight: 90),
    const FingerprintRule(id: 'upnp-camera', source: 'upnp', key: 'deviceType', contains: 'digitalsecuritycamera', category: DeviceCategory.camera, weight: 90),
    const FingerprintRule(id: 'upnp-tv', source: 'upnp', key: 'deviceType', contains: 'tvdevice', category: DeviceCategory.television, weight: 90),
    const FingerprintRule(id: 'upnp-renderer', source: 'upnp', key: 'deviceType', contains: 'mediarenderer', category: DeviceCategory.streamingDevice, weight: 60),
    const FingerprintRule(id: 'upnp-media-server', source: 'upnp', key: 'deviceType', contains: 'mediaserver', category: DeviceCategory.mediaServer, weight: 65),
    const FingerprintRule(id: 'mdns-ipp', source: 'mdns', key: 'service', contains: '_ipp.', category: DeviceCategory.printer, weight: 75),
    const FingerprintRule(id: 'mdns-ipps', source: 'mdns', key: 'service', contains: '_ipps.', category: DeviceCategory.printer, weight: 75),
    const FingerprintRule(id: 'mdns-printer', source: 'mdns', key: 'service', contains: '_printer.', category: DeviceCategory.printer, weight: 75),
    const FingerprintRule(id: 'mdns-cast', source: 'mdns', key: 'service', contains: '_googlecast.', category: DeviceCategory.streamingDevice, weight: 65),
    const FingerprintRule(id: 'mdns-airplay', source: 'mdns', key: 'service', contains: '_airplay.', category: DeviceCategory.streamingDevice, weight: 50),
    const FingerprintRule(id: 'mdns-workstation', source: 'mdns', key: 'service', contains: '_workstation.', category: DeviceCategory.computer, weight: 60),
    const FingerprintRule(id: 'port-ipp', source: 'port', key: 'tcp', contains: '631', category: DeviceCategory.printer, weight: 40),
    const FingerprintRule(id: 'port-jetdirect', source: 'port', key: 'tcp', contains: '9100', category: DeviceCategory.printer, weight: 40),
    const FingerprintRule(id: 'port-rtsp', source: 'port', key: 'tcp', contains: '554', category: DeviceCategory.camera, weight: 25),
    const FingerprintRule(id: 'port-smb', source: 'port', key: 'tcp', contains: '445', category: DeviceCategory.computer, weight: 30),
    const FingerprintRule(id: 'port-cast-8008', source: 'port', key: 'tcp', contains: '8008', category: DeviceCategory.streamingDevice, weight: 30),
    const FingerprintRule(id: 'port-cast-8009', source: 'port', key: 'tcp', contains: '8009', category: DeviceCategory.streamingDevice, weight: 30),
    const FingerprintRule(id: 'host-printer', source: 'dns', key: 'hostname', contains: 'printer', category: DeviceCategory.printer, weight: 25),
    const FingerprintRule(id: 'host-iphone', source: 'dns', key: 'hostname', contains: 'iphone', category: DeviceCategory.phone, weight: 25),
    const FingerprintRule(id: 'host-ipad', source: 'dns', key: 'hostname', contains: 'ipad', category: DeviceCategory.tablet, weight: 25),
    const FingerprintRule(id: 'host-camera', source: 'dns', key: 'hostname', contains: 'camera', category: DeviceCategory.camera, weight: 25),
    const FingerprintRule(id: 'host-playstation', source: 'dns', key: 'hostname', contains: 'playstation', category: DeviceCategory.gameConsole, weight: 30),
    const FingerprintRule(id: 'host-nvr', source: 'dns', key: 'hostname', contains: 'nvr', category: DeviceCategory.nvr, weight: 35),
    const FingerprintRule(id: 'host-nas', source: 'dns', key: 'hostname', contains: 'nas', category: DeviceCategory.nas, weight: 30),
    const FingerprintRule(id: 'host-server', source: 'dns', key: 'hostname', contains: 'server', category: DeviceCategory.server, weight: 25),
    const FingerprintRule(id: 'host-pos', source: 'dns', key: 'hostname', contains: 'pos', category: DeviceCategory.posTerminal, weight: 25),
  ];
}
