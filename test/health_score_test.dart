import 'package:flutter_test/flutter_test.dart';
import 'package:network_guardian_ai/features/devices/domain/device.dart';
import 'package:network_guardian_ai/features/network_health/domain/health_score.dart';
import 'package:network_guardian_ai/features/intelligence/domain/identity.dart';

void main() {
  test('health score is transparent and bounded', () {
    final gateway = Device(networkId: 'n', ipAddress: '192.168.1.1', isGateway: true);
    gateway.fingerprint.classification = const DeviceClassification(
      category: DeviceCategory.router,
      score: 90,
      level: ConfidenceLevel.high,
    );
    final score = const NetworkHealthCalculator().evaluate(
      hasNetwork: true,
      gatewayConfigured: true,
      devices: [gateway],
    );
    expect(score.score, inInclusiveRange(0, 100));
    expect(score.components.length, 4);
    expect(score.label, isNotEmpty);
  });

  test('no Wi-Fi produces a low score', () {
    final score = const NetworkHealthCalculator().evaluate(
      hasNetwork: false,
      gatewayConfigured: false,
      devices: const [],
    );
    expect(score.score, lessThan(50));
  });
}
