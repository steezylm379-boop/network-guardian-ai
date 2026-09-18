import '../../devices/domain/device.dart';
import '../../devices/domain/device_event.dart';
import '../../intelligence/domain/identity.dart';
import 'guardian_models.dart';

class NetworkInsightEngine {
  const NetworkInsightEngine();

  List<NetworkInsight> evaluate(NetworkSnapshot snapshot, {DateTime? now}) {
    final at = now ?? DateTime.now();
    final insights = <NetworkInsight>[];
    final devices = snapshot.devices;

    final unknown = devices.where((d) => d.trustState == DeviceTrustState.unknown).toList();
    if (unknown.isNotEmpty) {
      insights.add(NetworkInsight(
        id: 'unknown-devices',
        title: '${unknown.length} device${unknown.length == 1 ? '' : 's'} not marked trusted',
        body: 'Review devices you do not recognize. “Unknown” is an ownership state, not a threat verdict.',
        severity: InsightSeverity.attention,
      ));
    }

    final newlySeen = devices.where((d) => at.difference(d.firstSeen).inHours <= 24).toList();
    if (newlySeen.isNotEmpty) {
      insights.add(NetworkInsight(
        id: 'new-devices',
        title: '${newlySeen.length} device${newlySeen.length == 1 ? '' : 's'} first seen in the last 24 hours',
        body: newlySeen.take(3).map((d) => d.name).join(' · '),
        severity: InsightSeverity.info,
      ));
    }

    final gateway = devices.where((d) => d.isGateway).firstOrNull;
    if (snapshot.lastCompletedScan != null && gateway != null && !gateway.isOnline) {
      insights.add(const NetworkInsight(
        id: 'gateway-offline',
        title: 'Gateway was not seen in the last completed scan',
        body: 'This can indicate isolation, a discovery limitation, or a local network problem. Run Network Doctor for a direct gateway check.',
        severity: InsightSeverity.warning,
      ));
    }

    final conflicts = devices.where((d) => d.fingerprint.classification.conflicts.isNotEmpty).toList();
    if (conflicts.isNotEmpty) {
      insights.add(NetworkInsight(
        id: 'identity-conflicts',
        title: '${conflicts.length} identification conflict${conflicts.length == 1 ? '' : 's'} need review',
        body: 'Network Guardian found contradictory identity evidence and intentionally lowered confidence.',
        severity: InsightSeverity.attention,
      ));
    }

    final unstable = devices.where((d) {
      final since = at.subtract(const Duration(days: 7));
      final changes = d.events.where((e) =>
          e.at.isAfter(since) &&
          (e.type == DeviceEventType.online || e.type == DeviceEventType.offline));
      return changes.length >= 4;
    }).toList();
    if (unstable.isNotEmpty) {
      insights.add(NetworkInsight(
        id: 'unstable-devices',
        title: '${unstable.length} device${unstable.length == 1 ? '' : 's'} changed online state repeatedly',
        body: 'This is based on recorded scans, not continuous background monitoring.',
        severity: InsightSeverity.info,
      ));
    }

    final cameraLike = devices.where((d) {
      final c = d.fingerprint.classification.category;
      return c == DeviceCategory.camera || c == DeviceCategory.nvr;
    }).toList();
    if (cameraLike.isNotEmpty) {
      insights.add(NetworkInsight(
        id: 'camera-like',
        title: '${cameraLike.length} camera/NVR profile${cameraLike.length == 1 ? '' : 's'} identified',
        body: 'Classification is evidence-based and does not prove a device is hidden or recording.',
        severity: InsightSeverity.info,
      ));
    }

    if (insights.isEmpty) {
      insights.add(const NetworkInsight(
        id: 'quiet-network',
        title: 'No notable changes in the current local record',
        body: 'Run a fresh scan for the most current device picture.',
        severity: InsightSeverity.info,
      ));
    }
    return insights.take(5).toList(growable: false);
  }
}
