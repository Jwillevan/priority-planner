# Priority Planner

An independent, offline Android planner with an original paper-inspired daily
spread. Flutter, Material 3, Riverpod, GoRouter, and Drift/SQLite.

**Milestone 2 daily-planner source implemented; Flutter/Android verification pending.**
This is not a verified running app or release. Milestone 3 has not been started.
See [the Milestone 2 report](docs/MILESTONE_2.md) for actual checks and limitations;
the [Milestone 1 report](docs/MILESTONE_1.md) remains the historical foundation record.

## What's in this build

- Ivory and dark paper themes, original ruled-paper drawing and icon.
- Responsive two-page daily layout. Portrait offers labeled Planning and
  Notes controls and horizontal swiping; wide screens show both pages.
- Date picker and previous/next date navigation.
- Today, Calendar, Journal, Goals, Settings navigation; separate Help route.
- Functional-source task and appointment editors, task completion/delegation/
  forwarding, drag ordering, and conflict-safe undo.
- Editable, automatically saved daily notes with save status, retry and undo.
- Theme preference storage and recoverable database-opening error screen.
- Version 1 relational schema covering all planned entities; media references
  are paths, not BLOBs. Foreign keys, constraints, indexes, deletion queue.
- Executable SQLite/static Android checks (26 passed); Dart repository/widget
  tests awaiting SDK.

Tutorials, formal journals, media/recording, goal workflows, reminders, biometric
lock, encrypted backup/restore, and whole-planner export/deletion remain later
milestones. Their existing navigation shells are clearly labeled. There is no
demo personal data or nonfunctional save button in the daily planner.

## Using the daily planner after a successful build

- Use **Add task** to choose A/B/C, enter details and select a status. Rankings
  such as A1/A2/B1 are calculated from order within each priority.
- Check a task to complete it; uncheck to return to Not started. Its actions menu
  provides Edit, Forward to another day, Delegate, In progress, Cancel, Delete,
  and accessible Move up/down. Drag handles reorder within a priority group;
  use Edit to change the priority itself.
- Forwarding moves the same task ID to the selected date, keeps its original
  date, records history, and leaves it unfinished. It does not copy or complete it.
- Use **Add appointment** or tap a printed hour to enter title, description,
  dates and times. End must be after start. All-day end dates are inclusive in the
  editor. Appointment rows open the editor; their menu offers Edit and Delete.
  Overlaps remain visible; overnight appointments appear on both affected days.
- Choose **Notes** (or use the right page on wide screens) and type. Each change
  is queued for SQLite. **Saved on this device** appears only after successful
  persistence. On failure the draft stays in memory for this app session; use
  Retry. Unsaved drafts can still be lost if Android terminates the process.
- Task/appointment mutations offer **Undo** in a ten-second snackbar. Undo is
  session-local and refuses to replace newer edits. Notes also have an undo-edit
  toolbar control and a Clear action with guarded undo.
- Use the previous/next buttons or date heading to choose dates from 1900–2200.
  Past and future dates remain editable. The current date uses the device timezone.

## Windows 11 setup

1. Install Git for Windows and the **current stable Flutter SDK** following
   <https://docs.flutter.dev/install>. Extract it to a user-writable path such as
   `C:\src\flutter` and add `C:\src\flutter\bin` to your user PATH. Avoid
   `Program Files`. Open a new PowerShell terminal.
2. Install Android Studio from <https://developer.android.com/studio>. In SDK
   Manager, install the SDK Platform required by your Flutter stable version,
   Android SDK Build-Tools, Platform-Tools, Command-line Tools (latest), and an
   emulator image if needed. Use Android Studio's supported bundled JDK. The
   source configuration compiles Kotlin/Java for Java 17.
3. Verify the installation and accept Android SDK licenses:

   ```powershell
   flutter --version
   flutter doctor -v
   flutter doctor --android-licenses
   ```

   Resolve all Android-toolchain errors before proceeding. Visual Studio is not
   required for the Android target. Android Studio normally configures the JDK;
   if Flutter selects the wrong one, use `flutter config --jdk-dir <jdk-path>`.
4. From this project root, run:

   ```powershell
   .\tool\bootstrap.ps1
   ```

   The script creates a temporary Flutter scaffold and copies only the standard
   Gradle wrapper scripts/JAR into this project. It preserves reviewed source,
   manifest and Gradle files, resolves packages, then generates Drift sources.
   Review `flutter pub get` results against [dependency notes](docs/DEPENDENCIES.md).
   If PowerShell policy prevents local scripts, read the script and run its
   commands individually; changing global execution policy is unnecessary.

   On Linux/macOS with Flutter and Android SDK installed:

   ```sh
   bash tool/bootstrap.sh
   ```

   The bootstrap has not been executed in the development environment. Gradle
   wrapper binary files and `app_database.g.dart` are intentionally not fabricated.
5. Check and run:

   ```powershell
   dart format lib test
   flutter analyze
   flutter test
   flutter devices
   flutter run -d <android-device-id>
   ```

   On a physical Android device enable Developer options and USB debugging,
   connect by USB, and authorize your development computer. Minimum configured
   Android version is API 24 (Android 7.0). This baseline is provisional until
   plugin compatibility is resolved and a device build succeeds.

## Generate an installable APK

After bootstrap, successful analysis/tests, and device smoke testing:

```powershell
flutter build apk --debug
adb install -r build\app\outputs\flutter-apk\app-debug.apk
```

The APK will be at `build/app/outputs/flutter-apk/app-debug.apk`. This is a
development APK, not a signed production release. The debug-only manifest grants
INTERNET for Flutter's VM service/hot reload, including USB socket forwarding.
The release manifest does not request INTERNET; the planner has no network clients.

Production packaging, signing, release-mode tests, and performance/device testing
belong to milestone 8. Before generating a production APK, follow
<https://docs.flutter.dev/deployment/android> to configure private release signing,
keep the key and passwords outside source control, then run:

```powershell
flutter build apk --release
```

No APK has been generated or installed in the current environment.

## Local schema checks without Flutter

With Python 3 installed:

```powershell
python tool/check_foundation.py
python tool/check_planner_sql.py
```

These execute the real `schema.drift` and repository SQL using SQLite and check Android XML.
It does **not** compile Dart, run Drift migrations, render Flutter widgets, or
verify plugins on Android.

## After changing the schema

```powershell
dart run build_runner build --delete-conflicting-outputs
```

After the first successful generation, freeze a Drift schema snapshot:

```powershell
dart run drift_dev schema dump lib/data/database/app_database.dart drift_schemas
```

Commit `pubspec.lock` and the snapshot. See [architecture](docs/ARCHITECTURE.md)
before introducing a new version. Never use database deletion as a migration.

## Privacy

There are no accounts, ads, analytics, cloud dependencies, or internet permissions
in the authored release manifest. Debug builds grant network permission for
Flutter development tooling. Android automatic backup is disabled in
the authored configuration. The local database is **not encrypted at rest**.
Permission and encryption implementations remain future milestones. Dependency
manifest merging and effective Android permissions still require a real build.

Priority Planner uses original visuals and does not imply FranklinCovey affiliation.
