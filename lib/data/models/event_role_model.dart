import 'package:freezed_annotation/freezed_annotation.dart';
export 'event_module.dart';
import 'event_module.dart';

part 'event_role_model.freezed.dart';
part 'event_role_model.g.dart';

Map<String, String> defaultModuleAccessJsonForOwner() {
  return {
    for (final m in EventModules.all) m: ModuleAccessLevel.full.name,
  };
}

Map<String, ModuleAccessLevel> fullAccessForAllModules() {
  return {for (final m in EventModules.all) m: ModuleAccessLevel.full};
}

@freezed
class EventRoleModel with _$EventRoleModel {
  const factory EventRoleModel({
    required String id,
    required String eventId,
    required String name,
    @Default('') String description,
    @Default({}) Map<String, ModuleAccessLevel> moduleAccess,
    @Default([]) List<String> userIds,
    @Default({}) Map<String, String> userResponsibilities,
    @Default(false) bool isSystem,
    String? systemKey, // e.g. "owner"
  }) = _EventRoleModel;

  factory EventRoleModel.fromJson(Map<String, dynamic> json) =>
      _$EventRoleModelFromJson(_migrateRoleJson(json));
}

Map<String, dynamic> _migrateRoleJson(Map<String, dynamic> json) {
  // Back-compat for earlier schemas:
  // - {role: admin/manager/...} core-role based
  // - {permissions: [...]}
  // - {moduleAccess: {module: "view"}}
  final migrated = {...json};

  if (migrated['name'] == null && migrated['role'] != null) {
    final r = migrated['role'].toString();
    migrated['name'] = _coreRoleToName(r);
  }
  migrated['name'] ??= 'Role';

  if (migrated['description'] == null && migrated['responsibilities'] != null) {
    migrated['description'] = migrated['responsibilities'];
  }
  migrated['description'] ??= '';

  final access = decodeModuleAccess(migrated['moduleAccess']);
  migrated['moduleAccess'] = encodeModuleAccess(access);

  migrated['userIds'] ??= const <String>[];
  migrated['userResponsibilities'] ??= const <String, String>{};

  // Back-compat: older "Owner" role may not have system flags.
  migrated['isSystem'] ??= false;
  migrated['systemKey'] ??= null;
  final name = migrated['name']?.toString().trim().toLowerCase();
  if (name == 'owner' && migrated['systemKey'] == null) {
    migrated['isSystem'] = true;
    migrated['systemKey'] = 'owner';
  }

  return migrated;
}

String _coreRoleToName(String role) {
  switch (role) {
    case 'admin':
      return 'Owner';
    case 'manager':
      return 'Manager';
    case 'contributor':
      return 'Contributor';
    case 'viewer':
      return 'Viewer';
    default:
      return role;
  }
}
