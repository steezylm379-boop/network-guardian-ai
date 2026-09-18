import 'package:flutter_test/flutter_test.dart';
import 'package:network_guardian_ai/features/devices/domain/device.dart';
import 'package:network_guardian_ai/features/intelligence/domain/device_learning_service.dart';
import 'package:network_guardian_ai/features/intelligence/domain/identity.dart';

void main() {
  test('local learning transfers correction only on strong identifier', () {
    final known = Device(id: 'old', networkId: 'n', ipAddress: '192.168.1.10');
    known.fingerprint.identify(StableIdentifier(
      deviceId: known.id,
      type: 'upnp_udn',
      value: 'uuid:device-1234',
      source: 'upnp',
      stability: 95,
    ));
    known.fingerprint.applyOverride(DeviceOverride(
      userName: 'Living room TV',
      category: DeviceCategory.television,
      confirmed: true,
    ));

    final incoming = Device(id: 'new', networkId: 'n', ipAddress: '192.168.1.77');
    incoming.fingerprint.identify(StableIdentifier(
      deviceId: incoming.id,
      type: 'upnp_udn',
      value: 'uuid:device-1234',
      source: 'upnp',
      stability: 95,
    ));

    final learned = const DeviceLearningService().learnedOverride(incoming, [known]);
    expect(learned?.userName, 'Living room TV');
  });

  test('local learning refuses hostname-only transfer', () {
    final known = Device(id: 'old', networkId: 'n', ipAddress: '192.168.1.10');
    known.fingerprint.applyOverride(DeviceOverride(userName: 'My PC'));
    final incoming = Device(id: 'new', networkId: 'n', ipAddress: '192.168.1.77');
    expect(const DeviceLearningService().learnedOverride(incoming, [known]), isNull);
  });
}
