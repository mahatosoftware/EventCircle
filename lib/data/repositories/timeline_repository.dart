import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/timeline_model.dart';

abstract class TimelineRepository {
  Stream<List<TimelineItemModel>> getTimeline(String eventId);
  Future<void> addTimelineItem(TimelineItemModel item);
  Future<void> updateTimelineItem(TimelineItemModel item);
  Future<void> deleteTimelineItem(String eventId, String id);
}

class FirebaseTimelineRepository implements TimelineRepository {
  final _db = FirebaseFirestore.instance;

  @override
  Stream<List<TimelineItemModel>> getTimeline(String eventId) {
    return _db
        .collection('events')
        .doc(eventId)
        .collection('timeline')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => TimelineItemModel.fromJson(doc.data())).toList());
  }

  @override
  Future<void> addTimelineItem(TimelineItemModel item) {
    return _db
        .collection('events')
        .doc(item.eventId)
        .collection('timeline')
        .doc(item.id)
        .set(item.toJson());
  }

  @override
  Future<void> updateTimelineItem(TimelineItemModel item) {
    return _db
        .collection('events')
        .doc(item.eventId)
        .collection('timeline')
        .doc(item.id)
        .update(item.toJson());
  }

  @override
  Future<void> deleteTimelineItem(String eventId, String id) {
    return _db
        .collection('events')
        .doc(eventId)
        .collection('timeline')
        .doc(id)
        .delete();
  }
}
