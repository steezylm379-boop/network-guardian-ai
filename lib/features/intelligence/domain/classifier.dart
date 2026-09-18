import 'identity.dart';
import 'fingerprint_rules.dart';

/// Local evidence-strength rules. Scores are deterministic evidence strengths,
/// not statistical probabilities.
class DeviceClassifier {
  DeviceClassifier({DeviceFingerprintDatabase? database})
    : database = database ?? const DeviceFingerprintDatabase();

  final DeviceFingerprintDatabase database;

  DeviceClassification evaluate(DeviceFingerprint fingerprint, {DateTime? at}) {
    final now = at ?? DateTime.now();
    final categories = <String, Map<String, int>>{};
    final manufacturers = <String, Map<String, int>>{};
    final models = <String, Map<String, int>>{};
    final reasons = <String>{};

    void vote(
      Map<String, Map<String, int>> target,
      String candidate,
      IdentityEvidence e,
      int weight, {
      String? reason,
    }) {
      if (candidate.trim().isEmpty) return;
      final bucket = target.putIfAbsent(candidate, () => {});
      // Multiple advertisements from one protocol do not manufacture
      // confidence. Independent evidence sources may contribute a small bonus.
      bucket[e.source] = (bucket[e.source] ?? 0) > weight
          ? bucket[e.source]!
          : weight;
      reasons.add(reason ?? '${e.source}/${e.key}: ${e.value}');
    }

    final active = fingerprint.evidence.where((e) => e.activeAt(now)).toList();
    for (final e in active) {
      for (final rule in database.rules.where((r) => r.matches(e))) {
        if (rule.category != null) {
          vote(
            categories,
            rule.category!.name,
            e,
            rule.weight,
            reason: '${rule.id}: ${e.value}',
          );
        }
        if (rule.manufacturer != null) {
          vote(
            manufacturers,
            rule.manufacturer!,
            e,
            rule.weight,
            reason: '${rule.id}: ${e.value}',
          );
        }
        if (rule.modelFromEvidence) {
          vote(models, e.value.trim(), e, rule.weight, reason: '${rule.id}: ${e.value}');
        }
      }

      final v = e.normalizedValue;
      if (e.key == 'manufacturer' && ['upnp', 'oui'].contains(e.source)) {
        final normalized = v.contains('samsung')
            ? 'Samsung'
            : RegExp(r'^apple(?: inc\.?| computer,? inc\.?)?$').hasMatch(v)
            ? 'Apple'
            : e.value.trim();
        vote(manufacturers, normalized, e, e.weight);
      }

      if (e.source == 'upnp') {
        if (e.key == 'modelName' ||
            (e.key == 'modelNumber' &&
                !active.any((other) => other.source == 'upnp' && other.key == 'modelName'))) {
          vote(models, e.value.trim(), e, 85);
        }
        if (e.key == 'friendlyName') {
          final lower = v;
          if (lower.contains('nvr')) {
            vote(categories, DeviceCategory.nvr.name, e, 65);
          } else if (lower.contains('switch')) {
            vote(categories, DeviceCategory.networkSwitch.name, e, 60);
          } else if (lower.contains('repeater') || lower.contains('extender')) {
            vote(categories, DeviceCategory.repeater.name, e, 60);
          } else if (lower.contains('access point') || lower.contains('access-point')) {
            vote(categories, DeviceCategory.accessPoint.name, e, 60);
          }
        }
      }

      if (e.source == 'mdns_txt') {
        final scope = e.metadata['scope'];
        final valid =
            (scope == '_airplay._tcp' && e.key == 'model') ||
            (scope == '_raop._tcp' && e.key == 'am') ||
            (scope == '_googlecast._tcp' && e.key == 'md') ||
            (['_ipp._tcp', '_ipps._tcp', '_printer._tcp'].contains(scope) &&
                ['ty', 'product'].contains(e.key));
        if (valid) vote(models, e.value.trim(), e, 75);
      }

      if (e.source == 'dns' && e.key == 'hostname') {
        if (v.contains('laptop') || v.contains('macbook')) {
          vote(categories, DeviceCategory.laptop.name, e, 30);
        }
        if (v.contains('desktop') || v.startsWith('desktop-')) {
          vote(categories, DeviceCategory.desktop.name, e, 30);
        }
        if (v.contains('voip') || v.contains('sip')) {
          vote(categories, DeviceCategory.voipPhone.name, e, 25);
        }
        if (v.contains('modem')) {
          vote(categories, DeviceCategory.modem.name, e, 30);
        }
      }
    }

    Map<String, int> scores(Map<String, Map<String, int>> votes) =>
        votes.map((key, value) {
          final ranked = value.values.toList()..sort((a, b) => b.compareTo(a));
          final independentBonus = ranked.length > 1 ? 15 : 0;
          return MapEntry(key, (ranked.first + independentBonus).clamp(0, 95));
        });

    final cs = scores(categories), ms = scores(manufacturers), ds = scores(models);

    String? best(Map<String, int> map) {
      final entries = map.entries.toList()
        ..sort((a, b) {
          final score = b.value.compareTo(a.value);
          return score == 0 ? a.key.compareTo(b.key) : score;
        });
      return entries.firstOrNull?.key;
    }

    final conflicts = <String>[];
    void check(Map<String, int> map, String field) {
      // A weak secondary hint must not collapse a strong protocol-backed
      // classification. Treat candidates as a real conflict only when the
      // runner-up is itself meaningful and close enough to the leader that
      // the evidence is genuinely ambiguous. This keeps strong UPnP device
      // types authoritative over weak hostname/port hints while still
      // flagging contradictions such as two different manufacturers.
      final ranked = map.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      if (ranked.length < 2) return;
      final leader = ranked[0];
      final runnerUp = ranked[1];
      if (leader.value >= 55 &&
          runnerUp.value >= 55 &&
          (leader.value - runnerUp.value).abs() <= 20) {
        conflicts.add(
          'Conflicting $field evidence: ${leader.key} (${leader.value}) vs '
          '${runnerUp.key} (${runnerUp.value})',
        );
      }
    }

    check(cs, 'category');
    check(ms, 'manufacturer');
    check(ds, 'model');
    final category = best(cs), manufacturer = best(ms), model = best(ds);
    final strengths = [cs[category] ?? 0, ms[manufacturer] ?? 0, ds[model] ?? 0]..sort();
    var score = strengths.last;
    if (conflicts.isNotEmpty) score = score.clamp(0, 39);

    final override = fingerprint.override;
    final confirmed = override?.confirmsIdentity == true;
    if (override != null) reasons.add('User correction takes precedence over automatic evidence.');

    final result = DeviceClassification(
      category: override?.category ??
          (category == null ? DeviceCategory.unknown : DeviceCategory.values.byName(category)),
      manufacturer: override?.manufacturer ?? manufacturer,
      model: override?.model ?? model,
      score: confirmed ? 100 : score,
      level: confirmed
          ? ConfidenceLevel.confirmed
          : score >= 80
          ? ConfidenceLevel.high
          : score >= 55
          ? ConfidenceLevel.medium
          : score > 0
          ? ConfidenceLevel.low
          : ConfidenceLevel.unknown,
      reasons: reasons.toList()..sort(),
      conflicts: conflicts,
      categoryCandidates: cs,
      manufacturerCandidates: ms,
      modelCandidates: ds,
    );

    fingerprint.classification = result;
    fingerprint.lastEvaluated = now;
    final expiries = fingerprint.evidence
        .map((e) => e.expiresAt)
        .whereType<DateTime>()
        .where((d) => d.isAfter(now))
        .toList()
      ..sort();
    fingerprint.nextExpiry = expiries.firstOrNull;
    fingerprint.dirty = false;
    return result;
  }
}
