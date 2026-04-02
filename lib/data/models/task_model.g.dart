// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskModelImpl _$$TaskModelImplFromJson(Map<String, dynamic> json) =>
    _$TaskModelImpl(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      title: json['title'] as String,
      status: $enumDecode(_$TaskStatusEnumMap, json['status']),
      phase:
          $enumDecodeNullable(_$TaskPhaseEnumMap, json['phase']) ??
          TaskPhase.preEvent,
      description: json['description'] as String?,
      dueOffset: json['dueOffset'] as String?,
      role: json['role'] as String?,
      dependsOn:
          (json['dependsOn'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      assignedMemberId: json['assignedMemberId'] as String?,
      assignedMemberName: json['assignedMemberName'] as String?,
    );

Map<String, dynamic> _$$TaskModelImplToJson(_$TaskModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'title': instance.title,
      'status': _$TaskStatusEnumMap[instance.status]!,
      'phase': _$TaskPhaseEnumMap[instance.phase]!,
      'description': instance.description,
      'dueOffset': instance.dueOffset,
      'role': instance.role,
      'dependsOn': instance.dependsOn,
      'assignedMemberId': instance.assignedMemberId,
      'assignedMemberName': instance.assignedMemberName,
    };

const _$TaskStatusEnumMap = {
  TaskStatus.pending: 'pending',
  TaskStatus.done: 'done',
};

const _$TaskPhaseEnumMap = {
  TaskPhase.preEvent: 'preEvent',
  TaskPhase.eventDay: 'eventDay',
  TaskPhase.postEvent: 'postEvent',
};
