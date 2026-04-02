import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/event_role_model.dart';
import '../data/repositories/role_repository.dart';
import 'event_provider.dart';
import 'access_control_provider.dart';

final roleRepositoryProvider = Provider<RoleRepository>((ref) {
  return _GuardedRoleRepository(ref, FirebaseRoleRepository());
});

final rolesStreamProvider = StreamProvider<List<EventRoleModel>>((ref) {
  final eventId = ref.watch(currentEventIdProvider);
  if (eventId == null) return Stream.value([]);
  return ref.watch(roleRepositoryProvider).getRoles(eventId);
});

final rolesForEventStreamProvider = StreamProvider.family<List<EventRoleModel>, String>((ref, eventId) {
  return ref.watch(roleRepositoryProvider).getRoles(eventId);
});

class _GuardedRoleRepository implements RoleRepository {
  final Ref _ref;
  final RoleRepository _delegate;

  _GuardedRoleRepository(this._ref, this._delegate);

  Future<void> _require(String eventId, ModuleAccessLevel required) async {
    final access = await _ref.read(moduleAccessForEventFutureProvider((eventId: eventId, module: EventModules.roles)).future);
    if (!hasAtLeastAccess(access, required)) {
      throw StateError('No permission to manage roles');
    }
  }

  @override
  Stream<List<EventRoleModel>> getRoles(String eventId) => _delegate.getRoles(eventId);

  @override
  Future<void> addRole(EventRoleModel role) async {
    await _require(role.eventId, ModuleAccessLevel.edit);
    return _delegate.addRole(role);
  }

  @override
  Future<void> updateRole(EventRoleModel role) async {
    await _require(role.eventId, ModuleAccessLevel.edit);
    return _delegate.updateRole(role);
  }

  @override
  Future<void> deleteRole({required String eventId, required String roleId}) async {
    await _require(eventId, ModuleAccessLevel.full);
    return _delegate.deleteRole(eventId: eventId, roleId: roleId);
  }
}
