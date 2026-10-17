import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:priority_planner/data/database.dart';
import 'package:priority_planner/features/planning/recurrence.dart';

void main() {
  test(
    'recurrence honors anchor, weekly boundaries, leap years and month-end',
    () {
      expect(
        recurrenceDates(
          DateTime(2026, 1, 31),
          'monthly',
          DateTime(2026, 1, 1),
          DateTime(2026, 4, 30),
        ).map(dayKey),
        ['2026-01-31', '2026-02-28', '2026-03-31', '2026-04-30'],
      );
      expect(
        recurrenceDates(
          DateTime(2024, 1, 31),
          'monthly',
          DateTime(2024, 2),
          DateTime(2024, 3),
        ).map(dayKey),
        ['2024-02-29'],
      );
      expect(
        recurrenceDates(
          DateTime(2026, 10, 16),
          'weekly',
          DateTime(2026, 10, 1),
          DateTime(2026, 10, 31),
        ).map(dayKey),
        ['2026-10-16', '2026-10-23', '2026-10-30'],
      );
      expect(dayKey(weekStart(DateTime(2027, 1, 1))), '2026-12-28');
      expect(
        () => recurrenceDates(
          DateTime(2026),
          'daily',
          DateTime(2026),
          DateTime(2028),
        ),
        throwsArgumentError,
      );
    },
  );
  test('confirmed recurrence is duplicate-safe across overlap, forwarding and disabling', () async {
    final db = PlannerDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await db.addRecurrence(
      title: 'Review',
      kind: 'task',
      frequency: 'daily',
      anchorDay: '2026-10-16',
    );
    var rule = (await db.select(db.recurrenceRules).get()).single;
    expect(
      await db.recurrencePreview(rule, '2026-10-16', '2026-10-18'),
      hasLength(3),
    );
    expect(await db.select(db.plannerTasks).get(), isEmpty);
    expect(await db.generateRecurrence(rule.id, '2026-10-16', '2026-10-18'), 3);
    expect(await db.generateRecurrence(rule.id, '2026-10-17', '2026-10-19'), 1);
    final first = (await db.watchTasks('2026-10-16').first).single;
    await db.setTaskStatus(first.id, 'forwarded', targetDay: '2026-10-20');
    expect(await db.generateRecurrence(rule.id, '2026-10-16', '2026-10-19'), 0);
    await db.setRecurrenceActive(rule.id, false);
    expect(await db.generateRecurrence(rule.id, '2026-10-21', '2026-10-25'), 0);
    await db.addRecurrence(
      title: 'Meeting',
      kind: 'appointment',
      frequency: 'weekly',
      anchorDay: '2026-10-16',
      start: 600,
      end: 660,
    );
    rule = (await db.select(db.recurrenceRules).get()).last;
    expect(await db.generateRecurrence(rule.id, '2026-10-16', '2026-10-31'), 3);
    expect(await db.generateRecurrence(rule.id, '2026-10-16', '2026-10-31'), 0);
  });
  test('roles, values, goals, milestone progress and master task scheduling persist consistently', () async {
    final db = PlannerDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await db.saveRole(name: 'Family', description: 'Be present');
    final role = (await db.select(db.personalRoles).get()).single;
    await db.writeSetting('personal.values', 'Kindness');
    await db.saveGoal(
      title: 'Family trip',
      description: 'Plan a trip',
      horizon: 'long',
      targetDay: '2027-06-01',
      roleId: role.id,
    );
    final goal = (await db.select(db.goals).get()).single;
    await db.addMilestone(goal.id, 'Choose dates');
    final milestone = (await db.select(db.goalMilestones).get()).single;
    await db.setMilestone(milestone.id, true);
    await db.savePeriod(
      'week:2026-10-12',
      'Plan together',
      'Family trip',
      'Good progress',
    );
    await db.addMasterTask('week:2026-10-12', 'Agree dates', goal.id);
    final master = (await db.select(db.masterTasks).get()).single;
    final id = await db.scheduleMasterTask(master.id, '2026-10-16');
    expect(await db.scheduleMasterTask(master.id, '2026-10-17'), id);
    expect(await db.select(db.plannerTasks).get(), hasLength(1));
    expect((await db.select(db.taskGoalLinks).get()).single.goalId, goal.id);
    await db.goalStatus(goal.id, 'completed');
    await db.goalStatus(goal.id, 'archived');
    expect((await db.select(db.goals).get()).single.status, 'archived');
    expect((await db.select(db.goalMilestones).get()).single.completed, isTrue);
    expect(await db.readSetting('personal.values'), 'Kindness');
  });
  test('v4 upgrades preserving journal, media metadata and tutorial progress; v5 reopens', () async {
    final dir = await Directory.systemTemp.createTemp('planning-migration-');
    final file = File('${dir.path}/db.sqlite');
    var db = PlannerDatabase.forTesting(NativeDatabase(file));
    await db.saveNote('2026-10-16', 'Preserve');
    await db.writeSetting('tutorial.offered', 'yes');
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
    old.execute('PRAGMA user_version=4');
    old.close();
    db = PlannerDatabase.forTesting(NativeDatabase(file));
    expect((await db.watchNote('2026-10-16').first)!.content, 'Preserve');
    await db.saveGoal(title: 'Persist', description: '', horizon: 'short');
    await db.close();
    db = PlannerDatabase.forTesting(NativeDatabase(file));
    expect((await db.select(db.goals).get()).single.title, 'Persist');
    expect(await db.readSetting('tutorial.offered'), 'yes');
    await db.close();
    await dir.delete(recursive: true);
  });
}
