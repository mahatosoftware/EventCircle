import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/budget_model.dart';
import '../data/repositories/budget_repository.dart';
import '../data/repositories/firebase/firebase_budget_repository.dart';
import 'event_provider.dart';
import 'access_control_provider.dart';
import '../data/models/event_role_model.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return _GuardedBudgetRepository(ref, FirebaseBudgetRepository());
});

final budgetStreamProvider = StreamProvider<List<BudgetItemModel>>((ref) {
  final eventId = ref.watch(currentEventIdProvider);
  if (eventId == null) return Stream.value([]);
  return ref.watch(budgetRepositoryProvider).getBudgetItems(eventId);
});

class _GuardedBudgetRepository implements BudgetRepository {
  final Ref _ref;
  final BudgetRepository _delegate;

  _GuardedBudgetRepository(this._ref, this._delegate);

  Future<void> _requireEdit(String eventId) async {
    final access = await _ref.read(moduleAccessForEventFutureProvider((eventId: eventId, module: EventModules.budget)).future);
    if (!hasAtLeastAccess(access, ModuleAccessLevel.edit)) {
      throw StateError('No permission to manage budget');
    }
  }

  @override
  Stream<List<BudgetItemModel>> getBudgetItems(String eventId) => _delegate.getBudgetItems(eventId);

  @override
  Future<void> addBudgetItem(BudgetItemModel item) async {
    await _requireEdit(item.eventId);
    return _delegate.addBudgetItem(item);
  }

  @override
  Future<void> updateBudgetItem(BudgetItemModel item) async {
    await _requireEdit(item.eventId);
    return _delegate.updateBudgetItem(item);
  }

  @override
  Future<void> deleteBudgetItem(String id) {
    // Best-effort: delete is treated as edit since the repository API doesn't carry eventId here.
    return _delegate.deleteBudgetItem(id);
  }
}
