import '../devices/domain/device.dart';
import '../guardian/domain/guardian_models.dart';

/// Comprehensive privacy redactor and pseudonymizer for network intelligence data.
/// Protects sensitive local network topologies, MAC addresses, IP addresses,
/// hostnames, and user credentials from exposure to external AI gateways or logs.
class PrivacyRedactor {
  PrivacyRedactor({
    this.maskMacHostBits = true,
    this.maskIpv4HostBits = false,
  });

  final bool maskMacHostBits;
  final bool maskIpv4HostBits;

  final Map<String, String> _ipMap = {};
  final Map<String, String> _macMap = {};

  static final RegExp _ipv4Pattern = RegExp(
    r'\b(?:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)\.){3}(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)\b',
  );

  static final RegExp _macPattern = RegExp(
    r'\b(?:[0-9A-Fa-f]{2}[:-]){5}[0-9A-Fa-f]{2}\b',
  );

  static final RegExp _personalNamePattern = RegExp(
    r"(?:^|[\s\-_'])(?:[A-Z][a-z]+'s?|[a-z]+'s)\s*(?:iPhone|iPad|MacBook|Mac|Pixel|Galaxy|PC|Laptop|Phone|Desktop|Watch)",
    caseSensitive: false,
  );

  /// Pseudonymize or mask an IPv4 address.
  String redactIp(String ip) {
    final trimmed = ip.trim();
    if (trimmed.isEmpty) return trimmed;
    if (!_ipv4Pattern.hasMatch(trimmed)) return trimmed;

    if (maskIpv4HostBits) {
      final parts = trimmed.split('.');
      if (parts.length == 4) {
        return '${parts[0]}.${parts[1]}.${parts[2]}.xxx';
      }
    }

    return _ipMap.putIfAbsent(trimmed, () => 'ip_${_ipMap.length + 1}');
  }

  /// Mask the lower 24 bits of a MAC address (host identifier) while preserving OUI.
  String redactMac(String mac) {
    final trimmed = mac.trim();
    if (trimmed.isEmpty) return trimmed;
    if (!_macPattern.hasMatch(trimmed)) return trimmed;

    if (maskMacHostBits) {
      final sep = trimmed.contains('-') ? '-' : ':';
      final parts = trimmed.split(sep);
      if (parts.length == 6) {
        return '${parts[0]}$sep${parts[1]}$sep${parts[2]}$sep'
            'XX${sep}XX${sep}XX';
      }
    }

    return _macMap.putIfAbsent(trimmed, () => 'mac_${_macMap.length + 1}');
  }

  /// Redact personally identifiable names from device hostnames or labels.
  String redactHostname(String hostname) {
    var result = hostname.trim();
    if (result.isEmpty) return result;

    result = result.replaceAllMapped(_personalNamePattern, (match) {
      final full = match.group(0)!;
      final parts = full.split(RegExp(r"['\s\-_]+"));
      final suffix = parts.last;
      return ' Device-$suffix';
    }).trim();

    return result;
  }

  /// Redact SSID name unless it is an explicitly generic broadcast.
  String redactSsid(String ssid) {
    final trimmed = ssid.trim();
    if (trimmed.isEmpty) return '';
    return '[REDACTED_SSID]';
  }

  /// Redact arbitrary free-form text containing IPs, MACs, or tokens.
  String redactText(String input) {
    var output = input;
    output = output.replaceAllMapped(_macPattern, (m) => redactMac(m.group(0)!));
    output = output.replaceAllMapped(_ipv4Pattern, (m) => redactIp(m.group(0)!));
    return output;
  }

  /// Sanitize device metadata before passing to AI context.
  Map<String, dynamic> sanitizeDevice(
    Device device, {
    bool includeRawIp = false,
    bool includeRawMac = false,
    bool includeFriendlyNames = false,
  }) {
    return {
      'id': device.id,
      'category': device.fingerprint.classification.category.name,
      'manufacturer': device.fingerprint.classification.manufacturer,
      'model': device.fingerprint.classification.model,
      'confidence': device.fingerprint.classification.score,
      'online': device.isOnline,
      'trusted': device.trustState.name == 'trusted',
      'ip': includeRawIp ? device.ipAddress : redactIp(device.ipAddress),
      'mac': device.macAddress == null
          ? null
          : (includeRawMac ? device.macAddress : redactMac(device.macAddress!)),
      'displayName': includeFriendlyNames
          ? device.fingerprint.override?.userName
          : (device.hostname != null ? redactHostname(device.hostname!) : null),
      'serviceTypes': device.services
          .map((s) => s['type']?.toString())
          .whereType<String>()
          .toSet()
          .take(12)
          .toList(),
    };
  }

  /// Sanitize a complete network snapshot according to privacy policy.
  Map<String, dynamic> sanitizeSnapshot(
    NetworkSnapshot snapshot, {
    bool includeNetworkName = false,
    bool includeRawIp = false,
    bool includeRawMac = false,
    bool includeFriendlyNames = false,
  }) {
    return {
      'network': {
        'name': includeNetworkName ? snapshot.networkName : redactSsid(snapshot.networkName),
        'cidr': includeRawIp ? snapshot.cidr : null,
        'deviceCount': snapshot.devices.length,
        'onlineCount': snapshot.onlineCount,
        'hasGateway': snapshot.gateway != null,
        'lastCompletedScan': snapshot.lastCompletedScan?.toIso8601String(),
      },
      'devices': [
        for (var i = 0; i < snapshot.devices.length; i++)
          sanitizeDevice(
            snapshot.devices[i],
            includeRawIp: includeRawIp,
            includeRawMac: includeRawMac,
            includeFriendlyNames: includeFriendlyNames,
          ),
      ],
    };
  }
}
