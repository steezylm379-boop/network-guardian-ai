import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/components.dart';
import '../../network_scan/presentation/scan_controller.dart';
import '../../../core/network/subnet.dart';
import '../../network_health/domain/health_score.dart';
import '../../intelligence/domain/identity.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(scanProvider);
    final controller = ref.read(scanProvider.notifier);
    final n = s.network;
    final health = const NetworkHealthCalculator().evaluate(
      hasNetwork: n != null,
      gatewayConfigured: n?.gateway != null,
      devices: s.devices,
    );
    final confident = s.devices.where((d) {
      final c = d.fingerprint.classification;
      return c.category != DeviceCategory.unknown &&
          (c.level == ConfidenceLevel.high || c.level == ConfidenceLevel.confirmed);
    }).length;
    final partial = s.devices.where((d) {
      final c = d.fingerprint.classification;
      return c.level == ConfidenceLevel.low ||
          c.level == ConfidenceLevel.medium ||
          (c.category == DeviceCategory.unknown && (c.manufacturer != null || c.model != null));
    }).length;
    final unknown = (s.devices.length - confident - partial).clamp(0, s.devices.length);

    return Shell(
      title: 'GUARDIAN / NETWORK',
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 16),
          const Text('YOUR LOCAL NETWORK', style: TextStyle(color: accent, fontSize: 11, letterSpacing: 2)),
          const SizedBox(height: 14),
          Text(n?.ssid ?? (n == null ? 'Let’s connect.' : 'Wi-Fi network'), style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 10),
          Text(n?.subnet.cidr ?? 'Connect to Wi-Fi to discover your devices.', style: TextStyle(color: muted(context))),
          const SizedBox(height: 28),
          Surface(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('NETWORK HEALTH', style: TextStyle(fontSize: 11, letterSpacing: 1.5)),
                      const SizedBox(height: 10),
                      Text('${health.score}', style: const TextStyle(fontSize: 58, height: 1, fontWeight: FontWeight.w300)),
                      const SizedBox(height: 8),
                      Text(health.label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text('Transparent local-health score. Security is not analyzed yet.', style: TextStyle(color: muted(context), fontSize: 12)),
                    ],
                  ),
                ),
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: health.score / 100,
                    strokeWidth: 7,
                    backgroundColor: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: .35),
                  ),
                ),
              ],
            ),
          ),
          Surface(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('${s.devices.where((d) => d.isOnline).length}', style: const TextStyle(fontSize: 64, height: 1, fontWeight: FontWeight.w300)),
                    ),
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: s.busy
                          ? const CircularProgressIndicator(strokeWidth: 1.5, color: accent)
                          : const Icon(Icons.radar, size: 60, color: accent),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('devices seen online', style: TextStyle(color: muted(context))),
                const SizedBox(height: 26),
                Text(
                  s.busy ? '${s.phase.toUpperCase()} · ${s.found} FOUND' : 'A clearer view of what’s connected.',
                  style: const TextStyle(fontSize: 12, letterSpacing: .4),
                ),
                if (s.busy) ...[
                  const SizedBox(height: 16),
                  LinearProgressIndicator(value: s.total == 0 || s.phase != 'scanning' ? null : s.scanned / s.total, minHeight: 3),
                  const SizedBox(height: 10),
                  Text('${s.scanned} / ${s.total} addresses checked', style: TextStyle(color: muted(context))),
                  Text('Service discovery and name resolution run separately.', style: TextStyle(fontSize: 11, color: muted(context, .48))),
                ],
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: s.phase == 'saving' ? null : s.busy ? controller.cancel : controller.start,
                  icon: Icon(s.busy ? Icons.close : Icons.radar),
                  label: Text(s.busy ? 'CANCEL SCAN' : 'SCAN NETWORK'),
                ),
                if (!s.busy && s.phase != 'idle')
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text('Scan ${s.phase}', style: TextStyle(color: muted(context))),
                  ),
              ],
            ),
          ),
          Surface(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('GUARDIAN AI', style: TextStyle(fontSize: 11, letterSpacing: 1.4)),
                const SizedBox(height: 12),
                const Text('Ask what changed. Diagnose what is wrong.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text(
                  'Grounded answers use your local device history, identity evidence and measured diagnostics.',
                  style: TextStyle(color: muted(context), height: 1.45),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => context.push('/guardian'),
                  icon: const Icon(Icons.auto_awesome_outlined),
                  label: const Text('ASK YOUR NETWORK'),
                ),
              ],
            ),
          ),
          Surface(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('DEVICE IDENTIFICATION', style: TextStyle(fontSize: 11, letterSpacing: 1.4)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(child: _metric(context, '$confident', 'Confident')),
                    Expanded(child: _metric(context, '$partial', 'Partial')),
                    Expanded(child: _metric(context, '$unknown', 'Unknown')),
                  ],
                ),
                if (unknown > 0) ...[
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => context.push('/unknown'),
                    icon: const Icon(Icons.manage_search),
                    label: const Text('VIEW UNKNOWN DEVICES'),
                  ),
                ],
              ],
            ),
          ),
          Surface(
            child: Column(
              children: [
                detail('GATEWAY', n?.gateway ?? 'Unavailable'),
                detail('LOCAL ADDRESS', n?.ip ?? 'Unavailable'),
                detail('HOST RANGE', n == null ? 'Unavailable' : _hostRange(s)),
                detail('LAST COMPLETED SCAN', s.lastScan == null ? 'No completed scans' : time(s.lastScan!)),
              ],
            ),
          ),
          ...s.warnings.map(
            (w) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(w, style: TextStyle(color: Theme.of(context).colorScheme.tertiary, height: 1.5)),
            ),
          ),
          Text(
            'LOCAL BY DESIGN\nYour scan history and identity corrections stay on this device.',
            style: TextStyle(fontSize: 11, color: muted(context, .48), height: 1.8, letterSpacing: .5),
          ),
        ],
      ),
    );
  }

  Widget _metric(BuildContext context, String value, String label) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
      Text(label, style: TextStyle(color: muted(context), fontSize: 12)),
    ],
  );
}

String _hostRange(ScanView s) {
  final hosts = s.network!.subnet;
  return '${Ipv4Subnet.format(hosts.first)} – ${Ipv4Subnet.format(hosts.last)}';
}
