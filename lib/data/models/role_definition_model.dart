import 'package:freezed_annotation/freezed_annotation.dart';

import 'event_role_model.dart';

part 'role_definition_model.freezed.dart';
part 'role_definition_model.g.dart';

@freezed
class RoleDefinitionModel with _$RoleDefinitionModel {
  const factory RoleDefinitionModel({
    required String id,
    required String name,
    @Default('') String description,
    @Default({}) Map<String, ModuleAccessLevel> moduleAccess,
  }) = _RoleDefinitionModel;

  factory RoleDefinitionModel.fromJson(Map<String, dynamic> json) => _$RoleDefinitionModelFromJson(json);
}

