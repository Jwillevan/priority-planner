# Dependency and Android compatibility status

## Verification limit

Flutter, Dart, Android SDK, adb, and Gradle are absent from the development
workspace. Java 21 is installed. The configured HTTP proxy refused connections
when fetching Flutter's official stable-release metadata. Package metadata could
not be accessed either. **Current latest stable versions and mutual compatibility
have not been confirmed.** No lockfile exists yet.

The authored constraints are provisional known stable release lines, not a claim
to use the latest release as of October 2026:

| Foundation dependency | Constraint | Purpose |
| --- | --- | --- |
| Dart | >=3.9.0 <4.0.0 | Language baseline |
| Flutter | >=3.35.0 | Material 3 and current widget APIs used by source |
| flutter_riverpod | ^3.0.3 | Providers and persistent preferences |
| drift / drift_dev | ^2.28.2, matched | SQL schema and generation |
| go_router | ^16.2.4 | Retained navigation branches |
| path_provider | ^2.1.5 | Application support directory |
| path | ^1.9.1 | Portable path construction |
| sqlite3_flutter_libs | ^0.5.40 | Native SQLite plugin for this Drift release line |
| uuid | ^4.5.1 | Stable task, appointment and history IDs |
| build_runner | ^2.7.1 | Code generation |
| flutter_lints | ^6.0.0 | Static analysis |

Before marking milestone 1 complete:

1. Install current Flutter stable and record `flutter --version`.
2. Run `flutter pub get` and `flutter pub outdated`.
3. Check the latest stable package release notes and minimum Flutter/Dart/Android
   requirements. Adjust constraints together. If adopting a new Drift major,
   follow its SQLite bundling guidance rather than retaining an obsolete plugin.
4. Regenerate, format, analyze, test, and build. Review the merged manifest.
5. Commit the resolved `pubspec.lock`. Network access is required for development
   downloads; the installed app's foundation does not require a network.

## Android foundation

- Authored minimum SDK 24. Compile and target SDK come from Flutter tooling.
- Authored AGP 8.9.1, Gradle 8.11.1, Kotlin 2.1.0; Java/Kotlin bytecode target 17.
  These are a provisional aligned toolchain, not a verified pairing with the
  future installed Flutter version. Update together if Flutter stable requires it.
- Android embedding v2, AndroidX, exported launcher activity, rotation enabled.
- No release runtime permissions declared. No shared/external storage access is needed
  to open the foundation database in the application support directory.
- No release INTERNET permission or cleartext-network opt-in authored. A separate
  debug manifest grants INTERNET for Flutter's VM-service sockets/hot reload;
  the planner itself has no network clients.
- XML parsed successfully, but aapt compilation, manifest merging, and APK
  installation have **not** been tested.

## Future plugins: add only after preflight

Multimedia/privacy packages are deliberately not installed ahead of their
milestones. Select current mutually compatible stable versions then, verify on
Android, and add permission code alongside its feature.

| Feature/package | Required Android preflight |
| --- | --- |
| Rich-text editor (e.g. flutter_quill) | Flutter baseline, localization, JSON format, accessible toolbar, text scaling; no network image embeds by default |
| image_picker | Platform picker/camera requirements, process-death lost-data recovery, managed copies; avoid broad storage permissions |
| file_picker | Android Storage Access Framework, content URI handling, managed copies; no MANAGE_EXTERNAL_STORAGE |
| Document opener | Secure FileProvider/content URI and temporary read grant; choose a maintained opener or platform channel |
| record | Android supported AAC/M4A encoder, pause/resume, interruption behavior; RECORD_AUDIO requested only after pressing Record |
| just_audio | Local file playback/seeking, lifecycle disposal and audio focus; do not add INTERNET for local-only playback |
| local_auth | Chosen plugin minimum SDK; FlutterFragmentActivity, USE_BIOMETRIC, lock on resume; this is an app lock, not storage encryption |
| flutter_local_notifications | Compile/target SDK, desugaring, Android 13 POST_NOTIFICATIONS opt-in, reboot receivers; prefer inexact schedules and respect exact-alarm restrictions |
| Encrypted backup library | Maintained authenticated encryption, secure randomness, password KDF, format limits, integrity tests and staged restore |

Do not pre-request microphone/camera/notifications at startup. Validate merged
permissions after each plugin is added. Do not claim permission flows, media,
encryption, or platform compatibility have been tested until they run on Android.
