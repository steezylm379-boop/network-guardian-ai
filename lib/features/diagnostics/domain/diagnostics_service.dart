import 'package:flutter/services.dart';

class PingResult {
  const PingResult({
    required this.sent,
    required this.received,
    required this.minMs,
    required this.avgMs,
    required this.maxMs,
    required this.method,
  });
  final int sent, received;
  final double? minMs, avgMs, maxMs;
  final String method;
  double get packetLossPercent => sent == 0 ? 100 : ((sent - received) / sent) * 100;

  factory PingResult.fromMap(Map<String, dynamic> map) => PingResult(
    sent: map['sent'] as int? ?? 0,
    received: map['received'] as int? ?? 0,
    minMs: (map['minMs'] as num?)?.toDouble(),
    avgMs: (map['avgMs'] as num?)?.toDouble(),
    maxMs: (map['maxMs'] as num?)?.toDouble(),
    method: map['method']?.toString() ?? 'unknown',
  );
}

class ServiceProbeResult {
  const ServiceProbeResult(this.port, this.name);
  final int port;
  final String name;
}

class NetworkStatus {
  const NetworkStatus({
    required this.validatedInternet,
    required this.internetCapability,
    required this.metered,
    required this.dnsServers,
    required this.interfaceName,
  });
  final bool validatedInternet;
  final bool internetCapability;
  final bool metered;
  final List<String> dnsServers;
  final String? interfaceName;

  factory NetworkStatus.fromMap(Map<String, dynamic> map) => NetworkStatus(
    validatedInternet: map['validatedInternet'] == true,
    internetCapability: map['internetCapability'] == true,
    metered: map['metered'] == true,
    dnsServers: List<String>.from(map['dnsServers'] ?? const []),
    interfaceName: map['interfaceName']?.toString(),
  );
}

abstract interface class DiagnosticsApi {
  Future<PingResult> ping(String ip, {int count = 4});
  Future<List<ServiceProbeResult>> probeServices(String ip);
  Future<void> wakeOnLan(String mac);
  Future<NetworkStatus> networkStatus();
}

class DiagnosticsService implements DiagnosticsApi {
  static const _channel = MethodChannel('network_guardian/diagnostics');

  @override
  Future<PingResult> ping(String ip, {int count = 4}) async {
    final result = await _channel.invokeMapMethod<String, dynamic>('ping', {
      'ip': ip,
      'count': count.clamp(1, 10),
    });
    if (result == null) throw Exception('Ping returned no result.');
    return PingResult.fromMap(Map<String, dynamic>.from(result));
  }

  @override
  Future<List<ServiceProbeResult>> probeServices(String ip) async {
    final raw = await _channel.invokeListMethod<dynamic>('probeServices', {'ip': ip}) ?? const [];
    return raw.map((item) {
      final map = Map<String, dynamic>.from(item as Map);
      return ServiceProbeResult(map['port'] as int, map['name'] as String);
    }).toList();
  }

  @override
  Future<void> wakeOnLan(String mac) =>
      _channel.invokeMethod<void>('wakeOnLan', {'mac': mac});

  @override
  Future<NetworkStatus> networkStatus() async {
    final result = await _channel.invokeMapMethod<String, dynamic>('networkStatus');
    if (result == null) throw Exception('Network status returned no result.');
    return NetworkStatus.fromMap(Map<String, dynamic>.from(result));
  }
}
