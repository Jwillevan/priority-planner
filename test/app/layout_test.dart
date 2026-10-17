import 'package:flutter/material.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priority_planner/app/paper_theme.dart';
import 'package:priority_planner/app/providers.dart';
import 'package:priority_planner/data/database/app_database.dart';
import 'package:priority_planner/features/planner/daily_spread_screen.dart';

Widget harness(AppDatabase database, {TextScaler scaler = TextScaler.noScaling, Brightness brightness = Brightness.light}) =>
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(database)],
      child: MaterialApp(
        theme: paperTheme(brightness),
        home: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: scaler),
            child: const Scaffold(body: SafeArea(child: DailySpreadScreen())),
          ),
        ),
      ),
    );

Future<void> pumpPlanner(WidgetTester tester, {
  TextScaler scaler = TextScaler.noScaling,
  Brightness brightness = Brightness.light,
}) async {
  final database = AppDatabase(NativeDatabase.memory());
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox.shrink());
    await database.close();
  });
  await tester.pumpWidget(harness(database, scaler: scaler, brightness: brightness));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('portrait offers labeled page controls without swipe', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpPlanner(tester);
    expect(find.text('Planning'), findsOneWidget);
    expect(find.text('Notes'), findsOneWidget);
    await tester.tap(find.text('Notes'));
    await tester.pumpAndSettle();
    expect(find.text('Daily Record'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('wide landscape shows both pages', (tester) async {
    tester.view.physicalSize = const Size(1100, 650);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpPlanner(tester);
    expect(find.text('Daily Planning'), findsOneWidget);
    expect(find.text('Daily Record'), findsOneWidget);
    expect(find.byType(PageView), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('large text and dark theme keep portrait layout readable', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpPlanner(tester, scaler: TextScaler.linear(2), brightness: Brightness.dark);
    expect(find.byType(PageView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('date buttons remain accessible to screen readers', (tester) async {
    final semantics = tester.ensureSemantics();
    addTearDown(semantics.dispose);
    await pumpPlanner(tester);
    expect(find.byTooltip('Previous day'), findsOneWidget);
    expect(find.byTooltip('Next day'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('Choose planner date')), findsOneWidget);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  });

  test('day navigation uses calendar dates across month/year boundaries', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(selectedDayProvider.notifier).select(DateTime(2025, 12, 31));
    container.read(selectedDayProvider.notifier).move(1);
    expect(container.read(selectedDayProvider), DateTime(2026, 1, 1));
    container.read(selectedDayProvider.notifier).move(-1);
    expect(container.read(selectedDayProvider), DateTime(2025, 12, 31));
  });
}
