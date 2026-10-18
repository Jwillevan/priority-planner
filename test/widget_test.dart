import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:priority_planner/app/app.dart';
import 'package:priority_planner/data/database.dart';

void main() {
  testWidgets('daily planner adds tasks and navigates notes and dates', (
    tester,
  ) async {
    final db = PlannerDatabase.forTesting(NativeDatabase.memory());
    await db.writeSetting('tutorial.offered', 'yes');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const PriorityPlannerApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Top 9/Priority Planner'), findsOneWidget);
    await tester.tap(find.text('Add task'));
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pump();
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Plan the day');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Plan the day'), findsOneWidget);
    expect(find.text('A1'), findsOneWidget);
    await tester.tap(find.text('Notes'));
    await tester.pumpAndSettle();
    expect(find.text('NOTES & JOURNAL'), findsOneWidget);
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'A useful day');
    await tester.pumpAndSettle();
    expect(
      (await db.select(db.dailyNotes).get()).single.content,
      'A useful day',
    );
    await tester.tap(find.byTooltip('Next day'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Previous day'));
    await tester.pumpAndSettle();
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pumpAndSettle();
    expect(find.text('A useful day'), findsOneWidget);
    await db.writeSetting('tutorial.offered', 'yes');
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
    await db.close();
  });
}
