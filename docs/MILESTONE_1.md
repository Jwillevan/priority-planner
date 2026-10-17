# Milestone 1 — Foundation report

Date: October 12, 2026.

Status: **Source scaffold implemented; Flutter/Android verification blocked.**
Do not treat milestone 1 as a completed running application. Only SQLite and
static configuration checks below were executed successfully.

## Implemented source

- Flutter package structure and provisional foundation dependency constraints.
- Android Kotlin embedding, Gradle configuration, original launcher graphic,
  light/dark launch backgrounds, offline release manifest and backup exclusion
  rules. Debug-only INTERNET permission supports Flutter development tooling.
- Riverpod application/database/settings/date providers.
- GoRouter retained navigation for Today, Calendar, Journal, Goals, Settings;
  Help route and recovery route.
- Original paper palette and ruled-page painter, portrait page controls and
  responsive two-page daily layout shell. Reduced-motion support, semantics and
  page-storage keys. No real task/notes/journal workflows yet.
- Drift SQL schema v1 with 22 relational tables, constraints, indexes and a
  durable media-deletion queue trigger. Safe connection/startup handling and
  explicit rejection of unsupported migrations.
- Persistent appearance preference; no at-rest encryption claim.
- Windows/Linux bootstrap instructions and APK development build commands.

## Files created

All project files are newly created (the workspace had no prior app):

| Area | Files |
| --- | --- |
| Flutter config | `pubspec.yaml`, `analysis_options.yaml`, `.gitignore` |
| Entry point | `lib/main.dart` |
| App | `lib/app/{priority_planner_app,providers,router,paper_theme}.dart` |
| Database | `lib/data/database/app_database.dart`, `schema.drift` |
| Persistence | `lib/data/repositories/settings_repository.dart` |
| Screens | `lib/features/planner/daily_spread_screen.dart`, `lib/features/settings/settings_screen.dart` |
| Shared UI | `lib/shared/widgets/{paper_page,foundation_section}.dart` |
| Android | `android/settings.gradle.kts`, `build.gradle.kts`, `gradle.properties`, `gradle/wrapper/gradle-wrapper.properties`, `app/build.gradle.kts` |
| Android resources | `app/src/main/AndroidManifest.xml`, Kotlin `MainActivity.kt`, `res/values/styles.xml`, `res/values-night/styles.xml`, `res/drawable/{launch_background,ic_planner}.xml`, `res/xml/data_extraction_rules.xml` (under `android/`) |
| Debug tooling | `android/app/src/debug/AndroidManifest.xml` |
| Dart tests | `test/data/database_test.dart`, `test/app/layout_test.dart` |
| Local checks/setup | `tool/check_foundation.py`, `tool/bootstrap.ps1`, `tool/bootstrap.sh` |
| Documentation | `README.md`, `docs/{ARCHITECTURE,DEPENDENCIES,MILESTONE_1}.md`, `docs/PROJECT_SPEC.md` |

`app_database.g.dart`, wrapper binary/scripts, resolved lockfile and APK are not
present. Bootstrap/generation supplies the first three once tooling is installed.
The wrapper scripts and binary are copied from a genuine Flutter scaffold.

## Tests actually executed

Command: `python3 tool/check_foundation.py`.

Result: **16 passed**, using SQLite 3.53.1 against the actual `schema.drift`:

1. All 22 schema tables exist and foreign-key check is clean.
2. SQL A/B/C and position ordering.
3. Invalid priorities and negative positions rejected.
4. Completion/status timestamp consistency.
5. Unique history operation IDs and recurrence occurrences.
6. Positive appointment duration; overlapping rows allowed.
7. Deleting tasks preserves linked journal entries.
8. Orphan attachments rejected.
9. Obvious unsafe attachment paths rejected.
10. Journal deletion queues media paths through cascading attachment deletion.
11. Goal deletion preserves tasks.
12. Multiple entries per day and case-insensitive unique tags.
13. SQLite records/settings retained after closing and reopening the file.
14. Failed transaction rolls back changes.
15. Android XML well-formed.
16. No release permissions; automatic backup disabled in main manifest; debug
    permission is limited to INTERNET for Flutter tooling.

Also executed: `bash -n tool/bootstrap.sh` (syntax check, not a bootstrap run).

These are database foundations, not claims that task carry-forward, recurrence,
attachment persistence, audio, migrations, backup, or any Android feature works.

## Written but not run

- Dart: fresh Drift schema creation, FK rejection, persistent settings, unknown
  future schema refusal/data preservation.
- Flutter: portrait controls, landscape spread, large-text/dark layout, accessible
  date controls, calendar-day navigation.
- Drift code generation, formatting, analyzer, dependency resolution, migration
  integration checks, package compatibility verification.
- Android compile/install, screen-reader/device rotation testing and APK output.
- PowerShell bootstrap execution.

## Environment blockers

Flutter/Dart and Android SDK/adb/Gradle are not installed. The configured proxy
refused a request to official Flutter release metadata. The network permission
download attempt was interrupted; no SDK was downloaded. Latest stable package
versions could not be confirmed. Java alone does not provide an Android toolchain.

The setup guide provides the installation and generation commands. Re-run all
Dart/Flutter/Android checks before declaring this foundation complete. Fix any
generator/analyzer/build issues then; do not label unexecuted tests as passed.

## Next milestone

First resolve the foundation tooling and verification blockers. Then Milestone 2
adds the classic daily planner: task CRUD, derived numbering/status symbols,
reordering, carry-forward review/history, appointments with hourly schedule,
editable quick notes, and tests for actual workflows. The required safe practice
tutorial follows in Milestone 3. No milestones 2–8 were attempted in this step.
