import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/custom_announcement_model.dart';
import '../data/repositories/custom_announcement_repository.dart';
import 'event_provider.dart';

final customAnnouncementRepositoryProvider = Provider((ref) => FirebaseCustomAnnouncementRepository());

final customFieldsStreamProvider = StreamProvider<List<CustomFieldDefinitionModel>>((ref) {
  final eventId = ref.watch(currentEventIdProvider);
  if (eventId == null) return Stream.value([]);
  return ref.watch(customAnnouncementRepositoryProvider).getCustomFields(eventId);
});

final announcementsStreamProvider = StreamProvider<List<AnnouncementModel>>((ref) {
  final eventId = ref.watch(currentEventIdProvider);
  if (eventId == null) return Stream.value([]);
  return ref.watch(customAnnouncementRepositoryProvider).getAnnouncements(eventId);
});
