import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../../features/devices/domain/device.dart';
import '../network/platform_discovery.dart';
import '../../features/intelligence/domain/identity.dart';
import '../../features/intelligence/domain/evidence_collector.dart';
import '../../features/guardian/domain/guardian_models.dart';
part 'app_database.g.dart';

class Networks extends Table {
  TextColumn get id => text()();
  TextColumn get fingerprint => text().unique()();
  TextColumn get ssid => text().nullable()();
  TextColumn get gatewayIp => text().nullable()();
  TextColumn get cidr => text()();
  DateTimeColumn get firstSeen => dateTime()();
  DateTimeColumn get lastSeen => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DeviceRow')
class Devices extends Table {
  TextColumn get id => text()();
  TextColumn get networkId => text().references(Networks, #id)();
  TextColumn get ipAddress => text()();
  TextColumn get macAddress => text().nullable()();
  TextColumn get payload => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

class DeviceServices extends Table {
  TextColumn get deviceId =>
      text().references(Devices, #id, onDelete: KeyAction.cascade)();
  TextColumn get serviceKey => text()();
  TextColumn get payload => text()();
  @override
  Set<Column> get primaryKey => {deviceId, serviceKey};
}

class ScanSessions extends Table {
  TextColumn get id => text()();
  TextColumn get networkId => text().references(Networks, #id)();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  TextColumn get status => text()();
  IntColumn get scanned => integer().withDefault(const Constant(0))();
  IntColumn get total => integer()();
  IntColumn get found => integer().withDefault(const Constant(0))();
  @override
  Set<Column> get primaryKey => {id};
}

class DeviceIdentifiers extends Table {
  TextColumn get id => text()();
  TextColumn get deviceId =>
      text().references(Devices, #id, onDelete: KeyAction.cascade)();
  TextColumn get type => text()();
  TextColumn get value => text()();
  IntColumn get stability => integer()();
  TextColumn get payload => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class IdentityEvidenceRows extends Table {
  TextColumn get id => text()();
  TextColumn get deviceId =>
      text().references(Devices, #id, onDelete: KeyAction.cascade)();
  TextColumn get source => text()();
  TextColumn get evidenceKey => text()();
  TextColumn get normalizedValue => text()();
  IntColumn get weight => integer()();
  IntColumn get observationCount => integer()();
  DateTimeColumn get expiresAt => dateTime().nullable()();
  TextColumn get payload => text()();
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('FingerprintRow')
class DeviceFingerprints extends Table {
  TextColumn get deviceId =>
      text().references(Devices, #id, onDelete: KeyAction.cascade)();
  TextColumn get payload => text()();
  DateTimeColumn get lastEvaluated => dateTime().nullable()();
  @override
  Set<Column> get primaryKey => {deviceId};
}

@DataClassName('OverrideRow')
class DeviceOverrides extends Table {
  TextColumn get deviceId =>
      text().references(Devices, #id, onDelete: KeyAction.cascade)();
  TextColumn get payload => text()();
  @override
  Set<Column> get primaryKey => {deviceId};
}

class PotentialSameDeviceLinks extends Table {
  @ReferenceName('possibleMatches')
  TextColumn get deviceId =>
      text().references(Devices, #id, onDelete: KeyAction.cascade)();
  @ReferenceName('matchedBy')
  TextColumn get otherDeviceId =>
      text().references(Devices, #id, onDelete: KeyAction.cascade)();
  TextColumn get reason => text()();
  @override
  Set<Column> get primaryKey => {deviceId, otherDeviceId};
}

@DataClassName('GuardianConversationRow')
class GuardianConversations extends Table {
  TextColumn get id => text()();
  TextColumn get networkId => text()();
  TextColumn get title => text().withDefault(const Constant('Network conversation'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('GuardianMessageRow')
class GuardianMessages extends Table {
  TextColumn get id => text()();
  TextColumn get conversationId => text().references(GuardianConversations, #id, onDelete: KeyAction.cascade)();
  TextColumn get role => text()();
  TextColumn get textBody => text()();
  TextColumn get payload => text()();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DiagnosticRunRow')
class DiagnosticRuns extends Table {
  TextColumn get id => text()();
  TextColumn get networkId => text()();
  TextColumn get status => text()();
  TextColumn get payload => text()();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Networks,
    Devices,
    DeviceServices,
    ScanSessions,
    DeviceIdentifiers,
    IdentityEvidenceRows,
    DeviceFingerprints,
    DeviceOverrides,
    PotentialSameDeviceLinks,
    GuardianConversations,
    GuardianMessages,
    DiagnosticRuns,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase()
    : super(
        LazyDatabase(() async {
          final folder = await getApplicationSupportDirectory();
          return NativeDatabase.createInBackground(
            File(p.join(folder.path, 'guardian.sqlite')),
          );
        }),
      );
  AppDatabase.testing(super.executor);
  @override
  int get schemaVersion => 3;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(deviceIdentifiers);
        await m.createTable(identityEvidenceRows);
        await m.createTable(deviceFingerprints);
        await m.createTable(deviceOverrides);
        await m.createTable(potentialSameDeviceLinks);
      }
      if (from < 3) {
        await m.createTable(guardianConversations);
        await m.createTable(guardianMessages);
        await m.createTable(diagnosticRuns);
      }
    },
    beforeOpen: (_) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await (update(scanSessions)..where((s) => s.endedAt.isNull())).write(
        ScanSessionsCompanion(
          status: const Value('interrupted'),
          endedAt: Value(DateTime.now()),
        ),
      );
    },
  );
  Future<String> network(NetworkInfo n) async {
    final old = await (select(
      networks,
    )..where((r) => r.fingerprint.equals(n.fingerprint))).getSingleOrNull();
    final id = old?.id ?? const Uuid().v4();
    await into(networks).insertOnConflictUpdate(
      NetworksCompanion.insert(
        id: id,
        fingerprint: n.fingerprint,
        ssid: Value(n.ssid),
        gatewayIp: Value(n.gateway),
        cidr: n.subnet.cidr,
        firstSeen: old?.firstSeen ?? DateTime.now(),
        lastSeen: DateTime.now(),
      ),
    );
    return id;
  }

  Future<List<Device>> loadDevices(String networkId) async {
    final rows =
        (await (select(
              devices,
            )..where((d) => d.networkId.equals(networkId))).get())
            .map((r) => Device.fromJson(jsonDecode(r.payload)))
            .toList();
    if (rows.isEmpty) return rows;
    final stored = await (select(
      deviceFingerprints,
    )..where((f) => f.deviceId.isIn(rows.map((d) => d.id)))).get();
    final byId = {for (final f in stored) f.deviceId: f};
    final legacy = <Device>[];
    for (final d in rows) {
      final f = byId[d.id];
      if (f != null) {
        d.fingerprint = DeviceFingerprint.fromJson(jsonDecode(f.payload));
      } else {
        EvidenceCollector().seedLegacy(d);
        legacy.add(d);
      }
    }
    if (legacy.isNotEmpty) await saveIntelligence(legacy);
    return rows;
  }

  Future<void> saveDeviceProfile(Device device) async {
    final row = await (select(devices)..where((d) => d.id.equals(device.id))).getSingleOrNull();
    if (row == null) return;
    await (update(devices)..where((d) => d.id.equals(device.id))).write(
      DevicesCompanion(
        ipAddress: Value(device.ipAddress),
        macAddress: Value(device.macAddress),
        payload: Value(jsonEncode(device.toJson())),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await saveIntelligence([device]);
  }

  Future<void> saveIntelligence(List<Device> rows) => transaction(() async {
    for (final d in rows) {
      final f = d.fingerprint;
      await (delete(
        deviceIdentifiers,
      )..where((r) => r.deviceId.equals(d.id))).go();
      await (delete(
        identityEvidenceRows,
      )..where((r) => r.deviceId.equals(d.id))).go();
      await (delete(
        deviceOverrides,
      )..where((r) => r.deviceId.equals(d.id))).go();
      await (delete(
        potentialSameDeviceLinks,
      )..where((r) => r.deviceId.equals(d.id))).go();
      await into(deviceFingerprints).insertOnConflictUpdate(
        DeviceFingerprintsCompanion.insert(
          deviceId: d.id,
          payload: jsonEncode(f.toJson()),
          lastEvaluated: Value(f.lastEvaluated),
        ),
      );
      await batch((b) {
        for (final i in f.identifiers) {
          b.insert(
            deviceIdentifiers,
            DeviceIdentifiersCompanion.insert(
              id: i.id,
              deviceId: d.id,
              type: i.type,
              value: i.value,
              stability: i.stability,
              payload: jsonEncode(i.toJson()),
            ),
          );
        }
        for (final e in f.evidence) {
          b.insert(
            identityEvidenceRows,
            IdentityEvidenceRowsCompanion.insert(
              id: e.id,
              deviceId: d.id,
              source: e.source,
              evidenceKey: e.key,
              normalizedValue: e.normalizedValue,
              weight: e.weight,
              observationCount: e.observationCount,
              expiresAt: Value(e.expiresAt),
              payload: jsonEncode(e.toJson()),
            ),
          );
        }
        if (f.override != null) {
          b.insert(
            deviceOverrides,
            DeviceOverridesCompanion.insert(
              deviceId: d.id,
              payload: jsonEncode(f.override!.toJson()),
            ),
          );
        }
      });
      for (final link in f.possibleSameDevices.entries) {
        final exists = await (select(
          devices,
        )..where((r) => r.id.equals(link.key))).getSingleOrNull();
        if (exists != null && link.key != d.id) {
          await into(potentialSameDeviceLinks).insertOnConflictUpdate(
            PotentialSameDeviceLinksCompanion.insert(
              deviceId: d.id,
              otherDeviceId: link.key,
              reason: link.value,
            ),
          );
        }
      }
    }
  });
  Future<void> begin(String id, String network, int total) =>
      into(scanSessions).insert(
        ScanSessionsCompanion.insert(
          id: id,
          networkId: network,
          startedAt: DateTime.now(),
          status: 'scanning',
          total: total,
        ),
      );
  Future<void> save(
    String session,
    String network,
    List<Device> rows,
    String status,
    int scanned,
    int found,
  ) => transaction(() async {
    // Preserve existing rows and their identity/override foreign keys. Only
    // records explicitly consolidated by reconciliation are removed.
    final retained = rows.map((d) => d.id).toList();
    await (delete(
      devices,
    )..where((d) => d.networkId.equals(network) & d.id.isNotIn(retained))).go();
    for (final d in rows) {
      await (delete(
        deviceServices,
      )..where((s) => s.deviceId.equals(d.id))).go();
    }
    await batch((b) {
      for (final d in rows) {
        b.insert(
          devices,
          DevicesCompanion.insert(
            id: d.id,
            networkId: network,
            ipAddress: d.ipAddress,
            macAddress: Value(d.macAddress),
            payload: jsonEncode(d.toJson()),
            createdAt: d.firstSeen,
            updatedAt: DateTime.now(),
          ),
          onConflict: DoUpdate(
            (_) => DevicesCompanion(
              ipAddress: Value(d.ipAddress),
              macAddress: Value(d.macAddress),
              payload: Value(jsonEncode(d.toJson())),
              updatedAt: Value(DateTime.now()),
            ),
          ),
        );
        for (final s in d.services) {
          b.insert(
            deviceServices,
            DeviceServicesCompanion.insert(
              deviceId: d.id,
              serviceKey: '${s['type']}|${s['name']}',
              payload: jsonEncode(s),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      }
    });
    await saveIntelligence(rows);
    await (update(scanSessions)..where((s) => s.id.equals(session))).write(
      ScanSessionsCompanion(
        status: Value(status),
        endedAt: Value(DateTime.now()),
        scanned: Value(scanned),
        found: Value(found),
      ),
    );
  });

  Future<String> guardianConversation(String networkId) async {
    final existing = await (select(guardianConversations)
          ..where((c) => c.networkId.equals(networkId))
          ..orderBy([(c) => OrderingTerm.desc(c.updatedAt)])
          ..limit(1))
        .getSingleOrNull();
    if (existing != null) return existing.id;
    final id = const Uuid().v4();
    final now = DateTime.now();
    await into(guardianConversations).insert(
      GuardianConversationsCompanion.insert(
        id: id,
        networkId: networkId,
        createdAt: now,
        updatedAt: now,
      ),
    );
    return id;
  }

  Future<List<GuardianMessage>> loadGuardianMessages(String networkId, {int limit = 60}) async {
    final conversationId = await guardianConversation(networkId);
    final rows = await (select(guardianMessages)
          ..where((m) => m.conversationId.equals(conversationId))
          ..orderBy([(m) => OrderingTerm.desc(m.createdAt)])
          ..limit(limit))
        .get();
    return rows.reversed
        .map((row) => GuardianMessage.fromJson(Map<String, dynamic>.from(jsonDecode(row.payload))))
        .toList();
  }

  Future<void> saveGuardianMessage(String networkId, GuardianMessage message) async {
    final conversationId = await guardianConversation(networkId);
    await transaction(() async {
      await into(guardianMessages).insertOnConflictUpdate(
        GuardianMessagesCompanion.insert(
          id: message.id,
          conversationId: conversationId,
          role: message.role.name,
          textBody: message.text,
          payload: jsonEncode(message.toJson()),
          createdAt: message.createdAt,
        ),
      );
      await (update(guardianConversations)..where((c) => c.id.equals(conversationId))).write(
        GuardianConversationsCompanion(updatedAt: Value(DateTime.now())),
      );
    });
  }

  Future<void> clearGuardianMessages(String networkId) async {
    final rows = await (select(guardianConversations)..where((c) => c.networkId.equals(networkId))).get();
    if (rows.isEmpty) return;
    await (delete(guardianConversations)..where((c) => c.id.isIn(rows.map((e) => e.id)))).go();
  }

  Future<void> saveDoctorReport(String networkId, DoctorReport report) async {
    await into(diagnosticRuns).insert(
      DiagnosticRunsCompanion.insert(
        id: const Uuid().v4(),
        networkId: networkId,
        status: report.status.name,
        payload: jsonEncode(report.toJson()),
        createdAt: report.createdAt,
      ),
    );
  }

  Future<DoctorReport?> latestDoctorReport(String networkId) async {
    final row = await (select(diagnosticRuns)
          ..where((r) => r.networkId.equals(networkId))
          ..orderBy([(r) => OrderingTerm.desc(r.createdAt)])
          ..limit(1))
        .getSingleOrNull();
    if (row == null) return null;
    return DoctorReport.fromJson(Map<String, dynamic>.from(jsonDecode(row.payload)));
  }

}
