import '../features/security/settings_screen.dart';
import '../features/security/app_lock.dart';
import '../features/planning/planning_screen.dart';
import '../features/planning/goals_screen.dart';

import 'package:flutter_quill/flutter_quill.dart';

import '../features/journal/journal_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/planner/planner_screen.dart';
import 'theme.dart';
import '../features/help/help_screen.dart';

const sections = <String, String>{
  '/': 'Daily Planner',
  '/calendar': 'Calendar',
  '/journal': 'Journal',
  '/goals': 'Goals',
  '/help': 'Help & Tutorials',
  '/settings': 'Settings',
};

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) => PlannerShell(child: child),
        routes: [
          for (final section in sections.entries)
            GoRoute(
              path: section.key,
              builder: (context, state) => section.key == '/'
                  ? PlannerScreen(
                      key: ValueKey(state.uri.queryParameters['date']),
                      initialDate: DateTime.tryParse(
                        state.uri.queryParameters['date'] ?? '',
                      ),
                    )
                  : section.key == '/help'
                  ? const HelpScreen()
                  : section.key == '/journal'
                  ? const JournalScreen()
                  : section.key == '/calendar'
                  ? const PlanningScreen()
                  : section.key == '/goals'
                  ? const GoalsScreen()
                  : const SettingsScreen(),
            ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

class PriorityPlannerApp extends ConsumerWidget {
  const PriorityPlannerApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
    title: 'Priority Planner',
    localizationsDelegates: FlutterQuillLocalizations.localizationsDelegates,
    theme: plannerTheme(),
    builder: (context, child) => AppLockGate(child: child ?? const SizedBox()),
    debugShowCheckedModeBanner: false,
    routerConfig: ref.watch(routerProvider),
  );
}

class PlannerShell extends StatelessWidget {
  const PlannerShell({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Priority Planner'),
      actions: [
        IconButton(
          tooltip: 'Help & Tutorials',
          onPressed: () => context.go('/help'),
          icon: const Icon(Icons.help_outline),
        ),
      ],
    ),
    drawer: Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text('PLANNER INDEX'),
            ),
            for (final section in sections.entries)
              ListTile(
                title: Text(section.value),
                onTap: () {
                  Navigator.pop(context);
                  context.go(section.key);
                },
              ),
          ],
        ),
      ),
    ),
    body: TutorialWelcome(child: child),
  );
}
