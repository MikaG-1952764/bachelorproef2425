// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'Your name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _maxHeartRateMeta =
      const VerificationMeta('maxHeartRate');
  @override
  late final GeneratedColumn<int> maxHeartRate = GeneratedColumn<int>(
      'max_heart_rate', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _averageHeartRateMeta =
      const VerificationMeta('averageHeartRate');
  @override
  late final GeneratedColumn<int> averageHeartRate = GeneratedColumn<int>(
      'average_heart_rate', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _averageGSRMeta =
      const VerificationMeta('averageGSR');
  @override
  late final GeneratedColumn<int> averageGSR = GeneratedColumn<int>(
      'average_g_s_r', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, maxHeartRate, averageHeartRate, averageGSR, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('Your name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['Your name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('max_heart_rate')) {
      context.handle(
          _maxHeartRateMeta,
          maxHeartRate.isAcceptableOrUnknown(
              data['max_heart_rate']!, _maxHeartRateMeta));
    }
    if (data.containsKey('average_heart_rate')) {
      context.handle(
          _averageHeartRateMeta,
          averageHeartRate.isAcceptableOrUnknown(
              data['average_heart_rate']!, _averageHeartRateMeta));
    }
    if (data.containsKey('average_g_s_r')) {
      context.handle(
          _averageGSRMeta,
          averageGSR.isAcceptableOrUnknown(
              data['average_g_s_r']!, _averageGSRMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}Your name'])!,
      maxHeartRate: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_heart_rate']),
      averageHeartRate: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}average_heart_rate']),
      averageGSR: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}average_g_s_r']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String name;
  final int? maxHeartRate;
  final int? averageHeartRate;
  final int? averageGSR;
  final DateTime? createdAt;
  const User(
      {required this.id,
      required this.name,
      this.maxHeartRate,
      this.averageHeartRate,
      this.averageGSR,
      this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['Your name'] = Variable<String>(name);
    if (!nullToAbsent || maxHeartRate != null) {
      map['max_heart_rate'] = Variable<int>(maxHeartRate);
    }
    if (!nullToAbsent || averageHeartRate != null) {
      map['average_heart_rate'] = Variable<int>(averageHeartRate);
    }
    if (!nullToAbsent || averageGSR != null) {
      map['average_g_s_r'] = Variable<int>(averageGSR);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      maxHeartRate: maxHeartRate == null && nullToAbsent
          ? const Value.absent()
          : Value(maxHeartRate),
      averageHeartRate: averageHeartRate == null && nullToAbsent
          ? const Value.absent()
          : Value(averageHeartRate),
      averageGSR: averageGSR == null && nullToAbsent
          ? const Value.absent()
          : Value(averageGSR),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      maxHeartRate: serializer.fromJson<int?>(json['maxHeartRate']),
      averageHeartRate: serializer.fromJson<int?>(json['averageHeartRate']),
      averageGSR: serializer.fromJson<int?>(json['averageGSR']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'maxHeartRate': serializer.toJson<int?>(maxHeartRate),
      'averageHeartRate': serializer.toJson<int?>(averageHeartRate),
      'averageGSR': serializer.toJson<int?>(averageGSR),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  User copyWith(
          {int? id,
          String? name,
          Value<int?> maxHeartRate = const Value.absent(),
          Value<int?> averageHeartRate = const Value.absent(),
          Value<int?> averageGSR = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent()}) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        maxHeartRate:
            maxHeartRate.present ? maxHeartRate.value : this.maxHeartRate,
        averageHeartRate: averageHeartRate.present
            ? averageHeartRate.value
            : this.averageHeartRate,
        averageGSR: averageGSR.present ? averageGSR.value : this.averageGSR,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      maxHeartRate: data.maxHeartRate.present
          ? data.maxHeartRate.value
          : this.maxHeartRate,
      averageHeartRate: data.averageHeartRate.present
          ? data.averageHeartRate.value
          : this.averageHeartRate,
      averageGSR:
          data.averageGSR.present ? data.averageGSR.value : this.averageGSR,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('maxHeartRate: $maxHeartRate, ')
          ..write('averageHeartRate: $averageHeartRate, ')
          ..write('averageGSR: $averageGSR, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, maxHeartRate, averageHeartRate, averageGSR, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.maxHeartRate == this.maxHeartRate &&
          other.averageHeartRate == this.averageHeartRate &&
          other.averageGSR == this.averageGSR &&
          other.createdAt == this.createdAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> name;
  final Value<int?> maxHeartRate;
  final Value<int?> averageHeartRate;
  final Value<int?> averageGSR;
  final Value<DateTime?> createdAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.maxHeartRate = const Value.absent(),
    this.averageHeartRate = const Value.absent(),
    this.averageGSR = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.maxHeartRate = const Value.absent(),
    this.averageHeartRate = const Value.absent(),
    this.averageGSR = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? maxHeartRate,
    Expression<int>? averageHeartRate,
    Expression<int>? averageGSR,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'Your name': name,
      if (maxHeartRate != null) 'max_heart_rate': maxHeartRate,
      if (averageHeartRate != null) 'average_heart_rate': averageHeartRate,
      if (averageGSR != null) 'average_g_s_r': averageGSR,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int?>? maxHeartRate,
      Value<int?>? averageHeartRate,
      Value<int?>? averageGSR,
      Value<DateTime?>? createdAt}) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      maxHeartRate: maxHeartRate ?? this.maxHeartRate,
      averageHeartRate: averageHeartRate ?? this.averageHeartRate,
      averageGSR: averageGSR ?? this.averageGSR,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['Your name'] = Variable<String>(name.value);
    }
    if (maxHeartRate.present) {
      map['max_heart_rate'] = Variable<int>(maxHeartRate.value);
    }
    if (averageHeartRate.present) {
      map['average_heart_rate'] = Variable<int>(averageHeartRate.value);
    }
    if (averageGSR.present) {
      map['average_g_s_r'] = Variable<int>(averageGSR.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('maxHeartRate: $maxHeartRate, ')
          ..write('averageHeartRate: $averageHeartRate, ')
          ..write('averageGSR: $averageGSR, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $HeartRateTable extends HeartRate
    with TableInfo<$HeartRateTable, HeartRateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HeartRateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _heartRateMeta =
      const VerificationMeta('heartRate');
  @override
  late final GeneratedColumn<int> heartRate = GeneratedColumn<int>(
      'heart_rate', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, userId, heartRate, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'heart_rate';
  @override
  VerificationContext validateIntegrity(Insertable<HeartRateData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('heart_rate')) {
      context.handle(_heartRateMeta,
          heartRate.isAcceptableOrUnknown(data['heart_rate']!, _heartRateMeta));
    } else if (isInserting) {
      context.missing(_heartRateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HeartRateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HeartRateData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      heartRate: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}heart_rate'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $HeartRateTable createAlias(String alias) {
    return $HeartRateTable(attachedDatabase, alias);
  }
}

class HeartRateData extends DataClass implements Insertable<HeartRateData> {
  final int id;
  final int userId;
  final int heartRate;
  final DateTime? createdAt;
  const HeartRateData(
      {required this.id,
      required this.userId,
      required this.heartRate,
      this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['heart_rate'] = Variable<int>(heartRate);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  HeartRateCompanion toCompanion(bool nullToAbsent) {
    return HeartRateCompanion(
      id: Value(id),
      userId: Value(userId),
      heartRate: Value(heartRate),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory HeartRateData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HeartRateData(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      heartRate: serializer.fromJson<int>(json['heartRate']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'heartRate': serializer.toJson<int>(heartRate),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  HeartRateData copyWith(
          {int? id,
          int? userId,
          int? heartRate,
          Value<DateTime?> createdAt = const Value.absent()}) =>
      HeartRateData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        heartRate: heartRate ?? this.heartRate,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  HeartRateData copyWithCompanion(HeartRateCompanion data) {
    return HeartRateData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      heartRate: data.heartRate.present ? data.heartRate.value : this.heartRate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HeartRateData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('heartRate: $heartRate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, heartRate, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HeartRateData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.heartRate == this.heartRate &&
          other.createdAt == this.createdAt);
}

class HeartRateCompanion extends UpdateCompanion<HeartRateData> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> heartRate;
  final Value<DateTime?> createdAt;
  const HeartRateCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.heartRate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  HeartRateCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required int heartRate,
    this.createdAt = const Value.absent(),
  })  : userId = Value(userId),
        heartRate = Value(heartRate);
  static Insertable<HeartRateData> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? heartRate,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (heartRate != null) 'heart_rate': heartRate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  HeartRateCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<int>? heartRate,
      Value<DateTime?>? createdAt}) {
    return HeartRateCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      heartRate: heartRate ?? this.heartRate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (heartRate.present) {
      map['heart_rate'] = Variable<int>(heartRate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HeartRateCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('heartRate: $heartRate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $GSRTable extends GSR with TableInfo<$GSRTable, GSRData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GSRTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _gsrMeta = const VerificationMeta('gsr');
  @override
  late final GeneratedColumn<int> gsr = GeneratedColumn<int>(
      'gsr', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, userId, gsr, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gsr';
  @override
  VerificationContext validateIntegrity(Insertable<GSRData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('gsr')) {
      context.handle(
          _gsrMeta, gsr.isAcceptableOrUnknown(data['gsr']!, _gsrMeta));
    } else if (isInserting) {
      context.missing(_gsrMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GSRData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GSRData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      gsr: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}gsr'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $GSRTable createAlias(String alias) {
    return $GSRTable(attachedDatabase, alias);
  }
}

class GSRData extends DataClass implements Insertable<GSRData> {
  final int id;
  final int userId;
  final int gsr;
  final DateTime? createdAt;
  const GSRData(
      {required this.id,
      required this.userId,
      required this.gsr,
      this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['gsr'] = Variable<int>(gsr);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  GSRCompanion toCompanion(bool nullToAbsent) {
    return GSRCompanion(
      id: Value(id),
      userId: Value(userId),
      gsr: Value(gsr),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory GSRData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GSRData(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      gsr: serializer.fromJson<int>(json['gsr']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'gsr': serializer.toJson<int>(gsr),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  GSRData copyWith(
          {int? id,
          int? userId,
          int? gsr,
          Value<DateTime?> createdAt = const Value.absent()}) =>
      GSRData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        gsr: gsr ?? this.gsr,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  GSRData copyWithCompanion(GSRCompanion data) {
    return GSRData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      gsr: data.gsr.present ? data.gsr.value : this.gsr,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GSRData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('gsr: $gsr, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, gsr, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GSRData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.gsr == this.gsr &&
          other.createdAt == this.createdAt);
}

class GSRCompanion extends UpdateCompanion<GSRData> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> gsr;
  final Value<DateTime?> createdAt;
  const GSRCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.gsr = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  GSRCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required int gsr,
    this.createdAt = const Value.absent(),
  })  : userId = Value(userId),
        gsr = Value(gsr);
  static Insertable<GSRData> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? gsr,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (gsr != null) 'gsr': gsr,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  GSRCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<int>? gsr,
      Value<DateTime?>? createdAt}) {
    return GSRCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      gsr: gsr ?? this.gsr,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (gsr.present) {
      map['gsr'] = Variable<int>(gsr.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GSRCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('gsr: $gsr, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SPO2Table extends SPO2 with TableInfo<$SPO2Table, SPO2Data> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SPO2Table(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _spo2Meta = const VerificationMeta('spo2');
  @override
  late final GeneratedColumn<int> spo2 = GeneratedColumn<int>(
      'spo2', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, userId, spo2, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'spo2';
  @override
  VerificationContext validateIntegrity(Insertable<SPO2Data> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('spo2')) {
      context.handle(
          _spo2Meta, spo2.isAcceptableOrUnknown(data['spo2']!, _spo2Meta));
    } else if (isInserting) {
      context.missing(_spo2Meta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SPO2Data map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SPO2Data(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      spo2: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}spo2'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $SPO2Table createAlias(String alias) {
    return $SPO2Table(attachedDatabase, alias);
  }
}

class SPO2Data extends DataClass implements Insertable<SPO2Data> {
  final int id;
  final int userId;
  final int spo2;
  final DateTime? createdAt;
  const SPO2Data(
      {required this.id,
      required this.userId,
      required this.spo2,
      this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['spo2'] = Variable<int>(spo2);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  SPO2Companion toCompanion(bool nullToAbsent) {
    return SPO2Companion(
      id: Value(id),
      userId: Value(userId),
      spo2: Value(spo2),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory SPO2Data.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SPO2Data(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      spo2: serializer.fromJson<int>(json['spo2']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'spo2': serializer.toJson<int>(spo2),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  SPO2Data copyWith(
          {int? id,
          int? userId,
          int? spo2,
          Value<DateTime?> createdAt = const Value.absent()}) =>
      SPO2Data(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        spo2: spo2 ?? this.spo2,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  SPO2Data copyWithCompanion(SPO2Companion data) {
    return SPO2Data(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      spo2: data.spo2.present ? data.spo2.value : this.spo2,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SPO2Data(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('spo2: $spo2, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, spo2, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SPO2Data &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.spo2 == this.spo2 &&
          other.createdAt == this.createdAt);
}

class SPO2Companion extends UpdateCompanion<SPO2Data> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> spo2;
  final Value<DateTime?> createdAt;
  const SPO2Companion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.spo2 = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SPO2Companion.insert({
    this.id = const Value.absent(),
    required int userId,
    required int spo2,
    this.createdAt = const Value.absent(),
  })  : userId = Value(userId),
        spo2 = Value(spo2);
  static Insertable<SPO2Data> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? spo2,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (spo2 != null) 'spo2': spo2,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SPO2Companion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<int>? spo2,
      Value<DateTime?>? createdAt}) {
    return SPO2Companion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      spo2: spo2 ?? this.spo2,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (spo2.present) {
      map['spo2'] = Variable<int>(spo2.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SPO2Companion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('spo2: $spo2, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $StressLevelTable extends StressLevel
    with TableInfo<$StressLevelTable, StressLevelData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StressLevelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _stressLevelMeta =
      const VerificationMeta('stressLevel');
  @override
  late final GeneratedColumn<int> stressLevel = GeneratedColumn<int>(
      'stress_level', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, userId, stressLevel, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stress_level';
  @override
  VerificationContext validateIntegrity(Insertable<StressLevelData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('stress_level')) {
      context.handle(
          _stressLevelMeta,
          stressLevel.isAcceptableOrUnknown(
              data['stress_level']!, _stressLevelMeta));
    } else if (isInserting) {
      context.missing(_stressLevelMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StressLevelData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StressLevelData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      stressLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stress_level'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $StressLevelTable createAlias(String alias) {
    return $StressLevelTable(attachedDatabase, alias);
  }
}

class StressLevelData extends DataClass implements Insertable<StressLevelData> {
  final int id;
  final int userId;
  final int stressLevel;
  final DateTime? createdAt;
  const StressLevelData(
      {required this.id,
      required this.userId,
      required this.stressLevel,
      this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['stress_level'] = Variable<int>(stressLevel);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  StressLevelCompanion toCompanion(bool nullToAbsent) {
    return StressLevelCompanion(
      id: Value(id),
      userId: Value(userId),
      stressLevel: Value(stressLevel),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory StressLevelData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StressLevelData(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      stressLevel: serializer.fromJson<int>(json['stressLevel']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'stressLevel': serializer.toJson<int>(stressLevel),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  StressLevelData copyWith(
          {int? id,
          int? userId,
          int? stressLevel,
          Value<DateTime?> createdAt = const Value.absent()}) =>
      StressLevelData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        stressLevel: stressLevel ?? this.stressLevel,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  StressLevelData copyWithCompanion(StressLevelCompanion data) {
    return StressLevelData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      stressLevel:
          data.stressLevel.present ? data.stressLevel.value : this.stressLevel,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StressLevelData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('stressLevel: $stressLevel, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, stressLevel, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StressLevelData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.stressLevel == this.stressLevel &&
          other.createdAt == this.createdAt);
}

class StressLevelCompanion extends UpdateCompanion<StressLevelData> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> stressLevel;
  final Value<DateTime?> createdAt;
  const StressLevelCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.stressLevel = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  StressLevelCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required int stressLevel,
    this.createdAt = const Value.absent(),
  })  : userId = Value(userId),
        stressLevel = Value(stressLevel);
  static Insertable<StressLevelData> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? stressLevel,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (stressLevel != null) 'stress_level': stressLevel,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  StressLevelCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<int>? stressLevel,
      Value<DateTime?>? createdAt}) {
    return StressLevelCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      stressLevel: stressLevel ?? this.stressLevel,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (stressLevel.present) {
      map['stress_level'] = Variable<int>(stressLevel.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StressLevelCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('stressLevel: $stressLevel, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $RespiratoryRateTable extends RespiratoryRate
    with TableInfo<$RespiratoryRateTable, RespiratoryRateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RespiratoryRateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _respiratoryRateMeta =
      const VerificationMeta('respiratoryRate');
  @override
  late final GeneratedColumn<int> respiratoryRate = GeneratedColumn<int>(
      'respiratory_rate', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, respiratoryRate, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'respiratory_rate';
  @override
  VerificationContext validateIntegrity(
      Insertable<RespiratoryRateData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('respiratory_rate')) {
      context.handle(
          _respiratoryRateMeta,
          respiratoryRate.isAcceptableOrUnknown(
              data['respiratory_rate']!, _respiratoryRateMeta));
    } else if (isInserting) {
      context.missing(_respiratoryRateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RespiratoryRateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RespiratoryRateData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      respiratoryRate: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}respiratory_rate'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $RespiratoryRateTable createAlias(String alias) {
    return $RespiratoryRateTable(attachedDatabase, alias);
  }
}

class RespiratoryRateData extends DataClass
    implements Insertable<RespiratoryRateData> {
  final int id;
  final int userId;
  final int respiratoryRate;
  final DateTime? createdAt;
  const RespiratoryRateData(
      {required this.id,
      required this.userId,
      required this.respiratoryRate,
      this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['respiratory_rate'] = Variable<int>(respiratoryRate);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  RespiratoryRateCompanion toCompanion(bool nullToAbsent) {
    return RespiratoryRateCompanion(
      id: Value(id),
      userId: Value(userId),
      respiratoryRate: Value(respiratoryRate),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory RespiratoryRateData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RespiratoryRateData(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      respiratoryRate: serializer.fromJson<int>(json['respiratoryRate']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'respiratoryRate': serializer.toJson<int>(respiratoryRate),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  RespiratoryRateData copyWith(
          {int? id,
          int? userId,
          int? respiratoryRate,
          Value<DateTime?> createdAt = const Value.absent()}) =>
      RespiratoryRateData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        respiratoryRate: respiratoryRate ?? this.respiratoryRate,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  RespiratoryRateData copyWithCompanion(RespiratoryRateCompanion data) {
    return RespiratoryRateData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      respiratoryRate: data.respiratoryRate.present
          ? data.respiratoryRate.value
          : this.respiratoryRate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RespiratoryRateData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('respiratoryRate: $respiratoryRate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, respiratoryRate, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RespiratoryRateData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.respiratoryRate == this.respiratoryRate &&
          other.createdAt == this.createdAt);
}

class RespiratoryRateCompanion extends UpdateCompanion<RespiratoryRateData> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> respiratoryRate;
  final Value<DateTime?> createdAt;
  const RespiratoryRateCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.respiratoryRate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RespiratoryRateCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required int respiratoryRate,
    this.createdAt = const Value.absent(),
  })  : userId = Value(userId),
        respiratoryRate = Value(respiratoryRate);
  static Insertable<RespiratoryRateData> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? respiratoryRate,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (respiratoryRate != null) 'respiratory_rate': respiratoryRate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RespiratoryRateCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<int>? respiratoryRate,
      Value<DateTime?>? createdAt}) {
    return RespiratoryRateCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      respiratoryRate: respiratoryRate ?? this.respiratoryRate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (respiratoryRate.present) {
      map['respiratory_rate'] = Variable<int>(respiratoryRate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RespiratoryRateCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('respiratoryRate: $respiratoryRate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $HeartRateTable heartRate = $HeartRateTable(this);
  late final $GSRTable gsr = $GSRTable(this);
  late final $SPO2Table spo2 = $SPO2Table(this);
  late final $StressLevelTable stressLevel = $StressLevelTable(this);
  late final $RespiratoryRateTable respiratoryRate =
      $RespiratoryRateTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [users, heartRate, gsr, spo2, stressLevel, respiratoryRate];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  required String name,
  Value<int?> maxHeartRate,
  Value<int?> averageHeartRate,
  Value<int?> averageGSR,
  Value<DateTime?> createdAt,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int?> maxHeartRate,
  Value<int?> averageHeartRate,
  Value<int?> averageGSR,
  Value<DateTime?> createdAt,
});

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$HeartRateTable, List<HeartRateData>>
      _heartRateRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.heartRate,
          aliasName: $_aliasNameGenerator(db.users.id, db.heartRate.userId));

  $$HeartRateTableProcessedTableManager get heartRateRefs {
    final manager = $$HeartRateTableTableManager($_db, $_db.heartRate)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_heartRateRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$GSRTable, List<GSRData>> _gsrRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.gsr,
          aliasName: $_aliasNameGenerator(db.users.id, db.gsr.userId));

  $$GSRTableProcessedTableManager get gsrRefs {
    final manager = $$GSRTableTableManager($_db, $_db.gsr)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_gsrRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SPO2Table, List<SPO2Data>> _spo2RefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.spo2,
          aliasName: $_aliasNameGenerator(db.users.id, db.spo2.userId));

  $$SPO2TableProcessedTableManager get spo2Refs {
    final manager = $$SPO2TableTableManager($_db, $_db.spo2)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_spo2RefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$StressLevelTable, List<StressLevelData>>
      _stressLevelRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.stressLevel,
          aliasName: $_aliasNameGenerator(db.users.id, db.stressLevel.userId));

  $$StressLevelTableProcessedTableManager get stressLevelRefs {
    final manager = $$StressLevelTableTableManager($_db, $_db.stressLevel)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_stressLevelRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$RespiratoryRateTable, List<RespiratoryRateData>>
      _respiratoryRateRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.respiratoryRate,
              aliasName:
                  $_aliasNameGenerator(db.users.id, db.respiratoryRate.userId));

  $$RespiratoryRateTableProcessedTableManager get respiratoryRateRefs {
    final manager =
        $$RespiratoryRateTableTableManager($_db, $_db.respiratoryRate)
            .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_respiratoryRateRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxHeartRate => $composableBuilder(
      column: $table.maxHeartRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get averageHeartRate => $composableBuilder(
      column: $table.averageHeartRate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get averageGSR => $composableBuilder(
      column: $table.averageGSR, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> heartRateRefs(
      Expression<bool> Function($$HeartRateTableFilterComposer f) f) {
    final $$HeartRateTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.heartRate,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HeartRateTableFilterComposer(
              $db: $db,
              $table: $db.heartRate,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> gsrRefs(
      Expression<bool> Function($$GSRTableFilterComposer f) f) {
    final $$GSRTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.gsr,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GSRTableFilterComposer(
              $db: $db,
              $table: $db.gsr,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> spo2Refs(
      Expression<bool> Function($$SPO2TableFilterComposer f) f) {
    final $$SPO2TableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.spo2,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SPO2TableFilterComposer(
              $db: $db,
              $table: $db.spo2,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> stressLevelRefs(
      Expression<bool> Function($$StressLevelTableFilterComposer f) f) {
    final $$StressLevelTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.stressLevel,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StressLevelTableFilterComposer(
              $db: $db,
              $table: $db.stressLevel,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> respiratoryRateRefs(
      Expression<bool> Function($$RespiratoryRateTableFilterComposer f) f) {
    final $$RespiratoryRateTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.respiratoryRate,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RespiratoryRateTableFilterComposer(
              $db: $db,
              $table: $db.respiratoryRate,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxHeartRate => $composableBuilder(
      column: $table.maxHeartRate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get averageHeartRate => $composableBuilder(
      column: $table.averageHeartRate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get averageGSR => $composableBuilder(
      column: $table.averageGSR, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get maxHeartRate => $composableBuilder(
      column: $table.maxHeartRate, builder: (column) => column);

  GeneratedColumn<int> get averageHeartRate => $composableBuilder(
      column: $table.averageHeartRate, builder: (column) => column);

  GeneratedColumn<int> get averageGSR => $composableBuilder(
      column: $table.averageGSR, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> heartRateRefs<T extends Object>(
      Expression<T> Function($$HeartRateTableAnnotationComposer a) f) {
    final $$HeartRateTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.heartRate,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HeartRateTableAnnotationComposer(
              $db: $db,
              $table: $db.heartRate,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> gsrRefs<T extends Object>(
      Expression<T> Function($$GSRTableAnnotationComposer a) f) {
    final $$GSRTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.gsr,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GSRTableAnnotationComposer(
              $db: $db,
              $table: $db.gsr,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> spo2Refs<T extends Object>(
      Expression<T> Function($$SPO2TableAnnotationComposer a) f) {
    final $$SPO2TableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.spo2,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SPO2TableAnnotationComposer(
              $db: $db,
              $table: $db.spo2,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> stressLevelRefs<T extends Object>(
      Expression<T> Function($$StressLevelTableAnnotationComposer a) f) {
    final $$StressLevelTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.stressLevel,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StressLevelTableAnnotationComposer(
              $db: $db,
              $table: $db.stressLevel,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> respiratoryRateRefs<T extends Object>(
      Expression<T> Function($$RespiratoryRateTableAnnotationComposer a) f) {
    final $$RespiratoryRateTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.respiratoryRate,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RespiratoryRateTableAnnotationComposer(
              $db: $db,
              $table: $db.respiratoryRate,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function(
        {bool heartRateRefs,
        bool gsrRefs,
        bool spo2Refs,
        bool stressLevelRefs,
        bool respiratoryRateRefs})> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int?> maxHeartRate = const Value.absent(),
            Value<int?> averageHeartRate = const Value.absent(),
            Value<int?> averageGSR = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            name: name,
            maxHeartRate: maxHeartRate,
            averageHeartRate: averageHeartRate,
            averageGSR: averageGSR,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<int?> maxHeartRate = const Value.absent(),
            Value<int?> averageHeartRate = const Value.absent(),
            Value<int?> averageGSR = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            name: name,
            maxHeartRate: maxHeartRate,
            averageHeartRate: averageHeartRate,
            averageGSR: averageGSR,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$UsersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {heartRateRefs = false,
              gsrRefs = false,
              spo2Refs = false,
              stressLevelRefs = false,
              respiratoryRateRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (heartRateRefs) db.heartRate,
                if (gsrRefs) db.gsr,
                if (spo2Refs) db.spo2,
                if (stressLevelRefs) db.stressLevel,
                if (respiratoryRateRefs) db.respiratoryRate
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (heartRateRefs)
                    await $_getPrefetchedData<User, $UsersTable, HeartRateData>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._heartRateRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0).heartRateRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (gsrRefs)
                    await $_getPrefetchedData<User, $UsersTable, GSRData>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._gsrRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0).gsrRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (spo2Refs)
                    await $_getPrefetchedData<User, $UsersTable, SPO2Data>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._spo2RefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0).spo2Refs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (stressLevelRefs)
                    await $_getPrefetchedData<User, $UsersTable,
                            StressLevelData>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._stressLevelRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .stressLevelRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (respiratoryRateRefs)
                    await $_getPrefetchedData<User, $UsersTable,
                            RespiratoryRateData>(
                        currentTable: table,
                        referencedTable: $$UsersTableReferences
                            ._respiratoryRateRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .respiratoryRateRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function(
        {bool heartRateRefs,
        bool gsrRefs,
        bool spo2Refs,
        bool stressLevelRefs,
        bool respiratoryRateRefs})>;
typedef $$HeartRateTableCreateCompanionBuilder = HeartRateCompanion Function({
  Value<int> id,
  required int userId,
  required int heartRate,
  Value<DateTime?> createdAt,
});
typedef $$HeartRateTableUpdateCompanionBuilder = HeartRateCompanion Function({
  Value<int> id,
  Value<int> userId,
  Value<int> heartRate,
  Value<DateTime?> createdAt,
});

final class $$HeartRateTableReferences
    extends BaseReferences<_$AppDatabase, $HeartRateTable, HeartRateData> {
  $$HeartRateTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.heartRate.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$HeartRateTableFilterComposer
    extends Composer<_$AppDatabase, $HeartRateTable> {
  $$HeartRateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get heartRate => $composableBuilder(
      column: $table.heartRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HeartRateTableOrderingComposer
    extends Composer<_$AppDatabase, $HeartRateTable> {
  $$HeartRateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get heartRate => $composableBuilder(
      column: $table.heartRate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HeartRateTableAnnotationComposer
    extends Composer<_$AppDatabase, $HeartRateTable> {
  $$HeartRateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get heartRate =>
      $composableBuilder(column: $table.heartRate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HeartRateTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HeartRateTable,
    HeartRateData,
    $$HeartRateTableFilterComposer,
    $$HeartRateTableOrderingComposer,
    $$HeartRateTableAnnotationComposer,
    $$HeartRateTableCreateCompanionBuilder,
    $$HeartRateTableUpdateCompanionBuilder,
    (HeartRateData, $$HeartRateTableReferences),
    HeartRateData,
    PrefetchHooks Function({bool userId})> {
  $$HeartRateTableTableManager(_$AppDatabase db, $HeartRateTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HeartRateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HeartRateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HeartRateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<int> heartRate = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              HeartRateCompanion(
            id: id,
            userId: userId,
            heartRate: heartRate,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            required int heartRate,
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              HeartRateCompanion.insert(
            id: id,
            userId: userId,
            heartRate: heartRate,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$HeartRateTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$HeartRateTableReferences._userIdTable(db),
                    referencedColumn:
                        $$HeartRateTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$HeartRateTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HeartRateTable,
    HeartRateData,
    $$HeartRateTableFilterComposer,
    $$HeartRateTableOrderingComposer,
    $$HeartRateTableAnnotationComposer,
    $$HeartRateTableCreateCompanionBuilder,
    $$HeartRateTableUpdateCompanionBuilder,
    (HeartRateData, $$HeartRateTableReferences),
    HeartRateData,
    PrefetchHooks Function({bool userId})>;
typedef $$GSRTableCreateCompanionBuilder = GSRCompanion Function({
  Value<int> id,
  required int userId,
  required int gsr,
  Value<DateTime?> createdAt,
});
typedef $$GSRTableUpdateCompanionBuilder = GSRCompanion Function({
  Value<int> id,
  Value<int> userId,
  Value<int> gsr,
  Value<DateTime?> createdAt,
});

final class $$GSRTableReferences
    extends BaseReferences<_$AppDatabase, $GSRTable, GSRData> {
  $$GSRTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias($_aliasNameGenerator(db.gsr.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$GSRTableFilterComposer extends Composer<_$AppDatabase, $GSRTable> {
  $$GSRTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get gsr => $composableBuilder(
      column: $table.gsr, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GSRTableOrderingComposer extends Composer<_$AppDatabase, $GSRTable> {
  $$GSRTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get gsr => $composableBuilder(
      column: $table.gsr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GSRTableAnnotationComposer extends Composer<_$AppDatabase, $GSRTable> {
  $$GSRTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get gsr =>
      $composableBuilder(column: $table.gsr, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GSRTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GSRTable,
    GSRData,
    $$GSRTableFilterComposer,
    $$GSRTableOrderingComposer,
    $$GSRTableAnnotationComposer,
    $$GSRTableCreateCompanionBuilder,
    $$GSRTableUpdateCompanionBuilder,
    (GSRData, $$GSRTableReferences),
    GSRData,
    PrefetchHooks Function({bool userId})> {
  $$GSRTableTableManager(_$AppDatabase db, $GSRTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GSRTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GSRTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GSRTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<int> gsr = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              GSRCompanion(
            id: id,
            userId: userId,
            gsr: gsr,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            required int gsr,
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              GSRCompanion.insert(
            id: id,
            userId: userId,
            gsr: gsr,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$GSRTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable: $$GSRTableReferences._userIdTable(db),
                    referencedColumn: $$GSRTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$GSRTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GSRTable,
    GSRData,
    $$GSRTableFilterComposer,
    $$GSRTableOrderingComposer,
    $$GSRTableAnnotationComposer,
    $$GSRTableCreateCompanionBuilder,
    $$GSRTableUpdateCompanionBuilder,
    (GSRData, $$GSRTableReferences),
    GSRData,
    PrefetchHooks Function({bool userId})>;
typedef $$SPO2TableCreateCompanionBuilder = SPO2Companion Function({
  Value<int> id,
  required int userId,
  required int spo2,
  Value<DateTime?> createdAt,
});
typedef $$SPO2TableUpdateCompanionBuilder = SPO2Companion Function({
  Value<int> id,
  Value<int> userId,
  Value<int> spo2,
  Value<DateTime?> createdAt,
});

final class $$SPO2TableReferences
    extends BaseReferences<_$AppDatabase, $SPO2Table, SPO2Data> {
  $$SPO2TableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias($_aliasNameGenerator(db.spo2.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SPO2TableFilterComposer extends Composer<_$AppDatabase, $SPO2Table> {
  $$SPO2TableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get spo2 => $composableBuilder(
      column: $table.spo2, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SPO2TableOrderingComposer extends Composer<_$AppDatabase, $SPO2Table> {
  $$SPO2TableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get spo2 => $composableBuilder(
      column: $table.spo2, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SPO2TableAnnotationComposer
    extends Composer<_$AppDatabase, $SPO2Table> {
  $$SPO2TableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get spo2 =>
      $composableBuilder(column: $table.spo2, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SPO2TableTableManager extends RootTableManager<
    _$AppDatabase,
    $SPO2Table,
    SPO2Data,
    $$SPO2TableFilterComposer,
    $$SPO2TableOrderingComposer,
    $$SPO2TableAnnotationComposer,
    $$SPO2TableCreateCompanionBuilder,
    $$SPO2TableUpdateCompanionBuilder,
    (SPO2Data, $$SPO2TableReferences),
    SPO2Data,
    PrefetchHooks Function({bool userId})> {
  $$SPO2TableTableManager(_$AppDatabase db, $SPO2Table table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SPO2TableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SPO2TableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SPO2TableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<int> spo2 = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              SPO2Companion(
            id: id,
            userId: userId,
            spo2: spo2,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            required int spo2,
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              SPO2Companion.insert(
            id: id,
            userId: userId,
            spo2: spo2,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$SPO2TableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable: $$SPO2TableReferences._userIdTable(db),
                    referencedColumn: $$SPO2TableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SPO2TableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SPO2Table,
    SPO2Data,
    $$SPO2TableFilterComposer,
    $$SPO2TableOrderingComposer,
    $$SPO2TableAnnotationComposer,
    $$SPO2TableCreateCompanionBuilder,
    $$SPO2TableUpdateCompanionBuilder,
    (SPO2Data, $$SPO2TableReferences),
    SPO2Data,
    PrefetchHooks Function({bool userId})>;
typedef $$StressLevelTableCreateCompanionBuilder = StressLevelCompanion
    Function({
  Value<int> id,
  required int userId,
  required int stressLevel,
  Value<DateTime?> createdAt,
});
typedef $$StressLevelTableUpdateCompanionBuilder = StressLevelCompanion
    Function({
  Value<int> id,
  Value<int> userId,
  Value<int> stressLevel,
  Value<DateTime?> createdAt,
});

final class $$StressLevelTableReferences
    extends BaseReferences<_$AppDatabase, $StressLevelTable, StressLevelData> {
  $$StressLevelTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.stressLevel.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$StressLevelTableFilterComposer
    extends Composer<_$AppDatabase, $StressLevelTable> {
  $$StressLevelTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stressLevel => $composableBuilder(
      column: $table.stressLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StressLevelTableOrderingComposer
    extends Composer<_$AppDatabase, $StressLevelTable> {
  $$StressLevelTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stressLevel => $composableBuilder(
      column: $table.stressLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StressLevelTableAnnotationComposer
    extends Composer<_$AppDatabase, $StressLevelTable> {
  $$StressLevelTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get stressLevel => $composableBuilder(
      column: $table.stressLevel, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StressLevelTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StressLevelTable,
    StressLevelData,
    $$StressLevelTableFilterComposer,
    $$StressLevelTableOrderingComposer,
    $$StressLevelTableAnnotationComposer,
    $$StressLevelTableCreateCompanionBuilder,
    $$StressLevelTableUpdateCompanionBuilder,
    (StressLevelData, $$StressLevelTableReferences),
    StressLevelData,
    PrefetchHooks Function({bool userId})> {
  $$StressLevelTableTableManager(_$AppDatabase db, $StressLevelTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StressLevelTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StressLevelTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StressLevelTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<int> stressLevel = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              StressLevelCompanion(
            id: id,
            userId: userId,
            stressLevel: stressLevel,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            required int stressLevel,
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              StressLevelCompanion.insert(
            id: id,
            userId: userId,
            stressLevel: stressLevel,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$StressLevelTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$StressLevelTableReferences._userIdTable(db),
                    referencedColumn:
                        $$StressLevelTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$StressLevelTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StressLevelTable,
    StressLevelData,
    $$StressLevelTableFilterComposer,
    $$StressLevelTableOrderingComposer,
    $$StressLevelTableAnnotationComposer,
    $$StressLevelTableCreateCompanionBuilder,
    $$StressLevelTableUpdateCompanionBuilder,
    (StressLevelData, $$StressLevelTableReferences),
    StressLevelData,
    PrefetchHooks Function({bool userId})>;
typedef $$RespiratoryRateTableCreateCompanionBuilder = RespiratoryRateCompanion
    Function({
  Value<int> id,
  required int userId,
  required int respiratoryRate,
  Value<DateTime?> createdAt,
});
typedef $$RespiratoryRateTableUpdateCompanionBuilder = RespiratoryRateCompanion
    Function({
  Value<int> id,
  Value<int> userId,
  Value<int> respiratoryRate,
  Value<DateTime?> createdAt,
});

final class $$RespiratoryRateTableReferences extends BaseReferences<
    _$AppDatabase, $RespiratoryRateTable, RespiratoryRateData> {
  $$RespiratoryRateTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
      $_aliasNameGenerator(db.respiratoryRate.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RespiratoryRateTableFilterComposer
    extends Composer<_$AppDatabase, $RespiratoryRateTable> {
  $$RespiratoryRateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get respiratoryRate => $composableBuilder(
      column: $table.respiratoryRate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RespiratoryRateTableOrderingComposer
    extends Composer<_$AppDatabase, $RespiratoryRateTable> {
  $$RespiratoryRateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get respiratoryRate => $composableBuilder(
      column: $table.respiratoryRate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RespiratoryRateTableAnnotationComposer
    extends Composer<_$AppDatabase, $RespiratoryRateTable> {
  $$RespiratoryRateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get respiratoryRate => $composableBuilder(
      column: $table.respiratoryRate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RespiratoryRateTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RespiratoryRateTable,
    RespiratoryRateData,
    $$RespiratoryRateTableFilterComposer,
    $$RespiratoryRateTableOrderingComposer,
    $$RespiratoryRateTableAnnotationComposer,
    $$RespiratoryRateTableCreateCompanionBuilder,
    $$RespiratoryRateTableUpdateCompanionBuilder,
    (RespiratoryRateData, $$RespiratoryRateTableReferences),
    RespiratoryRateData,
    PrefetchHooks Function({bool userId})> {
  $$RespiratoryRateTableTableManager(
      _$AppDatabase db, $RespiratoryRateTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RespiratoryRateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RespiratoryRateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RespiratoryRateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<int> respiratoryRate = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              RespiratoryRateCompanion(
            id: id,
            userId: userId,
            respiratoryRate: respiratoryRate,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            required int respiratoryRate,
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              RespiratoryRateCompanion.insert(
            id: id,
            userId: userId,
            respiratoryRate: respiratoryRate,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RespiratoryRateTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$RespiratoryRateTableReferences._userIdTable(db),
                    referencedColumn:
                        $$RespiratoryRateTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RespiratoryRateTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RespiratoryRateTable,
    RespiratoryRateData,
    $$RespiratoryRateTableFilterComposer,
    $$RespiratoryRateTableOrderingComposer,
    $$RespiratoryRateTableAnnotationComposer,
    $$RespiratoryRateTableCreateCompanionBuilder,
    $$RespiratoryRateTableUpdateCompanionBuilder,
    (RespiratoryRateData, $$RespiratoryRateTableReferences),
    RespiratoryRateData,
    PrefetchHooks Function({bool userId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$HeartRateTableTableManager get heartRate =>
      $$HeartRateTableTableManager(_db, _db.heartRate);
  $$GSRTableTableManager get gsr => $$GSRTableTableManager(_db, _db.gsr);
  $$SPO2TableTableManager get spo2 => $$SPO2TableTableManager(_db, _db.spo2);
  $$StressLevelTableTableManager get stressLevel =>
      $$StressLevelTableTableManager(_db, _db.stressLevel);
  $$RespiratoryRateTableTableManager get respiratoryRate =>
      $$RespiratoryRateTableTableManager(_db, _db.respiratoryRate);
}
