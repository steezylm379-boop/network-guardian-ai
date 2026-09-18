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
    final online = devices.where((d) => d.isOnline).toList();
    final gatewayOnline = online.any((d) => d.isGateway);
    final classified = devices.where((d) {
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
    final discovery = devices.isEmpty
        ? (hasNetwork ? 65 : 0)
        : online.isNotEmpty
        ? 100
        : 55;
    final identity = devices.isEmpty
        ? 50
        : ((classified / devices.length) * 100).round().clamp(0, 100);

    // This is deliberately a transparent local-health score, not a security
    // verdict. Security analysis is a later, separate feature.
    final score = ((connectivity * .40) +
            (gateway * .25) +
            (discovery * .25) +
            (identity * .10))
        .round()
        .clamp(0, 100);

    return NetworkHealthScore(score: score, components: [
      HealthComponent(
        'Connectivity',
        connectivity,
        hasNetwork ? 'Wi-Fi network detected.' : 'No Wi-Fi network detected.',
      ),
      HealthComponent(
        'Gateway',
        gateway,
        gatewayOnline
            ? 'Gateway responded during discovery.'
            : gatewayConfigured
            ? 'Gateway is configured but was not observed in the latest data.'
            : 'Gateway address is unavailable.',
      ),
      HealthComponent(
        'Discovery',
        discovery,
        devices.isEmpty
            ? 'No device observations yet.'
            : '${online.length} of ${devices.length} recorded devices were seen online.',
      ),
      HealthComponent(
        'Identification',
        identity,
        devices.isEmpty
            ? 'No devices to classify yet.'
            : '$classified of ${devices.length} devices have high-confidence identities.',
      ),
    ]);
  }
}
