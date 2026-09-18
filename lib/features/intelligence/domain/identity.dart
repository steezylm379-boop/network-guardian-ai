import 'dart:convert';
import 'package:uuid/uuid.dart';

enum DeviceCategory {
  router,
  modem,
  accessPoint,
  networkSwitch,
  repeater,
  networkInfrastructure,
  phone,
  tablet,
  laptop,
  desktop,
  computer,
  server,
  nas,
  printer,
  television,
  streamingDevice,
  mediaServer,
  gameConsole,
  camera,
  nvr,
  smartSpeaker,
  smartHome,
  iot,
  voipPhone,
  posTerminal,
  unknown,
}

enum ConfidenceLevel { confirmed, high, medium, low, unknown }

class StableIdentifier {
  StableIdentifier({
    String? id,
    required this.deviceId,
    required this.type,
    required this.value,
    required this.source,
    required this.stability,
    DateTime? firstSeen,
    DateTime? lastSeen,
    this.isUserConfirmed = false,
  }) : id = id ?? const Uuid().v4(),
       firstSeen = firstSeen ?? DateTime.now(),
       lastSeen = lastSeen ?? DateTime.now();
  final String id;
  String deviceId;
  final String type, value, source;
  final int stability;
  DateTime firstSeen, lastSeen;
  bool isUserConfirmed;
  String get signature => '$type:$value';
  bool get strong => stability >= 80;
  static bool isPrivateMac(String mac) =>
      (int.parse(mac.substring(0, 2), radix: 16) & 2) != 0;
  static String? normalize(String type, String raw) {
    var value = raw.trim();
    if (value.isEmpty ||
        value.length > 512 ||
        value.contains(RegExp(r'[\x00-\x1f]'))) {
      return null;
    }
    if (type == 'mac') {
      value = value.replaceAll('-', ':').toUpperCase();
      if (!RegExp(r'^([0-9A-F]{2}:){5}[0-9A-F]{2}$').hasMatch(value) ||
          value == '00:00:00:00:00:00' ||
          value == '02:00:00:00:00:00' ||
          (int.parse(value.substring(0, 2), radix: 16) & 1) != 0) {
        return null;
      }
    } else if (type == 'upnp_udn') {
      value = value.toLowerCase().split('::').first;
      if (!RegExp(r'^uuid:[a-z0-9][a-z0-9._:-]{3,127}$').hasMatch(value)) {
        return null;
      }
    } else if (type == 'hostname') {
      value = value.toLowerCase().replaceFirst(RegExp(r'\.$'), '');
    }
    return value;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'deviceId': deviceId,
    'type': type,
    'value': value,
    'source': source,
    'stability': stability,
    'firstSeen': firstSeen.toIso8601String(),
    'lastSeen': lastSeen.toIso8601String(),
    'confirmed': isUserConfirmed,
  };
  factory StableIdentifier.fromJson(Map<String, dynamic> j) => StableIdentifier(
    id: j['id'],
    deviceId: j['deviceId'],
    type: j['type'],
    value: j['value'],
    source: j['source'],
    stability: j['stability'],
    firstSeen: DateTime.parse(j['firstSeen']),
    lastSeen: DateTime.parse(j['lastSeen']),
    isUserConfirmed: j['confirmed'] ?? false,
  );
}

class IdentityEvidence {
  IdentityEvidence({
    String? id,
    required this.deviceId,
    required this.source,
    required this.key,
    required this.value,
    required this.weight,
    DateTime? firstSeen,
    DateTime? lastSeen,
    this.expiresAt,
    this.observationCount = 1,
    this.observationId,
    Map<String, dynamic>? metadata,
  }) : id = id ?? const Uuid().v4(),
       firstSeen = firstSeen ?? DateTime.now(),
       lastSeen = lastSeen ?? DateTime.now(),
       metadata = metadata ?? {};
  final String id;
  String deviceId;
  final String source, key, value;
  final int weight;
  DateTime firstSeen, lastSeen;
  DateTime? expiresAt;
  int observationCount;
  String? observationId;
  final Map<String, dynamic> metadata;
  String get normalizedValue =>
      source == 'mdns_raw' ? value.trim() : value.trim().toLowerCase();
  String get signature =>
      jsonEncode([source, key, normalizedValue, metadata['scope']]);
  bool activeAt(DateTime now) => expiresAt == null || expiresAt!.isAfter(now);
  Map<String, dynamic> toJson() => {
    'id': id,
    'deviceId': deviceId,
    'source': source,
    'key': key,
    'value': value,
    'normalizedValue': normalizedValue,
    'weight': weight,
    'firstSeen': firstSeen.toIso8601String(),
    'lastSeen': lastSeen.toIso8601String(),
    'expiresAt': expiresAt?.toIso8601String(),
    'count': observationCount,
    'observationId': observationId,
    'metadata': metadata,
  };
  factory IdentityEvidence.fromJson(Map<String, dynamic> j) => IdentityEvidence(
    id: j['id'],
    deviceId: j['deviceId'],
    source: j['source'],
    key: j['key'],
    value: j['value'],
    weight: j['weight'],
    firstSeen: DateTime.parse(j['firstSeen']),
    lastSeen: DateTime.parse(j['lastSeen']),
    expiresAt: j['expiresAt'] == null ? null : DateTime.parse(j['expiresAt']),
    observationCount: j['count'] ?? 1,
    observationId: j['observationId'],
    metadata: Map<String, dynamic>.from(j['metadata'] ?? {}),
  );
}

class DeviceOverride {
  DeviceOverride({
    this.userName,
    this.category,
    this.manufacturer,
    this.model,
    this.confirmed = false,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();
  final String? userName, manufacturer, model;
  final DeviceCategory? category;
  final bool confirmed;
  final DateTime updatedAt;
  bool get confirmsIdentity =>
      confirmed &&
      ((category != null && category != DeviceCategory.unknown) ||
          manufacturer?.trim().isNotEmpty == true ||
          model?.trim().isNotEmpty == true);
  Map<String, dynamic> toJson() => {
    'userName': userName,
    'category': category?.name,
    'manufacturer': manufacturer,
    'model': model,
    'confirmed': confirmed,
    'updatedAt': updatedAt.toIso8601String(),
  };
  factory DeviceOverride.fromJson(Map<String, dynamic> j) => DeviceOverride(
    userName: j['userName'],
    category: j['category'] == null
        ? null
        : DeviceCategory.values.byName(j['category']),
    manufacturer: j['manufacturer'],
    model: j['model'],
    confirmed: j['confirmed'] ?? false,
    updatedAt: DateTime.parse(j['updatedAt']),
  );
}

class DeviceClassification {
  const DeviceClassification({
    this.category = DeviceCategory.unknown,
    this.manufacturer,
    this.model,
    this.score = 0,
    this.level = ConfidenceLevel.unknown,
    this.reasons = const [],
    this.conflicts = const [],
    this.manufacturerCandidates = const {},
    this.categoryCandidates = const {},
    this.modelCandidates = const {},
  });
  final DeviceCategory category;
  final String? manufacturer, model;
  final int score;
  final ConfidenceLevel level;
  final List<String> reasons, conflicts;
  final Map<String, int> manufacturerCandidates,
      categoryCandidates,
      modelCandidates;
  Map<String, dynamic> toJson() => {
    'category': category.name,
    'manufacturer': manufacturer,
    'model': model,
    'score': score,
    'level': level.name,
    'reasons': reasons,
    'conflicts': conflicts,
    'manufacturerCandidates': manufacturerCandidates,
    'categoryCandidates': categoryCandidates,
    'modelCandidates': modelCandidates,
  };
  factory DeviceClassification.fromJson(Map<String, dynamic> j) =>
      DeviceClassification(
        category: DeviceCategory.values.byName(j['category']),
        manufacturer: j['manufacturer'],
        model: j['model'],
        score: j['score'],
        level: ConfidenceLevel.values.byName(j['level']),
        reasons: List<String>.from(j['reasons']),
        conflicts: List<String>.from(j['conflicts']),
        manufacturerCandidates: Map<String, int>.from(
          j['manufacturerCandidates'] ?? {},
        ),
        categoryCandidates: Map<String, int>.from(
          j['categoryCandidates'] ?? {},
        ),
        modelCandidates: Map<String, int>.from(j['modelCandidates'] ?? {}),
      );
}

class DeviceFingerprint {
  DeviceFingerprint(this.deviceId);
  String deviceId;
  final List<StableIdentifier> identifiers = [];
  final List<IdentityEvidence> evidence = [];
  final Map<String, String> possibleSameDevices = {};
  DeviceClassification classification = const DeviceClassification();
  DeviceOverride? override;
  DateTime? lastEvaluated, nextExpiry;
  bool dirty = true;
  void applyOverride(DeviceOverride? value) {
    override = value;
    evidence.removeWhere((e) => e.source == 'user');
    identifiers.removeWhere((i) => i.type == 'user_identity');
    if (value != null) {
      for (final field in <String, String?>{
        'name': value.userName,
        'category': value.category?.name,
        'manufacturer': value.manufacturer,
        'model': value.model,
      }.entries) {
        if (field.value == null || field.value!.trim().isEmpty) continue;
        addEvidence(
          IdentityEvidence(
            deviceId: deviceId,
            source: 'user',
            key: field.key,
            value: field.value!,
            weight: 100,
            firstSeen: value.updatedAt,
            lastSeen: value.updatedAt,
            observationId: value.updatedAt.toIso8601String(),
            metadata: {'confirmed': value.confirmed},
          ),
        );
      }
      if (value.confirmsIdentity) {
        identify(
          StableIdentifier(
            deviceId: deviceId,
            type: 'user_identity',
            value: deviceId,
            source: 'user',
            stability: 100,
            firstSeen: value.updatedAt,
            lastSeen: value.updatedAt,
            isUserConfirmed: true,
          ),
        );
      }
    }
    dirty = true;
  }

  void addEvidence(IdentityEvidence item) {
    item.deviceId = deviceId;
    final existing = evidence
        .where((e) => e.signature == item.signature)
        .firstOrNull;
    if (existing == null) {
      evidence.add(item);
    } else {
      if (item.firstSeen.isBefore(existing.firstSeen)) {
        existing.firstSeen = item.firstSeen;
      }
      if (!item.lastSeen.isBefore(existing.lastSeen)) {
        if (existing.observationId != item.observationId) {
          existing.observationCount += item.observationCount;
        }
        existing.lastSeen = item.lastSeen;
        existing.expiresAt = item.expiresAt;
        existing.observationId = item.observationId;
      }
    }
    dirty = true;
  }

  void identify(StableIdentifier item) {
    item.deviceId = deviceId;
    final existing = identifiers
        .where((i) => i.signature == item.signature)
        .firstOrNull;
    if (existing == null) {
      identifiers.add(item);
    } else {
      if (item.firstSeen.isBefore(existing.firstSeen)) {
        existing.firstSeen = item.firstSeen;
      }
      if (item.lastSeen.isAfter(existing.lastSeen)) {
        existing.lastSeen = item.lastSeen;
      }
      existing.isUserConfirmed |= item.isUserConfirmed;
    }
    dirty = true;
  }

  void absorb(DeviceFingerprint other) {
    for (final e in other.evidence) {
      addEvidence(IdentityEvidence.fromJson({...e.toJson(), 'id': null}));
    }
    for (final i in other.identifiers) {
      identify(StableIdentifier.fromJson({...i.toJson(), 'id': null}));
    }
    override ??= other.override;
    possibleSameDevices.addAll(other.possibleSameDevices);
    possibleSameDevices.remove(deviceId);
  }

  Map<String, dynamic> toJson() => {
    'deviceId': deviceId,
    'identifiers': identifiers.map((i) => i.toJson()).toList(),
    'evidence': evidence.map((e) => e.toJson()).toList(),
    'classification': classification.toJson(),
    'override': override?.toJson(),
    'possibleSameDevices': possibleSameDevices,
    'lastEvaluated': lastEvaluated?.toIso8601String(),
    'nextExpiry': nextExpiry?.toIso8601String(),
  };
  factory DeviceFingerprint.fromJson(Map<String, dynamic> j) {
    final result = DeviceFingerprint(j['deviceId']);
    result.identifiers.addAll(
      (j['identifiers'] as List? ?? []).map(
        (e) => StableIdentifier.fromJson(Map<String, dynamic>.from(e)),
      ),
    );
    result.evidence.addAll(
      (j['evidence'] as List? ?? []).map(
        (e) => IdentityEvidence.fromJson(Map<String, dynamic>.from(e)),
      ),
    );
    if (j['classification'] != null) {
      result.classification = DeviceClassification.fromJson(
        Map<String, dynamic>.from(j['classification']),
      );
    }
    if (j['override'] != null) {
      result.override = DeviceOverride.fromJson(
        Map<String, dynamic>.from(j['override']),
      );
    }
    result.possibleSameDevices.addAll(
      Map<String, String>.from(j['possibleSameDevices'] ?? {}),
    );
    result.lastEvaluated = DateTime.tryParse(j['lastEvaluated'] ?? '');
    result.nextExpiry = DateTime.tryParse(j['nextExpiry'] ?? '');
    return result;
  }
}
