import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const accent = Color(0xffa9e899);

Color muted(BuildContext context, [double opacity = .58]) =>
    Theme.of(context).colorScheme.onSurface.withValues(alpha: opacity);

class Shell extends StatelessWidget {
  const Shell({
    super.key,
    required this.title,
    required this.child,
    this.index = 0,
  });
  final String title;
  final Widget child;
  final int index;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      actions: index == 4
          ? const []
          : [
              IconButton(
                onPressed: () => context.push('/settings'),
                icon: const Icon(Icons.tune_rounded),
                tooltip: 'Settings',
              ),
            ],
    ),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: child,
        ),
      ),
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: index,
      onDestinationSelected: (i) => context.go(switch (i) {
        0 => '/',
        1 => '/devices',
        2 => '/guardian',
        3 => '/tools',
        _ => '/settings',
      }),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.radar_rounded), label: 'Overview'),
        NavigationDestination(icon: Icon(Icons.devices_rounded), label: 'Devices'),
        NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), label: 'Guardian'),
        NavigationDestination(icon: Icon(Icons.build_circle_outlined), label: 'Tools'),
        NavigationDestination(icon: Icon(Icons.tune_rounded), label: 'Settings'),
      ],
    ),
  );
}

class Surface extends StatelessWidget {
  const Surface({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: .55)),
      ),
      child: child,
    );
  }
}

String time(DateTime t) => t.toLocal().toString().split('.').first;
Widget detail(String label, String value) => Builder(
  builder: (context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: muted(context, .48), letterSpacing: 1.4),
        ),
        const SizedBox(height: 6),
        SelectableText(value, style: const TextStyle(fontSize: 14)),
      ],
    ),
  ),
);
