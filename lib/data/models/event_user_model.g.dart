// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventUserModelImpl _$$EventUserModelImplFromJson(Map<String, dynamic> json) =>
    _$EventUserModelImpl(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      status: $enumDecode(_$EventUserStatusEnumMap, json['status']),
      addedAt: DateTime.parse(json['addedAt'] as String),
      removedAt: json['removedAt'] == null
          ? null
          : DateTime.parse(json['removedAt'] as String),
      addedBy: json['addedBy'] as String?,
    );

Map<String, dynamic> _$$EventUserModelImplToJson(
  _$EventUserModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'eventId': instance.eventId,
  'status': _$EventUserStatusEnumMap[instance.status]!,
  'addedAt': instance.addedAt.toIso8601String(),
  'removedAt': instance.removedAt?.toIso8601String(),
  'addedBy': instance.addedBy,
};

const _$EventUserStatusEnumMap = {
  EventUserStatus.active: 'active',
  EventUserStatus.removed: 'removed',
  EventUserStatus.pendingApproval: 'pendingApproval',
  EventUserStatus.blocked: 'blocked',
};
