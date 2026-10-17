import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'paper_theme.dart';
import 'providers.dart';
import 'router.dart';

class PriorityPlannerApp extends ConsumerWidget {
  const PriorityPlannerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ready = ref.watch(databaseReadyProvider);
    final mode = ref.watch(themeModeProvider).asData?.value ?? ThemeMode.system;
    final light = paperTheme(Brightness.light);
    final dark = paperTheme(Brightness.dark);
    if (!ready.hasValue) {
      return MaterialApp(
        title: 'Priority Planner',
        debugShowCheckedModeBanner: false,
        theme: light,
        darkTheme: dark,
        themeMode: mode,
        home: Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ready.hasError
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Local storage could not be opened. Your existing data has not been reset. Check available storage and try again.'),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: () {
                              ref.invalidate(databaseProvider);
                              ref.invalidate(themeModeProvider);
                            },
                            child: const Text('Try again'),
                          ),
                        ],
                      )
                    : const CircularProgressIndicator(semanticsLabel: 'Opening local planner'),
              ),
            ),
          ),
        ),
      );
    }
    return MaterialApp.router(
      title: 'Priority Planner',
      debugShowCheckedModeBanner: false,
      theme: light,
      darkTheme: dark,
      themeMode: mode,
      routerConfig: ref.watch(routerProvider),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('en')],
    );
  }
}
