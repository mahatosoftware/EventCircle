import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_model.freezed.dart';
part 'member_model.g.dart';

enum MemberStatus { invited, paid, pending, partiallyPaid }

enum RsvpStatus { attending, maybe, declined, none }

extension RsvpStatusExtension on RsvpStatus {
  String get displayName {
    switch (this) {
      case RsvpStatus.attending: return 'Attending';
      case RsvpStatus.maybe: return 'Maybe';
      case RsvpStatus.declined: return 'Declined';
      case RsvpStatus.none: return 'None';
    }
  }
}

@freezed
class MemberModel with _$MemberModel {
  const factory MemberModel({
    required String id,
    required String eventId,
    required String name,
    required String phone,
    required String identifier, // e.g., flat number
    required MemberStatus status,
    required DateTime joinedAt,
    String? guestCategory, // Family, VIP, Member
    @Default(RsvpStatus.none) RsvpStatus rsvpStatus,
    @Default(0) int plusOnes,
    double? assignedAmount, // For variable contribution
    String? groupId, // For group-based contribution
    String? selectedTier, // For tier-based contribution
    Map<String, dynamic>? metadata, // For tickets, items, etc. (Guest preferences, etc.)
  }) = _MemberModel;

  factory MemberModel.fromJson(Map<String, dynamic> json) => _$MemberModelFromJson(json);
}
