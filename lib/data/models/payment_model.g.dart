// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentModelImpl _$$PaymentModelImplFromJson(Map<String, dynamic> json) =>
    _$PaymentModelImpl(
      id: json['id'] as String,
      memberId: json['memberId'] as String,
      eventId: json['eventId'] as String,
      status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
      amount: (json['amount'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      paymentMethod: json['paymentMethod'] as String?,
      referenceNumber: json['referenceNumber'] as String?,
      contributionType: json['contributionType'] as String?,
      targetId: json['targetId'] as String?,
      recurringCycle: json['recurringCycle'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PaymentModelImplToJson(_$PaymentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'memberId': instance.memberId,
      'eventId': instance.eventId,
      'status': _$PaymentStatusEnumMap[instance.status]!,
      'amount': instance.amount,
      'timestamp': instance.timestamp.toIso8601String(),
      'paymentMethod': instance.paymentMethod,
      'referenceNumber': instance.referenceNumber,
      'contributionType': instance.contributionType,
      'targetId': instance.targetId,
      'recurringCycle': instance.recurringCycle,
      'metadata': instance.metadata,
    };

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.success: 'success',
  PaymentStatus.failed: 'failed',
};
