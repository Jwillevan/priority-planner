import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/planner_models.dart';
import '../../../shared/widgets/paper_page.dart';
import '../planner_providers.dart';
import 'appointment_editor.dart';
import 'task_editor.dart';

class DailyPlanningPage extends ConsumerStatefulWidget {
  const DailyPlanningPage({super.key, required this.day});
  final DateTime day;
  @override
  ConsumerState<DailyPlanningPage> createState() => _DailyPlanningPageState();
}

class _DailyPlanningPageState extends ConsumerState<DailyPlanningPage> {
  bool _busy = false;
  late final Timer _clock;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _clock = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() { _clock.cancel(); super.dispose(); }

  String _message(Object error) => switch (error) {
    PlannerConflict() => error.message,
    ArgumentError() => error.message?.toString() ?? 'Check the entered information.',
    _ => 'The change could not be saved. Check available storage and try again.',
  };

  Future<void> _run(Future<PlannerUndo?> Function() operation) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final undo = await operation();
      if (mounted && undo != null) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.clearSnackBars();
        messenger.showSnackBar(SnackBar(duration: const Duration(seconds: 10),
          content: Text(undo.label),
          action: SnackBarAction(label: 'Undo', onPressed: () async {
            // Snackbar may survive date navigation; the undo owns its snapshots.
            try {
              await undo.undo();
              if (messenger.mounted) messenger.showSnackBar(const SnackBar(content: Text('Change undone')));
            } catch (error) {
              if (messenger.mounted) messenger.showSnackBar(SnackBar(content: Text(_message(error))));
            }
          }),
        ));
      }
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_message(error))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<PlannerUndo?> _forward(PlannerTaskItem task) async {
    final current = DateTime.parse(task.day);
    final next = DateTime(current.year, current.month, current.day + 1);
    final target = await showDatePicker(context: context,
      initialDate: next.isAfter(DateTime(2200, 12, 31)) ? current : next,
      firstDate: DateTime(1900), lastDate: DateTime(2200, 12, 31),
      helpText: 'Forward unfinished task');
    if (target == null || !mounted) return null;
    return ref.read(plannerRepositoryProvider).moveTask(task, target);
  }

  void _taskAction(String action, PlannerTaskItem task, List<PlannerTaskItem> tasks, int index) {
    final repo = ref.read(plannerRepositoryProvider);
    switch (action) {
      case 'edit':
        _run(() => showTaskEditor(context, widget.day, task: task));
      case 'delegate':
        _run(() => showTaskEditor(context, widget.day, task: task, initialStatus: TaskStatus.delegated));
      case 'forward':
        _run(() => _forward(task));
      case 'start':
        _run(() => repo.setStatus(task, TaskStatus.inProgress));
      case 'cancel':
        _run(() => repo.setStatus(task, TaskStatus.canceled));
      case 'delete':
        _run(() => repo.deleteTask(task));
      case 'up':
        _run(() => repo.reorder(tasks, index, index - 1));
      case 'down':
        _run(() => repo.reorder(tasks, index, index + 2));
    }
  }

  Widget _tasks(List<PlannerTaskItem> tasks) {
    final rankings = taskRankings(tasks);
    final completed = tasks.where((t) => t.status == TaskStatus.completed).length;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$completed of ${tasks.length} tasks completed'),
      if (tasks.isEmpty) const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Text('No tasks planned for this day.')),
      ReorderableListView.builder(
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        buildDefaultDragHandles: false, itemCount: tasks.length,
        onReorder: (oldIndex, newIndex) {
          if (oldIndex == newIndex || oldIndex + 1 == newIndex) return;
          _run(() => ref.read(plannerRepositoryProvider).reorder(tasks, oldIndex, newIndex));
        },
        itemBuilder: (context, index) {
          final task = tasks[index];
          final rank = rankings[task.id]!;
          return Column(key: ValueKey(task.id), children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(padding: const EdgeInsets.only(top: 2), child: Semantics(
                label: 'Complete $rank ${task.title}',
                child: Checkbox(value: task.status == TaskStatus.completed,
                  onChanged: _busy ? null : (checked) => _run(() => ref.read(plannerRepositoryProvider).setStatus(
                    task, checked! ? TaskStatus.completed : TaskStatus.notStarted))),
              )),
              Expanded(child: InkWell(
                onTap: _busy ? null : () => _run(() => showTaskEditor(context, widget.day, task: task)),
                child: Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('$rank  ${task.title}', style: TextStyle(
                      decoration: task.status == TaskStatus.completed || task.status == TaskStatus.canceled
                          ? TextDecoration.lineThrough : null)),
                    Text('${task.status.symbol} ${task.status.label}${task.status == TaskStatus.delegated ? ' · ${task.delegateName}' : ''}',
                      style: Theme.of(context).textTheme.bodySmall),
                    if (task.description.isNotEmpty) Text(task.description, style: Theme.of(context).textTheme.bodySmall),
                    if (task.originalDay != task.day) Text('Originally ${task.originalDay}', style: Theme.of(context).textTheme.bodySmall),
                  ],
                )),
              )),
              PopupMenuButton<String>(enabled: !_busy, tooltip: 'Actions for $rank ${task.title}',
                onSelected: (action) => _taskAction(action, task, tasks, index),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit task')),
                  if (task.isUnfinished) ...[
                    const PopupMenuItem(value: 'forward', child: Text('Forward to another day')),
                    const PopupMenuItem(value: 'delegate', child: Text('Delegate task')),
                    if (task.status != TaskStatus.inProgress) const PopupMenuItem(value: 'start', child: Text('Mark in progress')),
                    const PopupMenuItem(value: 'cancel', child: Text('Cancel task')),
                  ],
                  if (index > 0 && tasks[index - 1].priority == task.priority)
                    const PopupMenuItem(value: 'up', child: Text('Move up within priority')),
                  if (index + 1 < tasks.length && tasks[index + 1].priority == task.priority)
                    const PopupMenuItem(value: 'down', child: Text('Move down within priority')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete task')),
                ]),
              if (!_busy) ReorderableDragStartListener(index: index,
                child: const Tooltip(message: 'Drag within priority; use the actions menu for Move up or Move down',
                  child: SizedBox(width: 48, height: 48, child: Icon(Icons.drag_handle, size: 20)))),
            ]),
            const Divider(height: 1),
          ]);
        },
      ),
    ]);
  }

  String _time(DateTime date) => MaterialLocalizations.of(context).formatTimeOfDay(
    TimeOfDay.fromDateTime(date), alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context));

  Widget _appointment(PlannerAppointmentItem appointment, List<PlannerAppointmentItem> appointments) {
    final overlaps = !appointment.allDay && appointments.any((other) =>
      other.id != appointment.id && !other.allDay && appointment.start.isBefore(other.end) && appointment.end.isAfter(other.start));
    final sameDay = plannerDay(appointment.start) == plannerDay(appointment.end);
    final timeLabel = appointment.allDay ? 'All day' : sameDay
        ? '${_time(appointment.start)} – ${_time(appointment.end)}'
        : '${MaterialLocalizations.of(context).formatCompactDate(appointment.start)} ${_time(appointment.start)} – ${MaterialLocalizations.of(context).formatCompactDate(appointment.end)} ${_time(appointment.end)}';
    return ListTile(contentPadding: EdgeInsets.zero,
      title: Text(appointment.title),
      subtitle: Text('$timeLabel${appointment.description.isEmpty ? '' : '\n${appointment.description}'}${overlaps ? '\nOverlaps another appointment' : ''}'),
      onTap: _busy ? null : () => _run(() => showAppointmentEditor(context, widget.day, appointment: appointment)),
      trailing: PopupMenuButton<String>(enabled: !_busy, tooltip: 'Actions for ${appointment.title}',
        onSelected: (value) => _run(() => value == 'edit'
          ? showAppointmentEditor(context, widget.day, appointment: appointment)
          : ref.read(plannerRepositoryProvider).deleteAppointment(appointment)),
        itemBuilder: (context) => const [
          PopupMenuItem(value: 'edit', child: Text('Edit appointment')),
          PopupMenuItem(value: 'delete', child: Text('Delete appointment')),
        ]),
    );
  }

  Widget _schedule(List<PlannerAppointmentItem> appointments) {
    final timed = appointments.where((a) => !a.allDay).toList();
    final startOfDay = DateTime(widget.day.year, widget.day.month, widget.day.day);
    int anchor(PlannerAppointmentItem a) => a.start.isBefore(startOfDay) ? 0 : a.start.hour;
    // Default paper schedule shows 06:00–22:00, extending when appointments
    // occur outside it. No appointment is hidden by the printed hour range.
    var first = 6;
    var last = 21;
    for (final a in timed) {
      if (anchor(a) < first) first = anchor(a);
      if (anchor(a) > last) last = anchor(a);
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      for (final appointment in appointments.where((a) => a.allDay)) _appointment(appointment, appointments),
      if (plannerDay(_now) == plannerDay(widget.day)) Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text('Now · ${_time(_now)}', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      ),
      for (var hour = first; hour <= last; hour++) ...[
        const Divider(height: 1),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 92, child: TextButton(
            onPressed: _busy ? null : () => _run(() => showAppointmentEditor(context, widget.day, hour: hour)),
            child: Text(_time(DateTime(widget.day.year, widget.day.month, widget.day.day, hour))),
          )),
          Expanded(child: Column(children: [
            for (final appointment in timed.where((a) => anchor(a) == hour)) _appointment(appointment, appointments),
            if (!timed.any((a) => anchor(a) == hour)) const SizedBox(height: 48),
          ])),
        ]),
      ],
      const Divider(height: 1),
      const SizedBox(height: 8),
      const Text('Tap an hour to schedule. Overlapping appointments remain visible.'),
    ]);
  }

  Widget _failure(String label, VoidCallback retry) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('$label could not be loaded. Your data has not been reset.'),
    TextButton.icon(onPressed: retry, icon: const Icon(Icons.refresh), label: const Text('Retry')),
  ]);

  @override
  Widget build(BuildContext context) {
    final key = plannerDay(widget.day);
    final tasks = ref.watch(dailyTasksProvider(key));
    final appointments = ref.watch(dailyAppointmentsProvider(key));
    return PaperPage(child: ListView(
      key: PageStorageKey('planning-scroll-$key'),
      children: [
        Text('Daily Planning', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        Semantics(header: true, child: Text('Prioritized Daily Tasks', style: Theme.of(context).textTheme.titleMedium)),
        const Divider(),
        const Text('A · Vital     B · Important     C · Optional'),
        Align(alignment: Alignment.centerLeft, child: TextButton.icon(
          onPressed: _busy ? null : () => _run(() => showTaskEditor(context, widget.day)),
          icon: const Icon(Icons.add), label: const Text('Add task'))),
        tasks.when(data: _tasks, loading: () => const LinearProgressIndicator(),
          error: (error, stack) => _failure('Tasks', () => ref.invalidate(dailyTasksProvider(key)))),
        const SizedBox(height: 12),
        const Text('○ Not started · ◐ In progress · ✓ Completed\n→ Forwarded · ↗ Delegated · × Canceled'),
        const SizedBox(height: 24),
        Semantics(header: true, child: Text('Appointment Schedule', style: Theme.of(context).textTheme.titleMedium)),
        Align(alignment: Alignment.centerLeft, child: TextButton.icon(
          onPressed: _busy ? null : () => _run(() => showAppointmentEditor(context, widget.day)),
          icon: const Icon(Icons.add), label: const Text('Add appointment'))),
        appointments.when(data: _schedule, loading: () => const LinearProgressIndicator(),
          error: (error, stack) => _failure('Appointments', () => ref.invalidate(dailyAppointmentsProvider(key)))),
      ],
    ));
  }
}
