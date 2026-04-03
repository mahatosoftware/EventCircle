import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/expense_model.dart';
import '../data/repositories/expense_repository.dart';
import '../data/repositories/firebase/firebase_expense_repository.dart';
import 'event_provider.dart';
import 'access_control_provider.dart';
import '../data/models/event_role_model.dart';
import 'auth_provider.dart';
import '../data/models/audit_log_model.dart';
import 'audit_log_provider.dart';
import 'budget_provider.dart';
import 'package:uuid/uuid.dart';

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return _GuardedExpenseRepository(ref, FirebaseExpenseRepository());
});

final expensesStreamProvider = StreamProvider<List<ExpenseModel>>((ref) {
  final eventId = ref.watch(currentEventIdProvider);
  if (eventId == null) return Stream.value([]);
  return ref.watch(expenseRepositoryProvider).getExpenses(eventId);
});

final expensesForEventStreamProvider = StreamProvider.family<List<ExpenseModel>, String>((ref, eventId) {
  return ref.watch(expenseRepositoryProvider).getExpenses(eventId);
});

class _GuardedExpenseRepository implements ExpenseRepository {
  final Ref _ref;
  final ExpenseRepository _delegate;

  _GuardedExpenseRepository(this._ref, this._delegate);

  Future<void> _requireEdit(String eventId) async {
    final access = await _ref.read(moduleAccessForEventFutureProvider((eventId: eventId, module: EventModules.budget)).future);
    if (!hasAtLeastAccess(access, ModuleAccessLevel.edit)) {
      throw StateError('No permission to manage budget/expenses');
    }
  }

  Future<void> _log(String eventId, String action, String entityId, {Map<String, dynamic>? prev, Map<String, dynamic>? next, String? reason}) async {
    final user = _ref.read(currentUserProvider);
    if (user == null) return;

    final log = AuditLogModel(
      id: const Uuid().v4(),
      eventId: eventId,
      userId: user.id,
      action: action,
      entityType: 'expense',
      entityId: entityId,
      timestamp: DateTime.now(),
      previousData: prev,
      newData: next,
      reason: reason,
    );
    await _ref.read(auditLogRepositoryProvider).logAction(log);
  }

  @override
  Stream<List<ExpenseModel>> getExpenses(String eventId) => _delegate.getExpenses(eventId);

  Future<void> _syncBudget(String eventId, String? budgetItemId, double delta) async {
    if (budgetItemId == null || delta == 0) return;
    try {
      final budgetRepo = _ref.read(budgetRepositoryProvider);
      final item = await budgetRepo.getBudgetItem(eventId, budgetItemId);
      if (item != null) {
        final updated = item.copyWith(actualCost: item.actualCost + delta);
        await budgetRepo.updateBudgetItem(updated);
      }
    } catch (e) {
      // Log error but don't fail the expense operation
    }
  }

  @override
  Future<ExpenseModel?> getExpense(String eventId, String id) => _delegate.getExpense(eventId, id);

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    await _requireEdit(expense.eventId);
    await _delegate.addExpense(expense);
    await _log(expense.eventId, 'create', expense.id, next: expense.toJson());
    await _syncBudget(expense.eventId, expense.budgetItemId, expense.amount);
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    await _requireEdit(expense.eventId);
    final oldExpense = await _delegate.getExpense(expense.eventId, expense.id);
    await _delegate.updateExpense(expense);
    await _log(expense.eventId, 'update', expense.id, next: expense.toJson(), prev: oldExpense?.toJson());
    
    if (oldExpense != null) {
      if (oldExpense.budgetItemId == expense.budgetItemId) {
        // Same budget item, just update the difference
        await _syncBudget(expense.eventId, expense.budgetItemId, expense.amount - oldExpense.amount);
      } else {
        // Different budget items, decrement old and increment new
        await _syncBudget(expense.eventId, oldExpense.budgetItemId, -oldExpense.amount);
        await _syncBudget(expense.eventId, expense.budgetItemId, expense.amount);
      }
    }
  }

  @override
  Future<void> deleteExpense(String eventId, String id, {String? reason, Map<String, dynamic>? prevData}) async {
    await _requireEdit(eventId);
    final expense = prevData != null ? ExpenseModel.fromJson(prevData) : await _delegate.getExpense(eventId, id);
    await _delegate.deleteExpense(eventId, id, reason: reason, prevData: prevData);
    await _log(eventId, 'delete', id, reason: reason, prev: prevData ?? expense?.toJson());
    
    if (expense != null) {
      await _syncBudget(eventId, expense.budgetItemId, -expense.amount);
    }
  }
}
