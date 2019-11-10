// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Device extends DataClass implements Insertable<Device> {
  final int id;
  final String uuid;
  final String name;
  final String ip;
  final int powerState;
  Device(
      {@required this.id,
      @required this.uuid,
      @required this.name,
      @required this.ip,
      @required this.powerState});
  factory Device.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Device(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      uuid: stringType.mapFromDatabaseResponse(data['${effectivePrefix}uuid']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      ip: stringType.mapFromDatabaseResponse(data['${effectivePrefix}ip']),
      powerState: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}power_state']),
    );
  }
  factory Device.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return Device(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      name: serializer.fromJson<String>(json['name']),
      ip: serializer.fromJson<String>(json['ip']),
      powerState: serializer.fromJson<int>(json['powerState']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'name': serializer.toJson<String>(name),
      'ip': serializer.toJson<String>(ip),
      'powerState': serializer.toJson<int>(powerState),
    };
  }

  @override
  DevicesCompanion createCompanion(bool nullToAbsent) {
    return DevicesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      uuid: uuid == null && nullToAbsent ? const Value.absent() : Value(uuid),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      ip: ip == null && nullToAbsent ? const Value.absent() : Value(ip),
      powerState: powerState == null && nullToAbsent
          ? const Value.absent()
          : Value(powerState),
    );
  }

  Device copyWith(
          {int id, String uuid, String name, String ip, int powerState}) =>
      Device(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        name: name ?? this.name,
        ip: ip ?? this.ip,
        powerState: powerState ?? this.powerState,
      );
  @override
  String toString() {
    return (StringBuffer('Device(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('ip: $ip, ')
          ..write('powerState: $powerState')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(uuid.hashCode,
          $mrjc(name.hashCode, $mrjc(ip.hashCode, powerState.hashCode)))));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Device &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.name == this.name &&
          other.ip == this.ip &&
          other.powerState == this.powerState);
}

class DevicesCompanion extends UpdateCompanion<Device> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> name;
  final Value<String> ip;
  final Value<int> powerState;
  const DevicesCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.name = const Value.absent(),
    this.ip = const Value.absent(),
    this.powerState = const Value.absent(),
  });
  DevicesCompanion.insert({
    this.id = const Value.absent(),
    @required String uuid,
    @required String name,
    @required String ip,
    @required int powerState,
  })  : uuid = Value(uuid),
        name = Value(name),
        ip = Value(ip),
        powerState = Value(powerState);
  DevicesCompanion copyWith(
      {Value<int> id,
      Value<String> uuid,
      Value<String> name,
      Value<String> ip,
      Value<int> powerState}) {
    return DevicesCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      ip: ip ?? this.ip,
      powerState: powerState ?? this.powerState,
    );
  }
}

class $DevicesTable extends Devices with TableInfo<$DevicesTable, Device> {
  final GeneratedDatabase _db;
  final String _alias;
  $DevicesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  GeneratedTextColumn _uuid;
  @override
  GeneratedTextColumn get uuid => _uuid ??= _constructUuid();
  GeneratedTextColumn _constructUuid() {
    return GeneratedTextColumn(
      'uuid',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _ipMeta = const VerificationMeta('ip');
  GeneratedTextColumn _ip;
  @override
  GeneratedTextColumn get ip => _ip ??= _constructIp();
  GeneratedTextColumn _constructIp() {
    return GeneratedTextColumn(
      'ip',
      $tableName,
      false,
    );
  }

  final VerificationMeta _powerStateMeta = const VerificationMeta('powerState');
  GeneratedIntColumn _powerState;
  @override
  GeneratedIntColumn get powerState => _powerState ??= _constructPowerState();
  GeneratedIntColumn _constructPowerState() {
    return GeneratedIntColumn(
      'power_state',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, uuid, name, ip, powerState];
  @override
  $DevicesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'devices';
  @override
  final String actualTableName = 'devices';
  @override
  VerificationContext validateIntegrity(DevicesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.uuid.present) {
      context.handle(
          _uuidMeta, uuid.isAcceptableValue(d.uuid.value, _uuidMeta));
    } else if (uuid.isRequired && isInserting) {
      context.missing(_uuidMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (name.isRequired && isInserting) {
      context.missing(_nameMeta);
    }
    if (d.ip.present) {
      context.handle(_ipMeta, ip.isAcceptableValue(d.ip.value, _ipMeta));
    } else if (ip.isRequired && isInserting) {
      context.missing(_ipMeta);
    }
    if (d.powerState.present) {
      context.handle(_powerStateMeta,
          powerState.isAcceptableValue(d.powerState.value, _powerStateMeta));
    } else if (powerState.isRequired && isInserting) {
      context.missing(_powerStateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Device map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Device.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(DevicesCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.uuid.present) {
      map['uuid'] = Variable<String, StringType>(d.uuid.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.ip.present) {
      map['ip'] = Variable<String, StringType>(d.ip.value);
    }
    if (d.powerState.present) {
      map['power_state'] = Variable<int, IntType>(d.powerState.value);
    }
    return map;
  }

  @override
  $DevicesTable createAlias(String alias) {
    return $DevicesTable(_db, alias);
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $DevicesTable _devices;
  $DevicesTable get devices => _devices ??= $DevicesTable(this);
  DevicesDao _devicesDao;
  DevicesDao get devicesDao => _devicesDao ??= DevicesDao(this as MyDatabase);
  @override
  List<TableInfo> get allTables => [devices];
}
