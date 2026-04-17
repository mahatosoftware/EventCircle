// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TemplateModelImpl _$$TemplateModelImplFromJson(
  Map<String, dynamic> json,
) => _$TemplateModelImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  category: $enumDecode(_$EventCategoryEnumMap, json['category']),
  contributionType: $enumDecode(
    _$ContributionTypeEnumMap,
    json['contributionType'],
  ),
  createdBy: json['createdBy'] as String,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  config: json['config'] as Map<String, dynamic>?,
  taskBlueprints:
      (json['taskBlueprints'] as List<dynamic>?)
          ?.map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  timelineBlueprints:
      (json['timelineBlueprints'] as List<dynamic>?)
          ?.map((e) => TimelineItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  vendorBlueprints:
      (json['vendorBlueprints'] as List<dynamic>?)
          ?.map((e) => VendorModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  inventoryBlueprints:
      (json['inventoryBlueprints'] as List<dynamic>?)
          ?.map((e) => InventoryItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  roleBlueprints:
      (json['roleBlueprints'] as List<dynamic>?)
          ?.map((e) => RoleDefinitionModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  venueBlueprints:
      (json['venueBlueprints'] as List<dynamic>?)
          ?.map((e) => LocationModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  ticketBlueprints:
      (json['ticketBlueprints'] as List<dynamic>?)
          ?.map((e) => TicketModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  customFieldBlueprints:
      (json['customFieldBlueprints'] as List<dynamic>?)
          ?.map(
            (e) =>
                CustomFieldDefinitionModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  announcementBlueprints:
      (json['announcementBlueprints'] as List<dynamic>?)
          ?.map((e) => AnnouncementModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  budgetBlueprints:
      (json['budgetBlueprints'] as List<dynamic>?)
          ?.map((e) => BudgetItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  enabledModules:
      (json['enabledModules'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$TemplateModuleEnumMap, e))
          .toList() ??
      const [],
  usageCount: (json['usageCount'] as num?)?.toInt() ?? 0,
  rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
  isPublic: json['isPublic'] as bool? ?? true,
  version: (json['version'] as num?)?.toInt() ?? 1,
  templateCode: json['templateCode'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$TemplateModelImplToJson(_$TemplateModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': _$EventCategoryEnumMap[instance.category]!,
      'contributionType': _$ContributionTypeEnumMap[instance.contributionType]!,
      'createdBy': instance.createdBy,
      'tags': instance.tags,
      'config': instance.config,
      'taskBlueprints': instance.taskBlueprints,
      'timelineBlueprints': instance.timelineBlueprints,
      'vendorBlueprints': instance.vendorBlueprints,
      'inventoryBlueprints': instance.inventoryBlueprints,
      'roleBlueprints': instance.roleBlueprints,
      'venueBlueprints': instance.venueBlueprints,
      'ticketBlueprints': instance.ticketBlueprints,
      'customFieldBlueprints': instance.customFieldBlueprints,
      'announcementBlueprints': instance.announcementBlueprints,
      'budgetBlueprints': instance.budgetBlueprints,
      'enabledModules': instance.enabledModules
          .map((e) => _$TemplateModuleEnumMap[e]!)
          .toList(),
      'usageCount': instance.usageCount,
      'rating': instance.rating,
      'isPublic': instance.isPublic,
      'version': instance.version,
      'templateCode': instance.templateCode,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$EventCategoryEnumMap = {
  EventCategory.communityAndCultural: 'communityAndCultural',
  EventCategory.socialAndPersonal: 'socialAndPersonal',
  EventCategory.corporate: 'corporate',
  EventCategory.educational: 'educational',
  EventCategory.sportsAndActivity: 'sportsAndActivity',
  EventCategory.entertainment: 'entertainment',
  EventCategory.religiousAndSpiritual: 'religiousAndSpiritual',
  EventCategory.charityAndFundraising: 'charityAndFundraising',
  EventCategory.commercialAndExhibition: 'commercialAndExhibition',
  EventCategory.travel: 'travel',
  EventCategory.kids: 'kids',
  EventCategory.personal: 'personal',
};

const _$ContributionTypeEnumMap = {
  ContributionType.fixed: 'fixed',
  ContributionType.variable: 'variable',
  ContributionType.voluntary: 'voluntary',
  ContributionType.tierBased: 'tierBased',
  ContributionType.itemBased: 'itemBased',
  ContributionType.groupBased: 'groupBased',
  ContributionType.recurring: 'recurring',
  ContributionType.ticketBased: 'ticketBased',
  ContributionType.sponsor: 'sponsor',
  ContributionType.none: 'none',
};

const _$TemplateModuleEnumMap = {
  TemplateModule.task: 'task',
  TemplateModule.budget: 'budget',
  TemplateModule.contribution: 'contribution',
  TemplateModule.userManagement: 'userManagement',
  TemplateModule.guestManagement: 'guestManagement',
  TemplateModule.timeline: 'timeline',
  TemplateModule.vendor: 'vendor',
  TemplateModule.inventory: 'inventory',
  TemplateModule.communication: 'communication',
  TemplateModule.roles: 'roles',
  TemplateModule.expenses: 'expenses',
  TemplateModule.location: 'location',
  TemplateModule.ticketing: 'ticketing',
  TemplateModule.customFields: 'customFields',
  TemplateModule.announcements: 'announcements',
};
