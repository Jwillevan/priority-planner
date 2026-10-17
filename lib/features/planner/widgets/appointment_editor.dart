import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/planner_models.dart';
import '../planner_providers.dart';

Future<PlannerUndo?> showAppointmentEditor(BuildContext context, DateTime day,
    {PlannerAppointmentItem? appointment, int hour = 9}) => showDialog<PlannerUndo>(
  context: context, barrierDismissible: false,
  builder: (context) => _AppointmentEditor(day: day, appointment: appointment, hour: hour),
);

class _AppointmentEditor extends ConsumerStatefulWidget {
  const _AppointmentEditor({required this.day, required this.hour, this.appointment});
  final DateTime day;
  final int hour;
  final PlannerAppointmentItem? appointment;
  @override
  ConsumerState<_AppointmentEditor> createState() => _AppointmentEditorState();
}

class _AppointmentEditorState extends ConsumerState<_AppointmentEditor> {
  final _form = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.appointment?.title ?? '');
  late final _description = TextEditingController(text: widget.appointment?.description ?? '');
  late DateTime _start = widget.appointment?.start ?? DateTime(widget.day.year, widget.day.month, widget.day.day, widget.hour);
  late DateTime _end = widget.appointment?.end ?? DateTime(widget.day.year, widget.day.month, widget.day.day, widget.hour + 1);
  late bool _allDay = widget.appointment?.allDay ?? false;
  bool _saving = false;
  String? _error;

  @override
  void dispose() { _title.dispose(); _description.dispose(); super.dispose(); }

  Future<void> _pick(bool start, bool date) async {
    final current = start ? _start : _end;
    DateTime? picked;
    if (date) {
      final day = await showDatePicker(context: context, initialDate: current,
        firstDate: DateTime(1900), lastDate: DateTime(2200, 12, 31));
      if (day != null) picked = DateTime(day.year, day.month, day.day, current.hour, current.minute);
    } else {
      final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(current));
      if (time != null) picked = DateTime(current.year, current.month, current.day, time.hour, time.minute);
    }
    if (picked != null && mounted) setState(() { if (start) { _start = picked!; } else { _end = picked!; } });
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    // All-day uses an exclusive midnight end; the UI edits the inclusive day.
    final start = _allDay ? DateTime(_start.year, _start.month, _start.day) : _start;
    final end = _allDay ? DateTime(_end.year, _end.month, _end.day + 1) : _end;
    if (!end.isAfter(start)) {
      setState(() => _error = 'End must be after start. For overnight appointments, choose the next end date.');
      return;
    }
    setState(() { _saving = true; _error = null; });
    try {
      final undo = await ref.read(plannerRepositoryProvider).saveAppointment(
        existing: widget.appointment, title: _title.text, description: _description.text,
        start: start, end: end, allDay: _allDay);
      if (mounted) Navigator.of(context).pop(undo);
    } catch (error) {
      if (mounted) setState(() {
        _saving = false;
        _error = error is PlannerConflict ? error.message : 'Appointment could not be saved. Your entered text is kept here. Check storage and try again.';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.appointment?.allDay == true) {
      final end = widget.appointment!.end;
      _end = DateTime(end.year, end.month, end.day - 1);
    }
  }

  Widget _dateControls(bool start) {
    final time = start ? _start : _end;
    final label = start ? 'Start' : 'End';
    final localizations = MaterialLocalizations.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: Theme.of(context).textTheme.titleSmall),
      Wrap(spacing: 8, children: [
        TextButton.icon(onPressed: _saving ? null : () => _pick(start, true),
          icon: const Icon(Icons.calendar_today_outlined),
          label: Text('$label date: ${localizations.formatCompactDate(time)}')),
        if (!_allDay) TextButton.icon(onPressed: _saving ? null : () => _pick(start, false),
          icon: const Icon(Icons.schedule), label: Text('$label time: ${localizations.formatTimeOfDay(TimeOfDay.fromDateTime(time), alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context))}')),
      ]),
    ]);
  }

  @override
  Widget build(BuildContext context) => PopScope(canPop: !_saving, child: AlertDialog(
    title: Text(widget.appointment == null ? 'Add appointment' : 'Edit appointment'),
    content: SizedBox(width: 480, child: SingleChildScrollView(child: Form(key: _form,
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextFormField(controller: _title, autofocus: true, enabled: !_saving,
          decoration: const InputDecoration(labelText: 'Appointment'),
          validator: (value) => value == null || value.trim().isEmpty ? 'Enter a title.' : null),
        const SizedBox(height: 16),
        TextFormField(controller: _description, enabled: !_saving, minLines: 2, maxLines: 5,
          decoration: const InputDecoration(labelText: 'Description (optional)')),
        SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('All day'),
          value: _allDay, onChanged: _saving ? null : (value) => setState(() => _allDay = value)),
        _dateControls(true),
        _dateControls(false),
        if (_allDay) const Text('End date is the last included day.'),
        if (_error != null) Padding(padding: const EdgeInsets.only(top: 16), child:
          Semantics(liveRegion: true, child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)))),
      ])))),
    actions: [
      TextButton(onPressed: _saving ? null : () => Navigator.of(context).pop(), child: const Text('Cancel')),
      FilledButton(onPressed: _saving ? null : _save, child: Text(_saving ? 'Saving…' : 'Save appointment')),
    ],
  ));
}
