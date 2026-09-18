import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_guardian_ai/core/database/app_database.dart';
import 'package:network_guardian_ai/features/guardian/domain/guardian_models.dart';

void main() {
  test('Phase 3 chat and doctor reports persist locally', () async {
    final db = AppDatabase.testing(NativeDatabase.memory());
    addTearDown(db.close);
    final message = GuardianMessage(
      id: 'm1',
      role: GuardianMessageRole.assistant,
      text: 'Grounded answer',
      createdAt: DateTime(2026, 9, 15),
      confidence: 91,
      evidence: const [GuardianEvidence(label: 'Online', value: '3')],
      intent: 'overview',
    );
    await db.saveGuardianMessage('network', message);
    final loaded = await db.loadGuardianMessages('network');
    expect(loaded.single.text, 'Grounded answer');
    expect(loaded.single.evidence.single.value, '3');

    final report = DoctorReport(
      createdAt: DateTime(2026, 9, 15, 1),
      status: DoctorStatus.healthy,
      headline: 'Healthy',
      summary: 'No obvious fault.',
      checks: const [],
      recommendations: const ['Keep monitoring.'],
      limitations: const ['No bandwidth telemetry.'],
    );
    await db.saveDoctorReport('network', report);
    expect((await db.latestDoctorReport('network'))?.headline, 'Healthy');
  });
}
