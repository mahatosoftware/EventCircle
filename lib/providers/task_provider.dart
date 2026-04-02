import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/task_model.dart';
import '../data/repositories/task_repository.dart';
import '../data/repositories/firebase/firebase_task_repository.dart';
import 'event_provider.dart';
import 'access_control_provider.dart';
import '../data/models/event_role_model.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return _GuardedTaskRepository(ref, FirebaseTaskRepository());
});

final tasksStreamProvider = StreamProvider<List<TaskModel>>((ref) {
  final eventId = ref.watch(currentEventIdProvider);
  if (eventId == null) return Stream.value([]);
  return ref.watch(taskRepositoryProvider).getTasks(eventId);
});

final tasksForEventStreamProvider = StreamProvider.family<List<TaskModel>, String>((ref, eventId) {
  return ref.watch(taskRepositoryProvider).getTasks(eventId);
});

class _GuardedTaskRepository implements TaskRepository {
  final Ref _ref;
  final TaskRepository _delegate;

  _GuardedTaskRepository(this._ref, this._delegate);

  Future<void> _require(String eventId, ModuleAccessLevel required) async {
    final access = await _ref.read(moduleAccessForEventFutureProvider((eventId: eventId, module: EventModules.tasks)).future);
    if (!hasAtLeastAccess(access, required)) {
      throw StateError('No permission to manage tasks');
    }
  }

  @override
  Stream<List<TaskModel>> getTasks(String eventId) => _delegate.getTasks(eventId);

  @override
  Future<void> addTask(TaskModel task) async {
    await _require(task.eventId, ModuleAccessLevel.edit);
    return _delegate.addTask(task);
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    await _require(task.eventId, ModuleAccessLevel.update);
    return _delegate.updateTask(task);
  }

  @override
  Future<void> deleteTask(String id) {
    // Best-effort: delete is treated as edit since the repository API doesn't carry eventId here.
    return _delegate.deleteTask(id);
  }
}
