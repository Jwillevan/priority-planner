# Milestone 6 — Long-Term Planning

Implemented:
- Calendar month grid, week/month switching, period/date navigation across years, and links to the selected daily page.
- Weekly/monthly priorities, goals/roles focus and review records; master task lists with goal selection and explicit scheduling into daily plans. Scheduling is transactional and repeat scheduling of the same master item does not create another task.
- Period task/status overview for unfinished-work review, appointment/important-date lists, and links to daily editing/forwarding controls.
- Personal roles with descriptions, personal values, short-/long-term goals, descriptions/target dates, role selection, milestone checkboxes, linked daily tasks, progress counts, completion and archiving.
- Goal selection in the daily task editor. Task edits and goal-link changes save in one transaction.
- Daily/weekly/monthly recurrence templates for tasks and timed appointments. Preview lists dates for the selected period and requires explicit confirmation. Unique rule/date records prevent duplicate generation across repeated or overlapping requests and after forwarding. Disabling a template preserves existing items. Month-end recurrence derives each date from the original anchor (Jan 31 -> Feb 28/29 -> Mar 31), and weekly calculations avoid DST duration errors.
- Expanded tutorial practice with isolated daily/calendar/goals navigation and updated long-term planning lessons.
- Schema v5 adds roles, goals, milestones, task-goal links, period plans, master tasks, recurrence rules and occurrence records, without replacing existing daily/journal/media/tutorial tables.

Files created:
- lib/features/planning/recurrence.dart
- lib/features/planning/planning_helpers.dart
- lib/features/planning/planning_screen.dart
- lib/features/planning/goals_screen.dart
- test/planning_test.dart
- test/planning_widget_test.dart
- docs/milestone-6.md

Files changed:
- lib/data/database.dart and generated database.g.dart
- lib/app/app.dart
- lib/features/planner/planner_screen.dart
- lib/features/help/help_screen.dart and lessons.dart
- test/journal_test.dart (legacy fixture)
- test/widget_test.dart
- README.md

Tests cover recurrence anchors/month ends/leap years, weekly year boundaries, duplicate-safe confirmed generation and forwarding, disabled templates, repeating appointments, goal/milestone/master-task relationships, migration/reopen persistence, goal/role forms, calendar-to-daily navigation, and isolated tutorial planning navigation. Final results appended below.

Remaining limitations:
- Android device/rotation, large text, accessibility services, performance at large dataset sizes and native media remain unverified. The known missing NDK 28.2.13676358 still blocks APK generation; no APK build was rerun.
- Recurrence is explicitly generated per displayed week/month rather than automatically at app launch. Templates can be enabled/disabled; changing a series currently means disabling the old template and creating a new one. Existing generated items remain independently editable. Recurring appointments are timed; all-day appointments can still be created/edited on daily pages.
- Goal progress displays separate milestone and task completion counts; it does not infer a percentage or automatically mark a goal complete. Archived goals remain visible with their status. Role, master-task and milestone deletion/editing beyond the provided controls is not implemented.
- Period goals/role focus is freeform text, while structured goal links live on master and daily tasks. Personal values are a freeform saved record.
- Several forms currently accept typed dates, horizon/frequency words and times; validation failures report guidance but do not provide full inline field validation. The calendar uses Monday as the start of the week.
- Period overviews read local lists and filter them; pagination and dedicated date indexes are future performance work.
- Bulk carry-forward remains outside this milestone; individual status/forwarding controls remain on daily pages.

Next: Milestone 7 — optional app lock, encrypted backup/restore, local notifications and reliability improvements.

Final verification: flutter analyze reported no issues; the full flutter test suite passed all 22 tests. Output is saved in milestone-6-tests.log. No Android device testing or APK generation was performed in this milestone.
