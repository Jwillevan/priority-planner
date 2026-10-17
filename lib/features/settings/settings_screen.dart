import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../shared/widgets/paper_page.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preference = ref.watch(themeModeProvider);
    return PaperPage(
      child: ListView(
        children: [
          Text('Settings', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          preference.when(
            data: (mode) => DropdownButtonFormField<ThemeMode>(
              initialValue: mode,
              decoration: const InputDecoration(labelText: 'Appearance'),
              items: const [
                DropdownMenuItem(value: ThemeMode.system, child: Text('Follow device')),
                DropdownMenuItem(value: ThemeMode.light, child: Text('Ivory paper')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark paper')),
              ],
              onChanged: (value) async {
                if (value == null) return;
                try {
                  await ref.read(themeModeProvider.notifier).setMode(value);
                } catch (_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Appearance could not be saved. Check available storage and try again.')),
                    );
                  }
                }
              },
            ),
            error: (error, stack) => const Text('Appearance settings could not be loaded.'),
            loading: () => const LinearProgressIndicator(),
          ),
          const SizedBox(height: 24),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Tutorials'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/help'),
          ),
          const Divider(),
          const Text('Your data stays on this device. The planner uses local SQLite storage and has no accounts, advertising, analytics, or cloud services.'),
          const SizedBox(height: 16),
          const Text('The database is not encrypted at rest. App lock and encrypted backups are planned for Milestone 7.'),
          const SizedBox(height: 16),
          const Text('Priority Planner is an independent application with original visuals. It is not affiliated with FranklinCovey.'),
          const SizedBox(height: 16),
          const Text('Daily planner development build · 0.2.0'),
        ],
      ),
    );
  }
}
