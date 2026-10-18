import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';

import 'package:local_auth/local_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:priority_planner/app/app.dart';
import 'package:priority_planner/data/database.dart';
import 'package:priority_planner/features/media/attachment_store.dart';
import 'package:priority_planner/features/security/backup_service.dart';
import 'package:priority_planner/features/security/reminders.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Android storage, native media, notifications and UI workflow', (
    tester,
  ) async {
    final support = await getApplicationSupportDirectory();
    final dir = Directory('${support.path}/integration-${const Uuid().v4()}');
    await dir.create();
    final databaseFile = File('${dir.path}/test.sqlite');
    var db = PlannerDatabase.forTesting(NativeDatabase(databaseFile));
    final root = Directory('${dir.path}/attachments');
    var media = AttachmentStore(db, root: Future.value(root));
    final recorder = AudioRecorder();
    final player = AudioPlayer();
    final notifications = DeviceNotifications();
    try {
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
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextField, 'Task description'),
        'Android integration task',
      );
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('Android integration task'), findsOneWidget);
      final today = dayKey(DateTime.now());
      await db.saveNote(today, 'Android native persistence');
      final entry = await db.saveJournal(
        day: today,
        title: 'Android journal',
        delta: '[{"insert":"Native journal\\n"}]',
        category: 'Testing',
        tags: ['android'],
        tasks: {},
        appointments: {},
      );
      final source = File('${dir.path}/source.txt');
      await source.writeAsString('Native document');
      await media.importFile(
        entryId: entry,
        source: source,
        name: 'source.txt',
        kind: 'document',
      );
      final png = File('${dir.path}/photo.png');
      await png.writeAsBytes(
        base64Decode(
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAusB9Wl6VtUAAAAASUVORK5CYII=',
        ),
      );
      await media.importFile(
        entryId: entry,
        source: png,
        name: 'photo.png',
        kind: 'photo',
      );
      expect(
        await recorder.hasPermission(),
        isTrue,
        reason: 'Grant RECORD_AUDIO to the test emulator before running.',
      );
      final audio = File('${dir.path}/voice.m4a');
      await recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: audio.path,
      );
      await Future<void>.delayed(const Duration(seconds: 1));
      await recorder.pause();
      await recorder.resume();
      await Future<void>.delayed(const Duration(seconds: 1));
      final recording = await recorder.stop();
      expect(recording, isNotNull);
      expect(await audio.length(), greaterThan(0));
      await media.importFile(
        entryId: entry,
        source: audio,
        name: 'voice.m4a',
        kind: 'audio',
      );
      final duration = await player.setFilePath(audio.path);
      expect(duration, isNotNull);
      expect(duration!.inMilliseconds, greaterThan(0));
      await player.seek(Duration(milliseconds: duration.inMilliseconds ~/ 2));
      await notifications.initialize();
      await notifications.schedule(
        21001,
        DateTime.now().add(const Duration(hours: 1)),
        'planning',
        false,
      );
      expect(
        (await notifications.plugin.pendingNotificationRequests()).any(
          (r) => r.id == 21001,
        ),
        isTrue,
      );
      await notifications.cancel(21001);
      final auth = LocalAuthentication();
      expect(await auth.isDeviceSupported(), isA<bool>());
      final backup = await BackupService(
        db,
        media,
      ).create('android test password');
      final checked = await BackupService(
        db,
        media,
      ).validate(backup, 'android test password');
      expect(checked.files, hasLength(3));
      await source.delete();
      await png.delete();
      await audio.delete();
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
      await db.close();
      db = PlannerDatabase.forTesting(NativeDatabase(databaseFile));
      media = AttachmentStore(db, root: Future.value(root));
      expect(
        (await db.watchNote(today).first)!.content,
        'Android native persistence',
      );
      final files = await db.watchAttachments(entry).first;
      expect(files, hasLength(3));
      for (final file in files) {
        expect(await (await media.file(file.filename)).exists(), isTrue);
      }
    } finally {
      await recorder.dispose();
      await player.dispose();
      await notifications.cancel(21001);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
      await db.close();
      // This directory is uniquely created by this test under application support.
      if (await dir.exists()) await dir.delete(recursive: true);
    }
  }, timeout: const Timeout(Duration(minutes: 4)));
}

