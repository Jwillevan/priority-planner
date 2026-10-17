// Literal, parameterized SQLite statements used by the repository. The local
// Python checks execute these same statements, not a second SQL implementation.
class PlannerSql {
  static const tasksForDay = '''
SELECT * FROM planner_tasks WHERE planned_day = ? ORDER BY priority, position, id
''';
  static const appointmentsForDay = '''
SELECT * FROM appointments WHERE start_at < ? AND end_at > ? ORDER BY all_day DESC, start_at, id
''';
  static const insertTask = '''
INSERT INTO planner_tasks
(id,title,description,planned_day,original_day,priority,position,status,delegate_name,created_at,updated_at,completed_at)
VALUES (?,?,?,?,?,?,?,?,?,?,?,?)
''';
  static const updateTask = '''
UPDATE planner_tasks SET title=?,description=?,priority=?,position=?,status=?,delegate_name=?,updated_at=?,completed_at=? WHERE id=?
''';
  static const moveTask = '''
UPDATE planner_tasks SET planned_day=?,position=?,status='forwarded',updated_at=?,completed_at=NULL WHERE id=?
''';
  static const reorderTask = '''
UPDATE planner_tasks SET position=?,updated_at=? WHERE id=?
''';
  static const history = '''
INSERT INTO task_status_history (id,task_id,from_status,to_status,from_day,to_day,changed_at,operation_id)
VALUES (?,?,?,?,?,?,?,?)
''';
  static const insertAppointment = '''
INSERT INTO appointments (id,title,description,start_at,end_at,all_day,created_at,updated_at)
VALUES (?,?,?,?,?,?,?,?)
''';
  static const updateAppointment = '''
UPDATE appointments SET title=?,description=?,start_at=?,end_at=?,all_day=?,updated_at=? WHERE id=?
''';
  static const readNote = '''
SELECT content FROM daily_notes WHERE day=?
''';
  static const saveNote = '''
INSERT INTO daily_notes (day,content,updated_at) VALUES (?,?,?)
ON CONFLICT(day) DO UPDATE SET content=excluded.content,updated_at=excluded.updated_at
''';
}
