import '../../devices/domain/device.dart';
import '../../intelligence/domain/identity.dart';

class HealthComponent {
  const HealthComponent(this.label, this.score, this.note);
  final String label;
  final int score;
  final String note;
}

class NetworkHealthScore {
  const NetworkHealthScore({required this.score, required this.components});
  final int score;
  final List<HealthComponent> components;

  String get label => score >= 90
      ? 'Excellent'
      : score >= 75
      ? 'Good'
      : score >= 55
      ? 'Fair'
      : 'Needs attention';
}

class NetworkHealthCalculator {
  const NetworkHealthCalculator();

  NetworkHealthScore evaluate({
    required bool hasNetwork,
    required bool gatewayConfigured,
    required List<Device> devices,
  }) {
    final validDevices = devices.where((d) => d.id.isNotEmpty).toList();
    final online = validDevices.where((d) => d.isOnline).toList();
    final gatewayOnline = online.any((d) => d.isGateway);
    final classified = validDevices.where((d) {
      final c = d.fingerprint.classification;
      return c.category != DeviceCategory.unknown &&
          (c.level == ConfidenceLevel.high ||
              c.level == ConfidenceLevel.confirmed);
    }).length;

    final connectivity = hasNetwork ? 100 : 0;
    final gateway = !gatewayConfigured
        ? 70
        : gatewayOnline
        ? 100
        : 55;
    final discovery = validDevices.isEmpty
        ? (hasNetwork ? 65 : 0)
        : online.isNotEmpty
        ? 100
        : 55;
    final identity = validDevices.isEmpty
        ? 50
        : ((classified / validDevices.length) * 100).round().clamp(0, 100);

    // Deterministic weighted formula with strict clamping
    final calculated = (connectivity * 0.40) +
        (gateway * 0.25) +
        (discovery * 0.25) +
        (identity * 0.10);

    final score = calculated.isNaN || calculated.isInfinite
        ? 0
        : calculated.round().clamp(0, 100);

    return NetworkHealthScore(score: score, components: [
      HealthComponent(
        'Connectivity',
        connectivity.clamp(0, 100),
        hasNetwork ? 'Wi-Fi network detected.' : 'No Wi-Fi network detected.',
      ),
      HealthComponent(
        'Gateway',
        gateway.clamp(0, 100),
        gatewayOnline
            ? 'Gateway responded during discovery.'
            : gatewayConfigured
            ? 'Gateway is configured but was not observed in the latest data.'
            : 'Gateway address is unavailable.',
      ),
      HealthComponent(
        'Discovery',
        discovery.clamp(0, 100),
        validDevices.isEmpty
            ? 'No device observations yet.'
            : '${online.length} of ${validDevices.length} recorded devices were seen online.',
      ),
      HealthComponent(
        'Identification',
        identity.clamp(0, 100),
        validDevices.isEmpty
            ? 'No devices to classify yet.'
            : '$classified of ${validDevices.length} devices have high-confidence identities.',
      ),
    ]);
  }
}
