// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_ticketing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LocationModelImpl _$$LocationModelImplFromJson(Map<String, dynamic> json) =>
    _$LocationModelImpl(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      mapLink: json['mapLink'] as String?,
      parkingInfo: json['parkingInfo'] as String?,
      instructions: json['instructions'] as String?,
      isMainVenue: json['isMainVenue'] as bool? ?? true,
    );

Map<String, dynamic> _$$LocationModelImplToJson(_$LocationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'name': instance.name,
      'address': instance.address,
      'mapLink': instance.mapLink,
      'parkingInfo': instance.parkingInfo,
      'instructions': instance.instructions,
      'isMainVenue': instance.isMainVenue,
    };

_$TicketModelImpl _$$TicketModelImplFromJson(Map<String, dynamic> json) =>
    _$TicketModelImpl(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      capacity: (json['capacity'] as num).toInt(),
      soldCount: (json['soldCount'] as num?)?.toInt() ?? 0,
      description: json['description'] as String?,
      saleStartDate: json['saleStartDate'] == null
          ? null
          : DateTime.parse(json['saleStartDate'] as String),
      saleEndDate: json['saleEndDate'] == null
          ? null
          : DateTime.parse(json['saleEndDate'] as String),
      maxTicketsPerUser: (json['maxTicketsPerUser'] as num?)?.toInt() ?? 1,
      visibility:
          $enumDecodeNullable(_$TicketVisibilityEnumMap, json['visibility']) ??
          TicketVisibility.public,
      allowAnonymous: json['allowAnonymous'] as bool? ?? false,
      benefits: (json['benefits'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$TicketModelImplToJson(_$TicketModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'title': instance.title,
      'price': instance.price,
      'capacity': instance.capacity,
      'soldCount': instance.soldCount,
      'description': instance.description,
      'saleStartDate': instance.saleStartDate?.toIso8601String(),
      'saleEndDate': instance.saleEndDate?.toIso8601String(),
      'maxTicketsPerUser': instance.maxTicketsPerUser,
      'visibility': _$TicketVisibilityEnumMap[instance.visibility]!,
      'allowAnonymous': instance.allowAnonymous,
      'benefits': instance.benefits,
    };

const _$TicketVisibilityEnumMap = {
  TicketVisibility.public: 'public',
  TicketVisibility.private: 'private',
  TicketVisibility.inviteOnly: 'inviteOnly',
};

_$IssuedTicketModelImpl _$$IssuedTicketModelImplFromJson(
  Map<String, dynamic> json,
) => _$IssuedTicketModelImpl(
  id: json['id'] as String,
  ticketTypeId: json['ticketTypeId'] as String,
  eventId: json['eventId'] as String,
  attendeeName: json['attendeeName'] as String,
  attendeeEmail: json['attendeeEmail'] as String,
  attendeePhone: json['attendeePhone'] as String,
  qrData: json['qrData'] as String,
  status:
      $enumDecodeNullable(_$TicketStatusEnumMap, json['status']) ??
      TicketStatus.valid,
  checkInTime: json['checkInTime'] == null
      ? null
      : DateTime.parse(json['checkInTime'] as String),
  customFieldData: json['customFieldData'] as Map<String, dynamic>?,
  issuedAt: json['issuedAt'] == null
      ? null
      : DateTime.parse(json['issuedAt'] as String),
);

Map<String, dynamic> _$$IssuedTicketModelImplToJson(
  _$IssuedTicketModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'ticketTypeId': instance.ticketTypeId,
  'eventId': instance.eventId,
  'attendeeName': instance.attendeeName,
  'attendeeEmail': instance.attendeeEmail,
  'attendeePhone': instance.attendeePhone,
  'qrData': instance.qrData,
  'status': _$TicketStatusEnumMap[instance.status]!,
  'checkInTime': instance.checkInTime?.toIso8601String(),
  'customFieldData': instance.customFieldData,
  'issuedAt': instance.issuedAt?.toIso8601String(),
};

const _$TicketStatusEnumMap = {
  TicketStatus.valid: 'valid',
  TicketStatus.used: 'used',
  TicketStatus.cancelled: 'cancelled',
};

_$TicketDesignModelImpl _$$TicketDesignModelImplFromJson(
  Map<String, dynamic> json,
) => _$TicketDesignModelImpl(
  eventId: json['eventId'] as String,
  logoUrl: json['logoUrl'] as String?,
  bannerUrl: json['bannerUrl'] as String?,
  theme: json['theme'] as String? ?? 'Minimal',
  customMessage: json['customMessage'] as String?,
  showAttendeeName: json['showAttendeeName'] as bool? ?? true,
  showSeatNumber: json['showSeatNumber'] as bool? ?? false,
);

Map<String, dynamic> _$$TicketDesignModelImplToJson(
  _$TicketDesignModelImpl instance,
) => <String, dynamic>{
  'eventId': instance.eventId,
  'logoUrl': instance.logoUrl,
  'bannerUrl': instance.bannerUrl,
  'theme': instance.theme,
  'customMessage': instance.customMessage,
  'showAttendeeName': instance.showAttendeeName,
  'showSeatNumber': instance.showSeatNumber,
};
