import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_guardian_ai/features/devices/domain/device.dart';
import 'package:network_guardian_ai/features/intelligence/domain/identity.dart';
import 'package:network_guardian_ai/features/intelligence/domain/classifier.dart';
import 'package:network_guardian_ai/features/intelligence/domain/evidence_collector.dart';
import 'package:network_guardian_ai/features/intelligence/domain/identity_reconciler.dart';

void main() {
  final collector = EvidenceCollector(), classifier = DeviceClassifier();
  Device sample({
    String ip = '192.168.1.2',
    String? mac,
    String? udn,
    String? hostname,
  }) {
    final d = Device(
      networkId: 'n',
      ipAddress: ip,
      macAddress: mac,
      hostname: hostname,
    );
    collector.collect(d, {
      if (udn != null) 'upnp': {'UDN': udn},
    }, 'scan');
    return d;
  }

  test('identifier normalization and global versus private MAC', () {
    expect(
      StableIdentifier.normalize('mac', 'a4-b2-c3-d4-e5-f6'),
      'A4:B2:C3:D4:E5:F6',
    );
    expect(StableIdentifier.normalize('mac', '01:00:00:00:00:01'), isNull);
    expect(StableIdentifier.normalize('mac', '02:00:00:00:00:00'), isNull);
    expect(
      StableIdentifier.normalize('upnp_udn', ' UUID:Device-123::root '),
      'uuid:device-123',
    );
    expect(StableIdentifier.isPrivateMac('AA:BB:CC:DD:EE:FF'), isTrue);
    expect(StableIdentifier.isPrivateMac('A4:BB:CC:DD:EE:FF'), isFalse);
    final d = sample(mac: 'AA:BB:CC:DD:EE:FF')..vendor = 'False vendor';
    collector.collect(d, {}, 'second');
    expect(d.fingerprint.identifiers.single.stability, 35);
    expect(d.fingerprint.evidence.where((e) => e.source == 'oui'), isEmpty);
  });
  test(
    'duplicate observations retain first seen and count scans, not fields',
    () {
      final d = sample();
      collector.collect(d, {'openPort': 9100}, 'one');
      collector.collect(d, {'openPort': 9100}, 'one');
      var port = d.fingerprint.evidence.singleWhere((e) => e.source == 'port');
      final first = port.firstSeen;
      expect(port.observationCount, 1);
      collector.collect(d, {'openPort': 9100}, 'two');
      port = d.fingerprint.evidence.singleWhere((e) => e.source == 'port');
      expect(port.observationCount, 2);
      expect(port.firstSeen, first);
    },
  );
  test('IP and generic HTTP cannot imply a model or category', () {
    final d = sample();
    collector.collect(d, {'openPort': 80}, 'scan');
    final c = classifier.evaluate(d.fingerprint);
    expect(c.category, DeviceCategory.unknown);
    expect(c.model, isNull);
    expect(c.score, 0);
  });
  test(
    'OUI alone never selects phone icon, model, or confirmed confidence',
    () {
      final d = sample(mac: 'A4:BB:CC:DD:EE:FF')..vendor = 'Apple';
      collector.collect(d, {}, 'scan');
      final c = classifier.evaluate(d.fingerprint);
      expect(c.manufacturer, 'Apple');
      expect(c.category, DeviceCategory.unknown);
      expect(c.model, isNull);
      expect(c.level, ConfidenceLevel.medium);
    },
  );
  test('UPnP strong category/model outweighs weak hostname and ports', () {
    final d = sample(hostname: 'printer.local');
    collector.collect(d, {
      'upnp': {
        'deviceType': 'urn:schemas-upnp-org:device:TVDevice:1',
        'modelName': 'Reported TV',
        'manufacturer': 'Sony',
      },
      'openPort': 9100,
    }, 'scan');
    final c = classifier.evaluate(d.fingerprint);
    expect(c.category, DeviceCategory.television);
    expect(c.model, 'Reported TV');
    expect(c.level, ConfidenceLevel.high);
  });
  test(
    'contradictory manufacturer evidence retained and confidence reduced',
    () {
      final d = sample(mac: 'A4:BB:CC:DD:EE:FF')
        ..vendor = 'Samsung Electronics';
      collector.collect(d, {
        'upnp': {'manufacturer': 'Sony'},
      }, 'scan');
      final c = classifier.evaluate(d.fingerprint);
      expect(c.manufacturer, 'Sony');
      expect(c.manufacturerCandidates.keys, containsAll(['Samsung', 'Sony']));
      expect(c.conflicts, isNotEmpty);
      expect(c.level, ConfidenceLevel.low);
    },
  );
  test('mDNS model is scoped; raw invalid TXT is retained safely', () {
    final d = sample();
    collector.collect(d, {
      'service': {
        'type': '_http._tcp.',
        'attributes': {
          'model': base64Encode(utf8.encode('Not a model')),
          'invalid': '***',
        },
      },
    }, 'scan');
    expect(classifier.evaluate(d.fingerprint).model, isNull);
    collector.collect(d, {
      'service': {
        'type': '_googlecast._tcp.',
        'attributes': {
          'md': base64Encode(utf8.encode('Reported Cast')),
          'id': base64Encode(utf8.encode('0123456789abcdef')),
        },
      },
    }, 'scan');
    final c = classifier.evaluate(d.fingerprint);
    expect(c.model, 'Reported Cast');
    expect(c.category, DeviceCategory.streamingDevice);
    expect(
      d.fingerprint.evidence.where((e) => e.source == 'mdns_raw').length,
      4,
    );
    expect(
      d.fingerprint.identifiers.any((i) => i.type == 'protocol_identifier'),
      isTrue,
    );
  });
  test(
    'user confirmation persists over new evidence and clear returns to automatic',
    () {
      final d = sample();
      collector.collect(d, {'openPort': 9100}, 'scan');
      d.fingerprint.override = DeviceOverride(
        userName: 'My camera',
        category: DeviceCategory.camera,
        model: 'Manual model',
        confirmed: true,
      );
      expect(
        classifier.evaluate(d.fingerprint).level,
        ConfidenceLevel.confirmed,
      );
      collector.collect(d, {
        'service': {'type': '_ipp._tcp'},
      }, 'next');
      expect(
        classifier.evaluate(d.fingerprint).category,
        DeviceCategory.camera,
      );
      final reopened = Device.fromJson(d.toJson());
      expect(reopened.name, 'My camera');
      reopened.fingerprint.override = null;
      expect(
        classifier.evaluate(reopened.fingerprint).category,
        DeviceCategory.printer,
      );
    },
  );
  test('expired evidence causes reevaluation without erasing history', () {
    final d = sample();
    final past = DateTime(2020);
    collector.collect(d, {'openPort': 9100}, 'past', observedAt: past);
    expect(
      classifier.evaluate(d.fingerprint, at: past).category,
      DeviceCategory.printer,
    );
    expect(
      classifier
          .evaluate(d.fingerprint, at: past.add(const Duration(days: 2)))
          .category,
      DeviceCategory.unknown,
    );
    expect(d.fingerprint.evidence.any((e) => e.source == 'port'), isTrue);
  });
  test(
    'stable UDN preserves device across DHCP and changed names without MAC',
    () {
      final m = IdentityReconciler();
      final old = sample(udn: 'uuid:device-123', hostname: 'old.local');
      m.devices.add(old);
      final result = m.merge(
        sample(
          ip: '192.168.1.99',
          udn: 'uuid:device-123',
          hostname: 'new.local',
        ),
      );
      expect(result.id, old.id);
      expect(m.devices.length, 1);
      expect(result.hostname, 'new.local');
    },
  );
  test(
    'global MAC continuity survives DHCP while private MAC stays tentative',
    () {
      final m = IdentityReconciler();
      final old = sample(mac: 'A4:BB:CC:DD:EE:FF');
      m.devices.add(old);
      expect(
        m.merge(sample(ip: '192.168.1.99', mac: old.macAddress)).id,
        old.id,
      );
      final p = IdentityReconciler();
      final private = sample(mac: 'AA:BB:CC:DD:EE:FF');
      p.devices.add(private);
      final moved = p.merge(
        sample(ip: '192.168.1.99', mac: private.macAddress),
      );
      expect(p.devices.length, 2);
      expect(moved.fingerprint.possibleSameDevices, contains(private.id));
    },
  );
  test(
    'IP reuse with new strong MAC restores prior history and separates device',
    () {
      final m = IdentityReconciler();
      final old = sample(mac: 'A4:BB:CC:DD:EE:FF');
      m.devices.add(old);
      m.merge(sample()); // Initial reachability event lacks identity.
      final replacement = m.merge(sample(mac: 'B4:BB:CC:DD:EE:FF'));
      expect(m.devices.length, 2);
      expect(replacement.id, isNot(old.id));
      expect(m.observedIds, isNot(contains(old.id)));
      expect(m.devices.first.macAddress, 'A4:BB:CC:DD:EE:FF');
    },
  );
  test('MAC temporarily unavailable at same IP preserves record', () {
    final m = IdentityReconciler();
    final old = sample(mac: 'A4:BB:CC:DD:EE:FF');
    m.devices.add(old);
    expect(m.merge(sample()).id, old.id);
    expect(m.devices.single.macAddress, old.macAddress);
  });
  test('same weak hostname at new IP does not merge', () {
    final m = IdentityReconciler();
    final old = sample(hostname: 'android.local');
    m.devices.add(old);
    final newer = m.merge(sample(ip: '192.168.1.4', hostname: 'android.local'));
    expect(m.devices.length, 2);
    expect(newer.fingerprint.possibleSameDevices, contains(old.id));
  });
  test('matching UDN never overrides conflicting global MAC', () {
    final m = IdentityReconciler();
    m.devices.add(sample(mac: 'A4:BB:CC:DD:EE:FF', udn: 'uuid:shared-device'));
    m.merge(sample(mac: 'B4:BB:CC:DD:EE:FF', udn: 'uuid:shared-device'));
    expect(m.devices.length, 2);
  });
}
