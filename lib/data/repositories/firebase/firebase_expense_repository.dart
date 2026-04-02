import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/expense_model.dart';
import '../expense_repository.dart';

class FirebaseExpenseRepository implements ExpenseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'expenses';

  @override
  Stream<List<ExpenseModel>> getExpenses(String eventId) {
    return _firestore
        .collection(_collection)
        .where('eventId', isEqualTo: eventId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ExpenseModel.fromJson({...doc.data(), 'id': doc.id})).toList();
    });
  }

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    await _firestore.collection(_collection).doc(expense.id).set(expense.toJson());
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    await _firestore.collection(_collection).doc(expense.id).update(expense.toJson());
  }

  @override
  Future<void> deleteExpense(String eventId, String id, {String? reason, Map<String, dynamic>? prevData}) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}
