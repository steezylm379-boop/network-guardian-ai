import 'package:flutter_test/flutter_test.dart';
import 'package:network_guardian_ai/features/devices/domain/device.dart';
import 'package:network_guardian_ai/features/intelligence/domain/classifier.dart';
import 'package:network_guardian_ai/features/intelligence/domain/evidence_collector.dart';
import 'package:network_guardian_ai/features/intelligence/domain/identity.dart';
import 'package:network_guardian_ai/features/intelligence/domain/identity_reconciler.dart';

void main() {
  final collector = EvidenceCollector();
  final classifier = DeviceClassifier();

  Device createDevice({
    String ip = '192.168.1.10',
    String? mac,
    String? udn,
    String? hostname,
  }) {
    final d = Device(
      networkId: 'test_net',
      ipAddress: ip,
      macAddress: mac,
      hostname: hostname,
    );
    collector.collect(d, {
      if (udn != null) 'upnp': {'UDN': udn},
    }, 'scan');
    return d;
  }

  group('Identity Reconciliation Hardening', () {
    test('conflicting strong identifiers prevent accidental merges', () {
      final reconciler = IdentityReconciler();
      final devA = createDevice(ip: '192.168.1.10', udn: 'uuid:alpha', mac: '00:11:22:33:44:55');
      final devB = createDevice(ip: '192.168.1.10', udn: 'uuid:beta', mac: 'AA:BB:CC:DD:EE:FF');

      reconciler.devices.add(devA);
      final merged = reconciler.merge(devB);

      expect(reconciler.devices.length, 2);
      expect(merged.id, isNot(devA.id));
      expect(reconciler.conflict(devA, devB), isTrue);
    });

    test('multiple strong matches require review rather than arbitrary merge', () {
      final reconciler = IdentityReconciler();
      final d1 = createDevice(ip: '192.168.1.101', mac: 'A4:BB:CC:00:11:22');
      final d2 = createDevice(ip: '192.168.1.102', mac: 'A4:BB:CC:00:11:22');
      reconciler.devices.addAll([d1, d2]);

      final incoming = createDevice(ip: '192.168.1.103', mac: 'A4:BB:CC:00:11:22');
      final result = reconciler.merge(incoming);

      expect(reconciler.devices.length, 3);
      expect(d1.fingerprint.possibleSameDevices, contains(incoming.id));
      expect(d2.fingerprint.possibleSameDevices, contains(incoming.id));
      expect(result.id, incoming.id);
    });

    test('classifier deterministically handles contradictory category evidence', () {
      final d = createDevice();
      collector.collect(d, {
        'upnp': {
          'deviceType': 'urn:schemas-upnp-org:device:MediaServer:1',
          'friendlyName': 'Living Room NVR',
        },
      }, 'scan');

      final c = classifier.evaluate(d.fingerprint);
      expect(c.score, inInclusiveRange(0, 100));
      expect(c.categoryCandidates, isNotEmpty);
      expect(c.conflicts, isNotNull);
    });
  });
}
