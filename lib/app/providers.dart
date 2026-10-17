import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart';
import '../data/repositories/settings_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase.open();
  ref.onDispose(() => unawaited(database.close()));
  return database;
});

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(databaseProvider)),
);

final databaseReadyProvider = FutureProvider<void>(
  (ref) => ref.watch(databaseProvider).verifyReady(),
);

final themeModeProvider = AsyncNotifierProvider<ThemePreference, ThemeMode>(
  ThemePreference.new,
);

class ThemePreference extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() async {
    final preference = await ref.read(settingsRepositoryProvider).read('theme');
    return switch (preference) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setMode(ThemeMode mode) async {
    // Update the UI only after durable storage succeeds.
    await ref.read(settingsRepositoryProvider).write('theme', mode.name);
    state = AsyncData(mode);
  }
}

final selectedDayProvider = NotifierProvider<SelectedDay, DateTime>(SelectedDay.new);

class SelectedDay extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void select(DateTime day) => state = DateTime(day.year, day.month, day.day);

  void move(int days) {
    // Calendar construction handles local daylight-saving transitions.
    state = DateTime(state.year, state.month, state.day + days);
  }
}
