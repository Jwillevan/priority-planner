import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priority_planner/data/database.dart';
import 'package:priority_planner/features/security/app_lock.dart';

class GateAuth implements AuthPort {
  @override
  Future<bool> authenticate() async => true;
}

void main() {
  testWidgets(
    'lock gate hides private semantics until unlock and relocks on background',
    (tester) async {
      final db = PlannerDatabase.forTesting(NativeDatabase.memory());
      await tester.runAsync(() => db.writeSetting('privacy.lock', 'yes'));
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            authProvider.overrideWithValue(GateAuth()),
          ],
          child: const MaterialApp(
            home: AppLockGate(child: Scaffold(body: Text('private record'))),
          ),
        ),
      );
      Future<void> settle() async {
        for (var i = 0; i < 3; i++) {
          await tester.pump();
          await tester.runAsync(() async {
            await Future<void>.delayed(const Duration(milliseconds: 60));
          });
        }
        await tester.pumpAndSettle();
      }

      await settle();
      expect(find.text('Unlock'), findsOneWidget);
      expect(
        tester.getSemantics(find.byType(AppLockGate)).toStringDeep(),
        isNot(contains('private record')),
      );
      await tester.tap(find.text('Unlock'));
      await settle();
      expect(find.text('Unlock'), findsNothing);
      expect(find.bySemanticsLabel('private record'), findsOneWidget);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await settle();
      expect(find.text('Unlock'), findsOneWidget);
      expect(
        tester.getSemantics(find.byType(AppLockGate)).toStringDeep(),
        isNot(contains('private record')),
      );
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await settle();
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
      semantics.dispose();
      await tester.runAsync(db.close);
    },
  );
}
