import 'package:flutter_test/flutter_test.dart';
import 'package:network_guardian_ai/features/devices/domain/device.dart';
import 'package:network_guardian_ai/features/guardian/domain/guardian_models.dart';
import 'package:network_guardian_ai/features/guardian/domain/local_network_assistant.dart';
import 'package:network_guardian_ai/features/intelligence/domain/identity.dart';

void main() {
  const assistant = LocalNetworkAssistant();

  test('overview answer is grounded in snapshot counts', () {
    final trusted = Device(networkId: 'n', ipAddress: '192.168.1.10', trustState: DeviceTrustState.trusted);
    final unknown = Device(networkId: 'n', ipAddress: '192.168.1.11');
    final snapshot = NetworkSnapshot(
      networkId: 'n',
      networkName: 'Office',
      gateway: '192.168.1.1',
      localIp: '192.168.1.20',
      cidr: '192.168.1.0/24',
      devices: [trusted, unknown],
      lastCompletedScan: DateTime.now(),
    );
    final answer = assistant.answer('What is connected right now?', snapshot);
    expect(answer.intent, 'overview');
    expect(answer.text, contains('2 recorded devices'));
    expect(answer.evidence, isNotEmpty);
  });

  test('camera answer preserves uncertainty language', () {
    final camera = Device(networkId: 'n', ipAddress: '192.168.1.40');
    camera.fingerprint.classification = const DeviceClassification(
      category: DeviceCategory.camera,
      manufacturer: 'Example Camera Co',
      score: 82,
      level: ConfidenceLevel.high,
    );
    final snapshot = NetworkSnapshot(
      networkId: 'n',
      networkName: 'Office',
      gateway: '192.168.1.1',
      localIp: '192.168.1.20',
      cidr: '192.168.1.0/24',
      devices: [camera],
      lastCompletedScan: DateTime.now(),
    );
    final answer = assistant.answer('Are there hidden cameras?', snapshot);
    expect(answer.intent, 'camera_profiles');
    expect(answer.text.toLowerCase(), contains('not proof'));
  });

  test('bandwidth question refuses unsupported telemetry', () {
    final snapshot = NetworkSnapshot(
      networkId: 'n',
      networkName: 'Office',
      gateway: '192.168.1.1',
      localIp: '192.168.1.20',
      cidr: '192.168.1.0/24',
      devices: const [],
      lastCompletedScan: null,
    );
    final answer = assistant.answer('Which device is using the most bandwidth?', snapshot);
    expect(answer.intent, 'bandwidth');
    expect(answer.text, contains('not measured'));
    expect(answer.confidence, 100);
  });
}
