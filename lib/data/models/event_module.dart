import 'package:flutter/material.dart';

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
  static const String inventory = 'inventory';
  static const String timeline = 'timeline';
  static const String location = 'location';
  static const String ticketing = 'ticketing';
  static const String auditLog = 'auditLog';

  static const List<String> all = [
    budget,
    contribution,
    tasks,
    guests,
    vendors,
    users,
    roles,
    inventory,
    timeline,
    location,
    ticketing,
    auditLog,
  ];

  static String label(String module) {
    switch (module) {
      case budget:
        return 'Budget';
      case contribution:
        return 'Contribution';
      case tasks:
        return 'Tasks';
      case guests:
        return 'Guests';
      case vendors:
        return 'Vendors';
      case users:
        return 'Users';
      case roles:
        return 'Roles';
      case inventory:
        return 'Inventory';
      case timeline:
        return 'Timeline';
      case location:
        return 'Location';
      case ticketing:
        return 'Ticketing';
      case auditLog:
        return 'Audit Log';
      default:
        return module.toUpperCase();
    }
  }

  static IconData icon(String module) {
    switch (module) {
      case budget:
        return Icons.account_balance_wallet_outlined;
      case contribution:
        return Icons.payments_outlined;
      case tasks:
        return Icons.task_alt;
      case guests:
        return Icons.people_outline;
      case vendors:
        return Icons.store_outlined;
      case users:
        return Icons.person_search_outlined;
      case roles:
        return Icons.settings_accessibility_outlined;
      case inventory:
        return Icons.inventory_2_outlined;
      case timeline:
        return Icons.schedule_outlined;
      case location:
        return Icons.location_on_outlined;
      case ticketing:
        return Icons.confirmation_number_outlined;
      case auditLog:
        return Icons.history_outlined;
      default:
        return Icons.extension_outlined;
    }
  }
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

Map<String, ModuleAccessLevel> decodeModuleAccess(dynamic raw) {
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

Map<String, String> encodeModuleAccess(Map<String, ModuleAccessLevel> access) {
  return access.map((k, v) => MapEntry(k, v.name));
}
