// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InventoryItemModelImpl _$$InventoryItemModelImplFromJson(
  Map<String, dynamic> json,
) => _$InventoryItemModelImpl(
  id: json['id'] as String,
  eventId: json['eventId'] as String,
  name: json['name'] as String,
  quantity: (json['quantity'] as num).toDouble(),
  unit: json['unit'] as String,
  category: json['category'] as String,
  status:
      $enumDecodeNullable(_$InventoryStatusEnumMap, json['status']) ??
      InventoryStatus.needed,
  estimatedCost: (json['estimatedCost'] as num?)?.toDouble(),
  responsibleRole: json['responsibleRole'] as String?,
  note: json['note'] as String?,
);

Map<String, dynamic> _$$InventoryItemModelImplToJson(
  _$InventoryItemModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'eventId': instance.eventId,
  'name': instance.name,
  'quantity': instance.quantity,
  'unit': instance.unit,
  'category': instance.category,
  'status': _$InventoryStatusEnumMap[instance.status]!,
  'estimatedCost': instance.estimatedCost,
  'responsibleRole': instance.responsibleRole,
  'note': instance.note,
};

const _$InventoryStatusEnumMap = {
  InventoryStatus.needed: 'needed',
  InventoryStatus.procured: 'procured',
  InventoryStatus.consumed: 'consumed',
};
