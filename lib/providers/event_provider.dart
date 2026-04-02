import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/event_model.dart';
import '../data/repositories/event_repository.dart';
import '../data/repositories/firebase/firebase_event_repository.dart';
import 'auth_provider.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return FirebaseEventRepository();
});

final eventByIdStreamProvider = StreamProvider.family<EventModel?, String>((ref, eventId) {
  return FirebaseFirestore.instance
      .collection('events')
      .doc(eventId)
      .snapshots()
      .map((doc) {
        if (!doc.exists) return null;
        final data = doc.data();
        if (data == null) return null;
        return EventModel.fromJson({...data, 'id': doc.id});
      });
});

final eventsStreamProvider = StreamProvider<List<EventModel>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(const []);
  return ref.watch(eventRepositoryProvider).getEventsForUser(user.id);
});

final currentEventIdProvider = StateProvider<String?>((ref) => null);

final currentEventProvider = FutureProvider<EventModel?>((ref) async {
  final eventId = ref.watch(currentEventIdProvider);
  if (eventId == null) return null;
  return await ref.watch(eventRepositoryProvider).getEventById(eventId);
});

final eventStreamProvider = StreamProvider.family<EventModel?, String>((ref, id) {
  return ref.watch(eventRepositoryProvider).getEventById(id).asStream();
});
