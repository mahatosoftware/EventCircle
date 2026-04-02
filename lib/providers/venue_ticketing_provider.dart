import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/venue_ticketing_model.dart';
import '../data/repositories/venue_ticketing_repository.dart';
import 'event_provider.dart';

final venueTicketingRepositoryProvider = Provider((ref) => FirebaseVenueTicketingRepository());

final venuesStreamProvider = StreamProvider<List<LocationModel>>((ref) {
  final eventId = ref.watch(currentEventIdProvider);
  if (eventId == null) return Stream.value([]);
  return ref.watch(venueTicketingRepositoryProvider).getVenues(eventId);
});

final ticketsStreamProvider = StreamProvider<List<TicketModel>>((ref) {
  final eventId = ref.watch(currentEventIdProvider);
  if (eventId == null) return Stream.value([]);
  return ref.watch(venueTicketingRepositoryProvider).getTickets(eventId);
});

final issuedTicketsStreamProvider = StreamProvider<List<IssuedTicketModel>>((ref) {
  final eventId = ref.watch(currentEventIdProvider);
  if (eventId == null) return Stream.value([]);
  return ref.watch(venueTicketingRepositoryProvider).getIssuedTickets(eventId);
});

final ticketDesignStreamProvider = StreamProvider<TicketDesignModel?>((ref) {
  final eventId = ref.watch(currentEventIdProvider);
  if (eventId == null) return Stream.value(null);
  return ref.watch(venueTicketingRepositoryProvider).getTicketDesign(eventId);
});
