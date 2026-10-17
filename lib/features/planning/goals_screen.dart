import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../planner/planner_screen.dart';
import 'planning_helpers.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});
  Future<void> editGoal(
    BuildContext context,
    PlannerDatabase db, [
    Goal? goal,
  ]) async {
    final roles = await db.select(db.personalRoles).get();
    if (!context.mounted) return;
    final value = await editPlanningText(
      context,
      goal == null ? 'New goal' : 'Edit goal',
      [
        'Title',
        'Description',
        'Horizon: short or long',
        'Target date YYYY-MM-DD (optional)',
      ],
      [
        goal?.title ?? '',
        goal?.description ?? '',
        goal?.horizon ?? 'short',
        goal?.targetDay ?? '',
      ],
      choices: {for (final r in roles) r.id: r.name},
      selected: goal?.roleId,
      choiceLabel: 'Personal role',
    );
    if (value == null || !context.mounted) return;
    await planningAction(
      context,
      () => db.saveGoal(
        id: goal?.id,
        title: value[0],
        description: value[1],
        horizon: value[2].trim(),
        targetDay: value[3].trim().isEmpty ? null : value[3].trim(),
        roleId: value[4].trim().isEmpty ? null : int.parse(value[4].trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return PaperPage(
      storageKey: 'goals',
      children: [
        Text(
          'Goals, roles & values',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const Text(
          'Choose meaningful outcomes, then connect daily actions to them.',
        ),
        TextButton(
          onPressed: () => planningAction(context, () async {
            final old = await db.readSetting('personal.values') ?? '';
            if (!context.mounted) return;
            final v = await editPlanningText(
              context,
              'Personal values',
              ['What principles guide your choices?'],
              [old],
            );
            if (v != null) await db.writeSetting('personal.values', v[0]);
          }),
          child: const Text('Edit personal values'),
        ),
        StreamBuilder(
          stream: db.select(db.plannerSettings).watch(),
          builder: (context, s) => Text(
            (s.data ?? <PlannerSetting>[])
                    .where((v) => v.key == 'personal.values')
                    .firstOrNull
                    ?.value ??
                'Record your values to guide planning.',
          ),
        ),
        const Divider(),
        const Text('PERSONAL ROLES'),
        TextButton(
          onPressed: () => planningAction(context, () async {
            final v = await editPlanningText(
              context,
              'New role',
              ['Role name', 'Description'],
              ['', ''],
            );
            if (v != null) await db.saveRole(name: v[0], description: v[1]);
          }),
          child: const Text('Add role'),
        ),
        StreamBuilder(
          stream: db.select(db.personalRoles).watch(),
          builder: (context, s) => Column(
            children: [
              for (final r in s.data ?? <PersonalRole>[])
                ListTile(
                  title: Text(r.name),
                  subtitle: Text(r.description),
                  onTap: () => planningAction(context, () async {
                    final v = await editPlanningText(
                      context,
                      'Edit role',
                      ['Role name', 'Description'],
                      [r.name, r.description],
                    );
                    if (v != null) {
                      await db.saveRole(
                        id: r.id,
                        name: v[0],
                        description: v[1],
                      );
                    }
                  }),
                ),
            ],
          ),
        ),
        const Divider(),
        const Text('SHORT-TERM & LONG-TERM GOALS'),
        TextButton(
          onPressed: () => planningAction(context, () => editGoal(context, db)),
          child: const Text('Add goal'),
        ),
        StreamBuilder(
          stream: db.select(db.goals).watch(),
          builder: (context, s) {
            if (s.hasError) return const Text('Goals could not be loaded.');
            return Column(
              children: [
                for (final g in s.data ?? <Goal>[])
                  ExpansionTile(
                    title: Text(g.title),
                    subtitle: Text(
                      '${g.horizon} term • ${g.status} • target ${g.targetDay ?? 'not set'}',
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(g.description),
                      ),
                      TextButton(
                        onPressed: () => planningAction(
                          context,
                          () => editGoal(context, db, g),
                        ),
                        child: const Text('Edit goal'),
                      ),
                      Wrap(
                        children: [
                          for (final status in [
                            'open',
                            'completed',
                            'archived',
                          ])
                            TextButton(
                              onPressed: () => planningAction(
                                context,
                                () => db.goalStatus(g.id, status),
                              ),
                              child: Text(status),
                            ),
                        ],
                      ),
                      TextButton(
                        onPressed: () => planningAction(context, () async {
                          final v = await editPlanningText(
                            context,
                            'New milestone',
                            ['Milestone'],
                            [''],
                          );
                          if (v != null) await db.addMilestone(g.id, v[0]);
                        }),
                        child: const Text('Add milestone'),
                      ),
                      StreamBuilder(
                        stream: db.select(db.goalMilestones).watch(),
                        builder: (context, s) {
                          final rows = (s.data ?? <GoalMilestone>[])
                              .where((m) => m.goalId == g.id)
                              .toList();
                          return Column(
                            children: [
                              Text(
                                '${rows.where((m) => m.completed).length}/${rows.length} milestones completed',
                              ),
                              for (final m in rows)
                                CheckboxListTile(
                                  title: Text(m.title),
                                  value: m.completed,
                                  onChanged: (v) => planningAction(
                                    context,
                                    () => db.setMilestone(m.id, v!),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      StreamBuilder(
                        stream: db.select(db.taskGoalLinks).watch(),
                        builder: (context, links) => StreamBuilder(
                          stream: db.select(db.plannerTasks).watch(),
                          builder: (context, tasks) {
                            final ids = (links.data ?? <TaskGoalLink>[])
                                .where((l) => l.goalId == g.id)
                                .map((l) => l.taskId)
                                .toSet();
                            final rows = (tasks.data ?? <PlannerTask>[])
                                .where((t) => ids.contains(t.id))
                                .toList();
                            return Column(
                              children: [
                                Text(
                                  '${rows.where((t) => t.status == 'completed').length}/${rows.length} linked tasks completed',
                                ),
                                for (final t in rows)
                                  ListTile(
                                    title: Text(t.title),
                                    subtitle: Text(
                                      '${t.day} • ${taskStatuses[t.status]}',
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
