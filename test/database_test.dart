import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priority_planner/data/database.dart';

void main() {
  test('schema creates and note upsert preserves one row', () async {
    final db = PlannerDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await db.saveNote('2026-10-16', 'First');
    await db.saveNote('2026-10-16', 'Revised');
    final notes = await db.select(db.dailyNotes).get();
    expect(notes, hasLength(1));
    expect(notes.single.content, 'Revised');
  });
}
