import 'package:flutter_test/flutter_test.dart';
import 'package:network_guardian_ai/features/devices/domain/device.dart';
import 'package:network_guardian_ai/features/guardian/domain/guardian_models.dart';
import 'package:network_guardian_ai/features/guardian/domain/network_insight_engine.dart';

void main() {
  test('insight engine flags unreviewed ownership without calling it malicious', () {
    final device = Device(networkId: 'n', ipAddress: '192.168.1.2');
    final snapshot = NetworkSnapshot(
      networkId: 'n',
      networkName: 'Office',
      gateway: '192.168.1.1',
      localIp: '192.168.1.10',
      cidr: '192.168.1.0/24',
      devices: [device],
      lastCompletedScan: DateTime.now(),
    );
    final insights = const NetworkInsightEngine().evaluate(snapshot);
    final ownership = insights.firstWhere((e) => e.id == 'unknown-devices');
    expect(ownership.body.toLowerCase(), isNot(contains('malicious')));
    expect(ownership.body.toLowerCase(), contains('not a threat'));
  });
}
