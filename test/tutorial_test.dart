import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priority_planner/data/database.dart';
import 'package:priority_planner/features/help/help_screen.dart';
import 'package:priority_planner/features/help/lessons.dart';
import 'package:priority_planner/features/help/tutorial_focus.dart';

Future<void> settle(WidgetTester tester) async {
  await tester.pump();
  await tester.runAsync(() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
  });
  await tester.pumpAndSettle();
}

void main() {
  test('lesson catalogue and selective progress reset', () async {
    final db = PlannerDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    expect(lessons.where((l) => !l.advanced), hasLength(20));
    expect(lessons.where((l) => l.advanced), hasLength(11));
    expect(lessons.map((l) => l.id).toSet(), hasLength(31));
    await db.writeSetting('tutorial.offered', 'yes');
    await db.writeSetting('startHour', '8');
    await db.writeSetting('tutorial.lesson.welcome', 'complete');
    expect(
      (await db.watchTutorialProgress().first).where(
        (s) => s.value == 'complete',
      ),
      hasLength(1),
    );
    await db.resetTutorialProgress();
    expect(await db.readSetting('tutorial.lesson.welcome'), isNull);
    expect(await db.readSetting('tutorial.offered'), 'yes');
    expect(await db.readSetting('startHour'), '8');
  });
  testWidgets('first launch skip persists and help search finds lessons', (
    tester,
  ) async {
    final db = PlannerDatabase.forTesting(NativeDatabase.memory());
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(
          home: Scaffold(body: TutorialWelcome(child: HelpScreen())),
        ),
      ),
    );
    await settle(tester);
    expect(find.text('Start Tutorial'), findsOneWidget);
    await tester.tap(find.text('Skip for Now'));
    await settle(tester);
    expect(
      await tester.runAsync(() => db.readSetting('tutorial.offered')),
      'yes',
    );
    await tester.enterText(find.byType(TextField), 'voice');
    await settle(tester);
    expect(find.text('Recording a voice entry'), findsOneWidget);
    expect(find.text('Adding your first task'), findsNothing);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(db.close);
  });
  testWidgets(
    'practice uses separate data and Next records progress while Skip does not',
    (tester) async {
      final real = PlannerDatabase.forTesting(NativeDatabase.memory());
      await tester.pumpWidget(
        MaterialApp(home: TutorialSession(realDb: real, initialIndex: 3)),
      );
      await settle(tester);
      expect(
        find.text('PRACTICE DATA • discarded when you leave'),
        findsOneWidget,
      );
      expect(find.byType(TutorialHighlight), findsWidgets);
      await tester.ensureVisible(find.text('Add task'));
      await tester.tap(find.text('Add task'));
      await settle(tester);
      await tester.enterText(find.byType(TextField).first, 'Only in practice');
      await tester.tap(find.text('Save'));
      await settle(tester);
      expect(
        await tester.runAsync(() => real.select(real.plannerTasks).get()),
        isEmpty,
      );
      expect(
        await tester.runAsync(() => real.select(real.appointments).get()),
        isEmpty,
      );
      await tester.tap(find.text('Next'));
      await settle(tester);
      expect(
        await tester.runAsync(
          () => real.readSetting('tutorial.lesson.add-task'),
        ),
        'complete',
      );
      await tester.tap(find.text('Skip'));
      await settle(tester);
      expect(
        await tester.runAsync(
          () => real.readSetting('tutorial.lesson.edit-task'),
        ),
        isNull,
      );
      await tester.tap(find.text('Restart'));
      await settle(tester);
      expect(find.textContaining('1/31 • Welcome'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
      await tester.runAsync(real.close);
    },
  );
}
