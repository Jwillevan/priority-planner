# Milestone 3 — Startup Guide

Implemented 20 beginner and 11 advanced lessons, with purpose, numbered steps, examples, task symbol explanations and repeatable sessions. Not-yet-built journal/media/long-term/security features are labeled previews rather than presented as working controls.

First launch offers Start Tutorial or Skip for Now. The choice is persisted in the local settings table. Help & Tutorials remains accessible from the planner index and app-bar help icon. Search covers lesson titles, explanations and steps. Completion marks persist locally; reset asks for confirmation and removes only lesson completion marks. Next records review completion; Skip does not. Back and Restart repeat lessons without deleting planner data or prior progress.

Tutorial sessions use a distinct NativeDatabase.memory() SQLite executor with sample tasks and appointments, scoped with Riverpod so the embedded real planner controls operate only on practice records. Leaving discards practice data. Only lesson progress is written to the real database. Instructions can be collapsed to provide more practice space. Borders highlight date/page/add-task/add-appointment entry controls when relevant; the guide does not overlay every editor field. Lessons are self-guided, with explicit review completion rather than automatic action assessment. Restart restarts lesson navigation; closing and reopening creates fresh practice data.

Files added:
- lib/features/help/lessons.dart
- lib/features/help/help_screen.dart
- lib/features/help/tutorial_focus.dart
- test/tutorial_test.dart
- docs/milestone-3.md

Files changed:
- lib/app/app.dart (help route, help icon, first-launch wrapper)
- lib/data/database.dart (settings/progress operations; no schema change)
- lib/features/planner/planner_screen.dart (highlight wrappers; Material surface for appointment list tiles)
- test/widget_test.dart (existing users bypass onboarding)
- README.md

Validation: tutorial tests passed 3 tests for catalogue/progress reset, first-launch Skip persistence/help search, and practice isolation/Next/Skip/Restart. Existing 5 tests cover the daily planner and database. Full final suite results appended below. Practice intentionally opens a second PlannerDatabase with its own executor; Drift may emit its debug-only multiple-instance warning even though these databases do not share an executor or storage.

Remaining limitations: on-device layout, screen reader behavior, rotation and large Android text remain unverified. No APK was rebuilt; missing NDK 28.2.13676358 remains the known build blocker. Preview lessons will need interactive controls as their feature milestones land. No media permissions or recording were introduced. Current data is not encrypted.

Next milestone: Milestone 4 — rich-text journal entries, categories/tags, search, timeline, and task/appointment linking.

Final verification: flutter analyze reported no issues. Full flutter test run passed all 8 tests. Test output saved in milestone-3-tests.log. No device or APK validation was performed.
