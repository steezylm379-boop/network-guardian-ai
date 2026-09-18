import 'package:flutter_test/flutter_test.dart';
import 'package:network_guardian_ai/features/devices/domain/device.dart';
import 'package:network_guardian_ai/features/devices/domain/device_event.dart';

void main() {
  test('trust state and events survive device JSON round-trip', () {
    final d = Device(
      id: 'd1',
      networkId: 'n1',
      ipAddress: '192.168.1.20',
      trustState: DeviceTrustState.trusted,
      events: [
        DeviceEvent(
          type: DeviceEventType.ipChanged,
          message: 'IP changed',
          scanId: 's1',
        ),
      ],
    );
    final copy = Device.fromJson(d.toJson());
    expect(copy.trustState, DeviceTrustState.trusted);
    expect(copy.events.single.type, DeviceEventType.ipChanged);
    expect(copy.events.single.scanId, 's1');
  });
}
