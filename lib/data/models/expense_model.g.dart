// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpenseModelImpl _$$ExpenseModelImplFromJson(Map<String, dynamic> json) =>
    _$ExpenseModelImpl(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status:
          $enumDecodeNullable(_$ExpenseStatusEnumMap, json['status']) ??
          ExpenseStatus.pending,
      createdBy: json['createdBy'] as String?,
      approvedBy: json['approvedBy'] as String?,
      receiptUrl: json['receiptUrl'] as String?,
    );

Map<String, dynamic> _$$ExpenseModelImplToJson(_$ExpenseModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'title': instance.title,
      'amount': instance.amount,
      'category': instance.category,
      'createdAt': instance.createdAt.toIso8601String(),
      'status': _$ExpenseStatusEnumMap[instance.status]!,
      'createdBy': instance.createdBy,
      'approvedBy': instance.approvedBy,
      'receiptUrl': instance.receiptUrl,
    };

const _$ExpenseStatusEnumMap = {
  ExpenseStatus.pending: 'pending',
  ExpenseStatus.approved: 'approved',
  ExpenseStatus.rejected: 'rejected',
};
