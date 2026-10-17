import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priority_planner/data/database.dart';
import 'package:priority_planner/features/media/attachment_store.dart';
import 'package:priority_planner/features/security/backup_service.dart';

Future<List<int>> changePayload(
  BackupService service,
  List<int> bytes,
  void Function(Map<String, dynamic>) change,
) async {
  final e = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
  final key = await service.key('correct horse', base64Decode(e['salt']));
  final clear = await service.cipher.decrypt(
    SecretBox(
      base64Decode(e['ciphertext']),
      nonce: base64Decode(e['nonce']),
      mac: Mac(base64Decode(e['mac'])),
    ),
    secretKey: key,
  );
  final payload = jsonDecode(utf8.decode(clear)) as Map<String, dynamic>;
  change(payload);
  final box = await service.cipher.encrypt(
    utf8.encode(jsonEncode(payload)),
    secretKey: key,
  );
  e['nonce'] = base64Encode(box.nonce);
  e['mac'] = base64Encode(box.mac.bytes);
  e['ciphertext'] = base64Encode(box.cipherText);
  return utf8.encode(jsonEncode(e));
}

void main() {
  test('encrypted backup roundtrip includes every table and media; corruption and wrong password preserve data', () async {
    final dir = await Directory.systemTemp.createTemp('backup-test-');
    final db = PlannerDatabase.forTesting(NativeDatabase.memory());
    final media = AttachmentStore(
      db,
      root: Future.value(Directory('${dir.path}/media')),
    );
    final service = BackupService(db, media);
    try {
      await db.saveNote('2026-10-16', 'Private original');
      await db.saveTask(
        day: '2026-10-16',
        title: 'Important',
        details: '',
        priority: 'A',
      );
      await db.saveGoal(title: 'Outcome', description: '', horizon: 'long');
      await db.writeSetting('tutorial.lesson.welcome', 'complete');
      await db.writeSetting('privacy.lock', 'yes');
      await db.writeSetting('notifications.enabled', 'yes');
      final entry = await db.saveJournal(
        day: '2026-10-16',
        title: 'Record',
        delta: '[{"insert":"Journal\\n"}]',
        category: 'Work',
        tags: ['tag'],
        tasks: {},
        appointments: {},
      );
      final source = File('${dir.path}/document.txt');
      await source.writeAsString('File contents');
      await media.importFile(
        entryId: entry,
        source: source,
        name: 'document.txt',
        kind: 'document',
      );
      final bytes = await service.create('correct horse');
      expect(utf8.decode(bytes), isNot(contains('Private original')));
      await expectLater(
        service.validate(bytes, 'wrong password'),
        throwsA(anything),
      );
      final envelope = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
      final ciphertext = base64Decode(envelope['ciphertext']);
      ciphertext[0] ^= 1;
      envelope['ciphertext'] = base64Encode(ciphertext);
      await expectLater(
        service.validate(utf8.encode(jsonEncode(envelope)), 'correct horse'),
        throwsA(anything),
      );
      expect(
        (await db.watchNote('2026-10-16').first)!.content,
        'Private original',
      );
      final checked = await service.validate(bytes, 'correct horse');
      expect(checked.tables.length, db.allTables.length);
      expect(checked.files, hasLength(1));
      await db.saveNote('2026-10-16', 'Newer current');
      final originalFile =
          (await db.watchAttachments(entry).first).single.filename;
      final brokenTables = {
        for (final t in checked.tables.entries)
          t.key: [for (final row in t.value) Map<String, Object?>.from(row)],
      };
      brokenTables['daily_notes']!.single['content'] = null;
      await expectLater(
        service.restore(
          ValidatedBackup(brokenTables, checked.files, checked.created),
        ),
        throwsA(anything),
      );
      expect(
        (await db.watchNote('2026-10-16').first)!.content,
        'Newer current',
      );
      expect(await (await media.file(originalFile)).exists(), isTrue);
      await service.restore(checked);
      expect(
        (await db.watchNote('2026-10-16').first)!.content,
        'Private original',
      );
      expect((await db.select(db.goals).get()).single.title, 'Outcome');
      expect(await db.readSetting('privacy.lock'), isNull);
      expect(await db.readSetting('notifications.enabled'), isNull);
      expect(await db.readSetting('tutorial.lesson.welcome'), 'complete');
      final restored = (await db.watchAttachments(entry).first).single;
      expect(restored.filename, isNot(originalFile));
      expect(
        await (await media.file(restored.filename)).readAsString(),
        'File contents',
      );
      expect(await (await media.file(originalFile)).exists(), isFalse);
      final unsafe = await changePayload(service, bytes, (p) {
        final files = p['files'] as Map;
        files['../escape.txt'] = files.remove(files.keys.first);
      });
      await expectLater(
        service.validate(unsafe, 'correct horse'),
        throwsA(anything),
      );
      final missing = await changePayload(
        service,
        bytes,
        (p) => p['files'] = {},
      );
      await expectLater(
        service.validate(missing, 'correct horse'),
        throwsA(anything),
      );
      await (await media.file(restored.filename)).delete();
      await expectLater(
        service.create('correct horse'),
        throwsA(isA<FileSystemException>()),
      );
    } finally {
      await db.close();
      await dir.delete(recursive: true);
    }
  }, timeout: const Timeout(Duration(minutes: 3)));
}
