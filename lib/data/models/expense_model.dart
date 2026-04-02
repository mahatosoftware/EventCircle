import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_model.freezed.dart';
part 'expense_model.g.dart';

enum ExpenseStatus { pending, approved, rejected }
enum PaidByType { organizer, volunteer }
enum ReimbursementStatus { none, pending, approved, paid, rejected }

@freezed
class ExpenseModel with _$ExpenseModel {
  const factory ExpenseModel({
    required String id,
    required String eventId,
    required String title,
    required double amount,
    required String category,
    required DateTime createdAt,
    @Default(ExpenseStatus.pending) ExpenseStatus status,
    String? createdBy,
    String? approvedBy,
    DateTime? approvedAt,
    String? receiptUrl,
    
    // Reimbursement Fields
    @Default(PaidByType.organizer) PaidByType paidByType,
    String? paidByUserId, // ID of the volunteer/member who paid
    @Default(false) bool isReimbursable,
    @Default(ReimbursementStatus.none) ReimbursementStatus reimbursementStatus,
    DateTime? paidAt,
    String? paymentMode, // UPI, Bank Transfer, Cash
    String? transactionRef,
    String? rejectionReason,
  }) = _ExpenseModel;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) => _$ExpenseModelFromJson(json);
}
