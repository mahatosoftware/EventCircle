// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventModelImpl _$$EventModelImplFromJson(Map<String, dynamic> json) =>
    _$EventModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      organizerId: json['organizerId'] as String,
      amount: (json['amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      category: $enumDecode(_$EventCategoryEnumMap, json['category']),
      contributionType: $enumDecode(
        _$ContributionTypeEnumMap,
        json['contributionType'],
      ),
      hybridSettings: json['hybridSettings'] as Map<String, dynamic>?,
      location: json['location'] as String?,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      tiers: (json['tiers'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      itemTargets: (json['itemTargets'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as Map<String, dynamic>),
      ),
      groups: (json['groups'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      recurringPeriod: json['recurringPeriod'] as String?,
      note: json['note'] as String?,
      templateId: json['templateId'] as String?,
      templateSnapshot: json['templateSnapshot'] as Map<String, dynamic>?,
      isHybrid: json['isHybrid'] as bool? ?? false,
      activeModels:
          (json['activeModels'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$ContributionTypeEnumMap, e))
              .toList() ??
          const [],
      allowedPaymentMethods:
          (json['allowedPaymentMethods'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['UPI', 'Cash'],
      contributionTargetGroup: json['contributionTargetGroup'] as String?,
      maxGuests: (json['maxGuests'] as num?)?.toInt(),
      isRsvpRequired: json['isRsvpRequired'] as bool? ?? false,
      guestCategories:
          (json['guestCategories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      guestMetadataFields:
          (json['guestMetadataFields'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isExpenseApprovalRequired:
          json['isExpenseApprovalRequired'] as bool? ?? false,
      expenseCategories:
          (json['expenseCategories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['Venue', 'Food', 'Decoration', 'Miscellaneous'],
    );

Map<String, dynamic> _$$EventModelImplToJson(_$EventModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'organizerId': instance.organizerId,
      'amount': instance.amount,
      'createdAt': instance.createdAt.toIso8601String(),
      'category': _$EventCategoryEnumMap[instance.category]!,
      'contributionType': _$ContributionTypeEnumMap[instance.contributionType]!,
      'hybridSettings': instance.hybridSettings,
      'location': instance.location,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'tiers': instance.tiers,
      'itemTargets': instance.itemTargets,
      'groups': instance.groups,
      'recurringPeriod': instance.recurringPeriod,
      'note': instance.note,
      'templateId': instance.templateId,
      'templateSnapshot': instance.templateSnapshot,
      'isHybrid': instance.isHybrid,
      'activeModels': instance.activeModels
          .map((e) => _$ContributionTypeEnumMap[e]!)
          .toList(),
      'allowedPaymentMethods': instance.allowedPaymentMethods,
      'contributionTargetGroup': instance.contributionTargetGroup,
      'maxGuests': instance.maxGuests,
      'isRsvpRequired': instance.isRsvpRequired,
      'guestCategories': instance.guestCategories,
      'guestMetadataFields': instance.guestMetadataFields,
      'isExpenseApprovalRequired': instance.isExpenseApprovalRequired,
      'expenseCategories': instance.expenseCategories,
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
