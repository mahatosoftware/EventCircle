import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_model.freezed.dart';
part 'expense_model.g.dart';

enum ExpenseStatus { pending, approved, rejected }

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
    String? receiptUrl,
  }) = _ExpenseModel;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) => _$ExpenseModelFromJson(json);
}
