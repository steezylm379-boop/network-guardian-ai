import 'package:flutter_test/flutter_test.dart';
import 'package:network_guardian_ai/features/devices/domain/device.dart';
import 'package:network_guardian_ai/features/guardian/domain/ai_gateway.dart';
import 'package:network_guardian_ai/features/guardian/domain/guardian_models.dart';

void main() {
  test('enterprise AI privacy policy redacts raw IP and MAC by default', () {
    final snapshot = NetworkSnapshot(
      networkId: 'n',
      networkName: 'Office',
      gateway: '192.168.1.1',
      localIp: '192.168.1.20',
      cidr: '192.168.1.0/24',
      devices: [Device(networkId: 'n', ipAddress: '192.168.1.10', macAddress: '00:11:22:33:44:55')],
      lastCompletedScan: null,
    );
    final sanitized = const AiPrivacyPolicy().sanitize(snapshot);
    final device = (sanitized['devices'] as List).single as Map<String, dynamic>;
    expect(device['ip'], isNull);
    expect(device['mac'], isNull);
    expect(device['id'], 'device_1');
  });
}
