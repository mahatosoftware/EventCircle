import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/budget_model.dart';
import '../budget_repository.dart';

class FirebaseBudgetRepository implements BudgetRepository {
  final _db = FirebaseFirestore.instance;

  @override
  Stream<List<BudgetItemModel>> getBudgetItems(String eventId) {
    return _db
        .collection('events')
        .doc(eventId)
        .collection('budget')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => BudgetItemModel.fromJson(doc.data())).toList());
  }
  
  @override
  Future<BudgetItemModel?> getBudgetItem(String eventId, String id) async {
    final doc = await _db.collection('events').doc(eventId).collection('budget').doc(id).get();
    if (!doc.exists) return null;
    return BudgetItemModel.fromJson(doc.data()!);
  }

  @override
  Future<void> addBudgetItem(BudgetItemModel item) {
    return _db
        .collection('events')
        .doc(item.eventId)
        .collection('budget')
        .doc(item.id)
        .set(item.toJson());
  }

  @override
  Future<void> updateBudgetItem(BudgetItemModel item) {
    return _db
        .collection('events')
        .doc(item.eventId)
        .collection('budget')
        .doc(item.id)
        .update(item.toJson());
  }

  @override
  Future<void> deleteBudgetItem(String eventId, String id, {String? reason, Map<String, dynamic>? prevData}) {
    return _db
        .collection('events')
        .doc(eventId)
        .collection('budget')
        .doc(id)
        .delete();
  }
}
