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
      approvedAt: json['approvedAt'] == null
          ? null
          : DateTime.parse(json['approvedAt'] as String),
      receiptUrl: json['receiptUrl'] as String?,
      paidByType:
          $enumDecodeNullable(_$PaidByTypeEnumMap, json['paidByType']) ??
          PaidByType.organizer,
      paidByUserId: json['paidByUserId'] as String?,
      isReimbursable: json['isReimbursable'] as bool? ?? false,
      reimbursementStatus:
          $enumDecodeNullable(
            _$ReimbursementStatusEnumMap,
            json['reimbursementStatus'],
          ) ??
          ReimbursementStatus.none,
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.parse(json['paidAt'] as String),
      paymentMode: json['paymentMode'] as String?,
      transactionRef: json['transactionRef'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
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
      'approvedAt': instance.approvedAt?.toIso8601String(),
      'receiptUrl': instance.receiptUrl,
      'paidByType': _$PaidByTypeEnumMap[instance.paidByType]!,
      'paidByUserId': instance.paidByUserId,
      'isReimbursable': instance.isReimbursable,
      'reimbursementStatus':
          _$ReimbursementStatusEnumMap[instance.reimbursementStatus]!,
      'paidAt': instance.paidAt?.toIso8601String(),
      'paymentMode': instance.paymentMode,
      'transactionRef': instance.transactionRef,
      'rejectionReason': instance.rejectionReason,
    };

const _$ExpenseStatusEnumMap = {
  ExpenseStatus.pending: 'pending',
  ExpenseStatus.approved: 'approved',
  ExpenseStatus.rejected: 'rejected',
};

const _$PaidByTypeEnumMap = {
  PaidByType.organizer: 'organizer',
  PaidByType.volunteer: 'volunteer',
};

const _$ReimbursementStatusEnumMap = {
  ReimbursementStatus.none: 'none',
  ReimbursementStatus.pending: 'pending',
  ReimbursementStatus.approved: 'approved',
  ReimbursementStatus.paid: 'paid',
  ReimbursementStatus.rejected: 'rejected',
};
