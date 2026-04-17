import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/event_model.dart';
import '../event_repository.dart';

class FirebaseEventRepository implements EventRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'events';

  EventModel _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Event document has no data: ${doc.id}');
    }
    return EventModel.fromJson({...data, 'id': doc.id});
  }

  @override
  Stream<List<EventModel>> getEvents() {
    return _firestore
        .collection(_collection)
        .orderBy('startDate', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map(_fromDoc).toList();
    });
  }

  @override
  Stream<List<EventModel>> getEventsForUser(String userId) {
    final controller = StreamController<List<EventModel>>();

    Map<String, EventModel> organizerEvents = {};
    final participantEvents = <String, EventModel>{};

    final participantDocSubs = <String, StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>>{};

    void emit() {
      final merged = <String, EventModel>{...participantEvents, ...organizerEvents};
      final list = merged.values.toList()
        ..sort((a, b) => (a.startDate ?? a.createdAt).compareTo(b.startDate ?? b.createdAt));
      if (!controller.isClosed) controller.add(list);
    }

    StreamSubscription? organizerSub;
    StreamSubscription? participantIdsSub;

    organizerSub = _firestore
        .collection(_collection)
        .where('organizerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
      (snap) {
        organizerEvents = {for (final d in snap.docs) d.id: _fromDoc(d)};
        emit();
      },
      onError: controller.addError,
    );

    participantIdsSub = _firestore
        .collectionGroup('users')
        .where('id', isEqualTo: userId)
        .where('status', isEqualTo: 'active')
        .snapshots()
        .listen(
      (snap) {
        final ids = <String>{};
        for (final d in snap.docs) {
          final data = d.data();
          final eventId = data['eventId']?.toString();
          if (eventId != null && eventId.isNotEmpty) ids.add(eventId);
        }

        // Stop listening to removed events.
        final toRemove = participantDocSubs.keys.where((k) => !ids.contains(k)).toList();
        for (final id in toRemove) {
          participantDocSubs.remove(id)?.cancel();
          participantEvents.remove(id);
        }

        // Start listening to newly added events.
        final toAdd = ids.where((id) => !participantDocSubs.containsKey(id)).toList();
        for (final id in toAdd) {
          participantDocSubs[id] = _firestore.collection(_collection).doc(id).snapshots().listen(
            (doc) {
              if (!doc.exists) {
                participantEvents.remove(id);
              } else {
                participantEvents[id] = _fromDoc(doc);
              }
              emit();
            },
            onError: controller.addError,
          );
        }

        emit();
      },
      onError: (e, st) {
        // Some Firestore security rules may not allow collectionGroup access.
        // Fall back gracefully to organizer-only events.
        emit();
      },
    );

    controller.onCancel = () async {
      await organizerSub?.cancel();
      await participantIdsSub?.cancel();
      for (final sub in participantDocSubs.values) {
        await sub.cancel();
      }
    };

    return controller.stream;
  }

  @override
  Future<EventModel> getEventById(String id) async {
    final doc = await _firestore.collection(_collection).doc(id).get();
    if (doc.exists) {
      return _fromDoc(doc);
    }
    throw Exception('Event not found');
  }

  @override
  Future<void> createEvent(EventModel event) async {
    await _firestore.collection(_collection).doc(event.id).set(event.toJson());
  }

  @override
  Future<void> updateEvent(EventModel event) async {
    await _firestore.collection(_collection).doc(event.id).update(event.toJson());
  }

  @override
  Future<void> deleteEvent(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}
