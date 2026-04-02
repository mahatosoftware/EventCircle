import '../models/expense_model.dart';

abstract class ExpenseRepository {
  Stream<List<ExpenseModel>> getExpenses(String eventId);
  Future<void> addExpense(ExpenseModel expense);
  Future<void> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(String id);
}
