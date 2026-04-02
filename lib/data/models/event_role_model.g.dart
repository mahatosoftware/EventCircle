// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_role_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventRoleModelImpl _$$EventRoleModelImplFromJson(Map<String, dynamic> json) =>
    _$EventRoleModelImpl(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      moduleAccess:
          (json['moduleAccess'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, $enumDecode(_$ModuleAccessLevelEnumMap, e)),
          ) ??
          const {},
      userIds:
          (json['userIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      userResponsibilities:
          (json['userResponsibilities'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      isSystem: json['isSystem'] as bool? ?? false,
      systemKey: json['systemKey'] as String?,
    );

Map<String, dynamic> _$$EventRoleModelImplToJson(
  _$EventRoleModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'eventId': instance.eventId,
  'name': instance.name,
  'description': instance.description,
  'moduleAccess': instance.moduleAccess.map(
    (k, e) => MapEntry(k, _$ModuleAccessLevelEnumMap[e]!),
  ),
  'userIds': instance.userIds,
  'userResponsibilities': instance.userResponsibilities,
  'isSystem': instance.isSystem,
  'systemKey': instance.systemKey,
};

const _$ModuleAccessLevelEnumMap = {
  ModuleAccessLevel.full: 'full',
  ModuleAccessLevel.edit: 'edit',
  ModuleAccessLevel.update: 'update',
  ModuleAccessLevel.view: 'view',
  ModuleAccessLevel.none: 'none',
};
