import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/database.dart';
import '../planner/planner_screen.dart';
import 'recurrence.dart';
import 'planning_helpers.dart';

class PlanningScreen extends ConsumerStatefulWidget {
  const PlanningScreen({
    this.onOpenDay,
    this.onGoals,
    this.initialWeekly = false,
    super.key,
  });
  final ValueChanged<DateTime>? onOpenDay;
  final VoidCallback? onGoals;
  final bool initialWeekly;
  @override
  ConsumerState<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends ConsumerState<PlanningScreen> {
  DateTime date = calendarDay(DateTime.now());
  late bool weekly = widget.initialWeekly;
  void openDay(DateTime day) {
    if (widget.onOpenDay != null) {
      widget.onOpenDay!(day);
    } else {
      context.go('/?date=${dayKey(day)}');
    }
  }

  PlannerDatabase get db => ref.read(databaseProvider);
  DateTime get start =>
      weekly ? weekStart(date) : DateTime(date.year, date.month);
  DateTime get end => weekly
      ? DateTime(start.year, start.month, start.day + 6)
      : DateTime(date.year, date.month + 1, 0);
  String get periodKey => '${weekly ? 'week' : 'month'}:${dayKey(start)}';
  Future<void> move(int amount) async {
    setState(
      () => date = weekly
          ? DateTime(date.year, date.month, date.day + amount * 7)
          : DateTime(date.year, date.month + amount),
    );
  }

  Future<void> masterTask() async {
    final goals = await db.select(db.goals).get();
    if (!mounted) return;
    final v = await editPlanningText(
      context,
      'Master task',
      ['Task title'],
      [''],
      choices: {for (final g in goals) g.id: g.title},
    );
    if (v != null) {
      await db.addMasterTask(
        periodKey,
        v[0],
        v[1].trim().isEmpty ? null : int.parse(v[1].trim()),
      );
    }
  }

  Future<void> recurrence() async {
    final v = await editPlanningText(
      context,
      'New recurring item',
      [
        'Title',
        'Kind: task or appointment',
        'Repeat: daily, weekly or monthly',
        'First date YYYY-MM-DD',
        'Task priority A, B or C',
        'Appointment start HH:mm',
        'Appointment end HH:mm',
      ],
      ['', 'task', 'weekly', dayKey(date), 'B', '09:00', '10:00'],
    );
    if (v != null) {
      await db.addRecurrence(
        title: v[0],
        kind: v[1].trim(),
        frequency: v[2].trim(),
        anchorDay: v[3].trim(),
        priority: v[4].trim(),
        start: planningTime(v[5]),
        end: planningTime(v[6]),
      );
    }
  }

  Future<void> generate(RecurrenceRule rule) async {
    final dates = await db.recurrencePreview(rule, dayKey(start), dayKey(end));
    if (!mounted) return;
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create ${dates.length} occurrences?'),
        content: SingleChildScrollView(
          child: Text(
            '${rule.title}\n${dates.join('\n')}\nOnly these new dates will be created. Existing, forwarded or deleted occurrences are not duplicated.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back'),
          ),
          TextButton(
            onPressed: dates.isEmpty
                ? null
                : () => Navigator.pop(context, true),
            child: const Text('Create occurrences'),
          ),
        ],
      ),
    );
    if (yes == true) {
      await db.generateRecurrence(rule.id, dayKey(start), dayKey(end));
    }
  }

  @override
  Widget build(BuildContext context) => PaperPage(
    storageKey: 'planning-$periodKey',
    children: [
      Text(
        weekly ? 'Weekly planning' : 'Monthly planning',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      Wrap(
        alignment: WrapAlignment.center,
        children: [
          TextButton(
            onPressed: () => setState(() => weekly = false),
            child: const Text('Month'),
          ),
          TextButton(
            onPressed: () => setState(() => weekly = true),
            child: const Text('Week'),
          ),
          IconButton(
            tooltip: 'Previous period',
            onPressed: () => move(-1),
            icon: const Icon(Icons.chevron_left),
          ),
          TextButton(
            onPressed: () async {
              final chosen = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: DateTime(1900),
                lastDate: DateTime(2200),
              );
              if (chosen != null && mounted) setState(() => date = chosen);
            },
            child: Text('${dayKey(start)} – ${dayKey(end)}'),
          ),
          IconButton(
            tooltip: 'Next period',
            onPressed: () => move(1),
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
      const Text(
        'Select a date to open its daily pages. Monday starts the week.',
      ),
      if (!weekly)
        Row(
          children: [
            for (final d in ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'])
              Expanded(child: Center(child: Text(d))),
          ],
        ),
      if (!weekly)
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.2,
          children: [
            for (var i = 1; i < start.weekday; i++) const SizedBox(),
            for (var d = 1; d <= end.day; d++)
              TextButton(
                onPressed: () => openDay(DateTime(date.year, date.month, d)),
                child: Text('$d'),
              ),
          ],
        ),
      if (weekly)
        Wrap(
          children: [
            for (
              var d = start;
              !d.isAfter(end);
              d = DateTime(d.year, d.month, d.day + 1)
            )
              TextButton(
                onPressed: () {
                  openDay(d);
                },
                child: Text(dayKey(d)),
              ),
          ],
        ),
      const Divider(),
      const Text('PRIORITIES, GOALS & REVIEW'),
      StreamBuilder(
        stream: db.select(db.periodPlans).watch(),
        builder: (context, s) {
          final plan = (s.data ?? <PeriodPlan>[])
              .where((p) => p.key == periodKey)
              .firstOrNull;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Priorities: ${plan?.priorities ?? ''}\nGoals / roles: ${plan?.outcomes ?? ''}\nReview: ${plan?.review ?? ''}',
              ),
              TextButton(
                onPressed: () => planningAction(context, () async {
                  final v = await editPlanningText(
                    context,
                    weekly ? 'Weekly plan' : 'Monthly plan',
                    [
                      'Priorities',
                      'Goals and roles to focus on',
                      'Review / lessons',
                    ],
                    [
                      plan?.priorities ?? '',
                      plan?.outcomes ?? '',
                      plan?.review ?? '',
                    ],
                  );
                  if (v != null) {
                    await db.savePeriod(periodKey, v[0], v[1], v[2]);
                  }
                }),
                child: const Text('Edit period plan'),
              ),
            ],
          );
        },
      ),
      TextButton(
        onPressed: () {
          if (widget.onGoals != null) {
            widget.onGoals!();
          } else {
            context.go('/goals');
          }
        },
        child: const Text('Review goals, roles & values'),
      ),
      const Divider(),
      const Text('MASTER TASK LIST'),
      TextButton(
        onPressed: () => planningAction(context, masterTask),
        child: const Text('Add master task'),
      ),
      StreamBuilder(
        stream: db.select(db.masterTasks).watch(),
        builder: (context, s) => Column(
          children: [
            for (final t in (s.data ?? <MasterTask>[]).where(
              (t) => t.periodKey == periodKey,
            ))
              ListTile(
                title: Text(t.title),
                subtitle: Text(
                  t.scheduled
                      ? 'Scheduled in daily planner'
                      : 'Not yet scheduled',
                ),
                trailing: t.scheduled
                    ? const Icon(Icons.check)
                    : IconButton(
                        tooltip: 'Schedule into daily plan',
                        icon: const Icon(Icons.event_available),
                        onPressed: () => planningAction(context, () async {
                          final chosen = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2200),
                          );
                          if (chosen != null) {
                            await db.scheduleMasterTask(t.id, dayKey(chosen));
                          }
                        }),
                      ),
              ),
          ],
        ),
      ),
      const Divider(),
      const Text('DAILY TASKS & UNFINISHED REVIEW'),
      StreamBuilder(
        stream: db.select(db.plannerTasks).watch(),
        builder: (context, s) {
          final rows =
              (s.data ?? <PlannerTask>[])
                  .where(
                    (t) =>
                        t.day.compareTo(dayKey(start)) >= 0 &&
                        t.day.compareTo(dayKey(end)) <= 0,
                  )
                  .toList()
                ..sort(
                  (a, b) => '${a.day}${a.priority}'.compareTo(
                    '${b.day}${b.priority}',
                  ),
                );
          return Column(
            children: [
              for (final t in rows)
                ListTile(
                  title: Text('${t.priority} • ${t.title}'),
                  subtitle: Text('${t.day} • ${taskStatuses[t.status]}'),
                  onTap: () => openDay(DateTime.parse(t.day)),
                ),
            ],
          );
        },
      ),
      const Text(
        'Open a task’s daily page to edit it, review its status, or forward it.',
      ),
      const Divider(),
      const Text('APPOINTMENTS & IMPORTANT DATES'),
      StreamBuilder(
        stream: db.select(db.appointments).watch(),
        builder: (context, s) {
          final rows =
              (s.data ?? <Appointment>[])
                  .where(
                    (a) =>
                        a.day.compareTo(dayKey(start)) >= 0 &&
                        a.day.compareTo(dayKey(end)) <= 0,
                  )
                  .toList()
                ..sort((a, b) => a.day.compareTo(b.day));
          return Column(
            children: [
              for (final a in rows)
                ListTile(
                  title: Text(a.title),
                  subtitle: Text(
                    '${a.day} • ${a.allDay ? 'All day' : timeLabel(a.startMinute)}',
                  ),
                  onTap: () => openDay(DateTime.parse(a.day)),
                ),
            ],
          );
        },
      ),
      const Divider(),
      const Text('RECURRING TASKS & APPOINTMENTS'),
      const Text(
        'Templates create items only after you preview and confirm a selected period. Disabling a template keeps existing items.',
      ),
      TextButton(
        onPressed: () => planningAction(context, recurrence),
        child: const Text('Add recurring item'),
      ),
      StreamBuilder(
        stream: db.select(db.recurrenceRules).watch(),
        builder: (context, s) => Column(
          children: [
            for (final r in s.data ?? <RecurrenceRule>[])
              ListTile(
                title: Text(r.title),
                subtitle: Text(
                  '${r.kind} • ${r.frequency} • from ${r.anchorDay}',
                ),
                leading: Switch(
                  value: r.active,
                  onChanged: (v) => planningAction(
                    context,
                    () => db.setRecurrenceActive(r.id, v),
                  ),
                ),
                trailing: TextButton(
                  onPressed: !r.active
                      ? null
                      : () => planningAction(context, () => generate(r)),
                  child: const Text('Preview'),
                ),
              ),
          ],
        ),
      ),
    ],
  );
}
