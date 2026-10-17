import 'dart:collection';

String plannerDay(DateTime day) =>
    '${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';

enum TaskStatus {
  notStarted('not_started', 'Not started', '○'),
  inProgress('in_progress', 'In progress', '◐'),
  completed('completed', 'Completed', '✓'),
  forwarded('forwarded', 'Forwarded', '→'),
  delegated('delegated', 'Delegated', '↗'),
  canceled('canceled', 'Canceled', '×');

  const TaskStatus(this.code, this.label, this.symbol);
  final String code;
  final String label;
  final String symbol;

  static TaskStatus fromCode(String code) =>
      values.firstWhere((status) => status.code == code);
}

class PlannerTaskItem {
  PlannerTaskItem(Map<String, Object?> row)
      : row = UnmodifiableMapView(Map<String, Object?>.from(row));
  final Map<String, Object?> row;
  String get id => row['id']! as String;
  String get title => row['title']! as String;
  String get description => row['description']! as String;
  String get priority => row['priority']! as String;
  int get position => row['position']! as int;
  String get day => row['planned_day']! as String;
  String get originalDay => row['original_day']! as String;
  String get delegateName => row['delegate_name']! as String;
  TaskStatus get status => TaskStatus.fromCode(row['status']! as String);
  bool get isUnfinished => status != TaskStatus.completed && status != TaskStatus.canceled;
}

/// Display numbering is derived from sorted rows, independently in each group.
Map<String, String> taskRankings(List<PlannerTaskItem> tasks) {
  final ordered = [...tasks]..sort((a, b) {
      final priority = a.priority.compareTo(b.priority);
      if (priority != 0) return priority;
      final position = a.position.compareTo(b.position);
      return position != 0 ? position : a.id.compareTo(b.id);
    });
  final counts = <String, int>{};
  return {
    for (final task in ordered)
      task.id: '${task.priority}${counts.update(task.priority, (n) => n + 1, ifAbsent: () => 1)}',
  };
}

class PlannerAppointmentItem {
  PlannerAppointmentItem(Map<String, Object?> row)
      : row = UnmodifiableMapView(Map<String, Object?>.from(row));
  final Map<String, Object?> row;
  String get id => row['id']! as String;
  String get title => row['title']! as String;
  String get description => row['description']! as String;
  DateTime get start => DateTime.fromMillisecondsSinceEpoch(row['start_at']! as int);
  DateTime get end => DateTime.fromMillisecondsSinceEpoch(row['end_at']! as int);
  bool get allDay => row['all_day'] == 1;
}

class PlannerConflict implements Exception {
  const PlannerConflict([this.message = 'This record changed. Reload it before trying again.']);
  final String message;
  @override
  String toString() => message;
}

/// Session-local, one-shot undo. It refuses to overwrite newer edits.
class PlannerUndo {
  PlannerUndo(this.label, this._restore);
  final String label;
  final Future<void> Function() _restore;
  bool _used = false;
  bool _running = false;

  Future<void> undo() async {
    if (_used || _running) throw const PlannerConflict('This action has already been undone.');
    _running = true;
    try {
      await _restore();
      _used = true;
    } finally {
      _running = false;
    }
  }
}
