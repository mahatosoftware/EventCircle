// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MemberModelImpl _$$MemberModelImplFromJson(Map<String, dynamic> json) =>
    _$MemberModelImpl(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      identifier: json['identifier'] as String,
      status: $enumDecode(_$MemberStatusEnumMap, json['status']),
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      guestCategory: json['guestCategory'] as String?,
      rsvpStatus:
          $enumDecodeNullable(_$RsvpStatusEnumMap, json['rsvpStatus']) ??
          RsvpStatus.none,
      plusOnes: (json['plusOnes'] as num?)?.toInt() ?? 0,
      assignedAmount: (json['assignedAmount'] as num?)?.toDouble(),
      groupId: json['groupId'] as String?,
      selectedTier: json['selectedTier'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$MemberModelImplToJson(_$MemberModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'name': instance.name,
      'phone': instance.phone,
      'identifier': instance.identifier,
      'status': _$MemberStatusEnumMap[instance.status]!,
      'joinedAt': instance.joinedAt.toIso8601String(),
      'guestCategory': instance.guestCategory,
      'rsvpStatus': _$RsvpStatusEnumMap[instance.rsvpStatus]!,
      'plusOnes': instance.plusOnes,
      'assignedAmount': instance.assignedAmount,
      'groupId': instance.groupId,
      'selectedTier': instance.selectedTier,
      'metadata': instance.metadata,
    };

const _$MemberStatusEnumMap = {
  MemberStatus.invited: 'invited',
  MemberStatus.paid: 'paid',
  MemberStatus.pending: 'pending',
  MemberStatus.partiallyPaid: 'partiallyPaid',
};

const _$RsvpStatusEnumMap = {
  RsvpStatus.attending: 'attending',
  RsvpStatus.maybe: 'maybe',
  RsvpStatus.declined: 'declined',
  RsvpStatus.none: 'none',
};
