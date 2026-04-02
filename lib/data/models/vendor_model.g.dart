// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VendorModelImpl _$$VendorModelImplFromJson(Map<String, dynamic> json) =>
    _$VendorModelImpl(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      title: json['title'] as String,
      role: json['role'] as String,
      status:
          $enumDecodeNullable(_$VendorStatusEnumMap, json['status']) ??
          VendorStatus.searching,
      name: json['name'] as String?,
      contact: json['contact'] as String?,
      selectionCriteria: json['selectionCriteria'] as String?,
      suggestions: json['suggestions'] as String?,
      quotedPrice: (json['quotedPrice'] as num?)?.toDouble(),
      finalPrice: (json['finalPrice'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$VendorModelImplToJson(_$VendorModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'title': instance.title,
      'role': instance.role,
      'status': _$VendorStatusEnumMap[instance.status]!,
      'name': instance.name,
      'contact': instance.contact,
      'selectionCriteria': instance.selectionCriteria,
      'suggestions': instance.suggestions,
      'quotedPrice': instance.quotedPrice,
      'finalPrice': instance.finalPrice,
    };

const _$VendorStatusEnumMap = {
  VendorStatus.searching: 'searching',
  VendorStatus.shortlisted: 'shortlisted',
  VendorStatus.contracted: 'contracted',
  VendorStatus.paid: 'paid',
};
