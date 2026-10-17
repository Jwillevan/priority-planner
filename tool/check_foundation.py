"""Executable foundation checks against the actual schema.drift SQL.

These verify SQLite DDL and static Android configuration only. They do not
substitute for Drift code generation, Flutter tests, or Android device tests.
Run: python tool/check_foundation.py
"""
from pathlib import Path
import sqlite3
import tempfile
import unittest
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
SCHEMA = (ROOT / "lib/data/database/schema.drift").read_text(encoding="utf-8")
ANDROID = "{http://schemas.android.com/apk/res/android}"


def open_database(path=":memory:"):
    connection = sqlite3.connect(path)
    connection.execute("PRAGMA foreign_keys = ON")
    connection.executescript(SCHEMA)
    return connection


def task(db, task_id="task", priority="B", position=0):
    db.execute(
        "INSERT INTO planner_tasks "
        "(id,title,planned_day,original_day,priority,position,created_at,updated_at) "
        "VALUES (?, 'Write proposal', '2026-10-12', '2026-10-12', ?, ?, 1, 1)",
        (task_id, priority, position),
    )


def journal(db, entry_id="journal"):
    db.execute(
        "INSERT INTO journal_entries (id,entry_day,title,created_at,updated_at) "
        "VALUES (?, '2026-10-12', 'Reflection', 1, 1)", (entry_id,)
    )


def attachment(db, relative_path="media/photo.jpg", entry_id="journal", attachment_id="photo"):
    db.execute(
        "INSERT INTO journal_attachments "
        "(id,entry_id,kind,display_name,relative_path,mime_type,size_bytes,created_at) "
        "VALUES (?, ?, 'image', 'Photo', ?, 'image/jpeg', 200, 1)",
        (attachment_id, entry_id, relative_path),
    )


class SchemaChecks(unittest.TestCase):
    def setUp(self):
        self.db = open_database()

    def tearDown(self):
        self.db.close()

    def test_all_foundation_entities_exist(self):
        expected = {
            "personal_roles", "personal_values", "goals", "goal_milestones",
            "planner_tasks", "task_status_history", "appointments", "daily_notes",
            "journal_entries", "journal_tags", "journal_entry_tags", "journal_task_links",
            "journal_appointment_links", "journal_attachments", "pending_file_deletions",
            "weekly_plans", "weekly_plan_goals", "monthly_plans", "monthly_plan_goals",
            "reminders", "app_settings", "tutorial_progress",
        }
        actual = {row[0] for row in self.db.execute("SELECT name FROM sqlite_master WHERE type='table'")}
        self.assertEqual(expected, actual)
        self.assertEqual([], list(self.db.execute("PRAGMA foreign_key_check")))

    def test_abc_priority_and_position_ordering(self):
        for task_id, priority, position in [("c1", "C", 0), ("a2", "A", 1), ("b1", "B", 0), ("a1", "A", 0)]:
            task(self.db, task_id, priority, position)
        ids = [row[0] for row in self.db.execute("SELECT id FROM planner_tasks ORDER BY priority, position, id")]
        self.assertEqual(["a1", "a2", "b1", "c1"], ids)

    def test_invalid_priority_and_negative_position_rejected(self):
        with self.assertRaises(sqlite3.IntegrityError):
            task(self.db, priority="D")
        with self.assertRaises(sqlite3.IntegrityError):
            task(self.db, position=-1)

    def test_completion_timestamp_consistent_with_status(self):
        task(self.db)
        with self.assertRaises(sqlite3.IntegrityError):
            self.db.execute("UPDATE planner_tasks SET status='completed'")
        self.db.execute("UPDATE planner_tasks SET status='completed', completed_at=2, updated_at=2")
        with self.assertRaises(sqlite3.IntegrityError):
            self.db.execute("UPDATE planner_tasks SET status='forwarded'")
        self.db.execute("UPDATE planner_tasks SET status='forwarded', completed_at=NULL")
        self.assertIsNone(self.db.execute("SELECT completed_at FROM planner_tasks").fetchone()[0])

    def test_operation_ids_and_recurring_occurrences_are_unique(self):
        task(self.db)
        insert = "INSERT INTO task_status_history VALUES (?, 'task', 'not_started', 'forwarded', '2026-10-12', '2026-10-13', 2, 'operation')"
        self.db.execute(insert, ("history1",))
        with self.assertRaises(sqlite3.IntegrityError):
            self.db.execute(insert, ("history2",))
        self.db.execute("UPDATE planner_tasks SET recurrence_series_id='series', occurrence_day='2026-10-12'")
        task(self.db, "task2")
        with self.assertRaises(sqlite3.IntegrityError):
            self.db.execute("UPDATE planner_tasks SET recurrence_series_id='series', occurrence_day='2026-10-12' WHERE id='task2'")

    def test_appointment_requires_positive_duration_but_allows_overlap(self):
        insert = "INSERT INTO appointments (id,title,start_at,end_at,created_at,updated_at) VALUES (?, 'Meeting', ?, ?, 1, 1)"
        with self.assertRaises(sqlite3.IntegrityError):
            self.db.execute(insert, ("invalid", 2, 1))
        self.db.execute(insert, ("first", 1, 5))
        self.db.execute(insert, ("second", 2, 6))
        self.assertEqual(2, self.db.execute("SELECT count(*) FROM appointments").fetchone()[0])

    def test_deleting_task_keeps_linked_journal(self):
        task(self.db)
        journal(self.db)
        self.db.execute("INSERT INTO journal_task_links VALUES ('journal', 'task')")
        self.db.execute("DELETE FROM planner_tasks WHERE id='task'")
        self.assertEqual(1, self.db.execute("SELECT count(*) FROM journal_entries").fetchone()[0])
        self.assertEqual(0, self.db.execute("SELECT count(*) FROM journal_task_links").fetchone()[0])

    def test_orphan_attachments_rejected(self):
        with self.assertRaises(sqlite3.IntegrityError):
            attachment(self.db)

    def test_paths_reject_traversal_and_external_locations(self):
        journal(self.db)
        for unsafe in ["../photo.jpg", "/media/photo.jpg", "media/../photo.jpg", "media/..\\photo.jpg", "C:\\photo.jpg", "media/file:stream"]:
            with self.subTest(path=unsafe), self.assertRaises(sqlite3.IntegrityError):
                attachment(self.db, unsafe)
        attachment(self.db, "media/photo.jpg")

    def test_journal_cascade_queues_media_deletion(self):
        journal(self.db)
        attachment(self.db)
        self.db.execute("DELETE FROM journal_entries WHERE id='journal'")
        self.assertEqual(0, self.db.execute("SELECT count(*) FROM journal_attachments").fetchone()[0])
        self.assertEqual("media/photo.jpg", self.db.execute("SELECT relative_path FROM pending_file_deletions").fetchone()[0])

    def test_goal_deletion_does_not_delete_tasks(self):
        self.db.execute("INSERT INTO goals (id,title,created_at,updated_at) VALUES ('goal','Learn',1,1)")
        task(self.db)
        self.db.execute("UPDATE planner_tasks SET goal_id='goal'")
        self.db.execute("DELETE FROM goals WHERE id='goal'")
        self.assertEqual((None,), self.db.execute("SELECT goal_id FROM planner_tasks").fetchone())

    def test_multiple_journals_per_day_and_case_insensitive_tags(self):
        journal(self.db, "first")
        journal(self.db, "second")
        self.assertEqual(2, self.db.execute("SELECT count(*) FROM journal_entries").fetchone()[0])
        self.db.execute("INSERT INTO journal_tags VALUES ('t1','Work')")
        with self.assertRaises(sqlite3.IntegrityError):
            self.db.execute("INSERT INTO journal_tags VALUES ('t2','work')")

    def test_settings_and_records_survive_sqlite_reopen(self):
        with tempfile.TemporaryDirectory() as directory:
            path = str(Path(directory) / "planner.sqlite")
            with open_database(path) as first:
                task(first)
                journal(first)
                first.execute("INSERT INTO app_settings VALUES ('theme','dark',1)")
            first.close()
            with sqlite3.connect(path) as second:
                self.assertEqual("dark", second.execute("SELECT value FROM app_settings").fetchone()[0])
                self.assertEqual(1, second.execute("SELECT count(*) FROM planner_tasks").fetchone()[0])
                self.assertEqual(1, second.execute("SELECT count(*) FROM journal_entries").fetchone()[0])
                self.assertEqual("ok", second.execute("PRAGMA integrity_check").fetchone()[0])

    def test_transaction_failure_rolls_back(self):
        with self.assertRaises(sqlite3.IntegrityError), self.db:
            task(self.db)
            attachment(self.db)
        self.assertEqual(0, self.db.execute("SELECT count(*) FROM planner_tasks").fetchone()[0])


class AndroidConfigurationChecks(unittest.TestCase):
    def test_xml_files_are_well_formed(self):
        files = list((ROOT / "android/app/src").rglob("*.xml"))
        self.assertTrue(files)
        for file in files:
            with self.subTest(file=file):
                ET.parse(file)

    def test_no_permissions_in_foundation_manifest(self):
        manifest = ET.parse(ROOT / "android/app/src/main/AndroidManifest.xml").getroot()
        self.assertEqual([], manifest.findall("uses-permission"))
        application = manifest.find("application")
        self.assertEqual("false", application.get(ANDROID + "allowBackup"))
        self.assertEqual("Priority Planner", application.get(ANDROID + "label"))
        activity = application.find("activity")
        self.assertEqual("true", activity.get(ANDROID + "exported"))
        debug = ET.parse(ROOT / "android/app/src/debug/AndroidManifest.xml").getroot()
        self.assertEqual(
            ["android.permission.INTERNET"],
            [permission.get(ANDROID + "name") for permission in debug.findall("uses-permission")],
        )


if __name__ == "__main__":
    print(f"SQLite {sqlite3.sqlite_version}; source: {ROOT / 'lib/data/database/schema.drift'}")
    unittest.main(verbosity=2)
