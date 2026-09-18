import 'dart:async';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_guardian_ai/core/database/app_database.dart';
import 'package:network_guardian_ai/core/network/platform_discovery.dart';
import 'package:network_guardian_ai/core/network/vendor_lookup_service.dart';
import 'package:network_guardian_ai/features/network_scan/presentation/scan_controller.dart';

// Test-only native adapter; no simulated discovery is shipped in the app.
class TestNetwork extends NetworkInfoService {
  @override
  Future<NetworkInfo> detect() async => NetworkInfo({
    'ip': '192.168.1.2',
    'prefix': 30,
    'gateway': '192.168.1.1',
    'interface': 'wlan0',
    'token': '1',
    'bssid': '00:11:22:33:44:55',
  });
}

class TestDiscovery extends AndroidDiscovery {
  final events = StreamController<Map<String, dynamic>>.broadcast();
  String? id;
  @override
  Stream<Map<String, dynamic>> get stream => events.stream;
  @override
  Future<void> start(NetworkInfo network, String runId) async {
    id = runId;
  }

  @override
  Future<void> cancel() async {}
  void send(Map<String, dynamic> event) => events.add({'runId': id, ...event});
}

class TestVendors extends VendorLookupService {
  @override
  Future<void> load() async {}
}

void main() {
  test(
    'completion updates presence; cancellation preserves it; returning identity keeps firstSeen',
    () async {
      final db = AppDatabase.testing(NativeDatabase.memory());
      final native = TestDiscovery();
      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          networkInfoProvider.overrideWithValue(TestNetwork()),
          discoveryProvider.overrideWithValue(native),
          vendorProvider.overrideWithValue(TestVendors()),
        ],
      );
      final sub = container.listen(scanProvider, (_, _) {});
      final controller = container.read(scanProvider.notifier);
      Future<void> settle() async {
        for (var i = 0; i < 200 && container.read(scanProvider).busy; i++) {
          await Future<void>.delayed(const Duration(milliseconds: 5));
        }
        expect(container.read(scanProvider).busy, false);
      }

      try {
        await controller.refresh();
        await controller.start();
        native.send({
          'kind': 'device',
          'ip': '192.168.1.1',
          'mac': '00:11:22:33:44:66',
          'source': 'ARP',
        });
        native.send({'kind': 'progress', 'scanned': 2});
        native.send({'kind': 'completed'});
        await settle();
        final original = container.read(scanProvider).devices.single;
        expect(original.isOnline, true);
        await controller.start();
        await controller.cancel();
        expect(container.read(scanProvider).devices.single.isOnline, true);
        await controller.start();
        native.send({'kind': 'completed'});
        await settle();
        expect(container.read(scanProvider).devices.single.isOnline, false);
        await controller.start();
        native.send({
          'kind': 'device',
          'ip': '192.168.1.1',
          'mac': '00:11:22:33:44:66',
          'source': 'ARP',
        });
        native.send({'kind': 'completed'});
        await settle();
        final returned = container.read(scanProvider).devices.single;
        expect(returned.id, original.id);
        expect(returned.firstSeen, original.firstSeen);
        expect(returned.lastSeen.isAfter(original.lastSeen), true);
        expect(returned.isOnline, true);
        expect((await db.select(db.scanSessions).get()).length, 4);
      } finally {
        sub.close();
        container.dispose();
        await native.events.close();
        await db.close();
      }
    },
  );
}
