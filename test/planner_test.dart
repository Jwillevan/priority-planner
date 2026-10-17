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
    expect(await db.select(db.plannerTasks).get(), hasLength(4));
    final moved = (await db.watchTasks('2026-10-17').first).single;
    expect(moved.status, 'open');
    expect(moved.id, second.id);
    expect(await db.select(db.taskHistories).get(), hasLength(2));
  });
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
