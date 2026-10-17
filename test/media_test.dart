import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:record/record.dart';
import 'package:priority_planner/data/database.dart';
import 'package:priority_planner/features/media/attachment_store.dart';
import 'package:priority_planner/features/media/attachment_panel.dart';
import 'package:priority_planner/features/media/recorder_port.dart';

class FakeRecorder implements RecorderPort {
  bool allowed = true;
  String? path;
  final calls = <String>[];
  @override
  Future<bool> hasPermission() async => allowed;
  @override
  Future<void> start(RecordConfig config, {required String path}) async {
    this.path = path;
    calls.add('start');
    await File(path).writeAsBytes([1, 2, 3]);
  }

  @override
  Future<void> pause() async {
    calls.add('pause');
  }

  @override
  Future<void> resume() async {
    calls.add('resume');
  }

  @override
  Future<String?> stop() async {
    calls.add('stop');
    return path;
  }

  @override
  Future<void> cancel() async {
    calls.add('cancel');
  }

  @override
  Future<void> dispose() async {}
}

Future<int> entry(PlannerDatabase db) => db.saveJournal(
  day: '2026-10-16',
  title: 'Media',
  delta: '[{"insert":"Text\\n"}]',
  category: '',
  tags: [],
  tasks: {},
  appointments: {},
);
void main() {
  test('photo/document/audio copies survive source deletion and database reopen; cleanup and safe paths', () async {
    final dir = await Directory.systemTemp.createTemp('attachments-test-');
    final dbFile = File('${dir.path}/data.sqlite');
    var db = PlannerDatabase.forTesting(NativeDatabase(dbFile));
    final root = Directory('${dir.path}/media');
    var store = AttachmentStore(db, root: Future.value(root));
    final id = await entry(db);
    final source = File('${dir.path}/source.txt');
    await source.writeAsBytes([1, 2, 3]);
    for (final type in ['photo', 'document', 'audio']) {
      await store.importFile(
        entryId: id,
        source: source,
        name: type == 'photo'
            ? 'photo.png'
            : type == 'audio'
            ? 'voice.m4a'
            : 'file.txt',
        kind: type,
      );
    }
    await source.delete();
    await db.close();
    db = PlannerDatabase.forTesting(NativeDatabase(dbFile));
    store = AttachmentStore(db, root: Future.value(root));
    final rows = await db.watchAttachments(id).first;
    expect(rows, hasLength(3));
    for (final row in rows) {
      expect(await (await store.file(row.filename)).readAsBytes(), [1, 2, 3]);
    }
    await store.rename(rows.first, 'Renamed photo', 'Caption');
    expect(
      await db
          .watchJournal(query: 'Renamed photo', attachmentKind: 'photo')
          .first,
      hasLength(1),
    );
    expect(await db.watchJournal(attachmentKind: 'audio').first, hasLength(1));
    await store.reorder(rows, 0, 2);
    expect(
      (await db.watchAttachments(id).first).last.displayName,
      'Renamed photo',
    );
    await expectLater(store.file('../escape.txt'), throwsArgumentError);
    await expectLater(store.file('/absolute.txt'), throwsArgumentError);
    await (await store.file(rows[1].filename)).delete();
    await store.remove(rows[1]);
    expect(await db.watchAttachments(id).first, hasLength(2));
    await db.deleteJournal(id);
    await store.cleanup();
    expect(await root.list().toList(), isEmpty);
    await db.close();
    await dir.delete(recursive: true);
  });
  test('failed copy does not insert metadata or leave partial files', () async {
    final dir = await Directory.systemTemp.createTemp('attachments-failure-');
    final db = PlannerDatabase.forTesting(NativeDatabase.memory());
    final store = AttachmentStore(
      db,
      root: Future.value(Directory('${dir.path}/media')),
    );
    final id = await entry(db);
    await expectLater(
      store.importFile(
        entryId: id,
        source: File('${dir.path}/missing'),
        name: 'missing.pdf',
        kind: 'document',
      ),
      throwsA(isA<FileSystemException>()),
    );
    expect(await db.watchAttachments(id).first, isEmpty);
    await db.close();
    await dir.delete(recursive: true);
  });
  testWidgets(
    'voice permission denial and start/pause/resume/stop/save lifecycle',
    (tester) async {
      final dir = (await tester.runAsync(
        () => Directory.systemTemp.createTemp('voice-test-'),
      ))!;
      final db = PlannerDatabase.forTesting(NativeDatabase.memory());
      final store = AttachmentStore(db, root: Future.value(dir));
      final id = (await tester.runAsync(() => entry(db)))!;
      final fake = FakeRecorder()..allowed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: VoiceRecorder(store: store, entryId: id, backend: fake),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('Start recording'));
      await tester.pump();
      await tester.pump();
      expect(
        find.textContaining('microphone access was denied'),
        findsOneWidget,
      );
      expect(fake.calls, isEmpty);
      fake.allowed = true;
      Future<void> press(String label) async {
        await tester.runAsync(() async {
          await tester.tap(find.text(label));
          await Future<void>.delayed(const Duration(milliseconds: 80));
        });
        for (var i = 0; i < 12; i++) {
          await tester.runAsync(() async {
            await Future<void>.delayed(const Duration(milliseconds: 30));
          });
          await tester.pump();
        }
      }

      await press('Start recording');
      await press('Pause');
      await press('Resume');
      await press('Stop');
      expect(fake.calls, ['start', 'pause', 'resume', 'stop']);
      // Saving uses the same import boundary tested above; this route stays mounted for inspection.
      await press('Save recording');
      expect(
        (await tester.runAsync(() => db.watchAttachments(id).first))!
            .single
            .kind,
        'audio',
      );
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
      await tester.runAsync(db.close);
      await tester.runAsync(() => dir.delete(recursive: true));
    },
  );
}
