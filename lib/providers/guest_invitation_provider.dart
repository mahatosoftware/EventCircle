import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/guest_invitation_repository.dart';
import '../data/models/invitation_config_model.dart';
import '../data/models/member_model.dart';

final guestInvitationRepositoryProvider = Provider((ref) => GuestInvitationRepository());

final invitationConfigProvider = StreamProvider.family<InvitationConfigModel?, String>((ref, eventId) {
  return ref.watch(guestInvitationRepositoryProvider).watchInvitationConfig(eventId);
});

final rsvpStatsProvider = StreamProvider.family<Map<String, int>, String>((ref, eventId) {
  return ref.watch(guestInvitationRepositoryProvider).watchRsvpStats(eventId);
});

class InvitationNotifier extends StateNotifier<AsyncValue<void>> {
  final GuestInvitationRepository _repo;
  InvitationNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<void> saveConfig(InvitationConfigModel config) async {
    state = const AsyncValue.loading();
    try {
      await _repo.saveInvitationConfig(config);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> submitRsvp({
    required String eventId,
    required String memberId,
    required RsvpStatus status,
    required int plusOnes,
    Map<String, dynamic>? customResponses,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repo.submitRsvp(
        eventId: eventId,
        memberId: memberId,
        status: status,
        plusOnes: plusOnes,
        customResponses: customResponses,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final invitationActionProvider = StateNotifierProvider<InvitationNotifier, AsyncValue<void>>((ref) {
  return InvitationNotifier(ref.watch(guestInvitationRepositoryProvider));
});
