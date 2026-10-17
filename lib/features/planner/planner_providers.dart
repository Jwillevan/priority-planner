import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../data/repositories/planner_repository.dart';
import '../../domain/planner_models.dart';
import 'note_session.dart';

final plannerRepositoryProvider = Provider<PlannerRepository>(
  (ref) => PlannerRepository(ref.watch(databaseProvider)),
);

final dailyTasksProvider = StreamProvider.autoDispose.family<List<PlannerTaskItem>, String>(
  (ref, day) => ref.watch(plannerRepositoryProvider).watchTasks(DateTime.parse(day)),
);

final dailyAppointmentsProvider = StreamProvider.autoDispose.family<List<PlannerAppointmentItem>, String>(
  (ref, day) => ref.watch(plannerRepositoryProvider).watchAppointments(DateTime.parse(day)),
);

// Intentionally retained for this app session: switching dates must not discard
// unsaved drafts after a storage failure. Binary/media content is never cached here.
final noteSessionProvider = Provider.family<NoteSession, String>((ref, day) {
  final session = NoteSession(ref.watch(plannerRepositoryProvider), day);
  ref.onDispose(session.dispose);
  return session;
});
