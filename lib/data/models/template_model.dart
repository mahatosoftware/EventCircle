import 'package:freezed_annotation/freezed_annotation.dart';
import 'event_model.dart';
import 'task_model.dart';
import 'timeline_model.dart';
import 'vendor_model.dart';
import 'inventory_model.dart';
import 'role_definition_model.dart';
import 'venue_ticketing_model.dart';
import 'custom_announcement_model.dart';
import 'budget_model.dart';

part 'template_model.freezed.dart';
part 'template_model.g.dart';

enum TemplateModule {
  task('TASK'),
  budget('BUDGET & EXPENSE TRACKING'),
  contribution('CONTRIBUTION'),
  userManagement('USER MANAGEMENT'),
  guestManagement('GUEST MANAGEMENT'),
  timeline('SCHEDULE / TIMELINE'),
  vendor('VENDOR'),
  inventory('ITEMS / PROCUREMENT'),
  communication('COMMUNICATION'),
  roles('ROLES & PERMISSIONS'),
  expenses('EXPENSE TRACKING'),
  location('LOCATION '),
  ticketing('TICKETING'),
  customFields('CUSTOM FIELDS'),
  announcements('ANNOUNCEMENT');

  final String displayName;
  const TemplateModule(this.displayName);
}

@freezed
class TemplateModel with _$TemplateModel {
  const factory TemplateModel({
    required String id,
    required String title,
    required String description,
    required EventCategory category,
    required ContributionType contributionType,
    required String createdBy,
    @Default([]) List<String> tags,
    Map<String, dynamic>? config, // Holds contribution, guest, and expense configs as needed
    @Default([]) List<TaskModel> taskBlueprints,
    @Default([]) List<TimelineItemModel> timelineBlueprints,
    @Default([]) List<VendorModel> vendorBlueprints,
    @Default([]) List<InventoryItemModel> inventoryBlueprints,
    @Default([]) List<RoleDefinitionModel> roleBlueprints,
    @Default([]) List<LocationModel> venueBlueprints,
    @Default([]) List<TicketModel> ticketBlueprints,
    @Default([]) List<CustomFieldDefinitionModel> customFieldBlueprints,
    @Default([]) List<AnnouncementModel> announcementBlueprints,
    @Default([]) List<BudgetItemModel> budgetBlueprints,
    @Default([]) List<TemplateModule> enabledModules,
    @Default(0) int usageCount,
    @Default(0.0) double rating,
    @Default(true) bool isPublic,
    @Default(1) int version,
    String? templateCode,
    DateTime? createdAt,
  }) = _TemplateModel;

  factory TemplateModel.fromJson(Map<String, dynamic> json) => _$TemplateModelFromJson(json);
}

extension TemplateModelJson on TemplateModel {
  /// Firestore-safe JSON (deep serialization for blueprint lists).
  Map<String, dynamic> toDeepJson() {
    final data = toJson();
    data['taskBlueprints'] = taskBlueprints.map((e) => e.toJson()).toList();
    data['timelineBlueprints'] = timelineBlueprints.map((e) => e.toJson()).toList();
    data['vendorBlueprints'] = vendorBlueprints.map((e) => e.toJson()).toList();
    data['inventoryBlueprints'] = inventoryBlueprints.map((e) => e.toJson()).toList();
    data['roleBlueprints'] = roleBlueprints.map((e) => e.toJson()).toList();
    data['venueBlueprints'] = venueBlueprints.map((e) => e.toJson()).toList();
    data['ticketBlueprints'] = ticketBlueprints.map((e) => e.toJson()).toList();
    data['customFieldBlueprints'] = customFieldBlueprints.map((e) => e.toJson()).toList();
    data['announcementBlueprints'] = announcementBlueprints.map((e) => e.toJson()).toList();
    data['budgetBlueprints'] = budgetBlueprints.map((e) => e.toJson()).toList();
    return data;
  }
}
