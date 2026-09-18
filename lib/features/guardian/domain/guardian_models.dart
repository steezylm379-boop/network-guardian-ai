import '../../devices/domain/device.dart';

/// Phase 3 is intentionally grounded in locally observed telemetry. These
/// evidence records are rendered with every assistant answer so a human can
/// inspect why a conclusion was made.
class GuardianEvidence {
  const GuardianEvidence({
    required this.label,
    required this.value,
    this.deviceId,
    this.kind = 'telemetry',
  });

  final String label;
  final String value;
  final String? deviceId;
  final String kind;

  Map<String, dynamic> toJson() => {
    'label': label,
    'value': value,
    'deviceId': deviceId,
    'kind': kind,
  };

  factory GuardianEvidence.fromJson(Map<String, dynamic> json) =>
      GuardianEvidence(
        label: json['label']?.toString() ?? 'Evidence',
        value: json['value']?.toString() ?? '',
        deviceId: json['deviceId']?.toString(),
        kind: json['kind']?.toString() ?? 'telemetry',
      );
}

enum GuardianMessageRole { user, assistant, system }

class GuardianMessage {
  GuardianMessage({
    required this.id,
    required this.role,
    required this.text,
    required this.createdAt,
    this.confidence,
    this.evidence = const [],
    this.intent,
  });

  final String id;
  final GuardianMessageRole role;
  final String text;
  final DateTime createdAt;
  final int? confidence;
  final List<GuardianEvidence> evidence;
  final String? intent;

  Map<String, dynamic> toJson() => {
    'id': id,
    'role': role.name,
    'text': text,
    'createdAt': createdAt.toIso8601String(),
    'confidence': confidence,
    'evidence': evidence.map((e) => e.toJson()).toList(),
    'intent': intent,
  };

  factory GuardianMessage.fromJson(Map<String, dynamic> json) =>
      GuardianMessage(
        id: json['id'] as String,
        role: GuardianMessageRole.values.byName(json['role'] as String),
        text: json['text'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        confidence: json['confidence'] as int?,
        evidence: (json['evidence'] as List? ?? const [])
            .map((e) => GuardianEvidence.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        intent: json['intent'] as String?,
      );
}

class GuardianAnswer {
  const GuardianAnswer({
    required this.text,
    required this.confidence,
    required this.intent,
    this.evidence = const [],
    this.suggestedQuestions = const [],
  });

  final String text;
  final int confidence;
  final String intent;
  final List<GuardianEvidence> evidence;
  final List<String> suggestedQuestions;
}

enum InsightSeverity { info, attention, warning }

class NetworkInsight {
  const NetworkInsight({
    required this.id,
    required this.title,
    required this.body,
    required this.severity,
    this.deviceId,
  });

  final String id;
  final String title;
  final String body;
  final InsightSeverity severity;
  final String? deviceId;
}

enum DoctorStatus { healthy, notice, warning, critical, unavailable }

class DoctorCheck {
  const DoctorCheck({
    required this.id,
    required this.label,
    required this.status,
    required this.summary,
    this.detail,
    this.measuredValue,
  });

  final String id;
  final String label;
  final DoctorStatus status;
  final String summary;
  final String? detail;
  final String? measuredValue;

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'status': status.name,
    'summary': summary,
    'detail': detail,
    'measuredValue': measuredValue,
  };

  factory DoctorCheck.fromJson(Map<String, dynamic> json) => DoctorCheck(
    id: json['id'] as String,
    label: json['label'] as String,
    status: DoctorStatus.values.byName(json['status'] as String),
    summary: json['summary'] as String,
    detail: json['detail'] as String?,
    measuredValue: json['measuredValue'] as String?,
  );
}

class DoctorReport {
  const DoctorReport({
    required this.createdAt,
    required this.status,
    required this.headline,
    required this.summary,
    required this.checks,
    required this.recommendations,
    required this.limitations,
  });

  final DateTime createdAt;
  final DoctorStatus status;
  final String headline;
  final String summary;
  final List<DoctorCheck> checks;
  final List<String> recommendations;
  final List<String> limitations;

  Map<String, dynamic> toJson() => {
    'createdAt': createdAt.toIso8601String(),
    'status': status.name,
    'headline': headline,
    'summary': summary,
    'checks': checks.map((e) => e.toJson()).toList(),
    'recommendations': recommendations,
    'limitations': limitations,
  };

  factory DoctorReport.fromJson(Map<String, dynamic> json) => DoctorReport(
    createdAt: DateTime.parse(json['createdAt'] as String),
    status: DoctorStatus.values.byName(json['status'] as String),
    headline: json['headline'] as String,
    summary: json['summary'] as String,
    checks: (json['checks'] as List? ?? const [])
        .map((e) => DoctorCheck.fromJson(Map<String, dynamic>.from(e)))
        .toList(),
    recommendations: List<String>.from(json['recommendations'] ?? const []),
    limitations: List<String>.from(json['limitations'] ?? const []),
  );
}

class NetworkSnapshot {
  const NetworkSnapshot({
    required this.networkId,
    required this.networkName,
    required this.gateway,
    required this.localIp,
    required this.cidr,
    required this.devices,
    required this.lastCompletedScan,
  });

  final String? networkId;
  final String networkName;
  final String? gateway;
  final String? localIp;
  final String? cidr;
  final List<Device> devices;
  final DateTime? lastCompletedScan;

  int get onlineCount => devices.where((d) => d.isOnline).length;
  int get unknownCount => devices.where((d) => d.trustState == DeviceTrustState.unknown).length;
}
