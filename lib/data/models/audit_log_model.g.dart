// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuditLogModelImpl _$$AuditLogModelImplFromJson(Map<String, dynamic> json) =>
    _$AuditLogModelImpl(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      userId: json['userId'] as String,
      action: json['action'] as String,
      entityType: json['entityType'] as String,
      entityId: json['entityId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      previousData: json['previousData'] as Map<String, dynamic>?,
      newData: json['newData'] as Map<String, dynamic>?,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$$AuditLogModelImplToJson(_$AuditLogModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'userId': instance.userId,
      'action': instance.action,
      'entityType': instance.entityType,
      'entityId': instance.entityId,
      'timestamp': instance.timestamp.toIso8601String(),
      'previousData': instance.previousData,
      'newData': instance.newData,
      'reason': instance.reason,
    };
