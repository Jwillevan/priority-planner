# Milestone 8 — Testing and APK

This is the final planned development milestone. An installable preview does not imply app-store publication or exhaustive physical-device validation.

Completed implementation/testing work:
- Resolved the missing NDK blocker by downloading official Android NDK r28c (28.2.13676358), verifying the published SHA-1 checksum 086bba43ff2f5eb0e387b15c8278bb4e0d89ba1d, and installing it into the Android SDK. Source: https://github.com/android/ndk/wiki/Unsupported-Downloads .
- Verified Windows Hypervisor acceleration, installed Android 16 emulator images and created/started a dedicated `medium_phone` virtual device. Gradle installed required Android SDK platforms/CMake during the successful debug build.
- Added explicit individual/bulk unfinished-task review actions (forward/keep/complete/cancel/delegate). Transactional review prevents duplicates, ignores already-final tasks and rolls back invalid selections.
- Preserved the selected daily page across swipe and portrait/spread rotation using an owned tab controller; enlarged task status controls to 48x48 logical pixels.
- Fixed the journal attachment filter at large text sizes and constrained reminder type selection to available width.
- Added useful date/relationship indexes and replaced full-table task-position reads with a scoped SQL aggregate.
- Added the same record-count bound to export and restore, preventing exports that exceed their own restore limit.
- Added an original planner launcher icon and updated help for bulk review.
- Added native Android integration coverage and inspected the actual initial app screen.

Files created:
- integration_test/android_test.dart
- test/release_readiness_test.dart
- android/app/src/main/res/drawable/ic_planner.xml
- docs/phone-acceptance.md
- docs/milestone-8.md
- docs/screenshots/android-launch.png
- dist/ (final artifact details appended below)

Files changed:
- lib/data/database.dart
- lib/features/planner/planner_screen.dart
- lib/features/journal/journal_screen.dart
- lib/features/security/settings_screen.dart
- lib/features/security/backup_service.dart
- lib/features/help/lessons.dart
- android/app/src/main/AndroidManifest.xml
- pubspec.yaml / pubspec.lock
- README.md

Validation observed so far:
- Android debug APK build succeeded after installing the toolchain components.
- 30 unit/widget tests passed, including bulk-review rollback/idempotency, bulk-review UI, swipe/rotation retention and 2x text on a 360x640 viewport.
- One Android 16 integration test passed on emulator-5554. It created a task through the app UI; preserved SQLite data after close/reopen; imported managed document/photo/audio copies; recorded AAC audio with native pause/resume/stop; loaded/seeked it with the native audio player; scheduled/canceled a native notification and verified it was pending; queried authentication support; and encrypted/validated a full backup with those media files.
- Media recording used emulator test audio with host audio disabled. No claim of audible real-phone playback is made. A notification pending in Android's scheduler is not proof of actual delivery.
- Actual app startup was inspected visually. The first-launch tutorial and classic ivory Top 9/Daily Planning page rendered correctly on the emulator.

Final build, signature, permission and launch checks appended below.

Remaining acceptance/release work:
- Follow docs/phone-acceptance.md on the user's Android phone, especially camera/gallery/document providers, biometrics/device PIN prompts, audible playback, phone-call interruption, notification delivery/reboot, TalkBack, low storage and device performance.
- The preview uses the existing development signing key. Production signing and store publication have not been performed.
- Working data/media are not encrypted. Backups are password encrypted; app lock is an application access control. No independent cryptographic audit is claimed.
- Backups are current-schema only and memory-bounded (64 MiB media, 128 MiB encrypted file, 250,000 records).
- Role/master-task/milestone editing/deletion and recurring-template editing retain the limitations documented in Milestone 6. Media process-death recovery and broad performance testing retain documented limitations. These are not hidden behind a claim of exhaustive specification compliance.

Additional packaging work:
- Release packaging initially failed because generated registration still referenced the integration-test plugin. Regenerating release-only configuration and building with --no-pub sequentially resolved it. Do not run other Flutter dependency-refresh commands concurrently with Android packaging.
- Added tools/build-preview.ps1 for sequential analysis, unit/widget tests, optional emulator integration, release generation and artifact hashing. Its PowerShell syntax was checked; the corresponding build/test commands were executed individually during this milestone.
- Removed dependency-added broad READ_EXTERNAL_STORAGE and READ_MEDIA_* permissions. Photo/document selection uses picker-granted access; imported media lives in private app storage, and OpenFilex's private-path branch uses FileProvider grants. ACCESS_NETWORK_STATE is retained by the native media player dependency; no INTERNET permission is present in the release manifest.

Final verification and artifact:
- Source analysis: no issues.
- Unit/widget suite: 30 tests passed (milestone-8-tests.log).
- Android native integration: 1 test passed on Android 16 / API 36 x86_64 emulator (milestone-8-integration.log).
- Optimized release-mode build: succeeded after permission minimization (milestone-8-build-release.log).
- APK signature: verified with APK Signature Scheme v2; one 2048-bit RSA development-key signer (milestone-8-signature.log).
- Release manifest: API 24 minimum, API 36 target, ARM32/ARM64/x86_64; no INTERNET, READ_EXTERNAL_STORAGE or READ_MEDIA_* permissions (milestone-8-permissions.log).
- Final APK installed successfully and launched with Status: ok. Emulator cold-launch TotalTime was 1514 ms; this is one emulator observation, not a phone performance guarantee (milestone-8-release-launch.log).
- Artifact: dist/Priority-Planner-1.0.0-preview.apk
- Size: 75228421 bytes.
- SHA-256: 95d1170a30c612cdc306347fdf0e845cb6c534c08d32e14de152eb6f87b5dde5
- Checksum file: dist/SHA256SUMS.txt
- Installation and outstanding phone checks: docs/phone-acceptance.md.

The eight planned development milestones have reached an installable preview. Physical-phone acceptance and production signing/publication remain explicitly separate from this handover.
