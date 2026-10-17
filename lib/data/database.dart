import '../features/planning/recurrence.dart';

import 'dart:convert';

import 'journal_content.dart';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
part 'database.g.dart';

String dayKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
const taskStatuses = {
  'open': '○ Not started',
  'progress': '◐ In progress',
  'completed': '✓ Completed',
  'forwarded': '→ Forwarded',
  'delegated': '↗ Delegated',
  'canceled': '× Canceled',
};

class DailyNotes extends Table {
  TextColumn get day => text()();
  TextColumn get content => text().withDefault(const Constant(''))();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {day};
}

class PlannerSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  @override
  Set<Column> get primaryKey => {key};
}

class PlannerTasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get day => text()();
  TextColumn get title => text()();
  TextColumn get details => text().withDefault(const Constant(''))();
  TextColumn get priority => text().withDefault(const Constant('A'))();
  IntColumn get position => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('open'))();
  DateTimeColumn get createdAt => dateTime()();
}

class TaskHistories extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get taskId => integer().references(PlannerTasks, #id)();
  TextColumn get fromStatus => text()();
  TextColumn get toStatus => text()();
  TextColumn get fromDay => text()();
  TextColumn get toDay => text()();
  DateTimeColumn get changedAt => dateTime()();
}

class Appointments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get day => text()();
  TextColumn get title => text()();
  IntColumn get startMinute => integer()();
  IntColumn get endMinute => integer()();
  BoolColumn get allDay => boolean().withDefault(const Constant(false))();
}

class JournalEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get day => text()();
  TextColumn get title => text()();
  TextColumn get delta => text()();
  TextColumn get plainText => text()();
  TextColumn get category => text().withDefault(const Constant(''))();
  TextColumn get tagsJson => text().withDefault(const Constant('[]'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class JournalTaskLinks extends Table {
  IntColumn get entryId =>
      integer().references(JournalEntries, #id, onDelete: KeyAction.cascade)();
  IntColumn get taskId => integer().nullable().references(
    PlannerTasks,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get label => text()();
  @override
  Set<Column> get primaryKey => {entryId, label};
}

class JournalAppointmentLinks extends Table {
  IntColumn get entryId =>
      integer().references(JournalEntries, #id, onDelete: KeyAction.cascade)();
  IntColumn get appointmentId => integer().nullable().references(
    Appointments,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get label => text()();
  @override
  Set<Column> get primaryKey => {entryId, label};
}

class JournalAttachments extends Table {
  TextColumn get id => text()();
  IntColumn get entryId =>
      integer().references(JournalEntries, #id, onDelete: KeyAction.cascade)();
  TextColumn get filename => text()();
  TextColumn get displayName => text()();
  TextColumn get kind => text()();
  TextColumn get caption => text().withDefault(const Constant(''))();
  IntColumn get bytes => integer()();
  IntColumn get position => integer()();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

class PersonalRoles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
}

class Goals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get horizon => text()();
  TextColumn get targetDay => text().nullable()();
  IntColumn get roleId => integer().nullable().references(
    PersonalRoles,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get status => text().withDefault(const Constant('open'))();
}

class GoalMilestones extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get goalId =>
      integer().references(Goals, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
}

class TaskGoalLinks extends Table {
  IntColumn get taskId =>
      integer().references(PlannerTasks, #id, onDelete: KeyAction.cascade)();
  IntColumn get goalId =>
      integer().references(Goals, #id, onDelete: KeyAction.cascade)();
  @override
  Set<Column> get primaryKey => {taskId};
}

class PeriodPlans extends Table {
  TextColumn get key => text()();
  TextColumn get priorities => text().withDefault(const Constant(''))();
  TextColumn get outcomes => text().withDefault(const Constant(''))();
  TextColumn get review => text().withDefault(const Constant(''))();
  @override
  Set<Column> get primaryKey => {key};
}

class MasterTasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get periodKey => text()();
  TextColumn get title => text()();
  IntColumn get goalId => integer().nullable().references(
    Goals,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get taskId => integer().nullable().references(
    PlannerTasks,
    #id,
    onDelete: KeyAction.setNull,
  )();
  BoolColumn get scheduled => boolean().withDefault(const Constant(false))();
}

class RecurrenceRules extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get kind => text()();
  TextColumn get frequency => text()();
  TextColumn get anchorDay => text()();
  TextColumn get priority => text().withDefault(const Constant('B'))();
  IntColumn get startMinute => integer().withDefault(const Constant(540))();
  IntColumn get endMinute => integer().withDefault(const Constant(600))();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
}

class RecurrenceOccurrences extends Table {
  IntColumn get ruleId =>
      integer().references(RecurrenceRules, #id, onDelete: KeyAction.cascade)();
  TextColumn get day => text()();
  IntColumn get taskId => integer().nullable().references(
    PlannerTasks,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get appointmentId => integer().nullable().references(
    Appointments,
    #id,
    onDelete: KeyAction.setNull,
  )();
  @override
  Set<Column> get primaryKey => {ruleId, day};
}

@DriftDatabase(
  tables: [
    DailyNotes,
    PlannerSettings,
    PlannerTasks,
    TaskHistories,
    Appointments,
    JournalEntries,
    JournalTaskLinks,
    JournalAppointmentLinks,
    JournalAttachments,
    PersonalRoles,
    Goals,
    GoalMilestones,
    TaskGoalLinks,
    PeriodPlans,
    MasterTasks,
    RecurrenceRules,
    RecurrenceOccurrences,
  ],
)
class PlannerDatabase extends _$PlannerDatabase {
  PlannerDatabase()
    : ephemeral = false,
      super(
        driftDatabase(
          name: 'priority_planner',
          native: const DriftNativeOptions(
            databaseDirectory: getApplicationSupportDirectory,
          ),
        ),
      );
  PlannerDatabase.forTesting(super.executor) : ephemeral = true;
  final bool ephemeral;
  @override
  int get schemaVersion => 5;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(plannerTasks);
        await m.createTable(taskHistories);
        await m.createTable(appointments);
      }
      if (from < 3) {
        await m.createTable(journalEntries);
        await m.createTable(journalTaskLinks);
        await m.createTable(journalAppointmentLinks);
      }
      if (from < 4) {
        await m.createTable(journalAttachments);
      }
      if (from < 5) {
        await m.createTable(personalRoles);
        await m.createTable(goals);
        await m.createTable(goalMilestones);
        await m.createTable(taskGoalLinks);
        await m.createTable(periodPlans);
        await m.createTable(masterTasks);
        await m.createTable(recurrenceRules);
        await m.createTable(recurrenceOccurrences);
      }
    },
    beforeOpen: (_) async {
      await customStatement('PRAGMA foreign_keys = ON');
      for (final statement in [
        'CREATE INDEX IF NOT EXISTS tasks_day_priority ON planner_tasks(day, priority, position)',
        'CREATE INDEX IF NOT EXISTS appointments_day_start ON appointments(day, start_minute)',
        'CREATE INDEX IF NOT EXISTS journal_day_created ON journal_entries(day, created_at)',
        'CREATE INDEX IF NOT EXISTS attachments_entry_position ON journal_attachments(entry_id, position)',
        'CREATE INDEX IF NOT EXISTS history_task_changed ON task_histories(task_id, changed_at)',
        'CREATE INDEX IF NOT EXISTS master_period ON master_tasks(period_key)',
      ]) {
        await customStatement(statement);
      }
    },
  );
  Future<void> saveNote(String day, String content) =>
      into(dailyNotes).insertOnConflictUpdate(
        DailyNotesCompanion.insert(
          day: day,
          content: Value(content),
          updatedAt: DateTime.now(),
        ),
      );
  Stream<DailyNote?> watchNote(String day) =>
      (select(dailyNotes)..where((n) => n.day.equals(day))).watchSingleOrNull();
  Stream<List<PlannerTask>> watchTasks(String day) =>
      (select(plannerTasks)
            ..where((t) => t.day.equals(day))
            ..orderBy([
              (t) => OrderingTerm.asc(t.priority),
              (t) => OrderingTerm.asc(t.position),
              (t) => OrderingTerm.asc(t.id),
            ]))
          .watch();
  Future<int> saveTask({
    int? id,
    required String day,
    required String title,
    required String details,
    required String priority,
  }) async {
    if (title.trim().isEmpty || !['A', 'B', 'C'].contains(priority)) {
      throw ArgumentError('A title and ABC priority are required');
    }
    if (id == null) {
      final next = await customSelect(
        'SELECT COALESCE(MAX(position), -1) + 1 AS next FROM planner_tasks WHERE day = ? AND priority = ?',
        variables: [Variable(day), Variable(priority)],
        readsFrom: {plannerTasks},
      ).getSingle();
      final last = next.read<int>('next');
      return await into(plannerTasks).insert(
        PlannerTasksCompanion.insert(
          day: day,
          title: title.trim(),
          details: Value(details),
          priority: Value(priority),
          position: Value(last),
          createdAt: DateTime.now(),
        ),
      );
    } else {
      await (update(plannerTasks)..where((t) => t.id.equals(id))).write(
        PlannerTasksCompanion(
          title: Value(title.trim()),
          details: Value(details),
          priority: Value(priority),
        ),
      );
      return id;
    }
  }

  Future<void> setTaskStatus(int id, String status, {String? targetDay}) =>
      transaction(() async {
        if (!taskStatuses.containsKey(status)) {
          throw ArgumentError('Unknown status');
        }
        final task = await (select(
          plannerTasks,
        )..where((t) => t.id.equals(id))).getSingle();
        final day = targetDay ?? task.day;
        if (status == 'forwarded' && day == task.day) {
          throw ArgumentError('Choose a different date');
        }
        final nextStatus = targetDay != null ? 'open' : status;
        if (task.status == nextStatus && task.day == day) {
          return;
        }
        await into(taskHistories).insert(
          TaskHistoriesCompanion.insert(
            taskId: id,
            fromStatus: task.status,
            toStatus: status,
            fromDay: task.day,
            toDay: day,
            changedAt: DateTime.now(),
          ),
        );
        await (update(plannerTasks)..where((t) => t.id.equals(id))).write(
          PlannerTasksCompanion(status: Value(nextStatus), day: Value(day)),
        );
      });
  Future<void> reviewTasks(
    Iterable<int> ids,
    String action, {
    String? targetDay,
  }) => transaction(() async {
    if (![
      'keep',
      'forwarded',
      'completed',
      'canceled',
      'delegated',
    ].contains(action)) {
      throw ArgumentError('Invalid review action');
    }
    if (action == 'forwarded' &&
        (targetDay == null ||
            DateTime.tryParse(targetDay) == null ||
            dayKey(DateTime.parse(targetDay)) != targetDay)) {
      throw ArgumentError('Choose a valid destination');
    }
    for (final id in ids.toSet()) {
      final task = await (select(
        plannerTasks,
      )..where((t) => t.id.equals(id))).getSingle();
      if (action == 'keep' || ['completed', 'canceled'].contains(task.status)) {
        continue;
      }
      if (action == 'forwarded' && task.day == targetDay) continue;
      await setTaskStatus(
        id,
        action,
        targetDay: action == 'forwarded' ? targetDay : null,
      );
    }
  });
  Stream<List<TaskHistory>> watchHistory(int id) =>
      (select(taskHistories)
            ..where((h) => h.taskId.equals(id))
            ..orderBy([(h) => OrderingTerm.desc(h.changedAt)]))
          .watch();

  Future<void> swapTasks(PlannerTask a, PlannerTask b) => transaction(() async {
    if (a.day != b.day || a.priority != b.priority) {
      throw ArgumentError('Reorder within a priority');
    }
    // Resolve equal positions deterministically (possible after moving dates).
    final group =
        await (select(plannerTasks)
              ..where(
                (t) => t.day.equals(a.day) & t.priority.equals(a.priority),
              )
              ..orderBy([
                (t) => OrderingTerm.asc(t.position),
                (t) => OrderingTerm.asc(t.id),
              ]))
            .get();
    final ids = group.map((t) => t.id).toList();
    final x = ids.indexOf(a.id), y = ids.indexOf(b.id);
    ids[x] = b.id;
    ids[y] = a.id;
    for (var i = 0; i < ids.length; i++) {
      await (update(plannerTasks)..where((t) => t.id.equals(ids[i]))).write(
        PlannerTasksCompanion(position: Value(i)),
      );
    }
  });
  Stream<List<Appointment>> watchAppointments(String day) =>
      (select(appointments)
            ..where((a) => a.day.equals(day))
            ..orderBy([
              (a) => OrderingTerm.desc(a.allDay),
              (a) => OrderingTerm.asc(a.startMinute),
            ]))
          .watch();
  Future<void> saveAppointment({
    int? id,
    required String day,
    required String title,
    required int start,
    required int end,
    required bool allDay,
  }) async {
    if (title.trim().isEmpty || start < 0 || end > 1440 || start >= end) {
      throw ArgumentError('Enter a title and an end time after the start');
    }
    final value = AppointmentsCompanion(
      day: Value(day),
      title: Value(title.trim()),
      startMinute: Value(start),
      endMinute: Value(end),
      allDay: Value(allDay),
    );
    if (id == null) {
      await into(appointments).insert(value);
    } else {
      await (update(appointments)..where((a) => a.id.equals(id))).write(value);
    }
  }

  Future<void> deleteAppointment(int id) =>
      (delete(appointments)..where((a) => a.id.equals(id))).go();
  Stream<List<JournalEntry>> watchJournal({
    String query = '',
    String attachmentKind = '',
    String category = '',
    String tag = '',
    String? fromDay,
    String? toDay,
  }) {
    final terms = query.trim().toLowerCase();
    final request = select(journalEntries)
      ..orderBy([
        (e) => OrderingTerm.desc(e.day),
        (e) => OrderingTerm.desc(e.createdAt),
        (e) => OrderingTerm.desc(e.id),
      ]);
    if (category.isNotEmpty) request.where((e) => e.category.equals(category));
    if (fromDay != null) {
      request.where((e) => e.day.isBiggerOrEqualValue(fromDay));
    }
    if (toDay != null) request.where((e) => e.day.isSmallerOrEqualValue(toDay));
    if (attachmentKind.isNotEmpty) {
      request.where(
        (e) => existsQuery(
          select(journalAttachments)..where(
            (a) => a.entryId.equalsExp(e.id) & a.kind.equals(attachmentKind),
          ),
        ),
      );
    }
    // SQL EXISTS keeps linked-title search reactive when links are changed.
    if (terms.isNotEmpty) {
      request.where(
        (e) =>
            e.title.lower().contains(terms) |
            e.plainText.lower().contains(terms) |
            e.day.contains(terms) |
            e.category.lower().contains(terms) |
            e.tagsJson.lower().contains(terms) |
            existsQuery(
              select(journalAttachments)..where(
                (a) =>
                    a.entryId.equalsExp(e.id) &
                    (a.displayName.lower().contains(terms) |
                        a.caption.lower().contains(terms)),
              ),
            ) |
            existsQuery(
              select(journalTaskLinks)..where(
                (l) =>
                    l.entryId.equalsExp(e.id) & l.label.lower().contains(terms),
              ),
            ) |
            existsQuery(
              select(journalAppointmentLinks)..where(
                (l) =>
                    l.entryId.equalsExp(e.id) & l.label.lower().contains(terms),
              ),
            ),
      );
    }
    return request.watch().map(
      (rows) => tag.trim().isEmpty
          ? rows
          : rows
                .where(
                  (e) => (jsonDecode(e.tagsJson) as List).contains(
                    tag.trim().toLowerCase(),
                  ),
                )
                .toList(),
    );
  }

  Future<int> saveJournal({
    int? id,
    required String day,
    required String title,
    required String delta,
    required String category,
    required Iterable<String> tags,
    required Map<int, String> tasks,
    required Map<int, String> appointments,
    Map<String, int?> retainedTasks = const {},
    Map<String, int?> retainedAppointments = const {},
  }) => transaction(() async {
    if (title.trim().isEmpty) throw ArgumentError('Entry title is required');
    final parsedDate = DateTime.tryParse(day);
    if (parsedDate == null || dayKey(parsedDate) != day) {
      throw ArgumentError('Invalid entry date');
    }
    final text = journalPlainText(delta);
    final now = DateTime.now();
    final value = JournalEntriesCompanion(
      day: Value(day),
      title: Value(title.trim()),
      delta: Value(delta),
      plainText: Value(text),
      category: Value(category.trim()),
      tagsJson: Value(jsonEncode(normalizeTags(tags))),
      updatedAt: Value(now),
    );
    final entryId =
        id ??
        await into(journalEntries)
            .insert(value.copyWith(createdAt: Value(now)));
    if (id != null) {
      final changed = await (update(
        journalEntries,
      )..where((e) => e.id.equals(id))).write(value);
      if (changed != 1) throw StateError('Entry no longer exists');
    }
    await (delete(
      journalTaskLinks,
    )..where((l) => l.entryId.equals(entryId))).go();
    await (delete(
      journalAppointmentLinks,
    )..where((l) => l.entryId.equals(entryId))).go();
    final taskLinks = {
      ...retainedTasks,
      for (final t in tasks.entries) '${t.key}: ${t.value}': t.key,
    };
    final appointmentLinks = {
      ...retainedAppointments,
      for (final a in appointments.entries) '${a.key}: ${a.value}': a.key,
    };
    for (final link in taskLinks.entries) {
      await into(journalTaskLinks).insert(
        JournalTaskLinksCompanion.insert(
          entryId: entryId,
          taskId: Value(link.value),
          label: link.key,
        ),
      );
    }
    for (final link in appointmentLinks.entries) {
      await into(journalAppointmentLinks).insert(
        JournalAppointmentLinksCompanion.insert(
          entryId: entryId,
          appointmentId: Value(link.value),
          label: link.key,
        ),
      );
    }
    return entryId;
  });
  Future<void> deleteJournal(int id) async {
    await (delete(journalEntries)..where((e) => e.id.equals(id))).go();
  }

  Future<List<JournalTaskLink>> journalTasks(int id) =>
      (select(journalTaskLinks)..where((l) => l.entryId.equals(id))).get();
  Future<List<JournalAppointmentLink>> journalAppointments(int id) => (select(
    journalAppointmentLinks,
  )..where((l) => l.entryId.equals(id))).get();
  Stream<List<JournalAttachment>> watchAttachments(int entryId) =>
      (select(journalAttachments)
            ..where((a) => a.entryId.equals(entryId))
            ..orderBy([
              (a) => OrderingTerm.asc(a.position),
              (a) => OrderingTerm.asc(a.createdAt),
            ]))
          .watch();
  Future<void> saveRole({
    int? id,
    required String name,
    required String description,
  }) async {
    if (name.trim().isEmpty) throw ArgumentError('Role name required');
    final value = PersonalRolesCompanion(
      name: Value(name.trim()),
      description: Value(description),
    );
    if (id == null) {
      await into(personalRoles).insert(value);
    } else {
      await (update(personalRoles)..where((r) => r.id.equals(id))).write(value);
    }
  }

  Future<void> saveGoal({
    int? id,
    required String title,
    required String description,
    required String horizon,
    String? targetDay,
    int? roleId,
  }) async {
    if (title.trim().isEmpty || !['short', 'long'].contains(horizon)) {
      throw ArgumentError('Invalid goal');
    }
    if (targetDay != null && dayKey(DateTime.parse(targetDay)) != targetDay) {
      throw ArgumentError('Invalid target date');
    }
    final value = GoalsCompanion(
      title: Value(title.trim()),
      description: Value(description),
      horizon: Value(horizon),
      targetDay: Value(targetDay),
      roleId: Value(roleId),
    );
    if (id == null) {
      await into(goals).insert(value);
    } else {
      await (update(goals)..where((g) => g.id.equals(id))).write(value);
    }
  }

  Future<void> goalStatus(int id, String status) async {
    if (!['open', 'completed', 'archived'].contains(status)) {
      throw ArgumentError('Invalid goal status');
    }
    await (update(goals)..where((g) => g.id.equals(id))).write(
      GoalsCompanion(status: Value(status)),
    );
  }

  Future<void> addMilestone(int goalId, String title) async {
    if (title.trim().isEmpty) throw ArgumentError('Title required');
    await into(goalMilestones).insert(
      GoalMilestonesCompanion.insert(goalId: goalId, title: title.trim()),
    );
  }

  Future<void> setMilestone(int id, bool completed) async {
    await (update(goalMilestones)..where((m) => m.id.equals(id))).write(
      GoalMilestonesCompanion(completed: Value(completed)),
    );
  }

  Future<void> linkTaskGoal(int taskId, int? goalId) => transaction(() async {
    await (delete(taskGoalLinks)..where((l) => l.taskId.equals(taskId))).go();
    if (goalId != null) {
      await into(taskGoalLinks).insert(
        TaskGoalLinksCompanion.insert(taskId: Value(taskId), goalId: goalId),
      );
    }
  });
  Future<void> savePeriod(
    String key,
    String priorities,
    String outcomes,
    String review,
  ) async {
    await into(periodPlans).insertOnConflictUpdate(
      PeriodPlansCompanion.insert(
        key: key,
        priorities: Value(priorities),
        outcomes: Value(outcomes),
        review: Value(review),
      ),
    );
  }

  Future<void> addMasterTask(String key, String title, int? goalId) async {
    if (title.trim().isEmpty) throw ArgumentError('Task title required');
    await into(masterTasks).insert(
      MasterTasksCompanion.insert(
        periodKey: key,
        title: title.trim(),
        goalId: Value(goalId),
      ),
    );
  }

  Future<int?> scheduleMasterTask(int id, String day) => transaction(() async {
    final row = await (select(
      masterTasks,
    )..where((t) => t.id.equals(id))).getSingle();
    if (row.scheduled) return row.taskId;
    final taskId = await saveTask(
      day: day,
      title: row.title,
      details: 'From ${row.periodKey}',
      priority: 'B',
    );
    await linkTaskGoal(taskId, row.goalId);
    await (update(masterTasks)..where((t) => t.id.equals(id))).write(
      MasterTasksCompanion(taskId: Value(taskId), scheduled: const Value(true)),
    );
    return taskId;
  });
  Future<void> addRecurrence({
    required String title,
    required String kind,
    required String frequency,
    required String anchorDay,
    String priority = 'B',
    int start = 540,
    int end = 600,
  }) async {
    if (title.trim().isEmpty ||
        !['task', 'appointment'].contains(kind) ||
        !['daily', 'weekly', 'monthly'].contains(frequency) ||
        !['A', 'B', 'C'].contains(priority) ||
        start < 0 ||
        end > 1440 ||
        start >= end) {
      throw ArgumentError('Invalid repeating item');
    }
    final anchor = DateTime.parse(anchorDay);
    if (dayKey(anchor) != anchorDay) throw ArgumentError('Invalid start date');
    await into(recurrenceRules).insert(
      RecurrenceRulesCompanion.insert(
        title: title.trim(),
        kind: kind,
        frequency: frequency,
        anchorDay: anchorDay,
        priority: Value(priority),
        startMinute: Value(start),
        endMinute: Value(end),
      ),
    );
  }

  Future<List<String>> recurrencePreview(
    RecurrenceRule rule,
    String from,
    String to,
  ) async {
    if (!rule.active) return [];
    final existing = await (select(
      recurrenceOccurrences,
    )..where((o) => o.ruleId.equals(rule.id))).get();
    final used = existing.map((o) => o.day).toSet();
    return recurrenceDates(
      DateTime.parse(rule.anchorDay),
      rule.frequency,
      DateTime.parse(from),
      DateTime.parse(to),
    ).map(dayKey).where((d) => !used.contains(d)).toList();
  }

  Future<int> generateRecurrence(int ruleId, String from, String to) =>
      transaction(() async {
        final rule = await (select(
          recurrenceRules,
        )..where((r) => r.id.equals(ruleId))).getSingle();
        final dates = await recurrencePreview(rule, from, to);
        for (final day in dates) {
          int? taskId, appointmentId;
          if (rule.kind == 'task') {
            taskId = await saveTask(
              day: day,
              title: rule.title,
              details: 'Recurring ${rule.frequency} item',
              priority: rule.priority,
            );
          } else {
            appointmentId = await into(appointments).insert(
              AppointmentsCompanion.insert(
                day: day,
                title: rule.title,
                startMinute: rule.startMinute,
                endMinute: rule.endMinute,
              ),
            );
          }
          await into(recurrenceOccurrences).insert(
            RecurrenceOccurrencesCompanion.insert(
              ruleId: ruleId,
              day: day,
              taskId: Value(taskId),
              appointmentId: Value(appointmentId),
            ),
          );
        }
        return dates.length;
      });
  Future<void> setRecurrenceActive(int id, bool active) async {
    await (update(recurrenceRules)..where((r) => r.id.equals(id))).write(
      RecurrenceRulesCompanion(active: Value(active)),
    );
  }

  Future<String?> readSetting(String key) async => (await (select(
    plannerSettings,
  )..where((s) => s.key.equals(key))).getSingleOrNull())?.value;
  Future<void> writeSetting(String key, String value) async {
    await into(plannerSettings).insertOnConflictUpdate(
      PlannerSettingsCompanion.insert(key: key, value: value),
    );
  }

  Stream<List<PlannerSetting>> watchTutorialProgress() =>
      (select(plannerSettings)..where((s) => s.key.like('tutorial.%'))).watch();
  Future<void> resetTutorialProgress() async {
    await (delete(
      plannerSettings,
    )..where((s) => s.key.like('tutorial.lesson.%'))).go();
  }

  Future<void> saveHours(int start, int end) => transaction(() async {
    if (start < 0 || end > 24 || start >= end) {
      throw ArgumentError('Invalid hours');
    }
    for (final entry in {'startHour': '$start', 'endHour': '$end'}.entries) {
      await into(plannerSettings).insertOnConflictUpdate(
        PlannerSettingsCompanion.insert(key: entry.key, value: entry.value),
      );
    }
  });
}

final databaseProvider = Provider<PlannerDatabase>((ref) {
  final db = PlannerDatabase();
  ref.onDispose(db.close);
  return db;
});
final databaseReadyProvider = FutureProvider<bool>((ref) async {
  await ref.watch(databaseProvider).customSelect('SELECT 1').get();
  return true;
});
