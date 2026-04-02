import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/event_user_model.dart';
import '../event_user_repository.dart';

class FirebaseEventUserRepository implements EventUserRepository {
  final FirebaseFirestore _db;

  FirebaseEventUserRepository({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _col(String eventId) =>
      _db.collection('events').doc(eventId).collection('users');

  @override
  Stream<List<EventUserModel>> getEventUsers(String eventId) {
    return _col(eventId)
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => EventUserModel.fromJson(d.data())).toList());
  }

  @override
  Future<void> addUserToEvent(EventUserModel user) async {
    await _col(user.eventId).doc(user.id).set(user.toJson(), SetOptions(merge: true));
  }

  @override
  Future<void> updateEventUser(EventUserModel user) async {
    await _col(user.eventId).doc(user.id).set(user.toJson(), SetOptions(merge: true));
  }

  @override
  Future<void> removeUserFromEvent(String eventId, String userId) async {
    await _col(eventId).doc(userId).set(
      {
        'status': EventUserStatus.removed.name,
        'removedAt': DateTime.now().toIso8601String(),
      },
      SetOptions(merge: true),
    );
  }
}

