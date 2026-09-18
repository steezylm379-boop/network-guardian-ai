import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'guardian_models.dart';

/// Contract for an enterprise AI gateway. The mobile app must never ship a
/// vendor model API secret. Production deployments authenticate to a
/// company-controlled backend which can enforce retention, redaction, tenancy,
/// rate limits, audit policy and model selection.
abstract interface class EnterpriseAiGateway {
  Future<GuardianAnswer> narrate({
    required String question,
    required NetworkSnapshot snapshot,
    DoctorReport? doctor,
  });
}

class AiPrivacyPolicy {
  const AiPrivacyPolicy({
    this.includeNetworkName = false,
    this.includeRawIp = false,
    this.includeRawMac = false,
    this.includeFriendlyNames = false,
  });
  final bool includeNetworkName;
  final bool includeRawIp;
  final bool includeRawMac;
  final bool includeFriendlyNames;

  Map<String, dynamic> sanitize(NetworkSnapshot snapshot) {
    return {
      'network': {
        'name': includeNetworkName ? snapshot.networkName : null,
        'cidr': includeRawIp ? snapshot.cidr : null,
        'deviceCount': snapshot.devices.length,
        'onlineCount': snapshot.onlineCount,
        'hasGateway': snapshot.gateway != null,
        'lastCompletedScan': snapshot.lastCompletedScan?.toIso8601String(),
      },
      'devices': [
        for (var i = 0; i < snapshot.devices.length; i++)
          {
            'id': 'device_${i + 1}',
            'displayName': includeFriendlyNames ? snapshot.devices[i].fingerprint.override?.userName : null,
            'ip': includeRawIp ? snapshot.devices[i].ipAddress : null,
            'mac': includeRawMac ? snapshot.devices[i].macAddress : null,
            'category': snapshot.devices[i].fingerprint.classification.category.name,
            'manufacturer': snapshot.devices[i].fingerprint.classification.manufacturer,
            'model': snapshot.devices[i].fingerprint.classification.model,
            'confidence': snapshot.devices[i].fingerprint.classification.score,
            'online': snapshot.devices[i].isOnline,
            'trusted': snapshot.devices[i].trustState.name == 'trusted',
            'serviceTypes': snapshot.devices[i].services
                .map((s) => s['type']?.toString())
                .whereType<String>()
                .toSet()
                .take(12)
                .toList(),
          },
      ],
    };
  }
}

/// Optional HTTPS client for a company-owned AI gateway. It is deliberately
/// not wired into the default Phase 3 UI until the deploying organization
/// provides an endpoint, authentication flow and data policy.
class HttpEnterpriseAiGateway implements EnterpriseAiGateway {
  HttpEnterpriseAiGateway({
    required this.endpoint,
    required this.accessToken,
    this.privacy = const AiPrivacyPolicy(),
    HttpClient? client,
  }) : _client = client ?? HttpClient();

  final Uri endpoint;
  final Future<String?> Function() accessToken;
  final AiPrivacyPolicy privacy;
  final HttpClient _client;

  @override
  Future<GuardianAnswer> narrate({
    required String question,
    required NetworkSnapshot snapshot,
    DoctorReport? doctor,
  }) async {
    if (endpoint.scheme != 'https') {
      throw StateError('Enterprise AI gateway must use HTTPS.');
    }
    final token = await accessToken();
    if (token == null || token.trim().isEmpty) {
      throw StateError('Enterprise AI gateway authentication is unavailable.');
    }
    final request = await _client.postUrl(endpoint).timeout(const Duration(seconds: 8));
    request.followRedirects = false;
    request.headers.contentType = ContentType.json;
    request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
    request.headers.set('X-Guardian-Protocol', 'phase3-v1');
    request.write(jsonEncode({
      'question': question,
      'context': privacy.sanitize(snapshot),
      'doctor': doctor?.toJson(),
      'policy': {
        'groundedOnly': true,
        'noInventedTelemetry': true,
        'returnEvidence': true,
      },
    }));
    final response = await request.close().timeout(const Duration(seconds: 12));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      await response.drain<void>();
      throw HttpException('Enterprise AI gateway returned HTTP ${response.statusCode}.');
    }
    final body = await utf8.decoder.bind(response).join();
    final json = jsonDecode(body);
    if (json is! Map) throw const FormatException('Invalid AI gateway response.');
    final map = Map<String, dynamic>.from(json);
    final text = map['answer']?.toString().trim();
    if (text == null || text.isEmpty) throw const FormatException('AI gateway returned no answer.');
    final evidence = (map['evidence'] as List? ?? const [])
        .whereType<Map>()
        .map((e) => GuardianEvidence.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return GuardianAnswer(
      text: text,
      confidence: ((map['confidence'] as num?)?.toInt() ?? 70).clamp(0, 100).toInt(),
      intent: map['intent']?.toString() ?? 'enterprise_ai',
      evidence: evidence,
      suggestedQuestions: List<String>.from(map['suggestedQuestions'] ?? const []),
    );
  }

  void close() => _client.close(force: true);
}
