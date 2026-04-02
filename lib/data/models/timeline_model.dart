enum TimelinePhase { preEvent, eventDay, postEvent }

class TimelineItemModel {
  final String id;
  final String eventId;
  final String title;
  final TimelinePhase phase;
  final String timeOrOffset;
  final int dayNumber;
  final String? description;
  final DateTime? startTime;

  const TimelineItemModel({
    required this.id,
    required this.eventId,
    required this.title,
    this.phase = TimelinePhase.eventDay,
    required this.timeOrOffset,
    this.dayNumber = 1,
    this.description,
    this.startTime,
  });

  factory TimelineItemModel.fromJson(Map<String, dynamic> json) {
    return TimelineItemModel(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      title: json['title'] as String,
      phase: TimelinePhase.values.firstWhere((e) => e.name == json['phase'], orElse: () => TimelinePhase.eventDay),
      timeOrOffset: json['timeOrOffset'] as String,
      dayNumber: json['dayNumber'] as int? ?? 1,
      description: json['description'] as String?,
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'title': title,
      'phase': phase.name,
      'timeOrOffset': timeOrOffset,
      'dayNumber': dayNumber,
      'description': description,
      'startTime': startTime?.toIso8601String(),
    };
  }

  TimelineItemModel copyWith({
    String? id,
    String? eventId,
    String? title,
    TimelinePhase? phase,
    String? timeOrOffset,
    int? dayNumber,
    String? description,
    DateTime? startTime,
  }) {
    return TimelineItemModel(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      title: title ?? this.title,
      phase: phase ?? this.phase,
      timeOrOffset: timeOrOffset ?? this.timeOrOffset,
      dayNumber: dayNumber ?? this.dayNumber,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
    );
  }
}
