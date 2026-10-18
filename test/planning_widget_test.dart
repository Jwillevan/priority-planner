import 'package:priority_planner/features/help/help_screen.dart';
import 'package:priority_planner/features/help/lessons.dart';
import 'package:priority_planner/features/planning/recurrence.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:priority_planner/app/app.dart';
import 'package:priority_planner/data/database.dart';
import 'package:priority_planner/features/planning/goals_screen.dart';

Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 3; i++) {
    await tester.pump();
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 60));
    });
  }
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('role and goal forms persist a new goal with target date', (
    tester,
  ) async {
    final db = PlannerDatabase.forTesting(NativeDatabase.memory());
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: Scaffold(body: GoalsScreen())),
      ),
    );
    await settle(tester);
    await tester.tap(find.text('Add role'));
    await settle(tester);
    await tester.enterText(find.widgetWithText(TextField, 'Role name'), 'Work');
    await tester.tap(find.text('Save'));
    await settle(tester);
    expect(
      (await tester.runAsync(() => db.select(db.personalRoles).get()))!
          .single
          .name,
      'Work',
    );
    await tester.scrollUntilVisible(
      find.text('Add goal'),
      150,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Add goal'));
    await settle(tester);
    await tester.enterText(
      find.widgetWithText(TextField, 'Title'),
      'Complete training',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Target date YYYY-MM-DD (optional)'),
      '2027-01-01',
    );
    await tester.tap(find.text('Save'));
    await settle(tester);
    final goals = await tester.runAsync(() => db.select(db.goals).get());
    expect(goals!.single.title, 'Complete training');
    expect(goals.single.targetDay, '2027-01-01');
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(db.close);
  });
  testWidgets(
    'calendar switches weekly/monthly and opens the selected daily date',
    (tester) async {
      final db = PlannerDatabase.forTesting(NativeDatabase.memory());
      await tester.runAsync(() => db.writeSetting('tutorial.offered', 'yes'));
      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db)],
          child: const PriorityPlannerApp(),
        ),
      );
      await settle(tester);
      await tester.tap(find.byTooltip('Open navigation menu'));
      await settle(tester);
      await tester.tap(find.text('Calendar'));
      await settle(tester);
      expect(find.text('Monthly planning'), findsOneWidget);
      await tester.tap(find.text('Week'));
      await settle(tester);
      expect(find.text('Weekly planning'), findsOneWidget);
      await tester.tap(find.text('Month'));
      await settle(tester);
      await tester.ensureVisible(find.text('15'));
      await tester.tap(find.text('15'));
      await settle(tester);
      final now = DateTime.now();
      expect(
        find.text(dayKey(DateTime(now.year, now.month, 15))),
        findsOneWidget,
      );
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
      await tester.runAsync(db.close);
    },
  );
  testWidgets(
    'weekly tutorial navigates within practice without changing real records',
    (tester) async {
      final real = PlannerDatabase.forTesting(NativeDatabase.memory());
      await tester.pumpWidget(
        MaterialApp(
          home: TutorialSession(
            realDb: real,
            initialIndex: lessons.indexWhere((l) => l.id == 'weekly'),
          ),
        ),
      );
      await settle(tester);
      expect(find.text('Weekly planning'), findsOneWidget);
      final day = dayKey(weekStart(DateTime.now()));
      await tester.ensureVisible(find.text(day));
      await tester.tap(find.text(day));
      await settle(tester);
      expect(find.text('Top 9/Daily Planning'), findsOneWidget);
      await tester.tap(find.text('Practice goals'));
      await settle(tester);
      expect(find.text('Goals, roles & values'), findsOneWidget);
      expect(
        await tester.runAsync(() => real.select(real.goals).get()),
        isEmpty,
      );
      expect(
        await tester.runAsync(() => real.select(real.personalRoles).get()),
        isEmpty,
      );
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
      await tester.runAsync(real.close);
    },
  );
}
