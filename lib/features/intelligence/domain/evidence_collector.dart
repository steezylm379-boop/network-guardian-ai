import 'dart:convert';
import '../../devices/domain/device.dart';
import 'identity.dart';

class EvidenceCollector {
  void collect(
    Device d,
    Map<String, dynamic> observation,
    String observationId, {
    DateTime? observedAt,
  }) {
    final now = observedAt ?? DateTime.now();
    final fp = d.fingerprint;
    void add(
      String source,
      String key,
      Object? raw,
      int weight,
      int? days, {
      Map<String, dynamic>? metadata,
    }) {
      if (raw == null || raw.toString().trim().isEmpty) return;
      final value = raw.toString();
      if (value.length > 8192) return;
      fp.addEvidence(
        IdentityEvidence(
          deviceId: d.id,
          source: source,
          key: key,
          value: value,
          weight: weight,
          firstSeen: now,
          lastSeen: now,
          expiresAt: days == null ? null : now.add(Duration(days: days)),
          observationId: observationId,
          metadata: metadata,
        ),
      );
    }

    void identifier(String type, Object? raw, String source, int stability) {
      if (raw == null) return;
      final value = StableIdentifier.normalize(type, raw.toString());
      if (value == null) return;
      fp.identify(
        StableIdentifier(
          deviceId: d.id,
          type: type,
          value: value,
          source: source,
          stability: stability,
          firstSeen: now,
          lastSeen: now,
        ),
      );
    }

    add('location', 'ip', d.ipAddress, 0, 1);
    if (d.isGateway) add('network', 'gateway', 'true', 85, 1);
    final mac = StableIdentifier.normalize('mac', d.macAddress ?? '');
    if (mac != null) {
      final private = StableIdentifier.isPrivateMac(mac);
      identifier('mac', mac, 'arp', private ? 35 : 85);
      add('arp', 'mac', mac, private ? 35 : 85, private ? 1 : 30);
      add('arp', 'privateMac', private, 0, 30);
      if (!private) add('oui', 'manufacturer', d.vendor, 70, 30);
    }
    add('dns', 'hostname', d.hostname, 20, 7);
    identifier('hostname', d.hostname, 'dns', 25);
    add('mdns', 'instanceName', d.mdnsName, 10, 3);
    final service = observation['service'];
    if (service is Map) {
      final type =
          service['type']?.toString().toLowerCase().replaceFirst(
            RegExp(r'\.$'),
            '',
          ) ??
          '';
      add('mdns', 'service', type, 60, 3, metadata: {'scope': type});
      final attributes = service['attributes'];
      if (attributes is Map) {
        for (final item in attributes.entries) {
          final key = item.key.toString().toLowerCase();
          final raw = item.value.toString();
          add(
            'mdns_raw',
            key,
            raw,
            0,
            7,
            metadata: {'scope': type, 'encoding': 'base64'},
          );
          try {
            final decoded = utf8.decode(
              base64Decode(raw),
              allowMalformed: false,
            );
            if (decoded.contains(RegExp(r'[\x00-\x08\x0b\x0c\x0e-\x1f]')) ||
                decoded.length > 1024) {
              continue;
            }
            add(
              'mdns_txt',
              key,
              decoded,
              ['model', 'am', 'md', 'ty', 'product'].contains(key) ? 75 : 35,
              7,
              metadata: {'scope': type},
            );
            if (type == '_airplay._tcp' && key == 'deviceid') {
              final value = StableIdentifier.normalize('mac', decoded);
              if (value != null) {
                identifier(
                  'mdns_identity',
                  '$type:$value',
                  'mdns_txt',
                  StableIdentifier.isPrivateMac(value) ? 35 : 80,
                );
              }
            }
            if (type == '_googlecast._tcp' &&
                key == 'id' &&
                RegExp(r'^[a-fA-F0-9-]{16,64}$').hasMatch(decoded)) {
              identifier(
                'protocol_identifier',
                'cast:${decoded.toLowerCase()}',
                'mdns_txt',
                85,
              );
            }
          } on FormatException {
            /* Raw bytes remain inspectable. */
          }
        }
      }
    }
    final ssdp = observation['ssdp'];
    if (ssdp is Map) {
      for (final entry in ssdp.entries) {
        add('ssdp', entry.key.toString().toLowerCase(), entry.value, 20, 1);
      }
      // USN is an advertised candidate; the fetched root-device UDN is stronger.
      identifier('ssdp_usn', ssdp['usn'], 'ssdp', 60);
    }
    final upnp = observation['upnp'];
    if (upnp is Map) {
      for (final entry in upnp.entries) {
        add(
          'upnp',
          entry.key.toString(),
          entry.value is List ? jsonEncode(entry.value) : entry.value,
          [
                'modelName',
                'modelNumber',
                'manufacturer',
                'deviceType',
              ].contains(entry.key)
              ? 85
              : 30,
          30,
        );
      }
      identifier('upnp_udn', upnp['UDN'], 'upnp', 95);
    }
    if (observation['openPort'] is int) {
      add('port', 'tcp', observation['openPort'], 35, 1);
    }
  }

  void seedLegacy(Device d) {
    if (d.fingerprint.evidence.isNotEmpty) return;
    collect(
      d,
      {},
      'legacy:${d.lastSeen.toIso8601String()}',
      observedAt: d.lastSeen,
    );
    for (final service in d.services) {
      collect(
        d,
        {'service': service},
        'legacy:${d.lastSeen.toIso8601String()}',
        observedAt: d.lastSeen,
      );
    }
  }
}
