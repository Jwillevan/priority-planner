import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:priority_planner/data/database.dart';

String delta(String text) => jsonEncode([
  {
    'insert': text,
    'attributes': {'bold': true},
  },
  {'insert': '\n'},
]);
void main() {
  test(
    'journal create/edit/search/tags/date filters and preserved links',
    () async {
      final db = PlannerDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      await db.saveTask(
        day: '2026-10-16',
        title: 'Outline',
        details: '',
        priority: 'A',
      );
      await db.saveAppointment(
        day: '2026-10-16',
        title: 'Discussion',
        start: 600,
        end: 660,
        allDay: false,
      );
      final task = (await db.watchTasks('2026-10-16').first).single;
      final appointment =
          (await db.watchAppointments('2026-10-16').first).single;
      final id = await db.saveJournal(
        day: '2026-10-16',
        title: 'Decisions',
        delta: delta('Agreed on next steps'),
        category: 'Work',
        tags: [' Project ', 'project', 'review'],
        tasks: {task.id: task.title},
        appointments: {appointment.id: appointment.title},
      );
      final original = (await db.watchJournal().first).single;
      expect(original.plainText, 'Agreed on next steps\n');
      expect(jsonDecode(original.tagsJson), ['project', 'review']);
      for (final q in [
        'decisions',
        'next steps',
        '2026-10',
        'work',
        'project',
        'Outline',
        'Discussion',
      ]) {
        expect(await db.watchJournal(query: q).first, hasLength(1), reason: q);
      }
      expect(await db.watchJournal(tag: 'proj').first, isEmpty);
      expect(
        await db.watchJournal(tag: 'PROJECT', category: 'Work').first,
        hasLength(1),
      );
      expect(await db.watchJournal(fromDay: '2026-10-17').first, isEmpty);
      expect(await db.watchJournal(toDay: '2026-10-15').first, isEmpty);
      await db.setTaskStatus(task.id, 'completed');
      await db.deleteAppointment(appointment.id);
      expect((await db.journalAppointments(id)).single.appointmentId, isNull);
      expect(await db.watchJournal(query: 'Discussion').first, hasLength(1));
      await db.saveJournal(
        id: id,
        day: '2026-10-17',
        title: 'Revised',
        delta: delta('Reflection'),
        category: 'Personal',
        tags: [],
        tasks: const {},
        appointments: const {},
        retainedAppointments: {'${appointment.id}: Discussion': null},
      );
      final revised = (await db.watchJournal().first).single;
      expect(revised.createdAt, original.createdAt);
      expect(revised.updatedAt.isBefore(original.updatedAt), isFalse);
      expect(revised.day, '2026-10-17');
      expect(revised.delta, delta('Reflection'));
      await db.deleteJournal(id);
      expect(await db.journalAppointments(id), isEmpty);
      expect(await db.watchTasks('2026-10-16').first, hasLength(1));
    },
  );
  test('invalid title/date/delta never leaves partial entries', () async {
    final db = PlannerDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    for (final input in [
      ('', '2026-10-16', delta('x')),
      ('Title', '2026-02-30', delta('x')),
      ('Title', '2026-10-16', 'invalid'),
    ]) {
      await expectLater(
        db.saveJournal(
          title: input.$1,
          day: input.$2,
          delta: input.$3,
          category: '',
          tags: [],
          tasks: {},
          appointments: {},
        ),
        throwsA(anything),
      );
    }
    expect(await db.watchJournal().first, isEmpty);
  });
  test(
    'v2 migration preserves existing records; journal persists after reopen',
    () async {
      final dir = await Directory.systemTemp.createTemp('journal-test-');
      final file = File('${dir.path}/planner.sqlite');
      var db = PlannerDatabase.forTesting(NativeDatabase(file));
      await db.saveNote('2026-10-16', 'Keep this');
      await db.close();
      final old = sqlite.sqlite3.open(file.path);
      for (final table in [
        'recurrence_occurrences',
        'recurrence_rules',
        'master_tasks',
        'period_plans',
        'task_goal_links',
        'goal_milestones',
        'goals',
        'personal_roles',
      ]) {
        old.execute('DROP TABLE $table');
      }
      old.execute('DROP TABLE journal_attachments');
      old.execute('DROP TABLE journal_task_links');
      old.execute('DROP TABLE journal_appointment_links');
      old.execute('DROP TABLE journal_entries');
      old.execute('PRAGMA user_version = 2');
      old.close();
      db = PlannerDatabase.forTesting(NativeDatabase(file));
      expect((await db.watchNote('2026-10-16').first)!.content, 'Keep this');
      await db.saveJournal(
        day: '2026-10-16',
        title: 'Saved',
        delta: delta('Formatted'),
        category: 'Work',
        tags: ['remember'],
        tasks: {},
        appointments: {},
      );
      await db.close();
      db = PlannerDatabase.forTesting(NativeDatabase(file));
      expect((await db.watchJournal().first).single.delta, delta('Formatted'));
      await db.close();
      await dir.delete(recursive: true);
    },
  );
}
