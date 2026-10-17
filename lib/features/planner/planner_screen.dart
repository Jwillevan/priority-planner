import '../journal/journal_screen.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../data/database.dart';
import '../help/tutorial_focus.dart';

class PlannerScreen extends ConsumerStatefulWidget {
  const PlannerScreen({this.initialDate, super.key});
  final DateTime? initialDate;
  @override
  ConsumerState<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends ConsumerState<PlannerScreen>
    with SingleTickerProviderStateMixin {
  late DateTime date = DateUtils.dateOnly(widget.initialDate ?? DateTime.now());
  late final TabController tabs;
  late Timer clock;
  @override
  void initState() {
    super.initState();
    tabs = TabController(length: 2, vsync: this);
    clock = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    tabs.dispose();
    clock.cancel();
    super.dispose();
  }

  PlannerDatabase get db => ref.read(databaseProvider);
  String get day => dayKey(date);
  Future<void> safely(Future<void> Function() action) async {
    try {
      await action();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Could not save. Check available storage and try again.',
            ),
          ),
        );
      }
    }
  }

  Future<void> pickDate({bool forward = false, PlannerTask? task}) async {
    final chosen = await showDatePicker(
      context: context,
      initialDate: forward ? date.add(const Duration(days: 1)) : date,
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
    );
    if (chosen == null || !mounted) return;
    if (forward && task != null) {
      if (dayKey(chosen) == task.day) return;
      await safely(
        () => db.setTaskStatus(task.id, 'forwarded', targetDay: dayKey(chosen)),
      );
    } else {
      setState(() => date = chosen);
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            tooltip: 'Previous day',
            onPressed: () => setState(
              () => date = DateTime(date.year, date.month, date.day - 1),
            ),
            icon: const Icon(Icons.chevron_left),
          ),
          Flexible(
            child: TutorialHighlight(
              target: 'date',
              child: TextButton(onPressed: pickDate, child: Text(day)),
            ),
          ),
          IconButton(
            tooltip: 'Next day',
            onPressed: () => setState(
              () => date = DateTime(date.year, date.month, date.day + 1),
            ),
            icon: const Icon(Icons.chevron_right),
          ),
          TextButton(
            onPressed: () =>
                setState(() => date = DateUtils.dateOnly(DateTime.now())),
            child: const Text('Today'),
          ),
        ],
      ),
      Expanded(
        child: LayoutBuilder(
          builder: (context, box) {
            final pages = [
              planning(),
              NotesPage(key: ValueKey(day), db: db, day: day),
            ];
            if (box.maxWidth >= 840) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [for (final p in pages) Expanded(child: p)],
              );
            }
            return DefaultTabController(
              initialIndex: tabs.index,
              length: 2,
              child: Column(
                children: [
                  TutorialHighlight(
                    target: 'pages',
                    child: TabBar(
                      controller: tabs,
                      tabs: const [
                        Tab(text: 'Planning'),
                        Tab(text: 'Notes'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(controller: tabs, children: pages),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ],
  );
  Widget planning() => PaperPage(
    storageKey: 'planning-$day',
    children: [
      Text('Daily planning', style: Theme.of(context).textTheme.headlineMedium),
      const Text('PRIORITIZED DAILY TASK LIST'),
      const Text('A · Vital    B · Important    C · Optional'),
      TutorialHighlight(
        target: 'task',
        child: TextButton.icon(
          onPressed: () => taskEditor(),
          icon: const Icon(Icons.add),
          label: const Text('Add task'),
        ),
      ),
      StreamBuilder<List<PlannerTask>>(
        stream: db.watchTasks(day),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Tasks could not be loaded.');
          }
          if (!snapshot.hasData) return const LinearProgressIndicator();
          final tasks = snapshot.data!;
          final counts = <String, int>{};
          return Column(
            children: [
              Text(
                '${tasks.where((t) => t.status == 'completed').length} of ${tasks.length} tasks completed',
              ),
              if (tasks.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('What matters most today? Add your first task.'),
                ),
              for (var i = 0; i < tasks.length; i++)
                taskRow(
                  tasks[i],
                  '${tasks[i].priority}${counts.update(tasks[i].priority, (v) => v + 1, ifAbsent: () => 1)}',
                  i > 0 && tasks[i - 1].priority == tasks[i].priority
                      ? tasks[i - 1]
                      : null,
                  i + 1 < tasks.length &&
                          tasks[i + 1].priority == tasks[i].priority
                      ? tasks[i + 1]
                      : null,
                ),
            ],
          );
        },
      ),
      const Divider(height: 32),
      Row(
        children: [
          const Expanded(child: Text('APPOINTMENT SCHEDULE')),
          IconButton(
            tooltip: 'Schedule hours',
            onPressed: hoursEditor,
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      TutorialHighlight(
        target: 'appointment',
        child: TextButton.icon(
          onPressed: () => appointmentEditor(),
          icon: const Icon(Icons.add),
          label: const Text('Add appointment'),
        ),
      ),
      StreamBuilder<List<Appointment>>(
        stream: db.watchAppointments(day),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Appointments could not be loaded.');
          }
          if (!snapshot.hasData) return const LinearProgressIndicator();
          final appointments = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final a in appointments)
                Material(
                  type: MaterialType.transparency,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(a.title),
                    subtitle: Text(
                      a.allDay
                          ? 'All day'
                          : '${timeLabel(a.startMinute)} – ${timeLabel(a.endMinute)}',
                    ),
                    onTap: () => appointmentEditor(a),
                  ),
                ),
              StreamBuilder(
                stream: db.select(db.plannerSettings).watch(),
                builder: (context, settings) {
                  final values = {
                    for (final s in settings.data ?? <PlannerSetting>[])
                      s.key: s.value,
                  };
                  final start = int.tryParse(values['startHour'] ?? '') ?? 7;
                  final end = int.tryParse(values['endHour'] ?? '') ?? 20;
                  final now = DateTime.now();
                  return Column(
                    children: [
                      for (var h = start; h < end; h++)
                        Container(
                          constraints: const BoxConstraints(minHeight: 48),
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: rule)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 62,
                                child: Text(timeLabel(h * 60)),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (dayKey(now) == day && now.hour == h)
                                      Text(
                                        '— Now ${timeLabel(now.hour * 60 + now.minute)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    for (final a in appointments.where(
                                      (a) =>
                                          !a.allDay &&
                                          a.startMinute < (h + 1) * 60 &&
                                          a.endMinute > h * 60,
                                    ))
                                      Text(a.title),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
      const SizedBox(height: 24),
      const Text('DAILY REVIEW'),
      TextButton(
        onPressed: () => safely(reviewUnfinished),
        child: const Text('Review unfinished tasks'),
      ),
      const Text(
        'Review unfinished tasks using their status menu. Forward, delegate, cancel, or keep them here. Record what you learned on the Notes page.',
      ),
    ],
  );
  Widget taskRow(
    PlannerTask task,
    String number,
    PlannerTask? previous,
    PlannerTask? next,
  ) => Container(
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: rule)),
    ),
    child: Row(
      children: [
        PopupMenuButton<String>(
          tooltip: 'Task status: ${taskStatuses[task.status]}',
          enabled: task.status != 'forwarded',
          onSelected: (status) async {
            if (status == 'forwarded') {
              await pickDate(forward: true, task: task);
            } else {
              await safely(() => db.setTaskStatus(task.id, status));
            }
          },
          itemBuilder: (_) => [
            for (final status in taskStatuses.entries)
              PopupMenuItem(value: status.key, child: Text(status.value)),
          ],
          child: SizedBox(
            width: 48,
            height: 48,
            child: Center(
              child: Text((taskStatuses[task.status] ?? '○').split(' ').first),
            ),
          ),
        ),
        Text(number),
        Expanded(
          child: TextButton(
            onPressed: () => taskEditor(task),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                task.title,
                style: TextStyle(
                  decoration: ['completed', 'canceled'].contains(task.status)
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
          ),
        ),
        PopupMenuButton<String>(
          tooltip: 'Reorder task',
          onSelected: (direction) async {
            if (direction == 'position') {
              await moveTask(task);
            } else {
              await safely(
                () => db.swapTasks(task, direction == 'up' ? previous! : next!),
              );
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: 'position',
              child: Text('Move to position…'),
            ),
            if (previous != null)
              const PopupMenuItem(value: 'up', child: Text('Move up')),
            if (next != null)
              const PopupMenuItem(value: 'down', child: Text('Move down')),
          ],
        ),
      ],
    ),
  );
  Future<void> moveTask(PlannerTask task) async {
    final group = (await db.watchTasks(task.day).first)
        .where((t) => t.priority == task.priority)
        .toList();
    if (!mounted) return;
    final position = await showDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Move within priority ${task.priority}'),
        children: [
          for (var i = 0; i < group.length; i++)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, i + 1),
              child: Text('${task.priority}${i + 1} — ${group[i].title}'),
            ),
        ],
      ),
    );
    if (position != null) {
      await safely(() => db.moveTaskToPosition(task.id, position));
    }
  }

  Future<void> reviewUnfinished() async {
    final tasks = (await db.watchTasks(day).first)
        .where(
          (t) => !['completed', 'canceled', 'forwarded'].contains(t.status),
        )
        .toList();
    if (!mounted) return;
    final selected = tasks.map((t) => t.id).toSet();
    String action = 'forwarded';
    DateTime destination = DateTime(date.year, date.month, date.day + 1);
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, update) => AlertDialog(
          title: const Text('Review unfinished tasks'),
          content: SizedBox(
            width: 440,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (tasks.isEmpty)
                    const Text('No unfinished tasks on this date.'),
                  for (final t in tasks)
                    CheckboxListTile(
                      title: Text('${t.priority} • ${t.title}'),
                      value: selected.contains(t.id),
                      onChanged: (v) => update(() {
                        if (v == true) {
                          selected.add(t.id);
                        } else {
                          selected.remove(t.id);
                        }
                      }),
                    ),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: action,
                    items: const [
                      DropdownMenuItem(
                        value: 'forwarded',
                        child: Text('Carry forward'),
                      ),
                      DropdownMenuItem(
                        value: 'keep',
                        child: Text('Keep on original date'),
                      ),
                      DropdownMenuItem(
                        value: 'completed',
                        child: Text('Mark completed'),
                      ),
                      DropdownMenuItem(
                        value: 'canceled',
                        child: Text('Cancel'),
                      ),
                      DropdownMenuItem(
                        value: 'delegated',
                        child: Text('Delegate'),
                      ),
                    ],
                    onChanged: (v) => update(() => action = v!),
                  ),
                  if (action == 'forwarded')
                    TextButton(
                      onPressed: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: destination,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2200),
                        );
                        if (d != null) update(() => destination = d);
                      },
                      child: Text('Destination: ${dayKey(destination)}'),
                    ),
                  const Text(
                    'Carry-forward leaves a forwarded record here and an open task on the selected day.',
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
            ),
            TextButton(
              onPressed: selected.isEmpty
                  ? null
                  : () => Navigator.pop(context, true),
              child: Text('Apply to ${selected.length} tasks'),
            ),
          ],
        ),
      ),
    );
    if (yes == true) {
      await db.reviewTasks(
        selected,
        action,
        targetDay: action == 'forwarded' ? dayKey(destination) : null,
      );
    }
  }

  Future<void> taskEditor([PlannerTask? task]) async {
    final availableGoals = await db.select(db.goals).get();
    final existingLinks = await db.select(db.taskGoalLinks).get();
    int? goalId = existingLinks
        .where((l) => l.taskId == task?.id)
        .firstOrNull
        ?.goalId;
    if (!mounted) return;
    final title = TextEditingController(text: task?.title);
    final details = TextEditingController(text: task?.details);
    final delegatedTo = TextEditingController(text: task?.delegatedTo);
    var priority = task?.priority ?? 'A';
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, update) => AlertDialog(
          title: Text(task == null ? 'Add task' : 'Edit task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: title,
                  decoration: const InputDecoration(
                    labelText: 'Task description',
                  ),
                  autofocus: true,
                ),
                TextField(
                  controller: details,
                  decoration: const InputDecoration(labelText: 'Details'),
                  maxLines: 3,
                ),
                DropdownButton<String>(
                  value: priority,
                  items: [
                    for (final p in ['A', 'B', 'C'])
                      DropdownMenuItem(value: p, child: Text('Priority $p')),
                  ],
                  onChanged: (v) => update(() => priority = v!),
                ),
                TextField(
                  controller: delegatedTo,
                  decoration: const InputDecoration(
                    labelText: 'Delegated to (first name)',
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                DropdownButton<int?>(
                  isExpanded: true,
                  value: goalId,
                  hint: const Text('Link to a goal (optional)'),
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('No goal'),
                    ),
                    for (final g in availableGoals)
                      DropdownMenuItem<int?>(
                        value: g.id,
                        child: Text(g.title, overflow: TextOverflow.ellipsis),
                      ),
                  ],
                  onChanged: (v) => update(() => goalId = v),
                ),
                if (task != null)
                  StreamBuilder<List<TaskHistory>>(
                    stream: db.watchHistory(task.id),
                    builder: (context, snapshot) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Created ${dayKey(task.createdAt)}'),
                        for (final h in snapshot.data ?? <TaskHistory>[])
                          Text(
                            '${h.fromDay} → ${h.toDay}: ${taskStatuses[h.toStatus]}',
                          ),
                      ],
                    ),
                  ),
                if (task != null)
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel task (keep history)'),
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
              onPressed: () {
                if (title.text.trim().isNotEmpty) Navigator.pop(context, true);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    if (saved == true) {
      await safely(
        () => db.transaction(() async {
          final savedId = await db.saveTask(
            id: task?.id,
            day: day,
            title: title.text,
            details: details.text,
            delegatedTo: delegatedTo.text,
            priority: priority,
          );
          await db.linkTaskGoal(savedId, goalId);
        }),
      );
    }
    if (saved == false && task != null) {
      await safely(() => db.setTaskStatus(task.id, 'canceled'));
    }
    // Controllers outlive the closing dialog animation.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    title.dispose();
    details.dispose();
    delegatedTo.dispose();
  }

  Future<void> appointmentEditor([Appointment? appointment]) async {
    final title = TextEditingController(text: appointment?.title);
    var start = appointment?.startMinute ?? 9 * 60,
        end = appointment?.endMinute ?? 10 * 60;
    var allDay = appointment?.allDay ?? false;
    String? error;
    final result = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, update) => AlertDialog(
          title: Text(
            appointment == null ? 'Add appointment' : 'Edit appointment',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: title,
                  decoration: const InputDecoration(
                    labelText: 'Appointment title',
                  ),
                ),
                SwitchListTile(
                  title: const Text('All day'),
                  value: allDay,
                  onChanged: (v) => update(() => allDay = v),
                ),
                if (!allDay)
                  for (final isStart in [true, false])
                    TextButton(
                      onPressed: () async {
                        final value = isStart ? start : end;
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                            hour: value ~/ 60,
                            minute: value % 60,
                          ),
                        );
                        if (time != null) {
                          update(() {
                            if (isStart) {
                              start = time.hour * 60 + time.minute;
                            } else {
                              end = time.hour * 60 + time.minute;
                            }
                          });
                        }
                      },
                      child: Text(
                        '${isStart ? 'Start' : 'End'}: ${timeLabel(isStart ? start : end)}',
                      ),
                    ),
                if (error != null)
                  Text(error!, style: const TextStyle(color: Colors.red)),
              ],
            ),
          ),
          actions: [
            if (appointment != null)
              TextButton(
                onPressed: () => Navigator.pop(context, 'delete'),
                child: const Text('Delete'),
              ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
            ),
            TextButton(
              onPressed: () {
                if (title.text.trim().isEmpty || (!allDay && start >= end)) {
                  update(
                    () => error =
                        'Enter a title and an end time after the start.',
                  );
                } else {
                  Navigator.pop(context, 'save');
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    if (result == 'save') {
      await safely(
        () => db.saveAppointment(
          id: appointment?.id,
          day: day,
          title: title.text,
          start: allDay ? 0 : start,
          end: allDay ? 1440 : end,
          allDay: allDay,
        ),
      );
    }
    if (result == 'delete' && appointment != null) {
      await safely(() => db.deleteAppointment(appointment.id));
    }
    await Future<void>.delayed(const Duration(milliseconds: 300));
    title.dispose();
  }

  Future<void> hoursEditor() async {
    final rows = await db.select(db.plannerSettings).get();
    var start =
        int.tryParse(
          rows.where((s) => s.key == 'startHour').firstOrNull?.value ?? '',
        ) ??
        7;
    var end =
        int.tryParse(
          rows.where((s) => s.key == 'endHour').firstOrNull?.value ?? '',
        ) ??
        20;
    if (!mounted) return;
    final save = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, update) => AlertDialog(
          title: const Text('Schedule hours'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<int>(
                value: start,
                items: [
                  for (var h = 0; h < 24; h++)
                    DropdownMenuItem(
                      value: h,
                      child: Text('Start ${timeLabel(h * 60)}'),
                    ),
                ],
                onChanged: (v) => update(() {
                  start = v!;
                  if (end <= start) end = start + 1;
                }),
              ),
              DropdownButton<int>(
                value: end,
                items: [
                  for (var h = start + 1; h <= 24; h++)
                    DropdownMenuItem(
                      value: h,
                      child: Text('End ${timeLabel(h * 60)}'),
                    ),
                ],
                onChanged: (v) => update(() => end = v!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    if (save == true) await safely(() => db.saveHours(start, end));
  }
}

String timeLabel(int minute) =>
    '${(minute ~/ 60).toString().padLeft(2, '0')}:${(minute % 60).toString().padLeft(2, '0')}';

class NotesPage extends StatefulWidget {
  const NotesPage({required this.db, required this.day, super.key});
  final PlannerDatabase db;
  final String day;
  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final controller = TextEditingController();
  bool loaded = false, saving = false, dirty = false;
  String message = '';
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final row = await widget.db.watchNote(widget.day).first;
      if (mounted) {
        setState(() {
          controller.text = row?.content ?? '';
          loaded = true;
        });
      }
    } catch (_) {
      if (mounted) setState(() => message = 'Notes could not be loaded.');
    }
  }

  Future<void> pending = Future<void>.value();
  Future<void> save() {
    final content = controller.text;
    final db = widget.db;
    final day = widget.day;
    pending = pending.then((_) async {
      try {
        await db.saveNote(day, content);
        if (mounted && controller.text == content) {
          setState(() {
            dirty = false;
            message = 'Saved on this device';
          });
        }
      } catch (_) {
        if (mounted) {
          setState(
            () => message =
                'Save failed. Keep this page open and retry Save notes.',
          );
        }
      }
    });
    return pending;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PaperPage(
    storageKey: 'notes-${widget.day}',
    children: [
      Text('Daily record', style: Theme.of(context).textTheme.headlineMedium),
      const Text('NOTES & JOURNAL'),
      const Text('Quick daily notes • journal entries are listed below'),
      if (loaded)
        TextField(
          controller: controller,
          minLines: 12,
          maxLines: null,
          decoration: const InputDecoration(
            labelText: 'Daily notes',
            alignLabelWithHint: true,
          ),
          onChanged: (_) {
            setState(() {
              dirty = true;
              message = 'Saving…';
            });
            save();
          },
        ),
      TextButton.icon(
        onPressed: !loaded || saving || !dirty
            ? null
            : () async {
                setState(() => saving = true);
                await save();
                if (mounted) setState(() => saving = false);
              },
        icon: const Icon(Icons.save_outlined),
        label: Text(saving ? 'Saving…' : 'Save notes'),
      ),
      Text(message, semanticsLabel: message),
      const Divider(),
      TextButton.icon(
        onPressed: () => openJournalEditor(context, widget.db, day: widget.day),
        icon: const Icon(Icons.menu_book_outlined),
        label: const Text('New journal entry for this day'),
      ),
      StreamBuilder<List<JournalEntry>>(
        stream: widget.db.watchJournal(fromDay: widget.day, toDay: widget.day),
        builder: (context, snapshot) => Column(
          children: [
            if (snapshot.hasError)
              const Text('Journal entries could not be loaded.'),
            for (final entry in snapshot.data ?? <JournalEntry>[])
              Material(
                type: MaterialType.transparency,
                child: ListTile(
                  title: Text(entry.title),
                  onTap: () =>
                      openJournalEditor(context, widget.db, entry: entry),
                ),
              ),
          ],
        ),
      ),
    ],
  );
}

class PaperPage extends StatelessWidget {
  const PaperPage({
    required this.children,
    required this.storageKey,
    super.key,
  });
  final List<Widget> children;
  final String storageKey;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.all(10),
    decoration: const BoxDecoration(
      color: paper,
      boxShadow: [
        BoxShadow(
          color: Color(0x22000000),
          blurRadius: 8,
          offset: Offset(1, 3),
        ),
      ],
    ),
    child: Material(
      type: MaterialType.transparency,
      child: CustomPaint(
        painter: Rules(),
        child: ListView(
          key: PageStorageKey(storageKey),
          padding: const EdgeInsets.all(20),
          children: children,
        ),
      ),
    ),
  );
}

class Rules extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = rule.withValues(alpha: .45)
      ..strokeWidth = .6;
    for (double y = 120; y < size.height; y += 32) {
      canvas.drawLine(Offset(20, y), Offset(size.width - 20, y), paint);
    }
  }

  @override
  bool shouldRepaint(Rules oldDelegate) => false;
}
