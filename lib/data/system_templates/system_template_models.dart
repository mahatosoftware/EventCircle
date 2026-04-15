import 'dart:convert';

import '../models/event_model.dart';
import '../models/budget_model.dart';
import '../models/task_model.dart';
import '../models/template_model.dart';

class SystemTemplatePack {
  final int schemaVersion;
  final int version;
  final List<SystemTemplateDefinition> templates;

  const SystemTemplatePack({
    required this.schemaVersion,
    required this.version,
    required this.templates,
  });

  static SystemTemplatePack fromJson(Map<String, dynamic> json) {
    final schemaVersion = (json['schemaVersion'] as num?)?.toInt() ?? 1;
    final version = (json['version'] as num?)?.toInt() ?? 0;
    final rawTemplates = json['templates'];
    final templates = <SystemTemplateDefinition>[];
    if (rawTemplates is List) {
      for (final t in rawTemplates) {
        if (t is Map<String, dynamic>) {
          templates.add(SystemTemplateDefinition.fromJson(t));
        }
      }
    }
    return SystemTemplatePack(schemaVersion: schemaVersion, version: version, templates: templates);
  }

  static SystemTemplatePack fromJsonString(String raw) {
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
  final List<BudgetItemModel> budgetBlueprints;
  final int version;
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
    required this.budgetBlueprints,
    required this.version,
    required this.templateCode,
    required this.tags,
    required this.isPublic,
  });

  static SystemTemplateDefinition fromJson(Map<String, dynamic> json) {
    final templateId = (json['templateId'] as String?)?.trim();
    final templateName = (json['templateName'] as String?)?.trim();
    final category = _eventCategoryFromJsonValue(json['category']);
    final description = (json['description'] as String?)?.trim() ?? '';
    final defaultFields = (json['defaultFields'] is Map<String, dynamic>)
        ? (json['defaultFields'] as Map<String, dynamic>)
        : <String, dynamic>{};
    final taskBlueprints = _taskBlueprintsFromJsonValue(json['taskBlueprints']);
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
      throw FormatException('System template "$templateId" has invalid category');
    }

    return SystemTemplateDefinition(
      templateId: templateId,
      templateName: templateName,
      category: category,
      description: description,
      defaultFields: defaultFields,
      taskBlueprints: taskBlueprints,
      budgetBlueprints: budgetBlueprints,
      version: version,
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
    } catch (_) {
      // Ignore invalid blueprint entries.
    }
  }
  return out;
}
