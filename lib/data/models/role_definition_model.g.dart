// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_definition_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoleDefinitionModelImpl _$$RoleDefinitionModelImplFromJson(
  Map<String, dynamic> json,
) => _$RoleDefinitionModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String? ?? '',
  moduleAccess:
      (json['moduleAccess'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, $enumDecode(_$ModuleAccessLevelEnumMap, e)),
      ) ??
      const {},
);

Map<String, dynamic> _$$RoleDefinitionModelImplToJson(
  _$RoleDefinitionModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'moduleAccess': instance.moduleAccess.map(
    (k, e) => MapEntry(k, _$ModuleAccessLevelEnumMap[e]!),
  ),
};

const _$ModuleAccessLevelEnumMap = {
  ModuleAccessLevel.full: 'full',
  ModuleAccessLevel.edit: 'edit',
  ModuleAccessLevel.update: 'update',
  ModuleAccessLevel.view: 'view',
  ModuleAccessLevel.none: 'none',
};
