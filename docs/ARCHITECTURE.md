# Foundation architecture

## Boundaries

`lib/app` owns Riverpod providers, GoRouter navigation, app startup, and theme.
`lib/features` owns screens. `lib/data/database` owns schema and connection.
`lib/data/repositories` is the persistence boundary for features. Settings and
daily planner repositories are implemented in source; journal operations are
future work. `lib/domain/planner_models.dart` contains immutable row views,
status definitions, derived rankings, conflicts and session-local undo actions.
`lib/shared/widgets` holds original paper rendering and section shells.

Domain logic and repositories must not import Android APIs. Platform services
(media, notifications, authentication) will sit behind injectable interfaces,
allowing future Windows/tablet support and permission/error testing.

Riverpod owns one database instance and disposes it. A background native SQLite
connection opens lazily in the application support directory. Startup checks the
connection and presents retry without wiping data on an error. Navigation uses
an indexed stateful shell to retain section state. Date navigation constructs
calendar dates, rather than adding 24 hours across daylight-saving changes.

## Data conventions

- IDs are text primary keys; future repositories should use UUID v4 (`uuid`).
- Local planner days are `YYYY-MM-DD`; month keys are `YYYY-MM`. Validate actual
  calendar dates in repositories; SQL length checks are not date validation.
- Creation/modification/event timestamps are integer UTC epoch milliseconds.
  Appointment rendering will convert them to device-local time; recurrence
  timezone/DST rules must be specified in milestone 6.
- Priority A/B/C is separate from status. `position` is a zero-based order within
a priority group; displayed A1/B1 numbers are derived, not stored separately.
- SQLite sorts A/B/C lexically. Break position ties by stable ID. Reordering and
  moving tasks are transactional in the planner repository.
- Completion timestamp is present only for `completed` status. Forwarding is not
  completion. Task history preserves original/moved days and unique operation IDs;
  the repository moves the existing ID and inserts history atomically. Repeating
  a request against a stale row is rejected rather than creating a duplicate.
- Recurrence series plus original occurrence day is unique. A recurrence generator
  has not been implemented. Do not auto-create tasks without explicit user consent.
- Journal rows are independent of task/appointment lifetimes. Deleting linked
  objects deletes their link only. Multiple journal rows per day are supported.
- Rich text is JSON and plain text is a separate future search projection. Full-
  text indexes/search and editor serialization are not implemented in milestone 1.
- Media metadata holds a unique relative `media/` path. Bytes will be copied into
  managed storage in milestone 5. Display names are separate from physical names.
- A deletion trigger queues removed attachment paths even during a journal
  cascade. A future media service must drain the durable queue and reconcile
  unreferenced files. No media filesystem cleanup runs yet.
- The path constraint rejects obvious traversal, absolute paths, Windows
  separators and drive/stream separators. File services and restore must also
  validate path segments, canonical containment, symlinks, duplicate archive
  paths, size limits and unsupported archive entries; SQL checks alone are not a
  complete file security boundary.

## Schema and migrations

`schema.drift` is the single schema source. It uses ordinary SQLite DDL, allowing
the Python foundation checks to execute the same file. Drift generates typed
table/entity declarations and creates the schema, indexes and trigger.

Schema version 1 is the first version; there is no earlier released schema and
no legitimate upgrade path to test yet. `onCreate` creates all schema objects;
`beforeOpen` enables foreign keys and checks relational integrity. Unknown version
transitions are rejected, never handled by resetting the database. Future versions
must replace the rejection only for explicitly supported transitions.

After Flutter generation succeeds, save and commit the v1 Drift schema snapshot.
For every later change:

1. Increment `schemaVersion`.
2. Add explicit migration steps, preserving records and media references.
3. Add a new schema snapshot and migration tests starting from every supported
   predecessor. Use Drift schema verification after migration.
4. Test populated old databases, invalid data, rollback on failure, foreign keys,
   and restart persistence. Keep snapshot files immutable.

Do not change v1 after it is released. Media files are outside database
transactions; later services need staged copies, rollback cleanup, a durable
deletion queue, and reconciliation after interruptions. Backups must capture a
consistent database snapshot plus its referenced files and settings. No backup
or restore implementation exists in this milestone.

## UI and accessibility

Warm ivory surfaces, thin rules, restrained green-gray ink, original book icon,
serif section headings, and page shadows form the foundation. Dark mode uses
similar understated surfaces. Wide-screen decisions include text scaling so a
two-page spread cannot force unreadably narrow pages. All pages scroll; page/date
controls have visible labels or tooltips. Reduced-motion preference disables
programmatic page animation. Tutorial practice isolation is planned for milestone 3.

Fonts use the platform fallback; no external font or artwork downloads are
required. Binder styling, month tabs, configurable schedule hours and the full
daily workflow were not part of milestone 1. Milestone 2 adds daily workflows;
configurable printed hours and month tabs remain future work. TalkBack, contrast, rotation,
very large text and real-device layout review remain unverified.

## Milestone 2: writes and undo

`PlannerSql` holds literal parameterized statements. `PlannerRepository` combines
them inside Drift transactions. Watch queries declare their source tables and
the repository notifies table updates after a successful commit. Reordering stays
inside A/B/C groups, including accessible Move up/down alternatives. Changing
priority appends to the new group; numbering is recalculated without gaps.

Edits compare the full current row to the editor's snapshot. A monotonic per-row
modification timestamp distinguishes rapid edits and device-clock rollback.
Forwarding preserves original day, ID, metadata and any recurrence identity.

Undo captures the parent plus its cascaded history/journal links/reminders. It
compares the current snapshot with the post-operation snapshot before restoring
the previous one in a transaction. Missing dependencies or constraint failures
roll back the whole restore. Undo restores prior history rather than appending a
compensating audit event. Undo actions exist only in memory and are exposed through
the latest action's snackbar; there is no persistent undo log or redo workflow.

`NoteSession` is a retained, date-scoped draft with serialized writes. A successful
older write cannot overwrite a newer draft or mark it saved. Errors remain visible,
and retry writes the retained text. The notes editor persists controller changes
including undo/programmatic edits. Clear undo checks the draft revision. Changing
pages does not dispose pending drafts; these sessions currently stay in memory
until the provider container is disposed. There is no durable recovery of failed
unsaved drafts after process termination. Future cache eviction must flush writes
and retain failed drafts safely rather than silently dropping them.

No v1 schema changes were needed for milestone 2. Connection, schema version,
foreign keys and original Android configuration remain unchanged. The app has no
new runtime permissions or network clients.
