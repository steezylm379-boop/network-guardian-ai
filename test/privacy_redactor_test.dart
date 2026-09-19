import 'package:flutter_test/flutter_test.dart';
import 'package:network_guardian_ai/features/devices/domain/device.dart';
import 'package:network_guardian_ai/features/guardian/domain/guardian_models.dart';
import 'package:network_guardian_ai/features/intelligence/domain/identity.dart';
import 'package:network_guardian_ai/features/privacy/redactor.dart';

void main() {
  group('PrivacyRedactor unit tests', () {
    test('redacts and pseudonymizes IPv4 addresses deterministically', () {
      final redactor = PrivacyRedactor();
      final ip1 = redactor.redactIp('192.168.1.50');
      final ip2 = redactor.redactIp('192.168.1.50');
      final ip3 = redactor.redactIp('10.0.0.1');

      expect(ip1, 'ip_1');
      expect(ip2, 'ip_1'); // deterministic mapping
      expect(ip3, 'ip_2');
    });

    test('masks host bits of MAC addresses preserving OUI prefix', () {
      final redactor = PrivacyRedactor(maskMacHostBits: true);
      final masked = redactor.redactMac('00:1A:2B:3C:4D:5E');
      expect(masked, '00:1A:2B:XX:XX:XX');

      final maskedDash = redactor.redactMac('00-1A-2B-3C-4D-5E');
      expect(maskedDash, '00-1A-2B-XX-XX-XX');
    });

    test('redacts personally identifiable hostnames', () {
      final redactor = PrivacyRedactor();
      expect(redactor.redactHostname("Alice's iPhone"), 'Device-iPhone');
      expect(redactor.redactHostname("Bob's MacBook"), 'Device-MacBook');
      expect(redactor.redactHostname("Generic-Printer"), 'Generic-Printer');
    });

    test('redacts SSIDs to prevent location tracking', () {
      final redactor = PrivacyRedactor();
      expect(redactor.redactSsid('MyHomeWifi_5G'), '[REDACTED_SSID]');
      expect(redactor.redactSsid(''), '');
    });

    test('redacts arbitrary text containing sensitive network info', () {
      final redactor = PrivacyRedactor();
      final text = 'Device 192.168.1.1 with MAC 00:11:22:33:44:55 is active.';
      final redacted = redactor.redactText(text);
      expect(redacted, contains('ip_1'));
      expect(redacted, contains('00:11:22:XX:XX:XX'));
      expect(redacted, isNot(contains('192.168.1.1')));
      expect(redacted, isNot(contains('33:44:55')));
    });

    test('sanitizes full network snapshots safely', () {
      final redactor = PrivacyRedactor();
      final device = Device(
        networkId: 'net_1',
        ipAddress: '192.168.1.42',
        macAddress: '00:11:22:AA:BB:CC',
        hostname: "Charlie's iPad",
      );
      device.fingerprint.classification = const DeviceClassification(
        category: DeviceCategory.tablet,
        score: 85,
        level: ConfidenceLevel.high,
      );

      final snapshot = NetworkSnapshot(
        networkId: 'net_1',
        networkName: 'SecretHQ_Wifi',
        gateway: '192.168.1.1',
        localIp: '192.168.1.42',
        cidr: '192.168.1.0/24',
        devices: [device],
        lastCompletedScan: DateTime.now(),
      );

      final sanitized = redactor.sanitizeSnapshot(snapshot);
      expect(sanitized['network']['name'], '[REDACTED_SSID]');
      expect(sanitized['network']['cidr'], isNull);

      final d = (sanitized['devices'] as List).single as Map<String, dynamic>;
      expect(d['ip'], 'ip_1');
      expect(d['mac'], '00:11:22:XX:XX:XX');
      expect(d['displayName'], 'Device-iPad');
    });
  });
}
