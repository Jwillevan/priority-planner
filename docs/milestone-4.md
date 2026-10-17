# Milestone 4 — Digital Journal

Implemented:
- Multiple titled entries per day, user-selected dates, creation/modification timestamps and newest-first timeline.
- Flutter Quill rich text stored as Delta JSON, with derived searchable plain text. Formatting controls include emphasis, lists and headings in a horizontally scrollable toolbar.
- Editable categories and normalized comma-separated tags. Search covers titles, body text, dates, category, tags and saved linked-item titles. Exact category/tag filters and a calendar date-range picker narrow the timeline.
- Links to tasks and appointments across dates, with unlink controls and saved title references. SQLite foreign keys set deleted targets to null while preserving the entry and its reference label. Entry deletion cascades only link rows, leaving planning records intact.
- Daily Notes remains separate, with links to create and open formal entries for the selected day.
- Explicit journal Save, unsaved-change discard confirmation, confirmed deletion, visible load/save errors and protection against overwriting malformed rich-text records.
- Schema version 3 migration adds journal tables while preserving existing planning and tutorial data.
- Updated journal/search tutorial lessons to reflect available functionality. Multimedia lessons remain previews.

Created files:
- lib/data/journal_content.dart
- lib/features/journal/journal_screen.dart
- test/journal_test.dart
- test/journal_widget_test.dart
- docs/milestone-4.md

Changed files:
- lib/data/database.dart and generated database.g.dart
- lib/app/app.dart
- lib/features/planner/planner_screen.dart
- lib/features/help/lessons.dart
- test/widget_test.dart
- pubspec.yaml and pubspec.lock
- README.md

Dependency: Flutter Quill 11.6.0 resolved by pub (https://pub.dev/packages/flutter_quill/versions/11.6.0). No media extension or account/cloud service added. The transitive HTTP package does not implement a journal network feature; entries remain stored locally.

Tests: journal creation/editing, rich-text preservation, timestamp retention, search and filters, normalized tags, preserved deleted-appointment links, entry deletion isolation, invalid-input rollback, version 2 migration and reopen persistence; widget test exercises formatted entry save and unsaved-change protection. Existing tests cover v1 migration through the current schema, daily planner and safe tutorials. Final full-suite results appended below.

Remaining limitations:
- Photos, documents and audio are Milestone 5; there are no attachment-type filters or searches yet.
- Search uses saved related-item titles rather than live titles after later task/appointment renames. Category filter is exact and case-sensitive; tags are normalized and exact. A blank category/tag filter means all.
- Task/appointment links are context references shown in the editor; they do not navigate to separate detail screens. The available-item chooser loads existing records and is not yet paginated.
- Journal edits require Save; daily notes retain autosave. No draft recovery after process termination is claimed.
- Android device behavior, screen readers, keyboard/rotation and large text remain unverified. No APK build was rerun; missing NDK 28.2.13676358 remains the known blocker.
- No database encryption, attachment previews, audio transcription or document-content indexing is claimed.

Next: Milestone 5 — photos, documents, voice recording/playback, and attachment management.

Final verification: flutter analyze reported no issues; the full flutter test run passed all 12 tests. Output is saved in milestone-4-tests.log. Android device and APK verification were not performed.
