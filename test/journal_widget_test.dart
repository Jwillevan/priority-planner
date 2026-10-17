import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:priority_planner/data/database.dart';
import 'package:priority_planner/features/journal/journal_screen.dart';

Future<void> settle(WidgetTester tester) async {
  await tester.pump();
  await tester.runAsync(() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
  });
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'journal editor saves formatted entry and guards unsaved navigation',
    (tester) async {
      final db = PlannerDatabase.forTesting(NativeDatabase.memory());
      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db)],
          child: const MaterialApp(
            localizationsDelegates:
                quill.FlutterQuillLocalizations.localizationsDelegates,
            home: Scaffold(body: JournalScreen()),
          ),
        ),
      );
      await settle(tester);
      await tester.tap(find.text('New entry'));
      await settle(tester);
      await tester.enterText(
        find.widgetWithText(TextField, 'Entry title'),
        'My reflection',
      );
      final editor = tester.widget<quill.QuillEditor>(
        find.byType(quill.QuillEditor),
      );
      editor.controller.document.insert(0, 'A meaningful result');
      editor.controller.formatText(0, 1, quill.Attribute.bold);
      await tester.tap(find.text('Save entry'));
      await settle(tester);
      final rows = await tester.runAsync(() => db.watchJournal().first);
      expect(rows, hasLength(1));
      expect(rows!.single.delta, contains('bold'));
      expect(rows.single.plainText, contains('meaningful'));
      expect(find.text('My reflection'), findsOneWidget);
      await tester.tap(find.text('My reflection'));
      await settle(tester);
      await tester.enterText(
        find.widgetWithText(TextField, 'Entry title'),
        'Unsaved',
      );
      await tester.tap(find.byTooltip('Back to journal'));
      await settle(tester);
      expect(find.text('Discard unsaved journal changes?'), findsOneWidget);
      await tester.tap(find.text('Discard'));
      await settle(tester);
      expect(
        (await tester.runAsync(() => db.watchJournal().first))!.single.title,
        'My reflection',
      );
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
      await tester.runAsync(db.close);
    },
  );
}
