import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_invitation_model.freezed.dart';
part 'event_invitation_model.g.dart';

@freezed
class EventInvitationModel with _$EventInvitationModel {
  const factory EventInvitationModel({
    required String id,
    required String eventId,
    required String token,
    required String createdBy,
    required DateTime createdAt,
    DateTime? expiresAt,
    @Default(false) bool isUsed,
    String? usedBy,
    DateTime? usedAt,
    @Default(true) bool isPreApproved, // If false, even token-joins need approval (not requested but flexible)
  }) = _EventInvitationModel;

  factory EventInvitationModel.fromJson(Map<String, dynamic> json) => _$EventInvitationModelFromJson(json);
}
