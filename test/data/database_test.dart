import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priority_planner/data/database/app_database.dart';
import 'package:priority_planner/data/repositories/settings_repository.dart';

void main() {
  test('fresh schema creates tables, indexes, and cleanup trigger', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await db.verifyReady();
    final tables = await db.customSelect("SELECT name FROM sqlite_master WHERE type = 'table'").get();
    final names = tables.map((row) => row.read<String>('name')).toSet();
    expect(names, containsAll(['planner_tasks', 'journal_entries', 'journal_attachments', 'tutorial_progress', 'app_settings']));
    final trigger = await db.customSelect("SELECT name FROM sqlite_master WHERE type = 'trigger' AND name = 'queue_attachment_file_deletion'").get();
    expect(trigger, hasLength(1));
    expect((await db.customSelect('PRAGMA user_version').getSingle()).read<int>('user_version'), 1);
  });

  test('foreign key enforcement rejects an orphan attachment', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await db.verifyReady();
    await expectLater(
      db.customStatement(
        'INSERT INTO journal_attachments '
        '(id, entry_id, kind, display_name, relative_path, mime_type, size_bytes, created_at) '
        'VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        ['a', 'missing', 'image', 'photo', 'media/a.jpg', 'image/jpeg', 100, 1],
      ),
      throwsA(isA<Exception>()),
    );
  });

  test('settings survive database close and reopen', () async {
    final directory = await Directory.systemTemp.createTemp('priority-planner-test-');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/planner.sqlite');
    final first = AppDatabase(NativeDatabase(file));
    try {
      await SettingsRepository(first).write('theme', 'dark');
    } finally {
      await first.close();
    }
    final second = AppDatabase(NativeDatabase(file));
    addTearDown(second.close);
    expect(await SettingsRepository(second).read('theme'), 'dark');
    expect(await second.customSelect('PRAGMA foreign_key_check').get(), isEmpty);
  });

  test('unknown future schema is rejected without deleting data', () async {
    final directory = await Directory.systemTemp.createTemp('priority-planner-future-');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/planner.sqlite');
    final first = AppDatabase(NativeDatabase(file));
    try {
      await SettingsRepository(first).write('sentinel', 'preserve me');
      await first.customStatement('PRAGMA user_version = 99');
    } finally {
      await first.close();
    }
    final second = AppDatabase(NativeDatabase(file));
    try {
      await expectLater(second.verifyReady(), throwsA(isA<StateError>()));
    } finally {
      await second.close();
    }
    // A test-only reader matching the stored version can inspect the sentinel.
    final reader = _FutureSchemaDatabase(NativeDatabase(file));
    try {
      expect(await SettingsRepository(reader).read('sentinel'), 'preserve me');
    } finally {
      await reader.close();
    }
  });
}

class _FutureSchemaDatabase extends AppDatabase {
  _FutureSchemaDatabase(super.executor);

  @override
  int get schemaVersion => 99;
}
