import 'dart:convert';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:network_guardian_ai/core/database/app_database.dart';
import 'package:network_guardian_ai/features/devices/domain/device.dart';
import 'package:network_guardian_ai/features/intelligence/domain/identity.dart';
import 'package:network_guardian_ai/features/intelligence/domain/classifier.dart';

void main() {
  test('real schema v1 migrates additively through Phase 3 preserving all records', () async {
    final directory = await Directory.systemTemp.createTemp('guardian-v1-');
    final file = File('${directory.path}/guardian.sqlite');
    final legacy = sqlite.sqlite3.open(file.path);
    final d = Device(
      id: 'device',
      networkId: 'network',
      ipAddress: '192.168.1.8',
      hostname: 'printer.local',
      firstSeen: DateTime(2024),
      lastSeen: DateTime(2025),
      services: [
        {'name': 'Printer', 'type': '_ipp._tcp', 'port': 631},
      ],
    );
    final payload = d.toJson()..remove('fingerprint');
    legacy.execute(
      'CREATE TABLE networks (id TEXT NOT NULL PRIMARY KEY, fingerprint TEXT NOT NULL UNIQUE, ssid TEXT, gateway_ip TEXT, cidr TEXT NOT NULL, first_seen INTEGER NOT NULL, last_seen INTEGER NOT NULL)',
    );
    legacy.execute(
      'CREATE TABLE devices (id TEXT NOT NULL PRIMARY KEY, network_id TEXT NOT NULL REFERENCES networks(id), ip_address TEXT NOT NULL, mac_address TEXT, payload TEXT NOT NULL, created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL)',
    );
    legacy.execute(
      'CREATE TABLE device_services (device_id TEXT NOT NULL REFERENCES devices(id) ON DELETE CASCADE, service_key TEXT NOT NULL, payload TEXT NOT NULL, PRIMARY KEY(device_id,service_key))',
    );
    legacy.execute(
      'CREATE TABLE scan_sessions (id TEXT NOT NULL PRIMARY KEY, network_id TEXT NOT NULL REFERENCES networks(id), started_at INTEGER NOT NULL, ended_at INTEGER, status TEXT NOT NULL, scanned INTEGER NOT NULL DEFAULT 0, total INTEGER NOT NULL, found INTEGER NOT NULL DEFAULT 0)',
    );
    legacy.execute(
      "INSERT INTO networks VALUES ('network','fingerprint','Wi-Fi','192.168.1.1','192.168.1.0/24',100,200)",
    );
    legacy.execute(
      "INSERT INTO devices VALUES ('device','network','192.168.1.8',NULL,?,100,200)",
      [jsonEncode(payload)],
    );
    legacy.execute(
      "INSERT INTO device_services VALUES ('device','_ipp._tcp|Printer',?)",
      [jsonEncode(d.services.single)],
    );
    legacy.execute(
      "INSERT INTO scan_sessions VALUES ('scan','network',100,200,'completed',254,254,1)",
    );
    legacy.execute('PRAGMA user_version = 1');
    legacy.close();
    var db = AppDatabase.testing(NativeDatabase(file));
    try {
      final rows = await db.loadDevices('network');
      expect(rows.single.id, 'device');
      expect(rows.single.firstSeen, DateTime(2024));
      expect(rows.single.services.single['port'], 631);
      expect((await db.select(db.networks).get()).single.ssid, 'Wi-Fi');
      expect(
        (await db.select(db.scanSessions).get()).single.status,
        'completed',
      );
      expect((await db.select(db.deviceServices).get()).length, 1);
      expect((await db.select(db.identityEvidenceRows).get()), isNotEmpty);
      expect((await db.select(db.guardianMessages).get()), isEmpty);
      expect((await db.select(db.diagnosticRuns).get()), isEmpty);
      expect(
        (await db.customSelect('PRAGMA user_version').getSingle()).read<int>(
          'user_version',
        ),
        3,
      );
      final device = rows.single;
      device.fingerprint.override = DeviceOverride(
        userName: 'Office printer',
        category: DeviceCategory.printer,
        confirmed: true,
      );
      DeviceClassifier().evaluate(device.fingerprint);
      await db.saveIntelligence(rows);
      await db.close();
      db = AppDatabase.testing(NativeDatabase(file));
      final reopened = (await db.loadDevices('network')).single;
      expect(reopened.name, 'Office printer');
      expect(
        reopened.fingerprint.classification.level,
        ConfidenceLevel.confirmed,
      );
      reopened.fingerprint.override = null;
      DeviceClassifier().evaluate(reopened.fingerprint);
      await db.saveIntelligence([reopened]);
      expect((await db.select(db.deviceOverrides).get()), isEmpty);
      expect((await db.loadDevices('network')).single.name, 'printer.local');
      expect((await db.select(db.scanSessions).get()).length, 1);
    } finally {
      await db.close();
      await directory.delete(recursive: true);
    }
  });
}
