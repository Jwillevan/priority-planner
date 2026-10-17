import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../data/database.dart';

class AttachmentStore {
  static final _roots = Expando<Future<Directory>>();
  static Future<Directory> _rootFor(PlannerDatabase db) =>
      _roots[db] ??= db.ephemeral
      ? Directory.systemTemp.createTemp('priority-planner-practice-')
      : getApplicationSupportDirectory().then(
          (d) => Directory(p.join(d.path, 'attachments')),
        );
  AttachmentStore(this.db, {Future<Directory>? root})
    : root = root ?? _rootFor(db);
  static Future<void> discardPractice(PlannerDatabase db) async {
    final value = _roots[db];
    if (!db.ephemeral || value == null) return;
    final dir = await value;
    final parent = p.normalize(p.absolute(Directory.systemTemp.path));
    final target = p.normalize(p.absolute(dir.path));
    if (!p.isWithin(parent, target) ||
        !p.basename(target).startsWith('priority-planner-practice-')) {
      throw StateError('Unsafe practice directory');
    }
    if (await dir.exists()) await dir.delete(recursive: true);
    _roots[db] = null;
  }

  final PlannerDatabase db;
  final Future<Directory> root;
  Future<File> file(String name) async {
    if (name != p.basename(name) ||
        !RegExp(r'^[a-zA-Z0-9-]+\.[a-zA-Z0-9]{1,10}$').hasMatch(name)) {
      throw ArgumentError('Unsafe attachment path');
    }
    final dir = await root;
    await dir.create(recursive: true);
    if (await FileSystemEntity.type(dir.path, followLinks: false) ==
        FileSystemEntityType.link) {
      throw ArgumentError('Unsafe storage root');
    }
    final target = File(p.join(dir.path, name));
    if (await FileSystemEntity.type(target.path, followLinks: false) ==
        FileSystemEntityType.link) {
      throw ArgumentError('Unsafe attachment link');
    }
    return target;
  }

  Future<JournalAttachment> importFile({
    required int entryId,
    required File source,
    required String name,
    required String kind,
  }) async {
    if (!['photo', 'document', 'audio'].contains(kind)) {
      throw ArgumentError('Unsupported attachment kind');
    }
    final id = const Uuid().v4();
    var ext = p.extension(name).replaceFirst('.', '').toLowerCase();
    if (!RegExp(r'^[a-z0-9]{1,10}$').hasMatch(ext)) ext = 'bin';
    final target = await file('$id.$ext');
    try {
      await source.copy(target.path);
      final bytes = await target.length();
      if (bytes == 0) throw StateError('Empty attachment');
      final rows = await (db.select(
        db.journalAttachments,
      )..where((a) => a.entryId.equals(entryId))).get();
      final position = rows.fold<int>(
        0,
        (n, a) => a.position >= n ? a.position + 1 : n,
      );
      await db
          .into(db.journalAttachments)
          .insert(
            JournalAttachmentsCompanion.insert(
              id: id,
              entryId: entryId,
              filename: p.basename(target.path),
              displayName: p.basename(name),
              kind: kind,
              bytes: bytes,
              position: position,
              createdAt: DateTime.now(),
            ),
          );
      return (await (db.select(
        db.journalAttachments,
      )..where((a) => a.id.equals(id))).getSingle());
    } catch (_) {
      if (await target.exists()) await target.delete();
      rethrow;
    }
  }

  Future<void> rename(JournalAttachment a, String name, String caption) async {
    if (name.trim().isEmpty) throw ArgumentError('Name required');
    await (db.update(
      db.journalAttachments,
    )..where((r) => r.id.equals(a.id))).write(
      JournalAttachmentsCompanion(
        displayName: Value(name.trim()),
        caption: Value(caption),
      ),
    );
  }

  Future<void> remove(JournalAttachment a) async {
    final target = await file(a.filename);
    await (db.delete(
      db.journalAttachments,
    )..where((r) => r.id.equals(a.id))).go();
    if (await target.exists()) await target.delete();
  }

  Future<void> reorder(List<JournalAttachment> rows, int from, int to) =>
      db.transaction(() async {
        final ordered = [...rows];
        final item = ordered.removeAt(from);
        ordered.insert(to, item);
        for (var i = 0; i < ordered.length; i++) {
          await (db.update(db.journalAttachments)
                ..where((a) => a.id.equals(ordered[i].id)))
              .write(JournalAttachmentsCompanion(position: Value(i)));
        }
      });
  Future<void> cleanup() async {
    final dir = await root;
    if (!await dir.exists()) return;
    final names = (await db.select(db.journalAttachments).get())
        .map((a) => a.filename)
        .toSet();
    await for (final entity in dir.list(followLinks: false)) {
      final name = p.basename(entity.path);
      if (entity is File &&
          !names.contains(name) &&
          RegExp(r'^[a-zA-Z0-9-]+\.[a-zA-Z0-9]{1,10}$').hasMatch(name)) {
        await entity.delete();
      }
    }
  }
}
