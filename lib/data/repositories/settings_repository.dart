import 'package:drift/drift.dart';

import '../database/app_database.dart';

/// Persists foundation preferences without coupling widgets to SQL.
class SettingsRepository {
  SettingsRepository(this.database);

  final AppDatabase database;

  Future<String?> read(String key) async {
    final row = await database.customSelect(
      'SELECT value FROM app_settings WHERE key = ?',
      variables: [Variable.withString(key)],
    ).getSingleOrNull();
    return row?.read<String>('value');
  }

  Future<void> write(String key, String value) async {
    await database.customStatement(
      'INSERT INTO app_settings (key, value, updated_at) VALUES (?, ?, ?) '
      'ON CONFLICT(key) DO UPDATE SET value = excluded.value, '
      'updated_at = excluded.updated_at',
      [key, value, DateTime.now().toUtc().millisecondsSinceEpoch],
    );
  }
}
