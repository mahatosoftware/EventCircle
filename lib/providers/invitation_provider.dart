import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/invitation_repository.dart';

final invitationRepositoryProvider = Provider<InvitationRepository>((ref) {
  return FirebaseInvitationRepository();
});
