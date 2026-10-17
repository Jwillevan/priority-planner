import 'package:drift/drift.dart';

import '../../data/journal_content.dart';

import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:drift/native.dart';
import 'package:uuid/uuid.dart';

import '../../data/database.dart';
import '../media/attachment_store.dart';

class ValidatedBackup {
  ValidatedBackup(this.tables, this.files, this.created);
  final Map<String, List<Map<String, Object?>>> tables;
  final Map<String, List<int>> files;
  final String created;
  int get records => tables.values.fold(0, (sum, rows) => sum + rows.length);
}

class BackupService {
  BackupService(this.db, this.media);
  final PlannerDatabase db;
  final AttachmentStore media;
  static const maxBytes = 128 * 1024 * 1024;
  static const maxMediaBytes = 64 * 1024 * 1024;
  static const iterations = 210000;
  final cipher = AesGcm.with256bits();
  Future<SecretKey> key(String password, List<int> salt) => Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: iterations,
    bits: 256,
  ).deriveKey(secretKey: SecretKey(utf8.encode(password)), nonce: salt);
  Future<List<int>> create(String password) async {
    if (password.length < 8) {
      throw ArgumentError('Use at least 8 password characters');
    }
    final payload = await db.transaction(() async {
      final tables = <String, Object?>{};
      for (final table in db.allTables) {
        tables[table.actualTableName] =
            (await db
                    .customSelect('SELECT * FROM "${table.actualTableName}"')
                    .get())
                .map((r) => r.data)
                .toList();
      }
      if (tables.values.fold<int>(
            0,
            (count, rows) => count + (rows as List).length,
          ) >
          250000) {
        throw StateError('Backup exceeds 250,000 records');
      }
      final rows = await db.select(db.journalAttachments).get();
      final files = <String, Object?>{};
      var total = 0;
      for (final a in rows) {
        final file = await media.file(a.filename);
        final length = await file.length();
        total += length;
        if (total > maxMediaBytes) {
          throw StateError('Backup media exceeds 64 MiB');
        }
        final bytes = await file.readAsBytes();
        if (bytes.length != a.bytes) {
          throw StateError('Attachment size mismatch: ${a.displayName}');
        }
        files[a.filename] = {
          'bytes': base64Encode(bytes),
          'size': length,
          'sha256': base64Encode((await Sha256().hash(bytes)).bytes),
        };
      }
      return {
        'format': 'priority-planner',
        'version': 1,
        'schema': db.schemaVersion,
        'created': DateTime.now().toUtc().toIso8601String(),
        'tables': tables,
        'files': files,
      };
    });
    final salt = SecretKeyData.random(length: 16).bytes;
    final nonce = cipher.newNonce();
    final box = await cipher.encrypt(
      utf8.encode(jsonEncode(payload)),
      secretKey: await key(password, salt),
      nonce: nonce,
    );
    final result = utf8.encode(
      jsonEncode({
        'format': 'priority-planner-encrypted',
        'version': 1,
        'kdf': 'pbkdf2-sha256',
        'iterations': iterations,
        'salt': base64Encode(salt),
        'nonce': base64Encode(box.nonce),
        'mac': base64Encode(box.mac.bytes),
        'ciphertext': base64Encode(box.cipherText),
      }),
    );
    if (result.length > maxBytes) throw StateError('Backup exceeds 128 MiB');
    return result;
  }

  Future<ValidatedBackup> validate(List<int> bytes, String password) async {
    if (bytes.length > maxBytes) throw FormatException('Backup too large');
    final envelope = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
    if (envelope['format'] != 'priority-planner-encrypted' ||
        envelope['version'] != 1 ||
        envelope['iterations'] != iterations ||
        envelope['kdf'] != 'pbkdf2-sha256') {
      throw FormatException('Unsupported backup');
    }
    final salt = base64Decode(envelope['salt'] as String),
        nonce = base64Decode(envelope['nonce'] as String),
        mac = base64Decode(envelope['mac'] as String);
    if (salt.length != 16 || nonce.length != 12 || mac.length != 16) {
      throw FormatException('Invalid encryption metadata');
    }
    final clear = await cipher.decrypt(
      SecretBox(
        base64Decode(envelope['ciphertext'] as String),
        nonce: nonce,
        mac: Mac(mac),
      ),
      secretKey: await key(password, salt),
    );
    final payload = jsonDecode(utf8.decode(clear)) as Map<String, dynamic>;
    if (payload['format'] != 'priority-planner' ||
        payload['version'] != 1 ||
        payload['schema'] != db.schemaVersion) {
      throw FormatException('Backup version is incompatible');
    }
    final tables = <String, List<Map<String, Object?>>>{};
    final input = payload['tables'] as Map<String, dynamic>;
    if (input.length != db.allTables.length) {
      throw FormatException('Incomplete table manifest');
    }
    var rowCount = 0;
    for (final table in db.allTables) {
      final rows = input[table.actualTableName] as List;
      final columns = table.$columns.map((c) => c.$name).toSet();
      tables[table.actualTableName] = rows.map((r) {
        final row = Map<String, Object?>.from(r as Map);
        if (row.keys.toSet().difference(columns).isNotEmpty ||
            columns.difference(row.keys.toSet()).isNotEmpty ||
            row.values.any((v) => v != null && v is! String && v is! num)) {
          throw FormatException('Invalid row');
        }
        for (final column in table.$columns) {
          final value = row[column.$name];
          if (value == null) {
            if (!column.$nullable) {
              throw FormatException('Missing required value');
            }
            continue;
          }
          if (column.type == DriftSqlType.string && value is! String) {
            throw FormatException('Invalid text value');
          }
          if ([
                DriftSqlType.int,
                DriftSqlType.bool,
                DriftSqlType.dateTime,
              ].contains(column.type) &&
              value is! int) {
            throw FormatException('Invalid integer value');
          }
          if (column.type == DriftSqlType.bool && value != 0 && value != 1) {
            throw FormatException('Invalid boolean');
          }
        }
        for (final name in [
          'day',
          'from_day',
          'to_day',
          'anchor_day',
          'target_day',
        ]) {
          final value = row[name];
          if (value != null &&
              (value is! String ||
                  DateTime.tryParse(value) == null ||
                  dayKey(DateTime.parse(value)) != value)) {
            throw FormatException('Invalid calendar date');
          }
        }
        if (table.actualTableName == 'planner_tasks' &&
            (!taskStatuses.containsKey(row['status']) ||
                !['A', 'B', 'C'].contains(row['priority']))) {
          throw FormatException('Invalid task');
        }
        if (table.actualTableName == 'appointments' &&
            ((row['start_minute'] as int) < 0 ||
                (row['end_minute'] as int) > 1440 ||
                (row['start_minute'] as int) >= (row['end_minute'] as int))) {
          throw FormatException('Invalid appointment');
        }
        if (table.actualTableName == 'journal_entries') {
          if (journalPlainText(row['delta'] as String) != row['plain_text']) {
            throw FormatException('Journal index mismatch');
          }
          if ((jsonDecode(row['tags_json'] as String) as List).any(
            (tag) => tag is! String,
          )) {
            throw FormatException('Invalid tags');
          }
        }
        if (table.actualTableName == 'journal_attachments' &&
            !['photo', 'document', 'audio'].contains(row['kind'])) {
          throw FormatException('Invalid attachment');
        }
        if (table.actualTableName == 'planner_settings' &&
            (row['key'] as String).startsWith('reminder.')) {
          if (int.tryParse((row['key'] as String).substring(9)) == null) {
            throw FormatException('Invalid reminder ID');
          }
          final data = jsonDecode(row['value'] as String) as Map;
          if (![
                'task',
                'appointment',
                'planning',
                'review',
              ].contains(data['kind']) ||
              DateTime.tryParse(data['at'] as String) == null ||
              data['daily'] is! bool) {
            throw FormatException('Invalid reminder');
          }
        }
        return row;
      }).toList();
      rowCount += rows.length;
    }
    if (rowCount > 250000) throw FormatException('Too many records');
    final files = <String, List<int>>{};
    var total = 0;
    for (final item in (payload['files'] as Map<String, dynamic>).entries) {
      await media.file(item.key);
      final data = item.value as Map;
      final declared = data['size'] as int;
      if (declared < 1 || declared > maxMediaBytes) {
        throw FormatException('Invalid media size');
      }
      final content = base64Decode(data['bytes'] as String);
      total += content.length;
      if (total > maxMediaBytes ||
          content.length != declared ||
          base64Encode((await Sha256().hash(content)).bytes) !=
              data['sha256']) {
        throw FormatException('Attachment integrity check failed');
      }
      files[item.key] = content;
    }
    final attachments = tables['journal_attachments']!;
    final referenced = <String>{};
    for (final a in attachments) {
      final name = a['filename'] as String;
      if (files[name]?.length != a['bytes']) {
        throw FormatException('Missing or damaged attachment');
      }
      if (!referenced.add(name)) {
        throw FormatException('Duplicate media filename');
      }
    }
    if (referenced.length != files.length) {
      throw FormatException('Unreferenced media in backup');
    }
    final staging = PlannerDatabase.forTesting(NativeDatabase.memory());
    try {
      await replaceRows(staging, tables);
    } finally {
      await staging.close();
    }
    final created = payload['created'] as String;
    DateTime.parse(created);
    return ValidatedBackup(tables, files, created);
  }

  Future<void> replaceRows(
    PlannerDatabase target,
    Map<String, List<Map<String, Object?>>> tables,
  ) => target.transaction(() async {
    await target.customStatement('PRAGMA defer_foreign_keys=ON');
    for (final table in target.allTables.toList().reversed) {
      await target.customStatement('DELETE FROM "${table.actualTableName}"');
    }
    for (final table in target.allTables) {
      for (final row in tables[table.actualTableName]!) {
        final keys = row.keys.toList();
        await target.customStatement(
          'INSERT INTO "${table.actualTableName}" (${keys.map((k) => '"$k"').join(',')}) VALUES (${List.filled(keys.length, '?').join(',')})',
          keys.map((k) => row[k]).toList(),
        );
      }
    }
    if ((await target.customSelect('PRAGMA foreign_key_check').get())
        .isNotEmpty) {
      throw FormatException('Broken data relationships');
    }
  });
  // Call only after a review/replace confirmation. New filenames allow DB rollback without touching current media.
  Future<void> restore(ValidatedBackup backup) async {
    final freshFiles = <File>[];
    final remap = <String, String>{};
    final tables = {
      for (final t in backup.tables.entries)
        t.key: [for (final row in t.value) Map<String, Object?>.from(row)],
    };
    try {
      for (final file in backup.files.entries) {
        final extension = file.key.split('.').last;
        final name = '${const Uuid().v4()}.$extension';
        final target = await media.file(name);
        freshFiles.add(target);
        await target.writeAsBytes(file.value, flush: true);
        remap[file.key] = name;
      }
      for (final row in tables['journal_attachments']!) {
        row['filename'] = remap[row['filename']]!;
      }
      // Device permissions and lock enrollment are intentionally not restored from another device.
      tables['planner_settings']!.removeWhere(
        (r) =>
            r['key'] == 'privacy.lock' ||
            r['key'] == 'notifications.enabled' ||
            r['key'] == 'notifications.cleanupNeeded',
      );
      tables['planner_settings']!.add({
        'key': 'notifications.cleanupNeeded',
        'value': 'yes',
      });
      await replaceRows(db, tables);
    } catch (_) {
      for (final file in freshFiles) {
        if (await file.exists()) await file.delete();
      }
      rethrow;
    }
    // Leftover files are harmless if cleanup fails; the restored DB already committed.
    try {
      await media.cleanup();
    } catch (_) {}
  }
}
