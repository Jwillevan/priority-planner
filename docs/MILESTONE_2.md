# Milestone 2 — Functional daily planner report

Date: October 12, 2026.

**Status: Daily-planner functionality implemented in source; Flutter/Android
verification remains blocked. Milestone 2 cannot yet be certified complete as a
running application. Milestone 3 has not been started.**

## Implemented source

| Requested capability | Implementation |
| --- | --- |
| ABC tasks and rankings | Task editor; A/B/C ordering; derived A1/A2/B1 numbering; drag and accessible menu ordering within each priority |
| Completion, forwarding, delegation | Checkboxes; six distinct statuses and symbols; delegated-person field; state-history rows |
| Appointment schedule | Ruled hourly rows, add-at-hour, create/edit/delete; editable descriptions/dates/times, all-day and overnight support; visible overlap labels |
| Autosaved daily notes | Editable right page; serialized SQLite writes, Saved/Saving/error status, retry and retained per-day drafts |
| Two-page paper layout | Existing original paper rendering retained; portrait tabs/swipe and wide two-page spread; scaled text changes spread threshold |
| Local persistence | Repository-driven SQLite writes; reactive Drift queries; no cloud, accounts, new permissions or network clients |
| Moving unfinished tasks | Explicit date selection; updates the existing ID, original date preserved; transactional history; stale/repeated requests rejected |
| Date navigation | Previous/next and date picker retained; bounded 1900–2200; past/future daily pages editable |
| Responsive layout | Existing layout retained; page/date-specific scroll storage; notes drafts retained across navigation |
| CRUD and undo | Task/appointment create, edit and delete with snapshot-based transactional undo; notes edit/clear and undo; conflict guards |

## Data preservation

`schema.drift` and `AppDatabase.schemaVersion` remain unchanged at v1. All fields
and relationships needed by these features already existed. No destructive reset,
table replacement or migration is necessary for this milestone. Existing
settings/journal/goal/media references are not rewritten by initialization.

Forwarding never duplicates a task or marks it completed. Task edits and forwarding
compare their input row with current data, preserving newer changes on conflict.
Task/appointment deletion uses existing FK cascades while preserving independent
journal rows. Undo restores deleted history, journal links and reminders together
with their parent; failure rolls back the whole restoration.

## Files created or changed

Created:

- `lib/domain/planner_models.dart`
- `lib/data/repositories/planner_sql.dart`
- `lib/data/repositories/planner_repository.dart`
- `lib/features/planner/planner_providers.dart`
- `lib/features/planner/note_session.dart`
- `lib/features/planner/widgets/task_editor.dart`
- `lib/features/planner/widgets/appointment_editor.dart`
- `lib/features/planner/widgets/daily_planning_page.dart`
- `lib/features/planner/widgets/daily_notes_page.dart`
- `test/data/planner_repository_test.dart`
- `test/app/daily_planner_test.dart`
- `tool/check_planner_sql.py`
- `docs/MILESTONE_2.md`

Changed:

- `lib/features/planner/daily_spread_screen.dart`: replaces placeholder page bodies.
- `lib/features/settings/settings_screen.dart`: current build label/privacy wording.
- `test/app/layout_test.dart`: injectable in-memory database and cleanup for actual pages.
- `pubspec.yaml`: development version 0.2.0+2; existing dependencies unchanged.
- `README.md`, `docs/ARCHITECTURE.md`, `docs/DEPENDENCIES.md`: current functionality,
  storage/undo behavior, running instructions and limits.

## Checks actually executed

```sh
python3 tool/check_foundation.py
python3 tool/check_planner_sql.py
bash -n tool/bootstrap.sh
```

- **16/16 foundation SQLite/static Android checks passed.**
- **10/10 new repository-SQL checks passed.** They execute the literal SQL from
  `planner_sql.dart` against the unchanged schema. Coverage includes sorting,
  completion/reopening, delegation, forwarding identity/origin, state history,
  reordering fields, appointment edits/overlaps/midnight boundaries, invalid
  duration rejection, notes upsert/clear/restore/date isolation, transactional
  rollback, existing v1 preservation, and SQLite file reopening.
- Bash bootstrap syntax check passed; the bootstrap itself was not run.

These checks verify SQLite semantics, not Dart orchestration, Drift notifications,
Flutter layout or installed Android behavior. They do not establish that undo
callbacks, autosave lifecycle or Android restart behavior works end to end.

## Automated tests written but not executed

18 repository/session tests exercise the actual Dart repository: sorting and
numbering, ordering/undo, task CRUD, completion/history, delegation, duplicate
forward rejection, stale-edit/undo conflict checks, restoring cascaded links,
rollback on missing dependencies, stream updates, appointment CRUD/undo, overnight
boundaries, rapid notes writes, day isolation, simulated storage failure/retry,
and database file reopening with existing v1 data.

4 new widget scenarios exercise task create/complete/delete/undo, task edit/undo,
notes autosave/date navigation/clear undo, and appointment entry. Existing layout
tests were updated to use a real in-memory Drift database; they cover portrait,
landscape, dark/large-text layout and date accessibility. They are **not passed**
until actually run under Flutter.

## Limitations and remaining verification

- Flutter, Dart, Android SDK, adb and Gradle are still absent. A fresh bounded
  request to official Flutter metadata failed because the configured proxy
  refused the connection. No SDK was installed.
- Package resolution/latest-version compatibility, Drift generation, Dart
  formatting/analyzer/tests, APK build/install and device tests were not run.
  Generated database sources, lockfile and APK therefore remain absent.
- Undo is session-local; the latest task/appointment action offers a ten-second
  snackbar. It is not an indefinitely retained or restart-persistent undo log.
- Notes are saved only when the Saved status appears. Failed drafts are kept
  in memory for this session; force-stop/process death can lose unsaved changes.
- Notes sessions remain cached in memory for visited dates. A future bounded
  cache must preserve failed drafts. There is no independent durable draft store.
- Hour rows default to 06:00–22:00 and expand for earlier/later appointments.
  They list events at their starting hour rather than drawing duration lanes.
  Printed hours are not yet user-configurable. Timezone display follows the device.
- Only individual forwarding is implemented; bulk daily-review workflows,
  recurrence, reminders and task search remain outside this request's scope.
- TalkBack, real rotation, keyboard behavior, huge text, Android low storage,
  performance and process-death behavior need device verification. Storage
  failure/retry is covered by a written simulation test, not a device test.
- No tutorials/practice mode, journal editor, media, goal workflows, encrypted
  backups, app lock, or later-milestone features were added.

## Running and verifying

Follow the Windows 11 Flutter/Android SDK installation steps in `README.md`. For a
first setup, run `.\tool\bootstrap.ps1` (or `bash tool/bootstrap.sh` on Linux/macOS).
For an already bootstrapped project, use:

```powershell
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format lib test
flutter analyze
flutter test
flutter devices
flutter run -d <android-device-id>
```

After those checks and device smoke tests succeed:

```powershell
flutter build apk --debug
adb install -r build\app\outputs\flutter-apk\app-debug.apk
```

No APK has been built here. Production signing/packaging remains milestone 8.
To close Milestone 2, run and fix all Flutter/Android checks, then smoke-test every
daily workflow, undo, date/page changes, app restart, rotation, TalkBack, large
text and low-storage behavior on Android. Do not begin Milestone 3 before this
verification is complete.
