import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priority_planner/data/database.dart';
import 'package:priority_planner/features/journal/journal_screen.dart';
import 'package:priority_planner/features/planner/planner_screen.dart';

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
  test('bulk review moves rather than duplicates and rolls back invalid selections', () async {
    final db = PlannerDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final a = await db.saveTask(
      day: '2026-10-16',
      title: 'A',
      details: '',
      priority: 'A',
    );
    final b = await db.saveTask(
      day: '2026-10-16',
      title: 'B',
      details: '',
      priority: 'B',
    );
    await db.reviewTasks([a, b, a], 'forwarded', targetDay: '2026-10-17');
    expect(await db.watchTasks('2026-10-16').first, isEmpty);
    expect(await db.watchTasks('2026-10-17').first, hasLength(2));
    expect(await db.select(db.taskHistories).get(), hasLength(2));
    await db.reviewTasks([a, b], 'forwarded', targetDay: '2026-10-17');
    expect(await db.select(db.taskHistories).get(), hasLength(2));
    await expectLater(
      db.reviewTasks([a, 999999], 'completed'),
      throwsA(anything),
    );
    expect(
      (await db.watchTasks('2026-10-17').first).every(
        (t) => t.status == 'open',
      ),
      isTrue,
    );
    await db.reviewTasks([a, b], 'keep');
    await db.reviewTasks([a, b], 'delegated');
    expect(
      (await db.watchTasks('2026-10-17').first).every(
        (t) => t.status == 'delegated',
      ),
      isTrue,
    );
  });
  testWidgets('portrait notes stay selected after wide spread rotation', (
    tester,
  ) async {
    final db = PlannerDatabase.forTesting(NativeDatabase.memory());
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(400, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: Scaffold(body: PlannerScreen())),
      ),
    );
    await settle(tester);
    await tester.drag(find.byType(TabBarView), const Offset(-350, 0));
    await settle(tester);
    expect(find.text('NOTES & JOURNAL'), findsOneWidget);
    tester.view.physicalSize = const Size(1000, 700);
    await settle(tester);
    expect(find.text('Daily planning'), findsOneWidget);
    expect(find.text('Daily record'), findsOneWidget);
    tester.view.physicalSize = const Size(400, 800);
    await settle(tester);
    expect(find.text('NOTES & JOURNAL'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(db.close);
  });
  testWidgets('daily and journal screens handle small phone and large text', (
    tester,
  ) async {
    final db = PlannerDatabase.forTesting(NativeDatabase.memory());
    await tester.runAsync(() => db.writeSetting('tutorial.offered', 'yes'));
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 640);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    Widget app(Widget child) => ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: MaterialApp(
        builder: (context, body) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(2)),
          child: body!,
        ),
        home: Scaffold(body: child),
      ),
    );
    await tester.pumpWidget(app(const PlannerScreen()));
    await settle(tester);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(app(const JournalScreen()));
    await settle(tester);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(db.close);
  });
  testWidgets('bulk daily review forwards selected tasks through the UI', (
    tester,
  ) async {
    final db = PlannerDatabase.forTesting(NativeDatabase.memory());
    await tester.runAsync(() async {
      for (final p in ['A', 'B']) {
        await db.saveTask(
          day: '2026-10-16',
          title: 'Review $p',
          details: '',
          priority: p,
        );
      }
    });
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          home: Scaffold(
            body: PlannerScreen(initialDate: DateTime(2026, 10, 16)),
          ),
        ),
      ),
    );
    await settle(tester);
    await tester.scrollUntilVisible(
      find.text('Review unfinished tasks'),
      400,
      scrollable: find
          .descendant(
            of: find.byType(PaperPage).first,
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.tap(find.text('Review unfinished tasks'));
    await settle(tester);
    await tester.tap(find.text('Apply to 2 tasks'));
    await settle(tester);
    expect(
      await tester.runAsync(() => db.watchTasks('2026-10-16').first),
      isEmpty,
    );
    expect(
      await tester.runAsync(() => db.watchTasks('2026-10-17').first),
      hasLength(2),
    );
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(db.close);
  });
}
