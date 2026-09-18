import '../../devices/domain/device.dart';
import '../../devices/domain/device_event.dart';
import '../../intelligence/domain/identity.dart';
import 'guardian_models.dart';

/// Grounded Phase 3 assistant. It intentionally answers only from the local
/// snapshot and doctor report. A future enterprise LLM can narrate this same
/// structured context without changing the telemetry/reasoning contract.
class LocalNetworkAssistant {
  const LocalNetworkAssistant();

  GuardianAnswer answer(
    String question,
    NetworkSnapshot snapshot, {
    DoctorReport? doctor,
    DateTime? now,
  }) {
    final q = question.trim().toLowerCase();
    final at = now ?? DateTime.now();
    if (q.isEmpty) {
      return const GuardianAnswer(
        text: 'Ask me about the devices, changes, unknown equipment, camera-like profiles, or the health of this network.',
        confidence: 100,
        intent: 'help',
      );
    }

    if (_containsAny(q, ['slow', 'lag', 'latency', 'internet problem', 'wifi problem', 'wi-fi problem', 'connection problem'])) {
      return _doctor(doctor);
    }
    if (_containsAny(q, ['bandwidth', 'using the most', 'most data', 'download usage', 'traffic usage'])) {
      return const GuardianAnswer(
        text: 'Per-device bandwidth is not measured in Phase 3, so I cannot truthfully name the device using the most data yet. That requires router/agent telemetry planned for a later phase.',
        confidence: 100,
        intent: 'bandwidth',
        suggestedQuestions: ['Why is my network slow?', 'What changed recently?'],
      );
    }
    if (_containsAny(q, ['camera', 'cameras', 'nvr', 'hidden camera'])) {
      return _cameras(snapshot);
    }
    if (_containsAny(q, ['unknown', 'unrecognized', 'not mine', 'stranger'])) {
      return _unknown(snapshot);
    }
    if (_containsAny(q, ['joined today', 'new today', 'appeared today', 'new device', 'joined recently'])) {
      return _newDevices(snapshot, at);
    }
    if (_containsAny(q, ['what changed', 'changed recently', 'what happened', 'timeline', 'yesterday'])) {
      return _changes(snapshot, at, q.contains('yesterday'));
    }
    if (_containsAny(q, ['offline', 'disconnected', 'not online'])) {
      return _offline(snapshot);
    }
    if (_containsAny(q, ['secure', 'security', 'safe', 'vulnerable', 'hacked'])) {
      return _security(snapshot);
    }
    if (_containsAny(q, ['router', 'gateway', 'access point'])) {
      return _router(snapshot);
    }
    if (_containsAny(q, ['how many', 'overview', 'summary', 'network status', 'what is connected', 'who is connected'])) {
      return _overview(snapshot);
    }

    final device = _matchDevice(q, snapshot.devices);
    if (device != null) return _device(device);

    return GuardianAnswer(
      text: 'I could not map that question to reliable local telemetry yet. I can answer about connected devices, unknown devices, recent changes, camera-like profiles, routers, offline devices, or run Network Doctor for connectivity problems.',
      confidence: 100,
      intent: 'unsupported',
      suggestedQuestions: const [
        'What is connected right now?',
        'Who joined recently?',
        'Are there any camera-like devices?',
        'Why is my network slow?',
      ],
    );
  }

  GuardianAnswer _overview(NetworkSnapshot s) {
    final online = s.devices.where((d) => d.isOnline).length;
    final trusted = s.devices.where((d) => d.trustState.name == 'trusted').length;
    final identified = s.devices.where((d) => d.fingerprint.classification.category != DeviceCategory.unknown).length;
    return GuardianAnswer(
      text: 'I have ${s.devices.length} recorded device${s.devices.length == 1 ? '' : 's'} on ${s.networkName}. $online were online at the latest recorded state, $trusted are marked trusted, and $identified have a non-unknown device category. ${s.lastCompletedScan == null ? 'There is no completed scan yet.' : 'The last completed scan was ${_when(s.lastCompletedScan!)}.'}',
      confidence: s.lastCompletedScan == null ? 70 : 95,
      intent: 'overview',
      evidence: [
        GuardianEvidence(label: 'Recorded devices', value: '${s.devices.length}'),
        GuardianEvidence(label: 'Online', value: '$online'),
        GuardianEvidence(label: 'Trusted', value: '$trusted'),
        GuardianEvidence(label: 'Last scan', value: s.lastCompletedScan?.toIso8601String() ?? 'None'),
      ],
    );
  }

  GuardianAnswer _unknown(NetworkSnapshot s) {
    final rows = s.devices.where((d) => d.trustState.name == 'unknown').toList();
    if (rows.isEmpty) {
      return const GuardianAnswer(
        text: 'No recorded devices are currently marked Unknown. That means they have been reviewed as trusted, not that a vulnerability scan has proven them safe.',
        confidence: 95,
        intent: 'unknown_devices',
      );
    }
    return GuardianAnswer(
      text: '${rows.length} device${rows.length == 1 ? ' is' : 's are'} still marked Unknown: ${rows.take(6).map((d) => '${d.name} (${d.ipAddress})').join(', ')}${rows.length > 6 ? ', and ${rows.length - 6} more' : ''}. Review ownership before treating any of them as suspicious.',
      confidence: 95,
      intent: 'unknown_devices',
      evidence: rows.take(8).map((d) => GuardianEvidence(label: d.name, value: d.ipAddress, deviceId: d.id)).toList(),
    );
  }

  GuardianAnswer _newDevices(NetworkSnapshot s, DateTime now) {
    final since = now.subtract(const Duration(hours: 24));
    final rows = s.devices.where((d) => d.firstSeen.isAfter(since)).toList()
      ..sort((a, b) => b.firstSeen.compareTo(a.firstSeen));
    if (rows.isEmpty) {
      return const GuardianAnswer(
        text: 'No device in the local history was first seen during the last 24 hours.',
        confidence: 90,
        intent: 'new_devices',
      );
    }
    return GuardianAnswer(
      text: '${rows.length} device${rows.length == 1 ? ' was' : 's were'} first seen in the last 24 hours: ${rows.take(6).map((d) => d.name).join(', ')}. “First seen” means first recorded by Network Guardian, not necessarily first connected to the router.',
      confidence: 90,
      intent: 'new_devices',
      evidence: rows.take(8).map((d) => GuardianEvidence(label: d.name, value: 'First seen ${d.firstSeen.toIso8601String()}', deviceId: d.id)).toList(),
    );
  }

  GuardianAnswer _cameras(NetworkSnapshot s) {
    final rows = s.devices.where((d) {
      final c = d.fingerprint.classification.category;
      if (c == DeviceCategory.camera || c == DeviceCategory.nvr) return true;
      return d.services.any((service) {
        final text = '${service['type']} ${service['name']} ${service['port']}'.toLowerCase();
        return text.contains('rtsp') || text.contains('onvif') || text.contains('554');
      });
    }).toList();
    if (rows.isEmpty) {
      return const GuardianAnswer(
        text: 'I do not currently have enough network evidence to label any recorded device as a camera or NVR. This does not prove that no camera exists: isolated, cellular, sleeping, locally recording, or non-advertising cameras can be invisible to this scan.',
        confidence: 75,
        intent: 'camera_profiles',
      );
    }
    return GuardianAnswer(
      text: 'I found ${rows.length} device${rows.length == 1 ? '' : 's'} with camera/NVR classification or camera-like service evidence: ${rows.map((d) => d.name).join(', ')}. This is network classification, not proof that a device is hidden or actively recording.',
      confidence: rows.map((d) => d.fingerprint.classification.score).fold<int>(0, (a, b) => a > b ? a : b).clamp(40, 95).toInt(),
      intent: 'camera_profiles',
      evidence: rows.map((d) {
        final c = d.fingerprint.classification;
        return GuardianEvidence(label: d.name, value: '${c.category.name} · ${c.score}/100 · ${d.ipAddress}', deviceId: d.id);
      }).toList(),
    );
  }

  GuardianAnswer _changes(NetworkSnapshot s, DateTime now, bool yesterday) {
    final start = yesterday
        ? DateTime(now.year, now.month, now.day).subtract(const Duration(days: 1))
        : now.subtract(const Duration(hours: 24));
    final end = yesterday ? DateTime(now.year, now.month, now.day) : now;
    final events = <({Device device, DeviceEvent event})>[];
    for (final d in s.devices) {
      for (final e in d.events) {
        if (!e.at.isBefore(start) && e.at.isBefore(end)) events.add((device: d, event: e));
      }
    }
    events.sort((a, b) => b.event.at.compareTo(a.event.at));
    if (events.isEmpty) {
      return GuardianAnswer(
        text: yesterday ? 'No recorded device-change events were stored for yesterday.' : 'No device-change events were stored during the last 24 hours.',
        confidence: 85,
        intent: 'changes',
      );
    }
    final meaningful = events.take(8).toList();
    return GuardianAnswer(
      text: 'I found ${events.length} recorded change event${events.length == 1 ? '' : 's'} ${yesterday ? 'yesterday' : 'in the last 24 hours'}. The latest: ${meaningful.take(4).map((x) => '${x.device.name}: ${x.event.message}').join(' | ')}',
      confidence: 90,
      intent: 'changes',
      evidence: meaningful.map((x) => GuardianEvidence(label: x.device.name, value: '${x.event.message} · ${x.event.at.toIso8601String()}', deviceId: x.device.id, kind: 'event')).toList(),
    );
  }

  GuardianAnswer _offline(NetworkSnapshot s) {
    final rows = s.devices.where((d) => !d.isOnline).toList();
    return GuardianAnswer(
      text: rows.isEmpty
          ? 'No recorded device is currently marked offline from the latest completed scan state.'
          : '${rows.length} recorded device${rows.length == 1 ? ' is' : 's are'} not marked online: ${rows.take(8).map((d) => d.name).join(', ')}. This means they were not seen in the latest completed scan; sleeping devices and firewalls can create false negatives.',
      confidence: 85,
      intent: 'offline_devices',
      evidence: rows.take(8).map((d) => GuardianEvidence(label: d.name, value: 'Last seen ${d.lastSeen.toIso8601String()}', deviceId: d.id)).toList(),
    );
  }

  GuardianAnswer _security(NetworkSnapshot s) {
    final unknown = s.devices.where((d) => d.trustState.name == 'unknown').length;
    final conflicts = s.devices.where((d) => d.fingerprint.classification.conflicts.isNotEmpty).length;
    return GuardianAnswer(
      text: 'I cannot honestly declare this network “secure” yet because Phase 3 does not perform full vulnerability or exposure analysis. I can say that $unknown recorded device${unknown == 1 ? ' is' : 's are'} still marked Unknown and $conflicts device${conflicts == 1 ? ' has' : 's have'} conflicting identity evidence. Those are review signals, not proof of compromise.',
      confidence: 100,
      intent: 'security_limits',
      evidence: [
        GuardianEvidence(label: 'Unknown ownership state', value: '$unknown'),
        GuardianEvidence(label: 'Identity conflicts', value: '$conflicts'),
      ],
      suggestedQuestions: const ['Which devices are unknown?', 'What changed recently?'],
    );
  }

  GuardianAnswer _router(NetworkSnapshot s) {
    final gateways = s.devices.where((d) => d.isGateway).toList();
    if (gateways.isEmpty) {
      return GuardianAnswer(
        text: 'The network reports ${s.gateway ?? 'no gateway address'}, but I do not have a matched gateway device profile in the local inventory yet.',
        confidence: 70,
        intent: 'router',
        evidence: [if (s.gateway != null) GuardianEvidence(label: 'Configured gateway', value: s.gateway!)],
      );
    }
    final d = gateways.first;
    final c = d.fingerprint.classification;
    return GuardianAnswer(
      text: 'The current gateway record is ${d.name} at ${d.ipAddress}. ${c.manufacturer == null ? 'The manufacturer is not confidently identified.' : 'Manufacturer: ${c.manufacturer}.'} It was ${d.isOnline ? 'seen online' : 'not seen'} in the latest completed scan state.',
      confidence: c.score.clamp(65, 95).toInt(),
      intent: 'router',
      evidence: [GuardianEvidence(label: d.name, value: '${d.ipAddress} · ${c.manufacturer ?? 'Unknown manufacturer'}', deviceId: d.id)],
    );
  }

  GuardianAnswer _device(Device d) {
    final c = d.fingerprint.classification;
    final reasons = c.reasons.take(3).join('; ');
    return GuardianAnswer(
      text: '${d.name} is recorded at ${d.ipAddress} and is ${d.isOnline ? 'online in the latest state' : 'not online in the latest state'}. Classification: ${c.category.name}${c.manufacturer == null ? '' : ', ${c.manufacturer}'}${c.model == null ? '' : ', ${c.model}'} with evidence strength ${c.score}/100 (${c.level.name}).${reasons.isEmpty ? '' : ' Main evidence: $reasons.'}',
      confidence: c.score == 0 ? 70 : c.score,
      intent: 'device_lookup',
      evidence: [
        GuardianEvidence(label: 'IP', value: d.ipAddress, deviceId: d.id),
        if (d.macAddress != null) GuardianEvidence(label: 'MAC', value: d.macAddress!, deviceId: d.id),
        GuardianEvidence(label: 'Identification', value: '${c.category.name} · ${c.score}/100', deviceId: d.id),
      ],
    );
  }

  GuardianAnswer _doctor(DoctorReport? report) {
    if (report == null) {
      return const GuardianAnswer(
        text: 'I need a fresh Network Doctor run to answer that from measured evidence. Tap “Diagnose my network” and I’ll check the local gateway path, Android Internet validation, DNS configuration and scan freshness.',
        confidence: 100,
        intent: 'network_doctor_needed',
      );
    }
    return GuardianAnswer(
      text: '${report.headline}. ${report.summary} ${report.recommendations.isEmpty ? '' : 'Next: ${report.recommendations.first}'}',
      confidence: report.status == DoctorStatus.healthy ? 90 : 85,
      intent: 'network_doctor',
      evidence: report.checks.map((c) => GuardianEvidence(label: c.label, value: '${c.summary}${c.measuredValue == null ? '' : ' · ${c.measuredValue}'}', kind: 'diagnostic')).toList(),
    );
  }

  Device? _matchDevice(String query, List<Device> devices) {
    final ips = RegExp(r'\b(?:\d{1,3}\.){3}\d{1,3}\b').allMatches(query).map((m) => m.group(0)!).toList();
    for (final d in devices) {
      if (ips.contains(d.ipAddress)) return d;
    }
    final sorted = [...devices]..sort((a, b) => b.name.length.compareTo(a.name.length));
    for (final d in sorted) {
      final names = <String?>[d.name, d.hostname, d.mdnsName, d.fingerprint.classification.model, d.fingerprint.classification.manufacturer]
          .whereType<String>()
          .map((e) => e.trim().toLowerCase())
          .where((e) => e.length >= 3);
      if (names.any(query.contains)) return d;
    }
    return null;
  }

  bool _containsAny(String value, List<String> needles) => needles.any(value.contains);
  String _when(DateTime time) {
    final delta = DateTime.now().difference(time);
    if (delta.inMinutes < 2) return 'just now';
    if (delta.inHours < 1) return '${delta.inMinutes} minutes ago';
    if (delta.inDays < 1) return '${delta.inHours} hours ago';
    return '${delta.inDays} days ago';
  }
}
