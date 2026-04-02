// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BudgetItemModelImpl _$$BudgetItemModelImplFromJson(
  Map<String, dynamic> json,
) => _$BudgetItemModelImpl(
  id: json['id'] as String,
  eventId: json['eventId'] as String,
  category: json['category'] as String,
  title: json['title'] as String,
  estimatedCost: (json['estimatedCost'] as num).toDouble(),
  isMandatory: json['isMandatory'] as bool? ?? true,
  actualCost: (json['actualCost'] as num?)?.toDouble() ?? 0.0,
  note: json['note'] as String?,
);

Map<String, dynamic> _$$BudgetItemModelImplToJson(
  _$BudgetItemModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'eventId': instance.eventId,
  'category': instance.category,
  'title': instance.title,
  'estimatedCost': instance.estimatedCost,
  'isMandatory': instance.isMandatory,
  'actualCost': instance.actualCost,
  'note': instance.note,
};
