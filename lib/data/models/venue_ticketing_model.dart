import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue_ticketing_model.freezed.dart';
part 'venue_ticketing_model.g.dart';

enum TicketVisibility { public, private, inviteOnly }
enum TicketStatus { valid, used, cancelled }

@freezed
class LocationModel with _$LocationModel {
  const factory LocationModel({
    required String id,
    required String eventId,
    required String name,
    required String address,
    String? mapLink,
    String? parkingInfo,
    String? instructions,
    @Default(true) bool isMainVenue,
  }) = _LocationModel;

  factory LocationModel.fromJson(Map<String, dynamic> json) => _$LocationModelFromJson(json);
}

@freezed
class TicketModel with _$TicketModel {
  const factory TicketModel({
    required String id,
    required String eventId,
    required String title, // Early Bird, VIP, etc.
    required double price,
    required int capacity,
    @Default(0) int soldCount,
    String? description,
    
    // Detailed fields for creation & sale
    DateTime? saleStartDate,
    DateTime? saleEndDate,
    @Default(1) int maxTicketsPerUser,
    @Default(TicketVisibility.public) TicketVisibility visibility,
    @Default(false) bool allowAnonymous,
    List<String>? benefits,
  }) = _TicketModel;

  factory TicketModel.fromJson(Map<String, dynamic> json) => _$TicketModelFromJson(json);
}

@freezed
class IssuedTicketModel with _$IssuedTicketModel {
  const factory IssuedTicketModel({
    required String id,
    required String ticketTypeId,
    required String eventId,
    required String attendeeName,
    required String attendeeEmail,
    required String attendeePhone,
    required String qrData,
    @Default(TicketStatus.valid) TicketStatus status,
    DateTime? checkInTime,
    Map<String, dynamic>? customFieldData,
    DateTime? issuedAt,
  }) = _IssuedTicketModel;

  factory IssuedTicketModel.fromJson(Map<String, dynamic> json) => _$IssuedTicketModelFromJson(json);
}

@freezed
class TicketDesignModel with _$TicketDesignModel {
  const factory TicketDesignModel({
    required String eventId,
    String? logoUrl,
    String? bannerUrl,
    @Default('Minimal') String theme,
    String? customMessage,
    @Default(true) bool showAttendeeName,
    @Default(false) bool showSeatNumber,
  }) = _TicketDesignModel;

  factory TicketDesignModel.fromJson(Map<String, dynamic> json) => _$TicketDesignModelFromJson(json);
}
