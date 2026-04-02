import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_role_model.freezed.dart';
part 'event_role_model.g.dart';

/// Module-level permissions with a small set of access levels.
///
/// - `full`: Create/Edit/Delete/Manage
/// - `edit`: Create + Modify
/// - `update`: Modify existing only
/// - `view`: Read-only
/// - `none`: Hidden / no access
enum ModuleAccessLevel { full, edit, update, view, none }

class EventModules {
  static const String budget = 'budget';
  static const String contribution = 'contribution';
  static const String tasks = 'tasks';
  static const String guests = 'guests';
  static const String vendors = 'vendors';
  static const String users = 'users';
  static const String roles = 'roles';

  static const List<String> all = [budget, contribution, tasks, guests, vendors, users, roles];
}

int accessRank(ModuleAccessLevel level) {
  switch (level) {
    case ModuleAccessLevel.full:
      return 4;
    case ModuleAccessLevel.edit:
      return 3;
    case ModuleAccessLevel.update:
      return 2;
    case ModuleAccessLevel.view:
      return 1;
    case ModuleAccessLevel.none:
      return 0;
  }
}

String accessLevelLabel(ModuleAccessLevel level) {
  switch (level) {
    case ModuleAccessLevel.full:
      return 'Full';
    case ModuleAccessLevel.edit:
      return 'Edit';
    case ModuleAccessLevel.update:
      return 'Update';
    case ModuleAccessLevel.view:
      return 'View';
    case ModuleAccessLevel.none:
      return 'No Access';
  }
}

bool hasAtLeastAccess(ModuleAccessLevel actual, ModuleAccessLevel required) {
  return accessRank(actual) >= accessRank(required);
}

Map<String, ModuleAccessLevel> _decodeModuleAccess(dynamic raw) {
  if (raw is! Map) return {};
  final out = <String, ModuleAccessLevel>{};
  for (final entry in raw.entries) {
    final k = entry.key?.toString();
    if (k == null || k.isEmpty) continue;
    final v = entry.value;
    if (v is String) {
      out[k] = ModuleAccessLevel.values.firstWhere(
        (lvl) => lvl.name == v,
        orElse: () => ModuleAccessLevel.none,
      );
    }
  }
  return out;
}

Map<String, String> _encodeModuleAccess(Map<String, ModuleAccessLevel> access) {
  return access.map((k, v) => MapEntry(k, v.name));
}

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

  final access = _decodeModuleAccess(migrated['moduleAccess']);
  migrated['moduleAccess'] = _encodeModuleAccess(access);

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
