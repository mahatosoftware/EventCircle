import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_user_model.freezed.dart';
part 'event_user_model.g.dart';

enum EventUserStatus { active, removed }

@freezed
class EventUserModel with _$EventUserModel {
  const factory EventUserModel({
    required String id, // userId
    required String eventId,
    required EventUserStatus status,
    required DateTime addedAt,
    DateTime? removedAt,
    String? addedBy,
  }) = _EventUserModel;

  factory EventUserModel.fromJson(Map<String, dynamic> json) => _$EventUserModelFromJson(json);
}

