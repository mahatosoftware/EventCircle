// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimelineItemModelImpl _$$TimelineItemModelImplFromJson(
  Map<String, dynamic> json,
) => _$TimelineItemModelImpl(
  id: json['id'] as String,
  eventId: json['eventId'] as String,
  title: json['title'] as String,
  phase: $enumDecode(_$TimelinePhaseEnumMap, json['phase']),
  timeOrOffset: json['timeOrOffset'] as String,
  description: json['description'] as String?,
  startTime: json['startTime'] == null
      ? null
      : DateTime.parse(json['startTime'] as String),
);

Map<String, dynamic> _$$TimelineItemModelImplToJson(
  _$TimelineItemModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'eventId': instance.eventId,
  'title': instance.title,
  'phase': _$TimelinePhaseEnumMap[instance.phase]!,
  'timeOrOffset': instance.timeOrOffset,
  'description': instance.description,
  'startTime': instance.startTime?.toIso8601String(),
};

const _$TimelinePhaseEnumMap = {
  TimelinePhase.preEvent: 'preEvent',
  TimelinePhase.eventDay: 'eventDay',
  TimelinePhase.postEvent: 'postEvent',
};
