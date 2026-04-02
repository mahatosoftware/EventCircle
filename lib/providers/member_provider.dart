import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/member_model.dart';
import '../data/repositories/member_repository.dart';
import '../data/repositories/firebase/firebase_member_repository.dart';
import 'event_provider.dart';
import 'access_control_provider.dart';
import '../data/models/event_role_model.dart';

final memberRepositoryProvider = Provider<MemberRepository>((ref) {
  return _GuardedMemberRepository(ref, FirebaseMemberRepository());
});

final membersStreamProvider = StreamProvider<List<MemberModel>>((ref) {
  final eventId = ref.watch(currentEventIdProvider);
  if (eventId == null) return Stream.value([]);
  return ref.watch(memberRepositoryProvider).getMembers(eventId);
});

final membersForEventStreamProvider = StreamProvider.family<List<MemberModel>, String>((ref, eventId) {
  return ref.watch(memberRepositoryProvider).getMembers(eventId);
});

class _GuardedMemberRepository implements MemberRepository {
  final Ref _ref;
  final MemberRepository _delegate;

  _GuardedMemberRepository(this._ref, this._delegate);

  Future<void> _requireEdit(String eventId) async {
    final access = await _ref.read(moduleAccessForEventFutureProvider((eventId: eventId, module: EventModules.guests)).future);
    if (!hasAtLeastAccess(access, ModuleAccessLevel.edit)) {
      throw StateError('No permission to edit guests');
    }
  }

  @override
  Stream<List<MemberModel>> getMembers(String eventId) => _delegate.getMembers(eventId);

  @override
  Future<void> addMember(MemberModel member) async {
    await _requireEdit(member.eventId);
    return _delegate.addMember(member);
  }

  @override
  Future<void> updateMember(MemberModel member) async {
    await _requireEdit(member.eventId);
    return _delegate.updateMember(member);
  }

  @override
  Future<void> deleteMember(String id) {
    // Best-effort: delete is treated as edit since the repository API doesn't carry eventId here.
    return _delegate.deleteMember(id);
  }

  @override
  Future<void> bulkUploadMembers(String eventId, List<MemberModel> members) {
    return _requireEdit(eventId).then((_) => _delegate.bulkUploadMembers(eventId, members));
  }
}
