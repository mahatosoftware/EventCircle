import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/member_model.dart';
import '../member_repository.dart';

class FirebaseMemberRepository implements MemberRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'members';

  @override
  Stream<List<MemberModel>> getMembers(String eventId) {
    return _firestore
        .collection(_collection)
        .where('eventId', isEqualTo: eventId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => MemberModel.fromJson(doc.data())).toList();
    });
  }

  @override
  Future<void> addMember(MemberModel member) async {
    await _firestore.collection(_collection).doc(member.id).set(member.toJson());
  }

  @override
  Future<void> updateMember(MemberModel member) async {
    await _firestore.collection(_collection).doc(member.id).update(member.toJson());
  }

  @override
  Future<void> deleteMember(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }

  @override
  Future<void> bulkUploadMembers(String eventId, List<MemberModel> members) async {
    final batch = _firestore.batch();
    for (final member in members) {
      final docRef = _firestore.collection(_collection).doc(member.id);
      batch.set(docRef, member.toJson());
    }
    await batch.commit();
  }

  @override
  Stream<MemberModel?> getMember(String memberId) {
    return _firestore.collection(_collection).doc(memberId).snapshots().map((doc) => doc.exists ? MemberModel.fromJson(doc.data()!) : null);
  }
}
