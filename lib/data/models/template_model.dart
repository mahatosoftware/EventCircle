import 'package:freezed_annotation/freezed_annotation.dart';
import 'event_model.dart';
import 'task_model.dart';
import 'timeline_model.dart';
import 'vendor_model.dart';
import 'inventory_model.dart';
import 'role_definition_model.dart';
import 'venue_ticketing_model.dart';
import 'budget_model.dart';
import 'package:json_annotation/json_annotation.dart';

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
  roles('ROLES & PERMISSIONS'),
  expenses('EXPENSE TRACKING'),
  location('LOCATION '),
  ticketing('TICKETING'),
  invitation('INVITATION & RSVP');

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
    @Default([]) List<BudgetItemModel> budgetBlueprints,
    @JsonKey(fromJson: _enabledModulesFromJson) @Default([]) List<TemplateModule> enabledModules,
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
    
    // Safety wrap for all lists that require nested toJson
    try {
      data['taskBlueprints'] = taskBlueprints.map((e) {
        try { return e.toJson(); } catch (_) { return null; }
      }).whereType<Map<String, dynamic>>().toList();
    } catch (_) { data['taskBlueprints'] = []; }

    try {
      data['timelineBlueprints'] = timelineBlueprints.map((e) {
        try { return e.toJson(); } catch (_) { return null; }
      }).whereType<Map<String, dynamic>>().toList();
    } catch (_) { data['timelineBlueprints'] = []; }

    try {
      data['vendorBlueprints'] = vendorBlueprints.map((e) {
        try { return e.toJson(); } catch (_) { return null; }
      }).whereType<Map<String, dynamic>>().toList();
    } catch (_) { data['vendorBlueprints'] = []; }

    try {
      data['inventoryBlueprints'] = inventoryBlueprints.map((e) {
        try { return e.toJson(); } catch (_) { return null; }
      }).whereType<Map<String, dynamic>>().toList();
    } catch (_) { data['inventoryBlueprints'] = []; }

    try {
      data['roleBlueprints'] = roleBlueprints.map((e) {
        try { return e.toJson(); } catch (_) { return null; }
      }).whereType<Map<String, dynamic>>().toList();
    } catch (_) { data['roleBlueprints'] = []; }

    try {
      data['venueBlueprints'] = venueBlueprints.map((e) {
        try { return e.toJson(); } catch (_) { return null; }
      }).whereType<Map<String, dynamic>>().toList();
    } catch (_) { data['venueBlueprints'] = []; }

    try {
      data['ticketBlueprints'] = ticketBlueprints.map((e) {
        try { return e.toJson(); } catch (_) { return null; }
      }).whereType<Map<String, dynamic>>().toList();
    } catch (_) { data['ticketBlueprints'] = []; }

    try {
      data['budgetBlueprints'] = budgetBlueprints.map((e) {
        try { return e.toJson(); } catch (_) { return null; }
      }).whereType<Map<String, dynamic>>().toList();
    } catch (_) { data['budgetBlueprints'] = []; }

    return data;
  }
}
List<TemplateModule> _enabledModulesFromJson(dynamic json) {
  if (json is! List) return [];
  return json
      .map((e) {
        if (e is! String) return null;
        for (final entry in _$TemplateModuleEnumMap.entries) {
          if (entry.value == e) return entry.key;
        }
        return null;
      })
      .whereType<TemplateModule>()
      .toList();
}
