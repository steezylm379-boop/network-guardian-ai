import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/components.dart';
import '../../network_scan/presentation/scan_controller.dart';
import '../domain/device.dart';
import '../../intelligence/presentation/intelligence_panel.dart';
import '../../intelligence/domain/identity.dart';

class DeviceList extends ConsumerStatefulWidget {
  const DeviceList({super.key});
  @override
  ConsumerState<DeviceList> createState() => _DeviceListState();
}

class _DeviceListState extends ConsumerState<DeviceList> {
  String query = '';
  String filter = 'all';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scanProvider);
    final rows = state.devices.where((d) {
      final q = query.trim().toLowerCase();
      final searchable = '${d.name} ${d.ipAddress} ${d.macAddress ?? ''} ${d.hostname ?? ''} ${d.fingerprint.classification.manufacturer ?? ''} ${d.fingerprint.classification.model ?? ''}'.toLowerCase();
      if (q.isNotEmpty && !searchable.contains(q)) return false;
      return switch (filter) {
        'online' => d.isOnline,
        'offline' => !d.isOnline,
        'unknown' => _isUnknown(d),
        'trusted' => d.trustState == DeviceTrustState.trusted,
        _ => true,
      };
    }).toList()
      ..sort((a, b) => a.isOnline == b.isOnline ? a.name.compareTo(b.name) : a.isOnline ? -1 : 1);

    return Shell(
      title: 'Devices / ${state.devices.length}',
      index: 1,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
            child: TextField(
              onChanged: (v) => setState(() => query = v),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search devices…',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: [
                for (final item in const {
                  'all': 'All',
                  'online': 'Online',
                  'offline': 'Offline',
                  'unknown': 'Unknown',
                  'trusted': 'Trusted',
                }.entries)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(item.value),
                      selected: filter == item.key,
                      onSelected: (_) => setState(() => filter = item.key),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: rows.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        state.devices.isEmpty
                            ? 'No devices recorded yet.\nStart a scan from Overview.'
                            : 'No devices match this filter.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: muted(context)),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: rows.length,
                    itemBuilder: (context, i) => _DeviceCard(device: rows[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class UnknownDevicesScreen extends ConsumerWidget {
  const UnknownDevicesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rows = ref.watch(scanProvider).devices.where(_isUnknown).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return Scaffold(
      appBar: AppBar(title: Text('Unknown devices / ${rows.length}')),
      body: rows.isEmpty
          ? Center(child: Text('No fully unknown devices right now.', style: TextStyle(color: muted(context))))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: rows.length,
              itemBuilder: (_, i) => _DeviceCard(device: rows[i]),
            ),
    );
  }
}

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({required this.device});
  final Device device;
  @override
  Widget build(BuildContext context) {
    final c = device.fingerprint.classification;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          onTap: () => context.push('/device/${device.id}'),
          leading: Icon(categoryIcon(c.category), color: muted(context, .72)),
          title: Row(
            children: [
              Expanded(child: Text(device.name, maxLines: 1, overflow: TextOverflow.ellipsis)),
              if (device.trustState == DeviceTrustState.trusted)
                const Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Icon(Icons.verified_user_outlined, size: 16, color: accent),
                ),
            ],
          ),
          subtitle: Text(
            '${c.manufacturer ?? 'Unknown manufacturer'} · ${c.level.name.toUpperCase()} ${c.score}/100\n${c.model == null ? '' : '${c.model}\n'}${device.ipAddress}',
            style: TextStyle(color: muted(context, .5), height: 1.45),
          ),
          trailing: Text(
            device.isOnline ? 'ONLINE' : 'OFFLINE',
            style: TextStyle(fontSize: 9, letterSpacing: 1, color: device.isOnline ? accent : muted(context, .35)),
          ),
        ),
      ),
    );
  }
}

bool _isUnknown(Device d) {
  final c = d.fingerprint.classification;
  return c.category == DeviceCategory.unknown &&
      c.manufacturer == null &&
      c.model == null &&
      c.level == ConfidenceLevel.unknown;
}

class DeviceDetail extends ConsumerWidget {
  const DeviceDetail({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rows = ref.watch(scanProvider.select((s) => s.devices));
    final Device? d = rows.where((d) => d.id == id).firstOrNull;
    return Scaffold(
      appBar: AppBar(title: const Text('Device details')),
      body: d == null
          ? const Center(child: Text('This record was merged or is no longer selected.'))
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(d.name, style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 12),
                Text(
                  d.isOnline ? 'ONLINE AT LAST OBSERVATION' : 'NOT SEEN IN LAST COMPLETED SCAN',
                  style: const TextStyle(color: accent, fontSize: 11),
                ),
                const SizedBox(height: 16),
                SegmentedButton<DeviceTrustState>(
                  segments: const [
                    ButtonSegment(value: DeviceTrustState.unknown, icon: Icon(Icons.help_outline), label: Text('Unknown')),
                    ButtonSegment(value: DeviceTrustState.trusted, icon: Icon(Icons.verified_user_outlined), label: Text('Trusted')),
                  ],
                  selected: {d.trustState},
                  onSelectionChanged: ref.watch(scanProvider).busy
                      ? null
                      : (value) => ref.read(scanProvider.notifier).setTrust(d, value.first),
                ),
                const SizedBox(height: 28),
                IntelligencePanel(device: d),
                Surface(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      detail('IP ADDRESS', d.ipAddress),
                      detail('MAC ADDRESS', d.macAddress ?? 'Unavailable on this device / network'),
                      detail('MANUFACTURER', d.fingerprint.classification.manufacturer ?? 'Unknown manufacturer'),
                      detail('HOSTNAME', d.hostname ?? 'Unavailable'),
                      detail('mDNS NAME', d.mdnsName ?? 'Unavailable'),
                      detail('GATEWAY', d.isGateway ? 'Yes' : 'No'),
                      detail('TRUST', d.trustState.name.toUpperCase()),
                      detail('FIRST SEEN', time(d.firstSeen)),
                      detail('LAST SEEN', time(d.lastSeen)),
                      detail('DISCOVERED VIA', d.sources.join(' · ')),
                    ],
                  ),
                ),
                const Text('DISCOVERED SERVICES', style: TextStyle(fontSize: 11, letterSpacing: 1.4)),
                const SizedBox(height: 16),
                if (d.services.isEmpty) Text('No services advertised or resolved.', style: TextStyle(color: muted(context))),
                ...d.services.map(
                  (s) => Surface(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s['name']?.toString() ?? 'Unnamed service'),
                        detail('TYPE / PORT', '${s['type']} / ${s['port']}'),
                        if (s['attributes'] != null) detail('TXT ATTRIBUTES', s['attributes'].toString()),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text('ACTIVITY', style: TextStyle(fontSize: 11, letterSpacing: 1.4)),
                const SizedBox(height: 12),
                if (d.events.isEmpty)
                  Text('No device-change events recorded yet.', style: TextStyle(color: muted(context)))
                else
                  ...d.events.take(30).map(
                    (e) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(_eventIcon(e.type.name), size: 20),
                      title: Text(e.message),
                      subtitle: Text(time(e.at), style: TextStyle(color: muted(context, .5))),
                    ),
                  ),
              ],
            ),
    );
  }
}

IconData _eventIcon(String type) => switch (type) {
  'online' => Icons.wifi,
  'offline' => Icons.wifi_off,
  'ipChanged' => Icons.swap_horiz,
  'servicesChanged' => Icons.lan_outlined,
  'trustChanged' => Icons.verified_user_outlined,
  'correctionChanged' => Icons.edit_outlined,
  _ => Icons.history,
};
