import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/planner/daily_spread_screen.dart';
import '../features/settings/settings_screen.dart';
import '../shared/widgets/foundation_section.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/today',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => _PlannerShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/today', builder: (context, state) => const DailySpreadScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/calendar',
              builder: (context, state) => const FoundationSection(
                title: 'Calendar',
                description: 'Monthly tabs, weekly planning, and navigation to your daily pages arrive in Milestone 6. Use the date heading in Today to preview another day.',
              ),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/journal',
              builder: (context, state) => const FoundationSection(
                title: 'Journal',
                description: 'Multiple entries, rich text, categories, tags, and history arrive in Milestone 4. Photos, documents, and audio follow in Milestone 5.',
              ),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/goals',
              builder: (context, state) => const FoundationSection(
                title: 'Goals & Values',
                description: 'Personal roles, values, goals, and milestones arrive in Milestone 6.',
              ),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
          ]),
        ],
      ),
      GoRoute(
        path: '/help',
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Help & Tutorials')),
          body: const SafeArea(
            child: FoundationSection(
              title: 'A thoughtful start',
              description: 'The interactive Startup Guide arrives in Milestone 3. It will explain the two-page layout, ABC priorities, tracking symbols, and daily review using a separate practice database.',
            ),
          ),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Priority Planner')),
      body: Center(
        child: TextButton(onPressed: () => context.go('/today'), child: const Text('Return to Today')),
      ),
    ),
  );
  ref.onDispose(router.dispose);
  return router;
});

class _PlannerShell extends StatelessWidget {
  const _PlannerShell({required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Priority Planner'),
          actions: [
            IconButton(
              tooltip: 'Help & Tutorials',
              onPressed: () => context.push('/help'),
              icon: const Icon(Icons.help_outline),
            ),
          ],
        ),
        body: SafeArea(child: shell),
        bottomNavigationBar: NavigationBar(
          selectedIndex: shell.currentIndex,
          onDestinationSelected: (index) => shell.goBranch(index),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.today_outlined), selectedIcon: Icon(Icons.today), label: 'Today'),
            NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month), label: 'Calendar'),
            NavigationDestination(icon: Icon(Icons.book_outlined), selectedIcon: Icon(Icons.book), label: 'Journal'),
            NavigationDestination(icon: Icon(Icons.flag_outlined), selectedIcon: Icon(Icons.flag), label: 'Goals'),
            NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
      );
}
