import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/components.dart';
import '../../network_scan/presentation/scan_controller.dart';
import '../domain/guardian_models.dart';
import 'guardian_controller.dart';

class GuardianScreen extends ConsumerStatefulWidget {
  const GuardianScreen({super.key});
  @override
  ConsumerState<GuardianScreen> createState() => _GuardianScreenState();
}

class _GuardianScreenState extends ConsumerState<GuardianScreen> {
  final input = TextEditingController();
  final scroll = ScrollController();

  @override
  void dispose() {
    input.dispose();
    scroll.dispose();
    super.dispose();
  }

  Future<void> send([String? preset]) async {
    final text = (preset ?? input.text).trim();
    if (text.isEmpty) return;
    input.clear();
    await ref.read(guardianProvider.notifier).ask(text);
    if (mounted) {
      await Future<void>.delayed(const Duration(milliseconds: 80));
      if (scroll.hasClients) {
        scroll.animateTo(
          scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final guardian = ref.watch(guardianProvider);
    final scan = ref.watch(scanProvider);
    final controller = ref.read(guardianProvider.notifier);
    final insights = controller.currentInsights();

    return Shell(
      title: 'Guardian AI',
      index: 2,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              controller: scroll,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
              children: [
                Text('ASK YOUR NETWORK', style: TextStyle(color: accent, fontSize: 11, letterSpacing: 2)),
                const SizedBox(height: 10),
                Text('Answers grounded in your network.', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(
                  'Phase 3 reads local device history, identity evidence and measured diagnostics. It does not invent telemetry or upload your network to a cloud model.',
                  style: TextStyle(color: muted(context), height: 1.5),
                ),
                const SizedBox(height: 18),
                _DoctorCard(
                  report: guardian.doctor,
                  running: guardian.doctorRunning,
                  enabled: scan.network != null,
                  onRun: controller.runDoctor,
                ),
                Surface(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('GUARDIAN INSIGHTS', style: TextStyle(fontSize: 11, letterSpacing: 1.4)),
                      const SizedBox(height: 8),
                      for (final item in insights)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(_insightIcon(item.severity), color: _insightColor(context, item.severity)),
                          title: Text(item.title),
                          subtitle: Text(item.body, style: TextStyle(color: muted(context), height: 1.4)),
                          onTap: item.deviceId == null ? null : () => context.push('/device/${item.deviceId}'),
                        ),
                    ],
                  ),
                ),
                if (guardian.messages.isEmpty) ...[
                  const SizedBox(height: 4),
                  const Text('TRY ASKING', style: TextStyle(fontSize: 11, letterSpacing: 1.4)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final text in const [
                        'What is connected right now?',
                        'Who joined recently?',
                        'Which devices are unknown?',
                        'Are there any camera-like devices?',
                        'What changed recently?',
                        'Why is my network slow?',
                      ])
                        ActionChip(label: Text(text), onPressed: guardian.answering ? null : () => send(text)),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
                if (guardian.loadingHistory)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                for (final message in guardian.messages) _MessageBubble(message: message),
                if (guardian.answering)
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: SizedBox(width: 26, height: 26, child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                  ),
                if (guardian.error != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(guardian.error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  ),
                if (guardian.messages.isNotEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: guardian.answering ? null : controller.clearConversation,
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('CLEAR LOCAL CONVERSATION'),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: .45))),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: input,
                    enabled: !guardian.answering,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => send(),
                    decoration: const InputDecoration(
                      hintText: 'Ask about your network…',
                      prefixIcon: Icon(Icons.auto_awesome_outlined),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filled(
                  onPressed: guardian.answering ? null : send,
                  icon: const Icon(Icons.arrow_upward_rounded),
                  tooltip: 'Ask Guardian',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});
  final GuardianMessage message;

  @override
  Widget build(BuildContext context) {
    final user = message.role == GuardianMessageRole.user;
    return Align(
      alignment: user ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 640),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: user
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: user ? null : Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: .5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.text, style: const TextStyle(height: 1.5)),
            if (!user && message.confidence != null) ...[
              const SizedBox(height: 10),
              Text('GROUNDING ${message.confidence}/100', style: TextStyle(fontSize: 10, letterSpacing: 1.2, color: muted(context, .48))),
            ],
            if (!user && message.evidence.isNotEmpty) ...[
              const SizedBox(height: 10),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                childrenPadding: EdgeInsets.zero,
                title: Text('Evidence · ${message.evidence.length}', style: const TextStyle(fontSize: 13)),
                children: [
                  for (final evidence in message.evidence.take(12))
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(evidence.label),
                      subtitle: Text(evidence.value),
                      trailing: evidence.deviceId == null
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.open_in_new, size: 17),
                              onPressed: () => context.push('/device/${evidence.deviceId}'),
                            ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  const _DoctorCard({required this.report, required this.running, required this.enabled, required this.onRun});
  final DoctorReport? report;
  final bool running, enabled;
  final Future<DoctorReport?> Function() onRun;

  @override
  Widget build(BuildContext context) => Surface(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('AI NETWORK DOCTOR', style: TextStyle(fontSize: 11, letterSpacing: 1.4)),
        const SizedBox(height: 12),
        Text(report?.headline ?? 'Diagnose the connection path', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text(
          report?.summary ?? 'Checks the local gateway response, Android Internet validation, DNS configuration and freshness of the device picture.',
          style: TextStyle(color: muted(context), height: 1.5),
        ),
        if (report != null) ...[
          const SizedBox(height: 14),
          for (final check in report!.checks)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(_doctorIcon(check.status), size: 18, color: _doctorColor(context, check.status)),
                  const SizedBox(width: 10),
                  Expanded(child: Text('${check.label}: ${check.summary}', style: const TextStyle(height: 1.35))),
                ],
              ),
            ),
        ],
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: !enabled || running ? null : onRun,
          icon: running
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.health_and_safety_outlined),
          label: Text(running ? 'DIAGNOSING…' : 'DIAGNOSE MY NETWORK'),
        ),
      ],
    ),
  );
}

IconData _insightIcon(InsightSeverity value) => switch (value) {
  InsightSeverity.info => Icons.auto_awesome_outlined,
  InsightSeverity.attention => Icons.visibility_outlined,
  InsightSeverity.warning => Icons.warning_amber_rounded,
};

Color _insightColor(BuildContext context, InsightSeverity value) => switch (value) {
  InsightSeverity.info => accent,
  InsightSeverity.attention => Theme.of(context).colorScheme.tertiary,
  InsightSeverity.warning => Theme.of(context).colorScheme.error,
};

IconData _doctorIcon(DoctorStatus status) => switch (status) {
  DoctorStatus.healthy => Icons.check_circle_outline,
  DoctorStatus.notice => Icons.info_outline,
  DoctorStatus.warning => Icons.warning_amber_rounded,
  DoctorStatus.critical => Icons.error_outline,
  DoctorStatus.unavailable => Icons.help_outline,
};

Color _doctorColor(BuildContext context, DoctorStatus status) => switch (status) {
  DoctorStatus.healthy => accent,
  DoctorStatus.notice => Theme.of(context).colorScheme.secondary,
  DoctorStatus.warning => Theme.of(context).colorScheme.tertiary,
  DoctorStatus.critical => Theme.of(context).colorScheme.error,
  DoctorStatus.unavailable => muted(context),
};
