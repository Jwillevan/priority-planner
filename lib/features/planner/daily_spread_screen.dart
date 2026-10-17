import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../domain/planner_models.dart';
import 'widgets/daily_notes_page.dart';
import 'widgets/daily_planning_page.dart';

/// Original two-page daily planner, backed by local repositories.
class DailySpreadScreen extends ConsumerStatefulWidget {
  const DailySpreadScreen({super.key});

  @override
  ConsumerState<DailySpreadScreen> createState() => _DailySpreadScreenState();
}

class _DailySpreadScreenState extends ConsumerState<DailySpreadScreen> {
  final _pages = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _selectPage(int page) {
    setState(() => _page = page);
    if (!_pages.hasClients) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _pages.jumpToPage(page);
    } else {
      _pages.animateToPage(
        page,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final day = ref.watch(selectedDayProvider);
    final date = MaterialLocalizations.of(context).formatFullDate(day);
    final planning = DailyPlanningPage(key: ValueKey('planning-${plannerDay(day)}'), day: day);
    final notes = DailyNotesPage(key: ValueKey('notes-${plannerDay(day)}'), day: day);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Previous day',
                onPressed: day.isAfter(DateTime(1900))
                    ? () => ref.read(selectedDayProvider.notifier).move(-1) : null,
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    final selected = await showDatePicker(
                      context: context,
                      initialDate: day,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2200, 12, 31),
                    );
                    if (selected != null && mounted) {
                      ref.read(selectedDayProvider.notifier).select(selected);
                    }
                  },
                  child: Semantics(
                    label: 'Choose planner date, $date',
                    excludeSemantics: true,
                    child: Text(date, textAlign: TextAlign.center),
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Next day',
                onPressed: day.isBefore(DateTime(2200, 12, 31))
                    ? () => ref.read(selectedDayProvider.notifier).move(1) : null,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final scale = MediaQuery.textScalerOf(context).scale(1);
              final spread = constraints.maxWidth >= 840 * scale;
              if (spread) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: planning),
                    Expanded(child: notes),
                  ],
                );
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: SegmentedButton<int>(
                      segments: const [
                        ButtonSegment(value: 0, label: Text('Planning'), icon: Icon(Icons.checklist)),
                        ButtonSegment(value: 1, label: Text('Notes'), icon: Icon(Icons.notes)),
                      ],
                      selected: {_page},
                      onSelectionChanged: (selection) => _selectPage(selection.single),
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      key: const PageStorageKey('daily-page'),
                      controller: _pages,
                      onPageChanged: (page) => setState(() => _page = page),
                      children: [planning, notes],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
