import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../media/attachment_store.dart';
import 'backup_service.dart';
import 'app_lock.dart';
import 'reminders.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool busy = false;
  String message = '';
  PlannerDatabase get db => ref.read(databaseProvider);
  Future<void> action(Future<void> Function() run) async {
    setState(() {
      busy = true;
      message = '';
    });
    try {
      await run();
    } catch (_) {
      if (mounted) {
        setState(
          () => message = 'Action failed. Check password, backup validity, permissions and available storage. Your current planner is kept if validation fails.',
        );
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<String?> password({required bool confirm}) async {
    final first = TextEditingController(), second = TextEditingController();
    String? error;
    final value = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, update) => AlertDialog(
          title: Text(confirm ? 'Encrypt backup' : 'Open encrypted backup'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Keep this password safely. There is no password recovery.',
              ),
              TextField(
                controller: first,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Backup password'),
              ),
              if (confirm)
                TextField(
                  controller: second,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm password',
                  ),
                ),
              if (error != null) Text(error!),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
            ),
            TextButton(
              onPressed: () {
                if (first.text.length < 8 ||
                    (confirm && first.text != second.text)) {
                  update(
                    () => error =
                        'Use at least 8 characters and matching passwords.',
                  );
                } else {
                  Navigator.pop(context, first.text);
                }
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 300));
    first.dispose();
    second.dispose();
    return value;
  }

  Future<void> backup() async {
    final secret = await password(confirm: true);
    if (secret == null) return;
    final service = BackupService(db, AttachmentStore(db));
    final bytes = await service.create(secret);
    final result = await FilePicker.saveFile(
      fileName: 'priority-planner-${dayKey(DateTime.now())}.ppbackup',
      bytes: Uint8List.fromList(bytes),
    );
    if (mounted) {
      setState(
        () => message = result == null
            ? 'Export canceled.'
            : 'Encrypted backup exported. Store a copy away from this device.',
      );
    }
  }

  Future<void> restore() async {
    final files = await FilePicker.pickFiles();
    if (files.isEmpty) return;
    final path = files.first.path;
    if (path == null) throw StateError('Backup unavailable');
    final file = File(path);
    if (await file.length() > BackupService.maxBytes) {
      throw StateError('Backup exceeds 128 MiB');
    }
    if (!mounted) return;
    final secret = await password(confirm: false);
    if (secret == null) return;
    final service = BackupService(db, AttachmentStore(db));
    final reviewed = await service.validate(await file.readAsBytes(), secret);
    if (!mounted) return;
    final replace = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Replace current planner?'),
        content: SingleChildScrollView(
          child: Text(
            'Validated backup from ${reviewed.created}\n${reviewed.records} records and ${reviewed.files.length} files.\n\nThis replaces all current planner information. Export a backup first if you need it. Device app lock and notifications will be switched off; re-enable them after restoring.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep current planner'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Replace with backup'),
          ),
        ],
      ),
    );
    if (replace != true) return;
    await service.restore(reviewed);
    try {
      await ref.read(remindersProvider).resetAfterRestore();
    } catch (_) {}
    if (mounted) {
      setState(
        () => message = 'Backup restored. Review your records, then re-enable device lock and reminders if desired.',
      );
    }
  }

  Future<void> addReminder() async {
    final tasks = await db.select(db.plannerTasks).get();
    final appointments = await db.select(db.appointments).get();
    if (!mounted) return;
    String kind = 'planning';
    int? target;
    var time = const TimeOfDay(hour: 8, minute: 0);
    var day = DateTime.now().add(const Duration(days: 1));
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, update) => AlertDialog(
          title: const Text('Add local reminder'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(
                  isExpanded: true,
                  value: kind,
                  items: const [
                    DropdownMenuItem(
                      value: 'planning',
                      child: Text('Daily planning'),
                    ),
                    DropdownMenuItem(
                      value: 'review',
                      child: Text('Daily review'),
                    ),
                    DropdownMenuItem(
                      value: 'task',
                      child: Text('Scheduled task'),
                    ),
                    DropdownMenuItem(
                      value: 'appointment',
                      child: Text('Appointment'),
                    ),
                  ],
                  onChanged: (v) => update(() {
                    kind = v!;
                    target = null;
                  }),
                ),
                if (kind == 'task')
                  DropdownButton<int>(
                    isExpanded: true,
                    value: target,
                    hint: const Text('Choose task'),
                    items: [
                      for (final t in tasks.where(
                        (t) => !['completed', 'canceled'].contains(t.status),
                      ))
                        DropdownMenuItem(
                          value: t.id,
                          child: Text(
                            '${t.day} • ${t.title}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (v) => update(() => target = v),
                  ),
                if (kind == 'appointment')
                  DropdownButton<int>(
                    isExpanded: true,
                    value: target,
                    hint: const Text('Choose appointment'),
                    items: [
                      for (final a in appointments)
                        DropdownMenuItem(
                          value: a.id,
                          child: Text(
                            '${a.day} • ${a.title}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (v) => update(() => target = v),
                  ),
                if (kind == 'appointment')
                  const Text(
                    'Reminder: 10 minutes before the appointment. It follows appointment edits.',
                  ),
                if (kind != 'appointment')
                  TextButton(
                    onPressed: () async {
                      final chosen = await showTimePicker(
                        context: context,
                        initialTime: time,
                      );
                      if (chosen != null) update(() => time = chosen);
                    },
                    child: Text('Time ${time.format(context)}'),
                  ),
                const Text(
                  'Task reminders follow the task date. Planning/review repeat daily. Android may delay delivery; reminders are not exact alarms.',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
            ),
            TextButton(
              onPressed:
                  (['task', 'appointment'].contains(kind) && target == null)
                  ? null
                  : () => Navigator.pop(context, true),
              child: const Text('Save reminder'),
            ),
          ],
        ),
      ),
    );
    if (yes != true) return;
    if (kind == 'task') {
      day = DateTime.parse(tasks.firstWhere((t) => t.id == target).day);
    }
    if (kind == 'appointment') {
      final a = appointments.firstWhere((a) => a.id == target);
      final d = DateTime.parse(a.day);
      day = DateTime(
        d.year,
        d.month,
        d.day,
        a.startMinute ~/ 60,
        a.startMinute % 60,
      ).subtract(const Duration(minutes: 10));
    }
    final at = kind == 'appointment'
        ? day
        : DateTime(day.year, day.month, day.day, time.hour, time.minute);
    await ref
        .read(remindersProvider)
        .add(
          kind: kind,
          at: at,
          targetId: target,
          daily: ['planning', 'review'].contains(kind),
        );
  }

  @override
  Widget build(BuildContext context) {
    final lock = ref.watch(lockProvider),
        reminders = ref.watch(remindersProvider);
    return AbsorbPointer(
      absorbing: busy,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Privacy & reliability',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Text(
            'Your planner is stored locally, with no account or analytics. The database and working media are not encrypted. App lock protects access through this app; exported backups use password encryption.',
          ),
          if (busy) const LinearProgressIndicator(),
          if (message.isNotEmpty) Text(message),
          const Divider(),
          const Text('APP LOCK'),
          AnimatedBuilder(
            animation: lock,
            builder: (context, _) => Column(
              children: [
                SwitchListTile(
                  title: const Text('Require device authentication'),
                  subtitle: const Text(
                    'Uses available biometrics or device PIN. Locks when the app leaves the foreground.',
                  ),
                  value: lock.enabled,
                  onChanged: lock.authenticating
                      ? null
                      : (v) => action(() => lock.setEnabled(v)),
                ),
                if (lock.error != null) Text(lock.error!),
                TextButton(
                  onPressed: lock.enabled ? lock.lock : null,
                  child: const Text('Lock now'),
                ),
              ],
            ),
          ),
          const Divider(),
          const Text('ENCRYPTED BACKUP & RESTORE'),
          const Text(
            'Complete backups include planner records, settings and media. Current format supports up to 64 MiB of media and 128 MiB per encrypted backup. Missing or changed files stop export. Restore validates before replacement.',
          ),
          TextButton.icon(
            onPressed: () => action(backup),
            icon: const Icon(Icons.file_upload_outlined),
            label: const Text('Export encrypted backup'),
          ),
          TextButton.icon(
            onPressed: () => action(restore),
            icon: const Icon(Icons.restore),
            label: const Text('Validate and restore backup'),
          ),
          const Divider(),
          const Text('LOCAL REMINDERS'),
          StreamBuilder(
            stream: db.select(db.plannerSettings).watch(),
            builder: (context, s) {
              final rows = s.data ?? <PlannerSetting>[];
              final enabled =
                  rows
                      .where((r) => r.key == 'notifications.enabled')
                      .firstOrNull
                      ?.value ==
                  'yes';
              return Column(
                children: [
                  SwitchListTile(
                    title: const Text('Enable local notifications'),
                    value: enabled,
                    onChanged: (v) => action(() => reminders.enable(v)),
                  ),
                  for (final row in rows.where(
                    (r) => r.key.startsWith('reminder.'),
                  ))
                    ListTile(
                      title: Text(
                        (jsonDecode(row.value) as Map)['kind'].toString(),
                      ),
                      subtitle: Text(
                        (jsonDecode(row.value) as Map)['at'].toString(),
                      ),
                      trailing: IconButton(
                        tooltip: 'Remove reminder',
                        onPressed: () =>
                            action(() => reminders.remove(row.key)),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ),
                ],
              );
            },
          ),
          TextButton(
            onPressed: () => action(addReminder),
            child: const Text('Add reminder'),
          ),
          TextButton(
            onPressed: () => action(reminders.refresh),
            child: const Text('Refresh reminder schedules'),
          ),
          AnimatedBuilder(
            animation: reminders,
            builder: (context, _) => Text(reminders.status),
          ),
          const Divider(),
          TextButton(
            onPressed: () => action(() async {
              await AttachmentStore(db).cleanup();
              if (mounted) {
                setState(() => message = 'Unused attachment files cleaned up.');
              }
            }),
            child: const Text('Clean unused attachment files'),
          ),
        ],
      ),
    );
  }
}
