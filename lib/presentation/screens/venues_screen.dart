import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/venue_ticketing_provider.dart';
import '../../providers/event_provider.dart';
import '../../data/models/venue_ticketing_model.dart';
import '../../data/models/event_model.dart';
import '../../data/services/event_template_service.dart';
import 'package:uuid/uuid.dart';

class VenuesScreen extends ConsumerWidget {
  final String eventId;
  const VenuesScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final venuesAsync = ref.watch(venuesStreamProvider);
    final eventAsync = ref.watch(currentEventProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Locations'),
      ),
      body: venuesAsync.when(
        data: (venues) => venues.isEmpty
            ? _buildNoVenues(context, ref, eventAsync.value)
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: venues.length,
                itemBuilder: (context, index) {
                  final venue = venues[index];
                  return _buildVenueCard(context, venue, ref);
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddVenueDialog(context, ref),
        label: const Text('Add Location'),
        icon: const Icon(Icons.add_location_alt_outlined),
      ),
    );
  }

  Widget _buildNoVenues(BuildContext context, WidgetRef ref, EventModel? event) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map_outlined, size: 80, color: Colors.grey.withAlpha(128)),
          const SizedBox(height: 16),
          const Text('No venues defined for this event'),
        ],
      ),
    );
  }

  Widget _buildVenueCard(BuildContext context, LocationModel venue, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: venue.isMainVenue ? BorderSide(color: Theme.of(context).primaryColor, width: 2) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(venue.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                if (venue.isMainVenue)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(8)),
                    child: const Text('MAIN VENUE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(child: Text(venue.address, style: const TextStyle(color: Colors.grey))),
              ],
            ),
            if (venue.parkingInfo != null) ...[
              const SizedBox(height: 12),
              const Text('Parking Info:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(venue.parkingInfo!, style: const TextStyle(fontSize: 13)),
            ],
            if (venue.instructions != null) ...[
              const SizedBox(height: 12),
              const Text('Instructions:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blue)),
              Text(venue.instructions!, style: const TextStyle(fontSize: 13)),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (venue.mapLink != null)
                   TextButton.icon(onPressed: () {}, icon: const Icon(Icons.map_outlined, size: 18), label: const Text('Open Map')),
                TextButton.icon(
                  onPressed: () => _showEditVenueDialog(context, ref, venue),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Edit'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showAddVenueDialog(BuildContext context, WidgetRef ref) {
    _showVenueForm(context, ref);
  }

  void _showEditVenueDialog(BuildContext context, WidgetRef ref, LocationModel venue) {
    _showVenueForm(context, ref, existing: venue);
  }

  void _showVenueForm(BuildContext context, WidgetRef ref, {LocationModel? existing}) {
    final nameController = TextEditingController(text: existing?.name);
    final addrController = TextEditingController(text: existing?.address);
    final parkController = TextEditingController(text: existing?.parkingInfo);
    final instController = TextEditingController(text: existing?.instructions);
    bool isMain = existing?.isMainVenue ?? false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(existing == null ? 'Add Location' : 'Edit Location'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Venue Name', prefixIcon: Icon(Icons.business_outlined)),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: addrController,
                  decoration: InputDecoration(labelText: 'Address', prefixIcon: Icon(Icons.location_on_outlined)),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: parkController,
                  decoration: InputDecoration(labelText: 'Parking Information', prefixIcon: Icon(Icons.local_parking_outlined)),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: instController,
                  decoration: InputDecoration(labelText: 'Additional Instructions', prefixIcon: Icon(Icons.notes_outlined)),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Main Venue', style: TextStyle(fontSize: 14)),
                  subtitle: const Text('Primary location for the event', style: TextStyle(fontSize: 12)),
                  value: isMain,
                  onChanged: (v) => setDialogState(() => isMain = v),
                ),
              ],
            ),
          ),
          actions: [
            if (existing != null)
              TextButton.icon(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Location?'),
                      content: const Text('Are you sure you want to remove this venue? This action cannot be undone.'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await ref.read(venueTicketingRepositoryProvider).deleteVenue(eventId, existing.id);
                    if (context.mounted) Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('Delete'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final model = LocationModel(
                  id: existing?.id ?? const Uuid().v4(),
                  eventId: eventId,
                  name: nameController.text,
                  address: addrController.text,
                  parkingInfo: parkController.text,
                  instructions: instController.text,
                  isMainVenue: isMain,
                );

                if (existing == null) {
                  await ref.read(venueTicketingRepositoryProvider).addVenue(model);
                } else {
                  await ref.read(venueTicketingRepositoryProvider).updateVenue(model);
                }
                if (context.mounted) Navigator.pop(context);
              },
              child: Text(existing == null ? 'Add Venue' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
