import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

enum EventCategory {
  communityAndCultural('Community & Cultural'),
  socialAndPersonal('Social & Personal'),
  corporate('Corporate'),
  educational('Educational'),
  sportsAndActivity('Sports & Activity'),
  entertainment('Entertainment'),
  religiousAndSpiritual('Religious & Spiritual'),
  charityAndFundraising('Charity & Fundraising'),
  commercialAndExhibition('Commercial & Exhibition');

  final String displayName;
  const EventCategory(this.displayName);
}

enum ContributionType {
  fixed('Fixed Contribution', 'Everyone pays the same amount (e.g. ₹500 per flat)'),
  variable('Variable Contribution', 'Amount differs per person (e.g. family vs bachelor)'),
  voluntary('Voluntary / Donation', 'Pay any amount you wish'),
  tierBased('Tier-Based', 'Predefined tiers (Silver, Gold, Platinum)'),
  itemBased('Item-Based', 'Contribute for specific items (Food, Decoration)'),
  groupBased('Group-Based', 'One payment per group (Family, Flat, Team)'),
  recurring('Recurring', 'Periodic payments (Monthly maintenance)'),
  ticketBased('Ticket-Based', 'Payment equals entry ticket'),
  sponsor('Sponsor Contribution', 'Large contributions from sponsors');

  final String displayName;
  final String description;
  const ContributionType(this.displayName, this.description);
}

@freezed
class EventModel with _$EventModel {
  const factory EventModel({
    required String id,
    required String title,
    required String description,
    required String organizerId,
    required double amount,
    required DateTime createdAt,
    required EventCategory category,
    required ContributionType contributionType,
    Map<String, dynamic>? hybridSettings, // e.g. {"fixed": 500, "donation": true}
    String? location,
    DateTime? startDate,
    DateTime? endDate,
    Map<String, double>? tiers, // {'Silver': 500, 'Gold': 1000}
    Map<String, Map<String, dynamic>>? itemTargets, // {'Food': {'target': 10000, 'collected': 0}}
    List<String>? groups, // For group-based tracking
    String? recurringPeriod, // 'monthly', etc.
    String? note,
    String? templateId,
    Map<String, dynamic>? templateSnapshot,
    @Default(false) bool isHybrid,
    @Default([]) List<ContributionType> activeModels,
    @Default(['UPI', 'Cash']) List<String> allowedPaymentMethods,
    String? contributionTargetGroup, // "All members", "Only heads", etc.
    // Guest Management
    int? maxGuests,
    @Default(false) bool isRsvpRequired,
    @Default([]) List<String> guestCategories, // e.g. ["Family", "VIP", "Member"]
    @Default([]) List<String> guestMetadataFields, // e.g. ["Food Pref", "Allergy"]
    // Expense Tracking
    @Default(false) bool isExpenseApprovalRequired,
    @Default(['Venue', 'Food', 'Decoration', 'Miscellaneous']) List<String> expenseCategories,
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) => _$EventModelFromJson(json);
}
