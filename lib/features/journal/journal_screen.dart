import '../media/attachment_panel.dart';
import '../media/attachment_store.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import '../../data/database.dart';
import '../../app/theme.dart';

Future<void> openJournalEditor(
  BuildContext context,
  PlannerDatabase db, {
  JournalEntry? entry,
  String? day,
}) => Navigator.of(context).push<void>(
  MaterialPageRoute(
    builder: (_) => JournalEditor(db: db, entry: entry, initialDay: day),
  ),
);

class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});
  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  String query = '', category = '', tag = '', attachmentKind = '';
  String? from, to;
  Future<void> dateRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
      initialDateRange: from == null
          ? null
          : DateTimeRange(
              start: DateTime.parse(from!),
              end: DateTime.parse(to!),
            ),
    );
    if (range != null && mounted) {
      setState(() {
        from = dayKey(range.start);
        to = dayKey(range.end);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Journal',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Journal help',
                    icon: const Icon(Icons.help_outline),
                    onPressed: () => showDialog<void>(
                      context: context,
                      builder: (context) => const AlertDialog(
                        title: Text('Your daily journal'),
                        content: Text(
                          'Create titled entries with rich text, tags and related tasks or appointments. Save before leaving the editor. Daily notes remain separate. Search covers text and linked item titles captured when linked. Open a saved entry to add photos, documents or voice recordings.',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Search journal'),
                onChanged: (s) => setState(() => query = s),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Category (exact)',
                      ),
                      onChanged: (s) => setState(() => category = s.trim()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Tag (exact)',
                      ),
                      onChanged: (s) => setState(() => tag = s.trim()),
                    ),
                  ),
                ],
              ),
              DropdownButton<String>(
                isExpanded: true,
                value: attachmentKind,
                items: const [
                  DropdownMenuItem(
                    value: '',
                    child: Text('All attachment types'),
                  ),
                  DropdownMenuItem(value: 'photo', child: Text('With photos')),
                  DropdownMenuItem(
                    value: 'document',
                    child: Text('With documents'),
                  ),
                  DropdownMenuItem(
                    value: 'audio',
                    child: Text('With voice recordings'),
                  ),
                ],
                onChanged: (v) => setState(() => attachmentKind = v!),
              ),
              Wrap(
                spacing: 12,
                children: [
                  TextButton(
                    onPressed: dateRange,
                    child: Text(
                      from == null
                          ? 'Browse dates / date range'
                          : '$from – $to',
                    ),
                  ),
                  if (from != null)
                    TextButton(
                      onPressed: () => setState(() {
                        from = null;
                        to = null;
                      }),
                      child: const Text('All dates'),
                    ),
                  FilledButton.icon(
                    onPressed: () => openJournalEditor(context, db),
                    icon: const Icon(Icons.add),
                    label: const Text('New entry'),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<JournalEntry>>(
            stream: db.watchJournal(
              query: query,
              attachmentKind: attachmentKind,
              category: category,
              tag: tag,
              fromDay: from,
              toDay: to,
            ),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Journal could not be loaded. Check storage and retry.',
                  ),
                );
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final entries = snapshot.data!;
              if (entries.isEmpty) {
                return const Center(
                  child: Text(
                    'No entries match. Create an entry or adjust your filters.',
                  ),
                );
              }
              return ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, i) {
                  final entry = entries[i];
                  return Material(
                    color: paper,
                    child: ListTile(
                      title: Text(entry.title),
                      subtitle: Text(
                        '${entry.day} • ${entry.category}\n${entry.plainText.trim()}',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      isThreeLine: true,
                      onTap: () => openJournalEditor(context, db, entry: entry),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class JournalEditor extends StatefulWidget {
  const JournalEditor({
    required this.db,
    this.entry,
    this.initialDay,
    super.key,
  });
  final PlannerDatabase db;
  final JournalEntry? entry;
  final String? initialDay;
  @override
  State<JournalEditor> createState() => _JournalEditorState();
}

class _JournalEditorState extends State<JournalEditor> {
  late final title = TextEditingController(text: widget.entry?.title ?? '');
  late final category = TextEditingController(
    text: widget.entry?.category ?? '',
  );
  late final tags = TextEditingController(
    text: widget.entry == null
        ? ''
        : (jsonDecode(widget.entry!.tagsJson) as List).join(', '),
  );
  late String day =
      widget.entry?.day ?? widget.initialDay ?? dayKey(DateTime.now());
  late quill.QuillController editor;
  late final mediaStore = AttachmentStore(widget.db);
  final focus = FocusNode();
  final scroll = ScrollController();
  bool dirty = false,
      busy = false,
      loading = true,
      allowExit = false,
      damaged = false;
  String? error;
  List<PlannerTask> tasks = [];
  List<Appointment> appointments = [];
  Map<String, int?> linkedTasks = {}, linkedAppointments = {};
  @override
  void initState() {
    super.initState();
    try {
      editor = quill.QuillController(
        document: widget.entry == null
            ? quill.Document()
            : quill.Document.fromJson(jsonDecode(widget.entry!.delta) as List),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } catch (_) {
      damaged = true;
      editor = quill.QuillController.basic();
      error = 'This entry has invalid rich text. Return without saving to preserve its data.';
    }
    editor.addListener(changed);
    title.addListener(changed);
    category.addListener(changed);
    tags.addListener(changed);
    load();
  }

  void changed() {
    if (mounted && !dirty) setState(() => dirty = true);
  }

  Future<void> load() async {
    try {
      tasks = await widget.db.select(widget.db.plannerTasks).get();
      appointments = await widget.db.select(widget.db.appointments).get();
      if (widget.entry != null) {
        final a = await widget.db.journalTasks(widget.entry!.id);
        final b = await widget.db.journalAppointments(widget.entry!.id);
        linkedTasks = {for (final l in a) l.label: l.taskId};
        linkedAppointments = {for (final l in b) l.label: l.appointmentId};
      }
      if (mounted) setState(() => loading = false);
    } catch (_) {
      if (mounted) {
        setState(
          () =>
              error = 'Related records could not be loaded. Return and retry.',
        );
      }
    }
  }

  @override
  void dispose() {
    editor.removeListener(changed);
    editor.dispose();
    title.dispose();
    category.dispose();
    tags.dispose();
    focus.dispose();
    scroll.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (title.text.trim().isEmpty) {
      setState(() => error = 'Enter an entry title.');
      return;
    }
    setState(() => busy = true);
    editor.readOnly = true;
    try {
      await widget.db.saveJournal(
        id: widget.entry?.id,
        day: day,
        title: title.text,
        delta: jsonEncode(editor.document.toDelta().toJson()),
        category: category.text,
        tags: tags.text.split(','),
        tasks: const {},
        appointments: const {},
        retainedTasks: linkedTasks,
        retainedAppointments: linkedAppointments,
      );
      if (mounted) {
        setState(() {
          dirty = false;
          allowExit = true;
        });
        Navigator.pop(context);
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => error = 'Entry could not be saved. Your edits are still here; please retry.',
        );
      }
    } finally {
      if (mounted) {
        editor.readOnly = false;
        setState(() => busy = false);
      }
    }
  }

  Future<void> leave() async {
    if (busy) return;
    if (!dirty) {
      setState(() => allowExit = true);
      Navigator.pop(context);
      return;
    }
    final discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard unsaved journal changes?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep editing'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    if (discard == true && mounted) {
      setState(() => allowExit = true);
      Navigator.pop(context);
    }
  }

  Future<void> remove() async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this journal entry?'),
        content: const Text(
          'This removes the entry and its links. Tasks and appointments are kept.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep entry'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete entry'),
          ),
        ],
      ),
    );
    if (yes != true || !mounted) return;
    setState(() => busy = true);
    editor.readOnly = true;
    try {
      await widget.db.deleteJournal(widget.entry!.id);
      try {
        await mediaStore.cleanup();
      } catch (_) {
        /* Retry unused-file cleanup from Settings. */
      }
      if (mounted) {
        setState(() => allowExit = true);
        Navigator.pop(context);
      }
    } catch (_) {
      if (mounted) setState(() => error = 'Deletion failed. Please retry.');
    } finally {
      if (mounted) {
        editor.readOnly = false;
        setState(() => busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: allowExit,
    onPopInvokedWithResult: (didPop, result) {
      if (!didPop) leave();
    },
    child: Scaffold(
      backgroundColor: paper,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back to journal',
          onPressed: leave,
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          widget.entry == null ? 'New journal entry' : 'Edit journal entry',
        ),
        actions: [
          if (widget.entry != null)
            IconButton(
              tooltip: 'Delete journal entry',
              onPressed: busy || loading ? null : remove,
              icon: const Icon(Icons.delete_outline),
            ),
          TextButton(
            onPressed: busy || loading || damaged ? null : save,
            child: Text(busy ? 'Saving…' : 'Save entry'),
          ),
        ],
      ),
      body: Column(
        children: [
          Flexible(
            flex: 2,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  controller: title,
                  enabled: !busy,
                  decoration: const InputDecoration(labelText: 'Entry title'),
                ),
                TextButton(
                  onPressed: busy
                      ? null
                      : () async {
                          final value = await showDatePicker(
                            context: context,
                            initialDate: DateTime.parse(day),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2200),
                          );
                          if (value != null && mounted) {
                            setState(() {
                              day = dayKey(value);
                              dirty = true;
                            });
                          }
                        },
                  child: Text('Entry date: $day'),
                ),
                if (widget.entry != null)
                  Text(
                    'Created ${widget.entry!.createdAt.toLocal()}\nModified ${widget.entry!.updatedAt.toLocal()}',
                  ),
                TextField(
                  controller: category,
                  enabled: !busy,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                TextField(
                  controller: tags,
                  enabled: !busy,
                  decoration: const InputDecoration(
                    labelText: 'Tags (comma separated)',
                  ),
                ),
                ExpansionTile(
                  title: Text('Related tasks (${linkedTasks.length})'),
                  children: [
                    for (final item in linkedTasks.entries.toList())
                      ListTile(
                        title: Text(item.key),
                        subtitle: item.value == null
                            ? const Text(
                                'Original task removed; reference preserved',
                              )
                            : null,
                        trailing: IconButton(
                          tooltip: 'Unlink task',
                          onPressed: busy
                              ? null
                              : () => setState(() {
                                  linkedTasks.remove(item.key);
                                  dirty = true;
                                }),
                          icon: const Icon(Icons.link_off),
                        ),
                      ),
                    for (final t in tasks.where(
                      (t) => !linkedTasks.values.contains(t.id),
                    ))
                      ListTile(
                        title: Text('${t.day} • ${t.title}'),
                        trailing: IconButton(
                          tooltip: 'Link task',
                          onPressed: busy
                              ? null
                              : () => setState(() {
                                  linkedTasks['${t.id}: ${t.title}'] = t.id;
                                  dirty = true;
                                }),
                          icon: const Icon(Icons.add_link),
                        ),
                      ),
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    'Related appointments (${linkedAppointments.length})',
                  ),
                  children: [
                    for (final item in linkedAppointments.entries.toList())
                      ListTile(
                        title: Text(item.key),
                        subtitle: item.value == null
                            ? const Text(
                                'Original appointment removed; reference preserved',
                              )
                            : null,
                        trailing: IconButton(
                          tooltip: 'Unlink appointment',
                          onPressed: busy
                              ? null
                              : () => setState(() {
                                  linkedAppointments.remove(item.key);
                                  dirty = true;
                                }),
                          icon: const Icon(Icons.link_off),
                        ),
                      ),
                    for (final a in appointments.where(
                      (a) => !linkedAppointments.values.contains(a.id),
                    ))
                      ListTile(
                        title: Text('${a.day} • ${a.title}'),
                        trailing: IconButton(
                          tooltip: 'Link appointment',
                          onPressed: busy
                              ? null
                              : () => setState(() {
                                  linkedAppointments['${a.id}: ${a.title}'] =
                                      a.id;
                                  dirty = true;
                                }),
                          icon: const Icon(Icons.add_link),
                        ),
                      ),
                  ],
                ),
                if (widget.entry != null)
                  AttachmentPanel(
                    db: widget.db,
                    entryId: widget.entry!.id,
                    store: mediaStore,
                  )
                else
                  const Text(
                    'Save this entry, then reopen it to add photos, documents or voice. Attachments save immediately.',
                  ),
                if (loading) const Text('Loading related records…'),
                if (error != null)
                  Text(
                    error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
              ],
            ),
          ),
          quill.QuillSimpleToolbar(
            controller: editor,
            config: const quill.QuillSimpleToolbarConfig(
              multiRowsDisplay: false,
              showFontFamily: false,
              showFontSize: false,
              showColorButton: false,
              showBackgroundColorButton: false,
              showSearchButton: false,
              showLink: false,
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: quill.QuillEditor(
                controller: editor,
                focusNode: focus,
                scrollController: scroll,
                config: const quill.QuillEditorConfig(
                  placeholder: 'Write your journal entry…',
                  padding: EdgeInsets.all(8),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
