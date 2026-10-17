import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as zones;
import 'package:timezone/timezone.dart' as tz;

import '../../data/database.dart';

abstract class NotificationPort {
  Future<void> initialize();
  Future<bool> permission();
  Future<void> schedule(int id, DateTime at, String kind, bool daily);
  Future<void> cancel(int id);
  Future<void> cancelAll();
}

class DeviceNotifications implements NotificationPort {
  final plugin = FlutterLocalNotificationsPlugin();
  bool ready = false;
  @override
  Future<void> initialize() async {
    zones.initializeTimeZones();
    final zone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(zone.identifier));
    if (ready) return;
    await plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@drawable/ic_notification'),
      ),
    );
    ready = true;
  }

  @override
  Future<bool> permission() async {
    await initialize();
    return await plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission() ??
        false;
  }

  @override
  Future<void> schedule(int id, DateTime at, String kind, bool daily) =>
      plugin.zonedSchedule(
        id: id,
        title: 'Priority Planner',
        body: kind == 'planning'
            ? 'Time to plan your day.'
            : kind == 'review'
            ? 'Time to review your day.'
            : 'You have a planner reminder.',
        scheduledDate: tz.TZDateTime(
          tz.local,
          at.year,
          at.month,
          at.day,
          at.hour,
          at.minute,
        ),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'planner_reminders',
            'Planner reminders',
            channelDescription: 'Offline planning and appointment reminders',
            importance: Importance.defaultImportance,
            visibility: NotificationVisibility.private,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: daily ? DateTimeComponents.time : null,
      );
  @override
  Future<void> cancel(int id) => plugin.cancel(id: id);
  @override
  Future<void> cancelAll() => plugin.cancelAll();
}

class ReminderService extends ChangeNotifier {
  ReminderService(this.db, this.port, {DateTime Function()? now})
    : now = now ?? DateTime.now;
  final PlannerDatabase db;
  final NotificationPort port;
  final DateTime Function() now;
  StreamSubscription? subscription;
  Timer? timer;
  Future<void> pending = Future.value();
  String status = 'Reminders are off';
  bool disposed = false;
  final scheduled = <int, String>{};
  void start() {
    subscription ??= db
        .customSelect(
          'SELECT COUNT(*) FROM planner_settings',
          readsFrom: {db.plannerSettings, db.plannerTasks, db.appointments},
        )
        .watch()
        .listen((_) {
          timer?.cancel();
          timer = Timer(const Duration(milliseconds: 200), () => sync());
        });
  }

  Future<void> enable(bool value) async {
    if (value) {
      await port.initialize();
      if (!await port.permission()) {
        throw StateError('Notification permission denied');
      }
    } else {
      await port.initialize();
      await port.cancelAll();
      scheduled.clear();
    }
    await db.writeSetting('notifications.enabled', value ? 'yes' : 'no');
    await sync();
  }

  Future<void> add({
    required String kind,
    required DateTime at,
    int? targetId,
    bool daily = false,
    int lead = 10,
  }) async {
    if (!['task', 'appointment', 'planning', 'review'].contains(kind) ||
        (!daily && !at.isAfter(now()))) {
      throw ArgumentError('Choose a future reminder');
    }
    final keys = (await db.select(db.plannerSettings).get())
        .where((s) => s.key.startsWith('reminder.'))
        .map((s) => int.tryParse(s.key.substring(9)) ?? 0);
    final id = keys.fold(0, (a, b) => a > b ? a : b) + 1;
    if (id > 2147483647 || lead < 0 || lead > 1440) {
      throw ArgumentError('Invalid reminder limits');
    }
    await db.writeSetting(
      'reminder.$id',
      jsonEncode({
        'kind': kind,
        'at': at.toIso8601String(),
        'target': targetId,
        'daily': daily,
        'lead': lead,
      }),
    );
    await sync();
  }

  Future<void> remove(String key) async {
    final id = int.parse(key.substring(9));
    await port.initialize();
    await port.cancel(id);
    await db.customStatement('DELETE FROM planner_settings WHERE key = ?', [
      key,
    ]);
    scheduled.remove(id);
    await sync();
  }

  Future<void> refresh() {
    scheduled.clear();
    return sync();
  }

  Future<void> sync() {
    pending = pending.then((_) => _sync()).catchError((Object e) {
      status = 'Reminders could not be updated. Check permission and retry in Settings.';
      if (!disposed) notifyListeners();
    });
    return pending;
  }

  Future<void> _sync() async {
    final settings = await db.select(db.plannerSettings).get();
    if (settings
            .where((s) => s.key == 'notifications.enabled')
            .firstOrNull
            ?.value !=
        'yes') {
      if (scheduled.isNotEmpty ||
          settings.any((s) => s.key == 'notifications.cleanupNeeded')) {
        await port.initialize();
        await port.cancelAll();
        scheduled.clear();
        await db.customStatement('DELETE FROM planner_settings WHERE key = ?', [
          'notifications.cleanupNeeded',
        ]);
      }
      status = 'Reminders are off';
      if (!disposed) notifyListeners();
      return;
    }
    await port.initialize();
    final tasks = await db.select(db.plannerTasks).get();
    final appointments = await db.select(db.appointments).get();
    final active = <int>{};
    var count = 0;
    for (final row in settings.where((s) => s.key.startsWith('reminder.'))) {
      final id = int.parse(row.key.substring(9));
      final data = jsonDecode(row.value) as Map;
      final kind = data['kind'] as String;
      var at = DateTime.parse(data['at'] as String);
      final daily = data['daily'] == true;
      var valid = true;
      if (kind == 'task') {
        final task = tasks.where((t) => t.id == data['target']).firstOrNull;
        valid =
            task != null && !['completed', 'canceled'].contains(task.status);
        if (task != null) {
          final d = DateTime.parse(task.day);
          at = DateTime(d.year, d.month, d.day, at.hour, at.minute);
        }
      }
      if (kind == 'appointment') {
        final appointment = appointments
            .where((a) => a.id == data['target'])
            .firstOrNull;
        valid = appointment != null;
        if (appointment != null) {
          final d = DateTime.parse(appointment.day);
          at = DateTime(
            d.year,
            d.month,
            d.day,
            appointment.startMinute ~/ 60,
            appointment.startMinute % 60,
          ).subtract(Duration(minutes: (data['lead'] as int?) ?? 10));
        }
      }
      if (daily) {
        final today = now();
        at = DateTime(today.year, today.month, today.day, at.hour, at.minute);
        if (!at.isAfter(today)) {
          at = DateTime(
            today.year,
            today.month,
            today.day + 1,
            at.hour,
            at.minute,
          );
        }
      }
      if (!valid || !at.isAfter(now())) {
        await port.cancel(id);
        scheduled.remove(id);
        continue;
      }
      final fingerprint = '$kind|${at.toIso8601String()}|$daily';
      if (scheduled[id] != fingerprint) {
        await port.schedule(id, at, kind, daily);
        scheduled[id] = fingerprint;
      }
      active.add(id);
      count++;
    }
    for (final id in scheduled.keys.toList().where(
      (id) => !active.contains(id),
    )) {
      await port.cancel(id);
      scheduled.remove(id);
    }
    status = '$count reminders scheduled • Android may delay delivery';
    if (!disposed) notifyListeners();
  }

  Future<void> resetAfterRestore() async {
    await port.initialize();
    await port.cancelAll();
    scheduled.clear();
    await sync();
  }

  @override
  void dispose() {
    disposed = true;
    timer?.cancel();
    subscription?.cancel();
    super.dispose();
  }
}

final notificationPortProvider = Provider<NotificationPort>(
  (ref) => DeviceNotifications(),
);
final remindersProvider = Provider<ReminderService>((ref) {
  final service = ReminderService(
    ref.watch(databaseProvider),
    ref.watch(notificationPortProvider),
  );
  ref.onDispose(service.dispose);
  return service;
});
