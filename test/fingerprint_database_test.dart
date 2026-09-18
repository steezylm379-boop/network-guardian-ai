import 'package:flutter_test/flutter_test.dart';
import 'package:network_guardian_ai/features/intelligence/domain/classifier.dart';
import 'package:network_guardian_ai/features/intelligence/domain/identity.dart';

void main() {
  test('data-driven rules classify a printer from mDNS', () {
    final fp = DeviceFingerprint('d1');
    fp.addEvidence(IdentityEvidence(
      deviceId: 'd1',
      source: 'mdns',
      key: 'service',
      value: '_ipp._tcp',
      weight: 60,
    ));
    final result = DeviceClassifier().evaluate(fp);
    expect(result.category, DeviceCategory.printer);
    expect(result.score, greaterThanOrEqualTo(55));
  });

  test('taxonomy contains business and infrastructure categories', () {
    expect(DeviceCategory.values, contains(DeviceCategory.posTerminal));
    expect(DeviceCategory.values, contains(DeviceCategory.voipPhone));
    expect(DeviceCategory.values, contains(DeviceCategory.networkSwitch));
    expect(DeviceCategory.values, contains(DeviceCategory.nvr));
    expect(DeviceCategory.values, contains(DeviceCategory.server));
  });
}
