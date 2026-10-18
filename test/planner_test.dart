import 'dart:io';

import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priority_planner/data/database.dart';

void main() {
  test('priority ordering, reorder, status history and forwarding without duplication', () async {
    final db = PlannerDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    for (final p in ['B', 'A', 'A', 'C']) {
      await db.saveTask(
        day: '2026-10-16',
        title: 'Task $p',
        details: '',
        priority: p,
      );
    }
    var tasks = await db.watchTasks('2026-10-16').first;
    expect(tasks.map((t) => t.priority), ['A', 'A', 'B', 'C']);
    final first = tasks[0], second = tasks[1];
    await db.swapTasks(first, second);
    tasks = await db.watchTasks('2026-10-16').first;
    expect(tasks.first.id, second.id);
    await db.setTaskStatus(first.id, 'completed');
    await db.setTaskStatus(first.id, 'completed');
    expect(await db.select(db.taskHistories).get(), hasLength(1));
    await db.setTaskStatus(second.id, 'forwarded', targetDay: '2026-10-17');
    await expectLater(
      db.setTaskStatus(second.id, 'forwarded', targetDay: '2026-10-17'),
      throwsArgumentError,
    );
    expect(await db.select(db.plannerTasks).get(), hasLength(5));
    final moved = (await db.watchTasks('2026-10-17').first).single;
    expect(moved.status, 'open');
    final original = (await db.watchTasks('2026-10-16').first).singleWhere(
      (t) => t.status == 'forwarded',
    );
    expect(original.title, second.title);
    await db.setTaskStatus(moved.id, 'completed');
    expect(
      (await db.watchTasks('2026-10-16').first)
          .singleWhere((t) => t.id == original.id)
          .status,
      'forwarded',
    );
    expect(moved.id, second.id);
    expect(await db.select(db.taskHistories).get(), hasLength(3));
  });
  test(
    'direct position moves shift intervening tasks and preserve delegate names',
    () async {
      final db = PlannerDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      for (var i = 0; i < 5; i++) {
        await db.saveTask(
          day: '2026-10-17',
          title: 'Task $i',
          details: '',
          priority: 'A',
          delegatedTo: i == 0 ? 'Sam' : '',
        );
      }
      var tasks = await db.watchTasks('2026-10-17').first;
      final id = tasks.first.id;
      await db.moveTaskToPosition(id, 5);
      tasks = await db.watchTasks('2026-10-17').first;
      expect(tasks.map((t) => t.title), [
        'Task 1',
        'Task 2',
        'Task 3',
        'Task 4',
        'Task 0',
      ]);
      expect(tasks.last.delegatedTo, 'Sam');
      await db.moveTaskToPosition(id, 2);
      expect((await db.watchTasks('2026-10-17').first)[1].id, id);
      await expectLater(db.moveTaskToPosition(id, 0), throwsArgumentError);
    },
  );
  test(
    'version 5 task migration preserves task and adds empty delegate',
    () async {
      final dir = await Directory.systemTemp.createTemp('planner-v5-');
      final file = File('${dir.path}/planner.sqlite');
      var db = PlannerDatabase.forTesting(NativeDatabase(file));
      await db.saveTask(
        day: '2026-10-17',
        title: 'Preserved',
        details: '',
        priority: 'A',
      );
      await db.close();
      final old = sqlite.sqlite3.open(file.path);
      old.execute('ALTER TABLE planner_tasks DROP COLUMN delegated_to');
      old.execute('PRAGMA user_version = 5');
      old.close();
      db = PlannerDatabase.forTesting(NativeDatabase(file));
      final task = (await db.watchTasks('2026-10-17').first).single;
      expect(task.title, 'Preserved');
      expect(task.delegatedTo, '');
      await db.close();
      await dir.delete(recursive: true);
    },
  );
  test(
    'drag moves across empty priorities and normalizes both groups',
    () async {
      final db = PlannerDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final ids = <int>[];
      for (var i = 0; i < 4; i++) {
        ids.add(
          await db.saveTask(
            day: '2026-10-17',
            title: 'Task $i',
            details: '',
            priority: 'A',
          ),
        );
      }
      await db.moveTaskToGroup(ids[1], 'C', 1);
      var tasks = await db.watchTasks('2026-10-17').first;
      expect(tasks.map((t) => t.priority), ['A', 'A', 'A', 'C']);
      expect(tasks.map((t) => t.position), [0, 1, 2, 0]);
      await db.moveTaskToGroup(ids[1], 'B', 1);
      await db.moveTaskToGroup(ids[3], 'B', 1);
      tasks = await db.watchTasks('2026-10-17').first;
      expect(tasks.map((t) => t.id), [ids[0], ids[2], ids[3], ids[1]]);
      expect(tasks.map((t) => t.position), [0, 1, 0, 1]);
      await db.moveTaskToGroup(ids[3], 'B', 2);
      expect((await db.watchTasks('2026-10-17').first).last.id, ids[3]);
      await expectLater(
        db.moveTaskToGroup(ids[0], 'D', 1),
        throwsArgumentError,
      );
      await expectLater(
        db.moveTaskToGroup(ids[0], 'C', 2),
        throwsArgumentError,
      );
      expect(await db.select(db.plannerTasks).get(), hasLength(4));
    },
  );
  test('appointment validation permits overlaps and edits', () async {
    final db = PlannerDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await expectLater(
      db.saveAppointment(
        day: '2026-10-16',
        title: 'Bad',
        start: 600,
        end: 500,
        allDay: false,
      ),
      throwsArgumentError,
    );
    await db.saveAppointment(
      day: '2026-10-16',
      title: 'One',
      start: 540,
      end: 660,
      allDay: false,
    );
    await db.saveAppointment(
      day: '2026-10-16',
      title: 'Two',
      start: 600,
      end: 720,
      allDay: false,
    );
    final rows = await db.watchAppointments('2026-10-16').first;
    expect(rows, hasLength(2));
    await db.saveAppointment(
      id: rows.first.id,
      day: '2026-10-16',
      title: 'Edited',
      start: 540,
      end: 660,
      allDay: false,
    );
    expect(
      (await db.watchAppointments('2026-10-16').first).first.title,
      'Edited',
    );
  });
  test('version 1 migrates without losing notes and survives reopen', () async {
    final dir = await Directory.systemTemp.createTemp('planner-test-');
    final file = File('${dir.path}/planner.sqlite');
    final legacy = sqlite.sqlite3.open(file.path);

    legacy.execute(
      'CREATE TABLE daily_notes (day TEXT NOT NULL PRIMARY KEY, content TEXT NOT NULL DEFAULT \'\', updated_at INTEGER NOT NULL)',
    );
    legacy.execute(
      'CREATE TABLE planner_settings (key TEXT NOT NULL PRIMARY KEY, value TEXT NOT NULL)',
    );
    legacy.execute(
      "INSERT INTO daily_notes VALUES ('2026-10-16','Preserved',0)",
    );
    legacy.execute('PRAGMA user_version = 1');
    legacy.close();
    var db = PlannerDatabase.forTesting(NativeDatabase(file));
    expect((await db.watchNote('2026-10-16').first)!.content, 'Preserved');
    await db.saveTask(
      day: '2026-10-16',
      title: 'Persistent',
      details: '',
      priority: 'A',
    );
    await db.close();
    db = PlannerDatabase.forTesting(NativeDatabase(file));
    expect(
      (await db.watchTasks('2026-10-16').first).single.title,
      'Persistent',
    );
    await db.close();
    await dir.delete(recursive: true);
  });
}
