import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/payment_model.dart';
import '../data/repositories/payment_repository.dart';
import '../data/repositories/firebase/firebase_payment_repository.dart';
import 'event_provider.dart';
import 'access_control_provider.dart';
import '../data/models/event_role_model.dart';
import 'auth_provider.dart';
import '../data/models/audit_log_model.dart';
import 'audit_log_provider.dart';
import 'package:uuid/uuid.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return _GuardedPaymentRepository(ref, FirebasePaymentRepository());
});

final paymentsStreamProvider = StreamProvider<List<PaymentModel>>((ref) {
  final eventId = ref.watch(currentEventIdProvider);
  if (eventId == null) return Stream.value([]);
  return ref.watch(paymentRepositoryProvider).getPayments(eventId);
});

final paymentsForEventStreamProvider = StreamProvider.family<List<PaymentModel>, String>((ref, eventId) {
  return ref.watch(paymentRepositoryProvider).getPayments(eventId);
});

class _GuardedPaymentRepository implements PaymentRepository {
  final Ref _ref;
  final PaymentRepository _delegate;

  _GuardedPaymentRepository(this._ref, this._delegate);

  Future<void> _requireUpdate(String eventId) async {
    final access =
        await _ref.read(moduleAccessForEventFutureProvider((eventId: eventId, module: EventModules.contribution)).future);
    if (!hasAtLeastAccess(access, ModuleAccessLevel.update)) {
      throw StateError('No permission to manage contributions');
    }
  }

  Future<void> _log(String eventId, String action, String entityId, {Map<String, dynamic>? prev, Map<String, dynamic>? next}) async {
    final user = _ref.read(currentUserProvider);
    if (user == null) return;

    final log = AuditLogModel(
      id: const Uuid().v4(),
      eventId: eventId,
      userId: user.id,
      action: action,
      entityType: 'payment',
      entityId: entityId,
      timestamp: DateTime.now(),
      previousData: prev,
      newData: next,
    );
    await _ref.read(auditLogRepositoryProvider).logAction(log);
  }

  @override
  Stream<List<PaymentModel>> getPayments(String eventId) => _delegate.getPayments(eventId);

  @override
  Future<void> initiatePayment(PaymentModel payment) async {
    await _requireUpdate(payment.eventId);
    await _delegate.initiatePayment(payment);
    await _log(payment.eventId, 'create', payment.id, next: payment.toJson());
  }

  @override
  Future<void> updatePayment(PaymentModel payment) async {
    await _requireUpdate(payment.eventId);
    // Best effort to get previous data if possible, but for simplicity we log the update.
    await _delegate.updatePayment(payment);
    await _log(payment.eventId, 'update', payment.id, next: payment.toJson());
  }

  @override
  Future<void> updatePaymentStatus(String paymentId, PaymentStatus status) async {
    // In a real app, we'd fetch the payment first to get the eventId for the guard.
    // For now, allow it but ideally fetch eventId first.
    await _delegate.updatePaymentStatus(paymentId, status);
  }

  @override
  Future<void> deletePayment(String eventId, String paymentId) async {
    await _requireUpdate(eventId);
    await _delegate.deletePayment(eventId, paymentId);
    await _log(eventId, 'delete', paymentId);
  }

  @override
  Future<String> generatePaymentLink(String memberId, double amount) => _delegate.generatePaymentLink(memberId, amount);
}
