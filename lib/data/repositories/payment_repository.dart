import '../models/payment_model.dart';

abstract class PaymentRepository {
  Stream<List<PaymentModel>> getPayments(String eventId);
  Future<void> initiatePayment(PaymentModel payment);
  Future<void> updatePayment(PaymentModel payment);
  Future<void> updatePaymentStatus(String paymentId, PaymentStatus status);
  Future<void> deletePayment(String eventId, String paymentId);
  Future<String> generatePaymentLink(String memberId, double amount);
}
