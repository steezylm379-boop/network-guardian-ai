// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $NetworksTable extends Networks with TableInfo<$NetworksTable, Network> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NetworksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fingerprintMeta = const VerificationMeta(
    'fingerprint',
  );
  @override
  late final GeneratedColumn<String> fingerprint = GeneratedColumn<String>(
    'fingerprint',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _ssidMeta = const VerificationMeta('ssid');
  @override
  late final GeneratedColumn<String> ssid = GeneratedColumn<String>(
    'ssid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gatewayIpMeta = const VerificationMeta(
    'gatewayIp',
  );
  @override
  late final GeneratedColumn<String> gatewayIp = GeneratedColumn<String>(
    'gateway_ip',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cidrMeta = const VerificationMeta('cidr');
  @override
  late final GeneratedColumn<String> cidr = GeneratedColumn<String>(
    'cidr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstSeenMeta = const VerificationMeta(
    'firstSeen',
  );
  @override
  late final GeneratedColumn<DateTime> firstSeen = GeneratedColumn<DateTime>(
    'first_seen',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSeenMeta = const VerificationMeta(
    'lastSeen',
  );
  @override
  late final GeneratedColumn<DateTime> lastSeen = GeneratedColumn<DateTime>(
    'last_seen',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fingerprint,
    ssid,
    gatewayIp,
    cidr,
    firstSeen,
    lastSeen,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'networks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Network> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('fingerprint')) {
      context.handle(
        _fingerprintMeta,
        fingerprint.isAcceptableOrUnknown(
          data['fingerprint']!,
          _fingerprintMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fingerprintMeta);
    }
    if (data.containsKey('ssid')) {
      context.handle(
        _ssidMeta,
        ssid.isAcceptableOrUnknown(data['ssid']!, _ssidMeta),
      );
    }
    if (data.containsKey('gateway_ip')) {
      context.handle(
        _gatewayIpMeta,
        gatewayIp.isAcceptableOrUnknown(data['gateway_ip']!, _gatewayIpMeta),
      );
    }
    if (data.containsKey('cidr')) {
      context.handle(
        _cidrMeta,
        cidr.isAcceptableOrUnknown(data['cidr']!, _cidrMeta),
      );
    } else if (isInserting) {
      context.missing(_cidrMeta);
    }
    if (data.containsKey('first_seen')) {
      context.handle(
        _firstSeenMeta,
        firstSeen.isAcceptableOrUnknown(data['first_seen']!, _firstSeenMeta),
      );
    } else if (isInserting) {
      context.missing(_firstSeenMeta);
    }
    if (data.containsKey('last_seen')) {
      context.handle(
        _lastSeenMeta,
        lastSeen.isAcceptableOrUnknown(data['last_seen']!, _lastSeenMeta),
      );
    } else if (isInserting) {
      context.missing(_lastSeenMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Network map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Network(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fingerprint'],
      )!,
      ssid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ssid'],
      ),
      gatewayIp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gateway_ip'],
      ),
      cidr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cidr'],
      )!,
      firstSeen: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}first_seen'],
      )!,
      lastSeen: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_seen'],
      )!,
    );
  }

  @override
  $NetworksTable createAlias(String alias) {
    return $NetworksTable(attachedDatabase, alias);
  }
}

class Network extends DataClass implements Insertable<Network> {
  final String id;
  final String fingerprint;
  final String? ssid;
  final String? gatewayIp;
  final String cidr;
  final DateTime firstSeen;
  final DateTime lastSeen;
  const Network({
    required this.id,
    required this.fingerprint,
    this.ssid,
    this.gatewayIp,
    required this.cidr,
    required this.firstSeen,
    required this.lastSeen,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['fingerprint'] = Variable<String>(fingerprint);
    if (!nullToAbsent || ssid != null) {
      map['ssid'] = Variable<String>(ssid);
    }
    if (!nullToAbsent || gatewayIp != null) {
      map['gateway_ip'] = Variable<String>(gatewayIp);
    }
    map['cidr'] = Variable<String>(cidr);
    map['first_seen'] = Variable<DateTime>(firstSeen);
    map['last_seen'] = Variable<DateTime>(lastSeen);
    return map;
  }

  NetworksCompanion toCompanion(bool nullToAbsent) {
    return NetworksCompanion(
      id: Value(id),
      fingerprint: Value(fingerprint),
      ssid: ssid == null && nullToAbsent ? const Value.absent() : Value(ssid),
      gatewayIp: gatewayIp == null && nullToAbsent
          ? const Value.absent()
          : Value(gatewayIp),
      cidr: Value(cidr),
      firstSeen: Value(firstSeen),
      lastSeen: Value(lastSeen),
    );
  }

  factory Network.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Network(
      id: serializer.fromJson<String>(json['id']),
      fingerprint: serializer.fromJson<String>(json['fingerprint']),
      ssid: serializer.fromJson<String?>(json['ssid']),
      gatewayIp: serializer.fromJson<String?>(json['gatewayIp']),
      cidr: serializer.fromJson<String>(json['cidr']),
      firstSeen: serializer.fromJson<DateTime>(json['firstSeen']),
      lastSeen: serializer.fromJson<DateTime>(json['lastSeen']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fingerprint': serializer.toJson<String>(fingerprint),
      'ssid': serializer.toJson<String?>(ssid),
      'gatewayIp': serializer.toJson<String?>(gatewayIp),
      'cidr': serializer.toJson<String>(cidr),
      'firstSeen': serializer.toJson<DateTime>(firstSeen),
      'lastSeen': serializer.toJson<DateTime>(lastSeen),
    };
  }

  Network copyWith({
    String? id,
    String? fingerprint,
    Value<String?> ssid = const Value.absent(),
    Value<String?> gatewayIp = const Value.absent(),
    String? cidr,
    DateTime? firstSeen,
    DateTime? lastSeen,
  }) => Network(
    id: id ?? this.id,
    fingerprint: fingerprint ?? this.fingerprint,
    ssid: ssid.present ? ssid.value : this.ssid,
    gatewayIp: gatewayIp.present ? gatewayIp.value : this.gatewayIp,
    cidr: cidr ?? this.cidr,
    firstSeen: firstSeen ?? this.firstSeen,
    lastSeen: lastSeen ?? this.lastSeen,
  );
  Network copyWithCompanion(NetworksCompanion data) {
    return Network(
      id: data.id.present ? data.id.value : this.id,
      fingerprint: data.fingerprint.present
          ? data.fingerprint.value
          : this.fingerprint,
      ssid: data.ssid.present ? data.ssid.value : this.ssid,
      gatewayIp: data.gatewayIp.present ? data.gatewayIp.value : this.gatewayIp,
      cidr: data.cidr.present ? data.cidr.value : this.cidr,
      firstSeen: data.firstSeen.present ? data.firstSeen.value : this.firstSeen,
      lastSeen: data.lastSeen.present ? data.lastSeen.value : this.lastSeen,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Network(')
          ..write('id: $id, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('ssid: $ssid, ')
          ..write('gatewayIp: $gatewayIp, ')
          ..write('cidr: $cidr, ')
          ..write('firstSeen: $firstSeen, ')
          ..write('lastSeen: $lastSeen')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, fingerprint, ssid, gatewayIp, cidr, firstSeen, lastSeen);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Network &&
          other.id == this.id &&
          other.fingerprint == this.fingerprint &&
          other.ssid == this.ssid &&
          other.gatewayIp == this.gatewayIp &&
          other.cidr == this.cidr &&
          other.firstSeen == this.firstSeen &&
          other.lastSeen == this.lastSeen);
}

class NetworksCompanion extends UpdateCompanion<Network> {
  final Value<String> id;
  final Value<String> fingerprint;
  final Value<String?> ssid;
  final Value<String?> gatewayIp;
  final Value<String> cidr;
  final Value<DateTime> firstSeen;
  final Value<DateTime> lastSeen;
  final Value<int> rowid;
  const NetworksCompanion({
    this.id = const Value.absent(),
    this.fingerprint = const Value.absent(),
    this.ssid = const Value.absent(),
    this.gatewayIp = const Value.absent(),
    this.cidr = const Value.absent(),
    this.firstSeen = const Value.absent(),
    this.lastSeen = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NetworksCompanion.insert({
    required String id,
    required String fingerprint,
    this.ssid = const Value.absent(),
    this.gatewayIp = const Value.absent(),
    required String cidr,
    required DateTime firstSeen,
    required DateTime lastSeen,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       fingerprint = Value(fingerprint),
       cidr = Value(cidr),
       firstSeen = Value(firstSeen),
       lastSeen = Value(lastSeen);
  static Insertable<Network> custom({
    Expression<String>? id,
    Expression<String>? fingerprint,
    Expression<String>? ssid,
    Expression<String>? gatewayIp,
    Expression<String>? cidr,
    Expression<DateTime>? firstSeen,
    Expression<DateTime>? lastSeen,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fingerprint != null) 'fingerprint': fingerprint,
      if (ssid != null) 'ssid': ssid,
      if (gatewayIp != null) 'gateway_ip': gatewayIp,
      if (cidr != null) 'cidr': cidr,
      if (firstSeen != null) 'first_seen': firstSeen,
      if (lastSeen != null) 'last_seen': lastSeen,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NetworksCompanion copyWith({
    Value<String>? id,
    Value<String>? fingerprint,
    Value<String?>? ssid,
    Value<String?>? gatewayIp,
    Value<String>? cidr,
    Value<DateTime>? firstSeen,
    Value<DateTime>? lastSeen,
    Value<int>? rowid,
  }) {
    return NetworksCompanion(
      id: id ?? this.id,
      fingerprint: fingerprint ?? this.fingerprint,
      ssid: ssid ?? this.ssid,
      gatewayIp: gatewayIp ?? this.gatewayIp,
      cidr: cidr ?? this.cidr,
      firstSeen: firstSeen ?? this.firstSeen,
      lastSeen: lastSeen ?? this.lastSeen,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fingerprint.present) {
      map['fingerprint'] = Variable<String>(fingerprint.value);
    }
    if (ssid.present) {
      map['ssid'] = Variable<String>(ssid.value);
    }
    if (gatewayIp.present) {
      map['gateway_ip'] = Variable<String>(gatewayIp.value);
    }
    if (cidr.present) {
      map['cidr'] = Variable<String>(cidr.value);
    }
    if (firstSeen.present) {
      map['first_seen'] = Variable<DateTime>(firstSeen.value);
    }
    if (lastSeen.present) {
      map['last_seen'] = Variable<DateTime>(lastSeen.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NetworksCompanion(')
          ..write('id: $id, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('ssid: $ssid, ')
          ..write('gatewayIp: $gatewayIp, ')
          ..write('cidr: $cidr, ')
          ..write('firstSeen: $firstSeen, ')
          ..write('lastSeen: $lastSeen, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DevicesTable extends Devices with TableInfo<$DevicesTable, DeviceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DevicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _networkIdMeta = const VerificationMeta(
    'networkId',
  );
  @override
  late final GeneratedColumn<String> networkId = GeneratedColumn<String>(
    'network_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES networks (id)',
    ),
  );
  static const VerificationMeta _ipAddressMeta = const VerificationMeta(
    'ipAddress',
  );
  @override
  late final GeneratedColumn<String> ipAddress = GeneratedColumn<String>(
    'ip_address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _macAddressMeta = const VerificationMeta(
    'macAddress',
  );
  @override
  late final GeneratedColumn<String> macAddress = GeneratedColumn<String>(
    'mac_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    networkId,
    ipAddress,
    macAddress,
    payload,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'devices';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeviceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('network_id')) {
      context.handle(
        _networkIdMeta,
        networkId.isAcceptableOrUnknown(data['network_id']!, _networkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_networkIdMeta);
    }
    if (data.containsKey('ip_address')) {
      context.handle(
        _ipAddressMeta,
        ipAddress.isAcceptableOrUnknown(data['ip_address']!, _ipAddressMeta),
      );
    } else if (isInserting) {
      context.missing(_ipAddressMeta);
    }
    if (data.containsKey('mac_address')) {
      context.handle(
        _macAddressMeta,
        macAddress.isAcceptableOrUnknown(data['mac_address']!, _macAddressMeta),
      );
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeviceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      networkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}network_id'],
      )!,
      ipAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ip_address'],
      )!,
      macAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mac_address'],
      ),
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DevicesTable createAlias(String alias) {
    return $DevicesTable(attachedDatabase, alias);
  }
}

class DeviceRow extends DataClass implements Insertable<DeviceRow> {
  final String id;
  final String networkId;
  final String ipAddress;
  final String? macAddress;
  final String payload;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DeviceRow({
    required this.id,
    required this.networkId,
    required this.ipAddress,
    this.macAddress,
    required this.payload,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['network_id'] = Variable<String>(networkId);
    map['ip_address'] = Variable<String>(ipAddress);
    if (!nullToAbsent || macAddress != null) {
      map['mac_address'] = Variable<String>(macAddress);
    }
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DevicesCompanion toCompanion(bool nullToAbsent) {
    return DevicesCompanion(
      id: Value(id),
      networkId: Value(networkId),
      ipAddress: Value(ipAddress),
      macAddress: macAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(macAddress),
      payload: Value(payload),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DeviceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceRow(
      id: serializer.fromJson<String>(json['id']),
      networkId: serializer.fromJson<String>(json['networkId']),
      ipAddress: serializer.fromJson<String>(json['ipAddress']),
      macAddress: serializer.fromJson<String?>(json['macAddress']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'networkId': serializer.toJson<String>(networkId),
      'ipAddress': serializer.toJson<String>(ipAddress),
      'macAddress': serializer.toJson<String?>(macAddress),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DeviceRow copyWith({
    String? id,
    String? networkId,
    String? ipAddress,
    Value<String?> macAddress = const Value.absent(),
    String? payload,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DeviceRow(
    id: id ?? this.id,
    networkId: networkId ?? this.networkId,
    ipAddress: ipAddress ?? this.ipAddress,
    macAddress: macAddress.present ? macAddress.value : this.macAddress,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DeviceRow copyWithCompanion(DevicesCompanion data) {
    return DeviceRow(
      id: data.id.present ? data.id.value : this.id,
      networkId: data.networkId.present ? data.networkId.value : this.networkId,
      ipAddress: data.ipAddress.present ? data.ipAddress.value : this.ipAddress,
      macAddress: data.macAddress.present
          ? data.macAddress.value
          : this.macAddress,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeviceRow(')
          ..write('id: $id, ')
          ..write('networkId: $networkId, ')
          ..write('ipAddress: $ipAddress, ')
          ..write('macAddress: $macAddress, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    networkId,
    ipAddress,
    macAddress,
    payload,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceRow &&
          other.id == this.id &&
          other.networkId == this.networkId &&
          other.ipAddress == this.ipAddress &&
          other.macAddress == this.macAddress &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DevicesCompanion extends UpdateCompanion<DeviceRow> {
  final Value<String> id;
  final Value<String> networkId;
  final Value<String> ipAddress;
  final Value<String?> macAddress;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DevicesCompanion({
    this.id = const Value.absent(),
    this.networkId = const Value.absent(),
    this.ipAddress = const Value.absent(),
    this.macAddress = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DevicesCompanion.insert({
    required String id,
    required String networkId,
    required String ipAddress,
    this.macAddress = const Value.absent(),
    required String payload,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       networkId = Value(networkId),
       ipAddress = Value(ipAddress),
       payload = Value(payload),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DeviceRow> custom({
    Expression<String>? id,
    Expression<String>? networkId,
    Expression<String>? ipAddress,
    Expression<String>? macAddress,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (networkId != null) 'network_id': networkId,
      if (ipAddress != null) 'ip_address': ipAddress,
      if (macAddress != null) 'mac_address': macAddress,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DevicesCompanion copyWith({
    Value<String>? id,
    Value<String>? networkId,
    Value<String>? ipAddress,
    Value<String?>? macAddress,
    Value<String>? payload,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DevicesCompanion(
      id: id ?? this.id,
      networkId: networkId ?? this.networkId,
      ipAddress: ipAddress ?? this.ipAddress,
      macAddress: macAddress ?? this.macAddress,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (networkId.present) {
      map['network_id'] = Variable<String>(networkId.value);
    }
    if (ipAddress.present) {
      map['ip_address'] = Variable<String>(ipAddress.value);
    }
    if (macAddress.present) {
      map['mac_address'] = Variable<String>(macAddress.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DevicesCompanion(')
          ..write('id: $id, ')
          ..write('networkId: $networkId, ')
          ..write('ipAddress: $ipAddress, ')
          ..write('macAddress: $macAddress, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeviceServicesTable extends DeviceServices
    with TableInfo<$DeviceServicesTable, DeviceService> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeviceServicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES devices (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _serviceKeyMeta = const VerificationMeta(
    'serviceKey',
  );
  @override
  late final GeneratedColumn<String> serviceKey = GeneratedColumn<String>(
    'service_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [deviceId, serviceKey, payload];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'device_services';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeviceService> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('service_key')) {
      context.handle(
        _serviceKeyMeta,
        serviceKey.isAcceptableOrUnknown(data['service_key']!, _serviceKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_serviceKeyMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {deviceId, serviceKey};
  @override
  DeviceService map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceService(
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      serviceKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_key'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
    );
  }

  @override
  $DeviceServicesTable createAlias(String alias) {
    return $DeviceServicesTable(attachedDatabase, alias);
  }
}

class DeviceService extends DataClass implements Insertable<DeviceService> {
  final String deviceId;
  final String serviceKey;
  final String payload;
  const DeviceService({
    required this.deviceId,
    required this.serviceKey,
    required this.payload,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['device_id'] = Variable<String>(deviceId);
    map['service_key'] = Variable<String>(serviceKey);
    map['payload'] = Variable<String>(payload);
    return map;
  }

  DeviceServicesCompanion toCompanion(bool nullToAbsent) {
    return DeviceServicesCompanion(
      deviceId: Value(deviceId),
      serviceKey: Value(serviceKey),
      payload: Value(payload),
    );
  }

  factory DeviceService.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceService(
      deviceId: serializer.fromJson<String>(json['deviceId']),
      serviceKey: serializer.fromJson<String>(json['serviceKey']),
      payload: serializer.fromJson<String>(json['payload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'deviceId': serializer.toJson<String>(deviceId),
      'serviceKey': serializer.toJson<String>(serviceKey),
      'payload': serializer.toJson<String>(payload),
    };
  }

  DeviceService copyWith({
    String? deviceId,
    String? serviceKey,
    String? payload,
  }) => DeviceService(
    deviceId: deviceId ?? this.deviceId,
    serviceKey: serviceKey ?? this.serviceKey,
    payload: payload ?? this.payload,
  );
  DeviceService copyWithCompanion(DeviceServicesCompanion data) {
    return DeviceService(
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      serviceKey: data.serviceKey.present
          ? data.serviceKey.value
          : this.serviceKey,
      payload: data.payload.present ? data.payload.value : this.payload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeviceService(')
          ..write('deviceId: $deviceId, ')
          ..write('serviceKey: $serviceKey, ')
          ..write('payload: $payload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(deviceId, serviceKey, payload);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceService &&
          other.deviceId == this.deviceId &&
          other.serviceKey == this.serviceKey &&
          other.payload == this.payload);
}

class DeviceServicesCompanion extends UpdateCompanion<DeviceService> {
  final Value<String> deviceId;
  final Value<String> serviceKey;
  final Value<String> payload;
  final Value<int> rowid;
  const DeviceServicesCompanion({
    this.deviceId = const Value.absent(),
    this.serviceKey = const Value.absent(),
    this.payload = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeviceServicesCompanion.insert({
    required String deviceId,
    required String serviceKey,
    required String payload,
    this.rowid = const Value.absent(),
  }) : deviceId = Value(deviceId),
       serviceKey = Value(serviceKey),
       payload = Value(payload);
  static Insertable<DeviceService> custom({
    Expression<String>? deviceId,
    Expression<String>? serviceKey,
    Expression<String>? payload,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (deviceId != null) 'device_id': deviceId,
      if (serviceKey != null) 'service_key': serviceKey,
      if (payload != null) 'payload': payload,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeviceServicesCompanion copyWith({
    Value<String>? deviceId,
    Value<String>? serviceKey,
    Value<String>? payload,
    Value<int>? rowid,
  }) {
    return DeviceServicesCompanion(
      deviceId: deviceId ?? this.deviceId,
      serviceKey: serviceKey ?? this.serviceKey,
      payload: payload ?? this.payload,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (serviceKey.present) {
      map['service_key'] = Variable<String>(serviceKey.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeviceServicesCompanion(')
          ..write('deviceId: $deviceId, ')
          ..write('serviceKey: $serviceKey, ')
          ..write('payload: $payload, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScanSessionsTable extends ScanSessions
    with TableInfo<$ScanSessionsTable, ScanSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScanSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _networkIdMeta = const VerificationMeta(
    'networkId',
  );
  @override
  late final GeneratedColumn<String> networkId = GeneratedColumn<String>(
    'network_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES networks (id)',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scannedMeta = const VerificationMeta(
    'scanned',
  );
  @override
  late final GeneratedColumn<int> scanned = GeneratedColumn<int>(
    'scanned',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foundMeta = const VerificationMeta('found');
  @override
  late final GeneratedColumn<int> found = GeneratedColumn<int>(
    'found',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    networkId,
    startedAt,
    endedAt,
    status,
    scanned,
    total,
    found,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scan_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScanSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('network_id')) {
      context.handle(
        _networkIdMeta,
        networkId.isAcceptableOrUnknown(data['network_id']!, _networkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_networkIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('scanned')) {
      context.handle(
        _scannedMeta,
        scanned.isAcceptableOrUnknown(data['scanned']!, _scannedMeta),
      );
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('found')) {
      context.handle(
        _foundMeta,
        found.isAcceptableOrUnknown(data['found']!, _foundMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScanSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScanSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      networkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}network_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      scanned: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scanned'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      )!,
      found: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}found'],
      )!,
    );
  }

  @override
  $ScanSessionsTable createAlias(String alias) {
    return $ScanSessionsTable(attachedDatabase, alias);
  }
}

class ScanSession extends DataClass implements Insertable<ScanSession> {
  final String id;
  final String networkId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String status;
  final int scanned;
  final int total;
  final int found;
  const ScanSession({
    required this.id,
    required this.networkId,
    required this.startedAt,
    this.endedAt,
    required this.status,
    required this.scanned,
    required this.total,
    required this.found,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['network_id'] = Variable<String>(networkId);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['status'] = Variable<String>(status);
    map['scanned'] = Variable<int>(scanned);
    map['total'] = Variable<int>(total);
    map['found'] = Variable<int>(found);
    return map;
  }

  ScanSessionsCompanion toCompanion(bool nullToAbsent) {
    return ScanSessionsCompanion(
      id: Value(id),
      networkId: Value(networkId),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      status: Value(status),
      scanned: Value(scanned),
      total: Value(total),
      found: Value(found),
    );
  }

  factory ScanSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScanSession(
      id: serializer.fromJson<String>(json['id']),
      networkId: serializer.fromJson<String>(json['networkId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      status: serializer.fromJson<String>(json['status']),
      scanned: serializer.fromJson<int>(json['scanned']),
      total: serializer.fromJson<int>(json['total']),
      found: serializer.fromJson<int>(json['found']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'networkId': serializer.toJson<String>(networkId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'status': serializer.toJson<String>(status),
      'scanned': serializer.toJson<int>(scanned),
      'total': serializer.toJson<int>(total),
      'found': serializer.toJson<int>(found),
    };
  }

  ScanSession copyWith({
    String? id,
    String? networkId,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    String? status,
    int? scanned,
    int? total,
    int? found,
  }) => ScanSession(
    id: id ?? this.id,
    networkId: networkId ?? this.networkId,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    status: status ?? this.status,
    scanned: scanned ?? this.scanned,
    total: total ?? this.total,
    found: found ?? this.found,
  );
  ScanSession copyWithCompanion(ScanSessionsCompanion data) {
    return ScanSession(
      id: data.id.present ? data.id.value : this.id,
      networkId: data.networkId.present ? data.networkId.value : this.networkId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      status: data.status.present ? data.status.value : this.status,
      scanned: data.scanned.present ? data.scanned.value : this.scanned,
      total: data.total.present ? data.total.value : this.total,
      found: data.found.present ? data.found.value : this.found,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScanSession(')
          ..write('id: $id, ')
          ..write('networkId: $networkId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('status: $status, ')
          ..write('scanned: $scanned, ')
          ..write('total: $total, ')
          ..write('found: $found')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    networkId,
    startedAt,
    endedAt,
    status,
    scanned,
    total,
    found,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScanSession &&
          other.id == this.id &&
          other.networkId == this.networkId &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.status == this.status &&
          other.scanned == this.scanned &&
          other.total == this.total &&
          other.found == this.found);
}

class ScanSessionsCompanion extends UpdateCompanion<ScanSession> {
  final Value<String> id;
  final Value<String> networkId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<String> status;
  final Value<int> scanned;
  final Value<int> total;
  final Value<int> found;
  final Value<int> rowid;
  const ScanSessionsCompanion({
    this.id = const Value.absent(),
    this.networkId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.scanned = const Value.absent(),
    this.total = const Value.absent(),
    this.found = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScanSessionsCompanion.insert({
    required String id,
    required String networkId,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    required String status,
    this.scanned = const Value.absent(),
    required int total,
    this.found = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       networkId = Value(networkId),
       startedAt = Value(startedAt),
       status = Value(status),
       total = Value(total);
  static Insertable<ScanSession> custom({
    Expression<String>? id,
    Expression<String>? networkId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<String>? status,
    Expression<int>? scanned,
    Expression<int>? total,
    Expression<int>? found,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (networkId != null) 'network_id': networkId,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (status != null) 'status': status,
      if (scanned != null) 'scanned': scanned,
      if (total != null) 'total': total,
      if (found != null) 'found': found,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScanSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? networkId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<String>? status,
    Value<int>? scanned,
    Value<int>? total,
    Value<int>? found,
    Value<int>? rowid,
  }) {
    return ScanSessionsCompanion(
      id: id ?? this.id,
      networkId: networkId ?? this.networkId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      status: status ?? this.status,
      scanned: scanned ?? this.scanned,
      total: total ?? this.total,
      found: found ?? this.found,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (networkId.present) {
      map['network_id'] = Variable<String>(networkId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (scanned.present) {
      map['scanned'] = Variable<int>(scanned.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (found.present) {
      map['found'] = Variable<int>(found.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScanSessionsCompanion(')
          ..write('id: $id, ')
          ..write('networkId: $networkId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('status: $status, ')
          ..write('scanned: $scanned, ')
          ..write('total: $total, ')
          ..write('found: $found, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeviceIdentifiersTable extends DeviceIdentifiers
    with TableInfo<$DeviceIdentifiersTable, DeviceIdentifier> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeviceIdentifiersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES devices (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stabilityMeta = const VerificationMeta(
    'stability',
  );
  @override
  late final GeneratedColumn<int> stability = GeneratedColumn<int>(
    'stability',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deviceId,
    type,
    value,
    stability,
    payload,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'device_identifiers';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeviceIdentifier> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('stability')) {
      context.handle(
        _stabilityMeta,
        stability.isAcceptableOrUnknown(data['stability']!, _stabilityMeta),
      );
    } else if (isInserting) {
      context.missing(_stabilityMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeviceIdentifier map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceIdentifier(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      stability: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stability'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
    );
  }

  @override
  $DeviceIdentifiersTable createAlias(String alias) {
    return $DeviceIdentifiersTable(attachedDatabase, alias);
  }
}

class DeviceIdentifier extends DataClass
    implements Insertable<DeviceIdentifier> {
  final String id;
  final String deviceId;
  final String type;
  final String value;
  final int stability;
  final String payload;
  const DeviceIdentifier({
    required this.id,
    required this.deviceId,
    required this.type,
    required this.value,
    required this.stability,
    required this.payload,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['device_id'] = Variable<String>(deviceId);
    map['type'] = Variable<String>(type);
    map['value'] = Variable<String>(value);
    map['stability'] = Variable<int>(stability);
    map['payload'] = Variable<String>(payload);
    return map;
  }

  DeviceIdentifiersCompanion toCompanion(bool nullToAbsent) {
    return DeviceIdentifiersCompanion(
      id: Value(id),
      deviceId: Value(deviceId),
      type: Value(type),
      value: Value(value),
      stability: Value(stability),
      payload: Value(payload),
    );
  }

  factory DeviceIdentifier.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceIdentifier(
      id: serializer.fromJson<String>(json['id']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      type: serializer.fromJson<String>(json['type']),
      value: serializer.fromJson<String>(json['value']),
      stability: serializer.fromJson<int>(json['stability']),
      payload: serializer.fromJson<String>(json['payload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'deviceId': serializer.toJson<String>(deviceId),
      'type': serializer.toJson<String>(type),
      'value': serializer.toJson<String>(value),
      'stability': serializer.toJson<int>(stability),
      'payload': serializer.toJson<String>(payload),
    };
  }

  DeviceIdentifier copyWith({
    String? id,
    String? deviceId,
    String? type,
    String? value,
    int? stability,
    String? payload,
  }) => DeviceIdentifier(
    id: id ?? this.id,
    deviceId: deviceId ?? this.deviceId,
    type: type ?? this.type,
    value: value ?? this.value,
    stability: stability ?? this.stability,
    payload: payload ?? this.payload,
  );
  DeviceIdentifier copyWithCompanion(DeviceIdentifiersCompanion data) {
    return DeviceIdentifier(
      id: data.id.present ? data.id.value : this.id,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      type: data.type.present ? data.type.value : this.type,
      value: data.value.present ? data.value.value : this.value,
      stability: data.stability.present ? data.stability.value : this.stability,
      payload: data.payload.present ? data.payload.value : this.payload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeviceIdentifier(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('stability: $stability, ')
          ..write('payload: $payload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, deviceId, type, value, stability, payload);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceIdentifier &&
          other.id == this.id &&
          other.deviceId == this.deviceId &&
          other.type == this.type &&
          other.value == this.value &&
          other.stability == this.stability &&
          other.payload == this.payload);
}

class DeviceIdentifiersCompanion extends UpdateCompanion<DeviceIdentifier> {
  final Value<String> id;
  final Value<String> deviceId;
  final Value<String> type;
  final Value<String> value;
  final Value<int> stability;
  final Value<String> payload;
  final Value<int> rowid;
  const DeviceIdentifiersCompanion({
    this.id = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.type = const Value.absent(),
    this.value = const Value.absent(),
    this.stability = const Value.absent(),
    this.payload = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeviceIdentifiersCompanion.insert({
    required String id,
    required String deviceId,
    required String type,
    required String value,
    required int stability,
    required String payload,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       deviceId = Value(deviceId),
       type = Value(type),
       value = Value(value),
       stability = Value(stability),
       payload = Value(payload);
  static Insertable<DeviceIdentifier> custom({
    Expression<String>? id,
    Expression<String>? deviceId,
    Expression<String>? type,
    Expression<String>? value,
    Expression<int>? stability,
    Expression<String>? payload,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceId != null) 'device_id': deviceId,
      if (type != null) 'type': type,
      if (value != null) 'value': value,
      if (stability != null) 'stability': stability,
      if (payload != null) 'payload': payload,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeviceIdentifiersCompanion copyWith({
    Value<String>? id,
    Value<String>? deviceId,
    Value<String>? type,
    Value<String>? value,
    Value<int>? stability,
    Value<String>? payload,
    Value<int>? rowid,
  }) {
    return DeviceIdentifiersCompanion(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      type: type ?? this.type,
      value: value ?? this.value,
      stability: stability ?? this.stability,
      payload: payload ?? this.payload,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (stability.present) {
      map['stability'] = Variable<int>(stability.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeviceIdentifiersCompanion(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('stability: $stability, ')
          ..write('payload: $payload, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IdentityEvidenceRowsTable extends IdentityEvidenceRows
    with TableInfo<$IdentityEvidenceRowsTable, IdentityEvidenceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IdentityEvidenceRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES devices (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _evidenceKeyMeta = const VerificationMeta(
    'evidenceKey',
  );
  @override
  late final GeneratedColumn<String> evidenceKey = GeneratedColumn<String>(
    'evidence_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _normalizedValueMeta = const VerificationMeta(
    'normalizedValue',
  );
  @override
  late final GeneratedColumn<String> normalizedValue = GeneratedColumn<String>(
    'normalized_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<int> weight = GeneratedColumn<int>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _observationCountMeta = const VerificationMeta(
    'observationCount',
  );
  @override
  late final GeneratedColumn<int> observationCount = GeneratedColumn<int>(
    'observation_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deviceId,
    source,
    evidenceKey,
    normalizedValue,
    weight,
    observationCount,
    expiresAt,
    payload,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'identity_evidence_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<IdentityEvidenceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('evidence_key')) {
      context.handle(
        _evidenceKeyMeta,
        evidenceKey.isAcceptableOrUnknown(
          data['evidence_key']!,
          _evidenceKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_evidenceKeyMeta);
    }
    if (data.containsKey('normalized_value')) {
      context.handle(
        _normalizedValueMeta,
        normalizedValue.isAcceptableOrUnknown(
          data['normalized_value']!,
          _normalizedValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_normalizedValueMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('observation_count')) {
      context.handle(
        _observationCountMeta,
        observationCount.isAcceptableOrUnknown(
          data['observation_count']!,
          _observationCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_observationCountMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IdentityEvidenceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IdentityEvidenceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      evidenceKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}evidence_key'],
      )!,
      normalizedValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_value'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weight'],
      )!,
      observationCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}observation_count'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      ),
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
    );
  }

  @override
  $IdentityEvidenceRowsTable createAlias(String alias) {
    return $IdentityEvidenceRowsTable(attachedDatabase, alias);
  }
}

class IdentityEvidenceRow extends DataClass
    implements Insertable<IdentityEvidenceRow> {
  final String id;
  final String deviceId;
  final String source;
  final String evidenceKey;
  final String normalizedValue;
  final int weight;
  final int observationCount;
  final DateTime? expiresAt;
  final String payload;
  const IdentityEvidenceRow({
    required this.id,
    required this.deviceId,
    required this.source,
    required this.evidenceKey,
    required this.normalizedValue,
    required this.weight,
    required this.observationCount,
    this.expiresAt,
    required this.payload,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['device_id'] = Variable<String>(deviceId);
    map['source'] = Variable<String>(source);
    map['evidence_key'] = Variable<String>(evidenceKey);
    map['normalized_value'] = Variable<String>(normalizedValue);
    map['weight'] = Variable<int>(weight);
    map['observation_count'] = Variable<int>(observationCount);
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    map['payload'] = Variable<String>(payload);
    return map;
  }

  IdentityEvidenceRowsCompanion toCompanion(bool nullToAbsent) {
    return IdentityEvidenceRowsCompanion(
      id: Value(id),
      deviceId: Value(deviceId),
      source: Value(source),
      evidenceKey: Value(evidenceKey),
      normalizedValue: Value(normalizedValue),
      weight: Value(weight),
      observationCount: Value(observationCount),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
      payload: Value(payload),
    );
  }

  factory IdentityEvidenceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IdentityEvidenceRow(
      id: serializer.fromJson<String>(json['id']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      source: serializer.fromJson<String>(json['source']),
      evidenceKey: serializer.fromJson<String>(json['evidenceKey']),
      normalizedValue: serializer.fromJson<String>(json['normalizedValue']),
      weight: serializer.fromJson<int>(json['weight']),
      observationCount: serializer.fromJson<int>(json['observationCount']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
      payload: serializer.fromJson<String>(json['payload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'deviceId': serializer.toJson<String>(deviceId),
      'source': serializer.toJson<String>(source),
      'evidenceKey': serializer.toJson<String>(evidenceKey),
      'normalizedValue': serializer.toJson<String>(normalizedValue),
      'weight': serializer.toJson<int>(weight),
      'observationCount': serializer.toJson<int>(observationCount),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
      'payload': serializer.toJson<String>(payload),
    };
  }

  IdentityEvidenceRow copyWith({
    String? id,
    String? deviceId,
    String? source,
    String? evidenceKey,
    String? normalizedValue,
    int? weight,
    int? observationCount,
    Value<DateTime?> expiresAt = const Value.absent(),
    String? payload,
  }) => IdentityEvidenceRow(
    id: id ?? this.id,
    deviceId: deviceId ?? this.deviceId,
    source: source ?? this.source,
    evidenceKey: evidenceKey ?? this.evidenceKey,
    normalizedValue: normalizedValue ?? this.normalizedValue,
    weight: weight ?? this.weight,
    observationCount: observationCount ?? this.observationCount,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
    payload: payload ?? this.payload,
  );
  IdentityEvidenceRow copyWithCompanion(IdentityEvidenceRowsCompanion data) {
    return IdentityEvidenceRow(
      id: data.id.present ? data.id.value : this.id,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      source: data.source.present ? data.source.value : this.source,
      evidenceKey: data.evidenceKey.present
          ? data.evidenceKey.value
          : this.evidenceKey,
      normalizedValue: data.normalizedValue.present
          ? data.normalizedValue.value
          : this.normalizedValue,
      weight: data.weight.present ? data.weight.value : this.weight,
      observationCount: data.observationCount.present
          ? data.observationCount.value
          : this.observationCount,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      payload: data.payload.present ? data.payload.value : this.payload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IdentityEvidenceRow(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('source: $source, ')
          ..write('evidenceKey: $evidenceKey, ')
          ..write('normalizedValue: $normalizedValue, ')
          ..write('weight: $weight, ')
          ..write('observationCount: $observationCount, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('payload: $payload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    deviceId,
    source,
    evidenceKey,
    normalizedValue,
    weight,
    observationCount,
    expiresAt,
    payload,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IdentityEvidenceRow &&
          other.id == this.id &&
          other.deviceId == this.deviceId &&
          other.source == this.source &&
          other.evidenceKey == this.evidenceKey &&
          other.normalizedValue == this.normalizedValue &&
          other.weight == this.weight &&
          other.observationCount == this.observationCount &&
          other.expiresAt == this.expiresAt &&
          other.payload == this.payload);
}

class IdentityEvidenceRowsCompanion
    extends UpdateCompanion<IdentityEvidenceRow> {
  final Value<String> id;
  final Value<String> deviceId;
  final Value<String> source;
  final Value<String> evidenceKey;
  final Value<String> normalizedValue;
  final Value<int> weight;
  final Value<int> observationCount;
  final Value<DateTime?> expiresAt;
  final Value<String> payload;
  final Value<int> rowid;
  const IdentityEvidenceRowsCompanion({
    this.id = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.source = const Value.absent(),
    this.evidenceKey = const Value.absent(),
    this.normalizedValue = const Value.absent(),
    this.weight = const Value.absent(),
    this.observationCount = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.payload = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IdentityEvidenceRowsCompanion.insert({
    required String id,
    required String deviceId,
    required String source,
    required String evidenceKey,
    required String normalizedValue,
    required int weight,
    required int observationCount,
    this.expiresAt = const Value.absent(),
    required String payload,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       deviceId = Value(deviceId),
       source = Value(source),
       evidenceKey = Value(evidenceKey),
       normalizedValue = Value(normalizedValue),
       weight = Value(weight),
       observationCount = Value(observationCount),
       payload = Value(payload);
  static Insertable<IdentityEvidenceRow> custom({
    Expression<String>? id,
    Expression<String>? deviceId,
    Expression<String>? source,
    Expression<String>? evidenceKey,
    Expression<String>? normalizedValue,
    Expression<int>? weight,
    Expression<int>? observationCount,
    Expression<DateTime>? expiresAt,
    Expression<String>? payload,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceId != null) 'device_id': deviceId,
      if (source != null) 'source': source,
      if (evidenceKey != null) 'evidence_key': evidenceKey,
      if (normalizedValue != null) 'normalized_value': normalizedValue,
      if (weight != null) 'weight': weight,
      if (observationCount != null) 'observation_count': observationCount,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (payload != null) 'payload': payload,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IdentityEvidenceRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? deviceId,
    Value<String>? source,
    Value<String>? evidenceKey,
    Value<String>? normalizedValue,
    Value<int>? weight,
    Value<int>? observationCount,
    Value<DateTime?>? expiresAt,
    Value<String>? payload,
    Value<int>? rowid,
  }) {
    return IdentityEvidenceRowsCompanion(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      source: source ?? this.source,
      evidenceKey: evidenceKey ?? this.evidenceKey,
      normalizedValue: normalizedValue ?? this.normalizedValue,
      weight: weight ?? this.weight,
      observationCount: observationCount ?? this.observationCount,
      expiresAt: expiresAt ?? this.expiresAt,
      payload: payload ?? this.payload,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (evidenceKey.present) {
      map['evidence_key'] = Variable<String>(evidenceKey.value);
    }
    if (normalizedValue.present) {
      map['normalized_value'] = Variable<String>(normalizedValue.value);
    }
    if (weight.present) {
      map['weight'] = Variable<int>(weight.value);
    }
    if (observationCount.present) {
      map['observation_count'] = Variable<int>(observationCount.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IdentityEvidenceRowsCompanion(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('source: $source, ')
          ..write('evidenceKey: $evidenceKey, ')
          ..write('normalizedValue: $normalizedValue, ')
          ..write('weight: $weight, ')
          ..write('observationCount: $observationCount, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('payload: $payload, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeviceFingerprintsTable extends DeviceFingerprints
    with TableInfo<$DeviceFingerprintsTable, FingerprintRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeviceFingerprintsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES devices (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastEvaluatedMeta = const VerificationMeta(
    'lastEvaluated',
  );
  @override
  late final GeneratedColumn<DateTime> lastEvaluated =
      GeneratedColumn<DateTime>(
        'last_evaluated',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [deviceId, payload, lastEvaluated];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'device_fingerprints';
  @override
  VerificationContext validateIntegrity(
    Insertable<FingerprintRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('last_evaluated')) {
      context.handle(
        _lastEvaluatedMeta,
        lastEvaluated.isAcceptableOrUnknown(
          data['last_evaluated']!,
          _lastEvaluatedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {deviceId};
  @override
  FingerprintRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FingerprintRow(
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      lastEvaluated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_evaluated'],
      ),
    );
  }

  @override
  $DeviceFingerprintsTable createAlias(String alias) {
    return $DeviceFingerprintsTable(attachedDatabase, alias);
  }
}

class FingerprintRow extends DataClass implements Insertable<FingerprintRow> {
  final String deviceId;
  final String payload;
  final DateTime? lastEvaluated;
  const FingerprintRow({
    required this.deviceId,
    required this.payload,
    this.lastEvaluated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['device_id'] = Variable<String>(deviceId);
    map['payload'] = Variable<String>(payload);
    if (!nullToAbsent || lastEvaluated != null) {
      map['last_evaluated'] = Variable<DateTime>(lastEvaluated);
    }
    return map;
  }

  DeviceFingerprintsCompanion toCompanion(bool nullToAbsent) {
    return DeviceFingerprintsCompanion(
      deviceId: Value(deviceId),
      payload: Value(payload),
      lastEvaluated: lastEvaluated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastEvaluated),
    );
  }

  factory FingerprintRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FingerprintRow(
      deviceId: serializer.fromJson<String>(json['deviceId']),
      payload: serializer.fromJson<String>(json['payload']),
      lastEvaluated: serializer.fromJson<DateTime?>(json['lastEvaluated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'deviceId': serializer.toJson<String>(deviceId),
      'payload': serializer.toJson<String>(payload),
      'lastEvaluated': serializer.toJson<DateTime?>(lastEvaluated),
    };
  }

  FingerprintRow copyWith({
    String? deviceId,
    String? payload,
    Value<DateTime?> lastEvaluated = const Value.absent(),
  }) => FingerprintRow(
    deviceId: deviceId ?? this.deviceId,
    payload: payload ?? this.payload,
    lastEvaluated: lastEvaluated.present
        ? lastEvaluated.value
        : this.lastEvaluated,
  );
  FingerprintRow copyWithCompanion(DeviceFingerprintsCompanion data) {
    return FingerprintRow(
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      payload: data.payload.present ? data.payload.value : this.payload,
      lastEvaluated: data.lastEvaluated.present
          ? data.lastEvaluated.value
          : this.lastEvaluated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FingerprintRow(')
          ..write('deviceId: $deviceId, ')
          ..write('payload: $payload, ')
          ..write('lastEvaluated: $lastEvaluated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(deviceId, payload, lastEvaluated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FingerprintRow &&
          other.deviceId == this.deviceId &&
          other.payload == this.payload &&
          other.lastEvaluated == this.lastEvaluated);
}

class DeviceFingerprintsCompanion extends UpdateCompanion<FingerprintRow> {
  final Value<String> deviceId;
  final Value<String> payload;
  final Value<DateTime?> lastEvaluated;
  final Value<int> rowid;
  const DeviceFingerprintsCompanion({
    this.deviceId = const Value.absent(),
    this.payload = const Value.absent(),
    this.lastEvaluated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeviceFingerprintsCompanion.insert({
    required String deviceId,
    required String payload,
    this.lastEvaluated = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : deviceId = Value(deviceId),
       payload = Value(payload);
  static Insertable<FingerprintRow> custom({
    Expression<String>? deviceId,
    Expression<String>? payload,
    Expression<DateTime>? lastEvaluated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (deviceId != null) 'device_id': deviceId,
      if (payload != null) 'payload': payload,
      if (lastEvaluated != null) 'last_evaluated': lastEvaluated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeviceFingerprintsCompanion copyWith({
    Value<String>? deviceId,
    Value<String>? payload,
    Value<DateTime?>? lastEvaluated,
    Value<int>? rowid,
  }) {
    return DeviceFingerprintsCompanion(
      deviceId: deviceId ?? this.deviceId,
      payload: payload ?? this.payload,
      lastEvaluated: lastEvaluated ?? this.lastEvaluated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (lastEvaluated.present) {
      map['last_evaluated'] = Variable<DateTime>(lastEvaluated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeviceFingerprintsCompanion(')
          ..write('deviceId: $deviceId, ')
          ..write('payload: $payload, ')
          ..write('lastEvaluated: $lastEvaluated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeviceOverridesTable extends DeviceOverrides
    with TableInfo<$DeviceOverridesTable, OverrideRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeviceOverridesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES devices (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [deviceId, payload];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'device_overrides';
  @override
  VerificationContext validateIntegrity(
    Insertable<OverrideRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {deviceId};
  @override
  OverrideRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OverrideRow(
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
    );
  }

  @override
  $DeviceOverridesTable createAlias(String alias) {
    return $DeviceOverridesTable(attachedDatabase, alias);
  }
}

class OverrideRow extends DataClass implements Insertable<OverrideRow> {
  final String deviceId;
  final String payload;
  const OverrideRow({required this.deviceId, required this.payload});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['device_id'] = Variable<String>(deviceId);
    map['payload'] = Variable<String>(payload);
    return map;
  }

  DeviceOverridesCompanion toCompanion(bool nullToAbsent) {
    return DeviceOverridesCompanion(
      deviceId: Value(deviceId),
      payload: Value(payload),
    );
  }

  factory OverrideRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OverrideRow(
      deviceId: serializer.fromJson<String>(json['deviceId']),
      payload: serializer.fromJson<String>(json['payload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'deviceId': serializer.toJson<String>(deviceId),
      'payload': serializer.toJson<String>(payload),
    };
  }

  OverrideRow copyWith({String? deviceId, String? payload}) => OverrideRow(
    deviceId: deviceId ?? this.deviceId,
    payload: payload ?? this.payload,
  );
  OverrideRow copyWithCompanion(DeviceOverridesCompanion data) {
    return OverrideRow(
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      payload: data.payload.present ? data.payload.value : this.payload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OverrideRow(')
          ..write('deviceId: $deviceId, ')
          ..write('payload: $payload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(deviceId, payload);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OverrideRow &&
          other.deviceId == this.deviceId &&
          other.payload == this.payload);
}

class DeviceOverridesCompanion extends UpdateCompanion<OverrideRow> {
  final Value<String> deviceId;
  final Value<String> payload;
  final Value<int> rowid;
  const DeviceOverridesCompanion({
    this.deviceId = const Value.absent(),
    this.payload = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeviceOverridesCompanion.insert({
    required String deviceId,
    required String payload,
    this.rowid = const Value.absent(),
  }) : deviceId = Value(deviceId),
       payload = Value(payload);
  static Insertable<OverrideRow> custom({
    Expression<String>? deviceId,
    Expression<String>? payload,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (deviceId != null) 'device_id': deviceId,
      if (payload != null) 'payload': payload,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeviceOverridesCompanion copyWith({
    Value<String>? deviceId,
    Value<String>? payload,
    Value<int>? rowid,
  }) {
    return DeviceOverridesCompanion(
      deviceId: deviceId ?? this.deviceId,
      payload: payload ?? this.payload,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeviceOverridesCompanion(')
          ..write('deviceId: $deviceId, ')
          ..write('payload: $payload, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PotentialSameDeviceLinksTable extends PotentialSameDeviceLinks
    with TableInfo<$PotentialSameDeviceLinksTable, PotentialSameDeviceLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PotentialSameDeviceLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES devices (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _otherDeviceIdMeta = const VerificationMeta(
    'otherDeviceId',
  );
  @override
  late final GeneratedColumn<String> otherDeviceId = GeneratedColumn<String>(
    'other_device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES devices (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [deviceId, otherDeviceId, reason];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'potential_same_device_links';
  @override
  VerificationContext validateIntegrity(
    Insertable<PotentialSameDeviceLink> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('other_device_id')) {
      context.handle(
        _otherDeviceIdMeta,
        otherDeviceId.isAcceptableOrUnknown(
          data['other_device_id']!,
          _otherDeviceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_otherDeviceIdMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {deviceId, otherDeviceId};
  @override
  PotentialSameDeviceLink map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PotentialSameDeviceLink(
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      otherDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}other_device_id'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
    );
  }

  @override
  $PotentialSameDeviceLinksTable createAlias(String alias) {
    return $PotentialSameDeviceLinksTable(attachedDatabase, alias);
  }
}

class PotentialSameDeviceLink extends DataClass
    implements Insertable<PotentialSameDeviceLink> {
  final String deviceId;
  final String otherDeviceId;
  final String reason;
  const PotentialSameDeviceLink({
    required this.deviceId,
    required this.otherDeviceId,
    required this.reason,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['device_id'] = Variable<String>(deviceId);
    map['other_device_id'] = Variable<String>(otherDeviceId);
    map['reason'] = Variable<String>(reason);
    return map;
  }

  PotentialSameDeviceLinksCompanion toCompanion(bool nullToAbsent) {
    return PotentialSameDeviceLinksCompanion(
      deviceId: Value(deviceId),
      otherDeviceId: Value(otherDeviceId),
      reason: Value(reason),
    );
  }

  factory PotentialSameDeviceLink.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PotentialSameDeviceLink(
      deviceId: serializer.fromJson<String>(json['deviceId']),
      otherDeviceId: serializer.fromJson<String>(json['otherDeviceId']),
      reason: serializer.fromJson<String>(json['reason']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'deviceId': serializer.toJson<String>(deviceId),
      'otherDeviceId': serializer.toJson<String>(otherDeviceId),
      'reason': serializer.toJson<String>(reason),
    };
  }

  PotentialSameDeviceLink copyWith({
    String? deviceId,
    String? otherDeviceId,
    String? reason,
  }) => PotentialSameDeviceLink(
    deviceId: deviceId ?? this.deviceId,
    otherDeviceId: otherDeviceId ?? this.otherDeviceId,
    reason: reason ?? this.reason,
  );
  PotentialSameDeviceLink copyWithCompanion(
    PotentialSameDeviceLinksCompanion data,
  ) {
    return PotentialSameDeviceLink(
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      otherDeviceId: data.otherDeviceId.present
          ? data.otherDeviceId.value
          : this.otherDeviceId,
      reason: data.reason.present ? data.reason.value : this.reason,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PotentialSameDeviceLink(')
          ..write('deviceId: $deviceId, ')
          ..write('otherDeviceId: $otherDeviceId, ')
          ..write('reason: $reason')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(deviceId, otherDeviceId, reason);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PotentialSameDeviceLink &&
          other.deviceId == this.deviceId &&
          other.otherDeviceId == this.otherDeviceId &&
          other.reason == this.reason);
}

class PotentialSameDeviceLinksCompanion
    extends UpdateCompanion<PotentialSameDeviceLink> {
  final Value<String> deviceId;
  final Value<String> otherDeviceId;
  final Value<String> reason;
  final Value<int> rowid;
  const PotentialSameDeviceLinksCompanion({
    this.deviceId = const Value.absent(),
    this.otherDeviceId = const Value.absent(),
    this.reason = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PotentialSameDeviceLinksCompanion.insert({
    required String deviceId,
    required String otherDeviceId,
    required String reason,
    this.rowid = const Value.absent(),
  }) : deviceId = Value(deviceId),
       otherDeviceId = Value(otherDeviceId),
       reason = Value(reason);
  static Insertable<PotentialSameDeviceLink> custom({
    Expression<String>? deviceId,
    Expression<String>? otherDeviceId,
    Expression<String>? reason,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (deviceId != null) 'device_id': deviceId,
      if (otherDeviceId != null) 'other_device_id': otherDeviceId,
      if (reason != null) 'reason': reason,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PotentialSameDeviceLinksCompanion copyWith({
    Value<String>? deviceId,
    Value<String>? otherDeviceId,
    Value<String>? reason,
    Value<int>? rowid,
  }) {
    return PotentialSameDeviceLinksCompanion(
      deviceId: deviceId ?? this.deviceId,
      otherDeviceId: otherDeviceId ?? this.otherDeviceId,
      reason: reason ?? this.reason,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (otherDeviceId.present) {
      map['other_device_id'] = Variable<String>(otherDeviceId.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PotentialSameDeviceLinksCompanion(')
          ..write('deviceId: $deviceId, ')
          ..write('otherDeviceId: $otherDeviceId, ')
          ..write('reason: $reason, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GuardianConversationsTable extends GuardianConversations
    with TableInfo<$GuardianConversationsTable, GuardianConversationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GuardianConversationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _networkIdMeta = const VerificationMeta(
    'networkId',
  );
  @override
  late final GeneratedColumn<String> networkId = GeneratedColumn<String>(
    'network_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Network conversation'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    networkId,
    title,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'guardian_conversations';
  @override
  VerificationContext validateIntegrity(
    Insertable<GuardianConversationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('network_id')) {
      context.handle(
        _networkIdMeta,
        networkId.isAcceptableOrUnknown(data['network_id']!, _networkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_networkIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GuardianConversationRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GuardianConversationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      networkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}network_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $GuardianConversationsTable createAlias(String alias) {
    return $GuardianConversationsTable(attachedDatabase, alias);
  }
}

class GuardianConversationRow extends DataClass
    implements Insertable<GuardianConversationRow> {
  final String id;
  final String networkId;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  const GuardianConversationRow({
    required this.id,
    required this.networkId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['network_id'] = Variable<String>(networkId);
    map['title'] = Variable<String>(title);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GuardianConversationsCompanion toCompanion(bool nullToAbsent) {
    return GuardianConversationsCompanion(
      id: Value(id),
      networkId: Value(networkId),
      title: Value(title),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory GuardianConversationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GuardianConversationRow(
      id: serializer.fromJson<String>(json['id']),
      networkId: serializer.fromJson<String>(json['networkId']),
      title: serializer.fromJson<String>(json['title']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'networkId': serializer.toJson<String>(networkId),
      'title': serializer.toJson<String>(title),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GuardianConversationRow copyWith({
    String? id,
    String? networkId,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => GuardianConversationRow(
    id: id ?? this.id,
    networkId: networkId ?? this.networkId,
    title: title ?? this.title,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  GuardianConversationRow copyWithCompanion(
    GuardianConversationsCompanion data,
  ) {
    return GuardianConversationRow(
      id: data.id.present ? data.id.value : this.id,
      networkId: data.networkId.present ? data.networkId.value : this.networkId,
      title: data.title.present ? data.title.value : this.title,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GuardianConversationRow(')
          ..write('id: $id, ')
          ..write('networkId: $networkId, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, networkId, title, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GuardianConversationRow &&
          other.id == this.id &&
          other.networkId == this.networkId &&
          other.title == this.title &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GuardianConversationsCompanion
    extends UpdateCompanion<GuardianConversationRow> {
  final Value<String> id;
  final Value<String> networkId;
  final Value<String> title;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const GuardianConversationsCompanion({
    this.id = const Value.absent(),
    this.networkId = const Value.absent(),
    this.title = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GuardianConversationsCompanion.insert({
    required String id,
    required String networkId,
    this.title = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       networkId = Value(networkId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<GuardianConversationRow> custom({
    Expression<String>? id,
    Expression<String>? networkId,
    Expression<String>? title,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (networkId != null) 'network_id': networkId,
      if (title != null) 'title': title,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GuardianConversationsCompanion copyWith({
    Value<String>? id,
    Value<String>? networkId,
    Value<String>? title,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return GuardianConversationsCompanion(
      id: id ?? this.id,
      networkId: networkId ?? this.networkId,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (networkId.present) {
      map['network_id'] = Variable<String>(networkId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GuardianConversationsCompanion(')
          ..write('id: $id, ')
          ..write('networkId: $networkId, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GuardianMessagesTable extends GuardianMessages
    with TableInfo<$GuardianMessagesTable, GuardianMessageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GuardianMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES guardian_conversations (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textBodyMeta = const VerificationMeta(
    'textBody',
  );
  @override
  late final GeneratedColumn<String> textBody = GeneratedColumn<String>(
    'text_body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    conversationId,
    role,
    textBody,
    payload,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'guardian_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<GuardianMessageRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('text_body')) {
      context.handle(
        _textBodyMeta,
        textBody.isAcceptableOrUnknown(data['text_body']!, _textBodyMeta),
      );
    } else if (isInserting) {
      context.missing(_textBodyMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GuardianMessageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GuardianMessageRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      textBody: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_body'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $GuardianMessagesTable createAlias(String alias) {
    return $GuardianMessagesTable(attachedDatabase, alias);
  }
}

class GuardianMessageRow extends DataClass
    implements Insertable<GuardianMessageRow> {
  final String id;
  final String conversationId;
  final String role;
  final String textBody;
  final String payload;
  final DateTime createdAt;
  const GuardianMessageRow({
    required this.id,
    required this.conversationId,
    required this.role,
    required this.textBody,
    required this.payload,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['conversation_id'] = Variable<String>(conversationId);
    map['role'] = Variable<String>(role);
    map['text_body'] = Variable<String>(textBody);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GuardianMessagesCompanion toCompanion(bool nullToAbsent) {
    return GuardianMessagesCompanion(
      id: Value(id),
      conversationId: Value(conversationId),
      role: Value(role),
      textBody: Value(textBody),
      payload: Value(payload),
      createdAt: Value(createdAt),
    );
  }

  factory GuardianMessageRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GuardianMessageRow(
      id: serializer.fromJson<String>(json['id']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      role: serializer.fromJson<String>(json['role']),
      textBody: serializer.fromJson<String>(json['textBody']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'conversationId': serializer.toJson<String>(conversationId),
      'role': serializer.toJson<String>(role),
      'textBody': serializer.toJson<String>(textBody),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  GuardianMessageRow copyWith({
    String? id,
    String? conversationId,
    String? role,
    String? textBody,
    String? payload,
    DateTime? createdAt,
  }) => GuardianMessageRow(
    id: id ?? this.id,
    conversationId: conversationId ?? this.conversationId,
    role: role ?? this.role,
    textBody: textBody ?? this.textBody,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
  );
  GuardianMessageRow copyWithCompanion(GuardianMessagesCompanion data) {
    return GuardianMessageRow(
      id: data.id.present ? data.id.value : this.id,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      role: data.role.present ? data.role.value : this.role,
      textBody: data.textBody.present ? data.textBody.value : this.textBody,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GuardianMessageRow(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('role: $role, ')
          ..write('textBody: $textBody, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, conversationId, role, textBody, payload, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GuardianMessageRow &&
          other.id == this.id &&
          other.conversationId == this.conversationId &&
          other.role == this.role &&
          other.textBody == this.textBody &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt);
}

class GuardianMessagesCompanion extends UpdateCompanion<GuardianMessageRow> {
  final Value<String> id;
  final Value<String> conversationId;
  final Value<String> role;
  final Value<String> textBody;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const GuardianMessagesCompanion({
    this.id = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.role = const Value.absent(),
    this.textBody = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GuardianMessagesCompanion.insert({
    required String id,
    required String conversationId,
    required String role,
    required String textBody,
    required String payload,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       conversationId = Value(conversationId),
       role = Value(role),
       textBody = Value(textBody),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<GuardianMessageRow> custom({
    Expression<String>? id,
    Expression<String>? conversationId,
    Expression<String>? role,
    Expression<String>? textBody,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (conversationId != null) 'conversation_id': conversationId,
      if (role != null) 'role': role,
      if (textBody != null) 'text_body': textBody,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GuardianMessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? conversationId,
    Value<String>? role,
    Value<String>? textBody,
    Value<String>? payload,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return GuardianMessagesCompanion(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      role: role ?? this.role,
      textBody: textBody ?? this.textBody,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (textBody.present) {
      map['text_body'] = Variable<String>(textBody.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GuardianMessagesCompanion(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('role: $role, ')
          ..write('textBody: $textBody, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DiagnosticRunsTable extends DiagnosticRuns
    with TableInfo<$DiagnosticRunsTable, DiagnosticRunRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiagnosticRunsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _networkIdMeta = const VerificationMeta(
    'networkId',
  );
  @override
  late final GeneratedColumn<String> networkId = GeneratedColumn<String>(
    'network_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    networkId,
    status,
    payload,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diagnostic_runs';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiagnosticRunRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('network_id')) {
      context.handle(
        _networkIdMeta,
        networkId.isAcceptableOrUnknown(data['network_id']!, _networkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_networkIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiagnosticRunRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiagnosticRunRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      networkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}network_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DiagnosticRunsTable createAlias(String alias) {
    return $DiagnosticRunsTable(attachedDatabase, alias);
  }
}

class DiagnosticRunRow extends DataClass
    implements Insertable<DiagnosticRunRow> {
  final String id;
  final String networkId;
  final String status;
  final String payload;
  final DateTime createdAt;
  const DiagnosticRunRow({
    required this.id,
    required this.networkId,
    required this.status,
    required this.payload,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['network_id'] = Variable<String>(networkId);
    map['status'] = Variable<String>(status);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DiagnosticRunsCompanion toCompanion(bool nullToAbsent) {
    return DiagnosticRunsCompanion(
      id: Value(id),
      networkId: Value(networkId),
      status: Value(status),
      payload: Value(payload),
      createdAt: Value(createdAt),
    );
  }

  factory DiagnosticRunRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiagnosticRunRow(
      id: serializer.fromJson<String>(json['id']),
      networkId: serializer.fromJson<String>(json['networkId']),
      status: serializer.fromJson<String>(json['status']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'networkId': serializer.toJson<String>(networkId),
      'status': serializer.toJson<String>(status),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DiagnosticRunRow copyWith({
    String? id,
    String? networkId,
    String? status,
    String? payload,
    DateTime? createdAt,
  }) => DiagnosticRunRow(
    id: id ?? this.id,
    networkId: networkId ?? this.networkId,
    status: status ?? this.status,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
  );
  DiagnosticRunRow copyWithCompanion(DiagnosticRunsCompanion data) {
    return DiagnosticRunRow(
      id: data.id.present ? data.id.value : this.id,
      networkId: data.networkId.present ? data.networkId.value : this.networkId,
      status: data.status.present ? data.status.value : this.status,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiagnosticRunRow(')
          ..write('id: $id, ')
          ..write('networkId: $networkId, ')
          ..write('status: $status, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, networkId, status, payload, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiagnosticRunRow &&
          other.id == this.id &&
          other.networkId == this.networkId &&
          other.status == this.status &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt);
}

class DiagnosticRunsCompanion extends UpdateCompanion<DiagnosticRunRow> {
  final Value<String> id;
  final Value<String> networkId;
  final Value<String> status;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const DiagnosticRunsCompanion({
    this.id = const Value.absent(),
    this.networkId = const Value.absent(),
    this.status = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DiagnosticRunsCompanion.insert({
    required String id,
    required String networkId,
    required String status,
    required String payload,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       networkId = Value(networkId),
       status = Value(status),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<DiagnosticRunRow> custom({
    Expression<String>? id,
    Expression<String>? networkId,
    Expression<String>? status,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (networkId != null) 'network_id': networkId,
      if (status != null) 'status': status,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DiagnosticRunsCompanion copyWith({
    Value<String>? id,
    Value<String>? networkId,
    Value<String>? status,
    Value<String>? payload,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return DiagnosticRunsCompanion(
      id: id ?? this.id,
      networkId: networkId ?? this.networkId,
      status: status ?? this.status,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (networkId.present) {
      map['network_id'] = Variable<String>(networkId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiagnosticRunsCompanion(')
          ..write('id: $id, ')
          ..write('networkId: $networkId, ')
          ..write('status: $status, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NetworksTable networks = $NetworksTable(this);
  late final $DevicesTable devices = $DevicesTable(this);
  late final $DeviceServicesTable deviceServices = $DeviceServicesTable(this);
  late final $ScanSessionsTable scanSessions = $ScanSessionsTable(this);
  late final $DeviceIdentifiersTable deviceIdentifiers =
      $DeviceIdentifiersTable(this);
  late final $IdentityEvidenceRowsTable identityEvidenceRows =
      $IdentityEvidenceRowsTable(this);
  late final $DeviceFingerprintsTable deviceFingerprints =
      $DeviceFingerprintsTable(this);
  late final $DeviceOverridesTable deviceOverrides = $DeviceOverridesTable(
    this,
  );
  late final $PotentialSameDeviceLinksTable potentialSameDeviceLinks =
      $PotentialSameDeviceLinksTable(this);
  late final $GuardianConversationsTable guardianConversations =
      $GuardianConversationsTable(this);
  late final $GuardianMessagesTable guardianMessages = $GuardianMessagesTable(
    this,
  );
  late final $DiagnosticRunsTable diagnosticRuns = $DiagnosticRunsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    networks,
    devices,
    deviceServices,
    scanSessions,
    deviceIdentifiers,
    identityEvidenceRows,
    deviceFingerprints,
    deviceOverrides,
    potentialSameDeviceLinks,
    guardianConversations,
    guardianMessages,
    diagnosticRuns,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'devices',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('device_services', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'devices',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('device_identifiers', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'devices',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('identity_evidence_rows', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'devices',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('device_fingerprints', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'devices',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('device_overrides', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'devices',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('potential_same_device_links', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'devices',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('potential_same_device_links', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'guardian_conversations',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('guardian_messages', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$NetworksTableCreateCompanionBuilder =
    NetworksCompanion Function({
      required String id,
      required String fingerprint,
      Value<String?> ssid,
      Value<String?> gatewayIp,
      required String cidr,
      required DateTime firstSeen,
      required DateTime lastSeen,
      Value<int> rowid,
    });
typedef $$NetworksTableUpdateCompanionBuilder =
    NetworksCompanion Function({
      Value<String> id,
      Value<String> fingerprint,
      Value<String?> ssid,
      Value<String?> gatewayIp,
      Value<String> cidr,
      Value<DateTime> firstSeen,
      Value<DateTime> lastSeen,
      Value<int> rowid,
    });

final class $$NetworksTableReferences
    extends BaseReferences<_$AppDatabase, $NetworksTable, Network> {
  $$NetworksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DevicesTable, List<DeviceRow>> _devicesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.devices,
    aliasName: 'networks__id__devices__network_id',
  );

  $$DevicesTableProcessedTableManager get devicesRefs {
    final manager = $$DevicesTableTableManager(
      $_db,
      $_db.devices,
    ).filter((f) => f.networkId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_devicesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ScanSessionsTable, List<ScanSession>>
  _scanSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.scanSessions,
    aliasName: 'networks__id__scan_sessions__network_id',
  );

  $$ScanSessionsTableProcessedTableManager get scanSessionsRefs {
    final manager = $$ScanSessionsTableTableManager(
      $_db,
      $_db.scanSessions,
    ).filter((f) => f.networkId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_scanSessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$NetworksTableFilterComposer
    extends Composer<_$AppDatabase, $NetworksTable> {
  $$NetworksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ssid => $composableBuilder(
    column: $table.ssid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gatewayIp => $composableBuilder(
    column: $table.gatewayIp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cidr => $composableBuilder(
    column: $table.cidr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get firstSeen => $composableBuilder(
    column: $table.firstSeen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSeen => $composableBuilder(
    column: $table.lastSeen,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> devicesRefs(
    Expression<bool> Function($$DevicesTableFilterComposer f) f,
  ) {
    final $$DevicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.networkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableFilterComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> scanSessionsRefs(
    Expression<bool> Function($$ScanSessionsTableFilterComposer f) f,
  ) {
    final $$ScanSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scanSessions,
      getReferencedColumn: (t) => t.networkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScanSessionsTableFilterComposer(
            $db: $db,
            $table: $db.scanSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NetworksTableOrderingComposer
    extends Composer<_$AppDatabase, $NetworksTable> {
  $$NetworksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ssid => $composableBuilder(
    column: $table.ssid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gatewayIp => $composableBuilder(
    column: $table.gatewayIp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cidr => $composableBuilder(
    column: $table.cidr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get firstSeen => $composableBuilder(
    column: $table.firstSeen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSeen => $composableBuilder(
    column: $table.lastSeen,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NetworksTableAnnotationComposer
    extends Composer<_$AppDatabase, $NetworksTable> {
  $$NetworksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ssid =>
      $composableBuilder(column: $table.ssid, builder: (column) => column);

  GeneratedColumn<String> get gatewayIp =>
      $composableBuilder(column: $table.gatewayIp, builder: (column) => column);

  GeneratedColumn<String> get cidr =>
      $composableBuilder(column: $table.cidr, builder: (column) => column);

  GeneratedColumn<DateTime> get firstSeen =>
      $composableBuilder(column: $table.firstSeen, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSeen =>
      $composableBuilder(column: $table.lastSeen, builder: (column) => column);

  Expression<T> devicesRefs<T extends Object>(
    Expression<T> Function($$DevicesTableAnnotationComposer a) f,
  ) {
    final $$DevicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.networkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableAnnotationComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> scanSessionsRefs<T extends Object>(
    Expression<T> Function($$ScanSessionsTableAnnotationComposer a) f,
  ) {
    final $$ScanSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scanSessions,
      getReferencedColumn: (t) => t.networkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScanSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.scanSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NetworksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NetworksTable,
          Network,
          $$NetworksTableFilterComposer,
          $$NetworksTableOrderingComposer,
          $$NetworksTableAnnotationComposer,
          $$NetworksTableCreateCompanionBuilder,
          $$NetworksTableUpdateCompanionBuilder,
          (Network, $$NetworksTableReferences),
          Network,
          PrefetchHooks Function({bool devicesRefs, bool scanSessionsRefs})
        > {
  $$NetworksTableTableManager(_$AppDatabase db, $NetworksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NetworksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NetworksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NetworksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> fingerprint = const Value.absent(),
                Value<String?> ssid = const Value.absent(),
                Value<String?> gatewayIp = const Value.absent(),
                Value<String> cidr = const Value.absent(),
                Value<DateTime> firstSeen = const Value.absent(),
                Value<DateTime> lastSeen = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NetworksCompanion(
                id: id,
                fingerprint: fingerprint,
                ssid: ssid,
                gatewayIp: gatewayIp,
                cidr: cidr,
                firstSeen: firstSeen,
                lastSeen: lastSeen,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String fingerprint,
                Value<String?> ssid = const Value.absent(),
                Value<String?> gatewayIp = const Value.absent(),
                required String cidr,
                required DateTime firstSeen,
                required DateTime lastSeen,
                Value<int> rowid = const Value.absent(),
              }) => NetworksCompanion.insert(
                id: id,
                fingerprint: fingerprint,
                ssid: ssid,
                gatewayIp: gatewayIp,
                cidr: cidr,
                firstSeen: firstSeen,
                lastSeen: lastSeen,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NetworksTable, Network>(table),
                  $$NetworksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({devicesRefs = false, scanSessionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (devicesRefs) db.devices,
                    if (scanSessionsRefs) db.scanSessions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (devicesRefs)
                        await $_getPrefetchedData<
                          Network,
                          $NetworksTable,
                          DeviceRow
                        >(
                          currentTable: table,
                          referencedTable: $$NetworksTableReferences
                              ._devicesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$NetworksTableReferences(
                                db,
                                table,
                                p0,
                              ).devicesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.networkId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (scanSessionsRefs)
                        await $_getPrefetchedData<
                          Network,
                          $NetworksTable,
                          ScanSession
                        >(
                          currentTable: table,
                          referencedTable: $$NetworksTableReferences
                              ._scanSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$NetworksTableReferences(
                                db,
                                table,
                                p0,
                              ).scanSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.networkId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$NetworksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NetworksTable,
      Network,
      $$NetworksTableFilterComposer,
      $$NetworksTableOrderingComposer,
      $$NetworksTableAnnotationComposer,
      $$NetworksTableCreateCompanionBuilder,
      $$NetworksTableUpdateCompanionBuilder,
      (Network, $$NetworksTableReferences),
      Network,
      PrefetchHooks Function({bool devicesRefs, bool scanSessionsRefs})
    >;
typedef $$DevicesTableCreateCompanionBuilder =
    DevicesCompanion Function({
      required String id,
      required String networkId,
      required String ipAddress,
      Value<String?> macAddress,
      required String payload,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$DevicesTableUpdateCompanionBuilder =
    DevicesCompanion Function({
      Value<String> id,
      Value<String> networkId,
      Value<String> ipAddress,
      Value<String?> macAddress,
      Value<String> payload,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$DevicesTableReferences
    extends BaseReferences<_$AppDatabase, $DevicesTable, DeviceRow> {
  $$DevicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NetworksTable _networkIdTable(_$AppDatabase db) =>
      db.networks.createAlias('devices__network_id__networks__id');

  $$NetworksTableProcessedTableManager get networkId {
    final $_column = $_itemColumn<String>('network_id')!;

    final manager = $$NetworksTableTableManager(
      $_db,
      $_db.networks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_networkIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$DeviceServicesTable, List<DeviceService>>
  _deviceServicesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.deviceServices,
    aliasName: 'devices__id__device_services__device_id',
  );

  $$DeviceServicesTableProcessedTableManager get deviceServicesRefs {
    final manager = $$DeviceServicesTableTableManager(
      $_db,
      $_db.deviceServices,
    ).filter((f) => f.deviceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_deviceServicesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DeviceIdentifiersTable, List<DeviceIdentifier>>
  _deviceIdentifiersRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.deviceIdentifiers,
        aliasName: 'devices__id__device_identifiers__device_id',
      );

  $$DeviceIdentifiersTableProcessedTableManager get deviceIdentifiersRefs {
    final manager = $$DeviceIdentifiersTableTableManager(
      $_db,
      $_db.deviceIdentifiers,
    ).filter((f) => f.deviceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _deviceIdentifiersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $IdentityEvidenceRowsTable,
    List<IdentityEvidenceRow>
  >
  _identityEvidenceRowsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.identityEvidenceRows,
        aliasName: 'devices__id__identity_evidence_rows__device_id',
      );

  $$IdentityEvidenceRowsTableProcessedTableManager
  get identityEvidenceRowsRefs {
    final manager = $$IdentityEvidenceRowsTableTableManager(
      $_db,
      $_db.identityEvidenceRows,
    ).filter((f) => f.deviceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _identityEvidenceRowsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DeviceFingerprintsTable, List<FingerprintRow>>
  _deviceFingerprintsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.deviceFingerprints,
        aliasName: 'devices__id__device_fingerprints__device_id',
      );

  $$DeviceFingerprintsTableProcessedTableManager get deviceFingerprintsRefs {
    final manager = $$DeviceFingerprintsTableTableManager(
      $_db,
      $_db.deviceFingerprints,
    ).filter((f) => f.deviceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _deviceFingerprintsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DeviceOverridesTable, List<OverrideRow>>
  _deviceOverridesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.deviceOverrides,
    aliasName: 'devices__id__device_overrides__device_id',
  );

  $$DeviceOverridesTableProcessedTableManager get deviceOverridesRefs {
    final manager = $$DeviceOverridesTableTableManager(
      $_db,
      $_db.deviceOverrides,
    ).filter((f) => f.deviceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _deviceOverridesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $PotentialSameDeviceLinksTable,
    List<PotentialSameDeviceLink>
  >
  _possibleMatchesTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.potentialSameDeviceLinks,
    aliasName: 'devices__id__potential_same_device_links__device_id',
  );

  $$PotentialSameDeviceLinksTableProcessedTableManager get possibleMatches {
    final manager = $$PotentialSameDeviceLinksTableTableManager(
      $_db,
      $_db.potentialSameDeviceLinks,
    ).filter((f) => f.deviceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_possibleMatchesTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $PotentialSameDeviceLinksTable,
    List<PotentialSameDeviceLink>
  >
  _matchedByTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.potentialSameDeviceLinks,
    aliasName: 'devices__id__potential_same_device_links__other_device_id',
  );

  $$PotentialSameDeviceLinksTableProcessedTableManager get matchedBy {
    final manager = $$PotentialSameDeviceLinksTableTableManager(
      $_db,
      $_db.potentialSameDeviceLinks,
    ).filter((f) => f.otherDeviceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_matchedByTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DevicesTableFilterComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ipAddress => $composableBuilder(
    column: $table.ipAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get macAddress => $composableBuilder(
    column: $table.macAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$NetworksTableFilterComposer get networkId {
    final $$NetworksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.networkId,
      referencedTable: $db.networks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NetworksTableFilterComposer(
            $db: $db,
            $table: $db.networks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> deviceServicesRefs(
    Expression<bool> Function($$DeviceServicesTableFilterComposer f) f,
  ) {
    final $$DeviceServicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deviceServices,
      getReferencedColumn: (t) => t.deviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeviceServicesTableFilterComposer(
            $db: $db,
            $table: $db.deviceServices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> deviceIdentifiersRefs(
    Expression<bool> Function($$DeviceIdentifiersTableFilterComposer f) f,
  ) {
    final $$DeviceIdentifiersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deviceIdentifiers,
      getReferencedColumn: (t) => t.deviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeviceIdentifiersTableFilterComposer(
            $db: $db,
            $table: $db.deviceIdentifiers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> identityEvidenceRowsRefs(
    Expression<bool> Function($$IdentityEvidenceRowsTableFilterComposer f) f,
  ) {
    final $$IdentityEvidenceRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.identityEvidenceRows,
      getReferencedColumn: (t) => t.deviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IdentityEvidenceRowsTableFilterComposer(
            $db: $db,
            $table: $db.identityEvidenceRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> deviceFingerprintsRefs(
    Expression<bool> Function($$DeviceFingerprintsTableFilterComposer f) f,
  ) {
    final $$DeviceFingerprintsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deviceFingerprints,
      getReferencedColumn: (t) => t.deviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeviceFingerprintsTableFilterComposer(
            $db: $db,
            $table: $db.deviceFingerprints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> deviceOverridesRefs(
    Expression<bool> Function($$DeviceOverridesTableFilterComposer f) f,
  ) {
    final $$DeviceOverridesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deviceOverrides,
      getReferencedColumn: (t) => t.deviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeviceOverridesTableFilterComposer(
            $db: $db,
            $table: $db.deviceOverrides,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> possibleMatches(
    Expression<bool> Function($$PotentialSameDeviceLinksTableFilterComposer f)
    f,
  ) {
    final $$PotentialSameDeviceLinksTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.potentialSameDeviceLinks,
          getReferencedColumn: (t) => t.deviceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PotentialSameDeviceLinksTableFilterComposer(
                $db: $db,
                $table: $db.potentialSameDeviceLinks,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> matchedBy(
    Expression<bool> Function($$PotentialSameDeviceLinksTableFilterComposer f)
    f,
  ) {
    final $$PotentialSameDeviceLinksTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.potentialSameDeviceLinks,
          getReferencedColumn: (t) => t.otherDeviceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PotentialSameDeviceLinksTableFilterComposer(
                $db: $db,
                $table: $db.potentialSameDeviceLinks,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$DevicesTableOrderingComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ipAddress => $composableBuilder(
    column: $table.ipAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get macAddress => $composableBuilder(
    column: $table.macAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$NetworksTableOrderingComposer get networkId {
    final $$NetworksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.networkId,
      referencedTable: $db.networks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NetworksTableOrderingComposer(
            $db: $db,
            $table: $db.networks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DevicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ipAddress =>
      $composableBuilder(column: $table.ipAddress, builder: (column) => column);

  GeneratedColumn<String> get macAddress => $composableBuilder(
    column: $table.macAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$NetworksTableAnnotationComposer get networkId {
    final $$NetworksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.networkId,
      referencedTable: $db.networks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NetworksTableAnnotationComposer(
            $db: $db,
            $table: $db.networks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> deviceServicesRefs<T extends Object>(
    Expression<T> Function($$DeviceServicesTableAnnotationComposer a) f,
  ) {
    final $$DeviceServicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deviceServices,
      getReferencedColumn: (t) => t.deviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeviceServicesTableAnnotationComposer(
            $db: $db,
            $table: $db.deviceServices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> deviceIdentifiersRefs<T extends Object>(
    Expression<T> Function($$DeviceIdentifiersTableAnnotationComposer a) f,
  ) {
    final $$DeviceIdentifiersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.deviceIdentifiers,
          getReferencedColumn: (t) => t.deviceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DeviceIdentifiersTableAnnotationComposer(
                $db: $db,
                $table: $db.deviceIdentifiers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> identityEvidenceRowsRefs<T extends Object>(
    Expression<T> Function($$IdentityEvidenceRowsTableAnnotationComposer a) f,
  ) {
    final $$IdentityEvidenceRowsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.identityEvidenceRows,
          getReferencedColumn: (t) => t.deviceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IdentityEvidenceRowsTableAnnotationComposer(
                $db: $db,
                $table: $db.identityEvidenceRows,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> deviceFingerprintsRefs<T extends Object>(
    Expression<T> Function($$DeviceFingerprintsTableAnnotationComposer a) f,
  ) {
    final $$DeviceFingerprintsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.deviceFingerprints,
          getReferencedColumn: (t) => t.deviceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DeviceFingerprintsTableAnnotationComposer(
                $db: $db,
                $table: $db.deviceFingerprints,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> deviceOverridesRefs<T extends Object>(
    Expression<T> Function($$DeviceOverridesTableAnnotationComposer a) f,
  ) {
    final $$DeviceOverridesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deviceOverrides,
      getReferencedColumn: (t) => t.deviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeviceOverridesTableAnnotationComposer(
            $db: $db,
            $table: $db.deviceOverrides,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> possibleMatches<T extends Object>(
    Expression<T> Function($$PotentialSameDeviceLinksTableAnnotationComposer a)
    f,
  ) {
    final $$PotentialSameDeviceLinksTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.potentialSameDeviceLinks,
          getReferencedColumn: (t) => t.deviceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PotentialSameDeviceLinksTableAnnotationComposer(
                $db: $db,
                $table: $db.potentialSameDeviceLinks,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> matchedBy<T extends Object>(
    Expression<T> Function($$PotentialSameDeviceLinksTableAnnotationComposer a)
    f,
  ) {
    final $$PotentialSameDeviceLinksTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.potentialSameDeviceLinks,
          getReferencedColumn: (t) => t.otherDeviceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PotentialSameDeviceLinksTableAnnotationComposer(
                $db: $db,
                $table: $db.potentialSameDeviceLinks,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$DevicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DevicesTable,
          DeviceRow,
          $$DevicesTableFilterComposer,
          $$DevicesTableOrderingComposer,
          $$DevicesTableAnnotationComposer,
          $$DevicesTableCreateCompanionBuilder,
          $$DevicesTableUpdateCompanionBuilder,
          (DeviceRow, $$DevicesTableReferences),
          DeviceRow,
          PrefetchHooks Function({
            bool networkId,
            bool deviceServicesRefs,
            bool deviceIdentifiersRefs,
            bool identityEvidenceRowsRefs,
            bool deviceFingerprintsRefs,
            bool deviceOverridesRefs,
            bool possibleMatches,
            bool matchedBy,
          })
        > {
  $$DevicesTableTableManager(_$AppDatabase db, $DevicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DevicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DevicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DevicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> networkId = const Value.absent(),
                Value<String> ipAddress = const Value.absent(),
                Value<String?> macAddress = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DevicesCompanion(
                id: id,
                networkId: networkId,
                ipAddress: ipAddress,
                macAddress: macAddress,
                payload: payload,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String networkId,
                required String ipAddress,
                Value<String?> macAddress = const Value.absent(),
                required String payload,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => DevicesCompanion.insert(
                id: id,
                networkId: networkId,
                ipAddress: ipAddress,
                macAddress: macAddress,
                payload: payload,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DevicesTable, DeviceRow>(table),
                  $$DevicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                networkId = false,
                deviceServicesRefs = false,
                deviceIdentifiersRefs = false,
                identityEvidenceRowsRefs = false,
                deviceFingerprintsRefs = false,
                deviceOverridesRefs = false,
                possibleMatches = false,
                matchedBy = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (deviceServicesRefs) db.deviceServices,
                    if (deviceIdentifiersRefs) db.deviceIdentifiers,
                    if (identityEvidenceRowsRefs) db.identityEvidenceRows,
                    if (deviceFingerprintsRefs) db.deviceFingerprints,
                    if (deviceOverridesRefs) db.deviceOverrides,
                    if (possibleMatches) db.potentialSameDeviceLinks,
                    if (matchedBy) db.potentialSameDeviceLinks,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (networkId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.networkId,
                                    referencedTable: $$DevicesTableReferences
                                        ._networkIdTable(db),
                                    referencedColumn: $$DevicesTableReferences
                                        ._networkIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (deviceServicesRefs)
                        await $_getPrefetchedData<
                          DeviceRow,
                          $DevicesTable,
                          DeviceService
                        >(
                          currentTable: table,
                          referencedTable: $$DevicesTableReferences
                              ._deviceServicesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DevicesTableReferences(
                                db,
                                table,
                                p0,
                              ).deviceServicesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.deviceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (deviceIdentifiersRefs)
                        await $_getPrefetchedData<
                          DeviceRow,
                          $DevicesTable,
                          DeviceIdentifier
                        >(
                          currentTable: table,
                          referencedTable: $$DevicesTableReferences
                              ._deviceIdentifiersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DevicesTableReferences(
                                db,
                                table,
                                p0,
                              ).deviceIdentifiersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.deviceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (identityEvidenceRowsRefs)
                        await $_getPrefetchedData<
                          DeviceRow,
                          $DevicesTable,
                          IdentityEvidenceRow
                        >(
                          currentTable: table,
                          referencedTable: $$DevicesTableReferences
                              ._identityEvidenceRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DevicesTableReferences(
                                db,
                                table,
                                p0,
                              ).identityEvidenceRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.deviceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (deviceFingerprintsRefs)
                        await $_getPrefetchedData<
                          DeviceRow,
                          $DevicesTable,
                          FingerprintRow
                        >(
                          currentTable: table,
                          referencedTable: $$DevicesTableReferences
                              ._deviceFingerprintsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DevicesTableReferences(
                                db,
                                table,
                                p0,
                              ).deviceFingerprintsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.deviceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (deviceOverridesRefs)
                        await $_getPrefetchedData<
                          DeviceRow,
                          $DevicesTable,
                          OverrideRow
                        >(
                          currentTable: table,
                          referencedTable: $$DevicesTableReferences
                              ._deviceOverridesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DevicesTableReferences(
                                db,
                                table,
                                p0,
                              ).deviceOverridesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.deviceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (possibleMatches)
                        await $_getPrefetchedData<
                          DeviceRow,
                          $DevicesTable,
                          PotentialSameDeviceLink
                        >(
                          currentTable: table,
                          referencedTable: $$DevicesTableReferences
                              ._possibleMatchesTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DevicesTableReferences(
                                db,
                                table,
                                p0,
                              ).possibleMatches,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.deviceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (matchedBy)
                        await $_getPrefetchedData<
                          DeviceRow,
                          $DevicesTable,
                          PotentialSameDeviceLink
                        >(
                          currentTable: table,
                          referencedTable: $$DevicesTableReferences
                              ._matchedByTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DevicesTableReferences(db, table, p0).matchedBy,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.otherDeviceId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DevicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DevicesTable,
      DeviceRow,
      $$DevicesTableFilterComposer,
      $$DevicesTableOrderingComposer,
      $$DevicesTableAnnotationComposer,
      $$DevicesTableCreateCompanionBuilder,
      $$DevicesTableUpdateCompanionBuilder,
      (DeviceRow, $$DevicesTableReferences),
      DeviceRow,
      PrefetchHooks Function({
        bool networkId,
        bool deviceServicesRefs,
        bool deviceIdentifiersRefs,
        bool identityEvidenceRowsRefs,
        bool deviceFingerprintsRefs,
        bool deviceOverridesRefs,
        bool possibleMatches,
        bool matchedBy,
      })
    >;
typedef $$DeviceServicesTableCreateCompanionBuilder =
    DeviceServicesCompanion Function({
      required String deviceId,
      required String serviceKey,
      required String payload,
      Value<int> rowid,
    });
typedef $$DeviceServicesTableUpdateCompanionBuilder =
    DeviceServicesCompanion Function({
      Value<String> deviceId,
      Value<String> serviceKey,
      Value<String> payload,
      Value<int> rowid,
    });

final class $$DeviceServicesTableReferences
    extends BaseReferences<_$AppDatabase, $DeviceServicesTable, DeviceService> {
  $$DeviceServicesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DevicesTable _deviceIdTable(_$AppDatabase db) =>
      db.devices.createAlias('device_services__device_id__devices__id');

  $$DevicesTableProcessedTableManager get deviceId {
    final $_column = $_itemColumn<String>('device_id')!;

    final manager = $$DevicesTableTableManager(
      $_db,
      $_db.devices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_deviceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DeviceServicesTableFilterComposer
    extends Composer<_$AppDatabase, $DeviceServicesTable> {
  $$DeviceServicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get serviceKey => $composableBuilder(
    column: $table.serviceKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  $$DevicesTableFilterComposer get deviceId {
    final $$DevicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableFilterComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeviceServicesTableOrderingComposer
    extends Composer<_$AppDatabase, $DeviceServicesTable> {
  $$DeviceServicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get serviceKey => $composableBuilder(
    column: $table.serviceKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  $$DevicesTableOrderingComposer get deviceId {
    final $$DevicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableOrderingComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeviceServicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeviceServicesTable> {
  $$DeviceServicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get serviceKey => $composableBuilder(
    column: $table.serviceKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  $$DevicesTableAnnotationComposer get deviceId {
    final $$DevicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableAnnotationComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeviceServicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeviceServicesTable,
          DeviceService,
          $$DeviceServicesTableFilterComposer,
          $$DeviceServicesTableOrderingComposer,
          $$DeviceServicesTableAnnotationComposer,
          $$DeviceServicesTableCreateCompanionBuilder,
          $$DeviceServicesTableUpdateCompanionBuilder,
          (DeviceService, $$DeviceServicesTableReferences),
          DeviceService,
          PrefetchHooks Function({bool deviceId})
        > {
  $$DeviceServicesTableTableManager(
    _$AppDatabase db,
    $DeviceServicesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeviceServicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeviceServicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeviceServicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> deviceId = const Value.absent(),
                Value<String> serviceKey = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeviceServicesCompanion(
                deviceId: deviceId,
                serviceKey: serviceKey,
                payload: payload,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String deviceId,
                required String serviceKey,
                required String payload,
                Value<int> rowid = const Value.absent(),
              }) => DeviceServicesCompanion.insert(
                deviceId: deviceId,
                serviceKey: serviceKey,
                payload: payload,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DeviceServicesTable, DeviceService>(table),
                  $$DeviceServicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({deviceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (deviceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.deviceId,
                                referencedTable: $$DeviceServicesTableReferences
                                    ._deviceIdTable(db),
                                referencedColumn:
                                    $$DeviceServicesTableReferences
                                        ._deviceIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DeviceServicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeviceServicesTable,
      DeviceService,
      $$DeviceServicesTableFilterComposer,
      $$DeviceServicesTableOrderingComposer,
      $$DeviceServicesTableAnnotationComposer,
      $$DeviceServicesTableCreateCompanionBuilder,
      $$DeviceServicesTableUpdateCompanionBuilder,
      (DeviceService, $$DeviceServicesTableReferences),
      DeviceService,
      PrefetchHooks Function({bool deviceId})
    >;
typedef $$ScanSessionsTableCreateCompanionBuilder =
    ScanSessionsCompanion Function({
      required String id,
      required String networkId,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      required String status,
      Value<int> scanned,
      required int total,
      Value<int> found,
      Value<int> rowid,
    });
typedef $$ScanSessionsTableUpdateCompanionBuilder =
    ScanSessionsCompanion Function({
      Value<String> id,
      Value<String> networkId,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<String> status,
      Value<int> scanned,
      Value<int> total,
      Value<int> found,
      Value<int> rowid,
    });

final class $$ScanSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $ScanSessionsTable, ScanSession> {
  $$ScanSessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NetworksTable _networkIdTable(_$AppDatabase db) =>
      db.networks.createAlias('scan_sessions__network_id__networks__id');

  $$NetworksTableProcessedTableManager get networkId {
    final $_column = $_itemColumn<String>('network_id')!;

    final manager = $$NetworksTableTableManager(
      $_db,
      $_db.networks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_networkIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ScanSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $ScanSessionsTable> {
  $$ScanSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scanned => $composableBuilder(
    column: $table.scanned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get found => $composableBuilder(
    column: $table.found,
    builder: (column) => ColumnFilters(column),
  );

  $$NetworksTableFilterComposer get networkId {
    final $$NetworksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.networkId,
      referencedTable: $db.networks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NetworksTableFilterComposer(
            $db: $db,
            $table: $db.networks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScanSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ScanSessionsTable> {
  $$ScanSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scanned => $composableBuilder(
    column: $table.scanned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get found => $composableBuilder(
    column: $table.found,
    builder: (column) => ColumnOrderings(column),
  );

  $$NetworksTableOrderingComposer get networkId {
    final $$NetworksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.networkId,
      referencedTable: $db.networks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NetworksTableOrderingComposer(
            $db: $db,
            $table: $db.networks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScanSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScanSessionsTable> {
  $$ScanSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get scanned =>
      $composableBuilder(column: $table.scanned, builder: (column) => column);

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get found =>
      $composableBuilder(column: $table.found, builder: (column) => column);

  $$NetworksTableAnnotationComposer get networkId {
    final $$NetworksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.networkId,
      referencedTable: $db.networks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NetworksTableAnnotationComposer(
            $db: $db,
            $table: $db.networks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScanSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScanSessionsTable,
          ScanSession,
          $$ScanSessionsTableFilterComposer,
          $$ScanSessionsTableOrderingComposer,
          $$ScanSessionsTableAnnotationComposer,
          $$ScanSessionsTableCreateCompanionBuilder,
          $$ScanSessionsTableUpdateCompanionBuilder,
          (ScanSession, $$ScanSessionsTableReferences),
          ScanSession,
          PrefetchHooks Function({bool networkId})
        > {
  $$ScanSessionsTableTableManager(_$AppDatabase db, $ScanSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScanSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScanSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScanSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> networkId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> scanned = const Value.absent(),
                Value<int> total = const Value.absent(),
                Value<int> found = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScanSessionsCompanion(
                id: id,
                networkId: networkId,
                startedAt: startedAt,
                endedAt: endedAt,
                status: status,
                scanned: scanned,
                total: total,
                found: found,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String networkId,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                required String status,
                Value<int> scanned = const Value.absent(),
                required int total,
                Value<int> found = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScanSessionsCompanion.insert(
                id: id,
                networkId: networkId,
                startedAt: startedAt,
                endedAt: endedAt,
                status: status,
                scanned: scanned,
                total: total,
                found: found,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ScanSessionsTable, ScanSession>(table),
                  $$ScanSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({networkId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (networkId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.networkId,
                                referencedTable: $$ScanSessionsTableReferences
                                    ._networkIdTable(db),
                                referencedColumn: $$ScanSessionsTableReferences
                                    ._networkIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ScanSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScanSessionsTable,
      ScanSession,
      $$ScanSessionsTableFilterComposer,
      $$ScanSessionsTableOrderingComposer,
      $$ScanSessionsTableAnnotationComposer,
      $$ScanSessionsTableCreateCompanionBuilder,
      $$ScanSessionsTableUpdateCompanionBuilder,
      (ScanSession, $$ScanSessionsTableReferences),
      ScanSession,
      PrefetchHooks Function({bool networkId})
    >;
typedef $$DeviceIdentifiersTableCreateCompanionBuilder =
    DeviceIdentifiersCompanion Function({
      required String id,
      required String deviceId,
      required String type,
      required String value,
      required int stability,
      required String payload,
      Value<int> rowid,
    });
typedef $$DeviceIdentifiersTableUpdateCompanionBuilder =
    DeviceIdentifiersCompanion Function({
      Value<String> id,
      Value<String> deviceId,
      Value<String> type,
      Value<String> value,
      Value<int> stability,
      Value<String> payload,
      Value<int> rowid,
    });

final class $$DeviceIdentifiersTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DeviceIdentifiersTable,
          DeviceIdentifier
        > {
  $$DeviceIdentifiersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DevicesTable _deviceIdTable(_$AppDatabase db) =>
      db.devices.createAlias('device_identifiers__device_id__devices__id');

  $$DevicesTableProcessedTableManager get deviceId {
    final $_column = $_itemColumn<String>('device_id')!;

    final manager = $$DevicesTableTableManager(
      $_db,
      $_db.devices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_deviceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DeviceIdentifiersTableFilterComposer
    extends Composer<_$AppDatabase, $DeviceIdentifiersTable> {
  $$DeviceIdentifiersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stability => $composableBuilder(
    column: $table.stability,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  $$DevicesTableFilterComposer get deviceId {
    final $$DevicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableFilterComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeviceIdentifiersTableOrderingComposer
    extends Composer<_$AppDatabase, $DeviceIdentifiersTable> {
  $$DeviceIdentifiersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stability => $composableBuilder(
    column: $table.stability,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  $$DevicesTableOrderingComposer get deviceId {
    final $$DevicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableOrderingComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeviceIdentifiersTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeviceIdentifiersTable> {
  $$DeviceIdentifiersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get stability =>
      $composableBuilder(column: $table.stability, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  $$DevicesTableAnnotationComposer get deviceId {
    final $$DevicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableAnnotationComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeviceIdentifiersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeviceIdentifiersTable,
          DeviceIdentifier,
          $$DeviceIdentifiersTableFilterComposer,
          $$DeviceIdentifiersTableOrderingComposer,
          $$DeviceIdentifiersTableAnnotationComposer,
          $$DeviceIdentifiersTableCreateCompanionBuilder,
          $$DeviceIdentifiersTableUpdateCompanionBuilder,
          (DeviceIdentifier, $$DeviceIdentifiersTableReferences),
          DeviceIdentifier,
          PrefetchHooks Function({bool deviceId})
        > {
  $$DeviceIdentifiersTableTableManager(
    _$AppDatabase db,
    $DeviceIdentifiersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeviceIdentifiersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeviceIdentifiersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeviceIdentifiersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> stability = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeviceIdentifiersCompanion(
                id: id,
                deviceId: deviceId,
                type: type,
                value: value,
                stability: stability,
                payload: payload,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String deviceId,
                required String type,
                required String value,
                required int stability,
                required String payload,
                Value<int> rowid = const Value.absent(),
              }) => DeviceIdentifiersCompanion.insert(
                id: id,
                deviceId: deviceId,
                type: type,
                value: value,
                stability: stability,
                payload: payload,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DeviceIdentifiersTable, DeviceIdentifier>(table),
                  $$DeviceIdentifiersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({deviceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (deviceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.deviceId,
                                referencedTable:
                                    $$DeviceIdentifiersTableReferences
                                        ._deviceIdTable(db),
                                referencedColumn:
                                    $$DeviceIdentifiersTableReferences
                                        ._deviceIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DeviceIdentifiersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeviceIdentifiersTable,
      DeviceIdentifier,
      $$DeviceIdentifiersTableFilterComposer,
      $$DeviceIdentifiersTableOrderingComposer,
      $$DeviceIdentifiersTableAnnotationComposer,
      $$DeviceIdentifiersTableCreateCompanionBuilder,
      $$DeviceIdentifiersTableUpdateCompanionBuilder,
      (DeviceIdentifier, $$DeviceIdentifiersTableReferences),
      DeviceIdentifier,
      PrefetchHooks Function({bool deviceId})
    >;
typedef $$IdentityEvidenceRowsTableCreateCompanionBuilder =
    IdentityEvidenceRowsCompanion Function({
      required String id,
      required String deviceId,
      required String source,
      required String evidenceKey,
      required String normalizedValue,
      required int weight,
      required int observationCount,
      Value<DateTime?> expiresAt,
      required String payload,
      Value<int> rowid,
    });
typedef $$IdentityEvidenceRowsTableUpdateCompanionBuilder =
    IdentityEvidenceRowsCompanion Function({
      Value<String> id,
      Value<String> deviceId,
      Value<String> source,
      Value<String> evidenceKey,
      Value<String> normalizedValue,
      Value<int> weight,
      Value<int> observationCount,
      Value<DateTime?> expiresAt,
      Value<String> payload,
      Value<int> rowid,
    });

final class $$IdentityEvidenceRowsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $IdentityEvidenceRowsTable,
          IdentityEvidenceRow
        > {
  $$IdentityEvidenceRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DevicesTable _deviceIdTable(_$AppDatabase db) =>
      db.devices.createAlias('identity_evidence_rows__device_id__devices__id');

  $$DevicesTableProcessedTableManager get deviceId {
    final $_column = $_itemColumn<String>('device_id')!;

    final manager = $$DevicesTableTableManager(
      $_db,
      $_db.devices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_deviceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IdentityEvidenceRowsTableFilterComposer
    extends Composer<_$AppDatabase, $IdentityEvidenceRowsTable> {
  $$IdentityEvidenceRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get evidenceKey => $composableBuilder(
    column: $table.evidenceKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalizedValue => $composableBuilder(
    column: $table.normalizedValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get observationCount => $composableBuilder(
    column: $table.observationCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  $$DevicesTableFilterComposer get deviceId {
    final $$DevicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableFilterComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IdentityEvidenceRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $IdentityEvidenceRowsTable> {
  $$IdentityEvidenceRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get evidenceKey => $composableBuilder(
    column: $table.evidenceKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalizedValue => $composableBuilder(
    column: $table.normalizedValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get observationCount => $composableBuilder(
    column: $table.observationCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  $$DevicesTableOrderingComposer get deviceId {
    final $$DevicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableOrderingComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IdentityEvidenceRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IdentityEvidenceRowsTable> {
  $$IdentityEvidenceRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get evidenceKey => $composableBuilder(
    column: $table.evidenceKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get normalizedValue => $composableBuilder(
    column: $table.normalizedValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<int> get observationCount => $composableBuilder(
    column: $table.observationCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  $$DevicesTableAnnotationComposer get deviceId {
    final $$DevicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableAnnotationComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IdentityEvidenceRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IdentityEvidenceRowsTable,
          IdentityEvidenceRow,
          $$IdentityEvidenceRowsTableFilterComposer,
          $$IdentityEvidenceRowsTableOrderingComposer,
          $$IdentityEvidenceRowsTableAnnotationComposer,
          $$IdentityEvidenceRowsTableCreateCompanionBuilder,
          $$IdentityEvidenceRowsTableUpdateCompanionBuilder,
          (IdentityEvidenceRow, $$IdentityEvidenceRowsTableReferences),
          IdentityEvidenceRow,
          PrefetchHooks Function({bool deviceId})
        > {
  $$IdentityEvidenceRowsTableTableManager(
    _$AppDatabase db,
    $IdentityEvidenceRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IdentityEvidenceRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IdentityEvidenceRowsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$IdentityEvidenceRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> evidenceKey = const Value.absent(),
                Value<String> normalizedValue = const Value.absent(),
                Value<int> weight = const Value.absent(),
                Value<int> observationCount = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IdentityEvidenceRowsCompanion(
                id: id,
                deviceId: deviceId,
                source: source,
                evidenceKey: evidenceKey,
                normalizedValue: normalizedValue,
                weight: weight,
                observationCount: observationCount,
                expiresAt: expiresAt,
                payload: payload,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String deviceId,
                required String source,
                required String evidenceKey,
                required String normalizedValue,
                required int weight,
                required int observationCount,
                Value<DateTime?> expiresAt = const Value.absent(),
                required String payload,
                Value<int> rowid = const Value.absent(),
              }) => IdentityEvidenceRowsCompanion.insert(
                id: id,
                deviceId: deviceId,
                source: source,
                evidenceKey: evidenceKey,
                normalizedValue: normalizedValue,
                weight: weight,
                observationCount: observationCount,
                expiresAt: expiresAt,
                payload: payload,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$IdentityEvidenceRowsTable, IdentityEvidenceRow>(
                    table,
                  ),
                  $$IdentityEvidenceRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({deviceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (deviceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.deviceId,
                                referencedTable:
                                    $$IdentityEvidenceRowsTableReferences
                                        ._deviceIdTable(db),
                                referencedColumn:
                                    $$IdentityEvidenceRowsTableReferences
                                        ._deviceIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$IdentityEvidenceRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IdentityEvidenceRowsTable,
      IdentityEvidenceRow,
      $$IdentityEvidenceRowsTableFilterComposer,
      $$IdentityEvidenceRowsTableOrderingComposer,
      $$IdentityEvidenceRowsTableAnnotationComposer,
      $$IdentityEvidenceRowsTableCreateCompanionBuilder,
      $$IdentityEvidenceRowsTableUpdateCompanionBuilder,
      (IdentityEvidenceRow, $$IdentityEvidenceRowsTableReferences),
      IdentityEvidenceRow,
      PrefetchHooks Function({bool deviceId})
    >;
typedef $$DeviceFingerprintsTableCreateCompanionBuilder =
    DeviceFingerprintsCompanion Function({
      required String deviceId,
      required String payload,
      Value<DateTime?> lastEvaluated,
      Value<int> rowid,
    });
typedef $$DeviceFingerprintsTableUpdateCompanionBuilder =
    DeviceFingerprintsCompanion Function({
      Value<String> deviceId,
      Value<String> payload,
      Value<DateTime?> lastEvaluated,
      Value<int> rowid,
    });

final class $$DeviceFingerprintsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DeviceFingerprintsTable,
          FingerprintRow
        > {
  $$DeviceFingerprintsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DevicesTable _deviceIdTable(_$AppDatabase db) =>
      db.devices.createAlias('device_fingerprints__device_id__devices__id');

  $$DevicesTableProcessedTableManager get deviceId {
    final $_column = $_itemColumn<String>('device_id')!;

    final manager = $$DevicesTableTableManager(
      $_db,
      $_db.devices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_deviceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DeviceFingerprintsTableFilterComposer
    extends Composer<_$AppDatabase, $DeviceFingerprintsTable> {
  $$DeviceFingerprintsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastEvaluated => $composableBuilder(
    column: $table.lastEvaluated,
    builder: (column) => ColumnFilters(column),
  );

  $$DevicesTableFilterComposer get deviceId {
    final $$DevicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableFilterComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeviceFingerprintsTableOrderingComposer
    extends Composer<_$AppDatabase, $DeviceFingerprintsTable> {
  $$DeviceFingerprintsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastEvaluated => $composableBuilder(
    column: $table.lastEvaluated,
    builder: (column) => ColumnOrderings(column),
  );

  $$DevicesTableOrderingComposer get deviceId {
    final $$DevicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableOrderingComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeviceFingerprintsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeviceFingerprintsTable> {
  $$DeviceFingerprintsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get lastEvaluated => $composableBuilder(
    column: $table.lastEvaluated,
    builder: (column) => column,
  );

  $$DevicesTableAnnotationComposer get deviceId {
    final $$DevicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableAnnotationComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeviceFingerprintsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeviceFingerprintsTable,
          FingerprintRow,
          $$DeviceFingerprintsTableFilterComposer,
          $$DeviceFingerprintsTableOrderingComposer,
          $$DeviceFingerprintsTableAnnotationComposer,
          $$DeviceFingerprintsTableCreateCompanionBuilder,
          $$DeviceFingerprintsTableUpdateCompanionBuilder,
          (FingerprintRow, $$DeviceFingerprintsTableReferences),
          FingerprintRow,
          PrefetchHooks Function({bool deviceId})
        > {
  $$DeviceFingerprintsTableTableManager(
    _$AppDatabase db,
    $DeviceFingerprintsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeviceFingerprintsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeviceFingerprintsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeviceFingerprintsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> deviceId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime?> lastEvaluated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeviceFingerprintsCompanion(
                deviceId: deviceId,
                payload: payload,
                lastEvaluated: lastEvaluated,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String deviceId,
                required String payload,
                Value<DateTime?> lastEvaluated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeviceFingerprintsCompanion.insert(
                deviceId: deviceId,
                payload: payload,
                lastEvaluated: lastEvaluated,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DeviceFingerprintsTable, FingerprintRow>(table),
                  $$DeviceFingerprintsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({deviceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (deviceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.deviceId,
                                referencedTable:
                                    $$DeviceFingerprintsTableReferences
                                        ._deviceIdTable(db),
                                referencedColumn:
                                    $$DeviceFingerprintsTableReferences
                                        ._deviceIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DeviceFingerprintsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeviceFingerprintsTable,
      FingerprintRow,
      $$DeviceFingerprintsTableFilterComposer,
      $$DeviceFingerprintsTableOrderingComposer,
      $$DeviceFingerprintsTableAnnotationComposer,
      $$DeviceFingerprintsTableCreateCompanionBuilder,
      $$DeviceFingerprintsTableUpdateCompanionBuilder,
      (FingerprintRow, $$DeviceFingerprintsTableReferences),
      FingerprintRow,
      PrefetchHooks Function({bool deviceId})
    >;
typedef $$DeviceOverridesTableCreateCompanionBuilder =
    DeviceOverridesCompanion Function({
      required String deviceId,
      required String payload,
      Value<int> rowid,
    });
typedef $$DeviceOverridesTableUpdateCompanionBuilder =
    DeviceOverridesCompanion Function({
      Value<String> deviceId,
      Value<String> payload,
      Value<int> rowid,
    });

final class $$DeviceOverridesTableReferences
    extends BaseReferences<_$AppDatabase, $DeviceOverridesTable, OverrideRow> {
  $$DeviceOverridesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DevicesTable _deviceIdTable(_$AppDatabase db) =>
      db.devices.createAlias('device_overrides__device_id__devices__id');

  $$DevicesTableProcessedTableManager get deviceId {
    final $_column = $_itemColumn<String>('device_id')!;

    final manager = $$DevicesTableTableManager(
      $_db,
      $_db.devices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_deviceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DeviceOverridesTableFilterComposer
    extends Composer<_$AppDatabase, $DeviceOverridesTable> {
  $$DeviceOverridesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  $$DevicesTableFilterComposer get deviceId {
    final $$DevicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableFilterComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeviceOverridesTableOrderingComposer
    extends Composer<_$AppDatabase, $DeviceOverridesTable> {
  $$DeviceOverridesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  $$DevicesTableOrderingComposer get deviceId {
    final $$DevicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableOrderingComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeviceOverridesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeviceOverridesTable> {
  $$DeviceOverridesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  $$DevicesTableAnnotationComposer get deviceId {
    final $$DevicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableAnnotationComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeviceOverridesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeviceOverridesTable,
          OverrideRow,
          $$DeviceOverridesTableFilterComposer,
          $$DeviceOverridesTableOrderingComposer,
          $$DeviceOverridesTableAnnotationComposer,
          $$DeviceOverridesTableCreateCompanionBuilder,
          $$DeviceOverridesTableUpdateCompanionBuilder,
          (OverrideRow, $$DeviceOverridesTableReferences),
          OverrideRow,
          PrefetchHooks Function({bool deviceId})
        > {
  $$DeviceOverridesTableTableManager(
    _$AppDatabase db,
    $DeviceOverridesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeviceOverridesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeviceOverridesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeviceOverridesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> deviceId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeviceOverridesCompanion(
                deviceId: deviceId,
                payload: payload,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String deviceId,
                required String payload,
                Value<int> rowid = const Value.absent(),
              }) => DeviceOverridesCompanion.insert(
                deviceId: deviceId,
                payload: payload,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DeviceOverridesTable, OverrideRow>(table),
                  $$DeviceOverridesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({deviceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (deviceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.deviceId,
                                referencedTable:
                                    $$DeviceOverridesTableReferences
                                        ._deviceIdTable(db),
                                referencedColumn:
                                    $$DeviceOverridesTableReferences
                                        ._deviceIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DeviceOverridesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeviceOverridesTable,
      OverrideRow,
      $$DeviceOverridesTableFilterComposer,
      $$DeviceOverridesTableOrderingComposer,
      $$DeviceOverridesTableAnnotationComposer,
      $$DeviceOverridesTableCreateCompanionBuilder,
      $$DeviceOverridesTableUpdateCompanionBuilder,
      (OverrideRow, $$DeviceOverridesTableReferences),
      OverrideRow,
      PrefetchHooks Function({bool deviceId})
    >;
typedef $$PotentialSameDeviceLinksTableCreateCompanionBuilder =
    PotentialSameDeviceLinksCompanion Function({
      required String deviceId,
      required String otherDeviceId,
      required String reason,
      Value<int> rowid,
    });
typedef $$PotentialSameDeviceLinksTableUpdateCompanionBuilder =
    PotentialSameDeviceLinksCompanion Function({
      Value<String> deviceId,
      Value<String> otherDeviceId,
      Value<String> reason,
      Value<int> rowid,
    });

final class $$PotentialSameDeviceLinksTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PotentialSameDeviceLinksTable,
          PotentialSameDeviceLink
        > {
  $$PotentialSameDeviceLinksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DevicesTable _deviceIdTable(_$AppDatabase db) => db.devices
      .createAlias('potential_same_device_links__device_id__devices__id');

  $$DevicesTableProcessedTableManager get deviceId {
    final $_column = $_itemColumn<String>('device_id')!;

    final manager = $$DevicesTableTableManager(
      $_db,
      $_db.devices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_deviceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DevicesTable _otherDeviceIdTable(_$AppDatabase db) => db.devices
      .createAlias('potential_same_device_links__other_device_id__devices__id');

  $$DevicesTableProcessedTableManager get otherDeviceId {
    final $_column = $_itemColumn<String>('other_device_id')!;

    final manager = $$DevicesTableTableManager(
      $_db,
      $_db.devices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_otherDeviceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PotentialSameDeviceLinksTableFilterComposer
    extends Composer<_$AppDatabase, $PotentialSameDeviceLinksTable> {
  $$PotentialSameDeviceLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  $$DevicesTableFilterComposer get deviceId {
    final $$DevicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableFilterComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DevicesTableFilterComposer get otherDeviceId {
    final $$DevicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.otherDeviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableFilterComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PotentialSameDeviceLinksTableOrderingComposer
    extends Composer<_$AppDatabase, $PotentialSameDeviceLinksTable> {
  $$PotentialSameDeviceLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  $$DevicesTableOrderingComposer get deviceId {
    final $$DevicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableOrderingComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DevicesTableOrderingComposer get otherDeviceId {
    final $$DevicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.otherDeviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableOrderingComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PotentialSameDeviceLinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $PotentialSameDeviceLinksTable> {
  $$PotentialSameDeviceLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  $$DevicesTableAnnotationComposer get deviceId {
    final $$DevicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableAnnotationComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DevicesTableAnnotationComposer get otherDeviceId {
    final $$DevicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.otherDeviceId,
      referencedTable: $db.devices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DevicesTableAnnotationComposer(
            $db: $db,
            $table: $db.devices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PotentialSameDeviceLinksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PotentialSameDeviceLinksTable,
          PotentialSameDeviceLink,
          $$PotentialSameDeviceLinksTableFilterComposer,
          $$PotentialSameDeviceLinksTableOrderingComposer,
          $$PotentialSameDeviceLinksTableAnnotationComposer,
          $$PotentialSameDeviceLinksTableCreateCompanionBuilder,
          $$PotentialSameDeviceLinksTableUpdateCompanionBuilder,
          (PotentialSameDeviceLink, $$PotentialSameDeviceLinksTableReferences),
          PotentialSameDeviceLink,
          PrefetchHooks Function({bool deviceId, bool otherDeviceId})
        > {
  $$PotentialSameDeviceLinksTableTableManager(
    _$AppDatabase db,
    $PotentialSameDeviceLinksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PotentialSameDeviceLinksTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PotentialSameDeviceLinksTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PotentialSameDeviceLinksTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> deviceId = const Value.absent(),
                Value<String> otherDeviceId = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PotentialSameDeviceLinksCompanion(
                deviceId: deviceId,
                otherDeviceId: otherDeviceId,
                reason: reason,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String deviceId,
                required String otherDeviceId,
                required String reason,
                Value<int> rowid = const Value.absent(),
              }) => PotentialSameDeviceLinksCompanion.insert(
                deviceId: deviceId,
                otherDeviceId: otherDeviceId,
                reason: reason,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $PotentialSameDeviceLinksTable,
                    PotentialSameDeviceLink
                  >(table),
                  $$PotentialSameDeviceLinksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({deviceId = false, otherDeviceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (deviceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.deviceId,
                                referencedTable:
                                    $$PotentialSameDeviceLinksTableReferences
                                        ._deviceIdTable(db),
                                referencedColumn:
                                    $$PotentialSameDeviceLinksTableReferences
                                        ._deviceIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (otherDeviceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.otherDeviceId,
                                referencedTable:
                                    $$PotentialSameDeviceLinksTableReferences
                                        ._otherDeviceIdTable(db),
                                referencedColumn:
                                    $$PotentialSameDeviceLinksTableReferences
                                        ._otherDeviceIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PotentialSameDeviceLinksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PotentialSameDeviceLinksTable,
      PotentialSameDeviceLink,
      $$PotentialSameDeviceLinksTableFilterComposer,
      $$PotentialSameDeviceLinksTableOrderingComposer,
      $$PotentialSameDeviceLinksTableAnnotationComposer,
      $$PotentialSameDeviceLinksTableCreateCompanionBuilder,
      $$PotentialSameDeviceLinksTableUpdateCompanionBuilder,
      (PotentialSameDeviceLink, $$PotentialSameDeviceLinksTableReferences),
      PotentialSameDeviceLink,
      PrefetchHooks Function({bool deviceId, bool otherDeviceId})
    >;
typedef $$GuardianConversationsTableCreateCompanionBuilder =
    GuardianConversationsCompanion Function({
      required String id,
      required String networkId,
      Value<String> title,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$GuardianConversationsTableUpdateCompanionBuilder =
    GuardianConversationsCompanion Function({
      Value<String> id,
      Value<String> networkId,
      Value<String> title,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$GuardianConversationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $GuardianConversationsTable,
          GuardianConversationRow
        > {
  $$GuardianConversationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$GuardianMessagesTable, List<GuardianMessageRow>>
  _guardianMessagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.guardianMessages,
    aliasName: 'guardian_conversations__id__guardian_messages__conversation_id',
  );

  $$GuardianMessagesTableProcessedTableManager get guardianMessagesRefs {
    final manager = $$GuardianMessagesTableTableManager(
      $_db,
      $_db.guardianMessages,
    ).filter((f) => f.conversationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _guardianMessagesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GuardianConversationsTableFilterComposer
    extends Composer<_$AppDatabase, $GuardianConversationsTable> {
  $$GuardianConversationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get networkId => $composableBuilder(
    column: $table.networkId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> guardianMessagesRefs(
    Expression<bool> Function($$GuardianMessagesTableFilterComposer f) f,
  ) {
    final $$GuardianMessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.guardianMessages,
      getReferencedColumn: (t) => t.conversationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GuardianMessagesTableFilterComposer(
            $db: $db,
            $table: $db.guardianMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GuardianConversationsTableOrderingComposer
    extends Composer<_$AppDatabase, $GuardianConversationsTable> {
  $$GuardianConversationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get networkId => $composableBuilder(
    column: $table.networkId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GuardianConversationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GuardianConversationsTable> {
  $$GuardianConversationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get networkId =>
      $composableBuilder(column: $table.networkId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> guardianMessagesRefs<T extends Object>(
    Expression<T> Function($$GuardianMessagesTableAnnotationComposer a) f,
  ) {
    final $$GuardianMessagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.guardianMessages,
      getReferencedColumn: (t) => t.conversationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GuardianMessagesTableAnnotationComposer(
            $db: $db,
            $table: $db.guardianMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GuardianConversationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GuardianConversationsTable,
          GuardianConversationRow,
          $$GuardianConversationsTableFilterComposer,
          $$GuardianConversationsTableOrderingComposer,
          $$GuardianConversationsTableAnnotationComposer,
          $$GuardianConversationsTableCreateCompanionBuilder,
          $$GuardianConversationsTableUpdateCompanionBuilder,
          (GuardianConversationRow, $$GuardianConversationsTableReferences),
          GuardianConversationRow,
          PrefetchHooks Function({bool guardianMessagesRefs})
        > {
  $$GuardianConversationsTableTableManager(
    _$AppDatabase db,
    $GuardianConversationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GuardianConversationsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$GuardianConversationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$GuardianConversationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> networkId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GuardianConversationsCompanion(
                id: id,
                networkId: networkId,
                title: title,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String networkId,
                Value<String> title = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => GuardianConversationsCompanion.insert(
                id: id,
                networkId: networkId,
                title: title,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $GuardianConversationsTable,
                    GuardianConversationRow
                  >(table),
                  $$GuardianConversationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({guardianMessagesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (guardianMessagesRefs) db.guardianMessages,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (guardianMessagesRefs)
                    await $_getPrefetchedData<
                      GuardianConversationRow,
                      $GuardianConversationsTable,
                      GuardianMessageRow
                    >(
                      currentTable: table,
                      referencedTable: $$GuardianConversationsTableReferences
                          ._guardianMessagesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$GuardianConversationsTableReferences(
                            db,
                            table,
                            p0,
                          ).guardianMessagesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.conversationId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$GuardianConversationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GuardianConversationsTable,
      GuardianConversationRow,
      $$GuardianConversationsTableFilterComposer,
      $$GuardianConversationsTableOrderingComposer,
      $$GuardianConversationsTableAnnotationComposer,
      $$GuardianConversationsTableCreateCompanionBuilder,
      $$GuardianConversationsTableUpdateCompanionBuilder,
      (GuardianConversationRow, $$GuardianConversationsTableReferences),
      GuardianConversationRow,
      PrefetchHooks Function({bool guardianMessagesRefs})
    >;
typedef $$GuardianMessagesTableCreateCompanionBuilder =
    GuardianMessagesCompanion Function({
      required String id,
      required String conversationId,
      required String role,
      required String textBody,
      required String payload,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$GuardianMessagesTableUpdateCompanionBuilder =
    GuardianMessagesCompanion Function({
      Value<String> id,
      Value<String> conversationId,
      Value<String> role,
      Value<String> textBody,
      Value<String> payload,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$GuardianMessagesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $GuardianMessagesTable,
          GuardianMessageRow
        > {
  $$GuardianMessagesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GuardianConversationsTable _conversationIdTable(_$AppDatabase db) =>
      db.guardianConversations.createAlias(
        'guardian_messages__conversation_id__guardian_conversations__id',
      );

  $$GuardianConversationsTableProcessedTableManager get conversationId {
    final $_column = $_itemColumn<String>('conversation_id')!;

    final manager = $$GuardianConversationsTableTableManager(
      $_db,
      $_db.guardianConversations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_conversationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GuardianMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $GuardianMessagesTable> {
  $$GuardianMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textBody => $composableBuilder(
    column: $table.textBody,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GuardianConversationsTableFilterComposer get conversationId {
    final $$GuardianConversationsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.conversationId,
          referencedTable: $db.guardianConversations,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GuardianConversationsTableFilterComposer(
                $db: $db,
                $table: $db.guardianConversations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$GuardianMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $GuardianMessagesTable> {
  $$GuardianMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textBody => $composableBuilder(
    column: $table.textBody,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GuardianConversationsTableOrderingComposer get conversationId {
    final $$GuardianConversationsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.conversationId,
          referencedTable: $db.guardianConversations,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GuardianConversationsTableOrderingComposer(
                $db: $db,
                $table: $db.guardianConversations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$GuardianMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GuardianMessagesTable> {
  $$GuardianMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get textBody =>
      $composableBuilder(column: $table.textBody, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$GuardianConversationsTableAnnotationComposer get conversationId {
    final $$GuardianConversationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.conversationId,
          referencedTable: $db.guardianConversations,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GuardianConversationsTableAnnotationComposer(
                $db: $db,
                $table: $db.guardianConversations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$GuardianMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GuardianMessagesTable,
          GuardianMessageRow,
          $$GuardianMessagesTableFilterComposer,
          $$GuardianMessagesTableOrderingComposer,
          $$GuardianMessagesTableAnnotationComposer,
          $$GuardianMessagesTableCreateCompanionBuilder,
          $$GuardianMessagesTableUpdateCompanionBuilder,
          (GuardianMessageRow, $$GuardianMessagesTableReferences),
          GuardianMessageRow,
          PrefetchHooks Function({bool conversationId})
        > {
  $$GuardianMessagesTableTableManager(
    _$AppDatabase db,
    $GuardianMessagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GuardianMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GuardianMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GuardianMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> textBody = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GuardianMessagesCompanion(
                id: id,
                conversationId: conversationId,
                role: role,
                textBody: textBody,
                payload: payload,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String conversationId,
                required String role,
                required String textBody,
                required String payload,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => GuardianMessagesCompanion.insert(
                id: id,
                conversationId: conversationId,
                role: role,
                textBody: textBody,
                payload: payload,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GuardianMessagesTable, GuardianMessageRow>(
                    table,
                  ),
                  $$GuardianMessagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({conversationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (conversationId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.conversationId,
                                referencedTable:
                                    $$GuardianMessagesTableReferences
                                        ._conversationIdTable(db),
                                referencedColumn:
                                    $$GuardianMessagesTableReferences
                                        ._conversationIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GuardianMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GuardianMessagesTable,
      GuardianMessageRow,
      $$GuardianMessagesTableFilterComposer,
      $$GuardianMessagesTableOrderingComposer,
      $$GuardianMessagesTableAnnotationComposer,
      $$GuardianMessagesTableCreateCompanionBuilder,
      $$GuardianMessagesTableUpdateCompanionBuilder,
      (GuardianMessageRow, $$GuardianMessagesTableReferences),
      GuardianMessageRow,
      PrefetchHooks Function({bool conversationId})
    >;
typedef $$DiagnosticRunsTableCreateCompanionBuilder =
    DiagnosticRunsCompanion Function({
      required String id,
      required String networkId,
      required String status,
      required String payload,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$DiagnosticRunsTableUpdateCompanionBuilder =
    DiagnosticRunsCompanion Function({
      Value<String> id,
      Value<String> networkId,
      Value<String> status,
      Value<String> payload,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$DiagnosticRunsTableFilterComposer
    extends Composer<_$AppDatabase, $DiagnosticRunsTable> {
  $$DiagnosticRunsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get networkId => $composableBuilder(
    column: $table.networkId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DiagnosticRunsTableOrderingComposer
    extends Composer<_$AppDatabase, $DiagnosticRunsTable> {
  $$DiagnosticRunsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get networkId => $composableBuilder(
    column: $table.networkId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DiagnosticRunsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiagnosticRunsTable> {
  $$DiagnosticRunsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get networkId =>
      $composableBuilder(column: $table.networkId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DiagnosticRunsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiagnosticRunsTable,
          DiagnosticRunRow,
          $$DiagnosticRunsTableFilterComposer,
          $$DiagnosticRunsTableOrderingComposer,
          $$DiagnosticRunsTableAnnotationComposer,
          $$DiagnosticRunsTableCreateCompanionBuilder,
          $$DiagnosticRunsTableUpdateCompanionBuilder,
          (
            DiagnosticRunRow,
            BaseReferences<
              _$AppDatabase,
              $DiagnosticRunsTable,
              DiagnosticRunRow
            >,
          ),
          DiagnosticRunRow,
          PrefetchHooks Function()
        > {
  $$DiagnosticRunsTableTableManager(
    _$AppDatabase db,
    $DiagnosticRunsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiagnosticRunsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiagnosticRunsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiagnosticRunsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> networkId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DiagnosticRunsCompanion(
                id: id,
                networkId: networkId,
                status: status,
                payload: payload,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String networkId,
                required String status,
                required String payload,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => DiagnosticRunsCompanion.insert(
                id: id,
                networkId: networkId,
                status: status,
                payload: payload,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DiagnosticRunsTable, DiagnosticRunRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $DiagnosticRunsTable,
                    DiagnosticRunRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DiagnosticRunsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiagnosticRunsTable,
      DiagnosticRunRow,
      $$DiagnosticRunsTableFilterComposer,
      $$DiagnosticRunsTableOrderingComposer,
      $$DiagnosticRunsTableAnnotationComposer,
      $$DiagnosticRunsTableCreateCompanionBuilder,
      $$DiagnosticRunsTableUpdateCompanionBuilder,
      (
        DiagnosticRunRow,
        BaseReferences<_$AppDatabase, $DiagnosticRunsTable, DiagnosticRunRow>,
      ),
      DiagnosticRunRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NetworksTableTableManager get networks =>
      $$NetworksTableTableManager(_db, _db.networks);
  $$DevicesTableTableManager get devices =>
      $$DevicesTableTableManager(_db, _db.devices);
  $$DeviceServicesTableTableManager get deviceServices =>
      $$DeviceServicesTableTableManager(_db, _db.deviceServices);
  $$ScanSessionsTableTableManager get scanSessions =>
      $$ScanSessionsTableTableManager(_db, _db.scanSessions);
  $$DeviceIdentifiersTableTableManager get deviceIdentifiers =>
      $$DeviceIdentifiersTableTableManager(_db, _db.deviceIdentifiers);
  $$IdentityEvidenceRowsTableTableManager get identityEvidenceRows =>
      $$IdentityEvidenceRowsTableTableManager(_db, _db.identityEvidenceRows);
  $$DeviceFingerprintsTableTableManager get deviceFingerprints =>
      $$DeviceFingerprintsTableTableManager(_db, _db.deviceFingerprints);
  $$DeviceOverridesTableTableManager get deviceOverrides =>
      $$DeviceOverridesTableTableManager(_db, _db.deviceOverrides);
  $$PotentialSameDeviceLinksTableTableManager get potentialSameDeviceLinks =>
      $$PotentialSameDeviceLinksTableTableManager(
        _db,
        _db.potentialSameDeviceLinks,
      );
  $$GuardianConversationsTableTableManager get guardianConversations =>
      $$GuardianConversationsTableTableManager(_db, _db.guardianConversations);
  $$GuardianMessagesTableTableManager get guardianMessages =>
      $$GuardianMessagesTableTableManager(_db, _db.guardianMessages);
  $$DiagnosticRunsTableTableManager get diagnosticRuns =>
      $$DiagnosticRunsTableTableManager(_db, _db.diagnosticRuns);
}
