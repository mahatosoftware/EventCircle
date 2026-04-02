import 'dart:math';
import '../../data/models/budget_model.dart';

abstract class BudgetRepository {
  Stream<List<BudgetItemModel>> getBudgetItems(String eventId);
  Future<void> addBudgetItem(BudgetItemModel item);
  Future<void> updateBudgetItem(BudgetItemModel item);
  Future<void> deleteBudgetItem(String id);
}
