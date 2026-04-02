import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

enum PaymentStatus { pending, success, failed }

@freezed
class PaymentModel with _$PaymentModel {
  const factory PaymentModel({
    required String id,
    required String memberId,
    required String eventId,
    required PaymentStatus status,
    required double amount,
    required DateTime timestamp,
    String? paymentMethod, // 'UPI', 'Cash', 'Cheque', 'NEFT', etc.
    String? referenceNumber, // Transaction ID or Reference Number
    String? contributionType, // 'item-based', 'tier-based', etc.
    String? targetId, // Item ID or Group ID
    String? recurringCycle, // e.g., '2026-03'
    Map<String, dynamic>? metadata, // Tickets, sponsor info, etc.
  }) = _PaymentModel;

  factory PaymentModel.fromJson(Map<String, dynamic> json) => _$PaymentModelFromJson(json);
}
