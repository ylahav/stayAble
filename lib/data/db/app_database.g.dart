// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoMeta = const VerificationMeta('photo');
  @override
  late final GeneratedColumn<String> photo = GeneratedColumn<String>(
    'photo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<FitnessLevel, String>
  fitnessLevel = GeneratedColumn<String>(
    'fitness_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<FitnessLevel>($UsersTable.$converterfitnessLevel);
  @override
  late final GeneratedColumnWithTypeConverter<List<FitnessGoal>, String> goals =
      GeneratedColumn<String>(
        'goals',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<FitnessGoal>>($UsersTable.$convertergoals);
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ExerciseVenue, String>
  trainingVenue = GeneratedColumn<String>(
    'training_venue',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('both'),
  ).withConverter<ExerciseVenue>($UsersTable.$convertertrainingVenue);
  @override
  late final GeneratedColumnWithTypeConverter<PreferredUnits, String>
  preferredUnits = GeneratedColumn<String>(
    'preferred_units',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('kg'),
  ).withConverter<PreferredUnits>($UsersTable.$converterpreferredUnits);
  static const VerificationMeta _defaultRestSecondsMeta =
      const VerificationMeta('defaultRestSeconds');
  @override
  late final GeneratedColumn<int> defaultRestSeconds = GeneratedColumn<int>(
    'default_rest_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    name,
    email,
    photo,
    birthDate,
    gender,
    fitnessLevel,
    goals,
    language,
    trainingVenue,
    preferredUnits,
    defaultRestSeconds,
    active,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('photo')) {
      context.handle(
        _photoMeta,
        photo.isAcceptableOrUnknown(data['photo']!, _photoMeta),
      );
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('default_rest_seconds')) {
      context.handle(
        _defaultRestSecondsMeta,
        defaultRestSeconds.isAcceptableOrUnknown(
          data['default_rest_seconds']!,
          _defaultRestSecondsMeta,
        ),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
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
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      photo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo'],
      ),
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      ),
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      fitnessLevel: $UsersTable.$converterfitnessLevel.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}fitness_level'],
        )!,
      ),
      goals: $UsersTable.$convertergoals.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}goals'],
        )!,
      ),
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      trainingVenue: $UsersTable.$convertertrainingVenue.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}training_venue'],
        )!,
      ),
      preferredUnits: $UsersTable.$converterpreferredUnits.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}preferred_units'],
        )!,
      ),
      defaultRestSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_rest_seconds'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
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
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<FitnessLevel, String, String>
  $converterfitnessLevel = const EnumNameConverter<FitnessLevel>(
    FitnessLevel.values,
  );
  static TypeConverter<List<FitnessGoal>, String> $convertergoals =
      const GoalListConverter();
  static JsonTypeConverter2<ExerciseVenue, String, String>
  $convertertrainingVenue = const EnumNameConverter<ExerciseVenue>(
    ExerciseVenue.values,
  );
  static JsonTypeConverter2<PreferredUnits, String, String>
  $converterpreferredUnits = const EnumNameConverter<PreferredUnits>(
    PreferredUnits.values,
  );
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String name;
  final String? email;
  final String? photo;
  final DateTime? birthDate;
  final String? gender;
  final FitnessLevel fitnessLevel;
  final List<FitnessGoal> goals;
  final String language;
  final ExerciseVenue trainingVenue;
  final PreferredUnits preferredUnits;
  final int? defaultRestSeconds;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;
  const User({
    required this.id,
    required this.name,
    this.email,
    this.photo,
    this.birthDate,
    this.gender,
    required this.fitnessLevel,
    required this.goals,
    required this.language,
    required this.trainingVenue,
    required this.preferredUnits,
    this.defaultRestSeconds,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || photo != null) {
      map['photo'] = Variable<String>(photo);
    }
    if (!nullToAbsent || birthDate != null) {
      map['birth_date'] = Variable<DateTime>(birthDate);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    {
      map['fitness_level'] = Variable<String>(
        $UsersTable.$converterfitnessLevel.toSql(fitnessLevel),
      );
    }
    {
      map['goals'] = Variable<String>($UsersTable.$convertergoals.toSql(goals));
    }
    map['language'] = Variable<String>(language);
    {
      map['training_venue'] = Variable<String>(
        $UsersTable.$convertertrainingVenue.toSql(trainingVenue),
      );
    }
    {
      map['preferred_units'] = Variable<String>(
        $UsersTable.$converterpreferredUnits.toSql(preferredUnits),
      );
    }
    if (!nullToAbsent || defaultRestSeconds != null) {
      map['default_rest_seconds'] = Variable<int>(defaultRestSeconds);
    }
    map['active'] = Variable<bool>(active);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      photo: photo == null && nullToAbsent
          ? const Value.absent()
          : Value(photo),
      birthDate: birthDate == null && nullToAbsent
          ? const Value.absent()
          : Value(birthDate),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      fitnessLevel: Value(fitnessLevel),
      goals: Value(goals),
      language: Value(language),
      trainingVenue: Value(trainingVenue),
      preferredUnits: Value(preferredUnits),
      defaultRestSeconds: defaultRestSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultRestSeconds),
      active: Value(active),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String?>(json['email']),
      photo: serializer.fromJson<String?>(json['photo']),
      birthDate: serializer.fromJson<DateTime?>(json['birthDate']),
      gender: serializer.fromJson<String?>(json['gender']),
      fitnessLevel: $UsersTable.$converterfitnessLevel.fromJson(
        serializer.fromJson<String>(json['fitnessLevel']),
      ),
      goals: serializer.fromJson<List<FitnessGoal>>(json['goals']),
      language: serializer.fromJson<String>(json['language']),
      trainingVenue: $UsersTable.$convertertrainingVenue.fromJson(
        serializer.fromJson<String>(json['trainingVenue']),
      ),
      preferredUnits: $UsersTable.$converterpreferredUnits.fromJson(
        serializer.fromJson<String>(json['preferredUnits']),
      ),
      defaultRestSeconds: serializer.fromJson<int?>(json['defaultRestSeconds']),
      active: serializer.fromJson<bool>(json['active']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String?>(email),
      'photo': serializer.toJson<String?>(photo),
      'birthDate': serializer.toJson<DateTime?>(birthDate),
      'gender': serializer.toJson<String?>(gender),
      'fitnessLevel': serializer.toJson<String>(
        $UsersTable.$converterfitnessLevel.toJson(fitnessLevel),
      ),
      'goals': serializer.toJson<List<FitnessGoal>>(goals),
      'language': serializer.toJson<String>(language),
      'trainingVenue': serializer.toJson<String>(
        $UsersTable.$convertertrainingVenue.toJson(trainingVenue),
      ),
      'preferredUnits': serializer.toJson<String>(
        $UsersTable.$converterpreferredUnits.toJson(preferredUnits),
      ),
      'defaultRestSeconds': serializer.toJson<int?>(defaultRestSeconds),
      'active': serializer.toJson<bool>(active),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  User copyWith({
    String? id,
    String? name,
    Value<String?> email = const Value.absent(),
    Value<String?> photo = const Value.absent(),
    Value<DateTime?> birthDate = const Value.absent(),
    Value<String?> gender = const Value.absent(),
    FitnessLevel? fitnessLevel,
    List<FitnessGoal>? goals,
    String? language,
    ExerciseVenue? trainingVenue,
    PreferredUnits? preferredUnits,
    Value<int?> defaultRestSeconds = const Value.absent(),
    bool? active,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => User(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email.present ? email.value : this.email,
    photo: photo.present ? photo.value : this.photo,
    birthDate: birthDate.present ? birthDate.value : this.birthDate,
    gender: gender.present ? gender.value : this.gender,
    fitnessLevel: fitnessLevel ?? this.fitnessLevel,
    goals: goals ?? this.goals,
    language: language ?? this.language,
    trainingVenue: trainingVenue ?? this.trainingVenue,
    preferredUnits: preferredUnits ?? this.preferredUnits,
    defaultRestSeconds: defaultRestSeconds.present
        ? defaultRestSeconds.value
        : this.defaultRestSeconds,
    active: active ?? this.active,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      photo: data.photo.present ? data.photo.value : this.photo,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      gender: data.gender.present ? data.gender.value : this.gender,
      fitnessLevel: data.fitnessLevel.present
          ? data.fitnessLevel.value
          : this.fitnessLevel,
      goals: data.goals.present ? data.goals.value : this.goals,
      language: data.language.present ? data.language.value : this.language,
      trainingVenue: data.trainingVenue.present
          ? data.trainingVenue.value
          : this.trainingVenue,
      preferredUnits: data.preferredUnits.present
          ? data.preferredUnits.value
          : this.preferredUnits,
      defaultRestSeconds: data.defaultRestSeconds.present
          ? data.defaultRestSeconds.value
          : this.defaultRestSeconds,
      active: data.active.present ? data.active.value : this.active,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('photo: $photo, ')
          ..write('birthDate: $birthDate, ')
          ..write('gender: $gender, ')
          ..write('fitnessLevel: $fitnessLevel, ')
          ..write('goals: $goals, ')
          ..write('language: $language, ')
          ..write('trainingVenue: $trainingVenue, ')
          ..write('preferredUnits: $preferredUnits, ')
          ..write('defaultRestSeconds: $defaultRestSeconds, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    email,
    photo,
    birthDate,
    gender,
    fitnessLevel,
    goals,
    language,
    trainingVenue,
    preferredUnits,
    defaultRestSeconds,
    active,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.photo == this.photo &&
          other.birthDate == this.birthDate &&
          other.gender == this.gender &&
          other.fitnessLevel == this.fitnessLevel &&
          other.goals == this.goals &&
          other.language == this.language &&
          other.trainingVenue == this.trainingVenue &&
          other.preferredUnits == this.preferredUnits &&
          other.defaultRestSeconds == this.defaultRestSeconds &&
          other.active == this.active &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> email;
  final Value<String?> photo;
  final Value<DateTime?> birthDate;
  final Value<String?> gender;
  final Value<FitnessLevel> fitnessLevel;
  final Value<List<FitnessGoal>> goals;
  final Value<String> language;
  final Value<ExerciseVenue> trainingVenue;
  final Value<PreferredUnits> preferredUnits;
  final Value<int?> defaultRestSeconds;
  final Value<bool> active;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.photo = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.gender = const Value.absent(),
    this.fitnessLevel = const Value.absent(),
    this.goals = const Value.absent(),
    this.language = const Value.absent(),
    this.trainingVenue = const Value.absent(),
    this.preferredUnits = const Value.absent(),
    this.defaultRestSeconds = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String name,
    this.email = const Value.absent(),
    this.photo = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.gender = const Value.absent(),
    required FitnessLevel fitnessLevel,
    required List<FitnessGoal> goals,
    required String language,
    this.trainingVenue = const Value.absent(),
    this.preferredUnits = const Value.absent(),
    this.defaultRestSeconds = const Value.absent(),
    this.active = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       fitnessLevel = Value(fitnessLevel),
       goals = Value(goals),
       language = Value(language),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? photo,
    Expression<DateTime>? birthDate,
    Expression<String>? gender,
    Expression<String>? fitnessLevel,
    Expression<String>? goals,
    Expression<String>? language,
    Expression<String>? trainingVenue,
    Expression<String>? preferredUnits,
    Expression<int>? defaultRestSeconds,
    Expression<bool>? active,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (photo != null) 'photo': photo,
      if (birthDate != null) 'birth_date': birthDate,
      if (gender != null) 'gender': gender,
      if (fitnessLevel != null) 'fitness_level': fitnessLevel,
      if (goals != null) 'goals': goals,
      if (language != null) 'language': language,
      if (trainingVenue != null) 'training_venue': trainingVenue,
      if (preferredUnits != null) 'preferred_units': preferredUnits,
      if (defaultRestSeconds != null)
        'default_rest_seconds': defaultRestSeconds,
      if (active != null) 'active': active,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? email,
    Value<String?>? photo,
    Value<DateTime?>? birthDate,
    Value<String?>? gender,
    Value<FitnessLevel>? fitnessLevel,
    Value<List<FitnessGoal>>? goals,
    Value<String>? language,
    Value<ExerciseVenue>? trainingVenue,
    Value<PreferredUnits>? preferredUnits,
    Value<int?>? defaultRestSeconds,
    Value<bool>? active,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photo: photo ?? this.photo,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      goals: goals ?? this.goals,
      language: language ?? this.language,
      trainingVenue: trainingVenue ?? this.trainingVenue,
      preferredUnits: preferredUnits ?? this.preferredUnits,
      defaultRestSeconds: defaultRestSeconds ?? this.defaultRestSeconds,
      active: active ?? this.active,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (photo.present) {
      map['photo'] = Variable<String>(photo.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (fitnessLevel.present) {
      map['fitness_level'] = Variable<String>(
        $UsersTable.$converterfitnessLevel.toSql(fitnessLevel.value),
      );
    }
    if (goals.present) {
      map['goals'] = Variable<String>(
        $UsersTable.$convertergoals.toSql(goals.value),
      );
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (trainingVenue.present) {
      map['training_venue'] = Variable<String>(
        $UsersTable.$convertertrainingVenue.toSql(trainingVenue.value),
      );
    }
    if (preferredUnits.present) {
      map['preferred_units'] = Variable<String>(
        $UsersTable.$converterpreferredUnits.toSql(preferredUnits.value),
      );
    }
    if (defaultRestSeconds.present) {
      map['default_rest_seconds'] = Variable<int>(defaultRestSeconds.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
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
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('photo: $photo, ')
          ..write('birthDate: $birthDate, ')
          ..write('gender: $gender, ')
          ..write('fitnessLevel: $fitnessLevel, ')
          ..write('goals: $goals, ')
          ..write('language: $language, ')
          ..write('trainingVenue: $trainingVenue, ')
          ..write('preferredUnits: $preferredUnits, ')
          ..write('defaultRestSeconds: $defaultRestSeconds, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LocalizedText, String> name =
      GeneratedColumn<String>(
        'name',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LocalizedText>($ExercisesTable.$convertername);
  @override
  late final GeneratedColumnWithTypeConverter<LocalizedText, String>
  description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<LocalizedText>($ExercisesTable.$converterdescription);
  @override
  late final GeneratedColumnWithTypeConverter<LocalizedText, String>
  instructions = GeneratedColumn<String>(
    'instructions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<LocalizedText>($ExercisesTable.$converterinstructions);
  static const VerificationMeta _photoMeta = const VerificationMeta('photo');
  @override
  late final GeneratedColumn<String> photo = GeneratedColumn<String>(
    'photo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ExerciseCategory, String>
  category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<ExerciseCategory>($ExercisesTable.$convertercategory);
  @override
  late final GeneratedColumnWithTypeConverter<Difficulty, String> difficulty =
      GeneratedColumn<String>(
        'difficulty',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Difficulty>($ExercisesTable.$converterdifficulty);
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
    'duration',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repetitionsMeta = const VerificationMeta(
    'repetitions',
  );
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
    'repetitions',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  targetMuscles = GeneratedColumn<String>(
    'target_muscles',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<String>>($ExercisesTable.$convertertargetMuscles);
  @override
  late final GeneratedColumnWithTypeConverter<EquipmentKind, String> equipment =
      GeneratedColumn<String>(
        'equipment',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EquipmentKind>($ExercisesTable.$converterequipment);
  @override
  late final GeneratedColumnWithTypeConverter<LocalizedText, String>
  safetyNotes = GeneratedColumn<String>(
    'safety_notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<LocalizedText>($ExercisesTable.$convertersafetyNotes);
  @override
  late final GeneratedColumnWithTypeConverter<ExerciseVenue, String> venue =
      GeneratedColumn<String>(
        'venue',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('both'),
      ).withConverter<ExerciseVenue>($ExercisesTable.$convertervenue);
  static const VerificationMeta _gymNumberMeta = const VerificationMeta(
    'gymNumber',
  );
  @override
  late final GeneratedColumn<int> gymNumber = GeneratedColumn<int>(
    'gym_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    name,
    description,
    instructions,
    photo,
    category,
    difficulty,
    duration,
    repetitions,
    targetMuscles,
    equipment,
    safetyNotes,
    venue,
    gymNumber,
    active,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<Exercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('photo')) {
      context.handle(
        _photoMeta,
        photo.isAcceptableOrUnknown(data['photo']!, _photoMeta),
      );
    } else if (isInserting) {
      context.missing(_photoMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    }
    if (data.containsKey('repetitions')) {
      context.handle(
        _repetitionsMeta,
        repetitions.isAcceptableOrUnknown(
          data['repetitions']!,
          _repetitionsMeta,
        ),
      );
    }
    if (data.containsKey('gym_number')) {
      context.handle(
        _gymNumberMeta,
        gymNumber.isAcceptableOrUnknown(data['gym_number']!, _gymNumberMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
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
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: $ExercisesTable.$convertername.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}name'],
        )!,
      ),
      description: $ExercisesTable.$converterdescription.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}description'],
        )!,
      ),
      instructions: $ExercisesTable.$converterinstructions.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}instructions'],
        )!,
      ),
      photo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo'],
      )!,
      category: $ExercisesTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      difficulty: $ExercisesTable.$converterdifficulty.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}difficulty'],
        )!,
      ),
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration'],
      ),
      repetitions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repetitions'],
      ),
      targetMuscles: $ExercisesTable.$convertertargetMuscles.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}target_muscles'],
        )!,
      ),
      equipment: $ExercisesTable.$converterequipment.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}equipment'],
        )!,
      ),
      safetyNotes: $ExercisesTable.$convertersafetyNotes.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}safety_notes'],
        )!,
      ),
      venue: $ExercisesTable.$convertervenue.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}venue'],
        )!,
      ),
      gymNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gym_number'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
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
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }

  static TypeConverter<LocalizedText, String> $convertername =
      const LocalizedTextConverter();
  static TypeConverter<LocalizedText, String> $converterdescription =
      const LocalizedTextConverter();
  static TypeConverter<LocalizedText, String> $converterinstructions =
      const LocalizedTextConverter();
  static JsonTypeConverter2<ExerciseCategory, String, String>
  $convertercategory = const EnumNameConverter<ExerciseCategory>(
    ExerciseCategory.values,
  );
  static JsonTypeConverter2<Difficulty, String, String> $converterdifficulty =
      const EnumNameConverter<Difficulty>(Difficulty.values);
  static TypeConverter<List<String>, String> $convertertargetMuscles =
      const StringListConverter();
  static JsonTypeConverter2<EquipmentKind, String, String> $converterequipment =
      const EnumNameConverter<EquipmentKind>(EquipmentKind.values);
  static TypeConverter<LocalizedText, String> $convertersafetyNotes =
      const LocalizedTextConverter();
  static JsonTypeConverter2<ExerciseVenue, String, String> $convertervenue =
      const EnumNameConverter<ExerciseVenue>(ExerciseVenue.values);
}

class Exercise extends DataClass implements Insertable<Exercise> {
  final String id;
  final LocalizedText name;
  final LocalizedText description;
  final LocalizedText instructions;
  final String photo;
  final ExerciseCategory category;
  final Difficulty difficulty;
  final int? duration;
  final int? repetitions;
  final List<String> targetMuscles;
  final EquipmentKind equipment;
  final LocalizedText safetyNotes;
  final ExerciseVenue venue;
  final int? gymNumber;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.instructions,
    required this.photo,
    required this.category,
    required this.difficulty,
    this.duration,
    this.repetitions,
    required this.targetMuscles,
    required this.equipment,
    required this.safetyNotes,
    required this.venue,
    this.gymNumber,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['name'] = Variable<String>(
        $ExercisesTable.$convertername.toSql(name),
      );
    }
    {
      map['description'] = Variable<String>(
        $ExercisesTable.$converterdescription.toSql(description),
      );
    }
    {
      map['instructions'] = Variable<String>(
        $ExercisesTable.$converterinstructions.toSql(instructions),
      );
    }
    map['photo'] = Variable<String>(photo);
    {
      map['category'] = Variable<String>(
        $ExercisesTable.$convertercategory.toSql(category),
      );
    }
    {
      map['difficulty'] = Variable<String>(
        $ExercisesTable.$converterdifficulty.toSql(difficulty),
      );
    }
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<int>(duration);
    }
    if (!nullToAbsent || repetitions != null) {
      map['repetitions'] = Variable<int>(repetitions);
    }
    {
      map['target_muscles'] = Variable<String>(
        $ExercisesTable.$convertertargetMuscles.toSql(targetMuscles),
      );
    }
    {
      map['equipment'] = Variable<String>(
        $ExercisesTable.$converterequipment.toSql(equipment),
      );
    }
    {
      map['safety_notes'] = Variable<String>(
        $ExercisesTable.$convertersafetyNotes.toSql(safetyNotes),
      );
    }
    {
      map['venue'] = Variable<String>(
        $ExercisesTable.$convertervenue.toSql(venue),
      );
    }
    if (!nullToAbsent || gymNumber != null) {
      map['gym_number'] = Variable<int>(gymNumber);
    }
    map['active'] = Variable<bool>(active);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      instructions: Value(instructions),
      photo: Value(photo),
      category: Value(category),
      difficulty: Value(difficulty),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      repetitions: repetitions == null && nullToAbsent
          ? const Value.absent()
          : Value(repetitions),
      targetMuscles: Value(targetMuscles),
      equipment: Value(equipment),
      safetyNotes: Value(safetyNotes),
      venue: Value(venue),
      gymNumber: gymNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(gymNumber),
      active: Value(active),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Exercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<LocalizedText>(json['name']),
      description: serializer.fromJson<LocalizedText>(json['description']),
      instructions: serializer.fromJson<LocalizedText>(json['instructions']),
      photo: serializer.fromJson<String>(json['photo']),
      category: $ExercisesTable.$convertercategory.fromJson(
        serializer.fromJson<String>(json['category']),
      ),
      difficulty: $ExercisesTable.$converterdifficulty.fromJson(
        serializer.fromJson<String>(json['difficulty']),
      ),
      duration: serializer.fromJson<int?>(json['duration']),
      repetitions: serializer.fromJson<int?>(json['repetitions']),
      targetMuscles: serializer.fromJson<List<String>>(json['targetMuscles']),
      equipment: $ExercisesTable.$converterequipment.fromJson(
        serializer.fromJson<String>(json['equipment']),
      ),
      safetyNotes: serializer.fromJson<LocalizedText>(json['safetyNotes']),
      venue: $ExercisesTable.$convertervenue.fromJson(
        serializer.fromJson<String>(json['venue']),
      ),
      gymNumber: serializer.fromJson<int?>(json['gymNumber']),
      active: serializer.fromJson<bool>(json['active']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<LocalizedText>(name),
      'description': serializer.toJson<LocalizedText>(description),
      'instructions': serializer.toJson<LocalizedText>(instructions),
      'photo': serializer.toJson<String>(photo),
      'category': serializer.toJson<String>(
        $ExercisesTable.$convertercategory.toJson(category),
      ),
      'difficulty': serializer.toJson<String>(
        $ExercisesTable.$converterdifficulty.toJson(difficulty),
      ),
      'duration': serializer.toJson<int?>(duration),
      'repetitions': serializer.toJson<int?>(repetitions),
      'targetMuscles': serializer.toJson<List<String>>(targetMuscles),
      'equipment': serializer.toJson<String>(
        $ExercisesTable.$converterequipment.toJson(equipment),
      ),
      'safetyNotes': serializer.toJson<LocalizedText>(safetyNotes),
      'venue': serializer.toJson<String>(
        $ExercisesTable.$convertervenue.toJson(venue),
      ),
      'gymNumber': serializer.toJson<int?>(gymNumber),
      'active': serializer.toJson<bool>(active),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Exercise copyWith({
    String? id,
    LocalizedText? name,
    LocalizedText? description,
    LocalizedText? instructions,
    String? photo,
    ExerciseCategory? category,
    Difficulty? difficulty,
    Value<int?> duration = const Value.absent(),
    Value<int?> repetitions = const Value.absent(),
    List<String>? targetMuscles,
    EquipmentKind? equipment,
    LocalizedText? safetyNotes,
    ExerciseVenue? venue,
    Value<int?> gymNumber = const Value.absent(),
    bool? active,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Exercise(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    instructions: instructions ?? this.instructions,
    photo: photo ?? this.photo,
    category: category ?? this.category,
    difficulty: difficulty ?? this.difficulty,
    duration: duration.present ? duration.value : this.duration,
    repetitions: repetitions.present ? repetitions.value : this.repetitions,
    targetMuscles: targetMuscles ?? this.targetMuscles,
    equipment: equipment ?? this.equipment,
    safetyNotes: safetyNotes ?? this.safetyNotes,
    venue: venue ?? this.venue,
    gymNumber: gymNumber.present ? gymNumber.value : this.gymNumber,
    active: active ?? this.active,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Exercise copyWithCompanion(ExercisesCompanion data) {
    return Exercise(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      instructions: data.instructions.present
          ? data.instructions.value
          : this.instructions,
      photo: data.photo.present ? data.photo.value : this.photo,
      category: data.category.present ? data.category.value : this.category,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      duration: data.duration.present ? data.duration.value : this.duration,
      repetitions: data.repetitions.present
          ? data.repetitions.value
          : this.repetitions,
      targetMuscles: data.targetMuscles.present
          ? data.targetMuscles.value
          : this.targetMuscles,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
      safetyNotes: data.safetyNotes.present
          ? data.safetyNotes.value
          : this.safetyNotes,
      venue: data.venue.present ? data.venue.value : this.venue,
      gymNumber: data.gymNumber.present ? data.gymNumber.value : this.gymNumber,
      active: data.active.present ? data.active.value : this.active,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('instructions: $instructions, ')
          ..write('photo: $photo, ')
          ..write('category: $category, ')
          ..write('difficulty: $difficulty, ')
          ..write('duration: $duration, ')
          ..write('repetitions: $repetitions, ')
          ..write('targetMuscles: $targetMuscles, ')
          ..write('equipment: $equipment, ')
          ..write('safetyNotes: $safetyNotes, ')
          ..write('venue: $venue, ')
          ..write('gymNumber: $gymNumber, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    instructions,
    photo,
    category,
    difficulty,
    duration,
    repetitions,
    targetMuscles,
    equipment,
    safetyNotes,
    venue,
    gymNumber,
    active,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.instructions == this.instructions &&
          other.photo == this.photo &&
          other.category == this.category &&
          other.difficulty == this.difficulty &&
          other.duration == this.duration &&
          other.repetitions == this.repetitions &&
          other.targetMuscles == this.targetMuscles &&
          other.equipment == this.equipment &&
          other.safetyNotes == this.safetyNotes &&
          other.venue == this.venue &&
          other.gymNumber == this.gymNumber &&
          other.active == this.active &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<String> id;
  final Value<LocalizedText> name;
  final Value<LocalizedText> description;
  final Value<LocalizedText> instructions;
  final Value<String> photo;
  final Value<ExerciseCategory> category;
  final Value<Difficulty> difficulty;
  final Value<int?> duration;
  final Value<int?> repetitions;
  final Value<List<String>> targetMuscles;
  final Value<EquipmentKind> equipment;
  final Value<LocalizedText> safetyNotes;
  final Value<ExerciseVenue> venue;
  final Value<int?> gymNumber;
  final Value<bool> active;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.instructions = const Value.absent(),
    this.photo = const Value.absent(),
    this.category = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.duration = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.targetMuscles = const Value.absent(),
    this.equipment = const Value.absent(),
    this.safetyNotes = const Value.absent(),
    this.venue = const Value.absent(),
    this.gymNumber = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExercisesCompanion.insert({
    required String id,
    required LocalizedText name,
    required LocalizedText description,
    required LocalizedText instructions,
    required String photo,
    required ExerciseCategory category,
    required Difficulty difficulty,
    this.duration = const Value.absent(),
    this.repetitions = const Value.absent(),
    required List<String> targetMuscles,
    required EquipmentKind equipment,
    required LocalizedText safetyNotes,
    this.venue = const Value.absent(),
    this.gymNumber = const Value.absent(),
    this.active = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       description = Value(description),
       instructions = Value(instructions),
       photo = Value(photo),
       category = Value(category),
       difficulty = Value(difficulty),
       targetMuscles = Value(targetMuscles),
       equipment = Value(equipment),
       safetyNotes = Value(safetyNotes),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Exercise> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? instructions,
    Expression<String>? photo,
    Expression<String>? category,
    Expression<String>? difficulty,
    Expression<int>? duration,
    Expression<int>? repetitions,
    Expression<String>? targetMuscles,
    Expression<String>? equipment,
    Expression<String>? safetyNotes,
    Expression<String>? venue,
    Expression<int>? gymNumber,
    Expression<bool>? active,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (instructions != null) 'instructions': instructions,
      if (photo != null) 'photo': photo,
      if (category != null) 'category': category,
      if (difficulty != null) 'difficulty': difficulty,
      if (duration != null) 'duration': duration,
      if (repetitions != null) 'repetitions': repetitions,
      if (targetMuscles != null) 'target_muscles': targetMuscles,
      if (equipment != null) 'equipment': equipment,
      if (safetyNotes != null) 'safety_notes': safetyNotes,
      if (venue != null) 'venue': venue,
      if (gymNumber != null) 'gym_number': gymNumber,
      if (active != null) 'active': active,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExercisesCompanion copyWith({
    Value<String>? id,
    Value<LocalizedText>? name,
    Value<LocalizedText>? description,
    Value<LocalizedText>? instructions,
    Value<String>? photo,
    Value<ExerciseCategory>? category,
    Value<Difficulty>? difficulty,
    Value<int?>? duration,
    Value<int?>? repetitions,
    Value<List<String>>? targetMuscles,
    Value<EquipmentKind>? equipment,
    Value<LocalizedText>? safetyNotes,
    Value<ExerciseVenue>? venue,
    Value<int?>? gymNumber,
    Value<bool>? active,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ExercisesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      instructions: instructions ?? this.instructions,
      photo: photo ?? this.photo,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      duration: duration ?? this.duration,
      repetitions: repetitions ?? this.repetitions,
      targetMuscles: targetMuscles ?? this.targetMuscles,
      equipment: equipment ?? this.equipment,
      safetyNotes: safetyNotes ?? this.safetyNotes,
      venue: venue ?? this.venue,
      gymNumber: gymNumber ?? this.gymNumber,
      active: active ?? this.active,
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
    if (name.present) {
      map['name'] = Variable<String>(
        $ExercisesTable.$convertername.toSql(name.value),
      );
    }
    if (description.present) {
      map['description'] = Variable<String>(
        $ExercisesTable.$converterdescription.toSql(description.value),
      );
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(
        $ExercisesTable.$converterinstructions.toSql(instructions.value),
      );
    }
    if (photo.present) {
      map['photo'] = Variable<String>(photo.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $ExercisesTable.$convertercategory.toSql(category.value),
      );
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(
        $ExercisesTable.$converterdifficulty.toSql(difficulty.value),
      );
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (targetMuscles.present) {
      map['target_muscles'] = Variable<String>(
        $ExercisesTable.$convertertargetMuscles.toSql(targetMuscles.value),
      );
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(
        $ExercisesTable.$converterequipment.toSql(equipment.value),
      );
    }
    if (safetyNotes.present) {
      map['safety_notes'] = Variable<String>(
        $ExercisesTable.$convertersafetyNotes.toSql(safetyNotes.value),
      );
    }
    if (venue.present) {
      map['venue'] = Variable<String>(
        $ExercisesTable.$convertervenue.toSql(venue.value),
      );
    }
    if (gymNumber.present) {
      map['gym_number'] = Variable<int>(gymNumber.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
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
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('instructions: $instructions, ')
          ..write('photo: $photo, ')
          ..write('category: $category, ')
          ..write('difficulty: $difficulty, ')
          ..write('duration: $duration, ')
          ..write('repetitions: $repetitions, ')
          ..write('targetMuscles: $targetMuscles, ')
          ..write('equipment: $equipment, ')
          ..write('safetyNotes: $safetyNotes, ')
          ..write('venue: $venue, ')
          ..write('gymNumber: $gymNumber, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrainingProgramsTable extends TrainingPrograms
    with TableInfo<$TrainingProgramsTable, TrainingProgram> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrainingProgramsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ScheduleType, String>
  scheduleType = GeneratedColumn<String>(
    'schedule_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<ScheduleType>($TrainingProgramsTable.$converterscheduleType);
  @override
  late final GeneratedColumnWithTypeConverter<ProgramVenue, String> venue =
      GeneratedColumn<String>(
        'venue',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('home'),
      ).withConverter<ProgramVenue>($TrainingProgramsTable.$convertervenue);
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    userId,
    name,
    description,
    startDate,
    endDate,
    scheduleType,
    venue,
    active,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'training_programs';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrainingProgram> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
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
  TrainingProgram map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrainingProgram(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      ),
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      scheduleType: $TrainingProgramsTable.$converterscheduleType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}schedule_type'],
        )!,
      ),
      venue: $TrainingProgramsTable.$convertervenue.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}venue'],
        )!,
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
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
  $TrainingProgramsTable createAlias(String alias) {
    return $TrainingProgramsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ScheduleType, String, String>
  $converterscheduleType = const EnumNameConverter<ScheduleType>(
    ScheduleType.values,
  );
  static JsonTypeConverter2<ProgramVenue, String, String> $convertervenue =
      const EnumNameConverter<ProgramVenue>(ProgramVenue.values);
}

class TrainingProgram extends DataClass implements Insertable<TrainingProgram> {
  final String id;
  final String userId;
  final String name;
  final String description;
  final DateTime? startDate;
  final DateTime? endDate;
  final ScheduleType scheduleType;
  final ProgramVenue venue;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TrainingProgram({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    this.startDate,
    this.endDate,
    required this.scheduleType,
    required this.venue,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    {
      map['schedule_type'] = Variable<String>(
        $TrainingProgramsTable.$converterscheduleType.toSql(scheduleType),
      );
    }
    {
      map['venue'] = Variable<String>(
        $TrainingProgramsTable.$convertervenue.toSql(venue),
      );
    }
    map['active'] = Variable<bool>(active);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TrainingProgramsCompanion toCompanion(bool nullToAbsent) {
    return TrainingProgramsCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      description: Value(description),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      scheduleType: Value(scheduleType),
      venue: Value(venue),
      active: Value(active),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TrainingProgram.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrainingProgram(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      scheduleType: $TrainingProgramsTable.$converterscheduleType.fromJson(
        serializer.fromJson<String>(json['scheduleType']),
      ),
      venue: $TrainingProgramsTable.$convertervenue.fromJson(
        serializer.fromJson<String>(json['venue']),
      ),
      active: serializer.fromJson<bool>(json['active']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'scheduleType': serializer.toJson<String>(
        $TrainingProgramsTable.$converterscheduleType.toJson(scheduleType),
      ),
      'venue': serializer.toJson<String>(
        $TrainingProgramsTable.$convertervenue.toJson(venue),
      ),
      'active': serializer.toJson<bool>(active),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TrainingProgram copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    Value<DateTime?> startDate = const Value.absent(),
    Value<DateTime?> endDate = const Value.absent(),
    ScheduleType? scheduleType,
    ProgramVenue? venue,
    bool? active,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TrainingProgram(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    description: description ?? this.description,
    startDate: startDate.present ? startDate.value : this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    scheduleType: scheduleType ?? this.scheduleType,
    venue: venue ?? this.venue,
    active: active ?? this.active,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TrainingProgram copyWithCompanion(TrainingProgramsCompanion data) {
    return TrainingProgram(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      scheduleType: data.scheduleType.present
          ? data.scheduleType.value
          : this.scheduleType,
      venue: data.venue.present ? data.venue.value : this.venue,
      active: data.active.present ? data.active.value : this.active,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrainingProgram(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('scheduleType: $scheduleType, ')
          ..write('venue: $venue, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    name,
    description,
    startDate,
    endDate,
    scheduleType,
    venue,
    active,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrainingProgram &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.description == this.description &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.scheduleType == this.scheduleType &&
          other.venue == this.venue &&
          other.active == this.active &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TrainingProgramsCompanion extends UpdateCompanion<TrainingProgram> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> name;
  final Value<String> description;
  final Value<DateTime?> startDate;
  final Value<DateTime?> endDate;
  final Value<ScheduleType> scheduleType;
  final Value<ProgramVenue> venue;
  final Value<bool> active;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TrainingProgramsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.scheduleType = const Value.absent(),
    this.venue = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrainingProgramsCompanion.insert({
    required String id,
    required String userId,
    required String name,
    required String description,
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    required ScheduleType scheduleType,
    this.venue = const Value.absent(),
    this.active = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       name = Value(name),
       description = Value(description),
       scheduleType = Value(scheduleType),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TrainingProgram> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? scheduleType,
    Expression<String>? venue,
    Expression<bool>? active,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (scheduleType != null) 'schedule_type': scheduleType,
      if (venue != null) 'venue': venue,
      if (active != null) 'active': active,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrainingProgramsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? name,
    Value<String>? description,
    Value<DateTime?>? startDate,
    Value<DateTime?>? endDate,
    Value<ScheduleType>? scheduleType,
    Value<ProgramVenue>? venue,
    Value<bool>? active,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TrainingProgramsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      scheduleType: scheduleType ?? this.scheduleType,
      venue: venue ?? this.venue,
      active: active ?? this.active,
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
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (scheduleType.present) {
      map['schedule_type'] = Variable<String>(
        $TrainingProgramsTable.$converterscheduleType.toSql(scheduleType.value),
      );
    }
    if (venue.present) {
      map['venue'] = Variable<String>(
        $TrainingProgramsTable.$convertervenue.toSql(venue.value),
      );
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
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
    return (StringBuffer('TrainingProgramsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('scheduleType: $scheduleType, ')
          ..write('venue: $venue, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProgramDaysTable extends ProgramDays
    with TableInfo<$ProgramDaysTable, ProgramDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgramDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _programIdMeta = const VerificationMeta(
    'programId',
  );
  @override
  late final GeneratedColumn<String> programId = GeneratedColumn<String>(
    'program_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES training_programs (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LocalizedText, String> title =
      GeneratedColumn<String>(
        'title',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LocalizedText>($ProgramDaysTable.$convertertitle);
  @override
  late final GeneratedColumnWithTypeConverter<LocalizedText, String>
  description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<LocalizedText>($ProgramDaysTable.$converterdescription);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    programId,
    date,
    weekday,
    title,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'program_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProgramDay> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('program_id')) {
      context.handle(
        _programIdMeta,
        programId.isAcceptableOrUnknown(data['program_id']!, _programIdMeta),
      );
    } else if (isInserting) {
      context.missing(_programIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgramDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgramDay(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      programId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}program_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      ),
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      ),
      title: $ProgramDaysTable.$convertertitle.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}title'],
        )!,
      ),
      description: $ProgramDaysTable.$converterdescription.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}description'],
        )!,
      ),
    );
  }

  @override
  $ProgramDaysTable createAlias(String alias) {
    return $ProgramDaysTable(attachedDatabase, alias);
  }

  static TypeConverter<LocalizedText, String> $convertertitle =
      const LocalizedTextConverter();
  static TypeConverter<LocalizedText, String> $converterdescription =
      const LocalizedTextConverter();
}

class ProgramDay extends DataClass implements Insertable<ProgramDay> {
  final String id;
  final String programId;
  final DateTime? date;
  final int? weekday;
  final LocalizedText title;
  final LocalizedText description;
  const ProgramDay({
    required this.id,
    required this.programId,
    this.date,
    this.weekday,
    required this.title,
    required this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['program_id'] = Variable<String>(programId);
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    if (!nullToAbsent || weekday != null) {
      map['weekday'] = Variable<int>(weekday);
    }
    {
      map['title'] = Variable<String>(
        $ProgramDaysTable.$convertertitle.toSql(title),
      );
    }
    {
      map['description'] = Variable<String>(
        $ProgramDaysTable.$converterdescription.toSql(description),
      );
    }
    return map;
  }

  ProgramDaysCompanion toCompanion(bool nullToAbsent) {
    return ProgramDaysCompanion(
      id: Value(id),
      programId: Value(programId),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      weekday: weekday == null && nullToAbsent
          ? const Value.absent()
          : Value(weekday),
      title: Value(title),
      description: Value(description),
    );
  }

  factory ProgramDay.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgramDay(
      id: serializer.fromJson<String>(json['id']),
      programId: serializer.fromJson<String>(json['programId']),
      date: serializer.fromJson<DateTime?>(json['date']),
      weekday: serializer.fromJson<int?>(json['weekday']),
      title: serializer.fromJson<LocalizedText>(json['title']),
      description: serializer.fromJson<LocalizedText>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'programId': serializer.toJson<String>(programId),
      'date': serializer.toJson<DateTime?>(date),
      'weekday': serializer.toJson<int?>(weekday),
      'title': serializer.toJson<LocalizedText>(title),
      'description': serializer.toJson<LocalizedText>(description),
    };
  }

  ProgramDay copyWith({
    String? id,
    String? programId,
    Value<DateTime?> date = const Value.absent(),
    Value<int?> weekday = const Value.absent(),
    LocalizedText? title,
    LocalizedText? description,
  }) => ProgramDay(
    id: id ?? this.id,
    programId: programId ?? this.programId,
    date: date.present ? date.value : this.date,
    weekday: weekday.present ? weekday.value : this.weekday,
    title: title ?? this.title,
    description: description ?? this.description,
  );
  ProgramDay copyWithCompanion(ProgramDaysCompanion data) {
    return ProgramDay(
      id: data.id.present ? data.id.value : this.id,
      programId: data.programId.present ? data.programId.value : this.programId,
      date: data.date.present ? data.date.value : this.date,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgramDay(')
          ..write('id: $id, ')
          ..write('programId: $programId, ')
          ..write('date: $date, ')
          ..write('weekday: $weekday, ')
          ..write('title: $title, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, programId, date, weekday, title, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgramDay &&
          other.id == this.id &&
          other.programId == this.programId &&
          other.date == this.date &&
          other.weekday == this.weekday &&
          other.title == this.title &&
          other.description == this.description);
}

class ProgramDaysCompanion extends UpdateCompanion<ProgramDay> {
  final Value<String> id;
  final Value<String> programId;
  final Value<DateTime?> date;
  final Value<int?> weekday;
  final Value<LocalizedText> title;
  final Value<LocalizedText> description;
  final Value<int> rowid;
  const ProgramDaysCompanion({
    this.id = const Value.absent(),
    this.programId = const Value.absent(),
    this.date = const Value.absent(),
    this.weekday = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProgramDaysCompanion.insert({
    required String id,
    required String programId,
    this.date = const Value.absent(),
    this.weekday = const Value.absent(),
    required LocalizedText title,
    required LocalizedText description,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       programId = Value(programId),
       title = Value(title),
       description = Value(description);
  static Insertable<ProgramDay> custom({
    Expression<String>? id,
    Expression<String>? programId,
    Expression<DateTime>? date,
    Expression<int>? weekday,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (programId != null) 'program_id': programId,
      if (date != null) 'date': date,
      if (weekday != null) 'weekday': weekday,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProgramDaysCompanion copyWith({
    Value<String>? id,
    Value<String>? programId,
    Value<DateTime?>? date,
    Value<int?>? weekday,
    Value<LocalizedText>? title,
    Value<LocalizedText>? description,
    Value<int>? rowid,
  }) {
    return ProgramDaysCompanion(
      id: id ?? this.id,
      programId: programId ?? this.programId,
      date: date ?? this.date,
      weekday: weekday ?? this.weekday,
      title: title ?? this.title,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (programId.present) {
      map['program_id'] = Variable<String>(programId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(
        $ProgramDaysTable.$convertertitle.toSql(title.value),
      );
    }
    if (description.present) {
      map['description'] = Variable<String>(
        $ProgramDaysTable.$converterdescription.toSql(description.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgramDaysCompanion(')
          ..write('id: $id, ')
          ..write('programId: $programId, ')
          ..write('date: $date, ')
          ..write('weekday: $weekday, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProgramExercisesTable extends ProgramExercises
    with TableInfo<$ProgramExercisesTable, ProgramExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgramExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _programDayIdMeta = const VerificationMeta(
    'programDayId',
  );
  @override
  late final GeneratedColumn<String> programDayId = GeneratedColumn<String>(
    'program_day_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES program_days (id)',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id)',
    ),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setsMeta = const VerificationMeta('sets');
  @override
  late final GeneratedColumn<int> sets = GeneratedColumn<int>(
    'sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repetitionsMeta = const VerificationMeta(
    'repetitions',
  );
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
    'repetitions',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
    'duration',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _loadKgMeta = const VerificationMeta('loadKg');
  @override
  late final GeneratedColumn<double> loadKg = GeneratedColumn<double>(
    'load_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restMeta = const VerificationMeta('rest');
  @override
  late final GeneratedColumn<int> rest = GeneratedColumn<int>(
    'rest',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    programDayId,
    exerciseId,
    sortOrder,
    sets,
    repetitions,
    duration,
    loadKg,
    rest,
    notes,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'program_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProgramExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('program_day_id')) {
      context.handle(
        _programDayIdMeta,
        programDayId.isAcceptableOrUnknown(
          data['program_day_id']!,
          _programDayIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_programDayIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('sets')) {
      context.handle(
        _setsMeta,
        sets.isAcceptableOrUnknown(data['sets']!, _setsMeta),
      );
    } else if (isInserting) {
      context.missing(_setsMeta);
    }
    if (data.containsKey('repetitions')) {
      context.handle(
        _repetitionsMeta,
        repetitions.isAcceptableOrUnknown(
          data['repetitions']!,
          _repetitionsMeta,
        ),
      );
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    }
    if (data.containsKey('load_kg')) {
      context.handle(
        _loadKgMeta,
        loadKg.isAcceptableOrUnknown(data['load_kg']!, _loadKgMeta),
      );
    }
    if (data.containsKey('rest')) {
      context.handle(
        _restMeta,
        rest.isAcceptableOrUnknown(data['rest']!, _restMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgramExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgramExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      programDayId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}program_day_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      sets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sets'],
      )!,
      repetitions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repetitions'],
      ),
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration'],
      ),
      loadKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}load_kg'],
      ),
      rest: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $ProgramExercisesTable createAlias(String alias) {
    return $ProgramExercisesTable(attachedDatabase, alias);
  }
}

class ProgramExercise extends DataClass implements Insertable<ProgramExercise> {
  final String id;
  final String programDayId;
  final String exerciseId;
  final int sortOrder;
  final int sets;
  final int? repetitions;
  final int? duration;
  final double? loadKg;
  final int rest;
  final String? notes;
  final bool active;
  const ProgramExercise({
    required this.id,
    required this.programDayId,
    required this.exerciseId,
    required this.sortOrder,
    required this.sets,
    this.repetitions,
    this.duration,
    this.loadKg,
    required this.rest,
    this.notes,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['program_day_id'] = Variable<String>(programDayId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['sort_order'] = Variable<int>(sortOrder);
    map['sets'] = Variable<int>(sets);
    if (!nullToAbsent || repetitions != null) {
      map['repetitions'] = Variable<int>(repetitions);
    }
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<int>(duration);
    }
    if (!nullToAbsent || loadKg != null) {
      map['load_kg'] = Variable<double>(loadKg);
    }
    map['rest'] = Variable<int>(rest);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['active'] = Variable<bool>(active);
    return map;
  }

  ProgramExercisesCompanion toCompanion(bool nullToAbsent) {
    return ProgramExercisesCompanion(
      id: Value(id),
      programDayId: Value(programDayId),
      exerciseId: Value(exerciseId),
      sortOrder: Value(sortOrder),
      sets: Value(sets),
      repetitions: repetitions == null && nullToAbsent
          ? const Value.absent()
          : Value(repetitions),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      loadKg: loadKg == null && nullToAbsent
          ? const Value.absent()
          : Value(loadKg),
      rest: Value(rest),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      active: Value(active),
    );
  }

  factory ProgramExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgramExercise(
      id: serializer.fromJson<String>(json['id']),
      programDayId: serializer.fromJson<String>(json['programDayId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      sets: serializer.fromJson<int>(json['sets']),
      repetitions: serializer.fromJson<int?>(json['repetitions']),
      duration: serializer.fromJson<int?>(json['duration']),
      loadKg: serializer.fromJson<double?>(json['loadKg']),
      rest: serializer.fromJson<int>(json['rest']),
      notes: serializer.fromJson<String?>(json['notes']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'programDayId': serializer.toJson<String>(programDayId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'sets': serializer.toJson<int>(sets),
      'repetitions': serializer.toJson<int?>(repetitions),
      'duration': serializer.toJson<int?>(duration),
      'loadKg': serializer.toJson<double?>(loadKg),
      'rest': serializer.toJson<int>(rest),
      'notes': serializer.toJson<String?>(notes),
      'active': serializer.toJson<bool>(active),
    };
  }

  ProgramExercise copyWith({
    String? id,
    String? programDayId,
    String? exerciseId,
    int? sortOrder,
    int? sets,
    Value<int?> repetitions = const Value.absent(),
    Value<int?> duration = const Value.absent(),
    Value<double?> loadKg = const Value.absent(),
    int? rest,
    Value<String?> notes = const Value.absent(),
    bool? active,
  }) => ProgramExercise(
    id: id ?? this.id,
    programDayId: programDayId ?? this.programDayId,
    exerciseId: exerciseId ?? this.exerciseId,
    sortOrder: sortOrder ?? this.sortOrder,
    sets: sets ?? this.sets,
    repetitions: repetitions.present ? repetitions.value : this.repetitions,
    duration: duration.present ? duration.value : this.duration,
    loadKg: loadKg.present ? loadKg.value : this.loadKg,
    rest: rest ?? this.rest,
    notes: notes.present ? notes.value : this.notes,
    active: active ?? this.active,
  );
  ProgramExercise copyWithCompanion(ProgramExercisesCompanion data) {
    return ProgramExercise(
      id: data.id.present ? data.id.value : this.id,
      programDayId: data.programDayId.present
          ? data.programDayId.value
          : this.programDayId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      sets: data.sets.present ? data.sets.value : this.sets,
      repetitions: data.repetitions.present
          ? data.repetitions.value
          : this.repetitions,
      duration: data.duration.present ? data.duration.value : this.duration,
      loadKg: data.loadKg.present ? data.loadKg.value : this.loadKg,
      rest: data.rest.present ? data.rest.value : this.rest,
      notes: data.notes.present ? data.notes.value : this.notes,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgramExercise(')
          ..write('id: $id, ')
          ..write('programDayId: $programDayId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('sets: $sets, ')
          ..write('repetitions: $repetitions, ')
          ..write('duration: $duration, ')
          ..write('loadKg: $loadKg, ')
          ..write('rest: $rest, ')
          ..write('notes: $notes, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    programDayId,
    exerciseId,
    sortOrder,
    sets,
    repetitions,
    duration,
    loadKg,
    rest,
    notes,
    active,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgramExercise &&
          other.id == this.id &&
          other.programDayId == this.programDayId &&
          other.exerciseId == this.exerciseId &&
          other.sortOrder == this.sortOrder &&
          other.sets == this.sets &&
          other.repetitions == this.repetitions &&
          other.duration == this.duration &&
          other.loadKg == this.loadKg &&
          other.rest == this.rest &&
          other.notes == this.notes &&
          other.active == this.active);
}

class ProgramExercisesCompanion extends UpdateCompanion<ProgramExercise> {
  final Value<String> id;
  final Value<String> programDayId;
  final Value<String> exerciseId;
  final Value<int> sortOrder;
  final Value<int> sets;
  final Value<int?> repetitions;
  final Value<int?> duration;
  final Value<double?> loadKg;
  final Value<int> rest;
  final Value<String?> notes;
  final Value<bool> active;
  final Value<int> rowid;
  const ProgramExercisesCompanion({
    this.id = const Value.absent(),
    this.programDayId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.sets = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.duration = const Value.absent(),
    this.loadKg = const Value.absent(),
    this.rest = const Value.absent(),
    this.notes = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProgramExercisesCompanion.insert({
    required String id,
    required String programDayId,
    required String exerciseId,
    required int sortOrder,
    required int sets,
    this.repetitions = const Value.absent(),
    this.duration = const Value.absent(),
    this.loadKg = const Value.absent(),
    this.rest = const Value.absent(),
    this.notes = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       programDayId = Value(programDayId),
       exerciseId = Value(exerciseId),
       sortOrder = Value(sortOrder),
       sets = Value(sets);
  static Insertable<ProgramExercise> custom({
    Expression<String>? id,
    Expression<String>? programDayId,
    Expression<String>? exerciseId,
    Expression<int>? sortOrder,
    Expression<int>? sets,
    Expression<int>? repetitions,
    Expression<int>? duration,
    Expression<double>? loadKg,
    Expression<int>? rest,
    Expression<String>? notes,
    Expression<bool>? active,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (programDayId != null) 'program_day_id': programDayId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (sets != null) 'sets': sets,
      if (repetitions != null) 'repetitions': repetitions,
      if (duration != null) 'duration': duration,
      if (loadKg != null) 'load_kg': loadKg,
      if (rest != null) 'rest': rest,
      if (notes != null) 'notes': notes,
      if (active != null) 'active': active,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProgramExercisesCompanion copyWith({
    Value<String>? id,
    Value<String>? programDayId,
    Value<String>? exerciseId,
    Value<int>? sortOrder,
    Value<int>? sets,
    Value<int?>? repetitions,
    Value<int?>? duration,
    Value<double?>? loadKg,
    Value<int>? rest,
    Value<String?>? notes,
    Value<bool>? active,
    Value<int>? rowid,
  }) {
    return ProgramExercisesCompanion(
      id: id ?? this.id,
      programDayId: programDayId ?? this.programDayId,
      exerciseId: exerciseId ?? this.exerciseId,
      sortOrder: sortOrder ?? this.sortOrder,
      sets: sets ?? this.sets,
      repetitions: repetitions ?? this.repetitions,
      duration: duration ?? this.duration,
      loadKg: loadKg ?? this.loadKg,
      rest: rest ?? this.rest,
      notes: notes ?? this.notes,
      active: active ?? this.active,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (programDayId.present) {
      map['program_day_id'] = Variable<String>(programDayId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (sets.present) {
      map['sets'] = Variable<int>(sets.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (loadKg.present) {
      map['load_kg'] = Variable<double>(loadKg.value);
    }
    if (rest.present) {
      map['rest'] = Variable<int>(rest.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgramExercisesCompanion(')
          ..write('id: $id, ')
          ..write('programDayId: $programDayId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('sets: $sets, ')
          ..write('repetitions: $repetitions, ')
          ..write('duration: $duration, ')
          ..write('loadKg: $loadKg, ')
          ..write('rest: $rest, ')
          ..write('notes: $notes, ')
          ..write('active: $active, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSessionsTable extends WorkoutSessions
    with TableInfo<$WorkoutSessionsTable, WorkoutSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _programDayIdMeta = const VerificationMeta(
    'programDayId',
  );
  @override
  late final GeneratedColumn<String> programDayId = GeneratedColumn<String>(
    'program_day_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES program_days (id)',
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
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
    'duration',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<WorkoutStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<WorkoutStatus>($WorkoutSessionsTable.$converterstatus);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalVolumeKgMeta = const VerificationMeta(
    'totalVolumeKg',
  );
  @override
  late final GeneratedColumn<double> totalVolumeKg = GeneratedColumn<double>(
    'total_volume_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    programDayId,
    startedAt,
    completedAt,
    duration,
    status,
    notes,
    totalVolumeKg,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('program_day_id')) {
      context.handle(
        _programDayIdMeta,
        programDayId.isAcceptableOrUnknown(
          data['program_day_id']!,
          _programDayIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_programDayIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('total_volume_kg')) {
      context.handle(
        _totalVolumeKgMeta,
        totalVolumeKg.isAcceptableOrUnknown(
          data['total_volume_kg']!,
          _totalVolumeKgMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      programDayId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}program_day_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration'],
      ),
      status: $WorkoutSessionsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      totalVolumeKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_volume_kg'],
      ),
    );
  }

  @override
  $WorkoutSessionsTable createAlias(String alias) {
    return $WorkoutSessionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<WorkoutStatus, String, String> $converterstatus =
      const EnumNameConverter<WorkoutStatus>(WorkoutStatus.values);
}

class WorkoutSession extends DataClass implements Insertable<WorkoutSession> {
  final String id;
  final String userId;
  final String programDayId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int? duration;
  final WorkoutStatus status;
  final String? notes;
  final double? totalVolumeKg;
  const WorkoutSession({
    required this.id,
    required this.userId,
    required this.programDayId,
    required this.startedAt,
    this.completedAt,
    this.duration,
    required this.status,
    this.notes,
    this.totalVolumeKg,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['program_day_id'] = Variable<String>(programDayId);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<int>(duration);
    }
    {
      map['status'] = Variable<String>(
        $WorkoutSessionsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || totalVolumeKg != null) {
      map['total_volume_kg'] = Variable<double>(totalVolumeKg);
    }
    return map;
  }

  WorkoutSessionsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionsCompanion(
      id: Value(id),
      userId: Value(userId),
      programDayId: Value(programDayId),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      status: Value(status),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      totalVolumeKg: totalVolumeKg == null && nullToAbsent
          ? const Value.absent()
          : Value(totalVolumeKg),
    );
  }

  factory WorkoutSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSession(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      programDayId: serializer.fromJson<String>(json['programDayId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      duration: serializer.fromJson<int?>(json['duration']),
      status: $WorkoutSessionsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      totalVolumeKg: serializer.fromJson<double?>(json['totalVolumeKg']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'programDayId': serializer.toJson<String>(programDayId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'duration': serializer.toJson<int?>(duration),
      'status': serializer.toJson<String>(
        $WorkoutSessionsTable.$converterstatus.toJson(status),
      ),
      'notes': serializer.toJson<String?>(notes),
      'totalVolumeKg': serializer.toJson<double?>(totalVolumeKg),
    };
  }

  WorkoutSession copyWith({
    String? id,
    String? userId,
    String? programDayId,
    DateTime? startedAt,
    Value<DateTime?> completedAt = const Value.absent(),
    Value<int?> duration = const Value.absent(),
    WorkoutStatus? status,
    Value<String?> notes = const Value.absent(),
    Value<double?> totalVolumeKg = const Value.absent(),
  }) => WorkoutSession(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    programDayId: programDayId ?? this.programDayId,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    duration: duration.present ? duration.value : this.duration,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
    totalVolumeKg: totalVolumeKg.present
        ? totalVolumeKg.value
        : this.totalVolumeKg,
  );
  WorkoutSession copyWithCompanion(WorkoutSessionsCompanion data) {
    return WorkoutSession(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      programDayId: data.programDayId.present
          ? data.programDayId.value
          : this.programDayId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      duration: data.duration.present ? data.duration.value : this.duration,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      totalVolumeKg: data.totalVolumeKg.present
          ? data.totalVolumeKg.value
          : this.totalVolumeKg,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSession(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('programDayId: $programDayId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('duration: $duration, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('totalVolumeKg: $totalVolumeKg')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    programDayId,
    startedAt,
    completedAt,
    duration,
    status,
    notes,
    totalVolumeKg,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSession &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.programDayId == this.programDayId &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.duration == this.duration &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.totalVolumeKg == this.totalVolumeKg);
}

class WorkoutSessionsCompanion extends UpdateCompanion<WorkoutSession> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> programDayId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<int?> duration;
  final Value<WorkoutStatus> status;
  final Value<String?> notes;
  final Value<double?> totalVolumeKg;
  final Value<int> rowid;
  const WorkoutSessionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.programDayId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.duration = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.totalVolumeKg = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSessionsCompanion.insert({
    required String id,
    required String userId,
    required String programDayId,
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    this.duration = const Value.absent(),
    required WorkoutStatus status,
    this.notes = const Value.absent(),
    this.totalVolumeKg = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       programDayId = Value(programDayId),
       startedAt = Value(startedAt),
       status = Value(status);
  static Insertable<WorkoutSession> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? programDayId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? duration,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<double>? totalVolumeKg,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (programDayId != null) 'program_day_id': programDayId,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (duration != null) 'duration': duration,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (totalVolumeKg != null) 'total_volume_kg': totalVolumeKg,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? programDayId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? completedAt,
    Value<int?>? duration,
    Value<WorkoutStatus>? status,
    Value<String?>? notes,
    Value<double?>? totalVolumeKg,
    Value<int>? rowid,
  }) {
    return WorkoutSessionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      programDayId: programDayId ?? this.programDayId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      totalVolumeKg: totalVolumeKg ?? this.totalVolumeKg,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (programDayId.present) {
      map['program_day_id'] = Variable<String>(programDayId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $WorkoutSessionsTable.$converterstatus.toSql(status.value),
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (totalVolumeKg.present) {
      map['total_volume_kg'] = Variable<double>(totalVolumeKg.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('programDayId: $programDayId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('duration: $duration, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('totalVolumeKg: $totalVolumeKg, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutExerciseResultsTable extends WorkoutExerciseResults
    with TableInfo<$WorkoutExerciseResultsTable, WorkoutExerciseResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutExerciseResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workoutSessionIdMeta = const VerificationMeta(
    'workoutSessionId',
  );
  @override
  late final GeneratedColumn<String> workoutSessionId = GeneratedColumn<String>(
    'workout_session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_sessions (id)',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id)',
    ),
  );
  static const VerificationMeta _programExerciseIdMeta = const VerificationMeta(
    'programExerciseId',
  );
  @override
  late final GeneratedColumn<String> programExerciseId =
      GeneratedColumn<String>(
        'program_exercise_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES program_exercises (id)',
        ),
      );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plannedSetsMeta = const VerificationMeta(
    'plannedSets',
  );
  @override
  late final GeneratedColumn<int> plannedSets = GeneratedColumn<int>(
    'planned_sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualSetsMeta = const VerificationMeta(
    'actualSets',
  );
  @override
  late final GeneratedColumn<int> actualSets = GeneratedColumn<int>(
    'actual_sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _plannedRepetitionsMeta =
      const VerificationMeta('plannedRepetitions');
  @override
  late final GeneratedColumn<int> plannedRepetitions = GeneratedColumn<int>(
    'planned_repetitions',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actualRepetitionsMeta = const VerificationMeta(
    'actualRepetitions',
  );
  @override
  late final GeneratedColumn<int> actualRepetitions = GeneratedColumn<int>(
    'actual_repetitions',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plannedDurationMeta = const VerificationMeta(
    'plannedDuration',
  );
  @override
  late final GeneratedColumn<int> plannedDuration = GeneratedColumn<int>(
    'planned_duration',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actualDurationMeta = const VerificationMeta(
    'actualDuration',
  );
  @override
  late final GeneratedColumn<int> actualDuration = GeneratedColumn<int>(
    'actual_duration',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumnWithTypeConverter<PerceivedEffort?, String> effort =
      GeneratedColumn<String>(
        'effort',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<PerceivedEffort?>(
        $WorkoutExerciseResultsTable.$convertereffortn,
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _personalRecordMeta = const VerificationMeta(
    'personalRecord',
  );
  @override
  late final GeneratedColumn<bool> personalRecord = GeneratedColumn<bool>(
    'personal_record',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("personal_record" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workoutSessionId,
    exerciseId,
    programExerciseId,
    sortOrder,
    plannedSets,
    actualSets,
    plannedRepetitions,
    actualRepetitions,
    plannedDuration,
    actualDuration,
    completed,
    effort,
    notes,
    personalRecord,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_exercise_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutExerciseResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workout_session_id')) {
      context.handle(
        _workoutSessionIdMeta,
        workoutSessionId.isAcceptableOrUnknown(
          data['workout_session_id']!,
          _workoutSessionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workoutSessionIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('program_exercise_id')) {
      context.handle(
        _programExerciseIdMeta,
        programExerciseId.isAcceptableOrUnknown(
          data['program_exercise_id']!,
          _programExerciseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_programExerciseIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('planned_sets')) {
      context.handle(
        _plannedSetsMeta,
        plannedSets.isAcceptableOrUnknown(
          data['planned_sets']!,
          _plannedSetsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedSetsMeta);
    }
    if (data.containsKey('actual_sets')) {
      context.handle(
        _actualSetsMeta,
        actualSets.isAcceptableOrUnknown(data['actual_sets']!, _actualSetsMeta),
      );
    }
    if (data.containsKey('planned_repetitions')) {
      context.handle(
        _plannedRepetitionsMeta,
        plannedRepetitions.isAcceptableOrUnknown(
          data['planned_repetitions']!,
          _plannedRepetitionsMeta,
        ),
      );
    }
    if (data.containsKey('actual_repetitions')) {
      context.handle(
        _actualRepetitionsMeta,
        actualRepetitions.isAcceptableOrUnknown(
          data['actual_repetitions']!,
          _actualRepetitionsMeta,
        ),
      );
    }
    if (data.containsKey('planned_duration')) {
      context.handle(
        _plannedDurationMeta,
        plannedDuration.isAcceptableOrUnknown(
          data['planned_duration']!,
          _plannedDurationMeta,
        ),
      );
    }
    if (data.containsKey('actual_duration')) {
      context.handle(
        _actualDurationMeta,
        actualDuration.isAcceptableOrUnknown(
          data['actual_duration']!,
          _actualDurationMeta,
        ),
      );
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('personal_record')) {
      context.handle(
        _personalRecordMeta,
        personalRecord.isAcceptableOrUnknown(
          data['personal_record']!,
          _personalRecordMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutExerciseResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutExerciseResult(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workoutSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_session_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      programExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}program_exercise_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      plannedSets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_sets'],
      )!,
      actualSets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_sets'],
      )!,
      plannedRepetitions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_repetitions'],
      ),
      actualRepetitions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_repetitions'],
      ),
      plannedDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_duration'],
      ),
      actualDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_duration'],
      ),
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      effort: $WorkoutExerciseResultsTable.$convertereffortn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}effort'],
        ),
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      personalRecord: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}personal_record'],
      )!,
    );
  }

  @override
  $WorkoutExerciseResultsTable createAlias(String alias) {
    return $WorkoutExerciseResultsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PerceivedEffort, String, String> $convertereffort =
      const EnumNameConverter<PerceivedEffort>(PerceivedEffort.values);
  static JsonTypeConverter2<PerceivedEffort?, String?, String?>
  $convertereffortn = JsonTypeConverter2.asNullable($convertereffort);
}

class WorkoutExerciseResult extends DataClass
    implements Insertable<WorkoutExerciseResult> {
  final String id;
  final String workoutSessionId;
  final String exerciseId;
  final String programExerciseId;
  final int sortOrder;
  final int plannedSets;
  final int actualSets;
  final int? plannedRepetitions;
  final int? actualRepetitions;
  final int? plannedDuration;
  final int? actualDuration;
  final bool completed;
  final PerceivedEffort? effort;
  final String? notes;
  final bool personalRecord;
  const WorkoutExerciseResult({
    required this.id,
    required this.workoutSessionId,
    required this.exerciseId,
    required this.programExerciseId,
    required this.sortOrder,
    required this.plannedSets,
    required this.actualSets,
    this.plannedRepetitions,
    this.actualRepetitions,
    this.plannedDuration,
    this.actualDuration,
    required this.completed,
    this.effort,
    this.notes,
    required this.personalRecord,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workout_session_id'] = Variable<String>(workoutSessionId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['program_exercise_id'] = Variable<String>(programExerciseId);
    map['sort_order'] = Variable<int>(sortOrder);
    map['planned_sets'] = Variable<int>(plannedSets);
    map['actual_sets'] = Variable<int>(actualSets);
    if (!nullToAbsent || plannedRepetitions != null) {
      map['planned_repetitions'] = Variable<int>(plannedRepetitions);
    }
    if (!nullToAbsent || actualRepetitions != null) {
      map['actual_repetitions'] = Variable<int>(actualRepetitions);
    }
    if (!nullToAbsent || plannedDuration != null) {
      map['planned_duration'] = Variable<int>(plannedDuration);
    }
    if (!nullToAbsent || actualDuration != null) {
      map['actual_duration'] = Variable<int>(actualDuration);
    }
    map['completed'] = Variable<bool>(completed);
    if (!nullToAbsent || effort != null) {
      map['effort'] = Variable<String>(
        $WorkoutExerciseResultsTable.$convertereffortn.toSql(effort),
      );
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['personal_record'] = Variable<bool>(personalRecord);
    return map;
  }

  WorkoutExerciseResultsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutExerciseResultsCompanion(
      id: Value(id),
      workoutSessionId: Value(workoutSessionId),
      exerciseId: Value(exerciseId),
      programExerciseId: Value(programExerciseId),
      sortOrder: Value(sortOrder),
      plannedSets: Value(plannedSets),
      actualSets: Value(actualSets),
      plannedRepetitions: plannedRepetitions == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedRepetitions),
      actualRepetitions: actualRepetitions == null && nullToAbsent
          ? const Value.absent()
          : Value(actualRepetitions),
      plannedDuration: plannedDuration == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedDuration),
      actualDuration: actualDuration == null && nullToAbsent
          ? const Value.absent()
          : Value(actualDuration),
      completed: Value(completed),
      effort: effort == null && nullToAbsent
          ? const Value.absent()
          : Value(effort),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      personalRecord: Value(personalRecord),
    );
  }

  factory WorkoutExerciseResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutExerciseResult(
      id: serializer.fromJson<String>(json['id']),
      workoutSessionId: serializer.fromJson<String>(json['workoutSessionId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      programExerciseId: serializer.fromJson<String>(json['programExerciseId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      plannedSets: serializer.fromJson<int>(json['plannedSets']),
      actualSets: serializer.fromJson<int>(json['actualSets']),
      plannedRepetitions: serializer.fromJson<int?>(json['plannedRepetitions']),
      actualRepetitions: serializer.fromJson<int?>(json['actualRepetitions']),
      plannedDuration: serializer.fromJson<int?>(json['plannedDuration']),
      actualDuration: serializer.fromJson<int?>(json['actualDuration']),
      completed: serializer.fromJson<bool>(json['completed']),
      effort: $WorkoutExerciseResultsTable.$convertereffortn.fromJson(
        serializer.fromJson<String?>(json['effort']),
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      personalRecord: serializer.fromJson<bool>(json['personalRecord']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workoutSessionId': serializer.toJson<String>(workoutSessionId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'programExerciseId': serializer.toJson<String>(programExerciseId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'plannedSets': serializer.toJson<int>(plannedSets),
      'actualSets': serializer.toJson<int>(actualSets),
      'plannedRepetitions': serializer.toJson<int?>(plannedRepetitions),
      'actualRepetitions': serializer.toJson<int?>(actualRepetitions),
      'plannedDuration': serializer.toJson<int?>(plannedDuration),
      'actualDuration': serializer.toJson<int?>(actualDuration),
      'completed': serializer.toJson<bool>(completed),
      'effort': serializer.toJson<String?>(
        $WorkoutExerciseResultsTable.$convertereffortn.toJson(effort),
      ),
      'notes': serializer.toJson<String?>(notes),
      'personalRecord': serializer.toJson<bool>(personalRecord),
    };
  }

  WorkoutExerciseResult copyWith({
    String? id,
    String? workoutSessionId,
    String? exerciseId,
    String? programExerciseId,
    int? sortOrder,
    int? plannedSets,
    int? actualSets,
    Value<int?> plannedRepetitions = const Value.absent(),
    Value<int?> actualRepetitions = const Value.absent(),
    Value<int?> plannedDuration = const Value.absent(),
    Value<int?> actualDuration = const Value.absent(),
    bool? completed,
    Value<PerceivedEffort?> effort = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? personalRecord,
  }) => WorkoutExerciseResult(
    id: id ?? this.id,
    workoutSessionId: workoutSessionId ?? this.workoutSessionId,
    exerciseId: exerciseId ?? this.exerciseId,
    programExerciseId: programExerciseId ?? this.programExerciseId,
    sortOrder: sortOrder ?? this.sortOrder,
    plannedSets: plannedSets ?? this.plannedSets,
    actualSets: actualSets ?? this.actualSets,
    plannedRepetitions: plannedRepetitions.present
        ? plannedRepetitions.value
        : this.plannedRepetitions,
    actualRepetitions: actualRepetitions.present
        ? actualRepetitions.value
        : this.actualRepetitions,
    plannedDuration: plannedDuration.present
        ? plannedDuration.value
        : this.plannedDuration,
    actualDuration: actualDuration.present
        ? actualDuration.value
        : this.actualDuration,
    completed: completed ?? this.completed,
    effort: effort.present ? effort.value : this.effort,
    notes: notes.present ? notes.value : this.notes,
    personalRecord: personalRecord ?? this.personalRecord,
  );
  WorkoutExerciseResult copyWithCompanion(
    WorkoutExerciseResultsCompanion data,
  ) {
    return WorkoutExerciseResult(
      id: data.id.present ? data.id.value : this.id,
      workoutSessionId: data.workoutSessionId.present
          ? data.workoutSessionId.value
          : this.workoutSessionId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      programExerciseId: data.programExerciseId.present
          ? data.programExerciseId.value
          : this.programExerciseId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      plannedSets: data.plannedSets.present
          ? data.plannedSets.value
          : this.plannedSets,
      actualSets: data.actualSets.present
          ? data.actualSets.value
          : this.actualSets,
      plannedRepetitions: data.plannedRepetitions.present
          ? data.plannedRepetitions.value
          : this.plannedRepetitions,
      actualRepetitions: data.actualRepetitions.present
          ? data.actualRepetitions.value
          : this.actualRepetitions,
      plannedDuration: data.plannedDuration.present
          ? data.plannedDuration.value
          : this.plannedDuration,
      actualDuration: data.actualDuration.present
          ? data.actualDuration.value
          : this.actualDuration,
      completed: data.completed.present ? data.completed.value : this.completed,
      effort: data.effort.present ? data.effort.value : this.effort,
      notes: data.notes.present ? data.notes.value : this.notes,
      personalRecord: data.personalRecord.present
          ? data.personalRecord.value
          : this.personalRecord,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExerciseResult(')
          ..write('id: $id, ')
          ..write('workoutSessionId: $workoutSessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('programExerciseId: $programExerciseId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('plannedSets: $plannedSets, ')
          ..write('actualSets: $actualSets, ')
          ..write('plannedRepetitions: $plannedRepetitions, ')
          ..write('actualRepetitions: $actualRepetitions, ')
          ..write('plannedDuration: $plannedDuration, ')
          ..write('actualDuration: $actualDuration, ')
          ..write('completed: $completed, ')
          ..write('effort: $effort, ')
          ..write('notes: $notes, ')
          ..write('personalRecord: $personalRecord')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workoutSessionId,
    exerciseId,
    programExerciseId,
    sortOrder,
    plannedSets,
    actualSets,
    plannedRepetitions,
    actualRepetitions,
    plannedDuration,
    actualDuration,
    completed,
    effort,
    notes,
    personalRecord,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutExerciseResult &&
          other.id == this.id &&
          other.workoutSessionId == this.workoutSessionId &&
          other.exerciseId == this.exerciseId &&
          other.programExerciseId == this.programExerciseId &&
          other.sortOrder == this.sortOrder &&
          other.plannedSets == this.plannedSets &&
          other.actualSets == this.actualSets &&
          other.plannedRepetitions == this.plannedRepetitions &&
          other.actualRepetitions == this.actualRepetitions &&
          other.plannedDuration == this.plannedDuration &&
          other.actualDuration == this.actualDuration &&
          other.completed == this.completed &&
          other.effort == this.effort &&
          other.notes == this.notes &&
          other.personalRecord == this.personalRecord);
}

class WorkoutExerciseResultsCompanion
    extends UpdateCompanion<WorkoutExerciseResult> {
  final Value<String> id;
  final Value<String> workoutSessionId;
  final Value<String> exerciseId;
  final Value<String> programExerciseId;
  final Value<int> sortOrder;
  final Value<int> plannedSets;
  final Value<int> actualSets;
  final Value<int?> plannedRepetitions;
  final Value<int?> actualRepetitions;
  final Value<int?> plannedDuration;
  final Value<int?> actualDuration;
  final Value<bool> completed;
  final Value<PerceivedEffort?> effort;
  final Value<String?> notes;
  final Value<bool> personalRecord;
  final Value<int> rowid;
  const WorkoutExerciseResultsCompanion({
    this.id = const Value.absent(),
    this.workoutSessionId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.programExerciseId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.plannedSets = const Value.absent(),
    this.actualSets = const Value.absent(),
    this.plannedRepetitions = const Value.absent(),
    this.actualRepetitions = const Value.absent(),
    this.plannedDuration = const Value.absent(),
    this.actualDuration = const Value.absent(),
    this.completed = const Value.absent(),
    this.effort = const Value.absent(),
    this.notes = const Value.absent(),
    this.personalRecord = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutExerciseResultsCompanion.insert({
    required String id,
    required String workoutSessionId,
    required String exerciseId,
    required String programExerciseId,
    required int sortOrder,
    required int plannedSets,
    this.actualSets = const Value.absent(),
    this.plannedRepetitions = const Value.absent(),
    this.actualRepetitions = const Value.absent(),
    this.plannedDuration = const Value.absent(),
    this.actualDuration = const Value.absent(),
    this.completed = const Value.absent(),
    this.effort = const Value.absent(),
    this.notes = const Value.absent(),
    this.personalRecord = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workoutSessionId = Value(workoutSessionId),
       exerciseId = Value(exerciseId),
       programExerciseId = Value(programExerciseId),
       sortOrder = Value(sortOrder),
       plannedSets = Value(plannedSets);
  static Insertable<WorkoutExerciseResult> custom({
    Expression<String>? id,
    Expression<String>? workoutSessionId,
    Expression<String>? exerciseId,
    Expression<String>? programExerciseId,
    Expression<int>? sortOrder,
    Expression<int>? plannedSets,
    Expression<int>? actualSets,
    Expression<int>? plannedRepetitions,
    Expression<int>? actualRepetitions,
    Expression<int>? plannedDuration,
    Expression<int>? actualDuration,
    Expression<bool>? completed,
    Expression<String>? effort,
    Expression<String>? notes,
    Expression<bool>? personalRecord,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutSessionId != null) 'workout_session_id': workoutSessionId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (programExerciseId != null) 'program_exercise_id': programExerciseId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (plannedSets != null) 'planned_sets': plannedSets,
      if (actualSets != null) 'actual_sets': actualSets,
      if (plannedRepetitions != null) 'planned_repetitions': plannedRepetitions,
      if (actualRepetitions != null) 'actual_repetitions': actualRepetitions,
      if (plannedDuration != null) 'planned_duration': plannedDuration,
      if (actualDuration != null) 'actual_duration': actualDuration,
      if (completed != null) 'completed': completed,
      if (effort != null) 'effort': effort,
      if (notes != null) 'notes': notes,
      if (personalRecord != null) 'personal_record': personalRecord,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutExerciseResultsCompanion copyWith({
    Value<String>? id,
    Value<String>? workoutSessionId,
    Value<String>? exerciseId,
    Value<String>? programExerciseId,
    Value<int>? sortOrder,
    Value<int>? plannedSets,
    Value<int>? actualSets,
    Value<int?>? plannedRepetitions,
    Value<int?>? actualRepetitions,
    Value<int?>? plannedDuration,
    Value<int?>? actualDuration,
    Value<bool>? completed,
    Value<PerceivedEffort?>? effort,
    Value<String?>? notes,
    Value<bool>? personalRecord,
    Value<int>? rowid,
  }) {
    return WorkoutExerciseResultsCompanion(
      id: id ?? this.id,
      workoutSessionId: workoutSessionId ?? this.workoutSessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      programExerciseId: programExerciseId ?? this.programExerciseId,
      sortOrder: sortOrder ?? this.sortOrder,
      plannedSets: plannedSets ?? this.plannedSets,
      actualSets: actualSets ?? this.actualSets,
      plannedRepetitions: plannedRepetitions ?? this.plannedRepetitions,
      actualRepetitions: actualRepetitions ?? this.actualRepetitions,
      plannedDuration: plannedDuration ?? this.plannedDuration,
      actualDuration: actualDuration ?? this.actualDuration,
      completed: completed ?? this.completed,
      effort: effort ?? this.effort,
      notes: notes ?? this.notes,
      personalRecord: personalRecord ?? this.personalRecord,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workoutSessionId.present) {
      map['workout_session_id'] = Variable<String>(workoutSessionId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (programExerciseId.present) {
      map['program_exercise_id'] = Variable<String>(programExerciseId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (plannedSets.present) {
      map['planned_sets'] = Variable<int>(plannedSets.value);
    }
    if (actualSets.present) {
      map['actual_sets'] = Variable<int>(actualSets.value);
    }
    if (plannedRepetitions.present) {
      map['planned_repetitions'] = Variable<int>(plannedRepetitions.value);
    }
    if (actualRepetitions.present) {
      map['actual_repetitions'] = Variable<int>(actualRepetitions.value);
    }
    if (plannedDuration.present) {
      map['planned_duration'] = Variable<int>(plannedDuration.value);
    }
    if (actualDuration.present) {
      map['actual_duration'] = Variable<int>(actualDuration.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (effort.present) {
      map['effort'] = Variable<String>(
        $WorkoutExerciseResultsTable.$convertereffortn.toSql(effort.value),
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (personalRecord.present) {
      map['personal_record'] = Variable<bool>(personalRecord.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExerciseResultsCompanion(')
          ..write('id: $id, ')
          ..write('workoutSessionId: $workoutSessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('programExerciseId: $programExerciseId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('plannedSets: $plannedSets, ')
          ..write('actualSets: $actualSets, ')
          ..write('plannedRepetitions: $plannedRepetitions, ')
          ..write('actualRepetitions: $actualRepetitions, ')
          ..write('plannedDuration: $plannedDuration, ')
          ..write('actualDuration: $actualDuration, ')
          ..write('completed: $completed, ')
          ..write('effort: $effort, ')
          ..write('notes: $notes, ')
          ..write('personalRecord: $personalRecord, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSetResultsTable extends WorkoutSetResults
    with TableInfo<$WorkoutSetResultsTable, WorkoutSetResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSetResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workoutExerciseResultIdMeta =
      const VerificationMeta('workoutExerciseResultId');
  @override
  late final GeneratedColumn<String> workoutExerciseResultId =
      GeneratedColumn<String>(
        'workout_exercise_result_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES workout_exercise_results (id)',
        ),
      );
  static const VerificationMeta _setNumberMeta = const VerificationMeta(
    'setNumber',
  );
  @override
  late final GeneratedColumn<int> setNumber = GeneratedColumn<int>(
    'set_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plannedRepsMeta = const VerificationMeta(
    'plannedReps',
  );
  @override
  late final GeneratedColumn<int> plannedReps = GeneratedColumn<int>(
    'planned_reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actualRepsMeta = const VerificationMeta(
    'actualReps',
  );
  @override
  late final GeneratedColumn<int> actualReps = GeneratedColumn<int>(
    'actual_reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plannedDurationMeta = const VerificationMeta(
    'plannedDuration',
  );
  @override
  late final GeneratedColumn<int> plannedDuration = GeneratedColumn<int>(
    'planned_duration',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actualDurationMeta = const VerificationMeta(
    'actualDuration',
  );
  @override
  late final GeneratedColumn<int> actualDuration = GeneratedColumn<int>(
    'actual_duration',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plannedLoadKgMeta = const VerificationMeta(
    'plannedLoadKg',
  );
  @override
  late final GeneratedColumn<double> plannedLoadKg = GeneratedColumn<double>(
    'planned_load_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actualLoadKgMeta = const VerificationMeta(
    'actualLoadKg',
  );
  @override
  late final GeneratedColumn<double> actualLoadKg = GeneratedColumn<double>(
    'actual_load_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workoutExerciseResultId,
    setNumber,
    plannedReps,
    actualReps,
    plannedDuration,
    actualDuration,
    plannedLoadKg,
    actualLoadKg,
    completed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_set_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSetResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workout_exercise_result_id')) {
      context.handle(
        _workoutExerciseResultIdMeta,
        workoutExerciseResultId.isAcceptableOrUnknown(
          data['workout_exercise_result_id']!,
          _workoutExerciseResultIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workoutExerciseResultIdMeta);
    }
    if (data.containsKey('set_number')) {
      context.handle(
        _setNumberMeta,
        setNumber.isAcceptableOrUnknown(data['set_number']!, _setNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_setNumberMeta);
    }
    if (data.containsKey('planned_reps')) {
      context.handle(
        _plannedRepsMeta,
        plannedReps.isAcceptableOrUnknown(
          data['planned_reps']!,
          _plannedRepsMeta,
        ),
      );
    }
    if (data.containsKey('actual_reps')) {
      context.handle(
        _actualRepsMeta,
        actualReps.isAcceptableOrUnknown(data['actual_reps']!, _actualRepsMeta),
      );
    }
    if (data.containsKey('planned_duration')) {
      context.handle(
        _plannedDurationMeta,
        plannedDuration.isAcceptableOrUnknown(
          data['planned_duration']!,
          _plannedDurationMeta,
        ),
      );
    }
    if (data.containsKey('actual_duration')) {
      context.handle(
        _actualDurationMeta,
        actualDuration.isAcceptableOrUnknown(
          data['actual_duration']!,
          _actualDurationMeta,
        ),
      );
    }
    if (data.containsKey('planned_load_kg')) {
      context.handle(
        _plannedLoadKgMeta,
        plannedLoadKg.isAcceptableOrUnknown(
          data['planned_load_kg']!,
          _plannedLoadKgMeta,
        ),
      );
    }
    if (data.containsKey('actual_load_kg')) {
      context.handle(
        _actualLoadKgMeta,
        actualLoadKg.isAcceptableOrUnknown(
          data['actual_load_kg']!,
          _actualLoadKgMeta,
        ),
      );
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSetResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSetResult(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workoutExerciseResultId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_exercise_result_id'],
      )!,
      setNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_number'],
      )!,
      plannedReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_reps'],
      ),
      actualReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_reps'],
      ),
      plannedDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_duration'],
      ),
      actualDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_duration'],
      ),
      plannedLoadKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}planned_load_kg'],
      ),
      actualLoadKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}actual_load_kg'],
      ),
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
    );
  }

  @override
  $WorkoutSetResultsTable createAlias(String alias) {
    return $WorkoutSetResultsTable(attachedDatabase, alias);
  }
}

class WorkoutSetResult extends DataClass
    implements Insertable<WorkoutSetResult> {
  final String id;
  final String workoutExerciseResultId;
  final int setNumber;
  final int? plannedReps;
  final int? actualReps;
  final int? plannedDuration;
  final int? actualDuration;
  final double? plannedLoadKg;
  final double? actualLoadKg;
  final bool completed;
  const WorkoutSetResult({
    required this.id,
    required this.workoutExerciseResultId,
    required this.setNumber,
    this.plannedReps,
    this.actualReps,
    this.plannedDuration,
    this.actualDuration,
    this.plannedLoadKg,
    this.actualLoadKg,
    required this.completed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workout_exercise_result_id'] = Variable<String>(
      workoutExerciseResultId,
    );
    map['set_number'] = Variable<int>(setNumber);
    if (!nullToAbsent || plannedReps != null) {
      map['planned_reps'] = Variable<int>(plannedReps);
    }
    if (!nullToAbsent || actualReps != null) {
      map['actual_reps'] = Variable<int>(actualReps);
    }
    if (!nullToAbsent || plannedDuration != null) {
      map['planned_duration'] = Variable<int>(plannedDuration);
    }
    if (!nullToAbsent || actualDuration != null) {
      map['actual_duration'] = Variable<int>(actualDuration);
    }
    if (!nullToAbsent || plannedLoadKg != null) {
      map['planned_load_kg'] = Variable<double>(plannedLoadKg);
    }
    if (!nullToAbsent || actualLoadKg != null) {
      map['actual_load_kg'] = Variable<double>(actualLoadKg);
    }
    map['completed'] = Variable<bool>(completed);
    return map;
  }

  WorkoutSetResultsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSetResultsCompanion(
      id: Value(id),
      workoutExerciseResultId: Value(workoutExerciseResultId),
      setNumber: Value(setNumber),
      plannedReps: plannedReps == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedReps),
      actualReps: actualReps == null && nullToAbsent
          ? const Value.absent()
          : Value(actualReps),
      plannedDuration: plannedDuration == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedDuration),
      actualDuration: actualDuration == null && nullToAbsent
          ? const Value.absent()
          : Value(actualDuration),
      plannedLoadKg: plannedLoadKg == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedLoadKg),
      actualLoadKg: actualLoadKg == null && nullToAbsent
          ? const Value.absent()
          : Value(actualLoadKg),
      completed: Value(completed),
    );
  }

  factory WorkoutSetResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSetResult(
      id: serializer.fromJson<String>(json['id']),
      workoutExerciseResultId: serializer.fromJson<String>(
        json['workoutExerciseResultId'],
      ),
      setNumber: serializer.fromJson<int>(json['setNumber']),
      plannedReps: serializer.fromJson<int?>(json['plannedReps']),
      actualReps: serializer.fromJson<int?>(json['actualReps']),
      plannedDuration: serializer.fromJson<int?>(json['plannedDuration']),
      actualDuration: serializer.fromJson<int?>(json['actualDuration']),
      plannedLoadKg: serializer.fromJson<double?>(json['plannedLoadKg']),
      actualLoadKg: serializer.fromJson<double?>(json['actualLoadKg']),
      completed: serializer.fromJson<bool>(json['completed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workoutExerciseResultId': serializer.toJson<String>(
        workoutExerciseResultId,
      ),
      'setNumber': serializer.toJson<int>(setNumber),
      'plannedReps': serializer.toJson<int?>(plannedReps),
      'actualReps': serializer.toJson<int?>(actualReps),
      'plannedDuration': serializer.toJson<int?>(plannedDuration),
      'actualDuration': serializer.toJson<int?>(actualDuration),
      'plannedLoadKg': serializer.toJson<double?>(plannedLoadKg),
      'actualLoadKg': serializer.toJson<double?>(actualLoadKg),
      'completed': serializer.toJson<bool>(completed),
    };
  }

  WorkoutSetResult copyWith({
    String? id,
    String? workoutExerciseResultId,
    int? setNumber,
    Value<int?> plannedReps = const Value.absent(),
    Value<int?> actualReps = const Value.absent(),
    Value<int?> plannedDuration = const Value.absent(),
    Value<int?> actualDuration = const Value.absent(),
    Value<double?> plannedLoadKg = const Value.absent(),
    Value<double?> actualLoadKg = const Value.absent(),
    bool? completed,
  }) => WorkoutSetResult(
    id: id ?? this.id,
    workoutExerciseResultId:
        workoutExerciseResultId ?? this.workoutExerciseResultId,
    setNumber: setNumber ?? this.setNumber,
    plannedReps: plannedReps.present ? plannedReps.value : this.plannedReps,
    actualReps: actualReps.present ? actualReps.value : this.actualReps,
    plannedDuration: plannedDuration.present
        ? plannedDuration.value
        : this.plannedDuration,
    actualDuration: actualDuration.present
        ? actualDuration.value
        : this.actualDuration,
    plannedLoadKg: plannedLoadKg.present
        ? plannedLoadKg.value
        : this.plannedLoadKg,
    actualLoadKg: actualLoadKg.present ? actualLoadKg.value : this.actualLoadKg,
    completed: completed ?? this.completed,
  );
  WorkoutSetResult copyWithCompanion(WorkoutSetResultsCompanion data) {
    return WorkoutSetResult(
      id: data.id.present ? data.id.value : this.id,
      workoutExerciseResultId: data.workoutExerciseResultId.present
          ? data.workoutExerciseResultId.value
          : this.workoutExerciseResultId,
      setNumber: data.setNumber.present ? data.setNumber.value : this.setNumber,
      plannedReps: data.plannedReps.present
          ? data.plannedReps.value
          : this.plannedReps,
      actualReps: data.actualReps.present
          ? data.actualReps.value
          : this.actualReps,
      plannedDuration: data.plannedDuration.present
          ? data.plannedDuration.value
          : this.plannedDuration,
      actualDuration: data.actualDuration.present
          ? data.actualDuration.value
          : this.actualDuration,
      plannedLoadKg: data.plannedLoadKg.present
          ? data.plannedLoadKg.value
          : this.plannedLoadKg,
      actualLoadKg: data.actualLoadKg.present
          ? data.actualLoadKg.value
          : this.actualLoadKg,
      completed: data.completed.present ? data.completed.value : this.completed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetResult(')
          ..write('id: $id, ')
          ..write('workoutExerciseResultId: $workoutExerciseResultId, ')
          ..write('setNumber: $setNumber, ')
          ..write('plannedReps: $plannedReps, ')
          ..write('actualReps: $actualReps, ')
          ..write('plannedDuration: $plannedDuration, ')
          ..write('actualDuration: $actualDuration, ')
          ..write('plannedLoadKg: $plannedLoadKg, ')
          ..write('actualLoadKg: $actualLoadKg, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workoutExerciseResultId,
    setNumber,
    plannedReps,
    actualReps,
    plannedDuration,
    actualDuration,
    plannedLoadKg,
    actualLoadKg,
    completed,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSetResult &&
          other.id == this.id &&
          other.workoutExerciseResultId == this.workoutExerciseResultId &&
          other.setNumber == this.setNumber &&
          other.plannedReps == this.plannedReps &&
          other.actualReps == this.actualReps &&
          other.plannedDuration == this.plannedDuration &&
          other.actualDuration == this.actualDuration &&
          other.plannedLoadKg == this.plannedLoadKg &&
          other.actualLoadKg == this.actualLoadKg &&
          other.completed == this.completed);
}

class WorkoutSetResultsCompanion extends UpdateCompanion<WorkoutSetResult> {
  final Value<String> id;
  final Value<String> workoutExerciseResultId;
  final Value<int> setNumber;
  final Value<int?> plannedReps;
  final Value<int?> actualReps;
  final Value<int?> plannedDuration;
  final Value<int?> actualDuration;
  final Value<double?> plannedLoadKg;
  final Value<double?> actualLoadKg;
  final Value<bool> completed;
  final Value<int> rowid;
  const WorkoutSetResultsCompanion({
    this.id = const Value.absent(),
    this.workoutExerciseResultId = const Value.absent(),
    this.setNumber = const Value.absent(),
    this.plannedReps = const Value.absent(),
    this.actualReps = const Value.absent(),
    this.plannedDuration = const Value.absent(),
    this.actualDuration = const Value.absent(),
    this.plannedLoadKg = const Value.absent(),
    this.actualLoadKg = const Value.absent(),
    this.completed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSetResultsCompanion.insert({
    required String id,
    required String workoutExerciseResultId,
    required int setNumber,
    this.plannedReps = const Value.absent(),
    this.actualReps = const Value.absent(),
    this.plannedDuration = const Value.absent(),
    this.actualDuration = const Value.absent(),
    this.plannedLoadKg = const Value.absent(),
    this.actualLoadKg = const Value.absent(),
    this.completed = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workoutExerciseResultId = Value(workoutExerciseResultId),
       setNumber = Value(setNumber);
  static Insertable<WorkoutSetResult> custom({
    Expression<String>? id,
    Expression<String>? workoutExerciseResultId,
    Expression<int>? setNumber,
    Expression<int>? plannedReps,
    Expression<int>? actualReps,
    Expression<int>? plannedDuration,
    Expression<int>? actualDuration,
    Expression<double>? plannedLoadKg,
    Expression<double>? actualLoadKg,
    Expression<bool>? completed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutExerciseResultId != null)
        'workout_exercise_result_id': workoutExerciseResultId,
      if (setNumber != null) 'set_number': setNumber,
      if (plannedReps != null) 'planned_reps': plannedReps,
      if (actualReps != null) 'actual_reps': actualReps,
      if (plannedDuration != null) 'planned_duration': plannedDuration,
      if (actualDuration != null) 'actual_duration': actualDuration,
      if (plannedLoadKg != null) 'planned_load_kg': plannedLoadKg,
      if (actualLoadKg != null) 'actual_load_kg': actualLoadKg,
      if (completed != null) 'completed': completed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSetResultsCompanion copyWith({
    Value<String>? id,
    Value<String>? workoutExerciseResultId,
    Value<int>? setNumber,
    Value<int?>? plannedReps,
    Value<int?>? actualReps,
    Value<int?>? plannedDuration,
    Value<int?>? actualDuration,
    Value<double?>? plannedLoadKg,
    Value<double?>? actualLoadKg,
    Value<bool>? completed,
    Value<int>? rowid,
  }) {
    return WorkoutSetResultsCompanion(
      id: id ?? this.id,
      workoutExerciseResultId:
          workoutExerciseResultId ?? this.workoutExerciseResultId,
      setNumber: setNumber ?? this.setNumber,
      plannedReps: plannedReps ?? this.plannedReps,
      actualReps: actualReps ?? this.actualReps,
      plannedDuration: plannedDuration ?? this.plannedDuration,
      actualDuration: actualDuration ?? this.actualDuration,
      plannedLoadKg: plannedLoadKg ?? this.plannedLoadKg,
      actualLoadKg: actualLoadKg ?? this.actualLoadKg,
      completed: completed ?? this.completed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workoutExerciseResultId.present) {
      map['workout_exercise_result_id'] = Variable<String>(
        workoutExerciseResultId.value,
      );
    }
    if (setNumber.present) {
      map['set_number'] = Variable<int>(setNumber.value);
    }
    if (plannedReps.present) {
      map['planned_reps'] = Variable<int>(plannedReps.value);
    }
    if (actualReps.present) {
      map['actual_reps'] = Variable<int>(actualReps.value);
    }
    if (plannedDuration.present) {
      map['planned_duration'] = Variable<int>(plannedDuration.value);
    }
    if (actualDuration.present) {
      map['actual_duration'] = Variable<int>(actualDuration.value);
    }
    if (plannedLoadKg.present) {
      map['planned_load_kg'] = Variable<double>(plannedLoadKg.value);
    }
    if (actualLoadKg.present) {
      map['actual_load_kg'] = Variable<double>(actualLoadKg.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetResultsCompanion(')
          ..write('id: $id, ')
          ..write('workoutExerciseResultId: $workoutExerciseResultId, ')
          ..write('setNumber: $setNumber, ')
          ..write('plannedReps: $plannedReps, ')
          ..write('actualReps: $actualReps, ')
          ..write('plannedDuration: $plannedDuration, ')
          ..write('actualDuration: $actualDuration, ')
          ..write('plannedLoadKg: $plannedLoadKg, ')
          ..write('actualLoadKg: $actualLoadKg, ')
          ..write('completed: $completed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $TrainingProgramsTable trainingPrograms = $TrainingProgramsTable(
    this,
  );
  late final $ProgramDaysTable programDays = $ProgramDaysTable(this);
  late final $ProgramExercisesTable programExercises = $ProgramExercisesTable(
    this,
  );
  late final $WorkoutSessionsTable workoutSessions = $WorkoutSessionsTable(
    this,
  );
  late final $WorkoutExerciseResultsTable workoutExerciseResults =
      $WorkoutExerciseResultsTable(this);
  late final $WorkoutSetResultsTable workoutSetResults =
      $WorkoutSetResultsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    exercises,
    trainingPrograms,
    programDays,
    programExercises,
    workoutSessions,
    workoutExerciseResults,
    workoutSetResults,
  ];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  required String id,
  required String name,
  Value<String?> email,
  Value<String?> photo,
  Value<DateTime?> birthDate,
  Value<String?> gender,
  required FitnessLevel fitnessLevel,
  required List<FitnessGoal> goals,
  required String language,
  Value<ExerciseVenue> trainingVenue,
  Value<PreferredUnits> preferredUnits,
  Value<int?> defaultRestSeconds,
  Value<bool> active,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> email,
  Value<String?> photo,
  Value<DateTime?> birthDate,
  Value<String?> gender,
  Value<FitnessLevel> fitnessLevel,
  Value<List<FitnessGoal>> goals,
  Value<String> language,
  Value<ExerciseVenue> trainingVenue,
  Value<PreferredUnits> preferredUnits,
  Value<int?> defaultRestSeconds,
  Value<bool> active,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TrainingProgramsTable, List<TrainingProgram>>
  _trainingProgramsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.trainingPrograms,
    aliasName: 'users__id__training_programs__user_id',
  );

  $$TrainingProgramsTableProcessedTableManager get trainingProgramsRefs {
    final manager = $$TrainingProgramsTableTableManager(
      $_db,
      $_db.trainingPrograms,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _trainingProgramsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WorkoutSessionsTable, List<WorkoutSession>>
  _workoutSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSessions,
    aliasName: 'users__id__workout_sessions__user_id',
  );

  $$WorkoutSessionsTableProcessedTableManager get workoutSessionsRefs {
    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutSessionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
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
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photo => $composableBuilder(
    column: $table.photo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<FitnessLevel, FitnessLevel, String>
  get fitnessLevel => $composableBuilder(
    column: $table.fitnessLevel,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<FitnessGoal>, List<FitnessGoal>, String>
  get goals => $composableBuilder(
    column: $table.goals,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ExerciseVenue, ExerciseVenue, String>
  get trainingVenue => $composableBuilder(
    column: $table.trainingVenue,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<PreferredUnits, PreferredUnits, String>
  get preferredUnits => $composableBuilder(
    column: $table.preferredUnits,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get defaultRestSeconds => $composableBuilder(
    column: $table.defaultRestSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
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

  Expression<bool> trainingProgramsRefs(
    Expression<bool> Function($$TrainingProgramsTableFilterComposer f) f,
  ) {
    final $$TrainingProgramsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trainingPrograms,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingProgramsTableFilterComposer(
            $db: $db,
            $table: $db.trainingPrograms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> workoutSessionsRefs(
    Expression<bool> Function($$WorkoutSessionsTableFilterComposer f) f,
  ) {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
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
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photo => $composableBuilder(
    column: $table.photo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fitnessLevel => $composableBuilder(
    column: $table.fitnessLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goals => $composableBuilder(
    column: $table.goals,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trainingVenue => $composableBuilder(
    column: $table.trainingVenue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredUnits => $composableBuilder(
    column: $table.preferredUnits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultRestSeconds => $composableBuilder(
    column: $table.defaultRestSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
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

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get photo =>
      $composableBuilder(column: $table.photo, builder: (column) => column);

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumnWithTypeConverter<FitnessLevel, String> get fitnessLevel =>
      $composableBuilder(
        column: $table.fitnessLevel,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<List<FitnessGoal>, String> get goals =>
      $composableBuilder(column: $table.goals, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ExerciseVenue, String> get trainingVenue =>
      $composableBuilder(
        column: $table.trainingVenue,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<PreferredUnits, String> get preferredUnits =>
      $composableBuilder(
        column: $table.preferredUnits,
        builder: (column) => column,
      );

  GeneratedColumn<int> get defaultRestSeconds => $composableBuilder(
    column: $table.defaultRestSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> trainingProgramsRefs<T extends Object>(
    Expression<T> Function($$TrainingProgramsTableAnnotationComposer a) f,
  ) {
    final $$TrainingProgramsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trainingPrograms,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingProgramsTableAnnotationComposer(
            $db: $db,
            $table: $db.trainingPrograms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> workoutSessionsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSessionsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableTableManager
    extends
        RootTableManager<
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
          PrefetchHooks Function({
            bool trainingProgramsRefs,
            bool workoutSessionsRefs,
          })
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> photo = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<FitnessLevel> fitnessLevel = const Value.absent(),
                Value<List<FitnessGoal>> goals = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<ExerciseVenue> trainingVenue = const Value.absent(),
                Value<PreferredUnits> preferredUnits = const Value.absent(),
                Value<int?> defaultRestSeconds = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                name: name,
                email: email,
                photo: photo,
                birthDate: birthDate,
                gender: gender,
                fitnessLevel: fitnessLevel,
                goals: goals,
                language: language,
                trainingVenue: trainingVenue,
                preferredUnits: preferredUnits,
                defaultRestSeconds: defaultRestSeconds,
                active: active,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> email = const Value.absent(),
                Value<String?> photo = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                required FitnessLevel fitnessLevel,
                required List<FitnessGoal> goals,
                required String language,
                Value<ExerciseVenue> trainingVenue = const Value.absent(),
                Value<PreferredUnits> preferredUnits = const Value.absent(),
                Value<int?> defaultRestSeconds = const Value.absent(),
                Value<bool> active = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                name: name,
                email: email,
                photo: photo,
                birthDate: birthDate,
                gender: gender,
                fitnessLevel: fitnessLevel,
                goals: goals,
                language: language,
                trainingVenue: trainingVenue,
                preferredUnits: preferredUnits,
                defaultRestSeconds: defaultRestSeconds,
                active: active,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UsersTable, User>(table),
                  $$UsersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({trainingProgramsRefs = false, workoutSessionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (trainingProgramsRefs) db.trainingPrograms,
                    if (workoutSessionsRefs) db.workoutSessions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (trainingProgramsRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          TrainingProgram
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._trainingProgramsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).trainingProgramsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (workoutSessionsRefs)
                        await $_getPrefetchedData<
                          User,
                          $UsersTable,
                          WorkoutSession
                        >(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._workoutSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
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

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
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
      PrefetchHooks Function({
        bool trainingProgramsRefs,
        bool workoutSessionsRefs,
      })
    >;
typedef $$ExercisesTableCreateCompanionBuilder = ExercisesCompanion Function({
  required String id,
  required LocalizedText name,
  required LocalizedText description,
  required LocalizedText instructions,
  required String photo,
  required ExerciseCategory category,
  required Difficulty difficulty,
  Value<int?> duration,
  Value<int?> repetitions,
  required List<String> targetMuscles,
  required EquipmentKind equipment,
  required LocalizedText safetyNotes,
  Value<ExerciseVenue> venue,
  Value<int?> gymNumber,
  Value<bool> active,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ExercisesTableUpdateCompanionBuilder = ExercisesCompanion Function({
  Value<String> id,
  Value<LocalizedText> name,
  Value<LocalizedText> description,
  Value<LocalizedText> instructions,
  Value<String> photo,
  Value<ExerciseCategory> category,
  Value<Difficulty> difficulty,
  Value<int?> duration,
  Value<int?> repetitions,
  Value<List<String>> targetMuscles,
  Value<EquipmentKind> equipment,
  Value<LocalizedText> safetyNotes,
  Value<ExerciseVenue> venue,
  Value<int?> gymNumber,
  Value<bool> active,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$ExercisesTableReferences
    extends BaseReferences<_$AppDatabase, $ExercisesTable, Exercise> {
  $$ExercisesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProgramExercisesTable, List<ProgramExercise>>
  _programExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.programExercises,
    aliasName: 'exercises__id__program_exercises__exercise_id',
  );

  $$ProgramExercisesTableProcessedTableManager get programExercisesRefs {
    final manager = $$ProgramExercisesTableTableManager(
      $_db,
      $_db.programExercises,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _programExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $WorkoutExerciseResultsTable,
    List<WorkoutExerciseResult>
  >
  _workoutExerciseResultsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.workoutExerciseResults,
        aliasName: 'exercises__id__workout_exercise_results__exercise_id',
      );

  $$WorkoutExerciseResultsTableProcessedTableManager
  get workoutExerciseResultsRefs {
    final manager = $$WorkoutExerciseResultsTableTableManager(
      $_db,
      $_db.workoutExerciseResults,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutExerciseResultsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
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

  ColumnWithTypeConverterFilters<LocalizedText, LocalizedText, String>
  get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<LocalizedText, LocalizedText, String>
  get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<LocalizedText, LocalizedText, String>
  get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get photo => $composableBuilder(
    column: $table.photo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ExerciseCategory, ExerciseCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<Difficulty, Difficulty, String>
  get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get targetMuscles => $composableBuilder(
    column: $table.targetMuscles,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<EquipmentKind, EquipmentKind, String>
  get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<LocalizedText, LocalizedText, String>
  get safetyNotes => $composableBuilder(
    column: $table.safetyNotes,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<ExerciseVenue, ExerciseVenue, String>
  get venue => $composableBuilder(
    column: $table.venue,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get gymNumber => $composableBuilder(
    column: $table.gymNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
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

  Expression<bool> programExercisesRefs(
    Expression<bool> Function($$ProgramExercisesTableFilterComposer f) f,
  ) {
    final $$ProgramExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.programExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramExercisesTableFilterComposer(
            $db: $db,
            $table: $db.programExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> workoutExerciseResultsRefs(
    Expression<bool> Function($$WorkoutExerciseResultsTableFilterComposer f) f,
  ) {
    final $$WorkoutExerciseResultsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutExerciseResults,
          getReferencedColumn: (t) => t.exerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutExerciseResultsTableFilterComposer(
                $db: $db,
                $table: $db.workoutExerciseResults,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photo => $composableBuilder(
    column: $table.photo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetMuscles => $composableBuilder(
    column: $table.targetMuscles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get safetyNotes => $composableBuilder(
    column: $table.safetyNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get venue => $composableBuilder(
    column: $table.venue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gymNumber => $composableBuilder(
    column: $table.gymNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
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

class $$ExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LocalizedText, String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LocalizedText, String> get description =>
      $composableBuilder(
        column: $table.description,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<LocalizedText, String> get instructions =>
      $composableBuilder(
        column: $table.instructions,
        builder: (column) => column,
      );

  GeneratedColumn<String> get photo =>
      $composableBuilder(column: $table.photo, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ExerciseCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Difficulty, String> get difficulty =>
      $composableBuilder(
        column: $table.difficulty,
        builder: (column) => column,
      );

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get targetMuscles =>
      $composableBuilder(
        column: $table.targetMuscles,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<EquipmentKind, String> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LocalizedText, String> get safetyNotes =>
      $composableBuilder(
        column: $table.safetyNotes,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<ExerciseVenue, String> get venue =>
      $composableBuilder(column: $table.venue, builder: (column) => column);

  GeneratedColumn<int> get gymNumber =>
      $composableBuilder(column: $table.gymNumber, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> programExercisesRefs<T extends Object>(
    Expression<T> Function($$ProgramExercisesTableAnnotationComposer a) f,
  ) {
    final $$ProgramExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.programExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.programExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> workoutExerciseResultsRefs<T extends Object>(
    Expression<T> Function($$WorkoutExerciseResultsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutExerciseResultsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutExerciseResults,
          getReferencedColumn: (t) => t.exerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutExerciseResultsTableAnnotationComposer(
                $db: $db,
                $table: $db.workoutExerciseResults,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExercisesTable,
          Exercise,
          $$ExercisesTableFilterComposer,
          $$ExercisesTableOrderingComposer,
          $$ExercisesTableAnnotationComposer,
          $$ExercisesTableCreateCompanionBuilder,
          $$ExercisesTableUpdateCompanionBuilder,
          (Exercise, $$ExercisesTableReferences),
          Exercise,
          PrefetchHooks Function({
            bool programExercisesRefs,
            bool workoutExerciseResultsRefs,
          })
        > {
  $$ExercisesTableTableManager(_$AppDatabase db, $ExercisesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<LocalizedText> name = const Value.absent(),
                Value<LocalizedText> description = const Value.absent(),
                Value<LocalizedText> instructions = const Value.absent(),
                Value<String> photo = const Value.absent(),
                Value<ExerciseCategory> category = const Value.absent(),
                Value<Difficulty> difficulty = const Value.absent(),
                Value<int?> duration = const Value.absent(),
                Value<int?> repetitions = const Value.absent(),
                Value<List<String>> targetMuscles = const Value.absent(),
                Value<EquipmentKind> equipment = const Value.absent(),
                Value<LocalizedText> safetyNotes = const Value.absent(),
                Value<ExerciseVenue> venue = const Value.absent(),
                Value<int?> gymNumber = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExercisesCompanion(
                id: id,
                name: name,
                description: description,
                instructions: instructions,
                photo: photo,
                category: category,
                difficulty: difficulty,
                duration: duration,
                repetitions: repetitions,
                targetMuscles: targetMuscles,
                equipment: equipment,
                safetyNotes: safetyNotes,
                venue: venue,
                gymNumber: gymNumber,
                active: active,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required LocalizedText name,
                required LocalizedText description,
                required LocalizedText instructions,
                required String photo,
                required ExerciseCategory category,
                required Difficulty difficulty,
                Value<int?> duration = const Value.absent(),
                Value<int?> repetitions = const Value.absent(),
                required List<String> targetMuscles,
                required EquipmentKind equipment,
                required LocalizedText safetyNotes,
                Value<ExerciseVenue> venue = const Value.absent(),
                Value<int?> gymNumber = const Value.absent(),
                Value<bool> active = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ExercisesCompanion.insert(
                id: id,
                name: name,
                description: description,
                instructions: instructions,
                photo: photo,
                category: category,
                difficulty: difficulty,
                duration: duration,
                repetitions: repetitions,
                targetMuscles: targetMuscles,
                equipment: equipment,
                safetyNotes: safetyNotes,
                venue: venue,
                gymNumber: gymNumber,
                active: active,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExercisesTable, Exercise>(table),
                  $$ExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                programExercisesRefs = false,
                workoutExerciseResultsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (programExercisesRefs) db.programExercises,
                    if (workoutExerciseResultsRefs) db.workoutExerciseResults,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (programExercisesRefs)
                        await $_getPrefetchedData<
                          Exercise,
                          $ExercisesTable,
                          ProgramExercise
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._programExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).programExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (workoutExerciseResultsRefs)
                        await $_getPrefetchedData<
                          Exercise,
                          $ExercisesTable,
                          WorkoutExerciseResult
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._workoutExerciseResultsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutExerciseResultsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseId == item.id,
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

typedef $$ExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExercisesTable,
      Exercise,
      $$ExercisesTableFilterComposer,
      $$ExercisesTableOrderingComposer,
      $$ExercisesTableAnnotationComposer,
      $$ExercisesTableCreateCompanionBuilder,
      $$ExercisesTableUpdateCompanionBuilder,
      (Exercise, $$ExercisesTableReferences),
      Exercise,
      PrefetchHooks Function({
        bool programExercisesRefs,
        bool workoutExerciseResultsRefs,
      })
    >;
typedef $$TrainingProgramsTableCreateCompanionBuilder =
    TrainingProgramsCompanion Function({
      required String id,
      required String userId,
      required String name,
      required String description,
      Value<DateTime?> startDate,
      Value<DateTime?> endDate,
      required ScheduleType scheduleType,
      Value<ProgramVenue> venue,
      Value<bool> active,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$TrainingProgramsTableUpdateCompanionBuilder =
    TrainingProgramsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> name,
      Value<String> description,
      Value<DateTime?> startDate,
      Value<DateTime?> endDate,
      Value<ScheduleType> scheduleType,
      Value<ProgramVenue> venue,
      Value<bool> active,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$TrainingProgramsTableReferences
    extends
        BaseReferences<_$AppDatabase, $TrainingProgramsTable, TrainingProgram> {
  $$TrainingProgramsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('training_programs__user_id__users__id');

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ProgramDaysTable, List<ProgramDay>>
  _programDaysRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.programDays,
    aliasName: 'training_programs__id__program_days__program_id',
  );

  $$ProgramDaysTableProcessedTableManager get programDaysRefs {
    final manager = $$ProgramDaysTableTableManager(
      $_db,
      $_db.programDays,
    ).filter((f) => f.programId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_programDaysRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TrainingProgramsTableFilterComposer
    extends Composer<_$AppDatabase, $TrainingProgramsTable> {
  $$TrainingProgramsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ScheduleType, ScheduleType, String>
  get scheduleType => $composableBuilder(
    column: $table.scheduleType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<ProgramVenue, ProgramVenue, String>
  get venue => $composableBuilder(
    column: $table.venue,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
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

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> programDaysRefs(
    Expression<bool> Function($$ProgramDaysTableFilterComposer f) f,
  ) {
    final $$ProgramDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.programDays,
      getReferencedColumn: (t) => t.programId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramDaysTableFilterComposer(
            $db: $db,
            $table: $db.programDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TrainingProgramsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrainingProgramsTable> {
  $$TrainingProgramsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduleType => $composableBuilder(
    column: $table.scheduleType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get venue => $composableBuilder(
    column: $table.venue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
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

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrainingProgramsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrainingProgramsTable> {
  $$TrainingProgramsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ScheduleType, String> get scheduleType =>
      $composableBuilder(
        column: $table.scheduleType,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<ProgramVenue, String> get venue =>
      $composableBuilder(column: $table.venue, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> programDaysRefs<T extends Object>(
    Expression<T> Function($$ProgramDaysTableAnnotationComposer a) f,
  ) {
    final $$ProgramDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.programDays,
      getReferencedColumn: (t) => t.programId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.programDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TrainingProgramsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrainingProgramsTable,
          TrainingProgram,
          $$TrainingProgramsTableFilterComposer,
          $$TrainingProgramsTableOrderingComposer,
          $$TrainingProgramsTableAnnotationComposer,
          $$TrainingProgramsTableCreateCompanionBuilder,
          $$TrainingProgramsTableUpdateCompanionBuilder,
          (TrainingProgram, $$TrainingProgramsTableReferences),
          TrainingProgram,
          PrefetchHooks Function({bool userId, bool programDaysRefs})
        > {
  $$TrainingProgramsTableTableManager(
    _$AppDatabase db,
    $TrainingProgramsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrainingProgramsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrainingProgramsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrainingProgramsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<ScheduleType> scheduleType = const Value.absent(),
                Value<ProgramVenue> venue = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrainingProgramsCompanion(
                id: id,
                userId: userId,
                name: name,
                description: description,
                startDate: startDate,
                endDate: endDate,
                scheduleType: scheduleType,
                venue: venue,
                active: active,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String name,
                required String description,
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                required ScheduleType scheduleType,
                Value<ProgramVenue> venue = const Value.absent(),
                Value<bool> active = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TrainingProgramsCompanion.insert(
                id: id,
                userId: userId,
                name: name,
                description: description,
                startDate: startDate,
                endDate: endDate,
                scheduleType: scheduleType,
                venue: venue,
                active: active,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TrainingProgramsTable, TrainingProgram>(table),
                  $$TrainingProgramsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false, programDaysRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (programDaysRefs) db.programDays],
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
                    if (userId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.userId,
                        referencedTable: $$TrainingProgramsTableReferences
                            ._userIdTable(db),
                        referencedColumn: $$TrainingProgramsTableReferences
                            ._userIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (programDaysRefs)
                    await $_getPrefetchedData<
                      TrainingProgram,
                      $TrainingProgramsTable,
                      ProgramDay
                    >(
                      currentTable: table,
                      referencedTable: $$TrainingProgramsTableReferences
                          ._programDaysRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TrainingProgramsTableReferences(
                            db,
                            table,
                            p0,
                          ).programDaysRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.programId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TrainingProgramsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrainingProgramsTable,
      TrainingProgram,
      $$TrainingProgramsTableFilterComposer,
      $$TrainingProgramsTableOrderingComposer,
      $$TrainingProgramsTableAnnotationComposer,
      $$TrainingProgramsTableCreateCompanionBuilder,
      $$TrainingProgramsTableUpdateCompanionBuilder,
      (TrainingProgram, $$TrainingProgramsTableReferences),
      TrainingProgram,
      PrefetchHooks Function({bool userId, bool programDaysRefs})
    >;
typedef $$ProgramDaysTableCreateCompanionBuilder =
    ProgramDaysCompanion Function({
      required String id,
      required String programId,
      Value<DateTime?> date,
      Value<int?> weekday,
      required LocalizedText title,
      required LocalizedText description,
      Value<int> rowid,
    });
typedef $$ProgramDaysTableUpdateCompanionBuilder =
    ProgramDaysCompanion Function({
      Value<String> id,
      Value<String> programId,
      Value<DateTime?> date,
      Value<int?> weekday,
      Value<LocalizedText> title,
      Value<LocalizedText> description,
      Value<int> rowid,
    });

final class $$ProgramDaysTableReferences
    extends BaseReferences<_$AppDatabase, $ProgramDaysTable, ProgramDay> {
  $$ProgramDaysTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TrainingProgramsTable _programIdTable(_$AppDatabase db) => db
      .trainingPrograms
      .createAlias('program_days__program_id__training_programs__id');

  $$TrainingProgramsTableProcessedTableManager get programId {
    final $_column = $_itemColumn<String>('program_id')!;

    final manager = $$TrainingProgramsTableTableManager(
      $_db,
      $_db.trainingPrograms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_programIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ProgramExercisesTable, List<ProgramExercise>>
  _programExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.programExercises,
    aliasName: 'program_days__id__program_exercises__program_day_id',
  );

  $$ProgramExercisesTableProcessedTableManager get programExercisesRefs {
    final manager = $$ProgramExercisesTableTableManager(
      $_db,
      $_db.programExercises,
    ).filter((f) => f.programDayId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _programExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WorkoutSessionsTable, List<WorkoutSession>>
  _workoutSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSessions,
    aliasName: 'program_days__id__workout_sessions__program_day_id',
  );

  $$WorkoutSessionsTableProcessedTableManager get workoutSessionsRefs {
    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.programDayId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutSessionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProgramDaysTableFilterComposer
    extends Composer<_$AppDatabase, $ProgramDaysTable> {
  $$ProgramDaysTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LocalizedText, LocalizedText, String>
  get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<LocalizedText, LocalizedText, String>
  get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$TrainingProgramsTableFilterComposer get programId {
    final $$TrainingProgramsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programId,
      referencedTable: $db.trainingPrograms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingProgramsTableFilterComposer(
            $db: $db,
            $table: $db.trainingPrograms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> programExercisesRefs(
    Expression<bool> Function($$ProgramExercisesTableFilterComposer f) f,
  ) {
    final $$ProgramExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.programExercises,
      getReferencedColumn: (t) => t.programDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramExercisesTableFilterComposer(
            $db: $db,
            $table: $db.programExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> workoutSessionsRefs(
    Expression<bool> Function($$WorkoutSessionsTableFilterComposer f) f,
  ) {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.programDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProgramDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgramDaysTable> {
  $$ProgramDaysTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  $$TrainingProgramsTableOrderingComposer get programId {
    final $$TrainingProgramsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programId,
      referencedTable: $db.trainingPrograms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingProgramsTableOrderingComposer(
            $db: $db,
            $table: $db.trainingPrograms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProgramDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgramDaysTable> {
  $$ProgramDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LocalizedText, String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LocalizedText, String> get description =>
      $composableBuilder(
        column: $table.description,
        builder: (column) => column,
      );

  $$TrainingProgramsTableAnnotationComposer get programId {
    final $$TrainingProgramsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programId,
      referencedTable: $db.trainingPrograms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingProgramsTableAnnotationComposer(
            $db: $db,
            $table: $db.trainingPrograms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> programExercisesRefs<T extends Object>(
    Expression<T> Function($$ProgramExercisesTableAnnotationComposer a) f,
  ) {
    final $$ProgramExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.programExercises,
      getReferencedColumn: (t) => t.programDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.programExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> workoutSessionsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSessionsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.programDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProgramDaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProgramDaysTable,
          ProgramDay,
          $$ProgramDaysTableFilterComposer,
          $$ProgramDaysTableOrderingComposer,
          $$ProgramDaysTableAnnotationComposer,
          $$ProgramDaysTableCreateCompanionBuilder,
          $$ProgramDaysTableUpdateCompanionBuilder,
          (ProgramDay, $$ProgramDaysTableReferences),
          ProgramDay,
          PrefetchHooks Function({
            bool programId,
            bool programExercisesRefs,
            bool workoutSessionsRefs,
          })
        > {
  $$ProgramDaysTableTableManager(_$AppDatabase db, $ProgramDaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgramDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgramDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgramDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> programId = const Value.absent(),
                Value<DateTime?> date = const Value.absent(),
                Value<int?> weekday = const Value.absent(),
                Value<LocalizedText> title = const Value.absent(),
                Value<LocalizedText> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProgramDaysCompanion(
                id: id,
                programId: programId,
                date: date,
                weekday: weekday,
                title: title,
                description: description,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String programId,
                Value<DateTime?> date = const Value.absent(),
                Value<int?> weekday = const Value.absent(),
                required LocalizedText title,
                required LocalizedText description,
                Value<int> rowid = const Value.absent(),
              }) => ProgramDaysCompanion.insert(
                id: id,
                programId: programId,
                date: date,
                weekday: weekday,
                title: title,
                description: description,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProgramDaysTable, ProgramDay>(table),
                  $$ProgramDaysTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                programId = false,
                programExercisesRefs = false,
                workoutSessionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (programExercisesRefs) db.programExercises,
                    if (workoutSessionsRefs) db.workoutSessions,
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
                        if (programId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.programId,
                            referencedTable: $$ProgramDaysTableReferences
                                ._programIdTable(db),
                            referencedColumn: $$ProgramDaysTableReferences
                                ._programIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (programExercisesRefs)
                        await $_getPrefetchedData<
                          ProgramDay,
                          $ProgramDaysTable,
                          ProgramExercise
                        >(
                          currentTable: table,
                          referencedTable: $$ProgramDaysTableReferences
                              ._programExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProgramDaysTableReferences(
                                db,
                                table,
                                p0,
                              ).programExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.programDayId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (workoutSessionsRefs)
                        await $_getPrefetchedData<
                          ProgramDay,
                          $ProgramDaysTable,
                          WorkoutSession
                        >(
                          currentTable: table,
                          referencedTable: $$ProgramDaysTableReferences
                              ._workoutSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProgramDaysTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.programDayId == item.id,
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

typedef $$ProgramDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProgramDaysTable,
      ProgramDay,
      $$ProgramDaysTableFilterComposer,
      $$ProgramDaysTableOrderingComposer,
      $$ProgramDaysTableAnnotationComposer,
      $$ProgramDaysTableCreateCompanionBuilder,
      $$ProgramDaysTableUpdateCompanionBuilder,
      (ProgramDay, $$ProgramDaysTableReferences),
      ProgramDay,
      PrefetchHooks Function({
        bool programId,
        bool programExercisesRefs,
        bool workoutSessionsRefs,
      })
    >;
typedef $$ProgramExercisesTableCreateCompanionBuilder =
    ProgramExercisesCompanion Function({
      required String id,
      required String programDayId,
      required String exerciseId,
      required int sortOrder,
      required int sets,
      Value<int?> repetitions,
      Value<int?> duration,
      Value<double?> loadKg,
      Value<int> rest,
      Value<String?> notes,
      Value<bool> active,
      Value<int> rowid,
    });
typedef $$ProgramExercisesTableUpdateCompanionBuilder =
    ProgramExercisesCompanion Function({
      Value<String> id,
      Value<String> programDayId,
      Value<String> exerciseId,
      Value<int> sortOrder,
      Value<int> sets,
      Value<int?> repetitions,
      Value<int?> duration,
      Value<double?> loadKg,
      Value<int> rest,
      Value<String?> notes,
      Value<bool> active,
      Value<int> rowid,
    });

final class $$ProgramExercisesTableReferences
    extends
        BaseReferences<_$AppDatabase, $ProgramExercisesTable, ProgramExercise> {
  $$ProgramExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProgramDaysTable _programDayIdTable(_$AppDatabase db) => db
      .programDays
      .createAlias('program_exercises__program_day_id__program_days__id');

  $$ProgramDaysTableProcessedTableManager get programDayId {
    final $_column = $_itemColumn<String>('program_day_id')!;

    final manager = $$ProgramDaysTableTableManager(
      $_db,
      $_db.programDays,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_programDayIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias('program_exercises__exercise_id__exercises__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<String>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $WorkoutExerciseResultsTable,
    List<WorkoutExerciseResult>
  >
  _workoutExerciseResultsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.workoutExerciseResults,
    aliasName:
        'program_exercises__id__workout_exercise_results__program_exercise_id',
  );

  $$WorkoutExerciseResultsTableProcessedTableManager
  get workoutExerciseResultsRefs {
    final manager =
        $$WorkoutExerciseResultsTableTableManager(
          $_db,
          $_db.workoutExerciseResults,
        ).filter(
          (f) => f.programExerciseId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _workoutExerciseResultsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProgramExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ProgramExercisesTable> {
  $$ProgramExercisesTableFilterComposer({
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

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sets => $composableBuilder(
    column: $table.sets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get loadKg => $composableBuilder(
    column: $table.loadKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rest => $composableBuilder(
    column: $table.rest,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  $$ProgramDaysTableFilterComposer get programDayId {
    final $$ProgramDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programDayId,
      referencedTable: $db.programDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramDaysTableFilterComposer(
            $db: $db,
            $table: $db.programDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> workoutExerciseResultsRefs(
    Expression<bool> Function($$WorkoutExerciseResultsTableFilterComposer f) f,
  ) {
    final $$WorkoutExerciseResultsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutExerciseResults,
          getReferencedColumn: (t) => t.programExerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutExerciseResultsTableFilterComposer(
                $db: $db,
                $table: $db.workoutExerciseResults,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ProgramExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgramExercisesTable> {
  $$ProgramExercisesTableOrderingComposer({
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

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sets => $composableBuilder(
    column: $table.sets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get loadKg => $composableBuilder(
    column: $table.loadKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rest => $composableBuilder(
    column: $table.rest,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProgramDaysTableOrderingComposer get programDayId {
    final $$ProgramDaysTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programDayId,
      referencedTable: $db.programDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramDaysTableOrderingComposer(
            $db: $db,
            $table: $db.programDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProgramExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgramExercisesTable> {
  $$ProgramExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get sets =>
      $composableBuilder(column: $table.sets, builder: (column) => column);

  GeneratedColumn<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<double> get loadKg =>
      $composableBuilder(column: $table.loadKg, builder: (column) => column);

  GeneratedColumn<int> get rest =>
      $composableBuilder(column: $table.rest, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  $$ProgramDaysTableAnnotationComposer get programDayId {
    final $$ProgramDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programDayId,
      referencedTable: $db.programDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.programDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> workoutExerciseResultsRefs<T extends Object>(
    Expression<T> Function($$WorkoutExerciseResultsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutExerciseResultsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutExerciseResults,
          getReferencedColumn: (t) => t.programExerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutExerciseResultsTableAnnotationComposer(
                $db: $db,
                $table: $db.workoutExerciseResults,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ProgramExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProgramExercisesTable,
          ProgramExercise,
          $$ProgramExercisesTableFilterComposer,
          $$ProgramExercisesTableOrderingComposer,
          $$ProgramExercisesTableAnnotationComposer,
          $$ProgramExercisesTableCreateCompanionBuilder,
          $$ProgramExercisesTableUpdateCompanionBuilder,
          (ProgramExercise, $$ProgramExercisesTableReferences),
          ProgramExercise,
          PrefetchHooks Function({
            bool programDayId,
            bool exerciseId,
            bool workoutExerciseResultsRefs,
          })
        > {
  $$ProgramExercisesTableTableManager(
    _$AppDatabase db,
    $ProgramExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgramExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgramExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgramExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> programDayId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> sets = const Value.absent(),
                Value<int?> repetitions = const Value.absent(),
                Value<int?> duration = const Value.absent(),
                Value<double?> loadKg = const Value.absent(),
                Value<int> rest = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProgramExercisesCompanion(
                id: id,
                programDayId: programDayId,
                exerciseId: exerciseId,
                sortOrder: sortOrder,
                sets: sets,
                repetitions: repetitions,
                duration: duration,
                loadKg: loadKg,
                rest: rest,
                notes: notes,
                active: active,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String programDayId,
                required String exerciseId,
                required int sortOrder,
                required int sets,
                Value<int?> repetitions = const Value.absent(),
                Value<int?> duration = const Value.absent(),
                Value<double?> loadKg = const Value.absent(),
                Value<int> rest = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProgramExercisesCompanion.insert(
                id: id,
                programDayId: programDayId,
                exerciseId: exerciseId,
                sortOrder: sortOrder,
                sets: sets,
                repetitions: repetitions,
                duration: duration,
                loadKg: loadKg,
                rest: rest,
                notes: notes,
                active: active,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProgramExercisesTable, ProgramExercise>(table),
                  $$ProgramExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                programDayId = false,
                exerciseId = false,
                workoutExerciseResultsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutExerciseResultsRefs) db.workoutExerciseResults,
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
                        if (programDayId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.programDayId,
                            referencedTable: $$ProgramExercisesTableReferences
                                ._programDayIdTable(db),
                            referencedColumn: $$ProgramExercisesTableReferences
                                ._programDayIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (exerciseId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.exerciseId,
                            referencedTable: $$ProgramExercisesTableReferences
                                ._exerciseIdTable(db),
                            referencedColumn: $$ProgramExercisesTableReferences
                                ._exerciseIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutExerciseResultsRefs)
                        await $_getPrefetchedData<
                          ProgramExercise,
                          $ProgramExercisesTable,
                          WorkoutExerciseResult
                        >(
                          currentTable: table,
                          referencedTable: $$ProgramExercisesTableReferences
                              ._workoutExerciseResultsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProgramExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutExerciseResultsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.programExerciseId == item.id,
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

typedef $$ProgramExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProgramExercisesTable,
      ProgramExercise,
      $$ProgramExercisesTableFilterComposer,
      $$ProgramExercisesTableOrderingComposer,
      $$ProgramExercisesTableAnnotationComposer,
      $$ProgramExercisesTableCreateCompanionBuilder,
      $$ProgramExercisesTableUpdateCompanionBuilder,
      (ProgramExercise, $$ProgramExercisesTableReferences),
      ProgramExercise,
      PrefetchHooks Function({
        bool programDayId,
        bool exerciseId,
        bool workoutExerciseResultsRefs,
      })
    >;
typedef $$WorkoutSessionsTableCreateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      required String id,
      required String userId,
      required String programDayId,
      required DateTime startedAt,
      Value<DateTime?> completedAt,
      Value<int?> duration,
      required WorkoutStatus status,
      Value<String?> notes,
      Value<double?> totalVolumeKg,
      Value<int> rowid,
    });
typedef $$WorkoutSessionsTableUpdateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> programDayId,
      Value<DateTime> startedAt,
      Value<DateTime?> completedAt,
      Value<int?> duration,
      Value<WorkoutStatus> status,
      Value<String?> notes,
      Value<double?> totalVolumeKg,
      Value<int> rowid,
    });

final class $$WorkoutSessionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $WorkoutSessionsTable, WorkoutSession> {
  $$WorkoutSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('workout_sessions__user_id__users__id');

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProgramDaysTable _programDayIdTable(_$AppDatabase db) => db
      .programDays
      .createAlias('workout_sessions__program_day_id__program_days__id');

  $$ProgramDaysTableProcessedTableManager get programDayId {
    final $_column = $_itemColumn<String>('program_day_id')!;

    final manager = $$ProgramDaysTableTableManager(
      $_db,
      $_db.programDays,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_programDayIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $WorkoutExerciseResultsTable,
    List<WorkoutExerciseResult>
  >
  _workoutExerciseResultsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.workoutExerciseResults,
    aliasName:
        'workout_sessions__id__workout_exercise_results__workout_session_id',
  );

  $$WorkoutExerciseResultsTableProcessedTableManager
  get workoutExerciseResultsRefs {
    final manager =
        $$WorkoutExerciseResultsTableTableManager(
          $_db,
          $_db.workoutExerciseResults,
        ).filter(
          (f) => f.workoutSessionId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _workoutExerciseResultsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableFilterComposer({
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

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WorkoutStatus, WorkoutStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalVolumeKg => $composableBuilder(
    column: $table.totalVolumeKg,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProgramDaysTableFilterComposer get programDayId {
    final $$ProgramDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programDayId,
      referencedTable: $db.programDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramDaysTableFilterComposer(
            $db: $db,
            $table: $db.programDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> workoutExerciseResultsRefs(
    Expression<bool> Function($$WorkoutExerciseResultsTableFilterComposer f) f,
  ) {
    final $$WorkoutExerciseResultsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutExerciseResults,
          getReferencedColumn: (t) => t.workoutSessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutExerciseResultsTableFilterComposer(
                $db: $db,
                $table: $db.workoutExerciseResults,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WorkoutSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalVolumeKg => $composableBuilder(
    column: $table.totalVolumeKg,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProgramDaysTableOrderingComposer get programDayId {
    final $$ProgramDaysTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programDayId,
      referencedTable: $db.programDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramDaysTableOrderingComposer(
            $db: $db,
            $table: $db.programDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableAnnotationComposer({
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

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WorkoutStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<double> get totalVolumeKg => $composableBuilder(
    column: $table.totalVolumeKg,
    builder: (column) => column,
  );

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProgramDaysTableAnnotationComposer get programDayId {
    final $$ProgramDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programDayId,
      referencedTable: $db.programDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.programDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> workoutExerciseResultsRefs<T extends Object>(
    Expression<T> Function($$WorkoutExerciseResultsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutExerciseResultsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutExerciseResults,
          getReferencedColumn: (t) => t.workoutSessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutExerciseResultsTableAnnotationComposer(
                $db: $db,
                $table: $db.workoutExerciseResults,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WorkoutSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSessionsTable,
          WorkoutSession,
          $$WorkoutSessionsTableFilterComposer,
          $$WorkoutSessionsTableOrderingComposer,
          $$WorkoutSessionsTableAnnotationComposer,
          $$WorkoutSessionsTableCreateCompanionBuilder,
          $$WorkoutSessionsTableUpdateCompanionBuilder,
          (WorkoutSession, $$WorkoutSessionsTableReferences),
          WorkoutSession,
          PrefetchHooks Function({
            bool userId,
            bool programDayId,
            bool workoutExerciseResultsRefs,
          })
        > {
  $$WorkoutSessionsTableTableManager(
    _$AppDatabase db,
    $WorkoutSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> programDayId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int?> duration = const Value.absent(),
                Value<WorkoutStatus> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<double?> totalVolumeKg = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSessionsCompanion(
                id: id,
                userId: userId,
                programDayId: programDayId,
                startedAt: startedAt,
                completedAt: completedAt,
                duration: duration,
                status: status,
                notes: notes,
                totalVolumeKg: totalVolumeKg,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String programDayId,
                required DateTime startedAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int?> duration = const Value.absent(),
                required WorkoutStatus status,
                Value<String?> notes = const Value.absent(),
                Value<double?> totalVolumeKg = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSessionsCompanion.insert(
                id: id,
                userId: userId,
                programDayId: programDayId,
                startedAt: startedAt,
                completedAt: completedAt,
                duration: duration,
                status: status,
                notes: notes,
                totalVolumeKg: totalVolumeKg,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutSessionsTable, WorkoutSession>(table),
                  $$WorkoutSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                userId = false,
                programDayId = false,
                workoutExerciseResultsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutExerciseResultsRefs) db.workoutExerciseResults,
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
                        if (userId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.userId,
                            referencedTable: $$WorkoutSessionsTableReferences
                                ._userIdTable(db),
                            referencedColumn: $$WorkoutSessionsTableReferences
                                ._userIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (programDayId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.programDayId,
                            referencedTable: $$WorkoutSessionsTableReferences
                                ._programDayIdTable(db),
                            referencedColumn: $$WorkoutSessionsTableReferences
                                ._programDayIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutExerciseResultsRefs)
                        await $_getPrefetchedData<
                          WorkoutSession,
                          $WorkoutSessionsTable,
                          WorkoutExerciseResult
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutSessionsTableReferences
                              ._workoutExerciseResultsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutExerciseResultsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.workoutSessionId == item.id,
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

typedef $$WorkoutSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSessionsTable,
      WorkoutSession,
      $$WorkoutSessionsTableFilterComposer,
      $$WorkoutSessionsTableOrderingComposer,
      $$WorkoutSessionsTableAnnotationComposer,
      $$WorkoutSessionsTableCreateCompanionBuilder,
      $$WorkoutSessionsTableUpdateCompanionBuilder,
      (WorkoutSession, $$WorkoutSessionsTableReferences),
      WorkoutSession,
      PrefetchHooks Function({
        bool userId,
        bool programDayId,
        bool workoutExerciseResultsRefs,
      })
    >;
typedef $$WorkoutExerciseResultsTableCreateCompanionBuilder =
    WorkoutExerciseResultsCompanion Function({
      required String id,
      required String workoutSessionId,
      required String exerciseId,
      required String programExerciseId,
      required int sortOrder,
      required int plannedSets,
      Value<int> actualSets,
      Value<int?> plannedRepetitions,
      Value<int?> actualRepetitions,
      Value<int?> plannedDuration,
      Value<int?> actualDuration,
      Value<bool> completed,
      Value<PerceivedEffort?> effort,
      Value<String?> notes,
      Value<bool> personalRecord,
      Value<int> rowid,
    });
typedef $$WorkoutExerciseResultsTableUpdateCompanionBuilder =
    WorkoutExerciseResultsCompanion Function({
      Value<String> id,
      Value<String> workoutSessionId,
      Value<String> exerciseId,
      Value<String> programExerciseId,
      Value<int> sortOrder,
      Value<int> plannedSets,
      Value<int> actualSets,
      Value<int?> plannedRepetitions,
      Value<int?> actualRepetitions,
      Value<int?> plannedDuration,
      Value<int?> actualDuration,
      Value<bool> completed,
      Value<PerceivedEffort?> effort,
      Value<String?> notes,
      Value<bool> personalRecord,
      Value<int> rowid,
    });

final class $$WorkoutExerciseResultsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WorkoutExerciseResultsTable,
          WorkoutExerciseResult
        > {
  $$WorkoutExerciseResultsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutSessionsTable _workoutSessionIdTable(_$AppDatabase db) =>
      db.workoutSessions.createAlias(
        'workout_exercise_results__workout_session_id__workout_sessions__id',
      );

  $$WorkoutSessionsTableProcessedTableManager get workoutSessionId {
    final $_column = $_itemColumn<String>('workout_session_id')!;

    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutSessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) => db.exercises
      .createAlias('workout_exercise_results__exercise_id__exercises__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<String>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProgramExercisesTable _programExerciseIdTable(_$AppDatabase db) =>
      db.programExercises.createAlias(
        'workout_exercise_results__program_exercise_id__program_exercises__id',
      );

  $$ProgramExercisesTableProcessedTableManager get programExerciseId {
    final $_column = $_itemColumn<String>('program_exercise_id')!;

    final manager = $$ProgramExercisesTableTableManager(
      $_db,
      $_db.programExercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_programExerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$WorkoutSetResultsTable, List<WorkoutSetResult>>
  _workoutSetResultsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.workoutSetResults,
        aliasName: 'workout_exercise_results__id__workout_set_results__workout_exercise_result_id',
      );

  $$WorkoutSetResultsTableProcessedTableManager get workoutSetResultsRefs {
    final manager =
        $$WorkoutSetResultsTableTableManager(
          $_db,
          $_db.workoutSetResults,
        ).filter(
          (f) => f.workoutExerciseResultId.id.sqlEquals(
            $_itemColumn<String>('id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _workoutSetResultsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutExerciseResultsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutExerciseResultsTable> {
  $$WorkoutExerciseResultsTableFilterComposer({
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

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedSets => $composableBuilder(
    column: $table.plannedSets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualSets => $composableBuilder(
    column: $table.actualSets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedRepetitions => $composableBuilder(
    column: $table.plannedRepetitions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualRepetitions => $composableBuilder(
    column: $table.actualRepetitions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedDuration => $composableBuilder(
    column: $table.plannedDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualDuration => $composableBuilder(
    column: $table.actualDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PerceivedEffort?, PerceivedEffort, String>
  get effort => $composableBuilder(
    column: $table.effort,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get personalRecord => $composableBuilder(
    column: $table.personalRecord,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutSessionsTableFilterComposer get workoutSessionId {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutSessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProgramExercisesTableFilterComposer get programExerciseId {
    final $$ProgramExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programExerciseId,
      referencedTable: $db.programExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramExercisesTableFilterComposer(
            $db: $db,
            $table: $db.programExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> workoutSetResultsRefs(
    Expression<bool> Function($$WorkoutSetResultsTableFilterComposer f) f,
  ) {
    final $$WorkoutSetResultsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSetResults,
      getReferencedColumn: (t) => t.workoutExerciseResultId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetResultsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSetResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutExerciseResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutExerciseResultsTable> {
  $$WorkoutExerciseResultsTableOrderingComposer({
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

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedSets => $composableBuilder(
    column: $table.plannedSets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualSets => $composableBuilder(
    column: $table.actualSets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedRepetitions => $composableBuilder(
    column: $table.plannedRepetitions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualRepetitions => $composableBuilder(
    column: $table.actualRepetitions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedDuration => $composableBuilder(
    column: $table.plannedDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualDuration => $composableBuilder(
    column: $table.actualDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get effort => $composableBuilder(
    column: $table.effort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get personalRecord => $composableBuilder(
    column: $table.personalRecord,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutSessionsTableOrderingComposer get workoutSessionId {
    final $$WorkoutSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutSessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProgramExercisesTableOrderingComposer get programExerciseId {
    final $$ProgramExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programExerciseId,
      referencedTable: $db.programExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.programExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutExerciseResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutExerciseResultsTable> {
  $$WorkoutExerciseResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get plannedSets => $composableBuilder(
    column: $table.plannedSets,
    builder: (column) => column,
  );

  GeneratedColumn<int> get actualSets => $composableBuilder(
    column: $table.actualSets,
    builder: (column) => column,
  );

  GeneratedColumn<int> get plannedRepetitions => $composableBuilder(
    column: $table.plannedRepetitions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get actualRepetitions => $composableBuilder(
    column: $table.actualRepetitions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get plannedDuration => $composableBuilder(
    column: $table.plannedDuration,
    builder: (column) => column,
  );

  GeneratedColumn<int> get actualDuration => $composableBuilder(
    column: $table.actualDuration,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PerceivedEffort?, String> get effort =>
      $composableBuilder(column: $table.effort, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get personalRecord => $composableBuilder(
    column: $table.personalRecord,
    builder: (column) => column,
  );

  $$WorkoutSessionsTableAnnotationComposer get workoutSessionId {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutSessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProgramExercisesTableAnnotationComposer get programExerciseId {
    final $$ProgramExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programExerciseId,
      referencedTable: $db.programExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.programExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> workoutSetResultsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSetResultsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSetResultsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutSetResults,
          getReferencedColumn: (t) => t.workoutExerciseResultId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutSetResultsTableAnnotationComposer(
                $db: $db,
                $table: $db.workoutSetResults,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WorkoutExerciseResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutExerciseResultsTable,
          WorkoutExerciseResult,
          $$WorkoutExerciseResultsTableFilterComposer,
          $$WorkoutExerciseResultsTableOrderingComposer,
          $$WorkoutExerciseResultsTableAnnotationComposer,
          $$WorkoutExerciseResultsTableCreateCompanionBuilder,
          $$WorkoutExerciseResultsTableUpdateCompanionBuilder,
          (WorkoutExerciseResult, $$WorkoutExerciseResultsTableReferences),
          WorkoutExerciseResult,
          PrefetchHooks Function({
            bool workoutSessionId,
            bool exerciseId,
            bool programExerciseId,
            bool workoutSetResultsRefs,
          })
        > {
  $$WorkoutExerciseResultsTableTableManager(
    _$AppDatabase db,
    $WorkoutExerciseResultsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutExerciseResultsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$WorkoutExerciseResultsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WorkoutExerciseResultsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workoutSessionId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<String> programExerciseId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> plannedSets = const Value.absent(),
                Value<int> actualSets = const Value.absent(),
                Value<int?> plannedRepetitions = const Value.absent(),
                Value<int?> actualRepetitions = const Value.absent(),
                Value<int?> plannedDuration = const Value.absent(),
                Value<int?> actualDuration = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<PerceivedEffort?> effort = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> personalRecord = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutExerciseResultsCompanion(
                id: id,
                workoutSessionId: workoutSessionId,
                exerciseId: exerciseId,
                programExerciseId: programExerciseId,
                sortOrder: sortOrder,
                plannedSets: plannedSets,
                actualSets: actualSets,
                plannedRepetitions: plannedRepetitions,
                actualRepetitions: actualRepetitions,
                plannedDuration: plannedDuration,
                actualDuration: actualDuration,
                completed: completed,
                effort: effort,
                notes: notes,
                personalRecord: personalRecord,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workoutSessionId,
                required String exerciseId,
                required String programExerciseId,
                required int sortOrder,
                required int plannedSets,
                Value<int> actualSets = const Value.absent(),
                Value<int?> plannedRepetitions = const Value.absent(),
                Value<int?> actualRepetitions = const Value.absent(),
                Value<int?> plannedDuration = const Value.absent(),
                Value<int?> actualDuration = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<PerceivedEffort?> effort = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> personalRecord = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutExerciseResultsCompanion.insert(
                id: id,
                workoutSessionId: workoutSessionId,
                exerciseId: exerciseId,
                programExerciseId: programExerciseId,
                sortOrder: sortOrder,
                plannedSets: plannedSets,
                actualSets: actualSets,
                plannedRepetitions: plannedRepetitions,
                actualRepetitions: actualRepetitions,
                plannedDuration: plannedDuration,
                actualDuration: actualDuration,
                completed: completed,
                effort: effort,
                notes: notes,
                personalRecord: personalRecord,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $WorkoutExerciseResultsTable,
                    WorkoutExerciseResult
                  >(table),
                  $$WorkoutExerciseResultsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                workoutSessionId = false,
                exerciseId = false,
                programExerciseId = false,
                workoutSetResultsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutSetResultsRefs) db.workoutSetResults,
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
                        if (workoutSessionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.workoutSessionId,
                            referencedTable:
                                $$WorkoutExerciseResultsTableReferences
                                    ._workoutSessionIdTable(db),
                            referencedColumn:
                                $$WorkoutExerciseResultsTableReferences
                                    ._workoutSessionIdTable(db)
                                    .id,
                          ) as T;
                        }
                        if (exerciseId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.exerciseId,
                            referencedTable:
                                $$WorkoutExerciseResultsTableReferences
                                    ._exerciseIdTable(db),
                            referencedColumn:
                                $$WorkoutExerciseResultsTableReferences
                                    ._exerciseIdTable(db)
                                    .id,
                          ) as T;
                        }
                        if (programExerciseId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.programExerciseId,
                            referencedTable:
                                $$WorkoutExerciseResultsTableReferences
                                    ._programExerciseIdTable(db),
                            referencedColumn:
                                $$WorkoutExerciseResultsTableReferences
                                    ._programExerciseIdTable(db)
                                    .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutSetResultsRefs)
                        await $_getPrefetchedData<
                          WorkoutExerciseResult,
                          $WorkoutExerciseResultsTable,
                          WorkoutSetResult
                        >(
                          currentTable: table,
                          referencedTable:
                              $$WorkoutExerciseResultsTableReferences
                                  ._workoutSetResultsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutExerciseResultsTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSetResultsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.workoutExerciseResultId == item.id,
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

typedef $$WorkoutExerciseResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutExerciseResultsTable,
      WorkoutExerciseResult,
      $$WorkoutExerciseResultsTableFilterComposer,
      $$WorkoutExerciseResultsTableOrderingComposer,
      $$WorkoutExerciseResultsTableAnnotationComposer,
      $$WorkoutExerciseResultsTableCreateCompanionBuilder,
      $$WorkoutExerciseResultsTableUpdateCompanionBuilder,
      (WorkoutExerciseResult, $$WorkoutExerciseResultsTableReferences),
      WorkoutExerciseResult,
      PrefetchHooks Function({
        bool workoutSessionId,
        bool exerciseId,
        bool programExerciseId,
        bool workoutSetResultsRefs,
      })
    >;
typedef $$WorkoutSetResultsTableCreateCompanionBuilder =
    WorkoutSetResultsCompanion Function({
      required String id,
      required String workoutExerciseResultId,
      required int setNumber,
      Value<int?> plannedReps,
      Value<int?> actualReps,
      Value<int?> plannedDuration,
      Value<int?> actualDuration,
      Value<double?> plannedLoadKg,
      Value<double?> actualLoadKg,
      Value<bool> completed,
      Value<int> rowid,
    });
typedef $$WorkoutSetResultsTableUpdateCompanionBuilder =
    WorkoutSetResultsCompanion Function({
      Value<String> id,
      Value<String> workoutExerciseResultId,
      Value<int> setNumber,
      Value<int?> plannedReps,
      Value<int?> actualReps,
      Value<int?> plannedDuration,
      Value<int?> actualDuration,
      Value<double?> plannedLoadKg,
      Value<double?> actualLoadKg,
      Value<bool> completed,
      Value<int> rowid,
    });

final class $$WorkoutSetResultsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WorkoutSetResultsTable,
          WorkoutSetResult
        > {
  $$WorkoutSetResultsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutExerciseResultsTable _workoutExerciseResultIdTable(
    _$AppDatabase db,
  ) => db.workoutExerciseResults.createAlias(
    'workout_set_results__workout_exercise_result_id__workout_exercise_results__id',
  );

  $$WorkoutExerciseResultsTableProcessedTableManager
  get workoutExerciseResultId {
    final $_column = $_itemColumn<String>('workout_exercise_result_id')!;

    final manager = $$WorkoutExerciseResultsTableTableManager(
      $_db,
      $_db.workoutExerciseResults,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _workoutExerciseResultIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkoutSetResultsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSetResultsTable> {
  $$WorkoutSetResultsTableFilterComposer({
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

  ColumnFilters<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedReps => $composableBuilder(
    column: $table.plannedReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualReps => $composableBuilder(
    column: $table.actualReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedDuration => $composableBuilder(
    column: $table.plannedDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualDuration => $composableBuilder(
    column: $table.actualDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get plannedLoadKg => $composableBuilder(
    column: $table.plannedLoadKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get actualLoadKg => $composableBuilder(
    column: $table.actualLoadKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutExerciseResultsTableFilterComposer get workoutExerciseResultId {
    final $$WorkoutExerciseResultsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.workoutExerciseResultId,
          referencedTable: $db.workoutExerciseResults,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutExerciseResultsTableFilterComposer(
                $db: $db,
                $table: $db.workoutExerciseResults,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$WorkoutSetResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSetResultsTable> {
  $$WorkoutSetResultsTableOrderingComposer({
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

  ColumnOrderings<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedReps => $composableBuilder(
    column: $table.plannedReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualReps => $composableBuilder(
    column: $table.actualReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedDuration => $composableBuilder(
    column: $table.plannedDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualDuration => $composableBuilder(
    column: $table.actualDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get plannedLoadKg => $composableBuilder(
    column: $table.plannedLoadKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get actualLoadKg => $composableBuilder(
    column: $table.actualLoadKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutExerciseResultsTableOrderingComposer get workoutExerciseResultId {
    final $$WorkoutExerciseResultsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.workoutExerciseResultId,
          referencedTable: $db.workoutExerciseResults,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutExerciseResultsTableOrderingComposer(
                $db: $db,
                $table: $db.workoutExerciseResults,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$WorkoutSetResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSetResultsTable> {
  $$WorkoutSetResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get setNumber =>
      $composableBuilder(column: $table.setNumber, builder: (column) => column);

  GeneratedColumn<int> get plannedReps => $composableBuilder(
    column: $table.plannedReps,
    builder: (column) => column,
  );

  GeneratedColumn<int> get actualReps => $composableBuilder(
    column: $table.actualReps,
    builder: (column) => column,
  );

  GeneratedColumn<int> get plannedDuration => $composableBuilder(
    column: $table.plannedDuration,
    builder: (column) => column,
  );

  GeneratedColumn<int> get actualDuration => $composableBuilder(
    column: $table.actualDuration,
    builder: (column) => column,
  );

  GeneratedColumn<double> get plannedLoadKg => $composableBuilder(
    column: $table.plannedLoadKg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get actualLoadKg => $composableBuilder(
    column: $table.actualLoadKg,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  $$WorkoutExerciseResultsTableAnnotationComposer get workoutExerciseResultId {
    final $$WorkoutExerciseResultsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.workoutExerciseResultId,
          referencedTable: $db.workoutExerciseResults,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutExerciseResultsTableAnnotationComposer(
                $db: $db,
                $table: $db.workoutExerciseResults,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$WorkoutSetResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSetResultsTable,
          WorkoutSetResult,
          $$WorkoutSetResultsTableFilterComposer,
          $$WorkoutSetResultsTableOrderingComposer,
          $$WorkoutSetResultsTableAnnotationComposer,
          $$WorkoutSetResultsTableCreateCompanionBuilder,
          $$WorkoutSetResultsTableUpdateCompanionBuilder,
          (WorkoutSetResult, $$WorkoutSetResultsTableReferences),
          WorkoutSetResult,
          PrefetchHooks Function({bool workoutExerciseResultId})
        > {
  $$WorkoutSetResultsTableTableManager(
    _$AppDatabase db,
    $WorkoutSetResultsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSetResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSetResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSetResultsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workoutExerciseResultId = const Value.absent(),
                Value<int> setNumber = const Value.absent(),
                Value<int?> plannedReps = const Value.absent(),
                Value<int?> actualReps = const Value.absent(),
                Value<int?> plannedDuration = const Value.absent(),
                Value<int?> actualDuration = const Value.absent(),
                Value<double?> plannedLoadKg = const Value.absent(),
                Value<double?> actualLoadKg = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSetResultsCompanion(
                id: id,
                workoutExerciseResultId: workoutExerciseResultId,
                setNumber: setNumber,
                plannedReps: plannedReps,
                actualReps: actualReps,
                plannedDuration: plannedDuration,
                actualDuration: actualDuration,
                plannedLoadKg: plannedLoadKg,
                actualLoadKg: actualLoadKg,
                completed: completed,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workoutExerciseResultId,
                required int setNumber,
                Value<int?> plannedReps = const Value.absent(),
                Value<int?> actualReps = const Value.absent(),
                Value<int?> plannedDuration = const Value.absent(),
                Value<int?> actualDuration = const Value.absent(),
                Value<double?> plannedLoadKg = const Value.absent(),
                Value<double?> actualLoadKg = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSetResultsCompanion.insert(
                id: id,
                workoutExerciseResultId: workoutExerciseResultId,
                setNumber: setNumber,
                plannedReps: plannedReps,
                actualReps: actualReps,
                plannedDuration: plannedDuration,
                actualDuration: actualDuration,
                plannedLoadKg: plannedLoadKg,
                actualLoadKg: actualLoadKg,
                completed: completed,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutSetResultsTable, WorkoutSetResult>(table),
                  $$WorkoutSetResultsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutExerciseResultId = false}) {
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
                    if (workoutExerciseResultId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.workoutExerciseResultId,
                        referencedTable: $$WorkoutSetResultsTableReferences
                            ._workoutExerciseResultIdTable(db),
                        referencedColumn: $$WorkoutSetResultsTableReferences
                            ._workoutExerciseResultIdTable(db)
                            .id,
                      ) as T;
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

typedef $$WorkoutSetResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSetResultsTable,
      WorkoutSetResult,
      $$WorkoutSetResultsTableFilterComposer,
      $$WorkoutSetResultsTableOrderingComposer,
      $$WorkoutSetResultsTableAnnotationComposer,
      $$WorkoutSetResultsTableCreateCompanionBuilder,
      $$WorkoutSetResultsTableUpdateCompanionBuilder,
      (WorkoutSetResult, $$WorkoutSetResultsTableReferences),
      WorkoutSetResult,
      PrefetchHooks Function({bool workoutExerciseResultId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$TrainingProgramsTableTableManager get trainingPrograms =>
      $$TrainingProgramsTableTableManager(_db, _db.trainingPrograms);
  $$ProgramDaysTableTableManager get programDays =>
      $$ProgramDaysTableTableManager(_db, _db.programDays);
  $$ProgramExercisesTableTableManager get programExercises =>
      $$ProgramExercisesTableTableManager(_db, _db.programExercises);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(_db, _db.workoutSessions);
  $$WorkoutExerciseResultsTableTableManager get workoutExerciseResults =>
      $$WorkoutExerciseResultsTableTableManager(
        _db,
        _db.workoutExerciseResults,
      );
  $$WorkoutSetResultsTableTableManager get workoutSetResults =>
      $$WorkoutSetResultsTableTableManager(_db, _db.workoutSetResults);
}
