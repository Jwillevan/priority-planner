import 'package:flutter/material.dart';

Future<List<String>?> editPlanningText(
  BuildContext context,
  String title,
  List<String> labels,
  List<String> values, {
  Map<int, String>? choices,
  int? selected,
  String choiceLabel = 'Related goal',
}) async {
  final controllers = values
      .map((v) => TextEditingController(text: v))
      .toList();
  final result = await showDialog<List<String>>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, update) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < labels.length; i++)
                  TextField(
                    controller: controllers[i],
                    decoration: InputDecoration(labelText: labels[i]),
                    minLines: 1,
                    maxLines: i == 0 ? 2 : 4,
                  ),
                if (choices != null)
                  DropdownButton<int?>(
                    isExpanded: true,
                    value: selected,
                    hint: Text(choiceLabel),
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('None'),
                      ),
                      for (final c in choices.entries)
                        DropdownMenuItem<int?>(
                          value: c.key,
                          child: Text(c.value, overflow: TextOverflow.ellipsis),
                        ),
                    ],
                    onChanged: (v) => update(() => selected = v),
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, [
              ...controllers.map((c) => c.text),
              if (choices != null) selected?.toString() ?? '',
            ]),
            child: const Text('Save'),
          ),
        ],
      ),
    ),
  );
  await Future<void>.delayed(const Duration(milliseconds: 300));
  for (final c in controllers) {
    c.dispose();
  }
  return result;
}

Future<void> planningAction(
  BuildContext context,
  Future<void> Function() action,
) async {
  try {
    await action();
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not save. Check required fields, dates and available storage, then retry.',
          ),
        ),
      );
    }
  }
}

int planningTime(String value) {
  final parts = value.trim().split(':');
  if (parts.length != 2) throw ArgumentError('Use HH:mm');
  final hour = int.parse(parts[0]), minute = int.parse(parts[1]);
  if (hour < 0 ||
      hour > 24 ||
      minute < 0 ||
      minute > 59 ||
      (hour == 24 && minute != 0)) {
    throw ArgumentError('Invalid time');
  }
  return hour * 60 + minute;
}
