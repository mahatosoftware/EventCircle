// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_invitation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventInvitationModelImpl _$$EventInvitationModelImplFromJson(
  Map<String, dynamic> json,
) => _$EventInvitationModelImpl(
  id: json['id'] as String,
  eventId: json['eventId'] as String,
  token: json['token'] as String,
  createdBy: json['createdBy'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  expiresAt: json['expiresAt'] == null
      ? null
      : DateTime.parse(json['expiresAt'] as String),
  isUsed: json['isUsed'] as bool? ?? false,
  usedBy: json['usedBy'] as String?,
  usedAt: json['usedAt'] == null
      ? null
      : DateTime.parse(json['usedAt'] as String),
  isPreApproved: json['isPreApproved'] as bool? ?? true,
);

Map<String, dynamic> _$$EventInvitationModelImplToJson(
  _$EventInvitationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'eventId': instance.eventId,
  'token': instance.token,
  'createdBy': instance.createdBy,
  'createdAt': instance.createdAt.toIso8601String(),
  'expiresAt': instance.expiresAt?.toIso8601String(),
  'isUsed': instance.isUsed,
  'usedBy': instance.usedBy,
  'usedAt': instance.usedAt?.toIso8601String(),
  'isPreApproved': instance.isPreApproved,
};
