import '../models/event_model.dart';

abstract class EventRepository {
  Stream<List<EventModel>> getEvents();
  Stream<List<EventModel>> getEventsForUser(String userId);
  Future<EventModel> getEventById(String id);
  Future<void> createEvent(EventModel event);
  Future<void> updateEvent(EventModel event);
  Future<void> deleteEvent(String id);
}
