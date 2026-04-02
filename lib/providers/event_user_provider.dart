import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/event_user_model.dart';
import '../data/repositories/event_user_repository.dart';
import '../data/repositories/firebase/firebase_event_user_repository.dart';
import 'access_control_provider.dart';
import '../data/models/event_role_model.dart';

import 'user_provider.dart';
import 'event_provider.dart';

final eventUserRepositoryProvider = Provider<EventUserRepository>((ref) {
  return _GuardedEventUserRepository(ref, FirebaseEventUserRepository());
});

final eventUsersStreamProvider = StreamProvider.family<List<EventUserModel>, String>((ref, eventId) {
  return ref.watch(eventUserRepositoryProvider).getEventUsers(eventId);
});

final eventUsersWithDetailsProvider = Provider.family<AsyncValue<List<({String id, String name})>>, String>((ref, eventId) {
  final eventAsync = ref.watch(eventByIdStreamProvider(eventId));
  final eventUsersAsync = ref.watch(eventUsersStreamProvider(eventId));

  return eventAsync.when(
    loading: () => const AsyncValue.loading(),
    error: (e, s) => AsyncValue.error(e, s),
    data: (event) => eventUsersAsync.when(
      loading: () => const AsyncValue.loading(),
      error: (e, s) => AsyncValue.error(e, s),
      data: (eventUsers) {
        final userIds = eventUsers
            .where((u) => u.status == EventUserStatus.active)
            .map((u) => u.id)
            .toSet();
        
        if (event != null) {
          userIds.add(event.organizerId);
        }

        final results = <({String id, String name})>[];
        for (final uid in userIds) {
          final uAsync = ref.watch(userByIdProvider(uid));
          // If we want to wait for all names, we could check uAsync.isLoading
          // but showing UID as fallback is better for UX.
          results.add((id: uid, name: uAsync.value?.name ?? uid));
        }

        return AsyncValue.data(results);
      }
    )
  );
});

class _GuardedEventUserRepository implements EventUserRepository {
  final Ref _ref;
  final EventUserRepository _delegate;

  _GuardedEventUserRepository(this._ref, this._delegate);

  Future<void> _requireEdit(String eventId) async {
    final access = await _ref.read(moduleAccessForEventFutureProvider((eventId: eventId, module: EventModules.users)).future);
    if (!hasAtLeastAccess(access, ModuleAccessLevel.edit)) {
      throw StateError('No permission to manage users');
    }
  }

  @override
  Stream<List<EventUserModel>> getEventUsers(String eventId) => _delegate.getEventUsers(eventId);

  @override
  Future<void> addUserToEvent(EventUserModel user) async {
    await _requireEdit(user.eventId);
    return _delegate.addUserToEvent(user);
  }

  @override
  Future<void> updateEventUser(EventUserModel user) async {
    await _requireEdit(user.eventId);
    return _delegate.updateEventUser(user);
  }

  @override
  Future<void> removeUserFromEvent(String eventId, String userId) async {
    await _requireEdit(eventId);
    return _delegate.removeUserFromEvent(eventId, userId);
  }
}
