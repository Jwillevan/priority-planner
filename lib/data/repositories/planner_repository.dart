import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/planner_models.dart';
import '../database/app_database.dart';
import 'planner_sql.dart';

class PlannerRepository {
  PlannerRepository(this.database, {DateTime Function()? clock, String Function()? newId})
      : _clock = clock ?? DateTime.now,
        _newId = newId ?? const Uuid().v4;

  final AppDatabase database;
  final DateTime Function() _clock;
  final String Function() _newId;
  int get _now => _clock().toUtc().millisecondsSinceEpoch;

  Stream<List<PlannerTaskItem>> watchTasks(DateTime day) => database.customSelect(
        PlannerSql.tasksForDay,
        variables: [Variable.withString(plannerDay(day))],
        readsFrom: {database.plannerTasks},
      ).watch().map((rows) => rows.map((r) => PlannerTaskItem(r.data)).toList());

  Stream<List<PlannerAppointmentItem>> watchAppointments(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = DateTime(day.year, day.month, day.day + 1);
    return database.customSelect(
      PlannerSql.appointmentsForDay,
      variables: [Variable.withInt(end.millisecondsSinceEpoch), Variable.withInt(start.millisecondsSinceEpoch)],
      readsFrom: {database.appointments},
    ).watch().map((rows) => rows.map((r) => PlannerAppointmentItem(r.data)).toList());
  }

  Future<List<PlannerTaskItem>> tasks(DateTime day) async =>
      (await database.customSelect(PlannerSql.tasksForDay,
        variables: [Variable.withString(plannerDay(day))]).get())
          .map((r) => PlannerTaskItem(r.data)).toList();

  Future<PlannerUndo> saveTask({
    PlannerTaskItem? existing,
    required DateTime day,
    required String title,
    required String description,
    required String priority,
    required TaskStatus status,
    String delegateName = '',
  }) async {
    if (title.trim().isEmpty || !['A', 'B', 'C'].contains(priority)) {
      throw ArgumentError('Enter a title and an A, B, or C priority.');
    }
    if (status == TaskStatus.delegated && delegateName.trim().isEmpty) {
      throw ArgumentError('Enter who the task is delegated to.');
    }
    final id = existing?.id ?? _newId();
    return _mutate('planner_tasks', id, existing == null ? 'Task created' : 'Task updated', (before) async {
      _requireExpected(before, existing?.row);
      final now = _timestamp(before);
      final key = existing?.day ?? plannerDay(day);
      final position = before != null && before['priority'] == priority
          ? before['position']! as int : await _nextPosition(key, priority);
      final completion = status == TaskStatus.completed
          ? (before?['completed_at'] ?? now) : null;
      if (before == null) {
        await database.customStatement(PlannerSql.insertTask, [
          id, title.trim(), description, key, key, priority, position, status.code,
          delegateName.trim(), now, now, completion,
        ]);
      } else {
        await database.customStatement(PlannerSql.updateTask, [
          title.trim(), description, priority, position, status.code,
          delegateName.trim(), now, completion, id,
        ]);
        if (before['status'] != status.code) {
          await _history(id, before, status.code, key, now);
        }
      }
    });
  }

  Future<PlannerUndo> setStatus(PlannerTaskItem task, TaskStatus status, {String? delegateName}) =>
      saveTask(existing: task, day: DateTime.parse(task.day), title: task.title,
        description: task.description, priority: task.priority, status: status,
        delegateName: delegateName ?? task.delegateName);

  /// Moves the existing record, preserving ID and original day. Never clones it.
  Future<PlannerUndo> moveTask(PlannerTaskItem task, DateTime target) async {
    final destination = plannerDay(target);
    if (!task.isUnfinished) throw ArgumentError('Only unfinished tasks can be forwarded.');
    if (destination == task.day) throw ArgumentError('Choose a different day.');
    return _mutate('planner_tasks', task.id, 'Task forwarded to $destination', (before) async {
      _requireExpected(before, task.row);
      final now = _timestamp(before);
      await database.customStatement(PlannerSql.moveTask,
        [destination, await _nextPosition(destination, task.priority), now, task.id]);
      await _history(task.id, before!, 'forwarded', destination, now);
    });
  }

  Future<PlannerUndo> deleteTask(PlannerTaskItem task) =>
      _mutate('planner_tasks', task.id, 'Task deleted', (before) async {
        _requireExpected(before, task.row);
        await database.customStatement('DELETE FROM planner_tasks WHERE id=?', [task.id]);
      });

  /// Reordering stays inside a priority group. Priority changes use the editor.
  Future<PlannerUndo> reorder(List<PlannerTaskItem> displayed, int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex--;
    if (oldIndex == newIndex) throw ArgumentError('The task is already in that position.');
    final ordered = [...displayed];
    final moved = ordered.removeAt(oldIndex);
    ordered.insert(newIndex, moved);
    final group = ordered.where((t) => t.priority == moved.priority).toList();
    // Reject dropping across the A/B/C boundaries rather than changing priority.
    final priorities = ordered.map((t) => t.priority).join();
    final sorted = [...ordered]..sort((a, b) => a.priority.compareTo(b.priority));
    if (priorities != sorted.map((t) => t.priority).join()) {
      throw ArgumentError('Reorder within A, B, or C. Use Edit to change priority.');
    }
    late List<_Snapshot> before;
    late List<_Snapshot> after;
    await database.transaction(() async {
      before = [for (final task in group) await _capture('planner_tasks', task.id)];
      for (var i = 0; i < group.length; i++) {
        _requireExpected(before[i].row, group[i].row);
        await database.customStatement(PlannerSql.reorderTask, [i, _timestamp(before[i].row), group[i].id]);
      }
      after = [for (final task in group) await _capture('planner_tasks', task.id)];
    });
    _notify();
    return PlannerUndo('Tasks reordered', () async {
      await database.transaction(() async {
        for (var i = 0; i < group.length; i++) {
          final current = await _capture('planner_tasks', group[i].id);
          _checkSnapshot(current, after[i]);
        }
        for (final snapshot in before) {
          await _restore(snapshot);
        }
      });
      _notify();
    });
  }

  Future<PlannerUndo> saveAppointment({PlannerAppointmentItem? existing,
    required String title, required String description, required DateTime start,
    required DateTime end, bool allDay = false}) async {
    if (title.trim().isEmpty || !end.isAfter(start)) {
      throw ArgumentError('Enter a title and an end time after the start time.');
    }
    final id = existing?.id ?? _newId();
    return _mutate('appointments', id, existing == null ? 'Appointment created' : 'Appointment updated', (before) async {
      _requireExpected(before, existing?.row);
      final now = _timestamp(before);
      if (before == null) {
        await database.customStatement(PlannerSql.insertAppointment,
          [id, title.trim(), description, start.millisecondsSinceEpoch, end.millisecondsSinceEpoch, allDay ? 1 : 0, now, now]);
      } else {
        await database.customStatement(PlannerSql.updateAppointment,
          [title.trim(), description, start.millisecondsSinceEpoch, end.millisecondsSinceEpoch, allDay ? 1 : 0, now, id]);
      }
    });
  }

  Future<PlannerUndo> deleteAppointment(PlannerAppointmentItem appointment) =>
      _mutate('appointments', appointment.id, 'Appointment deleted', (before) async {
        _requireExpected(before, appointment.row);
        await database.customStatement('DELETE FROM appointments WHERE id=?', [appointment.id]);
      });

  Future<String> readNote(String day) async =>
      (await database.customSelect(PlannerSql.readNote,
        variables: [Variable.withString(day)]).getSingleOrNull())?.read<String>('content') ?? '';

  Future<void> saveNote(String day, String text) async {
    await database.customStatement(PlannerSql.saveNote, [day, text, _now]);
    database.notifyUpdates({TableUpdate('daily_notes')});
  }

  int _timestamp(Map<String, Object?>? before) {
    final previous = before?['updated_at'] as int? ?? 0;
    return _now > previous ? _now : previous + 1;
  }

  Future<int> _nextPosition(String day, String priority) async {
    final result = await database.customSelect(
      'SELECT COALESCE(MAX(position), -1) + 1 AS next FROM planner_tasks WHERE planned_day=? AND priority=?',
      variables: [Variable.withString(day), Variable.withString(priority)],
    ).getSingle();
    return result.read<int>('next');
  }

  Future<void> _history(String id, Map<String, Object?> before, String status, String day, int time) =>
      database.customStatement(PlannerSql.history,
        [_newId(), id, before['status'], status, before['planned_day'], day, time, _newId()]);

  Future<PlannerUndo> _mutate(String table, String id, String label,
      Future<void> Function(Map<String, Object?>?) action) async {
    late _Snapshot before;
    late _Snapshot after;
    await database.transaction(() async {
      before = await _capture(table, id);
      await action(before.row);
      after = await _capture(table, id);
    });
    _notify();
    return PlannerUndo(label, () async {
      await database.transaction(() async {
        _checkSnapshot(await _capture(table, id), after);
        await _restore(before);
      });
      _notify();
    });
  }

  void _requireExpected(Map<String, Object?>? actual, Map<String, Object?>? expected) {
    if (jsonEncode(actual) != jsonEncode(expected)) throw const PlannerConflict();
  }

  void _checkSnapshot(_Snapshot actual, _Snapshot expected) {
    if (jsonEncode(actual.data) != jsonEncode(expected.data)) {
      throw const PlannerConflict('Undo would replace newer changes. The current data has been kept.');
    }
  }

  Future<_Snapshot> _capture(String table, String id) async {
    assert(table == 'planner_tasks' || table == 'appointments');
    final row = await database.customSelect('SELECT * FROM $table WHERE id=?',
      variables: [Variable.withString(id)]).getSingleOrNull();
    final childTables = table == 'planner_tasks'
        ? {'task_status_history': 'task_id', 'journal_task_links': 'task_id', 'reminders': 'task_id'}
        : {'journal_appointment_links': 'appointment_id', 'reminders': 'appointment_id'};
    final children = <String, List<Map<String, Object?>>>{};
    for (final entry in childTables.entries) {
      final order = entry.key.startsWith('journal_') ? 'entry_id' : 'id';
      children[entry.key] = (await database.customSelect(
        'SELECT * FROM ${entry.key} WHERE ${entry.value}=? ORDER BY $order',
        variables: [Variable.withString(id)]).get()).map((r) => Map<String, Object?>.from(r.data)).toList();
    }
    return _Snapshot(table, id, row == null ? null : Map<String, Object?>.from(row.data), children);
  }

  Future<void> _restore(_Snapshot snapshot) async {
    // Restore the parent and its cascaded dependants together, or roll back all.
    await database.customStatement('DELETE FROM ${snapshot.table} WHERE id=?', [snapshot.id]);
    if (snapshot.row == null) return;
    await _insertRow(snapshot.table, snapshot.row!);
    for (final entry in snapshot.children.entries) {
      for (final row in entry.value) {
        await _insertRow(entry.key, row);
      }
    }
  }

  Future<void> _insertRow(String table, Map<String, Object?> row) => database.customStatement(
    'INSERT INTO $table (${row.keys.join(',')}) VALUES (${List.filled(row.length, '?').join(',')})', row.values.toList());

  void _notify() => database.notifyUpdates({
    for (final table in ['planner_tasks', 'appointments', 'task_status_history', 'journal_task_links', 'journal_appointment_links', 'reminders'])
      TableUpdate(table),
  });
}

class _Snapshot {
  _Snapshot(this.table, this.id, this.row, this.children);
  final String table;
  final String id;
  final Map<String, Object?>? row;
  final Map<String, List<Map<String, Object?>>> children;
  Map<String, Object?> get data => {'row': row, 'children': children};
}
