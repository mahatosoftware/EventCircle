import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user_model.dart';
import '../user_repository.dart';

class FirebaseUserRepository implements UserRepository {
  final FirebaseFirestore _db;

  FirebaseUserRepository({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  @override
  Future<UserModel?> getUserById(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    if (!doc.exists) return null;
    final data = doc.data();
    if (data == null) return null;
    return UserModel.fromJson(data);
  }

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    final q = query.trim();
    if (q.isEmpty) return [];

    final qLower = q.toLowerCase();

    // If it looks like a UID, try direct doc fetch first.
    if (q.length >= 20 && !q.contains('@') && !q.contains(' ')) {
      final user = await getUserById(q);
      if (user != null) return [user];
    }

    final results = <UserModel>[];
    final seen = <String>{};

    Future<void> addQueryResult(QuerySnapshot<Map<String, dynamic>> snap) async {
      for (final d in snap.docs) {
        if (!seen.add(d.id)) continue;
        results.add(UserModel.fromJson(d.data()));
      }
    }

    // Exact email match.
    if (q.contains('@')) {
      final snap = await _db.collection('users').where('email', isEqualTo: q).limit(10).get();
      await addQueryResult(snap);
      final snapLower = await _db.collection('users').where('emailLower', isEqualTo: qLower).limit(10).get();
      await addQueryResult(snapLower);
      return results;
    }

    // Exact phone match (keep simple for now).
    final snap = await _db.collection('users').where('phone', isEqualTo: q).limit(10).get();
    await addQueryResult(snap);

    // Exact name match (best-effort; supports case-insensitive via nameLower when available).
    final nameSnap = await _db.collection('users').where('name', isEqualTo: q).limit(10).get();
    await addQueryResult(nameSnap);
    final nameLowerSnap = await _db.collection('users').where('nameLower', isEqualTo: qLower).limit(10).get();
    await addQueryResult(nameLowerSnap);
    return results;
  }

  @override
  Future<void> upsertUser(UserModel user) async {
    final data = user.toJson();
    data['nameLower'] = user.name.toLowerCase();
    data['emailLower'] = user.email.toLowerCase();
    await _db.collection('users').doc(user.id).set(data, SetOptions(merge: true));
  }
}
