import '../models/event_user_model.dart';

abstract class EventUserRepository {
  Stream<List<EventUserModel>> getEventUsers(String eventId);
  Future<void> addUserToEvent(EventUserModel user);
  Future<void> updateEventUser(EventUserModel user);
  Future<void> removeUserFromEvent(String eventId, String userId);
}

