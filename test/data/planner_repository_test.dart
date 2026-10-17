import 'dart:async';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priority_planner/data/database/app_database.dart';
import 'package:priority_planner/data/repositories/planner_repository.dart';
import 'package:priority_planner/domain/planner_models.dart';
import 'package:priority_planner/features/planner/note_session.dart';

void main() {
  late AppDatabase db;
  late PlannerRepository repo;
  final day = DateTime(2026, 10, 12);
  final tomorrow = DateTime(2026, 10, 13);
  var sequence = 0;

  setUp(() {
    sequence = 0;
    db = AppDatabase(NativeDatabase.memory());
    repo = PlannerRepository(db, clock: () => DateTime.utc(2026, 10, 12, 12),
      newId: () => 'id-${sequence++}');
  });
  tearDown(() => db.close());

  Future<PlannerUndo> create({String title = 'Plan the day', String priority = 'B'}) =>
      repo.saveTask(day: day, title: title, description: '', priority: priority, status: TaskStatus.notStarted);

  test('priority sorting, independent numbering, and reordering', () async {
    await create(title: 'C', priority: 'C');
    await create(title: 'A first', priority: 'A');
    await create(title: 'B', priority: 'B');
    await create(title: 'A second', priority: 'A');
    final tasks = await repo.tasks(day);
    expect(tasks.map((t) => t.title), ['A first', 'A second', 'B', 'C']);
    expect(taskRankings(tasks).values, ['A1', 'A2', 'B1', 'C1']);
    final undo = await repo.reorder(tasks, 1, 0);
    expect((await repo.tasks(day)).first.title, 'A second');
    await undo.undo();
    expect((await repo.tasks(day)).first.title, 'A first');
  });

  test('moving across priority groups is rejected', () async {
    await create(priority: 'A');
    await create(priority: 'B');
    await expectLater(repo.reorder(await repo.tasks(day), 0, 2), throwsArgumentError);
    expect((await repo.tasks(day)).map((t) => t.priority), ['A', 'B']);
  });

  test('create undo and one-shot protection', () async {
    final undo = await create();
    expect(await repo.tasks(day), hasLength(1));
    await undo.undo();
    expect(await repo.tasks(day), isEmpty);
    await expectLater(undo.undo(), throwsA(isA<PlannerConflict>()));
  });

  test('edit and undo preserve original date and ID', () async {
    await create();
    final original = (await repo.tasks(day)).single;
    final undo = await repo.saveTask(existing: original, day: day, title: 'Revised',
      description: 'Details', priority: 'A', status: TaskStatus.inProgress);
    final edited = (await repo.tasks(day)).single;
    expect(edited.id, original.id);
    expect(edited.priority, 'A');
    expect(edited.description, 'Details');
    await undo.undo();
    expect((await repo.tasks(day)).single.row, original.row);
  });

  test('completion and reopening update timestamps and history', () async {
    await create();
    await repo.setStatus((await repo.tasks(day)).single, TaskStatus.completed);
    final complete = (await repo.tasks(day)).single;
    expect(complete.row['completed_at'], isNotNull);
    await repo.setStatus(complete, TaskStatus.notStarted);
    expect((await repo.tasks(day)).single.row['completed_at'], isNull);
    expect(await db.customSelect('SELECT * FROM task_status_history').get(), hasLength(2));
  });

  test('delegation persists the person and remains unfinished', () async {
    await create();
    await repo.setStatus((await repo.tasks(day)).single, TaskStatus.delegated, delegateName: 'Sam');
    final delegated = (await repo.tasks(day)).single;
    expect(delegated.delegateName, 'Sam');
    expect(delegated.isUnfinished, isTrue);
    await expectLater(repo.setStatus(delegated, TaskStatus.delegated, delegateName: ''), throwsArgumentError);
  });

  test('forward moves a stable record, preserves origin, and can be undone', () async {
    await create();
    final original = (await repo.tasks(day)).single;
    final undo = await repo.moveTask(original, tomorrow);
    expect(await repo.tasks(day), isEmpty);
    final forwarded = (await repo.tasks(tomorrow)).single;
    expect(forwarded.id, original.id);
    expect(forwarded.originalDay, plannerDay(day));
    expect(forwarded.status, TaskStatus.forwarded);
    expect(forwarded.row['completed_at'], isNull);
    await expectLater(repo.moveTask(original, tomorrow), throwsA(isA<PlannerConflict>()));
    expect(await repo.tasks(tomorrow), hasLength(1));
    await undo.undo();
    expect((await repo.tasks(day)).single.row, original.row);
    expect(await repo.tasks(tomorrow), isEmpty);
  });

  test('completed tasks and same-day forwarding are rejected', () async {
    await create();
    await expectLater(repo.moveTask((await repo.tasks(day)).single, day), throwsArgumentError);
    await repo.setStatus((await repo.tasks(day)).single, TaskStatus.completed);
    await expectLater(repo.moveTask((await repo.tasks(day)).single, tomorrow), throwsArgumentError);
  });

  test('undo refuses to overwrite a subsequent edit', () async {
    await create();
    final undo = await repo.setStatus((await repo.tasks(day)).single, TaskStatus.inProgress);
    await repo.setStatus((await repo.tasks(day)).single, TaskStatus.completed);
    await expectLater(undo.undo(), throwsA(isA<PlannerConflict>()));
    expect((await repo.tasks(day)).single.status, TaskStatus.completed);
  });

  test('delete undo restores task history, journal links, and reminder', () async {
    await create();
    await repo.setStatus((await repo.tasks(day)).single, TaskStatus.inProgress);
    final task = (await repo.tasks(day)).single;
    await db.customStatement("INSERT INTO journal_entries (id,entry_day,created_at,updated_at) VALUES ('journal','2026-10-12',1,1)");
    await db.customStatement("INSERT INTO journal_task_links VALUES ('journal',?)", [task.id]);
    await db.customStatement("INSERT INTO reminders (id,notification_id,task_id,kind,scheduled_at) VALUES ('reminder',1,?,'task',1)", [task.id]);
    final undo = await repo.deleteTask(task);
    expect(await repo.tasks(day), isEmpty);
    expect(await db.customSelect('SELECT * FROM journal_entries').get(), hasLength(1));
    await undo.undo();
    expect(await db.customSelect('SELECT * FROM task_status_history').get(), hasLength(1));
    expect(await db.customSelect('SELECT * FROM journal_task_links').get(), hasLength(1));
    expect(await db.customSelect('SELECT * FROM reminders').get(), hasLength(1));
  });

  test('failed delete undo rolls back when its linked journal no longer exists', () async {
    await create();
    final task = (await repo.tasks(day)).single;
    await db.customStatement("INSERT INTO journal_entries (id,entry_day,created_at,updated_at) VALUES ('journal','2026-10-12',1,1)");
    await db.customStatement("INSERT INTO journal_task_links VALUES ('journal',?)", [task.id]);
    final undo = await repo.deleteTask(task);
    await db.customStatement("DELETE FROM journal_entries WHERE id='journal'");
    await expectLater(undo.undo(), throwsA(isA<Exception>()));
    expect(await repo.tasks(day), isEmpty);
  });

  test('stream updates after committed task creation', () async {
    final initial = Completer<void>();
    final changed = Completer<void>();
    final sub = repo.watchTasks(day).listen((tasks) {
      if (!initial.isCompleted) initial.complete();
      if (tasks.isNotEmpty && !changed.isCompleted) changed.complete();
    });
    addTearDown(sub.cancel);
    await initial.future.timeout(const Duration(seconds: 3));
    await create();
    await changed.future.timeout(const Duration(seconds: 3));
  });

  test('appointments create edit delete and undo', () async {
    final created = await repo.saveAppointment(title: 'Meeting', description: 'Prepare',
      start: DateTime(2026, 10, 12, 9), end: DateTime(2026, 10, 12, 10));
    var appointment = (await repo.watchAppointments(day).first).single;
    final edit = await repo.saveAppointment(existing: appointment, title: 'Revised', description: 'Changed',
      start: DateTime(2026, 10, 12, 11), end: DateTime(2026, 10, 12, 12));
    expect((await repo.watchAppointments(day).first).single.title, 'Revised');
    await edit.undo();
    appointment = (await repo.watchAppointments(day).first).single;
    expect(appointment.title, 'Meeting');
    final deletion = await repo.deleteAppointment(appointment);
    expect(await repo.watchAppointments(day).first, isEmpty);
    await deletion.undo();
    expect(await repo.watchAppointments(day).first, hasLength(1));
    // Restoring edit/delete to its original snapshot also allows original create undo.
    await created.undo();
    expect(await repo.watchAppointments(day).first, isEmpty);
  });

  test('overlap, overnight boundaries, and exclusive midnight end', () async {
    await repo.saveAppointment(title: 'Overnight', description: '',
      start: DateTime(2026, 10, 12, 23), end: DateTime(2026, 10, 13, 1));
    await repo.saveAppointment(title: 'Overlap', description: '',
      start: DateTime(2026, 10, 12, 23, 30), end: DateTime(2026, 10, 13));
    expect(await repo.watchAppointments(day).first, hasLength(2));
    expect(await repo.watchAppointments(tomorrow).first, hasLength(1));
    await expectLater(repo.saveAppointment(title: 'Invalid', description: '', start: day, end: day), throwsArgumentError);
  });

  test('notes session serializes rapid writes and restores cleared notes', () async {
    final session = NoteSession(repo, plannerDay(day));
    addTearDown(session.dispose);
    await session.ready;
    session.update('First');
    session.update('Second');
    session.update('Final');
    await session.flush();
    expect(await repo.readNote(plannerDay(day)), 'Final');
    expect(session.value.saving, isFalse);
    session.update('');
    await session.flush();
    session.update('Final');
    await session.flush();
    expect(await repo.readNote(plannerDay(day)), 'Final');
  });

  test('notes for different dates never overwrite each other', () async {
    await repo.saveNote(plannerDay(day), 'Today');
    await repo.saveNote(plannerDay(tomorrow), 'Tomorrow');
    expect(await repo.readNote(plannerDay(day)), 'Today');
    expect(await repo.readNote(plannerDay(tomorrow)), 'Tomorrow');
  });

  test('failed note write retains a draft and retry succeeds', () async {
    final failing = _FailingNotesRepository(db);
    final session = NoteSession(failing, plannerDay(day));
    addTearDown(session.dispose);
    await session.ready;
    session.update('Keep my draft');
    await session.flush();
    expect(session.value.text, 'Keep my draft');
    expect(session.value.error, isNotNull);
    failing.fail = false;
    session.retry();
    await session.flush();
    expect(await failing.readNote(plannerDay(day)), 'Keep my draft');
    expect(session.value.error, isNull);
  });

  test('existing v1 data survives repository use and file reopen', () async {
    final directory = await Directory.systemTemp.createTemp('planner-m2-');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/planner.sqlite');
    final first = AppDatabase(NativeDatabase(file));
    try {
      await first.customStatement("INSERT INTO app_settings VALUES ('sentinel','v1 data',1)");
      final writer = PlannerRepository(first);
      await writer.saveTask(day: day, title: 'Persisted', description: 'Details', priority: 'A', status: TaskStatus.notStarted);
      await writer.saveNote(plannerDay(day), 'Saved notes');
      await writer.saveAppointment(title: 'Visit', description: 'Location', start: day.add(const Duration(hours: 9)), end: day.add(const Duration(hours: 10)));
    } finally { await first.close(); }
    final second = AppDatabase(NativeDatabase(file));
    try {
      final reader = PlannerRepository(second);
      expect((await reader.tasks(day)).single.title, 'Persisted');
      expect(await reader.readNote(plannerDay(day)), 'Saved notes');
      expect((await reader.watchAppointments(day).first).single.description, 'Location');
      expect((await second.customSelect("SELECT value FROM app_settings WHERE key='sentinel'").getSingle()).read<String>('value'), 'v1 data');
      expect(second.schemaVersion, 1);
    } finally { await second.close(); }
  });
}

class _FailingNotesRepository extends PlannerRepository {
  _FailingNotesRepository(super.database);
  bool fail = true;
  @override
  Future<void> saveNote(String day, String text) async {
    if (fail) throw FileSystemException('Simulated storage full');
    await super.saveNote(day, text);
  }
}
