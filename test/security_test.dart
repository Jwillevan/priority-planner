import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priority_planner/data/database.dart';
import 'package:priority_planner/features/security/app_lock.dart';
import 'package:priority_planner/features/security/reminders.dart';

class FakeAuth implements AuthPort {
  bool accepted = true;
  bool fail = false;
  int calls = 0;
  @override
  Future<bool> authenticate() async {
    calls++;
    if (fail) throw StateError('Unavailable');
    return accepted;
  }
}

class FakeNotifications implements NotificationPort {
  bool allowed = true;
  int requests = 0;
  final events = <int, (DateTime, String, bool)>{};
  final canceled = <int>[];
  @override
  Future<void> initialize() async {}
  @override
  Future<bool> permission() async {
    requests++;
    return allowed;
  }

  @override
  Future<void> schedule(int id, DateTime at, String kind, bool daily) async {
    events[id] = (at, kind, daily);
  }

  @override
  Future<void> cancel(int id) async {
    events.remove(id);
    canceled.add(id);
  }

  @override
  Future<void> cancelAll() async {
    events.clear();
  }
}

void main() {
  test('app lock requires authentication to enable/disable and stays locked on denial/errors', () async {
    final db = PlannerDatabase.forTesting(NativeDatabase.memory());
    final auth = FakeAuth();
    final lock = LockController(db, auth);
    lock.start();
    await db.select(db.plannerSettings).get();
    await Future<void>.delayed(Duration.zero);
    expect(lock.enabled, isFalse);
    await lock.setEnabled(true);
    expect(await db.readSetting('privacy.lock'), 'yes');
    lock.lock();
    expect(lock.locked, isTrue);
    auth.accepted = false;
    await lock.unlock();
    expect(lock.locked, isTrue);
    await lock.setEnabled(false);
    expect(lock.enabled, isTrue);
    auth.fail = true;
    await lock.unlock();
    expect(lock.locked, isTrue);
    expect(lock.error, isNotNull);
    auth.fail = false;
    auth.accepted = true;
    await lock.unlock();
    expect(lock.locked, isFalse);
    await lock.setEnabled(false);
    expect(lock.enabled, isFalse);
    lock.dispose();
    await db.close();
  });
  test('reminders respect permission, edits, forwarding, completion, deletion and off switch', () async {
    final db = PlannerDatabase.forTesting(NativeDatabase.memory());
    final port = FakeNotifications();
    final service = ReminderService(
      db,
      port,
      now: () => DateTime(2026, 10, 16, 8),
    );
    try {
      port.allowed = false;
      await expectLater(service.enable(true), throwsStateError);
      expect(await db.readSetting('notifications.enabled'), isNull);
      port.allowed = true;
      await service.enable(true);
      final task = await db.saveTask(
        day: '2026-10-17',
        title: 'Task',
        details: '',
        priority: 'A',
      );
      await service.add(
        kind: 'task',
        at: DateTime(2026, 10, 17, 9),
        targetId: task,
      );
      expect(port.events[1]!.$1, DateTime(2026, 10, 17, 9));
      await db.setTaskStatus(task, 'forwarded', targetDay: '2026-10-18');
      await service.sync();
      expect(port.events[1]!.$1, DateTime(2026, 10, 18, 9));
      await db.setTaskStatus(task, 'completed');
      await service.sync();
      expect(port.events, isEmpty);
      await db.saveAppointment(
        day: '2026-10-17',
        title: 'Appointment',
        start: 600,
        end: 660,
        allDay: false,
      );
      final appt = (await db.watchAppointments('2026-10-17').first).single;
      await service.add(
        kind: 'appointment',
        at: DateTime(2026, 10, 17, 9, 50),
        targetId: appt.id,
      );
      expect(port.events[2]!.$1, DateTime(2026, 10, 17, 9, 50));
      await db.saveAppointment(
        id: appt.id,
        day: '2026-10-18',
        title: 'Changed',
        start: 660,
        end: 720,
        allDay: false,
      );
      await service.sync();
      expect(port.events[2]!.$1, DateTime(2026, 10, 18, 10, 50));
      await db.deleteAppointment(appt.id);
      await service.sync();
      expect(port.events, isEmpty);
      await service.add(
        kind: 'planning',
        at: DateTime(2026, 10, 17, 7),
        daily: true,
      );
      expect(port.events[3]!.$1, DateTime(2026, 10, 17, 7));
      expect(port.events[3]!.$3, isTrue);
      await service.enable(false);
      expect(port.events, isEmpty);
      expect(service.status, 'Reminders are off');
    } finally {
      service.dispose();
      await db.close();
    }
  });
}
