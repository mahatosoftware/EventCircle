import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/payment_model.dart';
import '../payment_repository.dart';

class FirebasePaymentRepository implements PaymentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'payments';

  @override
  Stream<List<PaymentModel>> getPayments(String eventId) {
    return _firestore
        .collection(_collection)
        .where('eventId', isEqualTo: eventId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => PaymentModel.fromJson(doc.data())).toList();
    });
  }

  @override
  Future<void> initiatePayment(PaymentModel payment) async {
    await _firestore.collection(_collection).doc(payment.id).set(payment.toJson());
  }

  @override
  Future<void> updatePayment(PaymentModel payment) async {
    await _firestore.collection(_collection).doc(payment.id).update(payment.toJson());
  }

  @override
  Future<void> updatePaymentStatus(String paymentId, PaymentStatus status) async {
    await _firestore.collection(_collection).doc(paymentId).update({
      'status': status.name,
    });
  }

  @override
  Future<void> deletePayment(String eventId, String paymentId) async {
    await _firestore.collection(_collection).doc(paymentId).delete();
  }

  @override
  Future<String> generatePaymentLink(String memberId, double amount) async {
    return 'https://razorpay.com/pl/mock-link-$memberId-$amount';
  }
}
