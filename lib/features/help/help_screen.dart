import '../planning/planning_screen.dart';
import '../planning/goals_screen.dart';
import '../media/attachment_store.dart';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../planner/planner_screen.dart';
import 'lessons.dart';
import 'tutorial_focus.dart';

class TutorialWelcome extends ConsumerStatefulWidget {
  const TutorialWelcome({required this.child, super.key});
  final Widget child;
  @override
  ConsumerState<TutorialWelcome> createState() => _TutorialWelcomeState();
}

class _TutorialWelcomeState extends ConsumerState<TutorialWelcome> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => offer());
  }

  Future<void> offer() async {
    try {
      final db = ref.read(databaseProvider);
      if (await db.readSetting('tutorial.offered') == 'yes' || !mounted) return;
      final start = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Welcome to Top 9/Priority Planner'),
          content: const Text(
            'Learn traditional Top 9/Daily Planning in a safe practice planner. You can repeat lessons later in Help & Tutorials.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Skip for Now'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Start Tutorial'),
            ),
          ],
        ),
      );
      await db.writeSetting('tutorial.offered', 'yes');
      if (start == true && mounted) await openLesson(context, db, 0);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Tutorial preferences could not be loaded or saved. Help & Tutorials remains available.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

Future<void> openLesson(
  BuildContext context,
  PlannerDatabase realDb,
  int index,
) => Navigator.of(context).push<void>(
  MaterialPageRoute(
    builder: (_) => TutorialSession(realDb: realDb, initialIndex: index),
  ),
);

class HelpScreen extends ConsumerStatefulWidget {
  const HelpScreen({super.key});
  @override
  ConsumerState<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends ConsumerState<HelpScreen> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    return StreamBuilder<List<PlannerSetting>>(
      stream: db.watchTutorialProgress(),
      builder: (context, snapshot) {
        final complete = {
          for (final s in snapshot.data ?? <PlannerSetting>[])
            if (s.value == 'complete') s.key,
        };
        final matching = lessons
            .where(
              (l) => '${l.title} ${l.why} ${l.steps.join(' ')}'
                  .toLowerCase()
                  .contains(query.toLowerCase()),
            )
            .toList();
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Help & Tutorials',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Text(
              'Practice safely. Progress records lessons reviewed, not a skills assessment.',
            ),
            Text('${complete.length} of ${lessons.length} lessons reviewed'),
            if (snapshot.hasError)
              const Text('Progress could not be loaded. Please retry later.'),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search help',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => query = value),
            ),
            Wrap(
              spacing: 12,
              children: [
                TextButton(
                  onPressed: () => openLesson(context, db, 0),
                  child: const Text('Start or repeat tutorial'),
                ),
                TextButton(
                  onPressed: () async {
                    final yes = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Reset lesson progress?'),
                        content: const Text(
                          'Only tutorial completion marks will be cleared. Planner records stay intact.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Back'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Reset progress'),
                          ),
                        ],
                      ),
                    );
                    if (yes == true) {
                      try {
                        await db.resetTutorialProgress();
                      } catch (_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Could not reset progress.'),
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: const Text('Reset progress'),
                ),
              ],
            ),
            if (matching.isEmpty)
              const Text('No matching lessons. Try another term.'),
            for (final advanced in [false, true]) ...[
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(advanced ? 'ADVANCED LESSONS' : 'BEGINNER LESSONS'),
              ),
              for (final lesson in matching.where(
                (l) => l.advanced == advanced,
              ))
                ListTile(
                  leading: Icon(
                    complete.contains('tutorial.lesson.${lesson.id}')
                        ? Icons.check_circle_outline
                        : Icons.menu_book_outlined,
                  ),
                  title: Text(lesson.title),
                  subtitle: Text(
                    lesson.future
                        ? 'Preview • feature planned for a later milestone'
                        : lesson.why,
                  ),
                  onTap: () => openLesson(context, db, lessons.indexOf(lesson)),
                ),
            ],
          ],
        );
      },
    );
  }
}

class TutorialSession extends StatefulWidget {
  const TutorialSession({
    required this.realDb,
    required this.initialIndex,
    super.key,
  });
  final PlannerDatabase realDb;
  final int initialIndex;
  @override
  State<TutorialSession> createState() => _TutorialSessionState();
}

class _TutorialSessionState extends State<TutorialSession> {
  String? practiceView;
  DateTime? practiceDay;
  String viewFor(Lesson lesson) =>
      ['weekly', 'monthly', 'recurrence'].contains(lesson.id)
      ? 'calendar'
      : ['roles', 'goals'].contains(lesson.id)
      ? 'goals'
      : 'daily';
  late int index = widget.initialIndex;
  late final PlannerDatabase practice = PlannerDatabase.forTesting(
    NativeDatabase.memory(),
  );
  late final Future<void> ready = seed();
  bool busy = false, instructions = true;
  String? error;
  Future<void> seed() async {
    await practice.saveTask(
      day: dayKey(DateTime.now()),
      title: 'Practice: prepare project outline',
      details: 'Sample task — safe to change',
      priority: 'A',
    );
    await practice.saveAppointment(
      day: dayKey(DateTime.now()),
      title: 'Practice: project discussion',
      start: 600,
      end: 660,
      allDay: false,
    );
  }

  @override
  void dispose() {
    practice.close().then((_) => AttachmentStore.discardPractice(practice));
    super.dispose();
  }

  Future<void> next({bool skip = false}) async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      if (!skip) {
        await widget.realDb.writeSetting(
          'tutorial.lesson.${lessons[index].id}',
          'complete',
        );
      }
      if (!mounted) return;
      if (index == lessons.length - 1) {
        Navigator.pop(context);
      } else {
        setState(() {
          index++;
          instructions = true;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => error = 'Progress could not be saved. Retry Next or use Skip.',
        );
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lesson = lessons[index];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorial • Practice only'),
        actions: [
          IconButton(
            tooltip: 'Show lesson instructions',
            onPressed: () => setState(() => instructions = !instructions),
            icon: const Icon(Icons.help_outline),
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: ready,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Practice data could not be created. Return and retry.',
              ),
            );
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              if (instructions)
                Flexible(
                  flex: 2,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${index + 1}/${lessons.length} • ${lesson.title}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(lesson.why),
                        if (lesson.future)
                          const Text(
                            'PREVIEW — this feature is not implemented yet.',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        for (var i = 0; i < lesson.steps.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text('${i + 1}. ${lesson.steps[i]}'),
                          ),
                        if (error != null) Text(error!),
                      ],
                    ),
                  ),
                ),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  TextButton(
                    onPressed: busy || index == 0
                        ? null
                        : () => setState(() {
                            practiceView = null;
                            index--;
                            instructions = true;
                          }),
                    child: const Text('Back'),
                  ),
                  TextButton(
                    onPressed: busy ? null : () => next(skip: true),
                    child: const Text('Skip'),
                  ),
                  TextButton(
                    onPressed: busy
                        ? null
                        : () => setState(() {
                            practiceView = null;
                            index = 0;
                            instructions = true;
                          }),
                    child: const Text('Restart'),
                  ),
                  TextButton(
                    onPressed: () =>
                        setState(() => instructions = !instructions),
                    child: Text(
                      instructions ? 'Expand practice' : 'Show instructions',
                    ),
                  ),
                  FilledButton(
                    onPressed: busy ? null : next,
                    child: Text(
                      index == lessons.length - 1 ? 'Finish' : 'Next',
                    ),
                  ),
                ],
              ),
              const Text('PRACTICE DATA • discarded when you leave'),
              Expanded(
                flex: 3,
                child: ProviderScope(
                  overrides: [databaseProvider.overrideWithValue(practice)],
                  child: TutorialFocus(
                    target: lesson.target,
                    child: Column(
                      children: [
                        Wrap(
                          children: [
                            for (final view in ['daily', 'calendar', 'goals'])
                              TextButton(
                                onPressed: () =>
                                    setState(() => practiceView = view),
                                child: Text('Practice $view'),
                              ),
                          ],
                        ),
                        Expanded(
                          child: (practiceView ?? viewFor(lesson)) == 'calendar'
                              ? PlanningScreen(
                                  initialWeekly: lesson.id == 'weekly',
                                  onOpenDay: (day) => setState(() {
                                    practiceDay = day;
                                    practiceView = 'daily';
                                  }),
                                  onGoals: () =>
                                      setState(() => practiceView = 'goals'),
                                )
                              : (practiceView ?? viewFor(lesson)) == 'goals'
                              ? const GoalsScreen()
                              : PlannerScreen(
                                  key: ValueKey(practiceDay),
                                  initialDate: practiceDay,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
