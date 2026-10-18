# Milestone 7 — Privacy and Reliability

Implemented:
- Settings replaces the final navigation placeholder and provides app lock, encrypted export/validated restore, local notification opt-in, reminder management and unused-media cleanup.
- Optional device authentication using local_auth (available biometrics or device PIN), authenticated enable/disable, background relocking, and a covering overlay that blocks pointer and accessibility access to planner content while locked. Authentication failures leave the planner locked.
- Versioned encrypted `.ppbackup` containers using AES-256-GCM with fresh nonce, random salt and PBKDF2-HMAC-SHA256 (210,000 iterations). Export includes every current table and referenced binary attachment, with byte counts and SHA-256 hashes. No plaintext backup file is written by this service.
- Restore checks the encryption envelope, current schema, table/column manifest, scalar types, selected semantic constraints, journal text consistency, attachment hashes/unique paths, and SQLite integrity/foreign-key constraints in a separate memory database before the replacement confirmation.
- Restore copies media using new random filenames, then replaces rows transactionally. Failure rolls back database changes and removes newly copied files while keeping original media. After success unused old files are cleaned when possible. Device-specific lock/notification opt-ins are cleared, with a durable reminder-cleanup marker for subsequent startup retries; other settings are restored.
- Local task/appointment reminders plus Top 9/Daily Planning/review reminders. Permission is requested only when enabling notifications. Reminders reconcile after task/appointment/settings changes; completed/canceled tasks and deleted appointments are canceled, forwarded tasks follow their new date, and appointment reminders follow edited start times. Schedule IDs and definitions persist in local settings.
- Inexact local Android scheduling with timezone data and boot rescheduling configuration. No exact-alarm permission is requested. Notification contents use generic planner wording rather than private titles.
- Android FlutterFragmentActivity/AppCompat configuration for local_auth; biometric/notification/boot permission declarations, reminder receivers, desugaring and an original monochrome notification icon. Standard Android automatic backup is disabled in favor of explicit encrypted export.
- Updated privacy/backup/restore help lessons and README. Entry deletion no longer reports failure solely because post-commit orphan cleanup fails.

Files created:
- lib/features/security/app_lock.dart
- lib/features/security/backup_service.dart
- lib/features/security/reminders.dart
- lib/features/security/settings_screen.dart
- test/backup_test.dart
- test/security_test.dart
- test/security_widget_test.dart
- android/app/src/main/res/drawable/ic_notification.xml
- docs/milestone-7.md

Files changed:
- lib/app/app.dart
- lib/features/help/lessons.dart
- lib/features/journal/journal_screen.dart
- android/app/src/main/AndroidManifest.xml
- android/app/src/main/kotlin/com/priorityplanner/priority_planner/MainActivity.kt
- android/app/src/main/res/values/styles.xml and values-night/styles.xml
- android/app/build.gradle.kts
- pubspec.yaml / pubspec.lock
- README.md

No schema version change: backup manifests use current schema v5; lock/reminder preferences live in the existing settings table.

Validation results appended below. Backup tests exercise encryption roundtrip, wrong passwords, tampering, invalid paths/missing media, failed-restore rollback, restored media content, opt-in resets and missing-file export failure. Lock/reminder tests use fake adapters; native authentication and Android scheduling are not proven by these tests.

Remaining limitations:
- Working SQLite/media storage is not encrypted. App lock is an application-access control and does not guarantee protection from device-level access, screenshots/recents capture or a compromised OS. Device credential availability must be tested on Android.
- Backup format v1 accepts current schema v5 only. Export is memory-based, with up to 64 MiB media, a 128 MiB encrypted container and at most 250,000 rows on restore. Passwords cannot be recovered. This is functional testing, not an independent cryptographic audit.
- Restoring replaces all planner data; there is no merge. Lock/notification device opt-ins must be re-enabled afterward. Media cleanup failures can leave unreferenced files, removable from Settings; this does not invalidate committed records.
- Reminder scheduling is inexact and Android may delay/suppress it due to permissions, battery settings or force stop. Phone reboot receivers and timezone behavior need device verification. Recurring templates do not automatically attach reminders to every generated occurrence; select the generated task/appointment to add one.
- Native file-provider export/import, app locking over permission prompts, microphone/camera, notifications and boot delivery remain unverified on an Android device. No release-readiness claim is made.
- NDK 28.2.13676358 is still absent; the last APK build failure remains unresolved. Android native configuration changes have been inspected in source but not compiled in this milestone.

References used for native configuration: installed package READMEs/APIs and https://pub.dev/documentation/flutter_local_notifications/latest/ and https://pub.dev/packages/local_auth_android .

Next: Milestone 8 — broader integration/accessibility testing, resolve Android toolchain blocker, device/performance checks, release signing and APK generation.

Final verification: the full flutter test suite passed all 26 tests, including the active accessibility-tree lock overlay and background/resume relocking test. After a style-only brace fix, flutter analyze reported no issues. Test output is saved in milestone-7-tests.log. No native Android authentication/notification testing or APK build was performed.
