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
  Future<void> deleteBudgetItem(String id) {
    // Note: This requires knowing the eventId. Alternatively, use a collectionGroup or add eventId to the call.
    // For now, assume this is handled at the UI layer or improved later.
    throw UnimplementedError('Delete requires eventId context');
  }
}
