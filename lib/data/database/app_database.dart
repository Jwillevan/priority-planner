import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// One connection per app. All SQL entities are declared in schema.drift.
/// Generated sources are produced by build_runner, never hand-written.
@DriftDatabase(include: {'schema.drift'})
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  factory AppDatabase.open() => AppDatabase(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        // There is no released predecessor to v1. Never reset unknown schemas.
        // New releases must add explicit upgrades and snapshot migration tests.
        onUpgrade: (m, from, to) async {
          throw StateError('No safe migration from schema $from to $to.');
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
          await customStatement('PRAGMA busy_timeout = 5000');
          final violations = await customSelect('PRAGMA foreign_key_check').get();
          if (violations.isNotEmpty) {
            throw StateError('Database integrity check failed. Data was preserved.');
          }
        },
      );

  /// Forces lazy opening so startup can show recoverable storage errors.
  Future<void> verifyReady() async {
    await customSelect('SELECT 1').getSingle();
  }
}

LazyDatabase _openConnection() => LazyDatabase(() async {
      final support = await getApplicationSupportDirectory();
      final directory = Directory(p.join(support.path, 'priority_planner'));
      await directory.create(recursive: true);
      // Binary media will use a sibling media/ directory. Backups must include
      // both; path handling belongs to the future managed-media service.
      return NativeDatabase.createInBackground(
        File(p.join(directory.path, 'planner.sqlite')),
      );
    });
