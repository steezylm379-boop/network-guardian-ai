import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/components.dart';
import '../../../core/settings/theme_controller.dart';
import '../../network_scan/presentation/scan_controller.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeModeProvider);
    return Shell(
      title: 'Settings',
      index: 4,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Surface(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Appearance', style: TextStyle(fontSize: 22)),
                const SizedBox(height: 14),
                SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(value: ThemeMode.system, label: Text('System')),
                    ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                    ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
                  ],
                  selected: {theme},
                  onSelectionChanged: (value) => ref.read(themeModeProvider.notifier).set(value.first),
                ),
              ],
            ),
          ),
          Surface(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Wi-Fi identity', style: TextStyle(fontSize: 22)),
                const SizedBox(height: 12),
                Text(
                  'Android may require precise location permission and enabled location services to expose the Wi-Fi name and access point identifier. Scanning can continue without them.',
                  style: TextStyle(color: muted(context), height: 1.6),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: ref.watch(scanProvider).busy ? null : ref.read(scanProvider.notifier).permission,
                  child: const Text('ALLOW WI-FI NAME ACCESS'),
                ),
              ],
            ),
          ),
          Surface(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('AI privacy', style: TextStyle(fontSize: 22)),
                const SizedBox(height: 12),
                Text(
                  'Phase 3 uses a grounded local assistant by default. Raw MAC addresses, IP addresses, hostnames, scan history and device identities are not sent to a cloud model. A future enterprise AI gateway is isolated behind a privacy/redaction contract and must be explicitly configured by the deploying organization.',
                  style: TextStyle(color: muted(context), height: 1.6),
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: () => context.push('/history'),
            icon: const Icon(Icons.history),
            label: const Text('NETWORK & SCAN HISTORY'),
          ),
          const SizedBox(height: 20),
          Surface(
            child: Text(
              'Phase 3 · Grounded AI network intelligence\n\nThe app scans only the connected Wi-Fi subnet. Discovery combines bounded reachability checks, mDNS/Bonjour, SSDP/UPnP, safe common-port hints, offline OUI manufacturer lookup, and deterministic identity evidence.\n\nAsk Your Network and Network Doctor reason over locally recorded telemetry. The default Phase 3 assistant is grounded and local; no network inventory is uploaded to a cloud model. Online means seen during a completed scan. The app does not monitor in the background yet. Firewalls, client isolation, and OS privacy controls can hide devices or metadata.\n\nDevice type and model are evidence-based estimates with an explicit confidence score. They are never presented as certainty when evidence is weak. Corrections and network history stay local on this device.',
              style: TextStyle(height: 1.6, color: muted(context)),
            ),
          ),
        ],
      ),
    );
  }
}
