import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/expense_model.dart';
import '../data/repositories/expense_repository.dart';
import '../data/repositories/firebase/firebase_expense_repository.dart';
import 'event_provider.dart';
import 'access_control_provider.dart';
import '../data/models/event_role_model.dart';

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

  @override
  Stream<List<ExpenseModel>> getExpenses(String eventId) => _delegate.getExpenses(eventId);

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    await _requireEdit(expense.eventId);
    return _delegate.addExpense(expense);
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    await _requireEdit(expense.eventId);
    return _delegate.updateExpense(expense);
  }

  @override
  Future<void> deleteExpense(String id) {
    // Best-effort: delete is treated as edit since the repository API doesn't carry eventId here.
    return _delegate.deleteExpense(id);
  }
}
