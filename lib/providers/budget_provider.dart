import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/budget_model.dart';
import '../data/repositories/budget_repository.dart';
import '../data/repositories/firebase/firebase_budget_repository.dart';
import 'event_provider.dart';
import 'access_control_provider.dart';
import '../data/models/event_role_model.dart';
import 'auth_provider.dart';
import '../data/models/audit_log_model.dart';
import 'audit_log_provider.dart';
import 'package:uuid/uuid.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return _GuardedBudgetRepository(ref, FirebaseBudgetRepository());
});

final budgetStreamProvider = StreamProvider<List<BudgetItemModel>>((ref) {
  final eventId = ref.watch(currentEventIdProvider);
  if (eventId == null) return Stream.value([]);
  return ref.watch(budgetRepositoryProvider).getBudgetItems(eventId);
});

final budgetForEventStreamProvider = StreamProvider.family<List<BudgetItemModel>, String>((ref, eventId) {
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

  Future<void> _log(String eventId, String action, String entityId, {Map<String, dynamic>? prev, Map<String, dynamic>? next, String? reason}) async {
    final user = _ref.read(currentUserProvider);
    if (user == null) return;

    final log = AuditLogModel(
      id: const Uuid().v4(),
      eventId: eventId,
      userId: user.id,
      action: action,
      entityType: 'budget_item',
      entityId: entityId,
      timestamp: DateTime.now(),
      previousData: prev,
      newData: next,
      reason: reason,
    );
    await _ref.read(auditLogRepositoryProvider).logAction(log);
  }

  @override
  Stream<List<BudgetItemModel>> getBudgetItems(String eventId) => _delegate.getBudgetItems(eventId);

  @override
  Future<BudgetItemModel?> getBudgetItem(String eventId, String id) => _delegate.getBudgetItem(eventId, id);

  @override
  Future<void> addBudgetItem(BudgetItemModel item) async {
    await _requireEdit(item.eventId);
    await _delegate.addBudgetItem(item);
    await _log(item.eventId, 'create', item.id, next: item.toJson());
  }

  @override
  Future<void> updateBudgetItem(BudgetItemModel item) async {
    await _requireEdit(item.eventId);
    await _delegate.updateBudgetItem(item);
    await _log(item.eventId, 'update', item.id, next: item.toJson());
  }

  @override
  Future<void> deleteBudgetItem(String eventId, String id, {String? reason, Map<String, dynamic>? prevData}) async {
    await _requireEdit(eventId);
    await _delegate.deleteBudgetItem(eventId, id, reason: reason, prevData: prevData);
    await _log(eventId, 'delete', id, reason: reason, prev: prevData);
  }
}
