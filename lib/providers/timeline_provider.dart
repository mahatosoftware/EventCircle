import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/timeline_model.dart';
import '../data/repositories/timeline_repository.dart';
import 'event_provider.dart';

final timelineRepositoryProvider = Provider((ref) => FirebaseTimelineRepository());

final timelineStreamProvider = StreamProvider<List<TimelineItemModel>>((ref) {
  final eventId = ref.watch(currentEventIdProvider);
  if (eventId == null) return Stream.value([]);
  return ref.watch(timelineRepositoryProvider).getTimeline(eventId);
});
