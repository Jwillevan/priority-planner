"""Execute the repository's literal SQL against the existing v1 schema.

This verifies SQL/storage behavior only, not Dart orchestration or Flutter UI.
"""
from pathlib import Path
import re
import sqlite3
import tempfile
import unittest

from check_foundation import ROOT, open_database

SOURCE = (ROOT / 'lib/data/repositories/planner_sql.dart').read_text(encoding='utf-8')
SQL = dict(re.findall(r"static const (\w+) = '''\n(.*?)\n''';", SOURCE, re.DOTALL))


class PlannerSqlChecks(unittest.TestCase):
    def setUp(self):
        self.db = open_database()

    def tearDown(self):
        self.db.close()

    def create_task(self, task_id='task', priority='B', position=0):
        self.db.execute(SQL['insertTask'], [task_id, 'Plan', 'Details', '2026-10-12',
            '2026-10-12', priority, position, 'not_started', '', 100, 100, None])

    def test_all_repository_statements_are_present(self):
        self.assertEqual({'tasksForDay', 'appointmentsForDay', 'insertTask', 'updateTask',
            'moveTask', 'reorderTask', 'history', 'insertAppointment', 'updateAppointment',
            'readNote', 'saveNote'}, set(SQL))

    def test_task_query_sorts_by_priority_and_numbering_position(self):
        self.create_task('c', 'C', 0)
        self.create_task('a2', 'A', 1)
        self.create_task('b', 'B', 0)
        self.create_task('a1', 'A', 0)
        rows = self.db.execute(SQL['tasksForDay'], ['2026-10-12']).fetchall()
        self.assertEqual(['a1', 'a2', 'b', 'c'], [row[0] for row in rows])

    def test_task_edit_completion_and_reopening(self):
        self.create_task()
        self.db.execute(SQL['updateTask'], ['Edited', 'More', 'A', 0, 'completed', '', 101, 101, 'task'])
        row = self.db.execute("SELECT title,description,priority,status,completed_at FROM planner_tasks").fetchone()
        self.assertEqual(('Edited', 'More', 'A', 'completed', 101), row)
        self.db.execute(SQL['updateTask'], ['Edited', 'More', 'A', 0, 'not_started', '', 102, None, 'task'])
        self.assertIsNone(self.db.execute('SELECT completed_at FROM planner_tasks').fetchone()[0])

    def test_forward_sql_preserves_identity_origin_and_unfinished_state(self):
        self.create_task()
        self.db.execute(SQL['moveTask'], ['2026-10-13', 2, 101, 'task'])
        self.assertEqual([], self.db.execute(SQL['tasksForDay'], ['2026-10-12']).fetchall())
        row = self.db.execute('SELECT id,planned_day,original_day,status,completed_at FROM planner_tasks').fetchone()
        self.assertEqual(('task', '2026-10-13', '2026-10-12', 'forwarded', None), row)
        self.db.execute(SQL['history'], ['history', 'task', 'not_started', 'forwarded', '2026-10-12', '2026-10-13', 101, 'op'])
        self.assertEqual(1, self.db.execute('SELECT count(*) FROM planner_tasks').fetchone()[0])
        self.assertEqual(1, self.db.execute('SELECT count(*) FROM task_status_history').fetchone()[0])

    def test_delegate_sql_and_reorder_preserve_other_fields(self):
        self.create_task()
        self.db.execute(SQL['updateTask'], ['Plan', 'Details', 'B', 0, 'delegated', 'Sam', 101, None, 'task'])
        self.db.execute(SQL['reorderTask'], [3, 102, 'task'])
        self.assertEqual(('delegated', 'Sam', 3), self.db.execute('SELECT status,delegate_name,position FROM planner_tasks').fetchone())

    def test_appointment_edits_overlap_and_midnight_boundaries(self):
        # Integer times isolate the SQL's half-open interval convention.
        self.db.execute(SQL['insertAppointment'], ['a', 'Overnight', 'Where', 23, 25, 0, 100, 100])
        self.db.execute(SQL['insertAppointment'], ['b', 'Earlier', '', 22, 24, 0, 100, 100])
        self.assertEqual(2, len(self.db.execute(SQL['appointmentsForDay'], [24, 0]).fetchall()))
        self.assertEqual(['a'], [r[0] for r in self.db.execute(SQL['appointmentsForDay'], [48, 24])])
        self.db.execute(SQL['updateAppointment'], ['Revised', 'Description', 9, 10, 0, 101, 'a'])
        self.assertEqual(('Revised', 'Description', 9, 10), self.db.execute("SELECT title,description,start_at,end_at FROM appointments WHERE id='a'").fetchone())

    def test_invalid_appointment_duration_rejected(self):
        with self.assertRaises(sqlite3.IntegrityError):
            self.db.execute(SQL['insertAppointment'], ['a', 'Invalid', '', 10, 10, 0, 100, 100])

    def test_notes_upsert_clear_restore_and_day_isolation(self):
        for text in ['First', 'Second', '', 'Restored']:
            self.db.execute(SQL['saveNote'], ['2026-10-12', text, 100])
        self.db.execute(SQL['saveNote'], ['2026-10-13', 'Tomorrow', 100])
        self.assertEqual(('Restored',), self.db.execute(SQL['readNote'], ['2026-10-12']).fetchone())
        self.assertEqual(('Tomorrow',), self.db.execute(SQL['readNote'], ['2026-10-13']).fetchone())
        self.assertEqual(2, self.db.execute('SELECT count(*) FROM daily_notes').fetchone()[0])

    def test_changes_roll_back_when_history_insert_fails(self):
        self.create_task()
        self.db.commit()
        with self.assertRaises(sqlite3.IntegrityError), self.db:
            self.db.execute(SQL['moveTask'], ['2026-10-13', 0, 101, 'task'])
            self.db.execute(SQL['history'], ['history', 'missing', 'not_started', 'forwarded', '2026-10-12', '2026-10-13', 101, 'op'])
        self.assertEqual('2026-10-12', self.db.execute('SELECT planned_day FROM planner_tasks').fetchone()[0])

    def test_v1_data_and_new_planner_records_survive_reopen(self):
        with tempfile.TemporaryDirectory() as directory:
            path = str(Path(directory) / 'planner.sqlite')
            first = open_database(path)
            try:
                first.execute('PRAGMA user_version=1')
                first.execute("INSERT INTO app_settings VALUES ('sentinel','existing v1',1)")
                first.execute(SQL['insertTask'], ['task', 'Persist', '', '2026-10-12', '2026-10-12', 'A', 0, 'not_started', '', 100, 100, None])
                first.execute(SQL['insertAppointment'], ['a', 'Visit', 'Address', 9, 10, 0, 100, 100])
                first.execute(SQL['saveNote'], ['2026-10-12', 'Local notes', 100])
                first.commit()
            finally:
                first.close()
            second = sqlite3.connect(path)
            try:
                self.assertEqual(1, second.execute('PRAGMA user_version').fetchone()[0])
                self.assertEqual('existing v1', second.execute('SELECT value FROM app_settings').fetchone()[0])
                self.assertEqual(1, len(second.execute(SQL['tasksForDay'], ['2026-10-12']).fetchall()))
                self.assertEqual(1, len(second.execute(SQL['appointmentsForDay'], [24, 0]).fetchall()))
                self.assertEqual('Local notes', second.execute(SQL['readNote'], ['2026-10-12']).fetchone()[0])
                self.assertEqual('ok', second.execute('PRAGMA integrity_check').fetchone()[0])
            finally:
                second.close()


if __name__ == '__main__':
    unittest.main(verbosity=2)
