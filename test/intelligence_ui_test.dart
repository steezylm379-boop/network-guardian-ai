import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_guardian_ai/features/devices/domain/device.dart';
import 'package:network_guardian_ai/features/intelligence/domain/identity.dart';
import 'package:network_guardian_ai/features/intelligence/domain/classifier.dart';
import 'package:network_guardian_ai/features/intelligence/domain/evidence_collector.dart';
import 'package:network_guardian_ai/features/intelligence/presentation/intelligence_panel.dart';
import 'package:network_guardian_ai/features/network_scan/presentation/scan_controller.dart';

class UiScan extends ScanController {
  @override
  ScanView build() => const ScanView();
}

void main() {
  testWidgets(
    'intelligence panel exposes evidence and correction form on narrow screen',
    (tester) async {
      final device = Device(networkId: 'n', ipAddress: '192.168.1.2');
      EvidenceCollector().collect(device, {
        'upnp': {
          'modelName': 'Reported printer',
          'deviceType': 'urn:schemas-upnp-org:device:Printer:1',
        },
      }, 'scan');
      DeviceClassifier().evaluate(device.fingerprint);
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [scanProvider.overrideWith(UiScan.new)],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: IntelligencePanel(device: device),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Reported printer'), findsOneWidget);
      await tester.ensureVisible(find.text('Why this identity?'));
      await tester.tap(find.text('Why this identity?'));
      await tester.pumpAndSettle();
      expect(find.text('Identity evidence'), findsOneWidget);
      expect(tester.takeException(), isNull);
      Navigator.of(tester.element(find.text('Identity evidence'))).pop();
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Confirm or correct'));
      await tester.tap(find.text('Confirm or correct'));
      await tester.pumpAndSettle();
      expect(find.text('Your device name'), findsOneWidget);
      expect(find.text('Save correction'), findsOneWidget);
      expect(tester.takeException(), isNull);
      expect(categoryIcon(DeviceCategory.unknown), Icons.devices_other_rounded);
    },
  );
}
