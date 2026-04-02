import '../models/member_model.dart';

abstract class MemberRepository {
  Stream<List<MemberModel>> getMembers(String eventId);
  Future<void> addMember(MemberModel member);
  Future<void> updateMember(MemberModel member);
  Future<void> deleteMember(String id);
  Future<void> bulkUploadMembers(String eventId, List<MemberModel> members);
}
