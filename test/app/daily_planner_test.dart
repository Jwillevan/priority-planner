import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priority_planner/app/paper_theme.dart';
import 'package:priority_planner/app/providers.dart';
import 'package:priority_planner/data/database/app_database.dart';
import 'package:priority_planner/data/repositories/planner_repository.dart';
import 'package:priority_planner/domain/planner_models.dart';
import 'package:priority_planner/features/planner/daily_spread_screen.dart';
import 'package:priority_planner/features/planner/planner_providers.dart';

final day = DateTime(2026, 10, 12);

Future<ProviderContainer> mountPlanner(WidgetTester tester) async {
  tester.view.physicalSize = const Size(420, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final db = AppDatabase(NativeDatabase.memory());
  final container = ProviderContainer(overrides: [databaseProvider.overrideWithValue(db)]);
  container.read(selectedDayProvider.notifier).select(day);
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
    await db.close();
  });
  await tester.pumpWidget(UncontrolledProviderScope(container: container,
    child: MaterialApp(theme: paperTheme(Brightness.light),
      home: const Scaffold(body: SafeArea(child: DailySpreadScreen())))));
  await tester.pumpAndSettle();
  return container;
}

Finder field(String label) => find.byWidgetPredicate((widget) =>
  widget is TextField && widget.decoration?.labelText == label);

Future<void> addTask(WidgetTester tester, String title) async {
  await tester.tap(find.text('Add task'));
  await tester.pumpAndSettle();
  await tester.enterText(field('Task'), title);
  await tester.tap(find.text('Save task'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('create complete delete and undo a task through the page', (tester) async {
    final container = await mountPlanner(tester);
    await addTask(tester, 'Write proposal');
    expect(find.text('B1  Write proposal'), findsOneWidget);
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(find.text('✓ Completed'), findsOneWidget);
    await tester.tap(find.byTooltip('Actions for B1 Write proposal'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete task'));
    await tester.pumpAndSettle();
    expect(await container.read(plannerRepositoryProvider).tasks(day), isEmpty);
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    final restored = (await container.read(plannerRepositoryProvider).tasks(day)).single;
    expect(restored.status, TaskStatus.completed);
    expect(find.text('B1  Write proposal'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('task editing saves and undo restores its earlier contents', (tester) async {
    await mountPlanner(tester);
    await addTask(tester, 'Original');
    await tester.tap(find.text('B1  Original'));
    await tester.pumpAndSettle();
    await tester.enterText(field('Task'), 'Revised');
    await tester.enterText(field('Details (optional)'), 'Details');
    await tester.tap(find.text('Save task'));
    await tester.pumpAndSettle();
    expect(find.text('B1  Revised'), findsOneWidget);
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(find.text('B1  Original'), findsOneWidget);
  });

  testWidgets('notes autosave on their own date and clear can be undone', (tester) async {
    final container = await mountPlanner(tester);
    final repo = container.read(plannerRepositoryProvider);
    await tester.tap(find.text('Notes'));
    await tester.pumpAndSettle();
    await tester.enterText(field('Daily notes'), 'Today reflection');
    await container.read(noteSessionProvider(plannerDay(day))).flush();
    await tester.pumpAndSettle();
    expect(await repo.readNote(plannerDay(day)), 'Today reflection');
    await tester.tap(find.byTooltip('Next day'));
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(field('Daily notes')).controller!.text, '');
    await tester.tap(find.byTooltip('Previous day'));
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(field('Daily notes')).controller!.text, 'Today reflection');
    await tester.tap(find.byTooltip('Clear daily notes'));
    await container.read(noteSessionProvider(plannerDay(day))).flush();
    await tester.pumpAndSettle();
    expect(await repo.readNote(plannerDay(day)), '');
    await tester.tap(find.text('Undo'));
    await container.read(noteSessionProvider(plannerDay(day))).flush();
    await tester.pumpAndSettle();
    expect(await repo.readNote(plannerDay(day)), 'Today reflection');
  });

  testWidgets('appointment editor saves title description and times', (tester) async {
    final container = await mountPlanner(tester);
    await tester.ensureVisible(find.text('Add appointment'));
    await tester.tap(find.text('Add appointment'));
    await tester.pumpAndSettle();
    await tester.enterText(field('Appointment'), 'Visit');
    await tester.enterText(field('Description (optional)'), 'At the office');
    await tester.tap(find.text('Save appointment'));
    await tester.pumpAndSettle();
    final appointment = (await container.read(plannerRepositoryProvider).watchAppointments(day).first).single;
    expect(appointment.title, 'Visit');
    expect(appointment.description, 'At the office');
    expect(appointment.start.hour, 9);
    expect(appointment.end.hour, 10);
    expect(find.text('Visit'), findsOneWidget);
  });
}
