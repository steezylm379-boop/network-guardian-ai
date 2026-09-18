import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../diagnostics/domain/diagnostics_provider.dart';
import '../../network_scan/presentation/scan_controller.dart';
import '../domain/guardian_models.dart';
import '../domain/local_network_assistant.dart';
import '../domain/network_doctor.dart';
import '../domain/network_insight_engine.dart';

final guardianProvider = NotifierProvider<GuardianController, GuardianState>(
  GuardianController.new,
);

class GuardianState {
  const GuardianState({
    this.messages = const [],
    this.loadingHistory = false,
    this.answering = false,
    this.doctorRunning = false,
    this.doctor,
    this.error,
    this.loadedNetworkId,
  });

  final List<GuardianMessage> messages;
  final bool loadingHistory;
  final bool answering;
  final bool doctorRunning;
  final DoctorReport? doctor;
  final String? error;
  final String? loadedNetworkId;

  GuardianState copyWith({
    List<GuardianMessage>? messages,
    bool? loadingHistory,
    bool? answering,
    bool? doctorRunning,
    DoctorReport? doctor,
    bool clearDoctor = false,
    String? error,
    bool clearError = false,
    String? loadedNetworkId,
  }) => GuardianState(
    messages: messages ?? this.messages,
    loadingHistory: loadingHistory ?? this.loadingHistory,
    answering: answering ?? this.answering,
    doctorRunning: doctorRunning ?? this.doctorRunning,
    doctor: clearDoctor ? null : doctor ?? this.doctor,
    error: clearError ? null : error ?? this.error,
    loadedNetworkId: loadedNetworkId ?? this.loadedNetworkId,
  );
}

class GuardianController extends Notifier<GuardianState> {
  final assistant = const LocalNetworkAssistant();
  final insights = const NetworkInsightEngine();

  @override
  GuardianState build() {
    ref.listen<String?>(
      scanProvider.select((s) => s.networkId),
      (previous, next) {
        if (next == null) {
          state = const GuardianState();
        } else if (next != state.loadedNetworkId) {
          unawaited(_load(next));
        }
      },
    );
    final current = ref.read(scanProvider).networkId;
    if (current != null) {
      unawaited(Future.microtask(() => _load(current)));
    }
    return const GuardianState();
  }

  NetworkSnapshot snapshot() {
    final scan = ref.read(scanProvider);
    return NetworkSnapshot(
      networkId: scan.networkId,
      networkName: scan.network?.ssid ?? 'Local network',
      gateway: scan.network?.gateway,
      localIp: scan.network?.ip,
      cidr: scan.network?.subnet.cidr,
      devices: List.unmodifiable(scan.devices),
      lastCompletedScan: scan.lastScan,
    );
  }

  List<NetworkInsight> currentInsights() => insights.evaluate(snapshot());

  Future<void> _load(String networkId) async {
    state = state.copyWith(
      loadingHistory: true,
      loadedNetworkId: networkId,
      clearError: true,
    );
    try {
      final db = ref.read(databaseProvider);
      final messages = await db.loadGuardianMessages(networkId);
      final doctor = await db.latestDoctorReport(networkId);
      if (state.loadedNetworkId != networkId) return;
      state = state.copyWith(
        messages: messages,
        loadingHistory: false,
        doctor: doctor,
      );
    } catch (e) {
      state = state.copyWith(
        loadingHistory: false,
        error: _friendly(e),
      );
    }
  }

  Future<void> ask(String rawQuestion) async {
    final question = rawQuestion.trim();
    if (question.isEmpty || state.answering) return;
    final networkId = ref.read(scanProvider).networkId;
    final user = GuardianMessage(
      id: const Uuid().v4(),
      role: GuardianMessageRole.user,
      text: question,
      createdAt: DateTime.now(),
    );
    state = state.copyWith(
      messages: [...state.messages, user],
      answering: true,
      clearError: true,
    );
    if (networkId != null) {
      try {
        await ref.read(databaseProvider).saveGuardianMessage(networkId, user);
      } catch (_) {
        // A chat answer is still useful when local persistence temporarily fails.
      }
    }

    DoctorReport? report = state.doctor;
    if (_needsDoctor(question) && !state.doctorRunning) {
      report = await _runDoctor(silent: true);
    }

    try {
      final answer = assistant.answer(question, snapshot(), doctor: report);
      final response = GuardianMessage(
        id: const Uuid().v4(),
        role: GuardianMessageRole.assistant,
        text: answer.text,
        createdAt: DateTime.now(),
        confidence: answer.confidence,
        evidence: answer.evidence,
        intent: answer.intent,
      );
      state = state.copyWith(
        messages: [...state.messages, response],
        answering: false,
      );
      if (networkId != null) {
        try {
          await ref.read(databaseProvider).saveGuardianMessage(networkId, response);
        } catch (_) {
          state = state.copyWith(error: 'The answer was generated, but local chat history could not be saved.');
        }
      }
    } catch (e) {
      state = state.copyWith(answering: false, error: _friendly(e));
    }
  }

  Future<DoctorReport?> runDoctor() => _runDoctor(silent: false);

  Future<DoctorReport?> _runDoctor({required bool silent}) async {
    if (state.doctorRunning) return state.doctor;
    state = state.copyWith(doctorRunning: true, clearError: true);
    try {
      final doctor = NetworkDoctorService(ref.read(diagnosticsProvider));
      final report = await doctor.run(snapshot());
      state = state.copyWith(doctorRunning: false, doctor: report);
      final networkId = ref.read(scanProvider).networkId;
      if (networkId != null) {
        try {
          await ref.read(databaseProvider).saveDoctorReport(networkId, report);
        } catch (_) {
          if (!silent) {
            state = state.copyWith(error: 'Diagnosis finished, but the report could not be saved locally.');
          }
        }
      }
      return report;
    } catch (e) {
      state = state.copyWith(doctorRunning: false, error: _friendly(e));
      return null;
    }
  }

  Future<void> clearConversation() async {
    final networkId = ref.read(scanProvider).networkId;
    if (networkId == null) {
      state = state.copyWith(messages: const []);
      return;
    }
    try {
      await ref.read(databaseProvider).clearGuardianMessages(networkId);
      state = state.copyWith(messages: const [], loadedNetworkId: networkId);
    } catch (e) {
      state = state.copyWith(error: _friendly(e));
    }
  }

  bool _needsDoctor(String value) {
    final q = value.toLowerCase();
    return ['slow', 'lag', 'latency', 'internet problem', 'wifi problem', 'wi-fi problem', 'connection problem']
        .any(q.contains);
  }

  String _friendly(Object error) => error.toString().replaceAll('Exception: ', '');
}
