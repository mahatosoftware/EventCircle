import 'package:freezed_annotation/freezed_annotation.dart';

part 'timeline_model.freezed.dart';
part 'timeline_model.g.dart';

enum TimelinePhase { preEvent, eventDay, postEvent }

@freezed
class TimelineItemModel with _$TimelineItemModel {
  const factory TimelineItemModel({
    required String id,
    required String eventId,
    required String title,
    required TimelinePhase phase,
    required String timeOrOffset, // e.g., "9:00 AM" or "T-7 days"
    String? description,
    DateTime? startTime, // For actual ordering of event-day items if needed
  }) = _TimelineItemModel;

  factory TimelineItemModel.fromJson(Map<String, dynamic> json) => _$TimelineItemModelFromJson(json);
}
