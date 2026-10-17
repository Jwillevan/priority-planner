import 'package:flutter/foundation.dart';

import '../../data/repositories/planner_repository.dart';

@immutable
class NoteDraft {
  const NoteDraft({this.text = '', this.loading = true, this.saving = false, this.error});
  final String text;
  final bool loading;
  final bool saving;
  final Object? error;
}

/// A day-scoped retained draft. Writes are serialized, including across page
/// changes. A failed write keeps the text in memory and exposes a retry.
class NoteSession extends ValueNotifier<NoteDraft> {
  NoteSession(this.repository, this.day) : super(const NoteDraft()) {
    _loading = _load();
  }

  final PlannerRepository repository;
  final String day;
  Future<void> _tail = Future.value();
  late Future<void> _loading;
  Future<void> get ready => _loading;
  bool _disposed = false;
  bool _loadingInFlight = false;
  int _revision = 0;
  int get revision => _revision;

  Future<void> _load() async {
    _loadingInFlight = true;
    if (!_disposed) value = const NoteDraft();
    try {
      final text = await repository.readNote(day);
      if (!_disposed) value = NoteDraft(text: text, loading: false);
    } catch (error) {
      if (!_disposed) value = NoteDraft(error: error);
    } finally {
      _loadingInFlight = false;
    }
  }

  void retry() {
    if (value.loading) {
      if (_loadingInFlight) return;
      _loading = _load();
    } else {
      update(value.text);
    }
  }

  void update(String text) {
    if (value.loading || _disposed) return;
    final revision = ++_revision;
    value = NoteDraft(text: text, loading: false, saving: true);
    _tail = _tail.then((_) async {
      try {
        await repository.saveNote(day, text);
        if (!_disposed && revision == _revision) {
          value = NoteDraft(text: text, loading: false);
        }
      } catch (error) {
        if (!_disposed && revision == _revision) {
          value = NoteDraft(text: text, loading: false, error: error);
        }
      }
    });
  }

  Future<void> flush() => _tail;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
