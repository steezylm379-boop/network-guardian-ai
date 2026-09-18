import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_guardian_ai/main.dart';
import 'package:network_guardian_ai/features/network_scan/presentation/scan_controller.dart';

class EmptyScan extends ScanController {
  @override
  ScanView build() => const ScanView();
}

void main() {
  testWidgets(
    'empty phone screen presents honest state without layout errors',
    (tester) async {
      final font = FontLoader('GuardianSans');
      for (final weight in ['regular', 'light', 'medium', 'bold']) {
        font.addFont(rootBundle.load('assets/fonts/roboto-$weight.ttf'));
      }
      await font.load();
      await (FontLoader(
        'MaterialIcons',
      )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [scanProvider.overrideWith(EmptyScan.new)],
          child: const RepaintBoundary(
            key: ValueKey('overview'),
            child: GuardianApp(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Let’s connect.'), findsOneWidget);
      expect(find.text('SCAN NETWORK'), findsOneWidget);
      expect(tester.takeException(), isNull);
      if (const bool.fromEnvironment('CAPTURE_UI')) {
        await expectLater(
          find.byKey(const ValueKey('overview')),
          matchesGoldenFile('goldens/overview.png'),
        );
      }
    },
  );
}
