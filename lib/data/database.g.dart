// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $DailyNotesTable extends DailyNotes
    with TableInfo<$DailyNotesTable, DailyNote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyNotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
  List<GeneratedColumn> get $columns => [day, content, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyNote> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
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
  Set<GeneratedColumn> get $primaryKey => {day};
  @override
  DailyNote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyNote(
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DailyNotesTable createAlias(String alias) {
    return $DailyNotesTable(attachedDatabase, alias);
  }
}

class DailyNote extends DataClass implements Insertable<DailyNote> {
  final String day;
  final String content;
  final DateTime updatedAt;
  const DailyNote({
    required this.day,
    required this.content,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['day'] = Variable<String>(day);
    map['content'] = Variable<String>(content);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DailyNotesCompanion toCompanion(bool nullToAbsent) {
    return DailyNotesCompanion(
      day: Value(day),
      content: Value(content),
      updatedAt: Value(updatedAt),
    );
  }

  factory DailyNote.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyNote(
      day: serializer.fromJson<String>(json['day']),
      content: serializer.fromJson<String>(json['content']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'day': serializer.toJson<String>(day),
      'content': serializer.toJson<String>(content),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DailyNote copyWith({String? day, String? content, DateTime? updatedAt}) =>
      DailyNote(
        day: day ?? this.day,
        content: content ?? this.content,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  DailyNote copyWithCompanion(DailyNotesCompanion data) {
    return DailyNote(
      day: data.day.present ? data.day.value : this.day,
      content: data.content.present ? data.content.value : this.content,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyNote(')
          ..write('day: $day, ')
          ..write('content: $content, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(day, content, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyNote &&
          other.day == this.day &&
          other.content == this.content &&
          other.updatedAt == this.updatedAt);
}

class DailyNotesCompanion extends UpdateCompanion<DailyNote> {
  final Value<String> day;
  final Value<String> content;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DailyNotesCompanion({
    this.day = const Value.absent(),
    this.content = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyNotesCompanion.insert({
    required String day,
    this.content = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : day = Value(day),
       updatedAt = Value(updatedAt);
  static Insertable<DailyNote> custom({
    Expression<String>? day,
    Expression<String>? content,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (day != null) 'day': day,
      if (content != null) 'content': content,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyNotesCompanion copyWith({
    Value<String>? day,
    Value<String>? content,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DailyNotesCompanion(
      day: day ?? this.day,
      content: content ?? this.content,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
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
    return (StringBuffer('DailyNotesCompanion(')
          ..write('day: $day, ')
          ..write('content: $content, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlannerSettingsTable extends PlannerSettings
    with TableInfo<$PlannerSettingsTable, PlannerSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlannerSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
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
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'planner_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlannerSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  PlannerSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlannerSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $PlannerSettingsTable createAlias(String alias) {
    return $PlannerSettingsTable(attachedDatabase, alias);
  }
}

class PlannerSetting extends DataClass implements Insertable<PlannerSetting> {
  final String key;
  final String value;
  const PlannerSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  PlannerSettingsCompanion toCompanion(bool nullToAbsent) {
    return PlannerSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory PlannerSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlannerSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  PlannerSetting copyWith({String? key, String? value}) =>
      PlannerSetting(key: key ?? this.key, value: value ?? this.value);
  PlannerSetting copyWithCompanion(PlannerSettingsCompanion data) {
    return PlannerSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlannerSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlannerSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class PlannerSettingsCompanion extends UpdateCompanion<PlannerSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const PlannerSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlannerSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<PlannerSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlannerSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return PlannerSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlannerSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlannerTasksTable extends PlannerTasks
    with TableInfo<$PlannerTasksTable, PlannerTask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlannerTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailsMeta = const VerificationMeta(
    'details',
  );
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
    'details',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _delegatedToMeta = const VerificationMeta(
    'delegatedTo',
  );
  @override
  late final GeneratedColumn<String> delegatedTo = GeneratedColumn<String>(
    'delegated_to',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('A'),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('open'),
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
    day,
    title,
    details,
    delegatedTo,
    priority,
    position,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'planner_tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlannerTask> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('details')) {
      context.handle(
        _detailsMeta,
        details.isAcceptableOrUnknown(data['details']!, _detailsMeta),
      );
    }
    if (data.containsKey('delegated_to')) {
      context.handle(
        _delegatedToMeta,
        delegatedTo.isAcceptableOrUnknown(
          data['delegated_to']!,
          _delegatedToMeta,
        ),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlannerTask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlannerTask(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      details: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details'],
      )!,
      delegatedTo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}delegated_to'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PlannerTasksTable createAlias(String alias) {
    return $PlannerTasksTable(attachedDatabase, alias);
  }
}

class PlannerTask extends DataClass implements Insertable<PlannerTask> {
  final int id;
  final String day;
  final String title;
  final String details;
  final String delegatedTo;
  final String priority;
  final int position;
  final String status;
  final DateTime createdAt;
  const PlannerTask({
    required this.id,
    required this.day,
    required this.title,
    required this.details,
    required this.delegatedTo,
    required this.priority,
    required this.position,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day'] = Variable<String>(day);
    map['title'] = Variable<String>(title);
    map['details'] = Variable<String>(details);
    map['delegated_to'] = Variable<String>(delegatedTo);
    map['priority'] = Variable<String>(priority);
    map['position'] = Variable<int>(position);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PlannerTasksCompanion toCompanion(bool nullToAbsent) {
    return PlannerTasksCompanion(
      id: Value(id),
      day: Value(day),
      title: Value(title),
      details: Value(details),
      delegatedTo: Value(delegatedTo),
      priority: Value(priority),
      position: Value(position),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory PlannerTask.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlannerTask(
      id: serializer.fromJson<int>(json['id']),
      day: serializer.fromJson<String>(json['day']),
      title: serializer.fromJson<String>(json['title']),
      details: serializer.fromJson<String>(json['details']),
      delegatedTo: serializer.fromJson<String>(json['delegatedTo']),
      priority: serializer.fromJson<String>(json['priority']),
      position: serializer.fromJson<int>(json['position']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'day': serializer.toJson<String>(day),
      'title': serializer.toJson<String>(title),
      'details': serializer.toJson<String>(details),
      'delegatedTo': serializer.toJson<String>(delegatedTo),
      'priority': serializer.toJson<String>(priority),
      'position': serializer.toJson<int>(position),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PlannerTask copyWith({
    int? id,
    String? day,
    String? title,
    String? details,
    String? delegatedTo,
    String? priority,
    int? position,
    String? status,
    DateTime? createdAt,
  }) => PlannerTask(
    id: id ?? this.id,
    day: day ?? this.day,
    title: title ?? this.title,
    details: details ?? this.details,
    delegatedTo: delegatedTo ?? this.delegatedTo,
    priority: priority ?? this.priority,
    position: position ?? this.position,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  PlannerTask copyWithCompanion(PlannerTasksCompanion data) {
    return PlannerTask(
      id: data.id.present ? data.id.value : this.id,
      day: data.day.present ? data.day.value : this.day,
      title: data.title.present ? data.title.value : this.title,
      details: data.details.present ? data.details.value : this.details,
      delegatedTo: data.delegatedTo.present
          ? data.delegatedTo.value
          : this.delegatedTo,
      priority: data.priority.present ? data.priority.value : this.priority,
      position: data.position.present ? data.position.value : this.position,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlannerTask(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('title: $title, ')
          ..write('details: $details, ')
          ..write('delegatedTo: $delegatedTo, ')
          ..write('priority: $priority, ')
          ..write('position: $position, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    day,
    title,
    details,
    delegatedTo,
    priority,
    position,
    status,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlannerTask &&
          other.id == this.id &&
          other.day == this.day &&
          other.title == this.title &&
          other.details == this.details &&
          other.delegatedTo == this.delegatedTo &&
          other.priority == this.priority &&
          other.position == this.position &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class PlannerTasksCompanion extends UpdateCompanion<PlannerTask> {
  final Value<int> id;
  final Value<String> day;
  final Value<String> title;
  final Value<String> details;
  final Value<String> delegatedTo;
  final Value<String> priority;
  final Value<int> position;
  final Value<String> status;
  final Value<DateTime> createdAt;
  const PlannerTasksCompanion({
    this.id = const Value.absent(),
    this.day = const Value.absent(),
    this.title = const Value.absent(),
    this.details = const Value.absent(),
    this.delegatedTo = const Value.absent(),
    this.priority = const Value.absent(),
    this.position = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PlannerTasksCompanion.insert({
    this.id = const Value.absent(),
    required String day,
    required String title,
    this.details = const Value.absent(),
    this.delegatedTo = const Value.absent(),
    this.priority = const Value.absent(),
    this.position = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime createdAt,
  }) : day = Value(day),
       title = Value(title),
       createdAt = Value(createdAt);
  static Insertable<PlannerTask> custom({
    Expression<int>? id,
    Expression<String>? day,
    Expression<String>? title,
    Expression<String>? details,
    Expression<String>? delegatedTo,
    Expression<String>? priority,
    Expression<int>? position,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (day != null) 'day': day,
      if (title != null) 'title': title,
      if (details != null) 'details': details,
      if (delegatedTo != null) 'delegated_to': delegatedTo,
      if (priority != null) 'priority': priority,
      if (position != null) 'position': position,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PlannerTasksCompanion copyWith({
    Value<int>? id,
    Value<String>? day,
    Value<String>? title,
    Value<String>? details,
    Value<String>? delegatedTo,
    Value<String>? priority,
    Value<int>? position,
    Value<String>? status,
    Value<DateTime>? createdAt,
  }) {
    return PlannerTasksCompanion(
      id: id ?? this.id,
      day: day ?? this.day,
      title: title ?? this.title,
      details: details ?? this.details,
      delegatedTo: delegatedTo ?? this.delegatedTo,
      priority: priority ?? this.priority,
      position: position ?? this.position,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (delegatedTo.present) {
      map['delegated_to'] = Variable<String>(delegatedTo.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlannerTasksCompanion(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('title: $title, ')
          ..write('details: $details, ')
          ..write('delegatedTo: $delegatedTo, ')
          ..write('priority: $priority, ')
          ..write('position: $position, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TaskHistoriesTable extends TaskHistories
    with TableInfo<$TaskHistoriesTable, TaskHistory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskHistoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES planner_tasks (id)',
    ),
  );
  static const VerificationMeta _fromStatusMeta = const VerificationMeta(
    'fromStatus',
  );
  @override
  late final GeneratedColumn<String> fromStatus = GeneratedColumn<String>(
    'from_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toStatusMeta = const VerificationMeta(
    'toStatus',
  );
  @override
  late final GeneratedColumn<String> toStatus = GeneratedColumn<String>(
    'to_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromDayMeta = const VerificationMeta(
    'fromDay',
  );
  @override
  late final GeneratedColumn<String> fromDay = GeneratedColumn<String>(
    'from_day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toDayMeta = const VerificationMeta('toDay');
  @override
  late final GeneratedColumn<String> toDay = GeneratedColumn<String>(
    'to_day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _changedAtMeta = const VerificationMeta(
    'changedAt',
  );
  @override
  late final GeneratedColumn<DateTime> changedAt = GeneratedColumn<DateTime>(
    'changed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    fromStatus,
    toStatus,
    fromDay,
    toDay,
    changedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_histories';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskHistory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('from_status')) {
      context.handle(
        _fromStatusMeta,
        fromStatus.isAcceptableOrUnknown(data['from_status']!, _fromStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_fromStatusMeta);
    }
    if (data.containsKey('to_status')) {
      context.handle(
        _toStatusMeta,
        toStatus.isAcceptableOrUnknown(data['to_status']!, _toStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_toStatusMeta);
    }
    if (data.containsKey('from_day')) {
      context.handle(
        _fromDayMeta,
        fromDay.isAcceptableOrUnknown(data['from_day']!, _fromDayMeta),
      );
    } else if (isInserting) {
      context.missing(_fromDayMeta);
    }
    if (data.containsKey('to_day')) {
      context.handle(
        _toDayMeta,
        toDay.isAcceptableOrUnknown(data['to_day']!, _toDayMeta),
      );
    } else if (isInserting) {
      context.missing(_toDayMeta);
    }
    if (data.containsKey('changed_at')) {
      context.handle(
        _changedAtMeta,
        changedAt.isAcceptableOrUnknown(data['changed_at']!, _changedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_changedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskHistory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskHistory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_id'],
      )!,
      fromStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_status'],
      )!,
      toStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_status'],
      )!,
      fromDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_day'],
      )!,
      toDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_day'],
      )!,
      changedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}changed_at'],
      )!,
    );
  }

  @override
  $TaskHistoriesTable createAlias(String alias) {
    return $TaskHistoriesTable(attachedDatabase, alias);
  }
}

class TaskHistory extends DataClass implements Insertable<TaskHistory> {
  final int id;
  final int taskId;
  final String fromStatus;
  final String toStatus;
  final String fromDay;
  final String toDay;
  final DateTime changedAt;
  const TaskHistory({
    required this.id,
    required this.taskId,
    required this.fromStatus,
    required this.toStatus,
    required this.fromDay,
    required this.toDay,
    required this.changedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['task_id'] = Variable<int>(taskId);
    map['from_status'] = Variable<String>(fromStatus);
    map['to_status'] = Variable<String>(toStatus);
    map['from_day'] = Variable<String>(fromDay);
    map['to_day'] = Variable<String>(toDay);
    map['changed_at'] = Variable<DateTime>(changedAt);
    return map;
  }

  TaskHistoriesCompanion toCompanion(bool nullToAbsent) {
    return TaskHistoriesCompanion(
      id: Value(id),
      taskId: Value(taskId),
      fromStatus: Value(fromStatus),
      toStatus: Value(toStatus),
      fromDay: Value(fromDay),
      toDay: Value(toDay),
      changedAt: Value(changedAt),
    );
  }

  factory TaskHistory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskHistory(
      id: serializer.fromJson<int>(json['id']),
      taskId: serializer.fromJson<int>(json['taskId']),
      fromStatus: serializer.fromJson<String>(json['fromStatus']),
      toStatus: serializer.fromJson<String>(json['toStatus']),
      fromDay: serializer.fromJson<String>(json['fromDay']),
      toDay: serializer.fromJson<String>(json['toDay']),
      changedAt: serializer.fromJson<DateTime>(json['changedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'taskId': serializer.toJson<int>(taskId),
      'fromStatus': serializer.toJson<String>(fromStatus),
      'toStatus': serializer.toJson<String>(toStatus),
      'fromDay': serializer.toJson<String>(fromDay),
      'toDay': serializer.toJson<String>(toDay),
      'changedAt': serializer.toJson<DateTime>(changedAt),
    };
  }

  TaskHistory copyWith({
    int? id,
    int? taskId,
    String? fromStatus,
    String? toStatus,
    String? fromDay,
    String? toDay,
    DateTime? changedAt,
  }) => TaskHistory(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    fromStatus: fromStatus ?? this.fromStatus,
    toStatus: toStatus ?? this.toStatus,
    fromDay: fromDay ?? this.fromDay,
    toDay: toDay ?? this.toDay,
    changedAt: changedAt ?? this.changedAt,
  );
  TaskHistory copyWithCompanion(TaskHistoriesCompanion data) {
    return TaskHistory(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      fromStatus: data.fromStatus.present
          ? data.fromStatus.value
          : this.fromStatus,
      toStatus: data.toStatus.present ? data.toStatus.value : this.toStatus,
      fromDay: data.fromDay.present ? data.fromDay.value : this.fromDay,
      toDay: data.toDay.present ? data.toDay.value : this.toDay,
      changedAt: data.changedAt.present ? data.changedAt.value : this.changedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskHistory(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('fromStatus: $fromStatus, ')
          ..write('toStatus: $toStatus, ')
          ..write('fromDay: $fromDay, ')
          ..write('toDay: $toDay, ')
          ..write('changedAt: $changedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, taskId, fromStatus, toStatus, fromDay, toDay, changedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskHistory &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.fromStatus == this.fromStatus &&
          other.toStatus == this.toStatus &&
          other.fromDay == this.fromDay &&
          other.toDay == this.toDay &&
          other.changedAt == this.changedAt);
}

class TaskHistoriesCompanion extends UpdateCompanion<TaskHistory> {
  final Value<int> id;
  final Value<int> taskId;
  final Value<String> fromStatus;
  final Value<String> toStatus;
  final Value<String> fromDay;
  final Value<String> toDay;
  final Value<DateTime> changedAt;
  const TaskHistoriesCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.fromStatus = const Value.absent(),
    this.toStatus = const Value.absent(),
    this.fromDay = const Value.absent(),
    this.toDay = const Value.absent(),
    this.changedAt = const Value.absent(),
  });
  TaskHistoriesCompanion.insert({
    this.id = const Value.absent(),
    required int taskId,
    required String fromStatus,
    required String toStatus,
    required String fromDay,
    required String toDay,
    required DateTime changedAt,
  }) : taskId = Value(taskId),
       fromStatus = Value(fromStatus),
       toStatus = Value(toStatus),
       fromDay = Value(fromDay),
       toDay = Value(toDay),
       changedAt = Value(changedAt);
  static Insertable<TaskHistory> custom({
    Expression<int>? id,
    Expression<int>? taskId,
    Expression<String>? fromStatus,
    Expression<String>? toStatus,
    Expression<String>? fromDay,
    Expression<String>? toDay,
    Expression<DateTime>? changedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (fromStatus != null) 'from_status': fromStatus,
      if (toStatus != null) 'to_status': toStatus,
      if (fromDay != null) 'from_day': fromDay,
      if (toDay != null) 'to_day': toDay,
      if (changedAt != null) 'changed_at': changedAt,
    });
  }

  TaskHistoriesCompanion copyWith({
    Value<int>? id,
    Value<int>? taskId,
    Value<String>? fromStatus,
    Value<String>? toStatus,
    Value<String>? fromDay,
    Value<String>? toDay,
    Value<DateTime>? changedAt,
  }) {
    return TaskHistoriesCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      fromStatus: fromStatus ?? this.fromStatus,
      toStatus: toStatus ?? this.toStatus,
      fromDay: fromDay ?? this.fromDay,
      toDay: toDay ?? this.toDay,
      changedAt: changedAt ?? this.changedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
    }
    if (fromStatus.present) {
      map['from_status'] = Variable<String>(fromStatus.value);
    }
    if (toStatus.present) {
      map['to_status'] = Variable<String>(toStatus.value);
    }
    if (fromDay.present) {
      map['from_day'] = Variable<String>(fromDay.value);
    }
    if (toDay.present) {
      map['to_day'] = Variable<String>(toDay.value);
    }
    if (changedAt.present) {
      map['changed_at'] = Variable<DateTime>(changedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskHistoriesCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('fromStatus: $fromStatus, ')
          ..write('toStatus: $toStatus, ')
          ..write('fromDay: $fromDay, ')
          ..write('toDay: $toDay, ')
          ..write('changedAt: $changedAt')
          ..write(')'))
        .toString();
  }
}

class $AppointmentsTable extends Appointments
    with TableInfo<$AppointmentsTable, Appointment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppointmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startMinuteMeta = const VerificationMeta(
    'startMinute',
  );
  @override
  late final GeneratedColumn<int> startMinute = GeneratedColumn<int>(
    'start_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endMinuteMeta = const VerificationMeta(
    'endMinute',
  );
  @override
  late final GeneratedColumn<int> endMinute = GeneratedColumn<int>(
    'end_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _allDayMeta = const VerificationMeta('allDay');
  @override
  late final GeneratedColumn<bool> allDay = GeneratedColumn<bool>(
    'all_day',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("all_day" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    day,
    title,
    startMinute,
    endMinute,
    allDay,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'appointments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Appointment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('start_minute')) {
      context.handle(
        _startMinuteMeta,
        startMinute.isAcceptableOrUnknown(
          data['start_minute']!,
          _startMinuteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startMinuteMeta);
    }
    if (data.containsKey('end_minute')) {
      context.handle(
        _endMinuteMeta,
        endMinute.isAcceptableOrUnknown(data['end_minute']!, _endMinuteMeta),
      );
    } else if (isInserting) {
      context.missing(_endMinuteMeta);
    }
    if (data.containsKey('all_day')) {
      context.handle(
        _allDayMeta,
        allDay.isAcceptableOrUnknown(data['all_day']!, _allDayMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Appointment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Appointment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      startMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minute'],
      )!,
      endMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_minute'],
      )!,
      allDay: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}all_day'],
      )!,
    );
  }

  @override
  $AppointmentsTable createAlias(String alias) {
    return $AppointmentsTable(attachedDatabase, alias);
  }
}

class Appointment extends DataClass implements Insertable<Appointment> {
  final int id;
  final String day;
  final String title;
  final int startMinute;
  final int endMinute;
  final bool allDay;
  const Appointment({
    required this.id,
    required this.day,
    required this.title,
    required this.startMinute,
    required this.endMinute,
    required this.allDay,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day'] = Variable<String>(day);
    map['title'] = Variable<String>(title);
    map['start_minute'] = Variable<int>(startMinute);
    map['end_minute'] = Variable<int>(endMinute);
    map['all_day'] = Variable<bool>(allDay);
    return map;
  }

  AppointmentsCompanion toCompanion(bool nullToAbsent) {
    return AppointmentsCompanion(
      id: Value(id),
      day: Value(day),
      title: Value(title),
      startMinute: Value(startMinute),
      endMinute: Value(endMinute),
      allDay: Value(allDay),
    );
  }

  factory Appointment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Appointment(
      id: serializer.fromJson<int>(json['id']),
      day: serializer.fromJson<String>(json['day']),
      title: serializer.fromJson<String>(json['title']),
      startMinute: serializer.fromJson<int>(json['startMinute']),
      endMinute: serializer.fromJson<int>(json['endMinute']),
      allDay: serializer.fromJson<bool>(json['allDay']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'day': serializer.toJson<String>(day),
      'title': serializer.toJson<String>(title),
      'startMinute': serializer.toJson<int>(startMinute),
      'endMinute': serializer.toJson<int>(endMinute),
      'allDay': serializer.toJson<bool>(allDay),
    };
  }

  Appointment copyWith({
    int? id,
    String? day,
    String? title,
    int? startMinute,
    int? endMinute,
    bool? allDay,
  }) => Appointment(
    id: id ?? this.id,
    day: day ?? this.day,
    title: title ?? this.title,
    startMinute: startMinute ?? this.startMinute,
    endMinute: endMinute ?? this.endMinute,
    allDay: allDay ?? this.allDay,
  );
  Appointment copyWithCompanion(AppointmentsCompanion data) {
    return Appointment(
      id: data.id.present ? data.id.value : this.id,
      day: data.day.present ? data.day.value : this.day,
      title: data.title.present ? data.title.value : this.title,
      startMinute: data.startMinute.present
          ? data.startMinute.value
          : this.startMinute,
      endMinute: data.endMinute.present ? data.endMinute.value : this.endMinute,
      allDay: data.allDay.present ? data.allDay.value : this.allDay,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Appointment(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('title: $title, ')
          ..write('startMinute: $startMinute, ')
          ..write('endMinute: $endMinute, ')
          ..write('allDay: $allDay')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, day, title, startMinute, endMinute, allDay);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Appointment &&
          other.id == this.id &&
          other.day == this.day &&
          other.title == this.title &&
          other.startMinute == this.startMinute &&
          other.endMinute == this.endMinute &&
          other.allDay == this.allDay);
}

class AppointmentsCompanion extends UpdateCompanion<Appointment> {
  final Value<int> id;
  final Value<String> day;
  final Value<String> title;
  final Value<int> startMinute;
  final Value<int> endMinute;
  final Value<bool> allDay;
  const AppointmentsCompanion({
    this.id = const Value.absent(),
    this.day = const Value.absent(),
    this.title = const Value.absent(),
    this.startMinute = const Value.absent(),
    this.endMinute = const Value.absent(),
    this.allDay = const Value.absent(),
  });
  AppointmentsCompanion.insert({
    this.id = const Value.absent(),
    required String day,
    required String title,
    required int startMinute,
    required int endMinute,
    this.allDay = const Value.absent(),
  }) : day = Value(day),
       title = Value(title),
       startMinute = Value(startMinute),
       endMinute = Value(endMinute);
  static Insertable<Appointment> custom({
    Expression<int>? id,
    Expression<String>? day,
    Expression<String>? title,
    Expression<int>? startMinute,
    Expression<int>? endMinute,
    Expression<bool>? allDay,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (day != null) 'day': day,
      if (title != null) 'title': title,
      if (startMinute != null) 'start_minute': startMinute,
      if (endMinute != null) 'end_minute': endMinute,
      if (allDay != null) 'all_day': allDay,
    });
  }

  AppointmentsCompanion copyWith({
    Value<int>? id,
    Value<String>? day,
    Value<String>? title,
    Value<int>? startMinute,
    Value<int>? endMinute,
    Value<bool>? allDay,
  }) {
    return AppointmentsCompanion(
      id: id ?? this.id,
      day: day ?? this.day,
      title: title ?? this.title,
      startMinute: startMinute ?? this.startMinute,
      endMinute: endMinute ?? this.endMinute,
      allDay: allDay ?? this.allDay,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (startMinute.present) {
      map['start_minute'] = Variable<int>(startMinute.value);
    }
    if (endMinute.present) {
      map['end_minute'] = Variable<int>(endMinute.value);
    }
    if (allDay.present) {
      map['all_day'] = Variable<bool>(allDay.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppointmentsCompanion(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('title: $title, ')
          ..write('startMinute: $startMinute, ')
          ..write('endMinute: $endMinute, ')
          ..write('allDay: $allDay')
          ..write(')'))
        .toString();
  }
}

class $JournalEntriesTable extends JournalEntries
    with TableInfo<$JournalEntriesTable, JournalEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deltaMeta = const VerificationMeta('delta');
  @override
  late final GeneratedColumn<String> delta = GeneratedColumn<String>(
    'delta',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plainTextMeta = const VerificationMeta(
    'plainText',
  );
  @override
  late final GeneratedColumn<String> plainText = GeneratedColumn<String>(
    'plain_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _tagsJsonMeta = const VerificationMeta(
    'tagsJson',
  );
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
    'tags_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
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
    day,
    title,
    delta,
    plainText,
    category,
    tagsJson,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('delta')) {
      context.handle(
        _deltaMeta,
        delta.isAcceptableOrUnknown(data['delta']!, _deltaMeta),
      );
    } else if (isInserting) {
      context.missing(_deltaMeta);
    }
    if (data.containsKey('plain_text')) {
      context.handle(
        _plainTextMeta,
        plainText.isAcceptableOrUnknown(data['plain_text']!, _plainTextMeta),
      );
    } else if (isInserting) {
      context.missing(_plainTextMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('tags_json')) {
      context.handle(
        _tagsJsonMeta,
        tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta),
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
  JournalEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      delta: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}delta'],
      )!,
      plainText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plain_text'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      tagsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags_json'],
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
  $JournalEntriesTable createAlias(String alias) {
    return $JournalEntriesTable(attachedDatabase, alias);
  }
}

class JournalEntry extends DataClass implements Insertable<JournalEntry> {
  final int id;
  final String day;
  final String title;
  final String delta;
  final String plainText;
  final String category;
  final String tagsJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  const JournalEntry({
    required this.id,
    required this.day,
    required this.title,
    required this.delta,
    required this.plainText,
    required this.category,
    required this.tagsJson,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day'] = Variable<String>(day);
    map['title'] = Variable<String>(title);
    map['delta'] = Variable<String>(delta);
    map['plain_text'] = Variable<String>(plainText);
    map['category'] = Variable<String>(category);
    map['tags_json'] = Variable<String>(tagsJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  JournalEntriesCompanion toCompanion(bool nullToAbsent) {
    return JournalEntriesCompanion(
      id: Value(id),
      day: Value(day),
      title: Value(title),
      delta: Value(delta),
      plainText: Value(plainText),
      category: Value(category),
      tagsJson: Value(tagsJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory JournalEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntry(
      id: serializer.fromJson<int>(json['id']),
      day: serializer.fromJson<String>(json['day']),
      title: serializer.fromJson<String>(json['title']),
      delta: serializer.fromJson<String>(json['delta']),
      plainText: serializer.fromJson<String>(json['plainText']),
      category: serializer.fromJson<String>(json['category']),
      tagsJson: serializer.fromJson<String>(json['tagsJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'day': serializer.toJson<String>(day),
      'title': serializer.toJson<String>(title),
      'delta': serializer.toJson<String>(delta),
      'plainText': serializer.toJson<String>(plainText),
      'category': serializer.toJson<String>(category),
      'tagsJson': serializer.toJson<String>(tagsJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  JournalEntry copyWith({
    int? id,
    String? day,
    String? title,
    String? delta,
    String? plainText,
    String? category,
    String? tagsJson,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => JournalEntry(
    id: id ?? this.id,
    day: day ?? this.day,
    title: title ?? this.title,
    delta: delta ?? this.delta,
    plainText: plainText ?? this.plainText,
    category: category ?? this.category,
    tagsJson: tagsJson ?? this.tagsJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  JournalEntry copyWithCompanion(JournalEntriesCompanion data) {
    return JournalEntry(
      id: data.id.present ? data.id.value : this.id,
      day: data.day.present ? data.day.value : this.day,
      title: data.title.present ? data.title.value : this.title,
      delta: data.delta.present ? data.delta.value : this.delta,
      plainText: data.plainText.present ? data.plainText.value : this.plainText,
      category: data.category.present ? data.category.value : this.category,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntry(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('title: $title, ')
          ..write('delta: $delta, ')
          ..write('plainText: $plainText, ')
          ..write('category: $category, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    day,
    title,
    delta,
    plainText,
    category,
    tagsJson,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntry &&
          other.id == this.id &&
          other.day == this.day &&
          other.title == this.title &&
          other.delta == this.delta &&
          other.plainText == this.plainText &&
          other.category == this.category &&
          other.tagsJson == this.tagsJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class JournalEntriesCompanion extends UpdateCompanion<JournalEntry> {
  final Value<int> id;
  final Value<String> day;
  final Value<String> title;
  final Value<String> delta;
  final Value<String> plainText;
  final Value<String> category;
  final Value<String> tagsJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const JournalEntriesCompanion({
    this.id = const Value.absent(),
    this.day = const Value.absent(),
    this.title = const Value.absent(),
    this.delta = const Value.absent(),
    this.plainText = const Value.absent(),
    this.category = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  JournalEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String day,
    required String title,
    required String delta,
    required String plainText,
    this.category = const Value.absent(),
    this.tagsJson = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : day = Value(day),
       title = Value(title),
       delta = Value(delta),
       plainText = Value(plainText),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<JournalEntry> custom({
    Expression<int>? id,
    Expression<String>? day,
    Expression<String>? title,
    Expression<String>? delta,
    Expression<String>? plainText,
    Expression<String>? category,
    Expression<String>? tagsJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (day != null) 'day': day,
      if (title != null) 'title': title,
      if (delta != null) 'delta': delta,
      if (plainText != null) 'plain_text': plainText,
      if (category != null) 'category': category,
      if (tagsJson != null) 'tags_json': tagsJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  JournalEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? day,
    Value<String>? title,
    Value<String>? delta,
    Value<String>? plainText,
    Value<String>? category,
    Value<String>? tagsJson,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return JournalEntriesCompanion(
      id: id ?? this.id,
      day: day ?? this.day,
      title: title ?? this.title,
      delta: delta ?? this.delta,
      plainText: plainText ?? this.plainText,
      category: category ?? this.category,
      tagsJson: tagsJson ?? this.tagsJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (delta.present) {
      map['delta'] = Variable<String>(delta.value);
    }
    if (plainText.present) {
      map['plain_text'] = Variable<String>(plainText.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntriesCompanion(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('title: $title, ')
          ..write('delta: $delta, ')
          ..write('plainText: $plainText, ')
          ..write('category: $category, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $JournalTaskLinksTable extends JournalTaskLinks
    with TableInfo<$JournalTaskLinksTable, JournalTaskLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalTaskLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<int> entryId = GeneratedColumn<int>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES journal_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES planner_tasks (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [entryId, taskId, label];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_task_links';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalTaskLink> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entryId, label};
  @override
  JournalTaskLink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalTaskLink(
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entry_id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_id'],
      ),
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
    );
  }

  @override
  $JournalTaskLinksTable createAlias(String alias) {
    return $JournalTaskLinksTable(attachedDatabase, alias);
  }
}

class JournalTaskLink extends DataClass implements Insertable<JournalTaskLink> {
  final int entryId;
  final int? taskId;
  final String label;
  const JournalTaskLink({
    required this.entryId,
    this.taskId,
    required this.label,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entry_id'] = Variable<int>(entryId);
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<int>(taskId);
    }
    map['label'] = Variable<String>(label);
    return map;
  }

  JournalTaskLinksCompanion toCompanion(bool nullToAbsent) {
    return JournalTaskLinksCompanion(
      entryId: Value(entryId),
      taskId: taskId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskId),
      label: Value(label),
    );
  }

  factory JournalTaskLink.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalTaskLink(
      entryId: serializer.fromJson<int>(json['entryId']),
      taskId: serializer.fromJson<int?>(json['taskId']),
      label: serializer.fromJson<String>(json['label']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entryId': serializer.toJson<int>(entryId),
      'taskId': serializer.toJson<int?>(taskId),
      'label': serializer.toJson<String>(label),
    };
  }

  JournalTaskLink copyWith({
    int? entryId,
    Value<int?> taskId = const Value.absent(),
    String? label,
  }) => JournalTaskLink(
    entryId: entryId ?? this.entryId,
    taskId: taskId.present ? taskId.value : this.taskId,
    label: label ?? this.label,
  );
  JournalTaskLink copyWithCompanion(JournalTaskLinksCompanion data) {
    return JournalTaskLink(
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      label: data.label.present ? data.label.value : this.label,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalTaskLink(')
          ..write('entryId: $entryId, ')
          ..write('taskId: $taskId, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entryId, taskId, label);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalTaskLink &&
          other.entryId == this.entryId &&
          other.taskId == this.taskId &&
          other.label == this.label);
}

class JournalTaskLinksCompanion extends UpdateCompanion<JournalTaskLink> {
  final Value<int> entryId;
  final Value<int?> taskId;
  final Value<String> label;
  final Value<int> rowid;
  const JournalTaskLinksCompanion({
    this.entryId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.label = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JournalTaskLinksCompanion.insert({
    required int entryId,
    this.taskId = const Value.absent(),
    required String label,
    this.rowid = const Value.absent(),
  }) : entryId = Value(entryId),
       label = Value(label);
  static Insertable<JournalTaskLink> custom({
    Expression<int>? entryId,
    Expression<int>? taskId,
    Expression<String>? label,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entryId != null) 'entry_id': entryId,
      if (taskId != null) 'task_id': taskId,
      if (label != null) 'label': label,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JournalTaskLinksCompanion copyWith({
    Value<int>? entryId,
    Value<int?>? taskId,
    Value<String>? label,
    Value<int>? rowid,
  }) {
    return JournalTaskLinksCompanion(
      entryId: entryId ?? this.entryId,
      taskId: taskId ?? this.taskId,
      label: label ?? this.label,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entryId.present) {
      map['entry_id'] = Variable<int>(entryId.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalTaskLinksCompanion(')
          ..write('entryId: $entryId, ')
          ..write('taskId: $taskId, ')
          ..write('label: $label, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JournalAppointmentLinksTable extends JournalAppointmentLinks
    with TableInfo<$JournalAppointmentLinksTable, JournalAppointmentLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalAppointmentLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<int> entryId = GeneratedColumn<int>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES journal_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _appointmentIdMeta = const VerificationMeta(
    'appointmentId',
  );
  @override
  late final GeneratedColumn<int> appointmentId = GeneratedColumn<int>(
    'appointment_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES appointments (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [entryId, appointmentId, label];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_appointment_links';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalAppointmentLink> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('appointment_id')) {
      context.handle(
        _appointmentIdMeta,
        appointmentId.isAcceptableOrUnknown(
          data['appointment_id']!,
          _appointmentIdMeta,
        ),
      );
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entryId, label};
  @override
  JournalAppointmentLink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalAppointmentLink(
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entry_id'],
      )!,
      appointmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}appointment_id'],
      ),
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
    );
  }

  @override
  $JournalAppointmentLinksTable createAlias(String alias) {
    return $JournalAppointmentLinksTable(attachedDatabase, alias);
  }
}

class JournalAppointmentLink extends DataClass
    implements Insertable<JournalAppointmentLink> {
  final int entryId;
  final int? appointmentId;
  final String label;
  const JournalAppointmentLink({
    required this.entryId,
    this.appointmentId,
    required this.label,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entry_id'] = Variable<int>(entryId);
    if (!nullToAbsent || appointmentId != null) {
      map['appointment_id'] = Variable<int>(appointmentId);
    }
    map['label'] = Variable<String>(label);
    return map;
  }

  JournalAppointmentLinksCompanion toCompanion(bool nullToAbsent) {
    return JournalAppointmentLinksCompanion(
      entryId: Value(entryId),
      appointmentId: appointmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(appointmentId),
      label: Value(label),
    );
  }

  factory JournalAppointmentLink.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalAppointmentLink(
      entryId: serializer.fromJson<int>(json['entryId']),
      appointmentId: serializer.fromJson<int?>(json['appointmentId']),
      label: serializer.fromJson<String>(json['label']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entryId': serializer.toJson<int>(entryId),
      'appointmentId': serializer.toJson<int?>(appointmentId),
      'label': serializer.toJson<String>(label),
    };
  }

  JournalAppointmentLink copyWith({
    int? entryId,
    Value<int?> appointmentId = const Value.absent(),
    String? label,
  }) => JournalAppointmentLink(
    entryId: entryId ?? this.entryId,
    appointmentId: appointmentId.present
        ? appointmentId.value
        : this.appointmentId,
    label: label ?? this.label,
  );
  JournalAppointmentLink copyWithCompanion(
    JournalAppointmentLinksCompanion data,
  ) {
    return JournalAppointmentLink(
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      appointmentId: data.appointmentId.present
          ? data.appointmentId.value
          : this.appointmentId,
      label: data.label.present ? data.label.value : this.label,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalAppointmentLink(')
          ..write('entryId: $entryId, ')
          ..write('appointmentId: $appointmentId, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entryId, appointmentId, label);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalAppointmentLink &&
          other.entryId == this.entryId &&
          other.appointmentId == this.appointmentId &&
          other.label == this.label);
}

class JournalAppointmentLinksCompanion
    extends UpdateCompanion<JournalAppointmentLink> {
  final Value<int> entryId;
  final Value<int?> appointmentId;
  final Value<String> label;
  final Value<int> rowid;
  const JournalAppointmentLinksCompanion({
    this.entryId = const Value.absent(),
    this.appointmentId = const Value.absent(),
    this.label = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JournalAppointmentLinksCompanion.insert({
    required int entryId,
    this.appointmentId = const Value.absent(),
    required String label,
    this.rowid = const Value.absent(),
  }) : entryId = Value(entryId),
       label = Value(label);
  static Insertable<JournalAppointmentLink> custom({
    Expression<int>? entryId,
    Expression<int>? appointmentId,
    Expression<String>? label,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entryId != null) 'entry_id': entryId,
      if (appointmentId != null) 'appointment_id': appointmentId,
      if (label != null) 'label': label,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JournalAppointmentLinksCompanion copyWith({
    Value<int>? entryId,
    Value<int?>? appointmentId,
    Value<String>? label,
    Value<int>? rowid,
  }) {
    return JournalAppointmentLinksCompanion(
      entryId: entryId ?? this.entryId,
      appointmentId: appointmentId ?? this.appointmentId,
      label: label ?? this.label,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entryId.present) {
      map['entry_id'] = Variable<int>(entryId.value);
    }
    if (appointmentId.present) {
      map['appointment_id'] = Variable<int>(appointmentId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalAppointmentLinksCompanion(')
          ..write('entryId: $entryId, ')
          ..write('appointmentId: $appointmentId, ')
          ..write('label: $label, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JournalAttachmentsTable extends JournalAttachments
    with TableInfo<$JournalAttachmentsTable, JournalAttachment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalAttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<int> entryId = GeneratedColumn<int>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES journal_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _filenameMeta = const VerificationMeta(
    'filename',
  );
  @override
  late final GeneratedColumn<String> filename = GeneratedColumn<String>(
    'filename',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _captionMeta = const VerificationMeta(
    'caption',
  );
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
    'caption',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _bytesMeta = const VerificationMeta('bytes');
  @override
  late final GeneratedColumn<int> bytes = GeneratedColumn<int>(
    'bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
    entryId,
    filename,
    displayName,
    kind,
    caption,
    bytes,
    position,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_attachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalAttachment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('filename')) {
      context.handle(
        _filenameMeta,
        filename.isAcceptableOrUnknown(data['filename']!, _filenameMeta),
      );
    } else if (isInserting) {
      context.missing(_filenameMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('caption')) {
      context.handle(
        _captionMeta,
        caption.isAcceptableOrUnknown(data['caption']!, _captionMeta),
      );
    }
    if (data.containsKey('bytes')) {
      context.handle(
        _bytesMeta,
        bytes.isAcceptableOrUnknown(data['bytes']!, _bytesMeta),
      );
    } else if (isInserting) {
      context.missing(_bytesMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
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
  JournalAttachment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalAttachment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entry_id'],
      )!,
      filename: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}filename'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      caption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption'],
      )!,
      bytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bytes'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $JournalAttachmentsTable createAlias(String alias) {
    return $JournalAttachmentsTable(attachedDatabase, alias);
  }
}

class JournalAttachment extends DataClass
    implements Insertable<JournalAttachment> {
  final String id;
  final int entryId;
  final String filename;
  final String displayName;
  final String kind;
  final String caption;
  final int bytes;
  final int position;
  final DateTime createdAt;
  const JournalAttachment({
    required this.id,
    required this.entryId,
    required this.filename,
    required this.displayName,
    required this.kind,
    required this.caption,
    required this.bytes,
    required this.position,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entry_id'] = Variable<int>(entryId);
    map['filename'] = Variable<String>(filename);
    map['display_name'] = Variable<String>(displayName);
    map['kind'] = Variable<String>(kind);
    map['caption'] = Variable<String>(caption);
    map['bytes'] = Variable<int>(bytes);
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  JournalAttachmentsCompanion toCompanion(bool nullToAbsent) {
    return JournalAttachmentsCompanion(
      id: Value(id),
      entryId: Value(entryId),
      filename: Value(filename),
      displayName: Value(displayName),
      kind: Value(kind),
      caption: Value(caption),
      bytes: Value(bytes),
      position: Value(position),
      createdAt: Value(createdAt),
    );
  }

  factory JournalAttachment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalAttachment(
      id: serializer.fromJson<String>(json['id']),
      entryId: serializer.fromJson<int>(json['entryId']),
      filename: serializer.fromJson<String>(json['filename']),
      displayName: serializer.fromJson<String>(json['displayName']),
      kind: serializer.fromJson<String>(json['kind']),
      caption: serializer.fromJson<String>(json['caption']),
      bytes: serializer.fromJson<int>(json['bytes']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entryId': serializer.toJson<int>(entryId),
      'filename': serializer.toJson<String>(filename),
      'displayName': serializer.toJson<String>(displayName),
      'kind': serializer.toJson<String>(kind),
      'caption': serializer.toJson<String>(caption),
      'bytes': serializer.toJson<int>(bytes),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  JournalAttachment copyWith({
    String? id,
    int? entryId,
    String? filename,
    String? displayName,
    String? kind,
    String? caption,
    int? bytes,
    int? position,
    DateTime? createdAt,
  }) => JournalAttachment(
    id: id ?? this.id,
    entryId: entryId ?? this.entryId,
    filename: filename ?? this.filename,
    displayName: displayName ?? this.displayName,
    kind: kind ?? this.kind,
    caption: caption ?? this.caption,
    bytes: bytes ?? this.bytes,
    position: position ?? this.position,
    createdAt: createdAt ?? this.createdAt,
  );
  JournalAttachment copyWithCompanion(JournalAttachmentsCompanion data) {
    return JournalAttachment(
      id: data.id.present ? data.id.value : this.id,
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      filename: data.filename.present ? data.filename.value : this.filename,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      kind: data.kind.present ? data.kind.value : this.kind,
      caption: data.caption.present ? data.caption.value : this.caption,
      bytes: data.bytes.present ? data.bytes.value : this.bytes,
      position: data.position.present ? data.position.value : this.position,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalAttachment(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('filename: $filename, ')
          ..write('displayName: $displayName, ')
          ..write('kind: $kind, ')
          ..write('caption: $caption, ')
          ..write('bytes: $bytes, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entryId,
    filename,
    displayName,
    kind,
    caption,
    bytes,
    position,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalAttachment &&
          other.id == this.id &&
          other.entryId == this.entryId &&
          other.filename == this.filename &&
          other.displayName == this.displayName &&
          other.kind == this.kind &&
          other.caption == this.caption &&
          other.bytes == this.bytes &&
          other.position == this.position &&
          other.createdAt == this.createdAt);
}

class JournalAttachmentsCompanion extends UpdateCompanion<JournalAttachment> {
  final Value<String> id;
  final Value<int> entryId;
  final Value<String> filename;
  final Value<String> displayName;
  final Value<String> kind;
  final Value<String> caption;
  final Value<int> bytes;
  final Value<int> position;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const JournalAttachmentsCompanion({
    this.id = const Value.absent(),
    this.entryId = const Value.absent(),
    this.filename = const Value.absent(),
    this.displayName = const Value.absent(),
    this.kind = const Value.absent(),
    this.caption = const Value.absent(),
    this.bytes = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JournalAttachmentsCompanion.insert({
    required String id,
    required int entryId,
    required String filename,
    required String displayName,
    required String kind,
    this.caption = const Value.absent(),
    required int bytes,
    required int position,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entryId = Value(entryId),
       filename = Value(filename),
       displayName = Value(displayName),
       kind = Value(kind),
       bytes = Value(bytes),
       position = Value(position),
       createdAt = Value(createdAt);
  static Insertable<JournalAttachment> custom({
    Expression<String>? id,
    Expression<int>? entryId,
    Expression<String>? filename,
    Expression<String>? displayName,
    Expression<String>? kind,
    Expression<String>? caption,
    Expression<int>? bytes,
    Expression<int>? position,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entryId != null) 'entry_id': entryId,
      if (filename != null) 'filename': filename,
      if (displayName != null) 'display_name': displayName,
      if (kind != null) 'kind': kind,
      if (caption != null) 'caption': caption,
      if (bytes != null) 'bytes': bytes,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JournalAttachmentsCompanion copyWith({
    Value<String>? id,
    Value<int>? entryId,
    Value<String>? filename,
    Value<String>? displayName,
    Value<String>? kind,
    Value<String>? caption,
    Value<int>? bytes,
    Value<int>? position,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return JournalAttachmentsCompanion(
      id: id ?? this.id,
      entryId: entryId ?? this.entryId,
      filename: filename ?? this.filename,
      displayName: displayName ?? this.displayName,
      kind: kind ?? this.kind,
      caption: caption ?? this.caption,
      bytes: bytes ?? this.bytes,
      position: position ?? this.position,
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
    if (entryId.present) {
      map['entry_id'] = Variable<int>(entryId.value);
    }
    if (filename.present) {
      map['filename'] = Variable<String>(filename.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    if (bytes.present) {
      map['bytes'] = Variable<int>(bytes.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
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
    return (StringBuffer('JournalAttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('filename: $filename, ')
          ..write('displayName: $displayName, ')
          ..write('kind: $kind, ')
          ..write('caption: $caption, ')
          ..write('bytes: $bytes, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PersonalRolesTable extends PersonalRoles
    with TableInfo<$PersonalRolesTable, PersonalRole> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonalRolesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
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
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'personal_roles';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersonalRole> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
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
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersonalRole map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonalRole(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
    );
  }

  @override
  $PersonalRolesTable createAlias(String alias) {
    return $PersonalRolesTable(attachedDatabase, alias);
  }
}

class PersonalRole extends DataClass implements Insertable<PersonalRole> {
  final int id;
  final String name;
  final String description;
  const PersonalRole({
    required this.id,
    required this.name,
    required this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    return map;
  }

  PersonalRolesCompanion toCompanion(bool nullToAbsent) {
    return PersonalRolesCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
    );
  }

  factory PersonalRole.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonalRole(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
    };
  }

  PersonalRole copyWith({int? id, String? name, String? description}) =>
      PersonalRole(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
      );
  PersonalRole copyWithCompanion(PersonalRolesCompanion data) {
    return PersonalRole(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonalRole(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonalRole &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description);
}

class PersonalRolesCompanion extends UpdateCompanion<PersonalRole> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> description;
  const PersonalRolesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
  });
  PersonalRolesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
  }) : name = Value(name);
  static Insertable<PersonalRole> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
    });
  }

  PersonalRolesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? description,
  }) {
    return PersonalRolesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonalRolesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $GoalsTable extends Goals with TableInfo<$GoalsTable, Goal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
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
  static const VerificationMeta _horizonMeta = const VerificationMeta(
    'horizon',
  );
  @override
  late final GeneratedColumn<String> horizon = GeneratedColumn<String>(
    'horizon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetDayMeta = const VerificationMeta(
    'targetDay',
  );
  @override
  late final GeneratedColumn<String> targetDay = GeneratedColumn<String>(
    'target_day',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roleIdMeta = const VerificationMeta('roleId');
  @override
  late final GeneratedColumn<int> roleId = GeneratedColumn<int>(
    'role_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES personal_roles (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('open'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    horizon,
    targetDay,
    roleId,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Goal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
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
    if (data.containsKey('horizon')) {
      context.handle(
        _horizonMeta,
        horizon.isAcceptableOrUnknown(data['horizon']!, _horizonMeta),
      );
    } else if (isInserting) {
      context.missing(_horizonMeta);
    }
    if (data.containsKey('target_day')) {
      context.handle(
        _targetDayMeta,
        targetDay.isAcceptableOrUnknown(data['target_day']!, _targetDayMeta),
      );
    }
    if (data.containsKey('role_id')) {
      context.handle(
        _roleIdMeta,
        roleId.isAcceptableOrUnknown(data['role_id']!, _roleIdMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Goal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Goal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      horizon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}horizon'],
      )!,
      targetDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_day'],
      ),
      roleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}role_id'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }
}

class Goal extends DataClass implements Insertable<Goal> {
  final int id;
  final String title;
  final String description;
  final String horizon;
  final String? targetDay;
  final int? roleId;
  final String status;
  const Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.horizon,
    this.targetDay,
    this.roleId,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['horizon'] = Variable<String>(horizon);
    if (!nullToAbsent || targetDay != null) {
      map['target_day'] = Variable<String>(targetDay);
    }
    if (!nullToAbsent || roleId != null) {
      map['role_id'] = Variable<int>(roleId);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      horizon: Value(horizon),
      targetDay: targetDay == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDay),
      roleId: roleId == null && nullToAbsent
          ? const Value.absent()
          : Value(roleId),
      status: Value(status),
    );
  }

  factory Goal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Goal(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      horizon: serializer.fromJson<String>(json['horizon']),
      targetDay: serializer.fromJson<String?>(json['targetDay']),
      roleId: serializer.fromJson<int?>(json['roleId']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'horizon': serializer.toJson<String>(horizon),
      'targetDay': serializer.toJson<String?>(targetDay),
      'roleId': serializer.toJson<int?>(roleId),
      'status': serializer.toJson<String>(status),
    };
  }

  Goal copyWith({
    int? id,
    String? title,
    String? description,
    String? horizon,
    Value<String?> targetDay = const Value.absent(),
    Value<int?> roleId = const Value.absent(),
    String? status,
  }) => Goal(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    horizon: horizon ?? this.horizon,
    targetDay: targetDay.present ? targetDay.value : this.targetDay,
    roleId: roleId.present ? roleId.value : this.roleId,
    status: status ?? this.status,
  );
  Goal copyWithCompanion(GoalsCompanion data) {
    return Goal(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      horizon: data.horizon.present ? data.horizon.value : this.horizon,
      targetDay: data.targetDay.present ? data.targetDay.value : this.targetDay,
      roleId: data.roleId.present ? data.roleId.value : this.roleId,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Goal(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('horizon: $horizon, ')
          ..write('targetDay: $targetDay, ')
          ..write('roleId: $roleId, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, description, horizon, targetDay, roleId, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Goal &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.horizon == this.horizon &&
          other.targetDay == this.targetDay &&
          other.roleId == this.roleId &&
          other.status == this.status);
}

class GoalsCompanion extends UpdateCompanion<Goal> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String> horizon;
  final Value<String?> targetDay;
  final Value<int?> roleId;
  final Value<String> status;
  const GoalsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.horizon = const Value.absent(),
    this.targetDay = const Value.absent(),
    this.roleId = const Value.absent(),
    this.status = const Value.absent(),
  });
  GoalsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String description,
    required String horizon,
    this.targetDay = const Value.absent(),
    this.roleId = const Value.absent(),
    this.status = const Value.absent(),
  }) : title = Value(title),
       description = Value(description),
       horizon = Value(horizon);
  static Insertable<Goal> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? horizon,
    Expression<String>? targetDay,
    Expression<int>? roleId,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (horizon != null) 'horizon': horizon,
      if (targetDay != null) 'target_day': targetDay,
      if (roleId != null) 'role_id': roleId,
      if (status != null) 'status': status,
    });
  }

  GoalsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? description,
    Value<String>? horizon,
    Value<String?>? targetDay,
    Value<int?>? roleId,
    Value<String>? status,
  }) {
    return GoalsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      horizon: horizon ?? this.horizon,
      targetDay: targetDay ?? this.targetDay,
      roleId: roleId ?? this.roleId,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (horizon.present) {
      map['horizon'] = Variable<String>(horizon.value);
    }
    if (targetDay.present) {
      map['target_day'] = Variable<String>(targetDay.value);
    }
    if (roleId.present) {
      map['role_id'] = Variable<int>(roleId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('horizon: $horizon, ')
          ..write('targetDay: $targetDay, ')
          ..write('roleId: $roleId, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $GoalMilestonesTable extends GoalMilestones
    with TableInfo<$GoalMilestonesTable, GoalMilestone> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalMilestonesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<int> goalId = GeneratedColumn<int>(
    'goal_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES goals (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  List<GeneratedColumn> get $columns => [id, goalId, title, completed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goal_milestones';
  @override
  VerificationContext validateIntegrity(
    Insertable<GoalMilestone> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
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
  GoalMilestone map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalMilestone(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goal_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
    );
  }

  @override
  $GoalMilestonesTable createAlias(String alias) {
    return $GoalMilestonesTable(attachedDatabase, alias);
  }
}

class GoalMilestone extends DataClass implements Insertable<GoalMilestone> {
  final int id;
  final int goalId;
  final String title;
  final bool completed;
  const GoalMilestone({
    required this.id,
    required this.goalId,
    required this.title,
    required this.completed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['goal_id'] = Variable<int>(goalId);
    map['title'] = Variable<String>(title);
    map['completed'] = Variable<bool>(completed);
    return map;
  }

  GoalMilestonesCompanion toCompanion(bool nullToAbsent) {
    return GoalMilestonesCompanion(
      id: Value(id),
      goalId: Value(goalId),
      title: Value(title),
      completed: Value(completed),
    );
  }

  factory GoalMilestone.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalMilestone(
      id: serializer.fromJson<int>(json['id']),
      goalId: serializer.fromJson<int>(json['goalId']),
      title: serializer.fromJson<String>(json['title']),
      completed: serializer.fromJson<bool>(json['completed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'goalId': serializer.toJson<int>(goalId),
      'title': serializer.toJson<String>(title),
      'completed': serializer.toJson<bool>(completed),
    };
  }

  GoalMilestone copyWith({
    int? id,
    int? goalId,
    String? title,
    bool? completed,
  }) => GoalMilestone(
    id: id ?? this.id,
    goalId: goalId ?? this.goalId,
    title: title ?? this.title,
    completed: completed ?? this.completed,
  );
  GoalMilestone copyWithCompanion(GoalMilestonesCompanion data) {
    return GoalMilestone(
      id: data.id.present ? data.id.value : this.id,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      title: data.title.present ? data.title.value : this.title,
      completed: data.completed.present ? data.completed.value : this.completed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalMilestone(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('title: $title, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, goalId, title, completed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalMilestone &&
          other.id == this.id &&
          other.goalId == this.goalId &&
          other.title == this.title &&
          other.completed == this.completed);
}

class GoalMilestonesCompanion extends UpdateCompanion<GoalMilestone> {
  final Value<int> id;
  final Value<int> goalId;
  final Value<String> title;
  final Value<bool> completed;
  const GoalMilestonesCompanion({
    this.id = const Value.absent(),
    this.goalId = const Value.absent(),
    this.title = const Value.absent(),
    this.completed = const Value.absent(),
  });
  GoalMilestonesCompanion.insert({
    this.id = const Value.absent(),
    required int goalId,
    required String title,
    this.completed = const Value.absent(),
  }) : goalId = Value(goalId),
       title = Value(title);
  static Insertable<GoalMilestone> custom({
    Expression<int>? id,
    Expression<int>? goalId,
    Expression<String>? title,
    Expression<bool>? completed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalId != null) 'goal_id': goalId,
      if (title != null) 'title': title,
      if (completed != null) 'completed': completed,
    });
  }

  GoalMilestonesCompanion copyWith({
    Value<int>? id,
    Value<int>? goalId,
    Value<String>? title,
    Value<bool>? completed,
  }) {
    return GoalMilestonesCompanion(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<int>(goalId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalMilestonesCompanion(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('title: $title, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }
}

class $TaskGoalLinksTable extends TaskGoalLinks
    with TableInfo<$TaskGoalLinksTable, TaskGoalLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskGoalLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES planner_tasks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<int> goalId = GeneratedColumn<int>(
    'goal_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES goals (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [taskId, goalId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_goal_links';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskGoalLink> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {taskId};
  @override
  TaskGoalLink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskGoalLink(
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_id'],
      )!,
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goal_id'],
      )!,
    );
  }

  @override
  $TaskGoalLinksTable createAlias(String alias) {
    return $TaskGoalLinksTable(attachedDatabase, alias);
  }
}

class TaskGoalLink extends DataClass implements Insertable<TaskGoalLink> {
  final int taskId;
  final int goalId;
  const TaskGoalLink({required this.taskId, required this.goalId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['task_id'] = Variable<int>(taskId);
    map['goal_id'] = Variable<int>(goalId);
    return map;
  }

  TaskGoalLinksCompanion toCompanion(bool nullToAbsent) {
    return TaskGoalLinksCompanion(taskId: Value(taskId), goalId: Value(goalId));
  }

  factory TaskGoalLink.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskGoalLink(
      taskId: serializer.fromJson<int>(json['taskId']),
      goalId: serializer.fromJson<int>(json['goalId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'taskId': serializer.toJson<int>(taskId),
      'goalId': serializer.toJson<int>(goalId),
    };
  }

  TaskGoalLink copyWith({int? taskId, int? goalId}) => TaskGoalLink(
    taskId: taskId ?? this.taskId,
    goalId: goalId ?? this.goalId,
  );
  TaskGoalLink copyWithCompanion(TaskGoalLinksCompanion data) {
    return TaskGoalLink(
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskGoalLink(')
          ..write('taskId: $taskId, ')
          ..write('goalId: $goalId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(taskId, goalId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskGoalLink &&
          other.taskId == this.taskId &&
          other.goalId == this.goalId);
}

class TaskGoalLinksCompanion extends UpdateCompanion<TaskGoalLink> {
  final Value<int> taskId;
  final Value<int> goalId;
  const TaskGoalLinksCompanion({
    this.taskId = const Value.absent(),
    this.goalId = const Value.absent(),
  });
  TaskGoalLinksCompanion.insert({
    this.taskId = const Value.absent(),
    required int goalId,
  }) : goalId = Value(goalId);
  static Insertable<TaskGoalLink> custom({
    Expression<int>? taskId,
    Expression<int>? goalId,
  }) {
    return RawValuesInsertable({
      if (taskId != null) 'task_id': taskId,
      if (goalId != null) 'goal_id': goalId,
    });
  }

  TaskGoalLinksCompanion copyWith({Value<int>? taskId, Value<int>? goalId}) {
    return TaskGoalLinksCompanion(
      taskId: taskId ?? this.taskId,
      goalId: goalId ?? this.goalId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<int>(goalId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskGoalLinksCompanion(')
          ..write('taskId: $taskId, ')
          ..write('goalId: $goalId')
          ..write(')'))
        .toString();
  }
}

class $PeriodPlansTable extends PeriodPlans
    with TableInfo<$PeriodPlansTable, PeriodPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PeriodPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prioritiesMeta = const VerificationMeta(
    'priorities',
  );
  @override
  late final GeneratedColumn<String> priorities = GeneratedColumn<String>(
    'priorities',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _outcomesMeta = const VerificationMeta(
    'outcomes',
  );
  @override
  late final GeneratedColumn<String> outcomes = GeneratedColumn<String>(
    'outcomes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _reviewMeta = const VerificationMeta('review');
  @override
  late final GeneratedColumn<String> review = GeneratedColumn<String>(
    'review',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [key, priorities, outcomes, review];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'period_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<PeriodPlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('priorities')) {
      context.handle(
        _prioritiesMeta,
        priorities.isAcceptableOrUnknown(data['priorities']!, _prioritiesMeta),
      );
    }
    if (data.containsKey('outcomes')) {
      context.handle(
        _outcomesMeta,
        outcomes.isAcceptableOrUnknown(data['outcomes']!, _outcomesMeta),
      );
    }
    if (data.containsKey('review')) {
      context.handle(
        _reviewMeta,
        review.isAcceptableOrUnknown(data['review']!, _reviewMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  PeriodPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PeriodPlan(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      priorities: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priorities'],
      )!,
      outcomes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outcomes'],
      )!,
      review: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}review'],
      )!,
    );
  }

  @override
  $PeriodPlansTable createAlias(String alias) {
    return $PeriodPlansTable(attachedDatabase, alias);
  }
}

class PeriodPlan extends DataClass implements Insertable<PeriodPlan> {
  final String key;
  final String priorities;
  final String outcomes;
  final String review;
  const PeriodPlan({
    required this.key,
    required this.priorities,
    required this.outcomes,
    required this.review,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['priorities'] = Variable<String>(priorities);
    map['outcomes'] = Variable<String>(outcomes);
    map['review'] = Variable<String>(review);
    return map;
  }

  PeriodPlansCompanion toCompanion(bool nullToAbsent) {
    return PeriodPlansCompanion(
      key: Value(key),
      priorities: Value(priorities),
      outcomes: Value(outcomes),
      review: Value(review),
    );
  }

  factory PeriodPlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PeriodPlan(
      key: serializer.fromJson<String>(json['key']),
      priorities: serializer.fromJson<String>(json['priorities']),
      outcomes: serializer.fromJson<String>(json['outcomes']),
      review: serializer.fromJson<String>(json['review']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'priorities': serializer.toJson<String>(priorities),
      'outcomes': serializer.toJson<String>(outcomes),
      'review': serializer.toJson<String>(review),
    };
  }

  PeriodPlan copyWith({
    String? key,
    String? priorities,
    String? outcomes,
    String? review,
  }) => PeriodPlan(
    key: key ?? this.key,
    priorities: priorities ?? this.priorities,
    outcomes: outcomes ?? this.outcomes,
    review: review ?? this.review,
  );
  PeriodPlan copyWithCompanion(PeriodPlansCompanion data) {
    return PeriodPlan(
      key: data.key.present ? data.key.value : this.key,
      priorities: data.priorities.present
          ? data.priorities.value
          : this.priorities,
      outcomes: data.outcomes.present ? data.outcomes.value : this.outcomes,
      review: data.review.present ? data.review.value : this.review,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PeriodPlan(')
          ..write('key: $key, ')
          ..write('priorities: $priorities, ')
          ..write('outcomes: $outcomes, ')
          ..write('review: $review')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, priorities, outcomes, review);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PeriodPlan &&
          other.key == this.key &&
          other.priorities == this.priorities &&
          other.outcomes == this.outcomes &&
          other.review == this.review);
}

class PeriodPlansCompanion extends UpdateCompanion<PeriodPlan> {
  final Value<String> key;
  final Value<String> priorities;
  final Value<String> outcomes;
  final Value<String> review;
  final Value<int> rowid;
  const PeriodPlansCompanion({
    this.key = const Value.absent(),
    this.priorities = const Value.absent(),
    this.outcomes = const Value.absent(),
    this.review = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PeriodPlansCompanion.insert({
    required String key,
    this.priorities = const Value.absent(),
    this.outcomes = const Value.absent(),
    this.review = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key);
  static Insertable<PeriodPlan> custom({
    Expression<String>? key,
    Expression<String>? priorities,
    Expression<String>? outcomes,
    Expression<String>? review,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (priorities != null) 'priorities': priorities,
      if (outcomes != null) 'outcomes': outcomes,
      if (review != null) 'review': review,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PeriodPlansCompanion copyWith({
    Value<String>? key,
    Value<String>? priorities,
    Value<String>? outcomes,
    Value<String>? review,
    Value<int>? rowid,
  }) {
    return PeriodPlansCompanion(
      key: key ?? this.key,
      priorities: priorities ?? this.priorities,
      outcomes: outcomes ?? this.outcomes,
      review: review ?? this.review,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (priorities.present) {
      map['priorities'] = Variable<String>(priorities.value);
    }
    if (outcomes.present) {
      map['outcomes'] = Variable<String>(outcomes.value);
    }
    if (review.present) {
      map['review'] = Variable<String>(review.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeriodPlansCompanion(')
          ..write('key: $key, ')
          ..write('priorities: $priorities, ')
          ..write('outcomes: $outcomes, ')
          ..write('review: $review, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MasterTasksTable extends MasterTasks
    with TableInfo<$MasterTasksTable, MasterTask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MasterTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _periodKeyMeta = const VerificationMeta(
    'periodKey',
  );
  @override
  late final GeneratedColumn<String> periodKey = GeneratedColumn<String>(
    'period_key',
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<int> goalId = GeneratedColumn<int>(
    'goal_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES goals (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES planner_tasks (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _scheduledMeta = const VerificationMeta(
    'scheduled',
  );
  @override
  late final GeneratedColumn<bool> scheduled = GeneratedColumn<bool>(
    'scheduled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("scheduled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    periodKey,
    title,
    goalId,
    taskId,
    scheduled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'master_tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<MasterTask> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('period_key')) {
      context.handle(
        _periodKeyMeta,
        periodKey.isAcceptableOrUnknown(data['period_key']!, _periodKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_periodKeyMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('scheduled')) {
      context.handle(
        _scheduledMeta,
        scheduled.isAcceptableOrUnknown(data['scheduled']!, _scheduledMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MasterTask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MasterTask(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      periodKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period_key'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goal_id'],
      ),
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_id'],
      ),
      scheduled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}scheduled'],
      )!,
    );
  }

  @override
  $MasterTasksTable createAlias(String alias) {
    return $MasterTasksTable(attachedDatabase, alias);
  }
}

class MasterTask extends DataClass implements Insertable<MasterTask> {
  final int id;
  final String periodKey;
  final String title;
  final int? goalId;
  final int? taskId;
  final bool scheduled;
  const MasterTask({
    required this.id,
    required this.periodKey,
    required this.title,
    this.goalId,
    this.taskId,
    required this.scheduled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['period_key'] = Variable<String>(periodKey);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || goalId != null) {
      map['goal_id'] = Variable<int>(goalId);
    }
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<int>(taskId);
    }
    map['scheduled'] = Variable<bool>(scheduled);
    return map;
  }

  MasterTasksCompanion toCompanion(bool nullToAbsent) {
    return MasterTasksCompanion(
      id: Value(id),
      periodKey: Value(periodKey),
      title: Value(title),
      goalId: goalId == null && nullToAbsent
          ? const Value.absent()
          : Value(goalId),
      taskId: taskId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskId),
      scheduled: Value(scheduled),
    );
  }

  factory MasterTask.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MasterTask(
      id: serializer.fromJson<int>(json['id']),
      periodKey: serializer.fromJson<String>(json['periodKey']),
      title: serializer.fromJson<String>(json['title']),
      goalId: serializer.fromJson<int?>(json['goalId']),
      taskId: serializer.fromJson<int?>(json['taskId']),
      scheduled: serializer.fromJson<bool>(json['scheduled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'periodKey': serializer.toJson<String>(periodKey),
      'title': serializer.toJson<String>(title),
      'goalId': serializer.toJson<int?>(goalId),
      'taskId': serializer.toJson<int?>(taskId),
      'scheduled': serializer.toJson<bool>(scheduled),
    };
  }

  MasterTask copyWith({
    int? id,
    String? periodKey,
    String? title,
    Value<int?> goalId = const Value.absent(),
    Value<int?> taskId = const Value.absent(),
    bool? scheduled,
  }) => MasterTask(
    id: id ?? this.id,
    periodKey: periodKey ?? this.periodKey,
    title: title ?? this.title,
    goalId: goalId.present ? goalId.value : this.goalId,
    taskId: taskId.present ? taskId.value : this.taskId,
    scheduled: scheduled ?? this.scheduled,
  );
  MasterTask copyWithCompanion(MasterTasksCompanion data) {
    return MasterTask(
      id: data.id.present ? data.id.value : this.id,
      periodKey: data.periodKey.present ? data.periodKey.value : this.periodKey,
      title: data.title.present ? data.title.value : this.title,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      scheduled: data.scheduled.present ? data.scheduled.value : this.scheduled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MasterTask(')
          ..write('id: $id, ')
          ..write('periodKey: $periodKey, ')
          ..write('title: $title, ')
          ..write('goalId: $goalId, ')
          ..write('taskId: $taskId, ')
          ..write('scheduled: $scheduled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, periodKey, title, goalId, taskId, scheduled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MasterTask &&
          other.id == this.id &&
          other.periodKey == this.periodKey &&
          other.title == this.title &&
          other.goalId == this.goalId &&
          other.taskId == this.taskId &&
          other.scheduled == this.scheduled);
}

class MasterTasksCompanion extends UpdateCompanion<MasterTask> {
  final Value<int> id;
  final Value<String> periodKey;
  final Value<String> title;
  final Value<int?> goalId;
  final Value<int?> taskId;
  final Value<bool> scheduled;
  const MasterTasksCompanion({
    this.id = const Value.absent(),
    this.periodKey = const Value.absent(),
    this.title = const Value.absent(),
    this.goalId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.scheduled = const Value.absent(),
  });
  MasterTasksCompanion.insert({
    this.id = const Value.absent(),
    required String periodKey,
    required String title,
    this.goalId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.scheduled = const Value.absent(),
  }) : periodKey = Value(periodKey),
       title = Value(title);
  static Insertable<MasterTask> custom({
    Expression<int>? id,
    Expression<String>? periodKey,
    Expression<String>? title,
    Expression<int>? goalId,
    Expression<int>? taskId,
    Expression<bool>? scheduled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (periodKey != null) 'period_key': periodKey,
      if (title != null) 'title': title,
      if (goalId != null) 'goal_id': goalId,
      if (taskId != null) 'task_id': taskId,
      if (scheduled != null) 'scheduled': scheduled,
    });
  }

  MasterTasksCompanion copyWith({
    Value<int>? id,
    Value<String>? periodKey,
    Value<String>? title,
    Value<int?>? goalId,
    Value<int?>? taskId,
    Value<bool>? scheduled,
  }) {
    return MasterTasksCompanion(
      id: id ?? this.id,
      periodKey: periodKey ?? this.periodKey,
      title: title ?? this.title,
      goalId: goalId ?? this.goalId,
      taskId: taskId ?? this.taskId,
      scheduled: scheduled ?? this.scheduled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (periodKey.present) {
      map['period_key'] = Variable<String>(periodKey.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<int>(goalId.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
    }
    if (scheduled.present) {
      map['scheduled'] = Variable<bool>(scheduled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MasterTasksCompanion(')
          ..write('id: $id, ')
          ..write('periodKey: $periodKey, ')
          ..write('title: $title, ')
          ..write('goalId: $goalId, ')
          ..write('taskId: $taskId, ')
          ..write('scheduled: $scheduled')
          ..write(')'))
        .toString();
  }
}

class $RecurrenceRulesTable extends RecurrenceRules
    with TableInfo<$RecurrenceRulesTable, RecurrenceRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurrenceRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _anchorDayMeta = const VerificationMeta(
    'anchorDay',
  );
  @override
  late final GeneratedColumn<String> anchorDay = GeneratedColumn<String>(
    'anchor_day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('B'),
  );
  static const VerificationMeta _startMinuteMeta = const VerificationMeta(
    'startMinute',
  );
  @override
  late final GeneratedColumn<int> startMinute = GeneratedColumn<int>(
    'start_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(540),
  );
  static const VerificationMeta _endMinuteMeta = const VerificationMeta(
    'endMinute',
  );
  @override
  late final GeneratedColumn<int> endMinute = GeneratedColumn<int>(
    'end_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(600),
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
    title,
    kind,
    frequency,
    anchorDay,
    priority,
    startMinute,
    endMinute,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurrence_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecurrenceRule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('anchor_day')) {
      context.handle(
        _anchorDayMeta,
        anchorDay.isAcceptableOrUnknown(data['anchor_day']!, _anchorDayMeta),
      );
    } else if (isInserting) {
      context.missing(_anchorDayMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('start_minute')) {
      context.handle(
        _startMinuteMeta,
        startMinute.isAcceptableOrUnknown(
          data['start_minute']!,
          _startMinuteMeta,
        ),
      );
    }
    if (data.containsKey('end_minute')) {
      context.handle(
        _endMinuteMeta,
        endMinute.isAcceptableOrUnknown(data['end_minute']!, _endMinuteMeta),
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
  RecurrenceRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurrenceRule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      anchorDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}anchor_day'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      startMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minute'],
      )!,
      endMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_minute'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $RecurrenceRulesTable createAlias(String alias) {
    return $RecurrenceRulesTable(attachedDatabase, alias);
  }
}

class RecurrenceRule extends DataClass implements Insertable<RecurrenceRule> {
  final int id;
  final String title;
  final String kind;
  final String frequency;
  final String anchorDay;
  final String priority;
  final int startMinute;
  final int endMinute;
  final bool active;
  const RecurrenceRule({
    required this.id,
    required this.title,
    required this.kind,
    required this.frequency,
    required this.anchorDay,
    required this.priority,
    required this.startMinute,
    required this.endMinute,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['kind'] = Variable<String>(kind);
    map['frequency'] = Variable<String>(frequency);
    map['anchor_day'] = Variable<String>(anchorDay);
    map['priority'] = Variable<String>(priority);
    map['start_minute'] = Variable<int>(startMinute);
    map['end_minute'] = Variable<int>(endMinute);
    map['active'] = Variable<bool>(active);
    return map;
  }

  RecurrenceRulesCompanion toCompanion(bool nullToAbsent) {
    return RecurrenceRulesCompanion(
      id: Value(id),
      title: Value(title),
      kind: Value(kind),
      frequency: Value(frequency),
      anchorDay: Value(anchorDay),
      priority: Value(priority),
      startMinute: Value(startMinute),
      endMinute: Value(endMinute),
      active: Value(active),
    );
  }

  factory RecurrenceRule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurrenceRule(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      kind: serializer.fromJson<String>(json['kind']),
      frequency: serializer.fromJson<String>(json['frequency']),
      anchorDay: serializer.fromJson<String>(json['anchorDay']),
      priority: serializer.fromJson<String>(json['priority']),
      startMinute: serializer.fromJson<int>(json['startMinute']),
      endMinute: serializer.fromJson<int>(json['endMinute']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'kind': serializer.toJson<String>(kind),
      'frequency': serializer.toJson<String>(frequency),
      'anchorDay': serializer.toJson<String>(anchorDay),
      'priority': serializer.toJson<String>(priority),
      'startMinute': serializer.toJson<int>(startMinute),
      'endMinute': serializer.toJson<int>(endMinute),
      'active': serializer.toJson<bool>(active),
    };
  }

  RecurrenceRule copyWith({
    int? id,
    String? title,
    String? kind,
    String? frequency,
    String? anchorDay,
    String? priority,
    int? startMinute,
    int? endMinute,
    bool? active,
  }) => RecurrenceRule(
    id: id ?? this.id,
    title: title ?? this.title,
    kind: kind ?? this.kind,
    frequency: frequency ?? this.frequency,
    anchorDay: anchorDay ?? this.anchorDay,
    priority: priority ?? this.priority,
    startMinute: startMinute ?? this.startMinute,
    endMinute: endMinute ?? this.endMinute,
    active: active ?? this.active,
  );
  RecurrenceRule copyWithCompanion(RecurrenceRulesCompanion data) {
    return RecurrenceRule(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      kind: data.kind.present ? data.kind.value : this.kind,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      anchorDay: data.anchorDay.present ? data.anchorDay.value : this.anchorDay,
      priority: data.priority.present ? data.priority.value : this.priority,
      startMinute: data.startMinute.present
          ? data.startMinute.value
          : this.startMinute,
      endMinute: data.endMinute.present ? data.endMinute.value : this.endMinute,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurrenceRule(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('kind: $kind, ')
          ..write('frequency: $frequency, ')
          ..write('anchorDay: $anchorDay, ')
          ..write('priority: $priority, ')
          ..write('startMinute: $startMinute, ')
          ..write('endMinute: $endMinute, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    kind,
    frequency,
    anchorDay,
    priority,
    startMinute,
    endMinute,
    active,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurrenceRule &&
          other.id == this.id &&
          other.title == this.title &&
          other.kind == this.kind &&
          other.frequency == this.frequency &&
          other.anchorDay == this.anchorDay &&
          other.priority == this.priority &&
          other.startMinute == this.startMinute &&
          other.endMinute == this.endMinute &&
          other.active == this.active);
}

class RecurrenceRulesCompanion extends UpdateCompanion<RecurrenceRule> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> kind;
  final Value<String> frequency;
  final Value<String> anchorDay;
  final Value<String> priority;
  final Value<int> startMinute;
  final Value<int> endMinute;
  final Value<bool> active;
  const RecurrenceRulesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.kind = const Value.absent(),
    this.frequency = const Value.absent(),
    this.anchorDay = const Value.absent(),
    this.priority = const Value.absent(),
    this.startMinute = const Value.absent(),
    this.endMinute = const Value.absent(),
    this.active = const Value.absent(),
  });
  RecurrenceRulesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String kind,
    required String frequency,
    required String anchorDay,
    this.priority = const Value.absent(),
    this.startMinute = const Value.absent(),
    this.endMinute = const Value.absent(),
    this.active = const Value.absent(),
  }) : title = Value(title),
       kind = Value(kind),
       frequency = Value(frequency),
       anchorDay = Value(anchorDay);
  static Insertable<RecurrenceRule> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? kind,
    Expression<String>? frequency,
    Expression<String>? anchorDay,
    Expression<String>? priority,
    Expression<int>? startMinute,
    Expression<int>? endMinute,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (kind != null) 'kind': kind,
      if (frequency != null) 'frequency': frequency,
      if (anchorDay != null) 'anchor_day': anchorDay,
      if (priority != null) 'priority': priority,
      if (startMinute != null) 'start_minute': startMinute,
      if (endMinute != null) 'end_minute': endMinute,
      if (active != null) 'active': active,
    });
  }

  RecurrenceRulesCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? kind,
    Value<String>? frequency,
    Value<String>? anchorDay,
    Value<String>? priority,
    Value<int>? startMinute,
    Value<int>? endMinute,
    Value<bool>? active,
  }) {
    return RecurrenceRulesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      kind: kind ?? this.kind,
      frequency: frequency ?? this.frequency,
      anchorDay: anchorDay ?? this.anchorDay,
      priority: priority ?? this.priority,
      startMinute: startMinute ?? this.startMinute,
      endMinute: endMinute ?? this.endMinute,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (anchorDay.present) {
      map['anchor_day'] = Variable<String>(anchorDay.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (startMinute.present) {
      map['start_minute'] = Variable<int>(startMinute.value);
    }
    if (endMinute.present) {
      map['end_minute'] = Variable<int>(endMinute.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurrenceRulesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('kind: $kind, ')
          ..write('frequency: $frequency, ')
          ..write('anchorDay: $anchorDay, ')
          ..write('priority: $priority, ')
          ..write('startMinute: $startMinute, ')
          ..write('endMinute: $endMinute, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }
}

class $RecurrenceOccurrencesTable extends RecurrenceOccurrences
    with TableInfo<$RecurrenceOccurrencesTable, RecurrenceOccurrence> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurrenceOccurrencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ruleIdMeta = const VerificationMeta('ruleId');
  @override
  late final GeneratedColumn<int> ruleId = GeneratedColumn<int>(
    'rule_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recurrence_rules (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES planner_tasks (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _appointmentIdMeta = const VerificationMeta(
    'appointmentId',
  );
  @override
  late final GeneratedColumn<int> appointmentId = GeneratedColumn<int>(
    'appointment_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES appointments (id) ON DELETE SET NULL',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [ruleId, day, taskId, appointmentId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurrence_occurrences';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecurrenceOccurrence> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('rule_id')) {
      context.handle(
        _ruleIdMeta,
        ruleId.isAcceptableOrUnknown(data['rule_id']!, _ruleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ruleIdMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('appointment_id')) {
      context.handle(
        _appointmentIdMeta,
        appointmentId.isAcceptableOrUnknown(
          data['appointment_id']!,
          _appointmentIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ruleId, day};
  @override
  RecurrenceOccurrence map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurrenceOccurrence(
      ruleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rule_id'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_id'],
      ),
      appointmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}appointment_id'],
      ),
    );
  }

  @override
  $RecurrenceOccurrencesTable createAlias(String alias) {
    return $RecurrenceOccurrencesTable(attachedDatabase, alias);
  }
}

class RecurrenceOccurrence extends DataClass
    implements Insertable<RecurrenceOccurrence> {
  final int ruleId;
  final String day;
  final int? taskId;
  final int? appointmentId;
  const RecurrenceOccurrence({
    required this.ruleId,
    required this.day,
    this.taskId,
    this.appointmentId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['rule_id'] = Variable<int>(ruleId);
    map['day'] = Variable<String>(day);
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<int>(taskId);
    }
    if (!nullToAbsent || appointmentId != null) {
      map['appointment_id'] = Variable<int>(appointmentId);
    }
    return map;
  }

  RecurrenceOccurrencesCompanion toCompanion(bool nullToAbsent) {
    return RecurrenceOccurrencesCompanion(
      ruleId: Value(ruleId),
      day: Value(day),
      taskId: taskId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskId),
      appointmentId: appointmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(appointmentId),
    );
  }

  factory RecurrenceOccurrence.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurrenceOccurrence(
      ruleId: serializer.fromJson<int>(json['ruleId']),
      day: serializer.fromJson<String>(json['day']),
      taskId: serializer.fromJson<int?>(json['taskId']),
      appointmentId: serializer.fromJson<int?>(json['appointmentId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ruleId': serializer.toJson<int>(ruleId),
      'day': serializer.toJson<String>(day),
      'taskId': serializer.toJson<int?>(taskId),
      'appointmentId': serializer.toJson<int?>(appointmentId),
    };
  }

  RecurrenceOccurrence copyWith({
    int? ruleId,
    String? day,
    Value<int?> taskId = const Value.absent(),
    Value<int?> appointmentId = const Value.absent(),
  }) => RecurrenceOccurrence(
    ruleId: ruleId ?? this.ruleId,
    day: day ?? this.day,
    taskId: taskId.present ? taskId.value : this.taskId,
    appointmentId: appointmentId.present
        ? appointmentId.value
        : this.appointmentId,
  );
  RecurrenceOccurrence copyWithCompanion(RecurrenceOccurrencesCompanion data) {
    return RecurrenceOccurrence(
      ruleId: data.ruleId.present ? data.ruleId.value : this.ruleId,
      day: data.day.present ? data.day.value : this.day,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      appointmentId: data.appointmentId.present
          ? data.appointmentId.value
          : this.appointmentId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurrenceOccurrence(')
          ..write('ruleId: $ruleId, ')
          ..write('day: $day, ')
          ..write('taskId: $taskId, ')
          ..write('appointmentId: $appointmentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ruleId, day, taskId, appointmentId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurrenceOccurrence &&
          other.ruleId == this.ruleId &&
          other.day == this.day &&
          other.taskId == this.taskId &&
          other.appointmentId == this.appointmentId);
}

class RecurrenceOccurrencesCompanion
    extends UpdateCompanion<RecurrenceOccurrence> {
  final Value<int> ruleId;
  final Value<String> day;
  final Value<int?> taskId;
  final Value<int?> appointmentId;
  final Value<int> rowid;
  const RecurrenceOccurrencesCompanion({
    this.ruleId = const Value.absent(),
    this.day = const Value.absent(),
    this.taskId = const Value.absent(),
    this.appointmentId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurrenceOccurrencesCompanion.insert({
    required int ruleId,
    required String day,
    this.taskId = const Value.absent(),
    this.appointmentId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : ruleId = Value(ruleId),
       day = Value(day);
  static Insertable<RecurrenceOccurrence> custom({
    Expression<int>? ruleId,
    Expression<String>? day,
    Expression<int>? taskId,
    Expression<int>? appointmentId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ruleId != null) 'rule_id': ruleId,
      if (day != null) 'day': day,
      if (taskId != null) 'task_id': taskId,
      if (appointmentId != null) 'appointment_id': appointmentId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurrenceOccurrencesCompanion copyWith({
    Value<int>? ruleId,
    Value<String>? day,
    Value<int?>? taskId,
    Value<int?>? appointmentId,
    Value<int>? rowid,
  }) {
    return RecurrenceOccurrencesCompanion(
      ruleId: ruleId ?? this.ruleId,
      day: day ?? this.day,
      taskId: taskId ?? this.taskId,
      appointmentId: appointmentId ?? this.appointmentId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ruleId.present) {
      map['rule_id'] = Variable<int>(ruleId.value);
    }
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
    }
    if (appointmentId.present) {
      map['appointment_id'] = Variable<int>(appointmentId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurrenceOccurrencesCompanion(')
          ..write('ruleId: $ruleId, ')
          ..write('day: $day, ')
          ..write('taskId: $taskId, ')
          ..write('appointmentId: $appointmentId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$PlannerDatabase extends GeneratedDatabase {
  _$PlannerDatabase(QueryExecutor e) : super(e);
  $PlannerDatabaseManager get managers => $PlannerDatabaseManager(this);
  late final $DailyNotesTable dailyNotes = $DailyNotesTable(this);
  late final $PlannerSettingsTable plannerSettings = $PlannerSettingsTable(
    this,
  );
  late final $PlannerTasksTable plannerTasks = $PlannerTasksTable(this);
  late final $TaskHistoriesTable taskHistories = $TaskHistoriesTable(this);
  late final $AppointmentsTable appointments = $AppointmentsTable(this);
  late final $JournalEntriesTable journalEntries = $JournalEntriesTable(this);
  late final $JournalTaskLinksTable journalTaskLinks = $JournalTaskLinksTable(
    this,
  );
  late final $JournalAppointmentLinksTable journalAppointmentLinks =
      $JournalAppointmentLinksTable(this);
  late final $JournalAttachmentsTable journalAttachments =
      $JournalAttachmentsTable(this);
  late final $PersonalRolesTable personalRoles = $PersonalRolesTable(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $GoalMilestonesTable goalMilestones = $GoalMilestonesTable(this);
  late final $TaskGoalLinksTable taskGoalLinks = $TaskGoalLinksTable(this);
  late final $PeriodPlansTable periodPlans = $PeriodPlansTable(this);
  late final $MasterTasksTable masterTasks = $MasterTasksTable(this);
  late final $RecurrenceRulesTable recurrenceRules = $RecurrenceRulesTable(
    this,
  );
  late final $RecurrenceOccurrencesTable recurrenceOccurrences =
      $RecurrenceOccurrencesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    dailyNotes,
    plannerSettings,
    plannerTasks,
    taskHistories,
    appointments,
    journalEntries,
    journalTaskLinks,
    journalAppointmentLinks,
    journalAttachments,
    personalRoles,
    goals,
    goalMilestones,
    taskGoalLinks,
    periodPlans,
    masterTasks,
    recurrenceRules,
    recurrenceOccurrences,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'journal_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('journal_task_links', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'planner_tasks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('journal_task_links', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'journal_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('journal_appointment_links', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'appointments',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('journal_appointment_links', kind: UpdateKind.update),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'journal_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('journal_attachments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'personal_roles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('goals', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'goals',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('goal_milestones', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'planner_tasks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('task_goal_links', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'goals',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('task_goal_links', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'goals',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('master_tasks', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'planner_tasks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('master_tasks', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'recurrence_rules',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('recurrence_occurrences', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'planner_tasks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('recurrence_occurrences', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'appointments',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('recurrence_occurrences', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$DailyNotesTableCreateCompanionBuilder = DailyNotesCompanion Function({
  required String day,
  Value<String> content,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$DailyNotesTableUpdateCompanionBuilder = DailyNotesCompanion Function({
  Value<String> day,
  Value<String> content,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$DailyNotesTableFilterComposer
    extends Composer<_$PlannerDatabase, $DailyNotesTable> {
  $$DailyNotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyNotesTableOrderingComposer
    extends Composer<_$PlannerDatabase, $DailyNotesTable> {
  $$DailyNotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyNotesTableAnnotationComposer
    extends Composer<_$PlannerDatabase, $DailyNotesTable> {
  $$DailyNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DailyNotesTableTableManager
    extends
        RootTableManager<
          _$PlannerDatabase,
          $DailyNotesTable,
          DailyNote,
          $$DailyNotesTableFilterComposer,
          $$DailyNotesTableOrderingComposer,
          $$DailyNotesTableAnnotationComposer,
          $$DailyNotesTableCreateCompanionBuilder,
          $$DailyNotesTableUpdateCompanionBuilder,
          (
            DailyNote,
            BaseReferences<_$PlannerDatabase, $DailyNotesTable, DailyNote>,
          ),
          DailyNote,
          PrefetchHooks Function()
        > {
  $$DailyNotesTableTableManager(_$PlannerDatabase db, $DailyNotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> day = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyNotesCompanion(
                day: day,
                content: content,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String day,
                Value<String> content = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => DailyNotesCompanion.insert(
                day: day,
                content: content,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DailyNotesTable, DailyNote>(table),
                  BaseReferences<
                    _$PlannerDatabase,
                    $DailyNotesTable,
                    DailyNote
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyNotesTableProcessedTableManager =
    ProcessedTableManager<
      _$PlannerDatabase,
      $DailyNotesTable,
      DailyNote,
      $$DailyNotesTableFilterComposer,
      $$DailyNotesTableOrderingComposer,
      $$DailyNotesTableAnnotationComposer,
      $$DailyNotesTableCreateCompanionBuilder,
      $$DailyNotesTableUpdateCompanionBuilder,
      (
        DailyNote,
        BaseReferences<_$PlannerDatabase, $DailyNotesTable, DailyNote>,
      ),
      DailyNote,
      PrefetchHooks Function()
    >;
typedef $$PlannerSettingsTableCreateCompanionBuilder =
    PlannerSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$PlannerSettingsTableUpdateCompanionBuilder =
    PlannerSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$PlannerSettingsTableFilterComposer
    extends Composer<_$PlannerDatabase, $PlannerSettingsTable> {
  $$PlannerSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlannerSettingsTableOrderingComposer
    extends Composer<_$PlannerDatabase, $PlannerSettingsTable> {
  $$PlannerSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlannerSettingsTableAnnotationComposer
    extends Composer<_$PlannerDatabase, $PlannerSettingsTable> {
  $$PlannerSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$PlannerSettingsTableTableManager
    extends
        RootTableManager<
          _$PlannerDatabase,
          $PlannerSettingsTable,
          PlannerSetting,
          $$PlannerSettingsTableFilterComposer,
          $$PlannerSettingsTableOrderingComposer,
          $$PlannerSettingsTableAnnotationComposer,
          $$PlannerSettingsTableCreateCompanionBuilder,
          $$PlannerSettingsTableUpdateCompanionBuilder,
          (
            PlannerSetting,
            BaseReferences<
              _$PlannerDatabase,
              $PlannerSettingsTable,
              PlannerSetting
            >,
          ),
          PlannerSetting,
          PrefetchHooks Function()
        > {
  $$PlannerSettingsTableTableManager(
    _$PlannerDatabase db,
    $PlannerSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlannerSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlannerSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlannerSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => PlannerSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => PlannerSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlannerSettingsTable, PlannerSetting>(table),
                  BaseReferences<
                    _$PlannerDatabase,
                    $PlannerSettingsTable,
                    PlannerSetting
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlannerSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$PlannerDatabase,
      $PlannerSettingsTable,
      PlannerSetting,
      $$PlannerSettingsTableFilterComposer,
      $$PlannerSettingsTableOrderingComposer,
      $$PlannerSettingsTableAnnotationComposer,
      $$PlannerSettingsTableCreateCompanionBuilder,
      $$PlannerSettingsTableUpdateCompanionBuilder,
      (
        PlannerSetting,
        BaseReferences<
          _$PlannerDatabase,
          $PlannerSettingsTable,
          PlannerSetting
        >,
      ),
      PlannerSetting,
      PrefetchHooks Function()
    >;
typedef $$PlannerTasksTableCreateCompanionBuilder =
    PlannerTasksCompanion Function({
      Value<int> id,
      required String day,
      required String title,
      Value<String> details,
      Value<String> delegatedTo,
      Value<String> priority,
      Value<int> position,
      Value<String> status,
      required DateTime createdAt,
    });
typedef $$PlannerTasksTableUpdateCompanionBuilder =
    PlannerTasksCompanion Function({
      Value<int> id,
      Value<String> day,
      Value<String> title,
      Value<String> details,
      Value<String> delegatedTo,
      Value<String> priority,
      Value<int> position,
      Value<String> status,
      Value<DateTime> createdAt,
    });

final class $$PlannerTasksTableReferences
    extends BaseReferences<_$PlannerDatabase, $PlannerTasksTable, PlannerTask> {
  $$PlannerTasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TaskHistoriesTable, List<TaskHistory>>
  _taskHistoriesRefsTable(_$PlannerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.taskHistories,
        aliasName: 'planner_tasks__id__task_histories__task_id',
      );

  $$TaskHistoriesTableProcessedTableManager get taskHistoriesRefs {
    final manager = $$TaskHistoriesTableTableManager(
      $_db,
      $_db.taskHistories,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_taskHistoriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$JournalTaskLinksTable, List<JournalTaskLink>>
  _journalTaskLinksRefsTable(_$PlannerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.journalTaskLinks,
        aliasName: 'planner_tasks__id__journal_task_links__task_id',
      );

  $$JournalTaskLinksTableProcessedTableManager get journalTaskLinksRefs {
    final manager = $$JournalTaskLinksTableTableManager(
      $_db,
      $_db.journalTaskLinks,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _journalTaskLinksRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TaskGoalLinksTable, List<TaskGoalLink>>
  _taskGoalLinksRefsTable(_$PlannerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.taskGoalLinks,
        aliasName: 'planner_tasks__id__task_goal_links__task_id',
      );

  $$TaskGoalLinksTableProcessedTableManager get taskGoalLinksRefs {
    final manager = $$TaskGoalLinksTableTableManager(
      $_db,
      $_db.taskGoalLinks,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_taskGoalLinksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MasterTasksTable, List<MasterTask>>
  _masterTasksRefsTable(_$PlannerDatabase db) => MultiTypedResultKey.fromTable(
    db.masterTasks,
    aliasName: 'planner_tasks__id__master_tasks__task_id',
  );

  $$MasterTasksTableProcessedTableManager get masterTasksRefs {
    final manager = $$MasterTasksTableTableManager(
      $_db,
      $_db.masterTasks,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_masterTasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $RecurrenceOccurrencesTable,
    List<RecurrenceOccurrence>
  >
  _recurrenceOccurrencesRefsTable(_$PlannerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recurrenceOccurrences,
        aliasName: 'planner_tasks__id__recurrence_occurrences__task_id',
      );

  $$RecurrenceOccurrencesTableProcessedTableManager
  get recurrenceOccurrencesRefs {
    final manager = $$RecurrenceOccurrencesTableTableManager(
      $_db,
      $_db.recurrenceOccurrences,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recurrenceOccurrencesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlannerTasksTableFilterComposer
    extends Composer<_$PlannerDatabase, $PlannerTasksTable> {
  $$PlannerTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get delegatedTo => $composableBuilder(
    column: $table.delegatedTo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> taskHistoriesRefs(
    Expression<bool> Function($$TaskHistoriesTableFilterComposer f) f,
  ) {
    final $$TaskHistoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskHistories,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskHistoriesTableFilterComposer(
            $db: $db,
            $table: $db.taskHistories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> journalTaskLinksRefs(
    Expression<bool> Function($$JournalTaskLinksTableFilterComposer f) f,
  ) {
    final $$JournalTaskLinksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalTaskLinks,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalTaskLinksTableFilterComposer(
            $db: $db,
            $table: $db.journalTaskLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> taskGoalLinksRefs(
    Expression<bool> Function($$TaskGoalLinksTableFilterComposer f) f,
  ) {
    final $$TaskGoalLinksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskGoalLinks,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskGoalLinksTableFilterComposer(
            $db: $db,
            $table: $db.taskGoalLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> masterTasksRefs(
    Expression<bool> Function($$MasterTasksTableFilterComposer f) f,
  ) {
    final $$MasterTasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.masterTasks,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MasterTasksTableFilterComposer(
            $db: $db,
            $table: $db.masterTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recurrenceOccurrencesRefs(
    Expression<bool> Function($$RecurrenceOccurrencesTableFilterComposer f) f,
  ) {
    final $$RecurrenceOccurrencesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recurrenceOccurrences,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurrenceOccurrencesTableFilterComposer(
                $db: $db,
                $table: $db.recurrenceOccurrences,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PlannerTasksTableOrderingComposer
    extends Composer<_$PlannerDatabase, $PlannerTasksTable> {
  $$PlannerTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get delegatedTo => $composableBuilder(
    column: $table.delegatedTo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlannerTasksTableAnnotationComposer
    extends Composer<_$PlannerDatabase, $PlannerTasksTable> {
  $$PlannerTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumn<String> get delegatedTo => $composableBuilder(
    column: $table.delegatedTo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> taskHistoriesRefs<T extends Object>(
    Expression<T> Function($$TaskHistoriesTableAnnotationComposer a) f,
  ) {
    final $$TaskHistoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskHistories,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskHistoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskHistories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> journalTaskLinksRefs<T extends Object>(
    Expression<T> Function($$JournalTaskLinksTableAnnotationComposer a) f,
  ) {
    final $$JournalTaskLinksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalTaskLinks,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalTaskLinksTableAnnotationComposer(
            $db: $db,
            $table: $db.journalTaskLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> taskGoalLinksRefs<T extends Object>(
    Expression<T> Function($$TaskGoalLinksTableAnnotationComposer a) f,
  ) {
    final $$TaskGoalLinksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskGoalLinks,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskGoalLinksTableAnnotationComposer(
            $db: $db,
            $table: $db.taskGoalLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> masterTasksRefs<T extends Object>(
    Expression<T> Function($$MasterTasksTableAnnotationComposer a) f,
  ) {
    final $$MasterTasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.masterTasks,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MasterTasksTableAnnotationComposer(
            $db: $db,
            $table: $db.masterTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recurrenceOccurrencesRefs<T extends Object>(
    Expression<T> Function($$RecurrenceOccurrencesTableAnnotationComposer a) f,
  ) {
    final $$RecurrenceOccurrencesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recurrenceOccurrences,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurrenceOccurrencesTableAnnotationComposer(
                $db: $db,
                $table: $db.recurrenceOccurrences,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PlannerTasksTableTableManager
    extends
        RootTableManager<
          _$PlannerDatabase,
          $PlannerTasksTable,
          PlannerTask,
          $$PlannerTasksTableFilterComposer,
          $$PlannerTasksTableOrderingComposer,
          $$PlannerTasksTableAnnotationComposer,
          $$PlannerTasksTableCreateCompanionBuilder,
          $$PlannerTasksTableUpdateCompanionBuilder,
          (PlannerTask, $$PlannerTasksTableReferences),
          PlannerTask,
          PrefetchHooks Function({
            bool taskHistoriesRefs,
            bool journalTaskLinksRefs,
            bool taskGoalLinksRefs,
            bool masterTasksRefs,
            bool recurrenceOccurrencesRefs,
          })
        > {
  $$PlannerTasksTableTableManager(
    _$PlannerDatabase db,
    $PlannerTasksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlannerTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlannerTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlannerTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> day = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> details = const Value.absent(),
                Value<String> delegatedTo = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PlannerTasksCompanion(
                id: id,
                day: day,
                title: title,
                details: details,
                delegatedTo: delegatedTo,
                priority: priority,
                position: position,
                status: status,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String day,
                required String title,
                Value<String> details = const Value.absent(),
                Value<String> delegatedTo = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> status = const Value.absent(),
                required DateTime createdAt,
              }) => PlannerTasksCompanion.insert(
                id: id,
                day: day,
                title: title,
                details: details,
                delegatedTo: delegatedTo,
                priority: priority,
                position: position,
                status: status,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlannerTasksTable, PlannerTask>(table),
                  $$PlannerTasksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                taskHistoriesRefs = false,
                journalTaskLinksRefs = false,
                taskGoalLinksRefs = false,
                masterTasksRefs = false,
                recurrenceOccurrencesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (taskHistoriesRefs) db.taskHistories,
                    if (journalTaskLinksRefs) db.journalTaskLinks,
                    if (taskGoalLinksRefs) db.taskGoalLinks,
                    if (masterTasksRefs) db.masterTasks,
                    if (recurrenceOccurrencesRefs) db.recurrenceOccurrences,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (taskHistoriesRefs)
                        await $_getPrefetchedData<
                          PlannerTask,
                          $PlannerTasksTable,
                          TaskHistory
                        >(
                          currentTable: table,
                          referencedTable: $$PlannerTasksTableReferences
                              ._taskHistoriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlannerTasksTableReferences(
                                db,
                                table,
                                p0,
                              ).taskHistoriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (journalTaskLinksRefs)
                        await $_getPrefetchedData<
                          PlannerTask,
                          $PlannerTasksTable,
                          JournalTaskLink
                        >(
                          currentTable: table,
                          referencedTable: $$PlannerTasksTableReferences
                              ._journalTaskLinksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlannerTasksTableReferences(
                                db,
                                table,
                                p0,
                              ).journalTaskLinksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (taskGoalLinksRefs)
                        await $_getPrefetchedData<
                          PlannerTask,
                          $PlannerTasksTable,
                          TaskGoalLink
                        >(
                          currentTable: table,
                          referencedTable: $$PlannerTasksTableReferences
                              ._taskGoalLinksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlannerTasksTableReferences(
                                db,
                                table,
                                p0,
                              ).taskGoalLinksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (masterTasksRefs)
                        await $_getPrefetchedData<
                          PlannerTask,
                          $PlannerTasksTable,
                          MasterTask
                        >(
                          currentTable: table,
                          referencedTable: $$PlannerTasksTableReferences
                              ._masterTasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlannerTasksTableReferences(
                                db,
                                table,
                                p0,
                              ).masterTasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recurrenceOccurrencesRefs)
                        await $_getPrefetchedData<
                          PlannerTask,
                          $PlannerTasksTable,
                          RecurrenceOccurrence
                        >(
                          currentTable: table,
                          referencedTable: $$PlannerTasksTableReferences
                              ._recurrenceOccurrencesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlannerTasksTableReferences(
                                db,
                                table,
                                p0,
                              ).recurrenceOccurrencesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
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

typedef $$PlannerTasksTableProcessedTableManager =
    ProcessedTableManager<
      _$PlannerDatabase,
      $PlannerTasksTable,
      PlannerTask,
      $$PlannerTasksTableFilterComposer,
      $$PlannerTasksTableOrderingComposer,
      $$PlannerTasksTableAnnotationComposer,
      $$PlannerTasksTableCreateCompanionBuilder,
      $$PlannerTasksTableUpdateCompanionBuilder,
      (PlannerTask, $$PlannerTasksTableReferences),
      PlannerTask,
      PrefetchHooks Function({
        bool taskHistoriesRefs,
        bool journalTaskLinksRefs,
        bool taskGoalLinksRefs,
        bool masterTasksRefs,
        bool recurrenceOccurrencesRefs,
      })
    >;
typedef $$TaskHistoriesTableCreateCompanionBuilder =
    TaskHistoriesCompanion Function({
      Value<int> id,
      required int taskId,
      required String fromStatus,
      required String toStatus,
      required String fromDay,
      required String toDay,
      required DateTime changedAt,
    });
typedef $$TaskHistoriesTableUpdateCompanionBuilder =
    TaskHistoriesCompanion Function({
      Value<int> id,
      Value<int> taskId,
      Value<String> fromStatus,
      Value<String> toStatus,
      Value<String> fromDay,
      Value<String> toDay,
      Value<DateTime> changedAt,
    });

final class $$TaskHistoriesTableReferences
    extends
        BaseReferences<_$PlannerDatabase, $TaskHistoriesTable, TaskHistory> {
  $$TaskHistoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PlannerTasksTable _taskIdTable(_$PlannerDatabase db) =>
      db.plannerTasks.createAlias('task_histories__task_id__planner_tasks__id');

  $$PlannerTasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<int>('task_id')!;

    final manager = $$PlannerTasksTableTableManager(
      $_db,
      $_db.plannerTasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaskHistoriesTableFilterComposer
    extends Composer<_$PlannerDatabase, $TaskHistoriesTable> {
  $$TaskHistoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromStatus => $composableBuilder(
    column: $table.fromStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toStatus => $composableBuilder(
    column: $table.toStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromDay => $composableBuilder(
    column: $table.fromDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toDay => $composableBuilder(
    column: $table.toDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PlannerTasksTableFilterComposer get taskId {
    final $$PlannerTasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.plannerTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlannerTasksTableFilterComposer(
            $db: $db,
            $table: $db.plannerTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskHistoriesTableOrderingComposer
    extends Composer<_$PlannerDatabase, $TaskHistoriesTable> {
  $$TaskHistoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromStatus => $composableBuilder(
    column: $table.fromStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toStatus => $composableBuilder(
    column: $table.toStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromDay => $composableBuilder(
    column: $table.fromDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toDay => $composableBuilder(
    column: $table.toDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlannerTasksTableOrderingComposer get taskId {
    final $$PlannerTasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.plannerTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlannerTasksTableOrderingComposer(
            $db: $db,
            $table: $db.plannerTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskHistoriesTableAnnotationComposer
    extends Composer<_$PlannerDatabase, $TaskHistoriesTable> {
  $$TaskHistoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fromStatus => $composableBuilder(
    column: $table.fromStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toStatus =>
      $composableBuilder(column: $table.toStatus, builder: (column) => column);

  GeneratedColumn<String> get fromDay =>
      $composableBuilder(column: $table.fromDay, builder: (column) => column);

  GeneratedColumn<String> get toDay =>
      $composableBuilder(column: $table.toDay, builder: (column) => column);

  GeneratedColumn<DateTime> get changedAt =>
      $composableBuilder(column: $table.changedAt, builder: (column) => column);

  $$PlannerTasksTableAnnotationComposer get taskId {
    final $$PlannerTasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.plannerTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlannerTasksTableAnnotationComposer(
            $db: $db,
            $table: $db.plannerTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskHistoriesTableTableManager
    extends
        RootTableManager<
          _$PlannerDatabase,
          $TaskHistoriesTable,
          TaskHistory,
          $$TaskHistoriesTableFilterComposer,
          $$TaskHistoriesTableOrderingComposer,
          $$TaskHistoriesTableAnnotationComposer,
          $$TaskHistoriesTableCreateCompanionBuilder,
          $$TaskHistoriesTableUpdateCompanionBuilder,
          (TaskHistory, $$TaskHistoriesTableReferences),
          TaskHistory,
          PrefetchHooks Function({bool taskId})
        > {
  $$TaskHistoriesTableTableManager(
    _$PlannerDatabase db,
    $TaskHistoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskHistoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskHistoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskHistoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> taskId = const Value.absent(),
                Value<String> fromStatus = const Value.absent(),
                Value<String> toStatus = const Value.absent(),
                Value<String> fromDay = const Value.absent(),
                Value<String> toDay = const Value.absent(),
                Value<DateTime> changedAt = const Value.absent(),
              }) => TaskHistoriesCompanion(
                id: id,
                taskId: taskId,
                fromStatus: fromStatus,
                toStatus: toStatus,
                fromDay: fromDay,
                toDay: toDay,
                changedAt: changedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int taskId,
                required String fromStatus,
                required String toStatus,
                required String fromDay,
                required String toDay,
                required DateTime changedAt,
              }) => TaskHistoriesCompanion.insert(
                id: id,
                taskId: taskId,
                fromStatus: fromStatus,
                toStatus: toStatus,
                fromDay: fromDay,
                toDay: toDay,
                changedAt: changedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TaskHistoriesTable, TaskHistory>(table),
                  $$TaskHistoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
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
                    if (taskId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.taskId,
                        referencedTable: $$TaskHistoriesTableReferences
                            ._taskIdTable(db),
                        referencedColumn: $$TaskHistoriesTableReferences
                            ._taskIdTable(db)
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

typedef $$TaskHistoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$PlannerDatabase,
      $TaskHistoriesTable,
      TaskHistory,
      $$TaskHistoriesTableFilterComposer,
      $$TaskHistoriesTableOrderingComposer,
      $$TaskHistoriesTableAnnotationComposer,
      $$TaskHistoriesTableCreateCompanionBuilder,
      $$TaskHistoriesTableUpdateCompanionBuilder,
      (TaskHistory, $$TaskHistoriesTableReferences),
      TaskHistory,
      PrefetchHooks Function({bool taskId})
    >;
typedef $$AppointmentsTableCreateCompanionBuilder =
    AppointmentsCompanion Function({
      Value<int> id,
      required String day,
      required String title,
      required int startMinute,
      required int endMinute,
      Value<bool> allDay,
    });
typedef $$AppointmentsTableUpdateCompanionBuilder =
    AppointmentsCompanion Function({
      Value<int> id,
      Value<String> day,
      Value<String> title,
      Value<int> startMinute,
      Value<int> endMinute,
      Value<bool> allDay,
    });

final class $$AppointmentsTableReferences
    extends BaseReferences<_$PlannerDatabase, $AppointmentsTable, Appointment> {
  $$AppointmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $JournalAppointmentLinksTable,
    List<JournalAppointmentLink>
  >
  _journalAppointmentLinksRefsTable(_$PlannerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.journalAppointmentLinks,
        aliasName:
            'appointments__id__journal_appointment_links__appointment_id',
      );

  $$JournalAppointmentLinksTableProcessedTableManager
  get journalAppointmentLinksRefs {
    final manager = $$JournalAppointmentLinksTableTableManager(
      $_db,
      $_db.journalAppointmentLinks,
    ).filter((f) => f.appointmentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _journalAppointmentLinksRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $RecurrenceOccurrencesTable,
    List<RecurrenceOccurrence>
  >
  _recurrenceOccurrencesRefsTable(_$PlannerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recurrenceOccurrences,
        aliasName: 'appointments__id__recurrence_occurrences__appointment_id',
      );

  $$RecurrenceOccurrencesTableProcessedTableManager
  get recurrenceOccurrencesRefs {
    final manager = $$RecurrenceOccurrencesTableTableManager(
      $_db,
      $_db.recurrenceOccurrences,
    ).filter((f) => f.appointmentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recurrenceOccurrencesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AppointmentsTableFilterComposer
    extends Composer<_$PlannerDatabase, $AppointmentsTable> {
  $$AppointmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMinute => $composableBuilder(
    column: $table.endMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get allDay => $composableBuilder(
    column: $table.allDay,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> journalAppointmentLinksRefs(
    Expression<bool> Function($$JournalAppointmentLinksTableFilterComposer f) f,
  ) {
    final $$JournalAppointmentLinksTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.journalAppointmentLinks,
          getReferencedColumn: (t) => t.appointmentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$JournalAppointmentLinksTableFilterComposer(
                $db: $db,
                $table: $db.journalAppointmentLinks,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> recurrenceOccurrencesRefs(
    Expression<bool> Function($$RecurrenceOccurrencesTableFilterComposer f) f,
  ) {
    final $$RecurrenceOccurrencesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recurrenceOccurrences,
          getReferencedColumn: (t) => t.appointmentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurrenceOccurrencesTableFilterComposer(
                $db: $db,
                $table: $db.recurrenceOccurrences,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$AppointmentsTableOrderingComposer
    extends Composer<_$PlannerDatabase, $AppointmentsTable> {
  $$AppointmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMinute => $composableBuilder(
    column: $table.endMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get allDay => $composableBuilder(
    column: $table.allDay,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppointmentsTableAnnotationComposer
    extends Composer<_$PlannerDatabase, $AppointmentsTable> {
  $$AppointmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endMinute =>
      $composableBuilder(column: $table.endMinute, builder: (column) => column);

  GeneratedColumn<bool> get allDay =>
      $composableBuilder(column: $table.allDay, builder: (column) => column);

  Expression<T> journalAppointmentLinksRefs<T extends Object>(
    Expression<T> Function($$JournalAppointmentLinksTableAnnotationComposer a)
    f,
  ) {
    final $$JournalAppointmentLinksTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.journalAppointmentLinks,
          getReferencedColumn: (t) => t.appointmentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$JournalAppointmentLinksTableAnnotationComposer(
                $db: $db,
                $table: $db.journalAppointmentLinks,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> recurrenceOccurrencesRefs<T extends Object>(
    Expression<T> Function($$RecurrenceOccurrencesTableAnnotationComposer a) f,
  ) {
    final $$RecurrenceOccurrencesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recurrenceOccurrences,
          getReferencedColumn: (t) => t.appointmentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurrenceOccurrencesTableAnnotationComposer(
                $db: $db,
                $table: $db.recurrenceOccurrences,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$AppointmentsTableTableManager
    extends
        RootTableManager<
          _$PlannerDatabase,
          $AppointmentsTable,
          Appointment,
          $$AppointmentsTableFilterComposer,
          $$AppointmentsTableOrderingComposer,
          $$AppointmentsTableAnnotationComposer,
          $$AppointmentsTableCreateCompanionBuilder,
          $$AppointmentsTableUpdateCompanionBuilder,
          (Appointment, $$AppointmentsTableReferences),
          Appointment,
          PrefetchHooks Function({
            bool journalAppointmentLinksRefs,
            bool recurrenceOccurrencesRefs,
          })
        > {
  $$AppointmentsTableTableManager(
    _$PlannerDatabase db,
    $AppointmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppointmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppointmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppointmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> day = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> startMinute = const Value.absent(),
                Value<int> endMinute = const Value.absent(),
                Value<bool> allDay = const Value.absent(),
              }) => AppointmentsCompanion(
                id: id,
                day: day,
                title: title,
                startMinute: startMinute,
                endMinute: endMinute,
                allDay: allDay,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String day,
                required String title,
                required int startMinute,
                required int endMinute,
                Value<bool> allDay = const Value.absent(),
              }) => AppointmentsCompanion.insert(
                id: id,
                day: day,
                title: title,
                startMinute: startMinute,
                endMinute: endMinute,
                allDay: allDay,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppointmentsTable, Appointment>(table),
                  $$AppointmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                journalAppointmentLinksRefs = false,
                recurrenceOccurrencesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (journalAppointmentLinksRefs) db.journalAppointmentLinks,
                    if (recurrenceOccurrencesRefs) db.recurrenceOccurrences,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (journalAppointmentLinksRefs)
                        await $_getPrefetchedData<
                          Appointment,
                          $AppointmentsTable,
                          JournalAppointmentLink
                        >(
                          currentTable: table,
                          referencedTable: $$AppointmentsTableReferences
                              ._journalAppointmentLinksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AppointmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).journalAppointmentLinksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.appointmentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recurrenceOccurrencesRefs)
                        await $_getPrefetchedData<
                          Appointment,
                          $AppointmentsTable,
                          RecurrenceOccurrence
                        >(
                          currentTable: table,
                          referencedTable: $$AppointmentsTableReferences
                              ._recurrenceOccurrencesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AppointmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).recurrenceOccurrencesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.appointmentId == item.id,
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

typedef $$AppointmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$PlannerDatabase,
      $AppointmentsTable,
      Appointment,
      $$AppointmentsTableFilterComposer,
      $$AppointmentsTableOrderingComposer,
      $$AppointmentsTableAnnotationComposer,
      $$AppointmentsTableCreateCompanionBuilder,
      $$AppointmentsTableUpdateCompanionBuilder,
      (Appointment, $$AppointmentsTableReferences),
      Appointment,
      PrefetchHooks Function({
        bool journalAppointmentLinksRefs,
        bool recurrenceOccurrencesRefs,
      })
    >;
typedef $$JournalEntriesTableCreateCompanionBuilder =
    JournalEntriesCompanion Function({
      Value<int> id,
      required String day,
      required String title,
      required String delta,
      required String plainText,
      Value<String> category,
      Value<String> tagsJson,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$JournalEntriesTableUpdateCompanionBuilder =
    JournalEntriesCompanion Function({
      Value<int> id,
      Value<String> day,
      Value<String> title,
      Value<String> delta,
      Value<String> plainText,
      Value<String> category,
      Value<String> tagsJson,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$JournalEntriesTableReferences
    extends
        BaseReferences<_$PlannerDatabase, $JournalEntriesTable, JournalEntry> {
  $$JournalEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$JournalTaskLinksTable, List<JournalTaskLink>>
  _journalTaskLinksRefsTable(_$PlannerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.journalTaskLinks,
        aliasName: 'journal_entries__id__journal_task_links__entry_id',
      );

  $$JournalTaskLinksTableProcessedTableManager get journalTaskLinksRefs {
    final manager = $$JournalTaskLinksTableTableManager(
      $_db,
      $_db.journalTaskLinks,
    ).filter((f) => f.entryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _journalTaskLinksRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $JournalAppointmentLinksTable,
    List<JournalAppointmentLink>
  >
  _journalAppointmentLinksRefsTable(_$PlannerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.journalAppointmentLinks,
        aliasName: 'journal_entries__id__journal_appointment_links__entry_id',
      );

  $$JournalAppointmentLinksTableProcessedTableManager
  get journalAppointmentLinksRefs {
    final manager = $$JournalAppointmentLinksTableTableManager(
      $_db,
      $_db.journalAppointmentLinks,
    ).filter((f) => f.entryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _journalAppointmentLinksRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$JournalAttachmentsTable, List<JournalAttachment>>
  _journalAttachmentsRefsTable(_$PlannerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.journalAttachments,
        aliasName: 'journal_entries__id__journal_attachments__entry_id',
      );

  $$JournalAttachmentsTableProcessedTableManager get journalAttachmentsRefs {
    final manager = $$JournalAttachmentsTableTableManager(
      $_db,
      $_db.journalAttachments,
    ).filter((f) => f.entryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _journalAttachmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$JournalEntriesTableFilterComposer
    extends Composer<_$PlannerDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get delta => $composableBuilder(
    column: $table.delta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plainText => $composableBuilder(
    column: $table.plainText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
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

  Expression<bool> journalTaskLinksRefs(
    Expression<bool> Function($$JournalTaskLinksTableFilterComposer f) f,
  ) {
    final $$JournalTaskLinksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalTaskLinks,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalTaskLinksTableFilterComposer(
            $db: $db,
            $table: $db.journalTaskLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> journalAppointmentLinksRefs(
    Expression<bool> Function($$JournalAppointmentLinksTableFilterComposer f) f,
  ) {
    final $$JournalAppointmentLinksTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.journalAppointmentLinks,
          getReferencedColumn: (t) => t.entryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$JournalAppointmentLinksTableFilterComposer(
                $db: $db,
                $table: $db.journalAppointmentLinks,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> journalAttachmentsRefs(
    Expression<bool> Function($$JournalAttachmentsTableFilterComposer f) f,
  ) {
    final $$JournalAttachmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalAttachments,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalAttachmentsTableFilterComposer(
            $db: $db,
            $table: $db.journalAttachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$JournalEntriesTableOrderingComposer
    extends Composer<_$PlannerDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get delta => $composableBuilder(
    column: $table.delta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plainText => $composableBuilder(
    column: $table.plainText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
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

class $$JournalEntriesTableAnnotationComposer
    extends Composer<_$PlannerDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get delta =>
      $composableBuilder(column: $table.delta, builder: (column) => column);

  GeneratedColumn<String> get plainText =>
      $composableBuilder(column: $table.plainText, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> journalTaskLinksRefs<T extends Object>(
    Expression<T> Function($$JournalTaskLinksTableAnnotationComposer a) f,
  ) {
    final $$JournalTaskLinksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalTaskLinks,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalTaskLinksTableAnnotationComposer(
            $db: $db,
            $table: $db.journalTaskLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> journalAppointmentLinksRefs<T extends Object>(
    Expression<T> Function($$JournalAppointmentLinksTableAnnotationComposer a)
    f,
  ) {
    final $$JournalAppointmentLinksTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.journalAppointmentLinks,
          getReferencedColumn: (t) => t.entryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$JournalAppointmentLinksTableAnnotationComposer(
                $db: $db,
                $table: $db.journalAppointmentLinks,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> journalAttachmentsRefs<T extends Object>(
    Expression<T> Function($$JournalAttachmentsTableAnnotationComposer a) f,
  ) {
    final $$JournalAttachmentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.journalAttachments,
          getReferencedColumn: (t) => t.entryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$JournalAttachmentsTableAnnotationComposer(
                $db: $db,
                $table: $db.journalAttachments,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$JournalEntriesTableTableManager
    extends
        RootTableManager<
          _$PlannerDatabase,
          $JournalEntriesTable,
          JournalEntry,
          $$JournalEntriesTableFilterComposer,
          $$JournalEntriesTableOrderingComposer,
          $$JournalEntriesTableAnnotationComposer,
          $$JournalEntriesTableCreateCompanionBuilder,
          $$JournalEntriesTableUpdateCompanionBuilder,
          (JournalEntry, $$JournalEntriesTableReferences),
          JournalEntry,
          PrefetchHooks Function({
            bool journalTaskLinksRefs,
            bool journalAppointmentLinksRefs,
            bool journalAttachmentsRefs,
          })
        > {
  $$JournalEntriesTableTableManager(
    _$PlannerDatabase db,
    $JournalEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> day = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> delta = const Value.absent(),
                Value<String> plainText = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => JournalEntriesCompanion(
                id: id,
                day: day,
                title: title,
                delta: delta,
                plainText: plainText,
                category: category,
                tagsJson: tagsJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String day,
                required String title,
                required String delta,
                required String plainText,
                Value<String> category = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => JournalEntriesCompanion.insert(
                id: id,
                day: day,
                title: title,
                delta: delta,
                plainText: plainText,
                category: category,
                tagsJson: tagsJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$JournalEntriesTable, JournalEntry>(table),
                  $$JournalEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                journalTaskLinksRefs = false,
                journalAppointmentLinksRefs = false,
                journalAttachmentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (journalTaskLinksRefs) db.journalTaskLinks,
                    if (journalAppointmentLinksRefs) db.journalAppointmentLinks,
                    if (journalAttachmentsRefs) db.journalAttachments,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (journalTaskLinksRefs)
                        await $_getPrefetchedData<
                          JournalEntry,
                          $JournalEntriesTable,
                          JournalTaskLink
                        >(
                          currentTable: table,
                          referencedTable: $$JournalEntriesTableReferences
                              ._journalTaskLinksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JournalEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).journalTaskLinksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.entryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (journalAppointmentLinksRefs)
                        await $_getPrefetchedData<
                          JournalEntry,
                          $JournalEntriesTable,
                          JournalAppointmentLink
                        >(
                          currentTable: table,
                          referencedTable: $$JournalEntriesTableReferences
                              ._journalAppointmentLinksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JournalEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).journalAppointmentLinksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.entryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (journalAttachmentsRefs)
                        await $_getPrefetchedData<
                          JournalEntry,
                          $JournalEntriesTable,
                          JournalAttachment
                        >(
                          currentTable: table,
                          referencedTable: $$JournalEntriesTableReferences
                              ._journalAttachmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$JournalEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).journalAttachmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.entryId == item.id,
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

typedef $$JournalEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$PlannerDatabase,
      $JournalEntriesTable,
      JournalEntry,
      $$JournalEntriesTableFilterComposer,
      $$JournalEntriesTableOrderingComposer,
      $$JournalEntriesTableAnnotationComposer,
      $$JournalEntriesTableCreateCompanionBuilder,
      $$JournalEntriesTableUpdateCompanionBuilder,
      (JournalEntry, $$JournalEntriesTableReferences),
      JournalEntry,
      PrefetchHooks Function({
        bool journalTaskLinksRefs,
        bool journalAppointmentLinksRefs,
        bool journalAttachmentsRefs,
      })
    >;
typedef $$JournalTaskLinksTableCreateCompanionBuilder =
    JournalTaskLinksCompanion Function({
      required int entryId,
      Value<int?> taskId,
      required String label,
      Value<int> rowid,
    });
typedef $$JournalTaskLinksTableUpdateCompanionBuilder =
    JournalTaskLinksCompanion Function({
      Value<int> entryId,
      Value<int?> taskId,
      Value<String> label,
      Value<int> rowid,
    });

final class $$JournalTaskLinksTableReferences
    extends
        BaseReferences<
          _$PlannerDatabase,
          $JournalTaskLinksTable,
          JournalTaskLink
        > {
  $$JournalTaskLinksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $JournalEntriesTable _entryIdTable(_$PlannerDatabase db) => db
      .journalEntries
      .createAlias('journal_task_links__entry_id__journal_entries__id');

  $$JournalEntriesTableProcessedTableManager get entryId {
    final $_column = $_itemColumn<int>('entry_id')!;

    final manager = $$JournalEntriesTableTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlannerTasksTable _taskIdTable(_$PlannerDatabase db) => db
      .plannerTasks
      .createAlias('journal_task_links__task_id__planner_tasks__id');

  $$PlannerTasksTableProcessedTableManager? get taskId {
    final $_column = $_itemColumn<int>('task_id');
    if ($_column == null) return null;
    final manager = $$PlannerTasksTableTableManager(
      $_db,
      $_db.plannerTasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$JournalTaskLinksTableFilterComposer
    extends Composer<_$PlannerDatabase, $JournalTaskLinksTable> {
  $$JournalTaskLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  $$JournalEntriesTableFilterComposer get entryId {
    final $$JournalEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableFilterComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlannerTasksTableFilterComposer get taskId {
    final $$PlannerTasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.plannerTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlannerTasksTableFilterComposer(
            $db: $db,
            $table: $db.plannerTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalTaskLinksTableOrderingComposer
    extends Composer<_$PlannerDatabase, $JournalTaskLinksTable> {
  $$JournalTaskLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  $$JournalEntriesTableOrderingComposer get entryId {
    final $$JournalEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlannerTasksTableOrderingComposer get taskId {
    final $$PlannerTasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.plannerTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlannerTasksTableOrderingComposer(
            $db: $db,
            $table: $db.plannerTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalTaskLinksTableAnnotationComposer
    extends Composer<_$PlannerDatabase, $JournalTaskLinksTable> {
  $$JournalTaskLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  $$JournalEntriesTableAnnotationComposer get entryId {
    final $$JournalEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlannerTasksTableAnnotationComposer get taskId {
    final $$PlannerTasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.plannerTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlannerTasksTableAnnotationComposer(
            $db: $db,
            $table: $db.plannerTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalTaskLinksTableTableManager
    extends
        RootTableManager<
          _$PlannerDatabase,
          $JournalTaskLinksTable,
          JournalTaskLink,
          $$JournalTaskLinksTableFilterComposer,
          $$JournalTaskLinksTableOrderingComposer,
          $$JournalTaskLinksTableAnnotationComposer,
          $$JournalTaskLinksTableCreateCompanionBuilder,
          $$JournalTaskLinksTableUpdateCompanionBuilder,
          (JournalTaskLink, $$JournalTaskLinksTableReferences),
          JournalTaskLink,
          PrefetchHooks Function({bool entryId, bool taskId})
        > {
  $$JournalTaskLinksTableTableManager(
    _$PlannerDatabase db,
    $JournalTaskLinksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalTaskLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalTaskLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalTaskLinksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> entryId = const Value.absent(),
                Value<int?> taskId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JournalTaskLinksCompanion(
                entryId: entryId,
                taskId: taskId,
                label: label,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int entryId,
                Value<int?> taskId = const Value.absent(),
                required String label,
                Value<int> rowid = const Value.absent(),
              }) => JournalTaskLinksCompanion.insert(
                entryId: entryId,
                taskId: taskId,
                label: label,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$JournalTaskLinksTable, JournalTaskLink>(table),
                  $$JournalTaskLinksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({entryId = false, taskId = false}) {
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
                    if (entryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.entryId,
                        referencedTable: $$JournalTaskLinksTableReferences
                            ._entryIdTable(db),
                        referencedColumn: $$JournalTaskLinksTableReferences
                            ._entryIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (taskId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.taskId,
                        referencedTable: $$JournalTaskLinksTableReferences
                            ._taskIdTable(db),
                        referencedColumn: $$JournalTaskLinksTableReferences
                            ._taskIdTable(db)
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

typedef $$JournalTaskLinksTableProcessedTableManager =
    ProcessedTableManager<
      _$PlannerDatabase,
      $JournalTaskLinksTable,
      JournalTaskLink,
      $$JournalTaskLinksTableFilterComposer,
      $$JournalTaskLinksTableOrderingComposer,
      $$JournalTaskLinksTableAnnotationComposer,
      $$JournalTaskLinksTableCreateCompanionBuilder,
      $$JournalTaskLinksTableUpdateCompanionBuilder,
      (JournalTaskLink, $$JournalTaskLinksTableReferences),
      JournalTaskLink,
      PrefetchHooks Function({bool entryId, bool taskId})
    >;
typedef $$JournalAppointmentLinksTableCreateCompanionBuilder =
    JournalAppointmentLinksCompanion Function({
      required int entryId,
      Value<int?> appointmentId,
      required String label,
      Value<int> rowid,
    });
typedef $$JournalAppointmentLinksTableUpdateCompanionBuilder =
    JournalAppointmentLinksCompanion Function({
      Value<int> entryId,
      Value<int?> appointmentId,
      Value<String> label,
      Value<int> rowid,
    });

final class $$JournalAppointmentLinksTableReferences
    extends
        BaseReferences<
          _$PlannerDatabase,
          $JournalAppointmentLinksTable,
          JournalAppointmentLink
        > {
  $$JournalAppointmentLinksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $JournalEntriesTable _entryIdTable(_$PlannerDatabase db) => db
      .journalEntries
      .createAlias('journal_appointment_links__entry_id__journal_entries__id');

  $$JournalEntriesTableProcessedTableManager get entryId {
    final $_column = $_itemColumn<int>('entry_id')!;

    final manager = $$JournalEntriesTableTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AppointmentsTable _appointmentIdTable(_$PlannerDatabase db) =>
      db.appointments.createAlias(
        'journal_appointment_links__appointment_id__appointments__id',
      );

  $$AppointmentsTableProcessedTableManager? get appointmentId {
    final $_column = $_itemColumn<int>('appointment_id');
    if ($_column == null) return null;
    final manager = $$AppointmentsTableTableManager(
      $_db,
      $_db.appointments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_appointmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$JournalAppointmentLinksTableFilterComposer
    extends Composer<_$PlannerDatabase, $JournalAppointmentLinksTable> {
  $$JournalAppointmentLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  $$JournalEntriesTableFilterComposer get entryId {
    final $$JournalEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableFilterComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AppointmentsTableFilterComposer get appointmentId {
    final $$AppointmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.appointmentId,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableFilterComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalAppointmentLinksTableOrderingComposer
    extends Composer<_$PlannerDatabase, $JournalAppointmentLinksTable> {
  $$JournalAppointmentLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  $$JournalEntriesTableOrderingComposer get entryId {
    final $$JournalEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AppointmentsTableOrderingComposer get appointmentId {
    final $$AppointmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.appointmentId,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableOrderingComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalAppointmentLinksTableAnnotationComposer
    extends Composer<_$PlannerDatabase, $JournalAppointmentLinksTable> {
  $$JournalAppointmentLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  $$JournalEntriesTableAnnotationComposer get entryId {
    final $$JournalEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AppointmentsTableAnnotationComposer get appointmentId {
    final $$AppointmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.appointmentId,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalAppointmentLinksTableTableManager
    extends
        RootTableManager<
          _$PlannerDatabase,
          $JournalAppointmentLinksTable,
          JournalAppointmentLink,
          $$JournalAppointmentLinksTableFilterComposer,
          $$JournalAppointmentLinksTableOrderingComposer,
          $$JournalAppointmentLinksTableAnnotationComposer,
          $$JournalAppointmentLinksTableCreateCompanionBuilder,
          $$JournalAppointmentLinksTableUpdateCompanionBuilder,
          (JournalAppointmentLink, $$JournalAppointmentLinksTableReferences),
          JournalAppointmentLink,
          PrefetchHooks Function({bool entryId, bool appointmentId})
        > {
  $$JournalAppointmentLinksTableTableManager(
    _$PlannerDatabase db,
    $JournalAppointmentLinksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalAppointmentLinksTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$JournalAppointmentLinksTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$JournalAppointmentLinksTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> entryId = const Value.absent(),
                Value<int?> appointmentId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JournalAppointmentLinksCompanion(
                entryId: entryId,
                appointmentId: appointmentId,
                label: label,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int entryId,
                Value<int?> appointmentId = const Value.absent(),
                required String label,
                Value<int> rowid = const Value.absent(),
              }) => JournalAppointmentLinksCompanion.insert(
                entryId: entryId,
                appointmentId: appointmentId,
                label: label,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $JournalAppointmentLinksTable,
                    JournalAppointmentLink
                  >(table),
                  $$JournalAppointmentLinksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({entryId = false, appointmentId = false}) {
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
                    if (entryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.entryId,
                        referencedTable:
                            $$JournalAppointmentLinksTableReferences
                                ._entryIdTable(db),
                        referencedColumn:
                            $$JournalAppointmentLinksTableReferences
                                ._entryIdTable(db)
                                .id,
                      ) as T;
                    }
                    if (appointmentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.appointmentId,
                        referencedTable:
                            $$JournalAppointmentLinksTableReferences
                                ._appointmentIdTable(db),
                        referencedColumn:
                            $$JournalAppointmentLinksTableReferences
                                ._appointmentIdTable(db)
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

typedef $$JournalAppointmentLinksTableProcessedTableManager =
    ProcessedTableManager<
      _$PlannerDatabase,
      $JournalAppointmentLinksTable,
      JournalAppointmentLink,
      $$JournalAppointmentLinksTableFilterComposer,
      $$JournalAppointmentLinksTableOrderingComposer,
      $$JournalAppointmentLinksTableAnnotationComposer,
      $$JournalAppointmentLinksTableCreateCompanionBuilder,
      $$JournalAppointmentLinksTableUpdateCompanionBuilder,
      (JournalAppointmentLink, $$JournalAppointmentLinksTableReferences),
      JournalAppointmentLink,
      PrefetchHooks Function({bool entryId, bool appointmentId})
    >;
typedef $$JournalAttachmentsTableCreateCompanionBuilder =
    JournalAttachmentsCompanion Function({
      required String id,
      required int entryId,
      required String filename,
      required String displayName,
      required String kind,
      Value<String> caption,
      required int bytes,
      required int position,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$JournalAttachmentsTableUpdateCompanionBuilder =
    JournalAttachmentsCompanion Function({
      Value<String> id,
      Value<int> entryId,
      Value<String> filename,
      Value<String> displayName,
      Value<String> kind,
      Value<String> caption,
      Value<int> bytes,
      Value<int> position,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$JournalAttachmentsTableReferences
    extends
        BaseReferences<
          _$PlannerDatabase,
          $JournalAttachmentsTable,
          JournalAttachment
        > {
  $$JournalAttachmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $JournalEntriesTable _entryIdTable(_$PlannerDatabase db) => db
      .journalEntries
      .createAlias('journal_attachments__entry_id__journal_entries__id');

  $$JournalEntriesTableProcessedTableManager get entryId {
    final $_column = $_itemColumn<int>('entry_id')!;

    final manager = $$JournalEntriesTableTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$JournalAttachmentsTableFilterComposer
    extends Composer<_$PlannerDatabase, $JournalAttachmentsTable> {
  $$JournalAttachmentsTableFilterComposer({
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

  ColumnFilters<String> get filename => $composableBuilder(
    column: $table.filename,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bytes => $composableBuilder(
    column: $table.bytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$JournalEntriesTableFilterComposer get entryId {
    final $$JournalEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableFilterComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalAttachmentsTableOrderingComposer
    extends Composer<_$PlannerDatabase, $JournalAttachmentsTable> {
  $$JournalAttachmentsTableOrderingComposer({
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

  ColumnOrderings<String> get filename => $composableBuilder(
    column: $table.filename,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bytes => $composableBuilder(
    column: $table.bytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$JournalEntriesTableOrderingComposer get entryId {
    final $$JournalEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalAttachmentsTableAnnotationComposer
    extends Composer<_$PlannerDatabase, $JournalAttachmentsTable> {
  $$JournalAttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filename =>
      $composableBuilder(column: $table.filename, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);

  GeneratedColumn<int> get bytes =>
      $composableBuilder(column: $table.bytes, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$JournalEntriesTableAnnotationComposer get entryId {
    final $$JournalEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalAttachmentsTableTableManager
    extends
        RootTableManager<
          _$PlannerDatabase,
          $JournalAttachmentsTable,
          JournalAttachment,
          $$JournalAttachmentsTableFilterComposer,
          $$JournalAttachmentsTableOrderingComposer,
          $$JournalAttachmentsTableAnnotationComposer,
          $$JournalAttachmentsTableCreateCompanionBuilder,
          $$JournalAttachmentsTableUpdateCompanionBuilder,
          (JournalAttachment, $$JournalAttachmentsTableReferences),
          JournalAttachment,
          PrefetchHooks Function({bool entryId})
        > {
  $$JournalAttachmentsTableTableManager(
    _$PlannerDatabase db,
    $JournalAttachmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalAttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalAttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalAttachmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> entryId = const Value.absent(),
                Value<String> filename = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> caption = const Value.absent(),
                Value<int> bytes = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JournalAttachmentsCompanion(
                id: id,
                entryId: entryId,
                filename: filename,
                displayName: displayName,
                kind: kind,
                caption: caption,
                bytes: bytes,
                position: position,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int entryId,
                required String filename,
                required String displayName,
                required String kind,
                Value<String> caption = const Value.absent(),
                required int bytes,
                required int position,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => JournalAttachmentsCompanion.insert(
                id: id,
                entryId: entryId,
                filename: filename,
                displayName: displayName,
                kind: kind,
                caption: caption,
                bytes: bytes,
                position: position,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$JournalAttachmentsTable, JournalAttachment>(
                    table,
                  ),
                  $$JournalAttachmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({entryId = false}) {
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
                    if (entryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.entryId,
                        referencedTable: $$JournalAttachmentsTableReferences
                            ._entryIdTable(db),
                        referencedColumn: $$JournalAttachmentsTableReferences
                            ._entryIdTable(db)
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

typedef $$JournalAttachmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$PlannerDatabase,
      $JournalAttachmentsTable,
      JournalAttachment,
      $$JournalAttachmentsTableFilterComposer,
      $$JournalAttachmentsTableOrderingComposer,
      $$JournalAttachmentsTableAnnotationComposer,
      $$JournalAttachmentsTableCreateCompanionBuilder,
      $$JournalAttachmentsTableUpdateCompanionBuilder,
      (JournalAttachment, $$JournalAttachmentsTableReferences),
      JournalAttachment,
      PrefetchHooks Function({bool entryId})
    >;
typedef $$PersonalRolesTableCreateCompanionBuilder =
    PersonalRolesCompanion Function({
      Value<int> id,
      required String name,
      Value<String> description,
    });
typedef $$PersonalRolesTableUpdateCompanionBuilder =
    PersonalRolesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> description,
    });

final class $$PersonalRolesTableReferences
    extends
        BaseReferences<_$PlannerDatabase, $PersonalRolesTable, PersonalRole> {
  $$PersonalRolesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$GoalsTable, List<Goal>> _goalsRefsTable(
    _$PlannerDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.goals,
    aliasName: 'personal_roles__id__goals__role_id',
  );

  $$GoalsTableProcessedTableManager get goalsRefs {
    final manager = $$GoalsTableTableManager(
      $_db,
      $_db.goals,
    ).filter((f) => f.roleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_goalsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PersonalRolesTableFilterComposer
    extends Composer<_$PlannerDatabase, $PersonalRolesTable> {
  $$PersonalRolesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
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

  Expression<bool> goalsRefs(
    Expression<bool> Function($$GoalsTableFilterComposer f) f,
  ) {
    final $$GoalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.roleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableFilterComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PersonalRolesTableOrderingComposer
    extends Composer<_$PlannerDatabase, $PersonalRolesTable> {
  $$PersonalRolesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
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
}

class $$PersonalRolesTableAnnotationComposer
    extends Composer<_$PlannerDatabase, $PersonalRolesTable> {
  $$PersonalRolesTableAnnotationComposer({
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

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  Expression<T> goalsRefs<T extends Object>(
    Expression<T> Function($$GoalsTableAnnotationComposer a) f,
  ) {
    final $$GoalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.roleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableAnnotationComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PersonalRolesTableTableManager
    extends
        RootTableManager<
          _$PlannerDatabase,
          $PersonalRolesTable,
          PersonalRole,
          $$PersonalRolesTableFilterComposer,
          $$PersonalRolesTableOrderingComposer,
          $$PersonalRolesTableAnnotationComposer,
          $$PersonalRolesTableCreateCompanionBuilder,
          $$PersonalRolesTableUpdateCompanionBuilder,
          (PersonalRole, $$PersonalRolesTableReferences),
          PersonalRole,
          PrefetchHooks Function({bool goalsRefs})
        > {
  $$PersonalRolesTableTableManager(
    _$PlannerDatabase db,
    $PersonalRolesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonalRolesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonalRolesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonalRolesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
              }) => PersonalRolesCompanion(
                id: id,
                name: name,
                description: description,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> description = const Value.absent(),
              }) => PersonalRolesCompanion.insert(
                id: id,
                name: name,
                description: description,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PersonalRolesTable, PersonalRole>(table),
                  $$PersonalRolesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({goalsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (goalsRefs) db.goals],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (goalsRefs)
                    await $_getPrefetchedData<
                      PersonalRole,
                      $PersonalRolesTable,
                      Goal
                    >(
                      currentTable: table,
                      referencedTable: $$PersonalRolesTableReferences
                          ._goalsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PersonalRolesTableReferences(
                            db,
                            table,
                            p0,
                          ).goalsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.roleId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PersonalRolesTableProcessedTableManager =
    ProcessedTableManager<
      _$PlannerDatabase,
      $PersonalRolesTable,
      PersonalRole,
      $$PersonalRolesTableFilterComposer,
      $$PersonalRolesTableOrderingComposer,
      $$PersonalRolesTableAnnotationComposer,
      $$PersonalRolesTableCreateCompanionBuilder,
      $$PersonalRolesTableUpdateCompanionBuilder,
      (PersonalRole, $$PersonalRolesTableReferences),
      PersonalRole,
      PrefetchHooks Function({bool goalsRefs})
    >;
typedef $$GoalsTableCreateCompanionBuilder = GoalsCompanion Function({
  Value<int> id,
  required String title,
  required String description,
  required String horizon,
  Value<String?> targetDay,
  Value<int?> roleId,
  Value<String> status,
});
typedef $$GoalsTableUpdateCompanionBuilder = GoalsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> description,
  Value<String> horizon,
  Value<String?> targetDay,
  Value<int?> roleId,
  Value<String> status,
});

final class $$GoalsTableReferences
    extends BaseReferences<_$PlannerDatabase, $GoalsTable, Goal> {
  $$GoalsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PersonalRolesTable _roleIdTable(_$PlannerDatabase db) =>
      db.personalRoles.createAlias('goals__role_id__personal_roles__id');

  $$PersonalRolesTableProcessedTableManager? get roleId {
    final $_column = $_itemColumn<int>('role_id');
    if ($_column == null) return null;
    final manager = $$PersonalRolesTableTableManager(
      $_db,
      $_db.personalRoles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_roleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$GoalMilestonesTable, List<GoalMilestone>>
  _goalMilestonesRefsTable(_$PlannerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.goalMilestones,
        aliasName: 'goals__id__goal_milestones__goal_id',
      );

  $$GoalMilestonesTableProcessedTableManager get goalMilestonesRefs {
    final manager = $$GoalMilestonesTableTableManager(
      $_db,
      $_db.goalMilestones,
    ).filter((f) => f.goalId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_goalMilestonesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TaskGoalLinksTable, List<TaskGoalLink>>
  _taskGoalLinksRefsTable(_$PlannerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.taskGoalLinks,
        aliasName: 'goals__id__task_goal_links__goal_id',
      );

  $$TaskGoalLinksTableProcessedTableManager get taskGoalLinksRefs {
    final manager = $$TaskGoalLinksTableTableManager(
      $_db,
      $_db.taskGoalLinks,
    ).filter((f) => f.goalId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_taskGoalLinksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MasterTasksTable, List<MasterTask>>
  _masterTasksRefsTable(_$PlannerDatabase db) => MultiTypedResultKey.fromTable(
    db.masterTasks,
    aliasName: 'goals__id__master_tasks__goal_id',
  );

  $$MasterTasksTableProcessedTableManager get masterTasksRefs {
    final manager = $$MasterTasksTableTableManager(
      $_db,
      $_db.masterTasks,
    ).filter((f) => f.goalId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_masterTasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GoalsTableFilterComposer
    extends Composer<_$PlannerDatabase, $GoalsTable> {
  $$GoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get horizon => $composableBuilder(
    column: $table.horizon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetDay => $composableBuilder(
    column: $table.targetDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  $$PersonalRolesTableFilterComposer get roleId {
    final $$PersonalRolesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roleId,
      referencedTable: $db.personalRoles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonalRolesTableFilterComposer(
            $db: $db,
            $table: $db.personalRoles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> goalMilestonesRefs(
    Expression<bool> Function($$GoalMilestonesTableFilterComposer f) f,
  ) {
    final $$GoalMilestonesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goalMilestones,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalMilestonesTableFilterComposer(
            $db: $db,
            $table: $db.goalMilestones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> taskGoalLinksRefs(
    Expression<bool> Function($$TaskGoalLinksTableFilterComposer f) f,
  ) {
    final $$TaskGoalLinksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskGoalLinks,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskGoalLinksTableFilterComposer(
            $db: $db,
            $table: $db.taskGoalLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> masterTasksRefs(
    Expression<bool> Function($$MasterTasksTableFilterComposer f) f,
  ) {
    final $$MasterTasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.masterTasks,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MasterTasksTableFilterComposer(
            $db: $db,
            $table: $db.masterTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GoalsTableOrderingComposer
    extends Composer<_$PlannerDatabase, $GoalsTable> {
  $$GoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
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

  ColumnOrderings<String> get horizon => $composableBuilder(
    column: $table.horizon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetDay => $composableBuilder(
    column: $table.targetDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $$PersonalRolesTableOrderingComposer get roleId {
    final $$PersonalRolesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roleId,
      referencedTable: $db.personalRoles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonalRolesTableOrderingComposer(
            $db: $db,
            $table: $db.personalRoles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalsTableAnnotationComposer
    extends Composer<_$PlannerDatabase, $GoalsTable> {
  $$GoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get horizon =>
      $composableBuilder(column: $table.horizon, builder: (column) => column);

  GeneratedColumn<String> get targetDay =>
      $composableBuilder(column: $table.targetDay, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$PersonalRolesTableAnnotationComposer get roleId {
    final $$PersonalRolesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roleId,
      referencedTable: $db.personalRoles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonalRolesTableAnnotationComposer(
            $db: $db,
            $table: $db.personalRoles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> goalMilestonesRefs<T extends Object>(
    Expression<T> Function($$GoalMilestonesTableAnnotationComposer a) f,
  ) {
    final $$GoalMilestonesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goalMilestones,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalMilestonesTableAnnotationComposer(
            $db: $db,
            $table: $db.goalMilestones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> taskGoalLinksRefs<T extends Object>(
    Expression<T> Function($$TaskGoalLinksTableAnnotationComposer a) f,
  ) {
    final $$TaskGoalLinksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskGoalLinks,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskGoalLinksTableAnnotationComposer(
            $db: $db,
            $table: $db.taskGoalLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> masterTasksRefs<T extends Object>(
    Expression<T> Function($$MasterTasksTableAnnotationComposer a) f,
  ) {
    final $$MasterTasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.masterTasks,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MasterTasksTableAnnotationComposer(
            $db: $db,
            $table: $db.masterTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GoalsTableTableManager
    extends
        RootTableManager<
          _$PlannerDatabase,
          $GoalsTable,
          Goal,
          $$GoalsTableFilterComposer,
          $$GoalsTableOrderingComposer,
          $$GoalsTableAnnotationComposer,
          $$GoalsTableCreateCompanionBuilder,
          $$GoalsTableUpdateCompanionBuilder,
          (Goal, $$GoalsTableReferences),
          Goal,
          PrefetchHooks Function({
            bool roleId,
            bool goalMilestonesRefs,
            bool taskGoalLinksRefs,
            bool masterTasksRefs,
          })
        > {
  $$GoalsTableTableManager(_$PlannerDatabase db, $GoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> horizon = const Value.absent(),
                Value<String?> targetDay = const Value.absent(),
                Value<int?> roleId = const Value.absent(),
                Value<String> status = const Value.absent(),
              }) => GoalsCompanion(
                id: id,
                title: title,
                description: description,
                horizon: horizon,
                targetDay: targetDay,
                roleId: roleId,
                status: status,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String description,
                required String horizon,
                Value<String?> targetDay = const Value.absent(),
                Value<int?> roleId = const Value.absent(),
                Value<String> status = const Value.absent(),
              }) => GoalsCompanion.insert(
                id: id,
                title: title,
                description: description,
                horizon: horizon,
                targetDay: targetDay,
                roleId: roleId,
                status: status,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GoalsTable, Goal>(table),
                  $$GoalsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                roleId = false,
                goalMilestonesRefs = false,
                taskGoalLinksRefs = false,
                masterTasksRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (goalMilestonesRefs) db.goalMilestones,
                    if (taskGoalLinksRefs) db.taskGoalLinks,
                    if (masterTasksRefs) db.masterTasks,
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
                        if (roleId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.roleId,
                            referencedTable: $$GoalsTableReferences
                                ._roleIdTable(db),
                            referencedColumn: $$GoalsTableReferences
                                ._roleIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (goalMilestonesRefs)
                        await $_getPrefetchedData<
                          Goal,
                          $GoalsTable,
                          GoalMilestone
                        >(
                          currentTable: table,
                          referencedTable: $$GoalsTableReferences
                              ._goalMilestonesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GoalsTableReferences(
                                db,
                                table,
                                p0,
                              ).goalMilestonesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.goalId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (taskGoalLinksRefs)
                        await $_getPrefetchedData<
                          Goal,
                          $GoalsTable,
                          TaskGoalLink
                        >(
                          currentTable: table,
                          referencedTable: $$GoalsTableReferences
                              ._taskGoalLinksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GoalsTableReferences(
                                db,
                                table,
                                p0,
                              ).taskGoalLinksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.goalId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (masterTasksRefs)
                        await $_getPrefetchedData<
                          Goal,
                          $GoalsTable,
                          MasterTask
                        >(
                          currentTable: table,
                          referencedTable: $$GoalsTableReferences
                              ._masterTasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GoalsTableReferences(
                                db,
                                table,
                                p0,
                              ).masterTasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.goalId == item.id,
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

typedef $$GoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$PlannerDatabase,
      $GoalsTable,
      Goal,
      $$GoalsTableFilterComposer,
      $$GoalsTableOrderingComposer,
      $$GoalsTableAnnotationComposer,
      $$GoalsTableCreateCompanionBuilder,
      $$GoalsTableUpdateCompanionBuilder,
      (Goal, $$GoalsTableReferences),
      Goal,
      PrefetchHooks Function({
        bool roleId,
        bool goalMilestonesRefs,
        bool taskGoalLinksRefs,
        bool masterTasksRefs,
      })
    >;
typedef $$GoalMilestonesTableCreateCompanionBuilder =
    GoalMilestonesCompanion Function({
      Value<int> id,
      required int goalId,
      required String title,
      Value<bool> completed,
    });
typedef $$GoalMilestonesTableUpdateCompanionBuilder =
    GoalMilestonesCompanion Function({
      Value<int> id,
      Value<int> goalId,
      Value<String> title,
      Value<bool> completed,
    });

final class $$GoalMilestonesTableReferences
    extends
        BaseReferences<_$PlannerDatabase, $GoalMilestonesTable, GoalMilestone> {
  $$GoalMilestonesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GoalsTable _goalIdTable(_$PlannerDatabase db) =>
      db.goals.createAlias('goal_milestones__goal_id__goals__id');

  $$GoalsTableProcessedTableManager get goalId {
    final $_column = $_itemColumn<int>('goal_id')!;

    final manager = $$GoalsTableTableManager(
      $_db,
      $_db.goals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_goalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GoalMilestonesTableFilterComposer
    extends Composer<_$PlannerDatabase, $GoalMilestonesTable> {
  $$GoalMilestonesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  $$GoalsTableFilterComposer get goalId {
    final $$GoalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableFilterComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalMilestonesTableOrderingComposer
    extends Composer<_$PlannerDatabase, $GoalMilestonesTable> {
  $$GoalMilestonesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  $$GoalsTableOrderingComposer get goalId {
    final $$GoalsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableOrderingComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalMilestonesTableAnnotationComposer
    extends Composer<_$PlannerDatabase, $GoalMilestonesTable> {
  $$GoalMilestonesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  $$GoalsTableAnnotationComposer get goalId {
    final $$GoalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableAnnotationComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalMilestonesTableTableManager
    extends
        RootTableManager<
          _$PlannerDatabase,
          $GoalMilestonesTable,
          GoalMilestone,
          $$GoalMilestonesTableFilterComposer,
          $$GoalMilestonesTableOrderingComposer,
          $$GoalMilestonesTableAnnotationComposer,
          $$GoalMilestonesTableCreateCompanionBuilder,
          $$GoalMilestonesTableUpdateCompanionBuilder,
          (GoalMilestone, $$GoalMilestonesTableReferences),
          GoalMilestone,
          PrefetchHooks Function({bool goalId})
        > {
  $$GoalMilestonesTableTableManager(
    _$PlannerDatabase db,
    $GoalMilestonesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalMilestonesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalMilestonesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalMilestonesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> goalId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<bool> completed = const Value.absent(),
              }) => GoalMilestonesCompanion(
                id: id,
                goalId: goalId,
                title: title,
                completed: completed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int goalId,
                required String title,
                Value<bool> completed = const Value.absent(),
              }) => GoalMilestonesCompanion.insert(
                id: id,
                goalId: goalId,
                title: title,
                completed: completed,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GoalMilestonesTable, GoalMilestone>(table),
                  $$GoalMilestonesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({goalId = false}) {
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
                    if (goalId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.goalId,
                        referencedTable: $$GoalMilestonesTableReferences
                            ._goalIdTable(db),
                        referencedColumn: $$GoalMilestonesTableReferences
                            ._goalIdTable(db)
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

typedef $$GoalMilestonesTableProcessedTableManager =
    ProcessedTableManager<
      _$PlannerDatabase,
      $GoalMilestonesTable,
      GoalMilestone,
      $$GoalMilestonesTableFilterComposer,
      $$GoalMilestonesTableOrderingComposer,
      $$GoalMilestonesTableAnnotationComposer,
      $$GoalMilestonesTableCreateCompanionBuilder,
      $$GoalMilestonesTableUpdateCompanionBuilder,
      (GoalMilestone, $$GoalMilestonesTableReferences),
      GoalMilestone,
      PrefetchHooks Function({bool goalId})
    >;
typedef $$TaskGoalLinksTableCreateCompanionBuilder =
    TaskGoalLinksCompanion Function({Value<int> taskId, required int goalId});
typedef $$TaskGoalLinksTableUpdateCompanionBuilder =
    TaskGoalLinksCompanion Function({Value<int> taskId, Value<int> goalId});

final class $$TaskGoalLinksTableReferences
    extends
        BaseReferences<_$PlannerDatabase, $TaskGoalLinksTable, TaskGoalLink> {
  $$TaskGoalLinksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PlannerTasksTable _taskIdTable(_$PlannerDatabase db) => db
      .plannerTasks
      .createAlias('task_goal_links__task_id__planner_tasks__id');

  $$PlannerTasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<int>('task_id')!;

    final manager = $$PlannerTasksTableTableManager(
      $_db,
      $_db.plannerTasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GoalsTable _goalIdTable(_$PlannerDatabase db) =>
      db.goals.createAlias('task_goal_links__goal_id__goals__id');

  $$GoalsTableProcessedTableManager get goalId {
    final $_column = $_itemColumn<int>('goal_id')!;

    final manager = $$GoalsTableTableManager(
      $_db,
      $_db.goals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_goalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaskGoalLinksTableFilterComposer
    extends Composer<_$PlannerDatabase, $TaskGoalLinksTable> {
  $$TaskGoalLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$PlannerTasksTableFilterComposer get taskId {
    final $$PlannerTasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.plannerTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlannerTasksTableFilterComposer(
            $db: $db,
            $table: $db.plannerTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GoalsTableFilterComposer get goalId {
    final $$GoalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableFilterComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskGoalLinksTableOrderingComposer
    extends Composer<_$PlannerDatabase, $TaskGoalLinksTable> {
  $$TaskGoalLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$PlannerTasksTableOrderingComposer get taskId {
    final $$PlannerTasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.plannerTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlannerTasksTableOrderingComposer(
            $db: $db,
            $table: $db.plannerTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GoalsTableOrderingComposer get goalId {
    final $$GoalsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableOrderingComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskGoalLinksTableAnnotationComposer
    extends Composer<_$PlannerDatabase, $TaskGoalLinksTable> {
  $$TaskGoalLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$PlannerTasksTableAnnotationComposer get taskId {
    final $$PlannerTasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.plannerTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlannerTasksTableAnnotationComposer(
            $db: $db,
            $table: $db.plannerTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GoalsTableAnnotationComposer get goalId {
    final $$GoalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableAnnotationComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskGoalLinksTableTableManager
    extends
        RootTableManager<
          _$PlannerDatabase,
          $TaskGoalLinksTable,
          TaskGoalLink,
          $$TaskGoalLinksTableFilterComposer,
          $$TaskGoalLinksTableOrderingComposer,
          $$TaskGoalLinksTableAnnotationComposer,
          $$TaskGoalLinksTableCreateCompanionBuilder,
          $$TaskGoalLinksTableUpdateCompanionBuilder,
          (TaskGoalLink, $$TaskGoalLinksTableReferences),
          TaskGoalLink,
          PrefetchHooks Function({bool taskId, bool goalId})
        > {
  $$TaskGoalLinksTableTableManager(
    _$PlannerDatabase db,
    $TaskGoalLinksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskGoalLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskGoalLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskGoalLinksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> taskId = const Value.absent(),
            Value<int> goalId = const Value.absent(),
          }) => TaskGoalLinksCompanion(taskId: taskId, goalId: goalId),
          createCompanionCallback: ({
            Value<int> taskId = const Value.absent(),
            required int goalId,
          }) => TaskGoalLinksCompanion.insert(taskId: taskId, goalId: goalId),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TaskGoalLinksTable, TaskGoalLink>(table),
                  $$TaskGoalLinksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false, goalId = false}) {
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
                    if (taskId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.taskId,
                        referencedTable: $$TaskGoalLinksTableReferences
                            ._taskIdTable(db),
                        referencedColumn: $$TaskGoalLinksTableReferences
                            ._taskIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (goalId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.goalId,
                        referencedTable: $$TaskGoalLinksTableReferences
                            ._goalIdTable(db),
                        referencedColumn: $$TaskGoalLinksTableReferences
                            ._goalIdTable(db)
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

typedef $$TaskGoalLinksTableProcessedTableManager =
    ProcessedTableManager<
      _$PlannerDatabase,
      $TaskGoalLinksTable,
      TaskGoalLink,
      $$TaskGoalLinksTableFilterComposer,
      $$TaskGoalLinksTableOrderingComposer,
      $$TaskGoalLinksTableAnnotationComposer,
      $$TaskGoalLinksTableCreateCompanionBuilder,
      $$TaskGoalLinksTableUpdateCompanionBuilder,
      (TaskGoalLink, $$TaskGoalLinksTableReferences),
      TaskGoalLink,
      PrefetchHooks Function({bool taskId, bool goalId})
    >;
typedef $$PeriodPlansTableCreateCompanionBuilder =
    PeriodPlansCompanion Function({
      required String key,
      Value<String> priorities,
      Value<String> outcomes,
      Value<String> review,
      Value<int> rowid,
    });
typedef $$PeriodPlansTableUpdateCompanionBuilder =
    PeriodPlansCompanion Function({
      Value<String> key,
      Value<String> priorities,
      Value<String> outcomes,
      Value<String> review,
      Value<int> rowid,
    });

class $$PeriodPlansTableFilterComposer
    extends Composer<_$PlannerDatabase, $PeriodPlansTable> {
  $$PeriodPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priorities => $composableBuilder(
    column: $table.priorities,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outcomes => $composableBuilder(
    column: $table.outcomes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get review => $composableBuilder(
    column: $table.review,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PeriodPlansTableOrderingComposer
    extends Composer<_$PlannerDatabase, $PeriodPlansTable> {
  $$PeriodPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priorities => $composableBuilder(
    column: $table.priorities,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outcomes => $composableBuilder(
    column: $table.outcomes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get review => $composableBuilder(
    column: $table.review,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PeriodPlansTableAnnotationComposer
    extends Composer<_$PlannerDatabase, $PeriodPlansTable> {
  $$PeriodPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get priorities => $composableBuilder(
    column: $table.priorities,
    builder: (column) => column,
  );

  GeneratedColumn<String> get outcomes =>
      $composableBuilder(column: $table.outcomes, builder: (column) => column);

  GeneratedColumn<String> get review =>
      $composableBuilder(column: $table.review, builder: (column) => column);
}

class $$PeriodPlansTableTableManager
    extends
        RootTableManager<
          _$PlannerDatabase,
          $PeriodPlansTable,
          PeriodPlan,
          $$PeriodPlansTableFilterComposer,
          $$PeriodPlansTableOrderingComposer,
          $$PeriodPlansTableAnnotationComposer,
          $$PeriodPlansTableCreateCompanionBuilder,
          $$PeriodPlansTableUpdateCompanionBuilder,
          (
            PeriodPlan,
            BaseReferences<_$PlannerDatabase, $PeriodPlansTable, PeriodPlan>,
          ),
          PeriodPlan,
          PrefetchHooks Function()
        > {
  $$PeriodPlansTableTableManager(_$PlannerDatabase db, $PeriodPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PeriodPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PeriodPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PeriodPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> priorities = const Value.absent(),
                Value<String> outcomes = const Value.absent(),
                Value<String> review = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PeriodPlansCompanion(
                key: key,
                priorities: priorities,
                outcomes: outcomes,
                review: review,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                Value<String> priorities = const Value.absent(),
                Value<String> outcomes = const Value.absent(),
                Value<String> review = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PeriodPlansCompanion.insert(
                key: key,
                priorities: priorities,
                outcomes: outcomes,
                review: review,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PeriodPlansTable, PeriodPlan>(table),
                  BaseReferences<
                    _$PlannerDatabase,
                    $PeriodPlansTable,
                    PeriodPlan
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PeriodPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$PlannerDatabase,
      $PeriodPlansTable,
      PeriodPlan,
      $$PeriodPlansTableFilterComposer,
      $$PeriodPlansTableOrderingComposer,
      $$PeriodPlansTableAnnotationComposer,
      $$PeriodPlansTableCreateCompanionBuilder,
      $$PeriodPlansTableUpdateCompanionBuilder,
      (
        PeriodPlan,
        BaseReferences<_$PlannerDatabase, $PeriodPlansTable, PeriodPlan>,
      ),
      PeriodPlan,
      PrefetchHooks Function()
    >;
typedef $$MasterTasksTableCreateCompanionBuilder =
    MasterTasksCompanion Function({
      Value<int> id,
      required String periodKey,
      required String title,
      Value<int?> goalId,
      Value<int?> taskId,
      Value<bool> scheduled,
    });
typedef $$MasterTasksTableUpdateCompanionBuilder =
    MasterTasksCompanion Function({
      Value<int> id,
      Value<String> periodKey,
      Value<String> title,
      Value<int?> goalId,
      Value<int?> taskId,
      Value<bool> scheduled,
    });

final class $$MasterTasksTableReferences
    extends BaseReferences<_$PlannerDatabase, $MasterTasksTable, MasterTask> {
  $$MasterTasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GoalsTable _goalIdTable(_$PlannerDatabase db) =>
      db.goals.createAlias('master_tasks__goal_id__goals__id');

  $$GoalsTableProcessedTableManager? get goalId {
    final $_column = $_itemColumn<int>('goal_id');
    if ($_column == null) return null;
    final manager = $$GoalsTableTableManager(
      $_db,
      $_db.goals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_goalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlannerTasksTable _taskIdTable(_$PlannerDatabase db) =>
      db.plannerTasks.createAlias('master_tasks__task_id__planner_tasks__id');

  $$PlannerTasksTableProcessedTableManager? get taskId {
    final $_column = $_itemColumn<int>('task_id');
    if ($_column == null) return null;
    final manager = $$PlannerTasksTableTableManager(
      $_db,
      $_db.plannerTasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MasterTasksTableFilterComposer
    extends Composer<_$PlannerDatabase, $MasterTasksTable> {
  $$MasterTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get periodKey => $composableBuilder(
    column: $table.periodKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get scheduled => $composableBuilder(
    column: $table.scheduled,
    builder: (column) => ColumnFilters(column),
  );

  $$GoalsTableFilterComposer get goalId {
    final $$GoalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableFilterComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlannerTasksTableFilterComposer get taskId {
    final $$PlannerTasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.plannerTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlannerTasksTableFilterComposer(
            $db: $db,
            $table: $db.plannerTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MasterTasksTableOrderingComposer
    extends Composer<_$PlannerDatabase, $MasterTasksTable> {
  $$MasterTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get periodKey => $composableBuilder(
    column: $table.periodKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get scheduled => $composableBuilder(
    column: $table.scheduled,
    builder: (column) => ColumnOrderings(column),
  );

  $$GoalsTableOrderingComposer get goalId {
    final $$GoalsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableOrderingComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlannerTasksTableOrderingComposer get taskId {
    final $$PlannerTasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.plannerTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlannerTasksTableOrderingComposer(
            $db: $db,
            $table: $db.plannerTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MasterTasksTableAnnotationComposer
    extends Composer<_$PlannerDatabase, $MasterTasksTable> {
  $$MasterTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get periodKey =>
      $composableBuilder(column: $table.periodKey, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get scheduled =>
      $composableBuilder(column: $table.scheduled, builder: (column) => column);

  $$GoalsTableAnnotationComposer get goalId {
    final $$GoalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableAnnotationComposer(
            $db: $db,
            $table: $db.goals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlannerTasksTableAnnotationComposer get taskId {
    final $$PlannerTasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.plannerTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlannerTasksTableAnnotationComposer(
            $db: $db,
            $table: $db.plannerTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MasterTasksTableTableManager
    extends
        RootTableManager<
          _$PlannerDatabase,
          $MasterTasksTable,
          MasterTask,
          $$MasterTasksTableFilterComposer,
          $$MasterTasksTableOrderingComposer,
          $$MasterTasksTableAnnotationComposer,
          $$MasterTasksTableCreateCompanionBuilder,
          $$MasterTasksTableUpdateCompanionBuilder,
          (MasterTask, $$MasterTasksTableReferences),
          MasterTask,
          PrefetchHooks Function({bool goalId, bool taskId})
        > {
  $$MasterTasksTableTableManager(_$PlannerDatabase db, $MasterTasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MasterTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MasterTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MasterTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> periodKey = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int?> goalId = const Value.absent(),
                Value<int?> taskId = const Value.absent(),
                Value<bool> scheduled = const Value.absent(),
              }) => MasterTasksCompanion(
                id: id,
                periodKey: periodKey,
                title: title,
                goalId: goalId,
                taskId: taskId,
                scheduled: scheduled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String periodKey,
                required String title,
                Value<int?> goalId = const Value.absent(),
                Value<int?> taskId = const Value.absent(),
                Value<bool> scheduled = const Value.absent(),
              }) => MasterTasksCompanion.insert(
                id: id,
                periodKey: periodKey,
                title: title,
                goalId: goalId,
                taskId: taskId,
                scheduled: scheduled,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MasterTasksTable, MasterTask>(table),
                  $$MasterTasksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({goalId = false, taskId = false}) {
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
                    if (goalId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.goalId,
                        referencedTable: $$MasterTasksTableReferences
                            ._goalIdTable(db),
                        referencedColumn: $$MasterTasksTableReferences
                            ._goalIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (taskId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.taskId,
                        referencedTable: $$MasterTasksTableReferences
                            ._taskIdTable(db),
                        referencedColumn: $$MasterTasksTableReferences
                            ._taskIdTable(db)
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

typedef $$MasterTasksTableProcessedTableManager =
    ProcessedTableManager<
      _$PlannerDatabase,
      $MasterTasksTable,
      MasterTask,
      $$MasterTasksTableFilterComposer,
      $$MasterTasksTableOrderingComposer,
      $$MasterTasksTableAnnotationComposer,
      $$MasterTasksTableCreateCompanionBuilder,
      $$MasterTasksTableUpdateCompanionBuilder,
      (MasterTask, $$MasterTasksTableReferences),
      MasterTask,
      PrefetchHooks Function({bool goalId, bool taskId})
    >;
typedef $$RecurrenceRulesTableCreateCompanionBuilder =
    RecurrenceRulesCompanion Function({
      Value<int> id,
      required String title,
      required String kind,
      required String frequency,
      required String anchorDay,
      Value<String> priority,
      Value<int> startMinute,
      Value<int> endMinute,
      Value<bool> active,
    });
typedef $$RecurrenceRulesTableUpdateCompanionBuilder =
    RecurrenceRulesCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> kind,
      Value<String> frequency,
      Value<String> anchorDay,
      Value<String> priority,
      Value<int> startMinute,
      Value<int> endMinute,
      Value<bool> active,
    });

final class $$RecurrenceRulesTableReferences
    extends
        BaseReferences<
          _$PlannerDatabase,
          $RecurrenceRulesTable,
          RecurrenceRule
        > {
  $$RecurrenceRulesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $RecurrenceOccurrencesTable,
    List<RecurrenceOccurrence>
  >
  _recurrenceOccurrencesRefsTable(_$PlannerDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recurrenceOccurrences,
        aliasName: 'recurrence_rules__id__recurrence_occurrences__rule_id',
      );

  $$RecurrenceOccurrencesTableProcessedTableManager
  get recurrenceOccurrencesRefs {
    final manager = $$RecurrenceOccurrencesTableTableManager(
      $_db,
      $_db.recurrenceOccurrences,
    ).filter((f) => f.ruleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recurrenceOccurrencesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RecurrenceRulesTableFilterComposer
    extends Composer<_$PlannerDatabase, $RecurrenceRulesTable> {
  $$RecurrenceRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get anchorDay => $composableBuilder(
    column: $table.anchorDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMinute => $composableBuilder(
    column: $table.endMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> recurrenceOccurrencesRefs(
    Expression<bool> Function($$RecurrenceOccurrencesTableFilterComposer f) f,
  ) {
    final $$RecurrenceOccurrencesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recurrenceOccurrences,
          getReferencedColumn: (t) => t.ruleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurrenceOccurrencesTableFilterComposer(
                $db: $db,
                $table: $db.recurrenceOccurrences,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$RecurrenceRulesTableOrderingComposer
    extends Composer<_$PlannerDatabase, $RecurrenceRulesTable> {
  $$RecurrenceRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get anchorDay => $composableBuilder(
    column: $table.anchorDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMinute => $composableBuilder(
    column: $table.endMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecurrenceRulesTableAnnotationComposer
    extends Composer<_$PlannerDatabase, $RecurrenceRulesTable> {
  $$RecurrenceRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<String> get anchorDay =>
      $composableBuilder(column: $table.anchorDay, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<int> get startMinute => $composableBuilder(
    column: $table.startMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endMinute =>
      $composableBuilder(column: $table.endMinute, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  Expression<T> recurrenceOccurrencesRefs<T extends Object>(
    Expression<T> Function($$RecurrenceOccurrencesTableAnnotationComposer a) f,
  ) {
    final $$RecurrenceOccurrencesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recurrenceOccurrences,
          getReferencedColumn: (t) => t.ruleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurrenceOccurrencesTableAnnotationComposer(
                $db: $db,
                $table: $db.recurrenceOccurrences,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$RecurrenceRulesTableTableManager
    extends
        RootTableManager<
          _$PlannerDatabase,
          $RecurrenceRulesTable,
          RecurrenceRule,
          $$RecurrenceRulesTableFilterComposer,
          $$RecurrenceRulesTableOrderingComposer,
          $$RecurrenceRulesTableAnnotationComposer,
          $$RecurrenceRulesTableCreateCompanionBuilder,
          $$RecurrenceRulesTableUpdateCompanionBuilder,
          (RecurrenceRule, $$RecurrenceRulesTableReferences),
          RecurrenceRule,
          PrefetchHooks Function({bool recurrenceOccurrencesRefs})
        > {
  $$RecurrenceRulesTableTableManager(
    _$PlannerDatabase db,
    $RecurrenceRulesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurrenceRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurrenceRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurrenceRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<String> anchorDay = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<int> startMinute = const Value.absent(),
                Value<int> endMinute = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => RecurrenceRulesCompanion(
                id: id,
                title: title,
                kind: kind,
                frequency: frequency,
                anchorDay: anchorDay,
                priority: priority,
                startMinute: startMinute,
                endMinute: endMinute,
                active: active,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String kind,
                required String frequency,
                required String anchorDay,
                Value<String> priority = const Value.absent(),
                Value<int> startMinute = const Value.absent(),
                Value<int> endMinute = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => RecurrenceRulesCompanion.insert(
                id: id,
                title: title,
                kind: kind,
                frequency: frequency,
                anchorDay: anchorDay,
                priority: priority,
                startMinute: startMinute,
                endMinute: endMinute,
                active: active,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecurrenceRulesTable, RecurrenceRule>(table),
                  $$RecurrenceRulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recurrenceOccurrencesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (recurrenceOccurrencesRefs) db.recurrenceOccurrences,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (recurrenceOccurrencesRefs)
                    await $_getPrefetchedData<
                      RecurrenceRule,
                      $RecurrenceRulesTable,
                      RecurrenceOccurrence
                    >(
                      currentTable: table,
                      referencedTable: $$RecurrenceRulesTableReferences
                          ._recurrenceOccurrencesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RecurrenceRulesTableReferences(
                            db,
                            table,
                            p0,
                          ).recurrenceOccurrencesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.ruleId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RecurrenceRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$PlannerDatabase,
      $RecurrenceRulesTable,
      RecurrenceRule,
      $$RecurrenceRulesTableFilterComposer,
      $$RecurrenceRulesTableOrderingComposer,
      $$RecurrenceRulesTableAnnotationComposer,
      $$RecurrenceRulesTableCreateCompanionBuilder,
      $$RecurrenceRulesTableUpdateCompanionBuilder,
      (RecurrenceRule, $$RecurrenceRulesTableReferences),
      RecurrenceRule,
      PrefetchHooks Function({bool recurrenceOccurrencesRefs})
    >;
typedef $$RecurrenceOccurrencesTableCreateCompanionBuilder =
    RecurrenceOccurrencesCompanion Function({
      required int ruleId,
      required String day,
      Value<int?> taskId,
      Value<int?> appointmentId,
      Value<int> rowid,
    });
typedef $$RecurrenceOccurrencesTableUpdateCompanionBuilder =
    RecurrenceOccurrencesCompanion Function({
      Value<int> ruleId,
      Value<String> day,
      Value<int?> taskId,
      Value<int?> appointmentId,
      Value<int> rowid,
    });

final class $$RecurrenceOccurrencesTableReferences
    extends
        BaseReferences<
          _$PlannerDatabase,
          $RecurrenceOccurrencesTable,
          RecurrenceOccurrence
        > {
  $$RecurrenceOccurrencesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RecurrenceRulesTable _ruleIdTable(_$PlannerDatabase db) => db
      .recurrenceRules
      .createAlias('recurrence_occurrences__rule_id__recurrence_rules__id');

  $$RecurrenceRulesTableProcessedTableManager get ruleId {
    final $_column = $_itemColumn<int>('rule_id')!;

    final manager = $$RecurrenceRulesTableTableManager(
      $_db,
      $_db.recurrenceRules,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ruleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlannerTasksTable _taskIdTable(_$PlannerDatabase db) => db
      .plannerTasks
      .createAlias('recurrence_occurrences__task_id__planner_tasks__id');

  $$PlannerTasksTableProcessedTableManager? get taskId {
    final $_column = $_itemColumn<int>('task_id');
    if ($_column == null) return null;
    final manager = $$PlannerTasksTableTableManager(
      $_db,
      $_db.plannerTasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AppointmentsTable _appointmentIdTable(_$PlannerDatabase db) => db
      .appointments
      .createAlias('recurrence_occurrences__appointment_id__appointments__id');

  $$AppointmentsTableProcessedTableManager? get appointmentId {
    final $_column = $_itemColumn<int>('appointment_id');
    if ($_column == null) return null;
    final manager = $$AppointmentsTableTableManager(
      $_db,
      $_db.appointments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_appointmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecurrenceOccurrencesTableFilterComposer
    extends Composer<_$PlannerDatabase, $RecurrenceOccurrencesTable> {
  $$RecurrenceOccurrencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  $$RecurrenceRulesTableFilterComposer get ruleId {
    final $$RecurrenceRulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ruleId,
      referencedTable: $db.recurrenceRules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurrenceRulesTableFilterComposer(
            $db: $db,
            $table: $db.recurrenceRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlannerTasksTableFilterComposer get taskId {
    final $$PlannerTasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.plannerTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlannerTasksTableFilterComposer(
            $db: $db,
            $table: $db.plannerTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AppointmentsTableFilterComposer get appointmentId {
    final $$AppointmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.appointmentId,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableFilterComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurrenceOccurrencesTableOrderingComposer
    extends Composer<_$PlannerDatabase, $RecurrenceOccurrencesTable> {
  $$RecurrenceOccurrencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  $$RecurrenceRulesTableOrderingComposer get ruleId {
    final $$RecurrenceRulesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ruleId,
      referencedTable: $db.recurrenceRules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurrenceRulesTableOrderingComposer(
            $db: $db,
            $table: $db.recurrenceRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlannerTasksTableOrderingComposer get taskId {
    final $$PlannerTasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.plannerTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlannerTasksTableOrderingComposer(
            $db: $db,
            $table: $db.plannerTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AppointmentsTableOrderingComposer get appointmentId {
    final $$AppointmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.appointmentId,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableOrderingComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurrenceOccurrencesTableAnnotationComposer
    extends Composer<_$PlannerDatabase, $RecurrenceOccurrencesTable> {
  $$RecurrenceOccurrencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  $$RecurrenceRulesTableAnnotationComposer get ruleId {
    final $$RecurrenceRulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ruleId,
      referencedTable: $db.recurrenceRules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurrenceRulesTableAnnotationComposer(
            $db: $db,
            $table: $db.recurrenceRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlannerTasksTableAnnotationComposer get taskId {
    final $$PlannerTasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.plannerTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlannerTasksTableAnnotationComposer(
            $db: $db,
            $table: $db.plannerTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AppointmentsTableAnnotationComposer get appointmentId {
    final $$AppointmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.appointmentId,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurrenceOccurrencesTableTableManager
    extends
        RootTableManager<
          _$PlannerDatabase,
          $RecurrenceOccurrencesTable,
          RecurrenceOccurrence,
          $$RecurrenceOccurrencesTableFilterComposer,
          $$RecurrenceOccurrencesTableOrderingComposer,
          $$RecurrenceOccurrencesTableAnnotationComposer,
          $$RecurrenceOccurrencesTableCreateCompanionBuilder,
          $$RecurrenceOccurrencesTableUpdateCompanionBuilder,
          (RecurrenceOccurrence, $$RecurrenceOccurrencesTableReferences),
          RecurrenceOccurrence,
          PrefetchHooks Function({bool ruleId, bool taskId, bool appointmentId})
        > {
  $$RecurrenceOccurrencesTableTableManager(
    _$PlannerDatabase db,
    $RecurrenceOccurrencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurrenceOccurrencesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RecurrenceOccurrencesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RecurrenceOccurrencesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> ruleId = const Value.absent(),
                Value<String> day = const Value.absent(),
                Value<int?> taskId = const Value.absent(),
                Value<int?> appointmentId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecurrenceOccurrencesCompanion(
                ruleId: ruleId,
                day: day,
                taskId: taskId,
                appointmentId: appointmentId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int ruleId,
                required String day,
                Value<int?> taskId = const Value.absent(),
                Value<int?> appointmentId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecurrenceOccurrencesCompanion.insert(
                ruleId: ruleId,
                day: day,
                taskId: taskId,
                appointmentId: appointmentId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $RecurrenceOccurrencesTable,
                    RecurrenceOccurrence
                  >(table),
                  $$RecurrenceOccurrencesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({ruleId = false, taskId = false, appointmentId = false}) {
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
                        if (ruleId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.ruleId,
                            referencedTable:
                                $$RecurrenceOccurrencesTableReferences
                                    ._ruleIdTable(db),
                            referencedColumn:
                                $$RecurrenceOccurrencesTableReferences
                                    ._ruleIdTable(db)
                                    .id,
                          ) as T;
                        }
                        if (taskId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.taskId,
                            referencedTable:
                                $$RecurrenceOccurrencesTableReferences
                                    ._taskIdTable(db),
                            referencedColumn:
                                $$RecurrenceOccurrencesTableReferences
                                    ._taskIdTable(db)
                                    .id,
                          ) as T;
                        }
                        if (appointmentId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.appointmentId,
                            referencedTable:
                                $$RecurrenceOccurrencesTableReferences
                                    ._appointmentIdTable(db),
                            referencedColumn:
                                $$RecurrenceOccurrencesTableReferences
                                    ._appointmentIdTable(db)
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

typedef $$RecurrenceOccurrencesTableProcessedTableManager =
    ProcessedTableManager<
      _$PlannerDatabase,
      $RecurrenceOccurrencesTable,
      RecurrenceOccurrence,
      $$RecurrenceOccurrencesTableFilterComposer,
      $$RecurrenceOccurrencesTableOrderingComposer,
      $$RecurrenceOccurrencesTableAnnotationComposer,
      $$RecurrenceOccurrencesTableCreateCompanionBuilder,
      $$RecurrenceOccurrencesTableUpdateCompanionBuilder,
      (RecurrenceOccurrence, $$RecurrenceOccurrencesTableReferences),
      RecurrenceOccurrence,
      PrefetchHooks Function({bool ruleId, bool taskId, bool appointmentId})
    >;

class $PlannerDatabaseManager {
  final _$PlannerDatabase _db;
  $PlannerDatabaseManager(this._db);
  $$DailyNotesTableTableManager get dailyNotes =>
      $$DailyNotesTableTableManager(_db, _db.dailyNotes);
  $$PlannerSettingsTableTableManager get plannerSettings =>
      $$PlannerSettingsTableTableManager(_db, _db.plannerSettings);
  $$PlannerTasksTableTableManager get plannerTasks =>
      $$PlannerTasksTableTableManager(_db, _db.plannerTasks);
  $$TaskHistoriesTableTableManager get taskHistories =>
      $$TaskHistoriesTableTableManager(_db, _db.taskHistories);
  $$AppointmentsTableTableManager get appointments =>
      $$AppointmentsTableTableManager(_db, _db.appointments);
  $$JournalEntriesTableTableManager get journalEntries =>
      $$JournalEntriesTableTableManager(_db, _db.journalEntries);
  $$JournalTaskLinksTableTableManager get journalTaskLinks =>
      $$JournalTaskLinksTableTableManager(_db, _db.journalTaskLinks);
  $$JournalAppointmentLinksTableTableManager get journalAppointmentLinks =>
      $$JournalAppointmentLinksTableTableManager(
        _db,
        _db.journalAppointmentLinks,
      );
  $$JournalAttachmentsTableTableManager get journalAttachments =>
      $$JournalAttachmentsTableTableManager(_db, _db.journalAttachments);
  $$PersonalRolesTableTableManager get personalRoles =>
      $$PersonalRolesTableTableManager(_db, _db.personalRoles);
  $$GoalsTableTableManager get goals =>
      $$GoalsTableTableManager(_db, _db.goals);
  $$GoalMilestonesTableTableManager get goalMilestones =>
      $$GoalMilestonesTableTableManager(_db, _db.goalMilestones);
  $$TaskGoalLinksTableTableManager get taskGoalLinks =>
      $$TaskGoalLinksTableTableManager(_db, _db.taskGoalLinks);
  $$PeriodPlansTableTableManager get periodPlans =>
      $$PeriodPlansTableTableManager(_db, _db.periodPlans);
  $$MasterTasksTableTableManager get masterTasks =>
      $$MasterTasksTableTableManager(_db, _db.masterTasks);
  $$RecurrenceRulesTableTableManager get recurrenceRules =>
      $$RecurrenceRulesTableTableManager(_db, _db.recurrenceRules);
  $$RecurrenceOccurrencesTableTableManager get recurrenceOccurrences =>
      $$RecurrenceOccurrencesTableTableManager(_db, _db.recurrenceOccurrences);
}
