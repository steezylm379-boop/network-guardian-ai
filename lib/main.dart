import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'features/network_scan/presentation/home_screen.dart';
import 'features/devices/presentation/device_screens.dart';
import 'features/settings/presentation/settings_screen.dart';
import 'features/diagnostics/presentation/tools_screen.dart';
import 'features/networks/presentation/network_history.dart';
import 'features/guardian/presentation/guardian_screen.dart';
import 'core/theme/components.dart';
import 'core/settings/theme_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: GuardianApp()));
}

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, _) => const Dashboard()),
    GoRoute(path: '/devices', builder: (_, _) => const DeviceList()),
    GoRoute(path: '/unknown', builder: (_, _) => const UnknownDevicesScreen()),
    GoRoute(
      path: '/device/:id',
      builder: (_, s) => DeviceDetail(id: s.pathParameters['id']!),
    ),
    GoRoute(path: '/guardian', builder: (_, _) => const GuardianScreen()),
    GoRoute(path: '/tools', builder: (_, _) => const ToolsScreen()),
    GoRoute(path: '/settings', builder: (_, _) => const Settings()),
    GoRoute(path: '/history', builder: (_, _) => const NetworkHistory()),
  ],
);

ThemeData guardianTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final scheme = ColorScheme.fromSeed(
    seedColor: accent,
    brightness: brightness,
    primary: dark ? accent : const Color(0xff2f6f2a),
  ).copyWith(
    surface: dark ? const Color(0xff191c1f) : const Color(0xfff8faf7),
  );
  return ThemeData(
    fontFamily: 'GuardianSans',
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: dark ? const Color(0xff101214) : const Color(0xfff1f4f0),
    appBarTheme: AppBarTheme(
      backgroundColor: dark ? const Color(0xff101214) : const Color(0xfff1f4f0),
      centerTitle: false,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 38, fontWeight: FontWeight.w600, letterSpacing: -1.5),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w500, letterSpacing: -0.8),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(160, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );
}

class GuardianApp extends ConsumerWidget {
  const GuardianApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
    title: 'Network Guardian AI',
    debugShowCheckedModeBanner: false,
    routerConfig: router,
    themeMode: ref.watch(themeModeProvider),
    theme: guardianTheme(Brightness.light),
    darkTheme: guardianTheme(Brightness.dark),
  );
}
