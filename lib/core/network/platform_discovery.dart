import 'package:flutter/services.dart';
import 'subnet.dart';

class NetworkInfo {
  NetworkInfo(this.raw);
  final Map<String, dynamic> raw;
  String get ip => raw['ip'] as String;
  String? get gateway => raw['gateway'] as String?;
  String? get ssid => raw['ssid'] as String?;
  String get interfaceName => raw['interface'] as String;
  String get token => raw['token'] as String;
  Ipv4Subnet get subnet => Ipv4Subnet(ip, raw['prefix'] as int);
  String get fingerprint =>
      '${raw['bssid'] ?? '${raw['boot'] ?? ''}:$token'}|${subnet.cidr}|${gateway ?? ''}';
}

class NetworkInfoService {
  static const channel = MethodChannel('network_guardian/discovery');
  Future<NetworkInfo> detect() async => NetworkInfo(
    Map<String, dynamic>.from(
      (await channel.invokeMapMethod<String, dynamic>('network'))!,
    ),
  );
  Future<bool> requestWifiName() async =>
      await channel.invokeMethod<bool>('permission') ?? false;
}

class AndroidDiscovery {
  static const events = EventChannel('network_guardian/events');
  Stream<Map<String, dynamic>> get stream =>
      events.receiveBroadcastStream().map((e) => Map<String, dynamic>.from(e));
  Future<void> start(NetworkInfo network, String runId) => NetworkInfoService
      .channel
      .invokeMethod('start', {'token': network.token, 'runId': runId});
  Future<void> cancel() => NetworkInfoService.channel.invokeMethod('cancel');
}
