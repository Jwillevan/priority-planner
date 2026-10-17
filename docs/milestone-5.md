# Milestone 5 — Multimedia Journal

Implemented photos from camera/gallery, multiple file import, app-managed file copies, thumbnails, zoomable photo viewing, display names/captions/metadata, reorder/remove controls, Android-compatible external document opening, and voice recording/playback. Media controls are available after saving and reopening an entry. Attachment mutations save immediately and are explicitly labeled as independent from unsaved journal text edits.

Recording begins only with Start recording and runtime microphone permission. Controls support pause, resume, stop, explicit save and discard. AAC-LC in M4A is requested. App-background transitions pause active recording. Playback includes play/pause, seeking and duration. Permission/plugin/file/storage failures report retry guidance. No document internal-preview or transcription claim is made.

Schema version 4 adds JournalAttachments metadata and cascading entry references. Binary files use generated UUID filenames in application support storage; imported source paths are not retained. Guarded path resolution rejects traversal and symbolic file links. Import failure removes its partial copy. Removal tolerates already-missing files. Deleting an entry triggers orphan cleanup. Practice media uses a distinct temporary root shared for that practice database and removed when the tutorial closes.

Journal search now includes attachment display names/captions and filters for photos, documents or voice. No indexing of document or audio contents is included. Multimedia help lessons now describe working controls.

Created:
- lib/features/media/attachment_store.dart
- lib/features/media/attachment_panel.dart
- lib/features/media/recorder_port.dart
- test/media_test.dart
- docs/milestone-5.md

Changed:
- lib/data/database.dart and generated database.g.dart
- lib/features/journal/journal_screen.dart
- lib/features/help/help_screen.dart and lessons.dart
- lib/app/app.dart
- android/app/src/main/AndroidManifest.xml (microphone permission declaration)
- pubspec.yaml and pubspec.lock
- test/journal_test.dart (legacy migration fixture)
- README.md

Validation results appended below. Media tests use temporary storage and fake audio data/recorder; they do not validate real image decoding, microphone hardware, AAC encoding or Android permission dialogs.

Remaining limitations:
- The Android NDK build blocker remains; actual camera/gallery/file provider, secure external opening, microphone, device interruption, audio seek and low-storage behavior need device validation. No APK was produced in this milestone.
- Save an entry before attaching media; attachments are independently persisted. Existing-entry deletion removes attachments, while discarding text edits keeps attachment operations that already saved.
- Android process death during camera picking is not yet recovered through image_picker.retrieveLostData. Process termination during recording can leave a draft file; orphan cleanup currently runs after entry deletion rather than on every launch.
- Cleanup failure after database deletion can leave unused files for a later cleanup; no record points outside app-managed storage. Full media/database encryption is not implemented.
- Phone-call/audio-focus interruptions beyond background pausing require device validation. Mock recording tests verify control sequencing rather than native codec behavior.
- Files selected through Attach files use document handling, even if their extension is an image. Photo thumbnails are provided for imports through the photo controls.

Next milestone: Milestone 6 — weekly/monthly planning, goals, roles and recurring tasks.

Final verification: flutter analyze reported no issues; the full flutter test suite passed all 15 tests. Media tests cover source-independent copies and reopen persistence, rename/reorder, attachment-name search/type filtering, removal/orphan cleanup, traversal rejection, missing-file failures, and mocked microphone permission/recording controls. Output is saved in milestone-5-tests.log. Native Android media behavior and APK verification remain untested.
