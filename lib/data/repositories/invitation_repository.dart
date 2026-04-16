import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_invitation_model.dart';

abstract class InvitationRepository {
  Future<EventInvitationModel> createPreApprovedInvitation(String eventId, String createdBy);
  Future<void> consumeInvitation(String token, String userId);
  Future<EventInvitationModel?> getInvitationByToken(String token);
}

class FirebaseInvitationRepository implements InvitationRepository {
  final FirebaseFirestore _db;
  FirebaseInvitationRepository({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  @override
  Future<EventInvitationModel> createPreApprovedInvitation(String eventId, String createdBy) async {
    final doc = _db.collection('invitations').doc();
    final invitation = EventInvitationModel(
      id: doc.id,
      eventId: eventId,
      token: doc.id, // Using doc ID as token for simplicity
      createdBy: createdBy,
      createdAt: DateTime.now(),
      isPreApproved: true,
    );
    await doc.set(invitation.toJson());
    return invitation;
  }

  @override
  Future<EventInvitationModel?> getInvitationByToken(String token) async {
    final snapshot = await _db.collection('invitations').where('token', isEqualTo: token).limit(1).get();
    if (snapshot.docs.isEmpty) return null;
    return EventInvitationModel.fromJson(snapshot.docs.first.data());
  }

  @override
  Future<void> consumeInvitation(String token, String userId) async {
    final invitation = await getInvitationByToken(token);
    if (invitation == null || invitation.isUsed) throw Exception('Invalid or used invitation');
    
    await _db.collection('invitations').doc(invitation.id).update({
      'isUsed': true,
      'usedBy': userId,
      'usedAt': DateTime.now().toIso8601String(),
    });
  }
}
