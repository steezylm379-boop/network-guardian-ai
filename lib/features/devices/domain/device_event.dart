enum DeviceEventType {
  discovered,
  online,
  offline,
  ipChanged,
  hostnameChanged,
  manufacturerIdentified,
  typeIdentified,
  modelIdentified,
  confidenceChanged,
  servicesChanged,
  trustChanged,
  correctionChanged,
}

class DeviceEvent {
  DeviceEvent({
    required this.type,
    required this.message,
    DateTime? at,
    this.scanId,
    Map<String, dynamic>? metadata,
  }) : at = at ?? DateTime.now(), metadata = metadata ?? {};

  final DeviceEventType type;
  final String message;
  final DateTime at;
  final String? scanId;
  final Map<String, dynamic> metadata;

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'message': message,
    'at': at.toIso8601String(),
    'scanId': scanId,
    'metadata': metadata,
  };

  factory DeviceEvent.fromJson(Map<String, dynamic> json) => DeviceEvent(
    type: DeviceEventType.values.byName(json['type'] as String),
    message: json['message'] as String,
    at: DateTime.parse(json['at'] as String),
    scanId: json['scanId'] as String?,
    metadata: Map<String, dynamic>.from(json['metadata'] ?? const {}),
  );
}
