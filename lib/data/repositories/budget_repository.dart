import 'dart:math';
import '../../data/models/budget_model.dart';

abstract class BudgetRepository {
  Stream<List<BudgetItemModel>> getBudgetItems(String eventId);
  Future<BudgetItemModel?> getBudgetItem(String eventId, String id);
  Future<void> addBudgetItem(BudgetItemModel item);
  Future<void> updateBudgetItem(BudgetItemModel item);
  Future<void> deleteBudgetItem(String eventId, String id, {String? reason, Map<String, dynamic>? prevData});
}
