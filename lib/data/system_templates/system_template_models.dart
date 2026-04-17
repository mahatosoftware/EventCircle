import 'dart:convert';

import '../models/event_model.dart';
import '../models/budget_model.dart';
import '../models/task_model.dart';
import '../models/template_model.dart';
import '../models/timeline_model.dart';
import '../models/vendor_model.dart';
import '../models/inventory_model.dart';
import '../models/role_definition_model.dart';
import '../models/venue_ticketing_model.dart';
import '../models/custom_announcement_model.dart';

class SystemTemplatePack {
  final int schemaVersion;
  final int version;
  final List<SystemTemplateDefinition> templates;

  const SystemTemplatePack({
    required this.schemaVersion,
    required this.version,
    required this.templates,
  });

  static SystemTemplatePack fromJson(Map<String, dynamic> json, {String? contentHash}) {
    final schemaVersion = (json['schemaVersion'] as num?)?.toInt() ?? 1;
    final version = (json['version'] as num?)?.toInt() ?? 0;
    final rawTemplates = json['templates'];
    final templates = <SystemTemplateDefinition>[];
    if (rawTemplates is List) {
      for (final t in rawTemplates) {
        if (t is Map<String, dynamic>) {
          templates.add(SystemTemplateDefinition.fromJson(t, contentHash: contentHash));
        }
      }
    }
    return SystemTemplatePack(schemaVersion: schemaVersion, version: version, templates: templates);
  }

  static SystemTemplatePack fromJsonString(String raw) {
    // Note: We don't hash here yet because AssetSystemTemplateSource handles individual file hashing.
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('System templates JSON root is not an object');
    }
    return SystemTemplatePack.fromJson(decoded);
  }
}

class SystemTemplateDefinition {
  final String templateId;
  final String templateName;
  final EventCategory category;
  final String description;
  final Map<String, dynamic> defaultFields;
  final List<TaskModel> taskBlueprints;
  final List<TimelineItemModel> timelineBlueprints;
  final List<VendorModel> vendorBlueprints;
  final List<InventoryItemModel> inventoryBlueprints;
  final List<RoleDefinitionModel> roleBlueprints;
  final List<LocationModel> venueBlueprints;
  final List<TicketModel> ticketBlueprints;
  final List<CustomFieldDefinitionModel> customFieldBlueprints;
  final List<AnnouncementModel> announcementBlueprints;
  final List<BudgetItemModel> budgetBlueprints;
  final int version;
  final String? contentHash;
  final String? templateCode;
  final List<String> tags;
  final bool isPublic;

  const SystemTemplateDefinition({
    required this.templateId,
    required this.templateName,
    required this.category,
    required this.description,
    required this.defaultFields,
    required this.taskBlueprints,
    required this.timelineBlueprints,
    required this.vendorBlueprints,
    required this.inventoryBlueprints,
    required this.roleBlueprints,
    required this.venueBlueprints,
    required this.ticketBlueprints,
    required this.customFieldBlueprints,
    required this.announcementBlueprints,
    required this.budgetBlueprints,
    required this.version,
    this.contentHash,
    this.templateCode,
    required this.tags,
    required this.isPublic,
  });

  static SystemTemplateDefinition fromJson(Map<String, dynamic> json, {String? contentHash}) {
    final templateId = (json['templateId'] as String?)?.trim();
    final templateName = (json['templateName'] as String?)?.trim();
    final categoryValue = json['category'];
    final category = _eventCategoryFromJsonValue(categoryValue);
    final description = (json['description'] as String?)?.trim() ?? '';
    final defaultFields = (json['defaultFields'] is Map<String, dynamic>)
        ? (json['defaultFields'] as Map<String, dynamic>)
        : <String, dynamic>{};
    final taskBlueprints = _taskBlueprintsFromJsonValue(json['taskBlueprints']);
    final timelineBlueprints = _timelineBlueprintsFromJsonValue(json['timelineBlueprints']);
    final vendorBlueprints = _vendorBlueprintsFromJsonValue(json['vendorBlueprints']);
    final inventoryBlueprints = _inventoryBlueprintsFromJsonValue(json['inventoryBlueprints']);
    final roleBlueprints = _roleBlueprintsFromJsonValue(json['roleBlueprints']);
    final venueBlueprints = _venueBlueprintsFromJsonValue(json['venueBlueprints']);
    final ticketBlueprints = _ticketBlueprintsFromJsonValue(json['ticketBlueprints']);
    final customFieldBlueprints = _customFieldBlueprintsFromJsonValue(json['customFieldBlueprints']);
    final announcementBlueprints = _announcementBlueprintsFromJsonValue(json['announcementBlueprints']);
    final budgetBlueprints = _budgetBlueprintsFromJsonValue(json['budgetBlueprints']);
    final version = (json['version'] as num?)?.toInt() ?? 1;
    final templateCode = (json['templateCode'] as String?)?.trim();
    final isPublic = json['isPublic'] is bool ? (json['isPublic'] as bool) : true;
    final tags = <String>[];
    final rawTags = json['tags'];
    if (rawTags is List) {
      for (final t in rawTags) {
        if (t is String && t.trim().isNotEmpty) tags.add(t.trim());
      }
    }

    if (templateId == null || templateId.isEmpty) {
      throw const FormatException('System template is missing templateId');
    }
    if (templateName == null || templateName.isEmpty) {
      throw const FormatException('System template is missing templateName');
    }
    if (category == null) {
      throw FormatException('System template "$templateId" has invalid category: $categoryValue');
    }

    return SystemTemplateDefinition(
      templateId: templateId,
      templateName: templateName,
      category: category,
      description: description,
      defaultFields: {...defaultFields, if (contentHash != null) 'contentHash': contentHash},
      taskBlueprints: taskBlueprints,
      timelineBlueprints: timelineBlueprints,
      vendorBlueprints: vendorBlueprints,
      inventoryBlueprints: inventoryBlueprints,
      roleBlueprints: roleBlueprints,
      venueBlueprints: venueBlueprints,
      ticketBlueprints: ticketBlueprints,
      customFieldBlueprints: customFieldBlueprints,
      announcementBlueprints: announcementBlueprints,
      budgetBlueprints: budgetBlueprints,
      version: version,
      contentHash: contentHash,
      templateCode: templateCode,
      tags: tags,
      isPublic: isPublic,
    );
  }

  TemplateModel toTemplateModel({
    required String systemCreatedBy,
  }) {
    final contributionType = _contributionTypeFromJsonValue(defaultFields['contributionType']) ?? ContributionType.fixed;
    final enabledModules = _templateModulesFromJsonValue(defaultFields['enabledModules']);

    return TemplateModel(
      id: templateId,
      title: templateName,
      description: description,
      category: category,
      contributionType: contributionType,
      createdBy: systemCreatedBy,
      tags: tags,
      config: defaultFields,
      taskBlueprints: taskBlueprints,
      timelineBlueprints: timelineBlueprints,
      vendorBlueprints: vendorBlueprints,
      inventoryBlueprints: inventoryBlueprints,
      roleBlueprints: roleBlueprints,
      venueBlueprints: venueBlueprints,
      ticketBlueprints: ticketBlueprints,
      customFieldBlueprints: customFieldBlueprints,
      announcementBlueprints: announcementBlueprints,
      budgetBlueprints: budgetBlueprints,
      enabledModules: enabledModules,
      version: version,
      isPublic: isPublic,
      templateCode: templateCode,
    );
  }
}

EventCategory? _eventCategoryFromJsonValue(dynamic value) {
  if (value is! String) return null;
  for (final c in EventCategory.values) {
    if (c.name == value) return c;
  }
  return null;
}

ContributionType? _contributionTypeFromJsonValue(dynamic value) {
  if (value is! String) return null;
  for (final c in ContributionType.values) {
    if (c.name == value) return c;
  }
  return null;
}

List<TemplateModule> _templateModulesFromJsonValue(dynamic value) {
  if (value is! List) return const [];
  final out = <TemplateModule>[];
  for (final v in value) {
    if (v is! String) continue;
    for (final m in TemplateModule.values) {
      if (m.name == v) {
        out.add(m);
        break;
      }
    }
  }
  return out;
}

List<TaskModel> _taskBlueprintsFromJsonValue(dynamic value) {
  if (value is! List) return const [];
  final out = <TaskModel>[];
  for (final v in value) {
    if (v is! Map<String, dynamic>) continue;
    try {
      out.add(TaskModel.fromJson(v));
    } catch (_) {
      // Ignore invalid blueprint entries.
    }
  }
  return out;
}

List<BudgetItemModel> _budgetBlueprintsFromJsonValue(dynamic value) {
  if (value is! List) return const [];
  final out = <BudgetItemModel>[];
  for (final v in value) {
    if (v is! Map<String, dynamic>) continue;
    try {
      out.add(BudgetItemModel.fromJson(v));
    } catch (_) {}
  }
  return out;
}

List<TimelineItemModel> _timelineBlueprintsFromJsonValue(dynamic value) {
  if (value is! List) return const [];
  final out = <TimelineItemModel>[];
  for (final v in value) {
    if (v is! Map<String, dynamic>) continue;
    try {
      out.add(TimelineItemModel.fromJson(v));
    } catch (_) {}
  }
  return out;
}

List<VendorModel> _vendorBlueprintsFromJsonValue(dynamic value) {
  if (value is! List) return const [];
  final out = <VendorModel>[];
  for (final v in value) {
    if (v is! Map<String, dynamic>) continue;
    try {
      out.add(VendorModel.fromJson(v));
    } catch (_) {}
  }
  return out;
}

List<InventoryItemModel> _inventoryBlueprintsFromJsonValue(dynamic value) {
  if (value is! List) return const [];
  final out = <InventoryItemModel>[];
  for (final v in value) {
    if (v is! Map<String, dynamic>) continue;
    try {
      out.add(InventoryItemModel.fromJson(v));
    } catch (_) {}
  }
  return out;
}

List<RoleDefinitionModel> _roleBlueprintsFromJsonValue(dynamic value) {
  if (value is! List) return const [];
  final out = <RoleDefinitionModel>[];
  for (final v in value) {
    if (v is! Map<String, dynamic>) continue;
    try {
      out.add(RoleDefinitionModel.fromJson(v));
    } catch (_) {}
  }
  return out;
}

List<LocationModel> _venueBlueprintsFromJsonValue(dynamic value) {
  if (value is! List) return const [];
  final out = <LocationModel>[];
  for (final v in value) {
    if (v is! Map<String, dynamic>) continue;
    try {
      out.add(LocationModel.fromJson(v));
    } catch (_) {}
  }
  return out;
}

List<TicketModel> _ticketBlueprintsFromJsonValue(dynamic value) {
  if (value is! List) return const [];
  final out = <TicketModel>[];
  for (final v in value) {
    if (v is! Map<String, dynamic>) continue;
    try {
      out.add(TicketModel.fromJson(v));
    } catch (_) {}
  }
  return out;
}

List<CustomFieldDefinitionModel> _customFieldBlueprintsFromJsonValue(dynamic value) {
  if (value is! List) return const [];
  final out = <CustomFieldDefinitionModel>[];
  for (final v in value) {
    if (v is! Map<String, dynamic>) continue;
    try {
      out.add(CustomFieldDefinitionModel.fromJson(v));
    } catch (_) {}
  }
  return out;
}

List<AnnouncementModel> _announcementBlueprintsFromJsonValue(dynamic value) {
  if (value is! List) return const [];
  final out = <AnnouncementModel>[];
  for (final v in value) {
    if (v is! Map<String, dynamic>) continue;
    try {
      out.add(AnnouncementModel.fromJson(v));
    } catch (_) {}
  }
  return out;
}
