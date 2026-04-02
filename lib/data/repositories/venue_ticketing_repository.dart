import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/venue_ticketing_model.dart';
import '../models/payment_model.dart';
import 'package:uuid/uuid.dart';

abstract class VenueTicketingRepository {
  Stream<List<LocationModel>> getVenues(String eventId);
  Future<void> addVenue(LocationModel venue);
  Future<void> updateVenue(LocationModel venue);
  
  Stream<List<TicketModel>> getTickets(String eventId);
  Future<void> addTicket(TicketModel ticket);
  Future<void> updateTicket(TicketModel ticket);

  // New features for issuance and validation
  Stream<List<IssuedTicketModel>> getIssuedTickets(String eventId);
  Future<void> issueTicket(IssuedTicketModel ticket, double price);
  Future<void> checkInTicket(String eventId, String ticketId);
  
  Stream<TicketDesignModel?> getTicketDesign(String eventId);
  Future<void> updateTicketDesign(TicketDesignModel design);
}

class FirebaseVenueTicketingRepository implements VenueTicketingRepository {
  final _db = FirebaseFirestore.instance;

  @override
  Stream<List<LocationModel>> getVenues(String eventId) {
    return _db.collection('events').doc(eventId).collection('venues')
        .snapshots().map((s) => s.docs.map((d) => LocationModel.fromJson(d.data())).toList());
  }

  @override
  Future<void> addVenue(LocationModel venue) =>
      _db.collection('events').doc(venue.eventId).collection('venues').doc(venue.id).set(venue.toJson());

  @override
  Future<void> updateVenue(LocationModel venue) =>
      _db.collection('events').doc(venue.eventId).collection('venues').doc(venue.id).update(venue.toJson());

  @override
  Stream<List<TicketModel>> getTickets(String eventId) {
    return _db.collection('events').doc(eventId).collection('tickets')
        .snapshots().map((s) => s.docs.map((d) => TicketModel.fromJson(d.data())).toList());
  }

  @override
  Future<void> addTicket(TicketModel ticket) =>
      _db.collection('events').doc(ticket.eventId).collection('tickets').doc(ticket.id).set(ticket.toJson());

  @override
  Future<void> updateTicket(TicketModel ticket) =>
      _db.collection('events').doc(ticket.eventId).collection('tickets').doc(ticket.id).update(ticket.toJson());

  @override
  Stream<List<IssuedTicketModel>> getIssuedTickets(String eventId) {
    return _db.collection('events').doc(eventId).collection('issuedTickets')
        .orderBy('issuedAt', descending: true)
        .snapshots().map((s) => s.docs.map((d) => IssuedTicketModel.fromJson(d.data())).toList());
  }

  @override
  Future<void> issueTicket(IssuedTicketModel ticket, double price) async {
    final batch = _db.batch();
    
    // 1. Save the issued ticket
    final issuedRef = _db.collection('events').doc(ticket.eventId).collection('issuedTickets').doc(ticket.id);
    batch.set(issuedRef, ticket.toJson());
    
    // 2. Increment the sold count on the master ticket type
    final ticketTypeRef = _db.collection('events').doc(ticket.eventId).collection('tickets').doc(ticket.ticketTypeId);
    batch.update(ticketTypeRef, {'soldCount': FieldValue.increment(1)});

    // 3. Double-entry: Record as a payment in the ledger
    final paymentId = const Uuid().v4();
    final paymentRef = _db.collection('payments').doc(paymentId);
    final payment = PaymentModel(
      id: paymentId,
      memberId: 'Manual-Issue', // Or attendee identifier
      eventId: ticket.eventId,
      status: PaymentStatus.success,
      amount: price,
      timestamp: DateTime.now(),
      contributionType: 'Ticketing',
      targetId: ticket.ticketTypeId,
      metadata: {
        'ticketId': ticket.id,
        'attendeeName': ticket.attendeeName,
        'attendeeEmail': ticket.attendeeEmail,
      },
    );
    batch.set(paymentRef, payment.toJson());
    
    await batch.commit();
  }

  @override
  Future<void> checkInTicket(String eventId, String ticketId) {
    return _db.collection('events').doc(eventId).collection('issuedTickets').doc(ticketId).update({
      'status': TicketStatus.used.name,
      'checkInTime': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<TicketDesignModel?> getTicketDesign(String eventId) {
    return _db.collection('events').doc(eventId).collection('config').doc('ticketDesign')
        .snapshots().map((doc) => doc.exists ? TicketDesignModel.fromJson(doc.data()!) : null);
  }

  @override
  Future<void> updateTicketDesign(TicketDesignModel design) {
    return _db.collection('events').doc(design.eventId).collection('config').doc('ticketDesign').set(design.toJson());
  }
}
