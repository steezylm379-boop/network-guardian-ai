import 'package:flutter_test/flutter_test.dart';
import 'package:network_guardian_ai/features/devices/domain/device.dart';
import 'package:network_guardian_ai/features/network_scan/domain/device_merge_service.dart';

void main() {
  test('shared hostnames cannot collapse two current IP observations', () {
    final m = DeviceMergeService(scanStarted: DateTime.now());
    m.merge(
      Device(
        networkId: 'home',
        ipAddress: '10.0.0.2',
        hostname: 'android.local',
      ),
    );
    m.merge(
      Device(
        networkId: 'home',
        ipAddress: '10.0.0.3',
        hostname: 'android.local',
      ),
    );
    expect(m.devices.length, 2);
  });
  test('a unique historical hostname may follow a DHCP change', () {
    final m = DeviceMergeService(scanStarted: DateTime.now());
    final old = Device(
      networkId: 'home',
      ipAddress: '10.0.0.2',
      hostname: 'printer.local',
      lastSeen: DateTime(2020),
    );
    m.devices.add(old);
    m.merge(
      Device(
        networkId: 'home',
        ipAddress: '10.0.0.3',
        hostname: 'printer.local',
      ),
    );
    expect(m.devices.single.id, old.id);
    expect(m.devices.single.ipAddress, '10.0.0.3');
  });
  Device device(
    String ip, {
    String? mac,
    String network = 'home',
    String? name,
  }) => Device(
    networkId: network,
    ipAddress: ip,
    macAddress: mac,
    hostname: name,
  );
  test('IP observation gains MAC and hostname without changing record id', () {
    final m = DeviceMergeService();
    final original = m.merge(device('192.168.1.20'));
    m.merge(device('192.168.1.20', mac: 'a4:12:34:56:78:90'));
    m.merge(device('192.168.1.20', name: 'tv.local'));
    expect(m.devices.length, 1);
    expect(m.devices.single.id, original.id);
    expect(m.devices.single.macAddress, 'A4:12:34:56:78:90');
    expect(m.devices.single.hostname, 'tv.local');
  });
  test(
    'MAC follows DHCP changes; reused IP with different MAC stays separate',
    () {
      final m = DeviceMergeService();
      m.merge(device('192.168.1.20', mac: 'A4:12:34:56:78:90'));
      m.merge(device('192.168.1.21', mac: 'A4:12:34:56:78:90'));
      expect(m.devices.single.ipAddress, '192.168.1.21');
      m.merge(device('192.168.1.21', mac: 'B4:12:34:56:78:90'));
      expect(m.devices.length, 2);
    },
  );
  test('network identities are isolated', () {
    final m = DeviceMergeService();
    m.merge(device('10.0.0.1'));
    m.merge(device('10.0.0.1', network: 'office'));
    expect(m.devices.length, 2);
  });
  test('MAC placeholder and multicast values are rejected', () {
    expect(DeviceMergeService.normalizeMac('02:00:00:00:00:00'), isNull);
    expect(DeviceMergeService.normalizeMac('FF:FF:FF:FF:FF:FF'), isNull);
  });
}
