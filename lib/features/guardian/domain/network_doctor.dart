import '../../diagnostics/domain/diagnostics_service.dart';
import 'guardian_models.dart';

class NetworkDoctorService {
  const NetworkDoctorService(this.diagnostics);
  final DiagnosticsApi diagnostics;

  Future<DoctorReport> run(NetworkSnapshot snapshot) async {
    final checks = <DoctorCheck>[];
    final recommendations = <String>[];
    final limitations = <String>[
      'Phase 3 does not measure per-device bandwidth yet.',
      'This diagnosis uses the phone’s current Wi-Fi path and locally recorded scan data.',
      'Firewalls, client isolation and sleeping devices can hide LAN responses.',
    ];

    if (snapshot.localIp == null || snapshot.cidr == null) {
      return DoctorReport(
        createdAt: DateTime.now(),
        status: DoctorStatus.critical,
        headline: 'Wi-Fi information is unavailable',
        summary: 'Network Guardian cannot run a grounded diagnosis until the device is attached to a usable Wi-Fi IPv4 network.',
        checks: const [
          DoctorCheck(
            id: 'wifi',
            label: 'Wi-Fi connection',
            status: DoctorStatus.critical,
            summary: 'No usable local network information is available.',
          ),
        ],
        recommendations: const ['Connect to Wi-Fi and try Diagnose My Network again.'],
        limitations: limitations,
      );
    }

    NetworkStatus? status;
    try {
      status = await diagnostics.networkStatus();
      checks.add(DoctorCheck(
        id: 'internet',
        label: 'Internet validation',
        status: status.validatedInternet ? DoctorStatus.healthy : DoctorStatus.warning,
        summary: status.validatedInternet
            ? 'Android currently considers this Wi-Fi path validated for Internet access.'
            : 'Android does not currently report validated Internet access on this Wi-Fi path.',
        measuredValue: status.validatedInternet ? 'Validated' : 'Not validated',
      ));
      checks.add(DoctorCheck(
        id: 'dns',
        label: 'DNS configuration',
        status: status.dnsServers.isNotEmpty ? DoctorStatus.healthy : DoctorStatus.warning,
        summary: status.dnsServers.isNotEmpty
            ? '${status.dnsServers.length} DNS server${status.dnsServers.length == 1 ? '' : 's'} configured.'
            : 'No DNS server was reported for the selected Wi-Fi network.',
        measuredValue: status.dnsServers.isEmpty ? 'None reported' : status.dnsServers.join(', '),
      ));
    } catch (e) {
      checks.add(DoctorCheck(
        id: 'internet',
        label: 'Internet validation',
        status: DoctorStatus.unavailable,
        summary: 'Android network validation information could not be read.',
        detail: _friendly(e),
      ));
    }

    PingResult? gatewayPing;
    if (snapshot.gateway == null) {
      checks.add(const DoctorCheck(
        id: 'gateway',
        label: 'Gateway/router',
        status: DoctorStatus.warning,
        summary: 'No IPv4 gateway is configured in the current network record.',
      ));
      recommendations.add('Reconnect to Wi-Fi or inspect the router/DHCP configuration.');
    } else {
      try {
        gatewayPing = await diagnostics.ping(snapshot.gateway!, count: 4);
        final loss = gatewayPing.packetLossPercent;
        final avg = gatewayPing.avgMs;
        final badLoss = loss >= 25;
        final highLatency = avg != null && avg >= 100;
        final degraded = badLoss || highLatency || gatewayPing.received == 0;
        checks.add(DoctorCheck(
          id: 'gateway',
          label: 'Gateway/router response',
          status: gatewayPing.received == 0
              ? DoctorStatus.critical
              : degraded
              ? DoctorStatus.warning
              : DoctorStatus.healthy,
          summary: gatewayPing.received == 0
              ? 'The configured gateway did not answer the diagnostic reachability test.'
              : degraded
              ? 'The gateway responded, but local latency or packet loss is elevated.'
              : 'The gateway responded normally during this short test.',
          measuredValue: '${_ms(avg)} avg · ${loss.toStringAsFixed(0)}% loss',
          detail: 'Method: ${gatewayPing.method}',
        ));
        if (badLoss) recommendations.add('Check Wi-Fi signal quality and local interference near this device.');
        if (highLatency) recommendations.add('Move closer to the access point or test the same network from another location.');
      } catch (e) {
        checks.add(DoctorCheck(
          id: 'gateway',
          label: 'Gateway/router response',
          status: DoctorStatus.unavailable,
          summary: 'The gateway diagnostic could not be completed.',
          detail: _friendly(e),
        ));
      }
    }

    final age = snapshot.lastCompletedScan == null
        ? null
        : DateTime.now().difference(snapshot.lastCompletedScan!);
    final stale = age == null || age > const Duration(hours: 6);
    checks.add(DoctorCheck(
      id: 'scan-freshness',
      label: 'Device picture',
      status: stale ? DoctorStatus.notice : DoctorStatus.healthy,
      summary: age == null
          ? 'No completed device scan is recorded yet.'
          : stale
          ? 'The last completed scan is ${_age(age)} old.'
          : 'The recorded device picture is recent.',
      measuredValue: snapshot.lastCompletedScan == null ? 'No completed scan' : _age(age!),
    ));
    if (stale) recommendations.add('Run a fresh network scan before making device-level conclusions.');

    final unknown = snapshot.devices.where((d) => d.trustState.name == 'unknown').length;
    checks.add(DoctorCheck(
      id: 'ownership',
      label: 'Unreviewed devices',
      status: unknown == 0 ? DoctorStatus.healthy : DoctorStatus.notice,
      summary: unknown == 0
          ? 'Every recorded device has been reviewed as trusted.'
          : '$unknown recorded device${unknown == 1 ? ' is' : 's are'} still marked Unknown.',
      measuredValue: '$unknown unknown',
    ));

    final gatewayCheck = checks.where((c) => c.id == 'gateway').firstOrNull;
    final internetCheck = checks.where((c) => c.id == 'internet').firstOrNull;
    DoctorStatus overall;
    String headline;
    String summary;
    if (gatewayCheck?.status == DoctorStatus.critical) {
      overall = DoctorStatus.critical;
      headline = 'The problem appears local to Wi-Fi or the router';
      summary = 'Your configured gateway did not answer. Internet troubleshooting should start with the local Wi-Fi/router path.';
      recommendations.insert(0, 'Verify the router is powered and that this device is connected to the intended Wi-Fi network.');
    } else if (internetCheck?.status == DoctorStatus.warning &&
        gatewayCheck?.status == DoctorStatus.healthy) {
      overall = DoctorStatus.warning;
      headline = 'Local Wi-Fi looks reachable, but Internet validation is missing';
      summary = 'The router answered locally while Android did not report a validated Internet path. This points more toward WAN/ISP/DNS/captive-portal conditions than a dead local Wi-Fi link.';
      recommendations.insert(0, 'Open a normal website to rule out a captive portal, then check the router WAN/ISP status.');
    } else if (gatewayCheck?.status == DoctorStatus.warning) {
      overall = DoctorStatus.warning;
      headline = 'Local Wi-Fi quality may be degraded';
      summary = 'The gateway answered, but the short local test showed elevated latency or packet loss.';
    } else if (internetCheck?.status == DoctorStatus.healthy &&
        gatewayCheck?.status == DoctorStatus.healthy) {
      overall = DoctorStatus.healthy;
      headline = 'No obvious connectivity fault found';
      summary = 'The gateway responded normally and Android reports validated Internet access. A speed or bandwidth problem may require the later bandwidth-analysis phase.';
    } else {
      overall = DoctorStatus.notice;
      headline = 'Diagnosis completed with limited evidence';
      summary = 'Some checks were unavailable, so Network Guardian is avoiding a stronger conclusion.';
    }

    if (recommendations.isEmpty) {
      recommendations.add('If the problem persists, run a fresh device scan and repeat the diagnosis while the issue is happening.');
    }

    return DoctorReport(
      createdAt: DateTime.now(),
      status: overall,
      headline: headline,
      summary: summary,
      checks: checks,
      recommendations: recommendations.toSet().toList(),
      limitations: limitations,
    );
  }

  String _friendly(Object error) =>
      error.toString().replaceAll('Exception: ', '').replaceAll('PlatformException', '');
  String _ms(double? value) => value == null ? '—' : '${value.toStringAsFixed(1)} ms';
  String _age(Duration value) {
    if (value.inDays > 0) return '${value.inDays}d ${value.inHours.remainder(24)}h';
    if (value.inHours > 0) return '${value.inHours}h ${value.inMinutes.remainder(60)}m';
    return '${value.inMinutes}m';
  }
}
