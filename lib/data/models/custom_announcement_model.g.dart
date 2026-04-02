// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_announcement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomFieldDefinitionModelImpl _$$CustomFieldDefinitionModelImplFromJson(
  Map<String, dynamic> json,
) => _$CustomFieldDefinitionModelImpl(
  id: json['id'] as String,
  eventId: json['eventId'] as String,
  name: json['name'] as String,
  type: $enumDecode(_$CustomFieldTypeEnumMap, json['type']),
  isRequired: json['isRequired'] as bool? ?? false,
  options: (json['options'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$$CustomFieldDefinitionModelImplToJson(
  _$CustomFieldDefinitionModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'eventId': instance.eventId,
  'name': instance.name,
  'type': _$CustomFieldTypeEnumMap[instance.type]!,
  'isRequired': instance.isRequired,
  'options': instance.options,
};

const _$CustomFieldTypeEnumMap = {
  CustomFieldType.text: 'text',
  CustomFieldType.number: 'number',
  CustomFieldType.dropdown: 'dropdown',
};

_$AnnouncementModelImpl _$$AnnouncementModelImplFromJson(
  Map<String, dynamic> json,
) => _$AnnouncementModelImpl(
  id: json['id'] as String,
  eventId: json['eventId'] as String,
  title: json['title'] as String,
  message: json['message'] as String,
  category: $enumDecode(_$AnnouncementCategoryEnumMap, json['category']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  postedBy: json['postedBy'] as String,
  sendNotification: json['sendNotification'] as bool? ?? true,
);

Map<String, dynamic> _$$AnnouncementModelImplToJson(
  _$AnnouncementModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'eventId': instance.eventId,
  'title': instance.title,
  'message': instance.message,
  'category': _$AnnouncementCategoryEnumMap[instance.category]!,
  'createdAt': instance.createdAt.toIso8601String(),
  'postedBy': instance.postedBy,
  'sendNotification': instance.sendNotification,
};

const _$AnnouncementCategoryEnumMap = {
  AnnouncementCategory.general: 'general',
  AnnouncementCategory.urgent: 'urgent',
  AnnouncementCategory.logistics: 'logistics',
  AnnouncementCategory.update: 'update',
};
