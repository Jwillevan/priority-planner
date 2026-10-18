# Top 9/Priority Planner

Offline-first Flutter Android planner with a traditional ivory, ruled-paper daily spread. An installable 1.0.2 preview is available in `dist/`. Automated checks and Android 16 emulator integration passed; physical-phone acceptance checks remain.

## Features available

- Daily ABC tasks, tracking symbols/history, forwarding, appointments and quick notes.
- Searchable rich-text journal, categories/tags, task/appointment references, photos/documents and voice recording/playback.
- Weekly/monthly planning, goals, milestones, roles/values and explicitly confirmed recurring items.
- First-launch tutorial, 31 help lessons, saved progress and an isolated practice planner.
- Optional app lock using device biometrics/PIN, password-encrypted backups and optional local reminders.

No required accounts, analytics, paid APIs or cloud synchronization. Working database/media are **not encrypted**. App lock protects access through the app. Standard Android automatic backup is disabled; use the explicit encrypted export controls.

## Run (PowerShell from this directory)

```powershell
flutter pub get
dart run build_runner build
flutter doctor -v
flutter devices
flutter run -d <android-device-id>
```

Enable Developer options and USB debugging on your Android phone, connect USB and accept authorization, or start an Android Studio emulator. Select its ID from `flutter devices`.

## Check and build

```powershell
flutter analyze
flutter test
flutter build apk --debug
flutter build apk --release --config-only
flutter build apk --release --no-pub
```

The NDK blocker is resolved: version 28.2.13676358 is installed and both debug and optimized APK builds succeeded. The deliverable is `dist/Priority-Planner-1.0.2-preview.apk`, with SHA-256 in `dist/SHA256SUMS.txt`. It supports Android 7.0 (API 24) or later and ARM32, ARM64 and x86_64.

The preview uses the existing development signing key for personal testing. Production signing and app-store publication have not been performed. See `docs/phone-acceptance.md` to install and test it on your phone.

Keep Flutter commands sequential: a dependency refresh or analysis command can regenerate development plugin registration during an Android build. The `--config-only` then `--no-pub` sequence avoids the observed integration-test plugin registration issue. `tools/build-preview.ps1` runs validation and packaging in that order; optionally pass `-AndroidTestDevice emulator-5554` for the native test (grant microphone/notification test permissions on the dedicated emulator first).

Validation: clean source analysis, 30 unit/widget tests passed, and one native Android 16 emulator integration test passed. See `docs/milestone-8.md` for the precise coverage and remaining physical-phone checks.
Build outputs when successful: `build/app/outputs/flutter-apk/app-debug.apk` and `app-release.apk`.

## Privacy and backup controls

Open Settings to enable app lock, export an encrypted `.ppbackup` file, validate/restore an existing backup, enable local notifications, add reminders, or clean unused attachment files.

Backups encrypt a versioned record/media manifest with AES-256-GCM and a password-derived key (PBKDF2-HMAC-SHA256, 210,000 iterations and a random 16-byte salt). At least 8 password characters are required. There is no password recovery. Backups support up to 64 MiB of media and a 128 MiB encrypted container and must match the current schema. All media must exist and match stored lengths to export. Restore validates authentication, structure, hashes, paths and relationships before asking for replacement; it is a full replacement, not a merge. Export current data first if needed. Device lock/notification opt-ins are reset after restore; other settings and tutorial progress are restored.

Reminders use local inexact Android scheduling. Task reminders follow their date and stop on completion/cancellation; appointment reminders are 10 minutes before the start and follow edits. Planning/review reminders repeat daily. Repeating event templates generate concrete tasks/appointments; add reminders to those generated items as desired. Delivery can be delayed or suppressed by Android permissions, battery restrictions or force stop. Reminder text is generic to avoid exposing entry/task titles on the lock screen.

Saved journal entries accept attachments. Attachment mutations save immediately, independently of journal text edits. Journal text requires Save; quick daily notes autosave.

## Architecture and reports

`lib/app` owns theme/router; `lib/data` owns Drift/SQLite schema v5; `lib/features` contains daily, journal, media, planning, help and security modules. Binary attachments live separately in application-managed storage. Backup export includes all schema tables and referenced media. Tests inject memory/file databases and fake device adapters.

See `docs/milestone-1.md` through `docs/milestone-8.md` for implementation inventories, actual test results and limitations. Synced `sources/` references are read-only and were not changed.


## Version 1.0.1

Forwarding keeps a Forwarded record on the original day and an open task on the destination day. Later completion does not change the original record. Existing moves from earlier versions are retained in history. Delegated tasks have a first-name field in the editor; names stay off the daily list. Use the three-dot menu and Move to position to choose any rank within the same ABC group. Existing planner data and version 5 encrypted backups upgrade safely.

## Version 1.0.2

Slide tasks with the drag handle to choose their order or move them between the A, B, and C sections. Empty sections remain available as drop destinations. The list keeps ABC order and renumbers both affected groups. The move menu has been removed.
