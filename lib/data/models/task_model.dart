import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

enum TaskStatus { pending, done }

enum TaskPhase { preEvent, eventDay, postEvent }

extension TaskPhaseExtension on TaskPhase {
  String get displayName {
    switch (this) {
      case TaskPhase.preEvent: return 'Pre-event';
      case TaskPhase.eventDay: return 'Event Day';
      case TaskPhase.postEvent: return 'Post-event';
    }
  }
}

@freezed
class TaskModel with _$TaskModel {
  const factory TaskModel({
    required String id,
    required String eventId,
    required String title,
    required TaskStatus status,
    @Default(TaskPhase.preEvent) TaskPhase phase,
    String? description,
    String? dueOffset, // e.g. T-7
    String? role, // Responsible role
    @Default([]) List<String> dependsOn, // List of task IDs
    String? assignedMemberId,
    String? assignedMemberName,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) => _$TaskModelFromJson(json);
}
