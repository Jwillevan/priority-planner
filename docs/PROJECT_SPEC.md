# PRIORITY PLANNER
## Complete Android Application Development Specification
### Version 1.0 — Initial Development

## 1. Project Overview

Create a fully functional Android application named **Priority Planner**.

The application should look, feel, and function as closely as practical to the traditional Franklin Planner Original/Classic two-page-per-day paper planner, while adding modern Android capabilities.

**Primary design objective:** When users open Priority Planner, they should feel as though they are using a traditional Franklin-style paper planner, not a generic digital task manager.

The application must combine:

- Traditional daily planning
- ABC task prioritization
- Appointment scheduling
- Daily records and notes
- Weekly and monthly planning
- Long-term goals
- Personal roles and values
- Full multimedia journaling
- Photos and document attachments
- Voice recordings
- Searchable history
- Interactive beginner and advanced tutorials
- Offline functionality
- Local backups and data protection

The application must be practical for everyday personal and professional use.

## 2. Platform and Technology

**Primary platform:** Android

**Development environment:** Windows 11

**Framework:** Flutter and Dart

Use:

- Material 3 for Android-compatible controls
- Riverpod for state management
- Drift and SQLite for structured local data
- GoRouter for navigation
- image_picker for camera and gallery
- file_picker for documents
- record for audio recording
- just_audio for audio playback
- path_provider for local file storage
- flutter_local_notifications for notifications
- local_auth for optional biometric authentication
- A compatible rich-text editor for journal entries

Use maintained, stable, compatible dependency versions.

The application must work without an internet connection.

Do not require a subscription, login, cloud account, or paid API.

Structure the project so future Windows and tablet support can be added without rewriting the core application.

## 3. Visual Design — Extremely Important

Use the traditional Franklin Planner Original/Classic two-page-per-day design as the primary reference.

Do not substitute a generic modern productivity dashboard for the traditional planner layout.

### Paper Appearance

Implement:

- Warm white or ivory paper backgrounds
- Thin, subtle horizontal writing lines
- Traditional readable typography
- Clear printed date headings
- Understated section dividers
- Subtle paper texture where appropriate
- Soft page shadows
- Page margins resembling a physical planner
- Realistic page-turn or page-slide animations
- Monthly navigation tabs
- Optional visual binder styling
- Original icons and graphics consistent with traditional paper planning

Avoid unnecessary colorful cards, oversized buttons, and distracting animations.

The interface should feel professional, calm, organized, and traditional.

Use original visual assets. Do not reproduce FranklinCovey trademarks, logos, copyrighted page artwork, or proprietary text without permission.

The application must not imply official FranklinCovey affiliation.

## 4. Traditional Two-Page Daily Layout

### Left Page — Daily Planning

Include:

**Prioritized Daily Task List**
- Task descriptions
- A, B, and C priorities
- Numbered priorities such as A1, A2, B1, and C1
- Task completion and status symbols
- Task editing and reordering
- Add Task control
- Optional task details
- Clear distinction between completed and unfinished tasks

**Appointment Schedule**
- Hourly schedule
- User-configurable start and end hours
- Appointments with start and end times
- Optional reminders
- Visual indication of current time
- Appointment creation and editing
- Support for overlapping appointments
- Optional all-day appointments

### Right Page — Daily Notes and Journal

Include:

- Traditional ruled-paper appearance
- Freeform daily notes
- Multiple journal entries
- Automatic timestamps
- Rich-text formatting
- Links to tasks and appointments
- Photos
- File attachments
- Voice recordings
- Searchable journal history

### Android Navigation

In portrait orientation:
- Display one daily page at a time
- Swipe horizontally between planning and notes
- Provide clearly labeled page navigation controls

In landscape orientation:
- Show a two-page spread when screen dimensions permit
- Otherwise retain a readable single-page layout

Allow navigation to previous and future dates.

Preserve the user's current page and scroll position when practical.

Ensure all essential features are accessible without relying solely on swipe gestures.

## 5. Traditional Task Prioritization

Support the Franklin-style ABC priority system.

- A = vital or highest-priority tasks
- B = important tasks
- C = lower-priority or optional tasks

Allow users to number tasks within their priority groups.

Examples:
- A1
- A2
- A3
- B1
- B2
- C1

Users must be able to:

- Add tasks
- Edit tasks
- Delete tasks
- Mark tasks completed
- Reorder tasks
- Change priorities
- Add descriptions
- Set dates
- Link tasks to goals
- Link tasks to journal entries
- Create recurring tasks
- Forward unfinished tasks
- Delegate tasks
- Search tasks

### Task Tracking Symbols

Include traditional-style tracking symbols for:

- Completed
- Forwarded
- Delegated
- Deleted or canceled
- In progress
- Not started

Provide an explanation of each symbol in the Startup Guide.

Store task status separately from task priority.

Do not treat forwarding a task as completing it.

## 6. Carry-Forward System

When tasks remain unfinished, allow users to review them and decide what happens next.

Options:

- Carry forward to tomorrow
- Carry forward to another date
- Keep on original date
- Mark completed
- Cancel
- Delegate

Allow individual and bulk actions.

Never automatically duplicate tasks without user approval.

Maintain task history so users can see when tasks were originally created and moved.

Prevent duplicate carry-forward operations.

## 7. Daily Planning Features

Provide:

- Daily task list
- Appointment schedule
- Daily notes
- Task completion summary
- Daily review
- Previous and next day navigation
- Quick task creation
- Quick appointment creation
- Searchable historical records

Support planning future dates.

Past dates must remain accessible and editable.

## 8. Weekly Planning

Include a traditional-style weekly planning system.

Features:

- Weekly overview
- Weekly priorities
- Weekly goals
- Personal roles
- Tasks connected to goals
- Weekly review
- Unfinished task review
- Ability to move tasks into daily plans

Allow users to define personal roles, such as work, family, personal development, and other custom categories.

## 9. Monthly Planning

Include:

- Monthly calendar
- Monthly goals
- Monthly master task list
- Important dates
- Recurring appointments
- Monthly review
- Navigation to any daily page

Provide month and year navigation.

## 10. Goals and Personal Values

Support:

- Short-term goals
- Long-term goals
- Personal roles
- Personal values
- Goal descriptions
- Target dates
- Milestones
- Linked tasks
- Progress tracking
- Goal completion
- Archived goals

Goals should connect naturally to weekly and daily planning.

## 11. Full Digital Journal

The journal is a core feature of Version 1.0.

It must support:

- Multiple entries per day
- Unlimited entries subject to available storage
- Entry titles
- Rich-text content
- Creation timestamps
- Modification timestamps
- User-selected dates
- Categories
- Tags
- Links to tasks
- Links to appointments
- Search
- Editing
- Deletion
- Chronological history
- Calendar-based browsing

Journal entries must remain available even after their associated tasks are completed or deleted.

Keep quick daily notes and formal journal entries as distinct but connected features.

## 12. Photos

Allow users to:

- Take photos using the Android camera
- Select photos from the gallery
- Attach multiple photos to a journal entry
- View image thumbnails
- Open full-screen photos
- Remove photos
- Add captions
- View attachment dates
- Reorder attachments

Store imported photos in application-managed storage.

Avoid relying on temporary Android file paths.

## 13. File Attachments

Support common document types, including:

- PDF
- TXT
- DOCX
- XLSX
- JPG
- PNG
- Other files supported by Android

Allow:

- Importing files
- Multiple attachments per entry
- Renaming attachment display names
- Opening files through compatible Android applications
- Removing attachments
- Viewing file metadata

Do not claim every file type can be previewed internally.

Use Android's secure file-selection and sharing mechanisms.

## 14. Voice Journal

Implement audio recording directly within the journal.

Features:

- Start recording
- Pause recording
- Resume recording
- Stop recording
- Save recording
- Rename recording
- Playback
- Playback seeking
- Recording duration
- Multiple recordings per entry
- Delete recording

Use a reliable Android-supported audio format.

Request microphone permission only when recording is initiated.

Handle interruptions, denied permissions, and failed recordings gracefully.

Do not record audio without an explicit user action.

## 15. Journal Search and History

Provide search across:

- Journal titles
- Journal text
- Dates
- Categories
- Tags
- Related tasks
- Related appointments
- Attachment filenames

Allow filtering by:

- Date range
- Entry type
- Attachment type
- Category
- Tag

Include a chronological timeline.

Do not promise searching inside audio or document contents until transcription or document indexing is implemented.

## 16. Built-In Startup Guide — Required

The application must include a comprehensive beginner-friendly Startup Guide.

On first launch, offer:

**Start Tutorial** or **Skip for Now**.

The tutorial must be accessible later through Help & Tutorials.

### Beginner Lessons

1. Welcome to Priority Planner
2. Understanding the two-page daily layout
3. Moving between planner pages
4. Adding your first task
5. Editing a task
6. Understanding A, B, and C priorities
7. Numbering tasks A1, A2, B1, etc.
8. Marking a task completed
9. Understanding task tracking symbols
10. Creating an appointment
11. Editing an appointment
12. Writing daily notes
13. Creating a journal entry
14. Attaching a photo
15. Attaching a document
16. Recording a voice entry
17. Finding previous journal entries
18. Carrying unfinished tasks forward
19. Reviewing the day
20. Planning tomorrow

### Advanced Lessons

- Weekly planning
- Monthly planning
- Personal roles
- Long-term goals
- Task delegation
- Recurring tasks
- Search and filtering
- Backups
- Restoring backups
- Privacy settings
- Customizing the planner

### Tutorial Requirements

- Step-by-step instructions
- Highlight relevant interface controls
- Provide simple examples
- Allow users to repeat lessons
- Track lesson completion
- Provide Next, Back, Skip, and Restart controls
- Offer a searchable help library
- Include contextual help icons

Use a separate practice environment or safe sample data so tutorials cannot accidentally damage actual planner information.

Explain not only how buttons work, but also why the traditional planning methods are useful.

## 17. Privacy and Security

The app must be offline-first.

Requirements:

- No required accounts
- No advertising
- No third-party analytics SDKs
- No unnecessary internet permissions
- Optional biometric application lock
- Secure handling of media attachments
- User-controlled export
- User-controlled deletion
- Encrypted backups
- Protection against unsafe file paths
- Clear explanations of data storage

Do not claim full database or media encryption at rest unless it is implemented and verified.

## 18. Backup and Restore

Users must be able to export a complete backup containing:

- Tasks
- Appointments
- Goals
- Journal entries
- Photos
- Documents
- Voice recordings
- Settings

Backups must include a manifest and version information.

Restore operations must validate backup integrity before replacing existing data.

Handle missing or corrupted files safely.

Offer backup encryption with a user-provided password.

Never silently overwrite existing planner information.

## 19. Notifications

Support optional local reminders for:

- Appointments
- Scheduled tasks
- Daily planning
- Daily review
- Recurring events

Allow notifications to be enabled or disabled.

Respect Android notification permissions and scheduling limitations.

Do not require internet access for local reminders.

## 20. Accessibility

The app must support:

- Readable text sizes
- Android text scaling
- Screen readers
- Large touch targets
- Adequate contrast
- Clear labels
- Accessible task status controls
- Reduced-motion preferences
- Navigation without swipe-only gestures

Preserve the paper-planner aesthetic without sacrificing usability.

## 21. Database Architecture

Use Drift with SQLite.

Suggested entities:

- PlannerTask
- TaskStatusHistory
- Appointment
- DailyNote
- JournalEntry
- JournalAttachment
- JournalTag
- JournalEntryTag
- Goal
- GoalMilestone
- PersonalRole
- WeeklyPlan
- MonthlyPlan
- Reminder
- AppSettings
- TutorialProgress

Use stable IDs and foreign-key relationships.

Store binary media files separately from the database.

Use safe schema migrations.

Maintain referential integrity and clean up unused attachment files.

## 22. Application Navigation

Primary sections:

- Daily Planner
- Calendar
- Journal
- Goals
- Help & Tutorials
- Settings

The Daily Planner should be the default opening screen.

Use traditional planner-style tabs and page navigation where practical.

Avoid a cluttered dashboard.

## 23. Testing Requirements

Create automated tests for:

- Priority sorting
- Task numbering
- Task status changes
- Carry-forward behavior
- Recurring tasks
- Appointment validation
- Journal creation and editing
- Journal search
- Photo attachment persistence
- Document attachment persistence
- Audio recording lifecycle
- Database migrations
- Backup creation
- Backup restore
- Tutorial progress
- Accessibility
- App restart persistence

Also test:

- Denied permissions
- Missing files
- Low storage
- Device rotation
- Large text settings
- Interrupted audio recording
- Corrupted backups

Do not claim a test passed unless it actually ran successfully.

## 24. Development Milestones

### Milestone 1 — Foundation
- Create Flutter project
- Configure Android
- Set up project architecture
- Configure database
- Configure navigation
- Implement paper-inspired visual theme

### Milestone 2 — Classic Daily Planner
- Two-page daily layout
- ABC tasks
- Task tracking symbols
- Appointment schedule
- Daily notes
- Date navigation

### Milestone 3 — Startup Guide
- First-launch tutorial
- Interactive beginner lessons
- Practice mode
- Help library
- Tutorial progress

### Milestone 4 — Digital Journal
- Rich-text journal entries
- Categories and tags
- Search
- Timeline
- Task and appointment linking

### Milestone 5 — Multimedia
- Photos
- Documents
- Voice recording
- Playback
- Attachment management

### Milestone 6 — Long-Term Planning
- Weekly planning
- Monthly planning
- Goals
- Personal roles
- Recurring tasks

### Milestone 7 — Privacy and Reliability
- Optional app lock
- Encrypted backup and restore
- Notifications
- Data integrity improvements

### Milestone 8 — Testing and Release
- Unit tests
- Widget tests
- Integration tests
- Android device testing
- Performance improvements
- Generate installable APK

## 25. Instructions for Codex

Work incrementally and maintain a functional application throughout development.

Start by inspecting the development environment and determining whether Flutter and Android SDK tools are installed.

If required software is missing, explain the installation steps clearly.

Do not assume access to tools, permissions, or environments that have not been verified.

Create the project structure before implementing advanced features.

Prioritize the traditional Franklin-style daily planner appearance and the beginner tutorial.

Do not replace the traditional two-page planner with a generic task dashboard.

After each milestone:

1. Summarize what was implemented.
2. List files created or changed.
3. Report tests actually executed.
4. Explain any remaining issues.
5. Identify the next development milestone.

Use maintainable, documented code.

Do not add paid services, subscriptions, cloud synchronization, or AI features to the initial release.

Provide clear instructions for running the app on an Android device and producing an APK.

**Begin with Milestone 1. Do not attempt to implement all eight milestones in one step.**
