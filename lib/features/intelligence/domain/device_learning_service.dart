import '../../devices/domain/device.dart';
import 'identity.dart';

/// Local-only learning that reuses a user correction only when a strong,
/// stable identifier matches. It deliberately refuses weak hostname/IP-only
/// transfer to avoid teaching the app a false identity.
class DeviceLearningService {
  const DeviceLearningService();

  DeviceOverride? learnedOverride(Device incoming, Iterable<Device> known) {
    final signatures = incoming.fingerprint.identifiers
        .where((i) => i.strong)
        .map((i) => i.signature)
        .toSet();
    if (signatures.isEmpty) return null;
    final matches = known.where((d) {
      final override = d.fingerprint.override;
      if (override == null) return false;
      final other = d.fingerprint.identifiers
          .where((i) => i.strong)
          .map((i) => i.signature)
          .toSet();
      return signatures.intersection(other).isNotEmpty;
    }).toList();
    if (matches.length != 1) return null;
    return DeviceOverride.fromJson(matches.single.fingerprint.override!.toJson());
  }
}
