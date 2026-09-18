import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_guardian_ai/core/database/app_database.dart';
import 'package:network_guardian_ai/core/network/platform_discovery.dart';
import 'package:network_guardian_ai/features/devices/domain/device.dart';

void main() {
  test(
    'SQLite survives reopen and retains absent device history and services',
    () async {
      final dir = await Directory.systemTemp.createTemp('guardian-test');
      final file = File('${dir.path}/history.sqlite');
      var db = AppDatabase.testing(NativeDatabase(file));
      try {
        final id = await db.network(
          NetworkInfo({
            'ip': '192.168.1.2',
            'prefix': 24,
            'gateway': '192.168.1.1',
            'ssid': 'test',
            'bssid': 'A4:12:34:56:78:90',
            'token': '1',
          }),
        );
        final d = Device(
          networkId: id,
          ipAddress: '192.168.1.5',
          services: [
            {'name': 'printer', 'type': '_ipp._tcp', 'port': 631},
          ],
        );
        await db.begin('scan1', id, 254);
        await db.save('scan1', id, [d], 'completed', 254, 1);
        await db.close();
        db = AppDatabase.testing(NativeDatabase(file));
        final rows = await db.loadDevices(id);
        expect(rows.single.id, d.id);
        expect(rows.single.services.single['port'], 631);
        rows.single.isOnline = false;
        await db.begin('scan2', id, 254);
        await db.save('scan2', id, rows, 'completed', 254, 0);
        expect((await db.loadDevices(id)).single.isOnline, false);
        expect((await db.select(db.scanSessions).get()).length, 2);
        expect((await db.select(db.deviceServices).get()).length, 1);
      } finally {
        await db.close();
        await dir.delete(recursive: true);
      }
    },
  );
}
