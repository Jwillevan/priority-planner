import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/planner_models.dart';
import '../../../shared/widgets/paper_page.dart';
import '../note_session.dart';
import '../planner_providers.dart';

class DailyNotesPage extends ConsumerStatefulWidget {
  const DailyNotesPage({super.key, required this.day});
  final DateTime day;
  @override
  ConsumerState<DailyNotesPage> createState() => _DailyNotesPageState();
}

class _DailyNotesPageState extends ConsumerState<DailyNotesPage> with WidgetsBindingObserver {
  final _text = TextEditingController();
  final _undo = UndoHistoryController();
  late final NoteSession _session;
  bool _applying = false;

  @override
  void initState() {
    super.initState();
    _session = ref.read(noteSessionProvider(plannerDay(widget.day)));
    _session.addListener(_syncDraft);
    _text.addListener(_textChanged);
    WidgetsBinding.instance.addObserver(this);
    _syncDraft();
  }

  void _syncDraft() {
    if (_text.text != _session.value.text) {
      _applying = true;
      _text.text = _session.value.text;
      _applying = false;
    }
  }

  void _textChanged() {
    if (!_applying && !_session.value.loading && _text.text != _session.value.text) {
      _session.update(_text.text);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) unawaited(_session.flush());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _session.removeListener(_syncDraft);
    _text.dispose();
    _undo.dispose();
    super.dispose();
  }

  void _clear() {
    final previous = _text.text;
    _text.clear();
    final session = _session;
    final revision = session.revision;
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(SnackBar(
      content: const Text('Daily notes cleared'),
      action: SnackBarAction(label: 'Undo', onPressed: () {
        if (session.revision != revision) {
          if (messenger.mounted) messenger.showSnackBar(const SnackBar(
            content: Text('Notes changed after clearing. Use Undo notes edit to undo your latest edits.')));
          return;
        }
        session.update(previous);
      }),
    ));
  }

  @override
  Widget build(BuildContext context) => PaperPage(ruled: true,
    child: ValueListenableBuilder<NoteDraft>(valueListenable: _session,
      builder: (context, draft, child) => ListView(
        key: PageStorageKey('notes-scroll-${plannerDay(widget.day)}'),
        children: [
          Text('Daily Record', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: 8, children: [
            Semantics(liveRegion: true, child: Text(draft.error != null
              ? (draft.loading ? 'Notes could not be loaded.' : 'Not saved · draft kept in this session')
              : draft.loading ? 'Loading notes…' : draft.saving ? 'Saving…' : 'Saved on this device')),
            if (draft.error != null) TextButton.icon(onPressed: _session.retry,
              icon: const Icon(Icons.refresh), label: const Text('Retry')),
            ValueListenableBuilder<UndoHistoryValue>(valueListenable: _undo,
              builder: (context, history, child) => IconButton(
                tooltip: 'Undo notes edit', onPressed: history.canUndo ? _undo.undo : null,
                icon: const Icon(Icons.undo))),
            IconButton(tooltip: 'Clear daily notes',
              onPressed: draft.loading || draft.text.isEmpty ? null : _clear,
              icon: const Icon(Icons.delete_outline)),
          ]),
          const SizedBox(height: 16),
          if (draft.loading && draft.error == null) const LinearProgressIndicator(),
          if (!draft.loading) TextField(controller: _text, undoController: _undo,
            minLines: 12, maxLines: null, keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(height: 1.8, color: Theme.of(context).colorScheme.onSurface),
            decoration: const InputDecoration(labelText: 'Daily notes',
              hintText: 'Write your thoughts, observations, and daily record…',
              alignLabelWithHint: true, border: InputBorder.none)),
          const SizedBox(height: 16),
          const Text('Quick daily notes are separate from formal journal entries.'),
        ],
      ),
    ),
  );
}
