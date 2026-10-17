import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/planner_models.dart';
import '../planner_providers.dart';

Future<PlannerUndo?> showTaskEditor(BuildContext context, DateTime day, {PlannerTaskItem? task, TaskStatus? initialStatus}) =>
    showDialog<PlannerUndo>(context: context, barrierDismissible: false,
      builder: (context) => _TaskEditor(day: day, task: task, initialStatus: initialStatus));

class _TaskEditor extends ConsumerStatefulWidget {
  const _TaskEditor({required this.day, this.task, this.initialStatus});
  final DateTime day;
  final PlannerTaskItem? task;
  final TaskStatus? initialStatus;
  @override
  ConsumerState<_TaskEditor> createState() => _TaskEditorState();
}

class _TaskEditorState extends ConsumerState<_TaskEditor> {
  final _form = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.task?.title ?? '');
  late final _description = TextEditingController(text: widget.task?.description ?? '');
  late final _delegate = TextEditingController(text: widget.task?.delegateName ?? '');
  late String _priority = widget.task?.priority ?? 'B';
  late TaskStatus _status = widget.initialStatus ?? widget.task?.status ?? TaskStatus.notStarted;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _delegate.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() { _saving = true; _error = null; });
    try {
      final undo = await ref.read(plannerRepositoryProvider).saveTask(
        existing: widget.task, day: widget.day, title: _title.text,
        description: _description.text, priority: _priority, status: _status,
        delegateName: _delegate.text,
      );
      if (mounted) Navigator.of(context).pop(undo);
    } catch (error) {
      if (mounted) setState(() {
        _saving = false;
        _error = error is PlannerConflict ? error.message : 'Task could not be saved. Your entered text is kept here. Check storage and try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_saving,
    child: AlertDialog(
      title: Text(widget.task == null ? 'Add task' : 'Edit task'),
      content: SizedBox(width: 480, child: SingleChildScrollView(
        child: Form(key: _form, child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(controller: _title, autofocus: true, enabled: !_saving,
            decoration: const InputDecoration(labelText: 'Task'),
            textCapitalization: TextCapitalization.sentences,
            validator: (value) => value == null || value.trim().isEmpty ? 'Enter a task.' : null),
          const SizedBox(height: 16),
          TextFormField(controller: _description, enabled: !_saving, minLines: 2, maxLines: 5,
            decoration: const InputDecoration(labelText: 'Details (optional)')),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(initialValue: _priority, isExpanded: true,
            decoration: const InputDecoration(labelText: 'Priority'),
            items: const [
              DropdownMenuItem(value: 'A', child: Text('A · Vital')),
              DropdownMenuItem(value: 'B', child: Text('B · Important')),
              DropdownMenuItem(value: 'C', child: Text('C · Optional')),
            ], onChanged: _saving ? null : (value) => setState(() => _priority = value!)),
          const SizedBox(height: 16),
          DropdownButtonFormField<TaskStatus>(initialValue: _status, isExpanded: true,
            decoration: const InputDecoration(labelText: 'Status'),
            items: [for (final status in TaskStatus.values)
              DropdownMenuItem(value: status, child: Text('${status.symbol} ${status.label}'))],
            onChanged: _saving ? null : (value) => setState(() => _status = value!)),
          if (_status == TaskStatus.delegated) ...[
            const SizedBox(height: 16),
            TextFormField(controller: _delegate, enabled: !_saving,
              decoration: const InputDecoration(labelText: 'Delegated to'),
              validator: (value) => value == null || value.trim().isEmpty ? 'Enter a person or team.' : null),
          ],
          if (_error != null) Padding(padding: const EdgeInsets.only(top: 16),
            child: Semantics(liveRegion: true, child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)))),
        ])),
      )),
      actions: [
        TextButton(onPressed: _saving ? null : () => Navigator.of(context).pop(), child: const Text('Cancel')),
        FilledButton(onPressed: _saving ? null : _save, child: Text(_saving ? 'Saving…' : 'Save task')),
      ],
    ),
  );
}
