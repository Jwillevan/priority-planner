class Lesson {
  const Lesson(
    this.id,
    this.title,
    this.why,
    this.steps, {
    this.target,
    this.advanced = false,
    this.future = false,
  });
  final String id, title, why;
  final List<String> steps;
  final String? target;
  final bool advanced, future;
}

const lessons = <Lesson>[
  Lesson(
    'welcome',
    'Welcome to Top 9/Priority Planner',
    'Planning begins with deciding what matters.',
    [
      'Use this separate practice planner. Changes here never enter your personal planner.',
      'Choose Next after trying a lesson. Completion means you reviewed it; actions are not graded.',
    ],
  ),
  Lesson(
    'layout',
    'Understanding the two-page daily layout',
    'Keeping commitments and records side by side makes daily review easier.',
    [
      'Planning holds tasks and appointments. Notes holds your daily record.',
      'On wide screens both pages appear together. On phones use the labeled tabs.',
    ],
    target: 'pages',
  ),
  Lesson(
    'navigation',
    'Moving between planner pages',
    'Reviewing yesterday and planning tomorrow keeps work connected.',
    [
      'Select Notes, then Planning, or swipe horizontally.',
      'Use Previous day, Next day, Today, or the printed date to choose a day.',
    ],
    target: 'date',
  ),
  Lesson(
    'add-task',
    'Adding your first task',
    'A concrete action is easier to start than a vague intention.',
    [
      'Tap Add task. Enter “Prepare project outline”.',
      'Choose priority A and Save.',
    ],
    target: 'task',
  ),
  Lesson(
    'edit-task',
    'Editing a task',
    'Keep the task wording useful as circumstances change.',
    [
      'Tap a task description.',
      'Change its description, add details, and Save.',
    ],
    target: 'task',
  ),
  Lesson(
    'abc',
    'Understanding A, B, and C priorities',
    'Urgency alone should not decide how you spend your day.',
    [
      'A means vital. B means important. C means optional or lower priority.',
      'Edit a task to change its priority. Choose a priority based on consequences and values.',
    ],
    target: 'task',
  ),
  Lesson(
    'numbering',
    'Numbering tasks A1, A2, B1, etc.',
    'A sequence tells you what to do first within each priority.',
    [
      'Add two A tasks and one B task. The list numbers each group automatically.',
      'Slide a task using its drag handle to change its order. Drop it below the A, B, or C heading to change priority; the list renumbers automatically.',
    ],
    target: 'task',
  ),
  Lesson(
    'complete',
    'Marking a task completed',
    'An honest record of results makes review valuable.',
    [
      'Open the symbol at the left of a task.',
      'Select ✓ Completed. Its text is crossed out and the completion summary updates.',
    ],
    target: 'task',
  ),
  Lesson(
    'symbols',
    'Understanding task tracking symbols',
    'Priority measures importance; status records what happened.',
    [
      '○ Not started; ◐ In progress; ✓ Completed.',
      '→ Forwarded leaves a record on the original day and an open task on the new day; ↗ Delegated records a handoff (enter the first name in the task editor); × Canceled keeps the record.',
      'Forwarding never marks a task complete. Open its editor to review history.',
    ],
    target: 'task',
  ),
  Lesson(
    'add-appointment',
    'Creating an appointment',
    'Appointments reserve time; tasks describe outcomes.',
    [
      'Tap Add appointment and enter “Project discussion”.',
      'Set a start and later end time, or choose All day, then Save. Overlapping appointments are allowed.',
    ],
    target: 'appointment',
  ),
  Lesson(
    'edit-appointment',
    'Editing an appointment',
    'A trustworthy schedule reflects current commitments.',
    [
      'Tap an appointment in the list above the hourly schedule.',
      'Change its time or title and Save. Delete removes that appointment.',
    ],
    target: 'appointment',
  ),
  Lesson(
    'notes',
    'Writing daily notes',
    'A short daily record preserves decisions and lessons.',
    [
      'Select Notes. Type “Agreed to review the outline tomorrow”.',
      'Wait for Saved on this device. If saving fails, stay on the page and retry Save notes.',
    ],
    target: 'pages',
  ),
  Lesson(
    'journal',
    'Creating a journal entry',
    'Formal entries give reflections a title and a place in your history.',
    [
      'Open Journal from the planner index and choose New entry, or create one from the daily Notes page.',
      'Enter a title, date and rich text. Add category, tags or related records, then Save entry. Daily notes remain separate.',
    ],
  ),
  Lesson(
    'photo',
    'Attaching a photo',
    'A picture can preserve context that words miss.',
    [
      'Save and reopen a journal entry. Expand Photos, documents & voice and choose Take photo or Choose photos.',
      'The app keeps its own copy. Tap a thumbnail to view it. Use Attachment actions to rename, caption, reorder or remove it.',
    ],
  ),
  Lesson(
    'document',
    'Attaching a document',
    'Keeping supporting material with a record makes it easier to revisit.',
    [
      'In a saved journal entry, expand Photos, documents & voice and choose Attach files. Select one or more documents.',
      'Compatible Android applications will open supported files; internal previews are not guaranteed.',
    ],
  ),
  Lesson(
    'voice',
    'Recording a voice entry',
    'Voice can capture thoughts when typing is inconvenient.',
    [
      'In a saved journal entry, choose Record voice, then Start recording. Allow microphone access when asked.',
      'Pause or Resume as needed, then Stop and Save recording, or Discard. Tap saved audio for playback and seeking. No transcription is included.',
    ],
  ),
  Lesson(
    'history',
    'Finding previous journal entries',
    'Reviewing records helps you learn from past choices.',
    [
      'Open Journal to browse newest entries first. Use Search journal or Browse dates / date range to find older entries.',
      'Tap an entry to read or edit it. Daily Notes also lists entries associated with that date.',
    ],
  ),
  Lesson(
    'forward',
    'Carrying unfinished tasks forward',
    'Review a task’s value before recommitting your time.',
    [
      'Open a task’s status symbol and select → Forwarded.',
      'Choose a different date. The task appears there as Not started, with a separate Forwarded record left on the original day. For bulk review, use Review unfinished tasks in Daily review, select tasks, choose an action and confirm.',
    ],
    target: 'task',
  ),
  Lesson(
    'review',
    'Reviewing the day',
    'Review makes tomorrow’s plan more realistic.',
    [
      'Check your completion summary and review unfinished tasks.',
      'Complete, delegate, cancel, forward, or leave each task on its original date. Record a lesson in Notes.',
    ],
    target: 'task',
  ),
  Lesson(
    'tomorrow',
    'Planning tomorrow',
    'Choosing a few priorities in advance gives the next day direction.',
    [
      'Select Next day and add one vital task.',
      'Return with Today. Your real planner is unchanged by these practice exercises.',
    ],
    target: 'date',
  ),
  Lesson(
    'weekly',
    'Weekly planning',
    'A weekly view connects daily work to broader responsibilities.',
    [
      'Open Calendar and select Week. Edit period priorities, goals/roles and review; schedule a master task into a daily plan.',
      'Review roles, choose weekly outcomes, and place actions into daily plans.',
    ],
    advanced: true,
  ),
  Lesson(
    'monthly',
    'Monthly planning',
    'Looking ahead reveals deadlines and capacity.',
    [
      'Open Calendar and select Month. Use Previous/Next period or the date heading to browse months and years; select a date for Top 9/Daily Planning.',
      'Review important dates, monthly goals and a master task list.',
    ],
    advanced: true,
  ),
  Lesson(
    'roles',
    'Personal roles',
    'Roles remind you of responsibilities beyond immediate work.',
    [
      'Open Goals and use Add role. Describe your responsibilities, then connect goals to a role.',
      'Examples: colleague, parent, friend and learner. Choose actions that reflect your commitments.',
    ],
    advanced: true,
  ),
  Lesson(
    'goals',
    'Long-term goals',
    'A goal becomes practical when connected to next actions.',
    [
      'Open Goals and choose Add goal. Set a short/long horizon and optional target date; add milestones and link daily tasks.',
      'Define an outcome, a target date and milestones, then link tasks.',
    ],
    advanced: true,
  ),
  Lesson(
    'delegate',
    'Task delegation',
    'Delegation records a handoff while retaining accountability.',
    [
      'Select ↗ Delegated from a task’s status menu.',
      'Record the person and follow-up agreement in task details. Delegation does not mean completed.',
    ],
    advanced: true,
    target: 'task',
  ),
  Lesson(
    'recurrence',
    'Recurring tasks',
    'Repeated commitments deserve a predictable review.',
    [
      'In Calendar choose Add recurring item. Define a daily, weekly or monthly template, then Preview and confirm occurrences for the displayed period.',
      'Generation is explicit and duplicate-safe. Disable a template to stop future generation; existing tasks stay editable.',
    ],
    advanced: true,
  ),
  Lesson(
    'search',
    'Search and filtering',
    'Retrieving a record makes it useful beyond the day it was written.',
    [
      'The help library search works now: search lesson titles and text.',
      'Journal search covers titles, text, dates, categories, tags and saved related-item titles. Exact category/tag filters and calendar date ranges narrow results. Audio/document content indexing is not included.',
    ],
    advanced: true,
  ),
  Lesson(
    'backup',
    'Backups',
    'A separate backup protects against losing your device.',
    [
      'Leave practice and open Settings. Choose Export encrypted backup and enter a password of at least 8 characters twice.',
      'Choose a destination in the Android document picker. Keep the password safely; it cannot be recovered. Backups include all records and media within the stated storage limits.',
    ],
    advanced: true,
  ),
  Lesson(
    'restore',
    'Restoring backups',
    'A restore must protect both existing records and imported data.',
    [
      'In Settings choose Validate and restore backup, select a .ppbackup file, and enter its password.',
      'Review the validated record/file counts and choose Keep current planner or Replace with backup. App lock and notifications must be re-enabled after restore.',
    ],
    advanced: true,
  ),
  Lesson(
    'privacy',
    'Privacy settings',
    'Knowing where information lives helps you make informed choices.',
    [
      'The planner uses local app storage without an account or analytics.',
      'Settings offers device authentication and encrypted backups. App lock uses biometrics or device PIN and locks on backgrounding. The working database and media are not encrypted. Local reminders need notification permission and may be delayed by Android.',
    ],
    advanced: true,
  ),
  Lesson(
    'customize',
    'Customizing the planner',
    'The schedule should match the hours you actually use.',
    [
      'Tap Schedule hours beside APPOINTMENT SCHEDULE. Choose start/end hours and Save.',
      'The ivory paper layout follows device text scaling. More visual customization is planned.',
    ],
    advanced: true,
    target: 'appointment',
  ),
];
