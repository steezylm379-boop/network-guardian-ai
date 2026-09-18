import 'package:flutter_test/flutter_test.dart';
import 'package:network_guardian_ai/features/devices/domain/device.dart';
import 'package:network_guardian_ai/features/diagnostics/domain/diagnostics_service.dart';
import 'package:network_guardian_ai/features/guardian/domain/guardian_models.dart';
import 'package:network_guardian_ai/features/guardian/domain/network_doctor.dart';

class FakeDiagnostics implements DiagnosticsApi {
  FakeDiagnostics({required this.validated, required this.pingResult});
  final bool validated;
  final PingResult pingResult;

  @override
  Future<NetworkStatus> networkStatus() async => NetworkStatus(
    validatedInternet: validated,
    internetCapability: true,
    metered: false,
    dnsServers: const ['192.168.1.1'],
    interfaceName: 'wlan0',
  );

  @override
  Future<PingResult> ping(String ip, {int count = 4}) async => pingResult;

  @override
  Future<List<ServiceProbeResult>> probeServices(String ip) async => const [];

  @override
  Future<void> wakeOnLan(String mac) async {}
}

void main() {
  NetworkSnapshot snapshot() => NetworkSnapshot(
    networkId: 'n',
    networkName: 'Office',
    gateway: '192.168.1.1',
    localIp: '192.168.1.20',
    cidr: '192.168.1.0/24',
    devices: [Device(networkId: 'n', ipAddress: '192.168.1.1', isGateway: true)],
    lastCompletedScan: DateTime.now(),
  );

  test('doctor reports healthy when gateway and Android validation are healthy', () async {
    final service = NetworkDoctorService(FakeDiagnostics(
      validated: true,
      pingResult: const PingResult(sent: 4, received: 4, minMs: 2, avgMs: 4, maxMs: 7, method: 'ICMP'),
    ));
    final report = await service.run(snapshot());
    expect(report.status, DoctorStatus.healthy);
    expect(report.checks.where((e) => e.id == 'gateway').single.status, DoctorStatus.healthy);
  });

  test('doctor points upstream when gateway works but Internet is not validated', () async {
    final service = NetworkDoctorService(FakeDiagnostics(
      validated: false,
      pingResult: const PingResult(sent: 4, received: 4, minMs: 2, avgMs: 4, maxMs: 7, method: 'ICMP'),
    ));
    final report = await service.run(snapshot());
    expect(report.status, DoctorStatus.warning);
    expect(report.headline.toLowerCase(), contains('internet'));
  });
}
