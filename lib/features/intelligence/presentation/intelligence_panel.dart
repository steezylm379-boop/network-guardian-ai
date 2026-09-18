import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/components.dart';
import '../../devices/domain/device.dart';
import '../../network_scan/presentation/scan_controller.dart';
import '../domain/identity.dart';

String categoryLabel(DeviceCategory category) => category.name.replaceAllMapped(
  RegExp(r'[A-Z]'),
  (m) => ' ${m[0]!.toLowerCase()}',
);
IconData categoryIcon(DeviceCategory c) => switch (c) {
  DeviceCategory.router ||
  DeviceCategory.modem ||
  DeviceCategory.accessPoint ||
  DeviceCategory.repeater ||
  DeviceCategory.networkInfrastructure => Icons.router_outlined,
  DeviceCategory.networkSwitch => Icons.account_tree_outlined,
  DeviceCategory.phone => Icons.phone_android,
  DeviceCategory.tablet => Icons.tablet_outlined,
  DeviceCategory.laptop => Icons.laptop,
  DeviceCategory.desktop || DeviceCategory.computer => Icons.computer,
  DeviceCategory.server => Icons.dns_outlined,
  DeviceCategory.television || DeviceCategory.streamingDevice || DeviceCategory.mediaServer => Icons.tv,
  DeviceCategory.smartSpeaker => Icons.speaker_outlined,
  DeviceCategory.printer => Icons.print_outlined,
  DeviceCategory.camera => Icons.videocam_outlined,
  DeviceCategory.nvr => Icons.video_library_outlined,
  DeviceCategory.gameConsole => Icons.sports_esports_outlined,
  DeviceCategory.nas => Icons.storage_outlined,
  DeviceCategory.voipPhone => Icons.phone_in_talk_outlined,
  DeviceCategory.posTerminal => Icons.point_of_sale_outlined,
  DeviceCategory.smartHome || DeviceCategory.iot => Icons.sensors,
  DeviceCategory.unknown => Icons.devices_other_rounded,
};

class IntelligencePanel extends ConsumerWidget {
  const IntelligencePanel({super.key, required this.device});
  final Device device;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final f = device.fingerprint, c = f.classification;
    final busy = ref.watch(scanProvider.select((s) => s.busy));
    return Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('DEVICE INTELLIGENCE'),
          const SizedBox(height: 16),
          detail(
            'CATEGORY',
            '${c.category != DeviceCategory.unknown && c.level != ConfidenceLevel.confirmed ? 'Likely ' : ''}${categoryLabel(c.category)}',
          ),
          detail('MANUFACTURER', c.manufacturer ?? 'Unknown'),
          detail(
            'REPORTED MODEL',
            c.model ?? 'Unknown — insufficient evidence',
          ),
          detail(
            'CONFIDENCE',
            '${c.level.name.toUpperCase()} · ${c.score}/100 evidence strength',
          ),
          Text(
            'Evidence strength is not a probability. Device advertisements may be incomplete or incorrect.',
            style: TextStyle(color: muted(context), fontSize: 12),
          ),
          if (f.override != null)
            detail('USER CORRECTION', 'Saved ${time(f.override!.updatedAt)}'),
          if (c.conflicts.isNotEmpty)
            detail('CONFLICTS', c.conflicts.join('\n')),
          if (f.possibleSameDevices.isNotEmpty)
            detail(
              'POSSIBLY THE SAME DEVICE',
              f.possibleSameDevices.entries
                  .map((e) => '${e.key}: ${e.value}')
                  .join('\n'),
            ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => EvidenceSheet(device: device),
                ),
                child: const Text('Why this identity?'),
              ),
              OutlinedButton(
                onPressed: busy
                    ? null
                    : () => showDialog<void>(
                        context: context,
                        builder: (_) => CorrectionDialog(device: device),
                      ),
                child: const Text('Confirm or correct'),
              ),
              if (f.override != null)
                TextButton(
                  onPressed: busy
                      ? null
                      : () async {
                          try {
                            await ref
                                .read(scanProvider.notifier)
                                .setOverride(device, null);
                          } catch (_) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Could not clear correction. Please try again.',
                                  ),
                                ),
                              );
                            }
                          }
                        },
                  child: const Text('Clear correction'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class EvidenceSheet extends StatelessWidget {
  const EvidenceSheet({super.key, required this.device});
  final Device device;
  @override
  Widget build(BuildContext context) {
    final f = device.fingerprint;
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * .85,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Identity evidence',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            const Text(
              'IP is a temporary location. Private/randomized MAC addresses have reduced stability and are not used for manufacturer lookup.',
            ),
            detail(
              'STABLE IDENTIFIERS',
              f.identifiers.isEmpty
                  ? 'No stable identifier available'
                  : f.identifiers
                        .map(
                          (i) =>
                              '${i.type}: ${i.value}\n${i.source} · stability ${i.stability}/100\nFirst ${time(i.firstSeen)} · Last ${time(i.lastSeen)}',
                        )
                        .join('\n\n'),
            ),
            detail(
              'REASONS',
              f.classification.reasons.isEmpty
                  ? 'Insufficient evidence'
                  : f.classification.reasons.join('\n'),
            ),
            detail(
              'CANDIDATE SCORES',
              'Category: ${f.classification.categoryCandidates}\nManufacturer: ${f.classification.manufacturerCandidates}\nModel: ${f.classification.modelCandidates}',
            ),
            ...f.evidence.map(
              (e) => Surface(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${e.source} / ${e.key}'),
                    SelectableText(e.value),
                    detail('NORMALIZED', e.normalizedValue),
                    detail(
                      'STRENGTH / OBSERVATIONS',
                      '${e.weight} / ${e.observationCount}',
                    ),
                    detail(
                      'FIRST / LAST SEEN',
                      '${time(e.firstSeen)} / ${time(e.lastSeen)}',
                    ),
                    detail(
                      'EXPIRY',
                      '${e.activeAt(DateTime.now()) ? 'Active' : 'Expired'} · ${e.expiresAt == null ? 'No expiry' : time(e.expiresAt!)}',
                    ),
                    if (e.metadata.isNotEmpty)
                      detail('CONTEXT', e.metadata.toString()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CorrectionDialog extends ConsumerStatefulWidget {
  const CorrectionDialog({super.key, required this.device});
  final Device device;
  @override
  ConsumerState<CorrectionDialog> createState() => _CorrectionDialogState();
}

class _CorrectionDialogState extends ConsumerState<CorrectionDialog> {
  late final TextEditingController name, manufacturer, model;
  DeviceCategory? category;
  bool confirmed = false, saving = false;
  String? error;
  @override
  void initState() {
    super.initState();
    final f = widget.device.fingerprint;
    name = TextEditingController(text: f.override?.userName ?? '');
    manufacturer = TextEditingController(
      text: f.override?.manufacturer ?? f.classification.manufacturer ?? '',
    );
    model = TextEditingController(
      text: f.override?.model ?? f.classification.model ?? '',
    );
    category = f.override?.category ?? f.classification.category;
    confirmed = f.override?.confirmed ?? false;
  }

  @override
  void dispose() {
    name.dispose();
    manufacturer.dispose();
    model.dispose();
    super.dispose();
  }

  String? clean(TextEditingController c) =>
      c.text.trim().isEmpty ? null : c.text.trim();
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Confirm or correct identity'),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: name,
            maxLength: 100,
            decoration: const InputDecoration(labelText: 'Your device name'),
          ),
          DropdownButtonFormField<DeviceCategory>(
            initialValue: category,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Device category'),
            items: DeviceCategory.values
                .map(
                  (c) =>
                      DropdownMenuItem(value: c, child: Text(categoryLabel(c))),
                )
                .toList(),
            onChanged: (v) => setState(() => category = v),
          ),
          TextField(
            controller: manufacturer,
            maxLength: 150,
            decoration: const InputDecoration(labelText: 'Manufacturer'),
          ),
          TextField(
            controller: model,
            maxLength: 150,
            decoration: const InputDecoration(labelText: 'Model'),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('I have verified these identity details'),
            value: confirmed,
            onChanged: (v) => setState(() => confirmed = v ?? false),
          ),
          if (error != null) Text(error!),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: saving ? null : () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: saving
            ? null
            : () async {
                if (confirmed &&
                    (category == null || category == DeviceCategory.unknown) &&
                    clean(manufacturer) == null &&
                    clean(model) == null) {
                  setState(
                    () => error =
                        'Enter at least one known identity detail to confirm.',
                  );
                  return;
                }
                setState(() {
                  saving = true;
                  error = null;
                });
                try {
                  await ref
                      .read(scanProvider.notifier)
                      .setOverride(
                        widget.device,
                        DeviceOverride(
                          userName: clean(name),
                          category: category,
                          manufacturer: clean(manufacturer),
                          model: clean(model),
                          confirmed: confirmed,
                        ),
                      );
                  if (context.mounted) Navigator.pop(context);
                } catch (_) {
                  if (mounted) {
                    setState(() {
                      saving = false;
                      error = 'Could not save correction. Please try again.';
                    });
                  }
                }
              },
        child: Text(saving ? 'Saving…' : 'Save correction'),
      ),
    ],
  );
}
