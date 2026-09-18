import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/components.dart';
import '../../devices/domain/device.dart';
import '../../network_scan/presentation/scan_controller.dart';
import '../domain/diagnostics_service.dart';
import '../domain/diagnostics_provider.dart';

class ToolsScreen extends ConsumerStatefulWidget {
  const ToolsScreen({super.key});
  @override
  ConsumerState<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends ConsumerState<ToolsScreen> {
  String? selectedId;
  bool running = false;
  PingResult? ping;
  List<ServiceProbeResult>? services;
  String? message;

  Device? selected(List<Device> devices) {
    final id = selectedId;
    if (id == null) return devices.where((d) => d.isOnline).firstOrNull;
    return devices.where((d) => d.id == id).firstOrNull;
  }

  Future<void> runPing(Device d) async {
    setState(() { running = true; message = null; ping = null; });
    try {
      final value = await ref.read(diagnosticsProvider).ping(d.ipAddress);
      if (mounted) setState(() => ping = value);
    } catch (e) {
      if (mounted) setState(() => message = e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => running = false);
    }
  }

  Future<void> probe(Device d) async {
    setState(() { running = true; message = null; services = null; });
    try {
      final value = await ref.read(diagnosticsProvider).probeServices(d.ipAddress);
      if (mounted) setState(() => services = value);
    } catch (e) {
      if (mounted) setState(() => message = e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => running = false);
    }
  }

  Future<void> wake(Device d) async {
    final mac = d.macAddress;
    if (mac == null) return;
    setState(() { running = true; message = null; });
    try {
      await ref.read(diagnosticsProvider).wakeOnLan(mac);
      if (mounted) setState(() => message = 'Wake-on-LAN magic packet sent to ${d.name}. The target must support and enable Wake-on-LAN.');
    } catch (e) {
      if (mounted) setState(() => message = e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => running = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scanProvider);
    final devices = state.devices.where((d) => d.isOnline).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    final d = selected(devices);
    final currentId = devices.any((item) => item.id == selectedId) ? selectedId : d?.id;

    return Shell(
      title: 'Network tools',
      index: 3,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Surface(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('TARGET DEVICE', style: TextStyle(fontSize: 11, letterSpacing: 1.4)),
                const SizedBox(height: 12),
                if (devices.isEmpty)
                  Text('No online devices are recorded. Run a network scan first.', style: TextStyle(color: muted(context)))
                else
                  DropdownButtonFormField<String>(
                    key: ValueKey(currentId),
                    initialValue: currentId,
                    isExpanded: true,
                    items: devices.map((item) => DropdownMenuItem(
                      value: item.id,
                      child: Text('${item.name} · ${item.ipAddress}', overflow: TextOverflow.ellipsis),
                    )).toList(),
                    onChanged: running ? null : (v) => setState(() { selectedId = v; ping = null; services = null; message = null; }),
                  ),
              ],
            ),
          ),
          Surface(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('DIAGNOSTICS', style: TextStyle(fontSize: 11, letterSpacing: 1.4)),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    FilledButton.icon(
                      onPressed: d == null || running ? null : () => runPing(d),
                      icon: const Icon(Icons.network_ping),
                      label: const Text('PING'),
                    ),
                    OutlinedButton.icon(
                      onPressed: d == null || running ? null : () => probe(d),
                      icon: const Icon(Icons.lan_outlined),
                      label: const Text('CHECK SERVICES'),
                    ),
                    OutlinedButton.icon(
                      onPressed: d == null || d.macAddress == null || running ? null : () => wake(d),
                      icon: const Icon(Icons.power_settings_new),
                      label: const Text('WAKE ON LAN'),
                    ),
                  ],
                ),
                if (running) ...[
                  const SizedBox(height: 18),
                  const LinearProgressIndicator(minHeight: 2),
                ],
              ],
            ),
          ),
          if (ping != null)
            Surface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('PING RESULT'),
                  detail('METHOD', ping!.method),
                  detail('PACKETS', '${ping!.received} received / ${ping!.sent} sent'),
                  detail('PACKET LOSS', '${ping!.packetLossPercent.toStringAsFixed(1)}%'),
                  detail('MIN / AVG / MAX', '${_ms(ping!.minMs)} / ${_ms(ping!.avgMs)} / ${_ms(ping!.maxMs)}'),
                ],
              ),
            ),
          if (services != null)
            Surface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('REACHABLE SERVICES'),
                  const SizedBox(height: 12),
                  if (services!.isEmpty)
                    Text('No curated TCP services responded. A firewall may still hide services.', style: TextStyle(color: muted(context)))
                  else
                    ...services!.map((s) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.check_circle_outline),
                      title: Text(s.name),
                      subtitle: Text('TCP ${s.port}'),
                    )),
                ],
              ),
            ),
          if (message != null)
            Surface(child: Text(message!, style: const TextStyle(height: 1.5))),
          Text(
            'Diagnostics are restricted to the currently connected Wi-Fi subnet. Service checks are limited to a curated set of common TCP ports.',
            style: TextStyle(color: muted(context, .5), fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }

  String _ms(double? value) => value == null ? '—' : '${value.toStringAsFixed(1)} ms';
}
