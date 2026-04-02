import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/custom_announcement_model.dart';

abstract class CustomAnnouncementRepository {
  Stream<List<CustomFieldDefinitionModel>> getCustomFields(String eventId);
  Future<void> addCustomField(CustomFieldDefinitionModel field);
  Future<void> updateCustomField(CustomFieldDefinitionModel field);
  
  Stream<List<AnnouncementModel>> getAnnouncements(String eventId);
  Future<void> addAnnouncement(AnnouncementModel announcement);
}

class FirebaseCustomAnnouncementRepository implements CustomAnnouncementRepository {
  final _db = FirebaseFirestore.instance;

  @override
  Stream<List<CustomFieldDefinitionModel>> getCustomFields(String eventId) {
    return _db.collection('events').doc(eventId).collection('customFields')
        .snapshots().map((s) => s.docs.map((d) => CustomFieldDefinitionModel.fromJson(d.data())).toList());
  }

  @override
  Future<void> addCustomField(CustomFieldDefinitionModel field) =>
      _db.collection('events').doc(field.eventId).collection('customFields').doc(field.id).set(field.toJson());

  @override
  Future<void> updateCustomField(CustomFieldDefinitionModel field) =>
      _db.collection('events').doc(field.eventId).collection('customFields').doc(field.id).update(field.toJson());

  @override
  Stream<List<AnnouncementModel>> getAnnouncements(String eventId) {
    return _db.collection('events').doc(eventId).collection('announcements')
        .orderBy('createdAt', descending: true)
        .snapshots().map((s) => s.docs.map((d) => AnnouncementModel.fromJson(d.data())).toList());
  }

  @override
  Future<void> addAnnouncement(AnnouncementModel announcement) =>
      _db.collection('events').doc(announcement.eventId).collection('announcements').doc(announcement.id).set(announcement.toJson());
}
