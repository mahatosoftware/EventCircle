import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/invitation_config_model.dart';
import '../models/member_model.dart';

class GuestInvitationRepository {
  final FirebaseFirestore _db;

  GuestInvitationRepository({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  // Configuration
  Future<void> saveInvitationConfig(InvitationConfigModel config) async {
    await _db
        .collection('events')
        .doc(config.eventId)
        .collection('configs')
        .doc('invitation')
        .set(config.toJson());
  }

  Stream<InvitationConfigModel?> watchInvitationConfig(String eventId) {
    return _db
        .collection('events')
        .doc(eventId)
        .collection('configs')
        .doc('invitation')
        .snapshots()
        .map((doc) => doc.exists ? InvitationConfigModel.fromJson(doc.data()!) : null);
  }

  Future<InvitationConfigModel?> getInvitationConfig(String eventId) async {
    final doc = await _db
        .collection('events')
        .doc(eventId)
        .collection('configs')
        .doc('invitation')
        .get();
    return doc.exists ? InvitationConfigModel.fromJson(doc.data()!) : null;
  }

  // RSVP Stats
  Stream<Map<String, int>> watchRsvpStats(String eventId) {
    return _db
        .collection('members')
        .where('eventId', isEqualTo: eventId)
        .snapshots()
        .map((snapshot) {
      int attending = 0;
      int maybe = 0;
      int declined = 0;
      int pending = 0;
      int plusOnes = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final rsvp = data['rsvpStatus']?.toString();
        final pOnes = data['plusOnes'] as int? ?? 0;

        if (rsvp == 'attending') {
          attending++;
          plusOnes += pOnes;
        } else if (rsvp == 'maybe') {
          maybe++;
        } else if (rsvp == 'declined') {
          declined++;
        } else {
          pending++;
        }
      }

      return {
        'total': snapshot.size,
        'attending': attending,
        'maybe': maybe,
        'declined': declined,
        'pending': pending,
        'totalHeads': attending + plusOnes,
      };
    });
  }

  // Submit RSVP
  Future<void> submitRsvp({
    required String eventId,
    required String memberId,
    required RsvpStatus status,
    required int plusOnes,
    Map<String, dynamic>? customResponses,
  }) async {
    await _db
        .collection('members')
        .doc(memberId)
        .update({
      'rsvpStatus': status.name,
      'plusOnes': plusOnes,
      if (customResponses != null) 'metadata.rsvpResponses': customResponses,
    });
  }
}
