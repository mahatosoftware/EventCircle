import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_role_model.dart';

abstract class RoleRepository {
  Stream<List<EventRoleModel>> getRoles(String eventId);
  Future<void> addRole(EventRoleModel role);
  Future<void> updateRole(EventRoleModel role);
  Future<void> deleteRole({required String eventId, required String roleId});
}

class FirebaseRoleRepository implements RoleRepository {
  final _db = FirebaseFirestore.instance;

  @override
  Stream<List<EventRoleModel>> getRoles(String eventId) {
    return _db.collection('events').doc(eventId).collection('roles')
        .snapshots().map((s) => s.docs.map((d) => EventRoleModel.fromJson(d.data())).toList());
  }

  @override
  Future<void> addRole(EventRoleModel role) =>
      _db.collection('events').doc(role.eventId).collection('roles').doc(role.id).set(role.toJson());

  @override
  Future<void> updateRole(EventRoleModel role) =>
      _db.collection('events').doc(role.eventId).collection('roles').doc(role.id).update(role.toJson());

  @override
  Future<void> deleteRole({required String eventId, required String roleId}) =>
      _db.collection('events').doc(eventId).collection('roles').doc(roleId).delete();
}
