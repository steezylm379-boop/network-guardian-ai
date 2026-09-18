import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_guardian_ai/core/database/app_database.dart';
import 'package:network_guardian_ai/features/network_scan/presentation/scan_controller.dart';
import 'package:network_guardian_ai/features/intelligence/domain/identity.dart';
import 'scan_lifecycle_test.dart' show TestNetwork, TestDiscovery, TestVendors;

void main() {
  test(
    'cancellation during identifying persists evidence and rejects late events',
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
      final subscription = container.listen(scanProvider, (_, _) {});
      try {
        final controller = container.read(scanProvider.notifier);
        await controller.refresh();
        await controller.start();
        native.send({'kind': 'phase', 'phase': 'identifying'});
        native.send({
          'kind': 'device',
          'ip': '192.168.1.1',
          'source': 'UPnP',
          'upnp': {'UDN': 'uuid:router-123', 'manufacturer': 'Reported maker'},
        });
        await Future<void>.delayed(const Duration(milliseconds: 20));
        controller.publish();
        expect(container.read(scanProvider).phase, 'identifying');
        expect(container.read(scanProvider).busy, true);
        await controller.cancel();
        native.send({
          'kind': 'device',
          'ip': '192.168.1.2',
          'source': 'UPnP',
          'upnp': {'modelName': 'Late'},
        });
        await Future<void>.delayed(const Duration(milliseconds: 20));
        expect(container.read(scanProvider).phase, 'cancelled');
        expect(container.read(scanProvider).devices.length, 1);
        expect(
          (await db.select(db.identityEvidenceRows).get()).any(
            (e) => e.evidenceKey == 'manufacturer',
          ),
          true,
        );
        expect(
          (await db.select(db.scanSessions).get()).single.status,
          'cancelled',
        );
        await controller.setOverride(
          container.read(scanProvider).devices.single,
          DeviceOverride(
            userName: 'My router',
            category: DeviceCategory.router,
            confirmed: true,
          ),
        );
        expect(container.read(scanProvider).devices.single.name, 'My router');
        expect(
          (await db.select(db.identityEvidenceRows).get()).any(
            (e) => e.source == 'user',
          ),
          true,
        );
        await controller.setOverride(
          container.read(scanProvider).devices.single,
          null,
        );
        expect(
          (await db.select(db.identityEvidenceRows).get()).any(
            (e) => e.source == 'user',
          ),
          false,
        );
        expect((await db.select(db.deviceOverrides).get()), isEmpty);
      } finally {
        subscription.close();
        container.dispose();
        await native.events.close();
        await db.close();
      }
    },
  );
}
