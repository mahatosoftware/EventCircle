import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_announcement_model.freezed.dart';
part 'custom_announcement_model.g.dart';

enum CustomFieldType { text, number, dropdown }

@freezed
class CustomFieldDefinitionModel with _$CustomFieldDefinitionModel {
  const factory CustomFieldDefinitionModel({
    required String id,
    required String eventId,
    required String name,
    required CustomFieldType type,
    @Default(false) bool isRequired,
    List<String>? options, // For dropdowns
  }) = _CustomFieldDefinitionModel;

  factory CustomFieldDefinitionModel.fromJson(Map<String, dynamic> json) => _$CustomFieldDefinitionModelFromJson(json);
}

enum AnnouncementCategory { general, urgent, logistics, update }

@freezed
class AnnouncementModel with _$AnnouncementModel {
  const factory AnnouncementModel({
    required String id,
    required String eventId,
    required String title,
    required String message,
    required AnnouncementCategory category,
    required DateTime createdAt,
    required String postedBy,
    @Default(true) bool sendNotification,
  }) = _AnnouncementModel;

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) => _$AnnouncementModelFromJson(json);
}
