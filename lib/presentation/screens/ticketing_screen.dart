import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/venue_ticketing_provider.dart';
import '../../providers/event_provider.dart';
import '../../data/models/venue_ticketing_model.dart';
import '../../data/models/event_model.dart';
import 'package:uuid/uuid.dart';

import 'dart:io';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/utils/ticket_service.dart';

class TicketingScreen extends ConsumerStatefulWidget {
  final String eventId;
  const TicketingScreen({super.key, required this.eventId});

  @override
  ConsumerState<TicketingScreen> createState() => _TicketingScreenState();
}

class _TicketingScreenState extends ConsumerState<TicketingScreen> {
  @override
  Widget build(BuildContext context) {
    final ticketsAsync = ref.watch(ticketsStreamProvider);
    final issuedTicketsAsync = ref.watch(issuedTicketsStreamProvider);
    final eventAsync = ref.watch(currentEventProvider);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ticket Management'),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: 'Categories', icon: Icon(Icons.category_outlined)),
              Tab(text: 'Attendees', icon: Icon(Icons.people_outline)),
              Tab(text: 'Validator', icon: Icon(Icons.qr_code_scanner)),
              Tab(text: 'Design & Stats', icon: Icon(Icons.palette_outlined)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCategoriesTab(ticketsAsync, eventAsync.value),
            _buildAttendeesTab(issuedTicketsAsync, ticketsAsync.value ?? [], eventAsync.value),
            _buildValidatorTab(),
            _buildDesignTab(issuedTicketsAsync.value ?? [], eventAsync.value),
          ],
        ),
      ),
    );
  }

  Widget _buildDesignTab(List<IssuedTicketModel> issued, EventModel? event) {
    final designAsync = ref.watch(ticketDesignStreamProvider);
    
    return designAsync.when(
      data: (design) {
        final current = design ?? TicketDesignModel(eventId: widget.eventId);
        final msgController = TextEditingController(text: current.customMessage);
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Design Settings', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: current.theme,
                items: ['Minimal', 'Festive', 'Corporate', 'Religious'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => _updateDesign(current.copyWith(theme: v!)),
                decoration: const InputDecoration(labelText: 'Ticket Theme'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: msgController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Custom Message', hintText: 'Short note for attendee'),
                onChanged: (v) => _updateDesign(current.copyWith(customMessage: v)),
              ),
              const SizedBox(height: 32),
              Text('Data Export', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ListTile(
                tileColor: Colors.grey.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                leading: const Icon(Icons.table_view_outlined, color: Colors.green),
                title: const Text('Export Attendee List'),
                subtitle: const Text('.CSV format for Excel/Google Sheets'),
                onTap: () => _exportAttendees(issued),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error loading design: $e')),
    );
  }

  void _updateDesign(TicketDesignModel design) async {
    await ref.read(venueTicketingRepositoryProvider).updateTicketDesign(design);
  }

  void _exportAttendees(List<IssuedTicketModel> issued) async {
    if (issued.isEmpty) return;
    
    final rows = [
      ['ID', 'Name', 'Email', 'Status', 'Check-in Time'],
      ...issued.map((i) => [i.id, i.attendeeName, i.attendeeEmail, i.status.name, i.checkInTime?.toString() ?? 'Pending']),
    ];
    
    final csvResult = rows.map((e) => e.join(',')).join('\n');
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/attendees_export.csv');
    await file.writeAsString(csvResult);
    if (!mounted) return;
    await Share.shareXFiles([XFile(file.path)], text: 'Attendee list export');
  }

  Widget _buildCategoriesTab(AsyncValue<List<TicketModel>> ticketsAsync, EventModel? event) {
    return ticketsAsync.when(
      data: (tickets) => Scaffold(
        body: tickets.isEmpty 
          ? _buildNoTickets(event) 
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tickets.length,
              itemBuilder: (context, index) => _buildTicketCard(tickets[index]),
            ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddTicketTypeDialog(),
          label: const Text('New Type'),
          icon: const Icon(Icons.add),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildAttendeesTab(AsyncValue<List<IssuedTicketModel>> issuedAsync, List<TicketModel> types, EventModel? event) {
    return issuedAsync.when(
      data: (issued) => Scaffold(
        body: issued.isEmpty
          ? const Center(child: Text('No tickets issued yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: issued.length,
              itemBuilder: (context, index) {
                final item = issued[index];
                final type = types.firstWhere((t) => t.id == item.ticketTypeId, orElse: () => TicketModel(id: '', eventId: '', title: 'Unknown', price: 0, capacity: 0));
                return _buildAttendeeCard(item, type, event);
              },
            ),
        floatingActionButton: types.isEmpty ? null : FloatingActionButton.extended(
          onPressed: () => _showIssueTicketDialog(types),
          label: const Text('Issue Ticket'),
          icon: const Icon(Icons.local_activity_outlined),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildValidatorTab() {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Theme.of(context).primaryColor, width: 2),
            ),
            clipBehavior: Clip.antiAlias,
            child: MobileScanner(
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  if (barcode.rawValue != null) {
                    _validateTicket(barcode.rawValue!);
                  }
                }
              },
            ),
          ),
        ),
        const Expanded(
          flex: 1,
          child: Center(
            child: Text('Point the camera at the ticket QR code', style: TextStyle(color: Colors.grey)),
          ),
        ),
      ],
    );
  }

  void _validateTicket(String qrData) async {
    // Basic search in issued tickets
    final issued = ref.read(issuedTicketsStreamProvider).value ?? [];
    try {
      final ticket = issued.firstWhere((t) => t.qrData == qrData);
      final isAnonymous = ticket.attendeeName.toLowerCase().contains('guest') || 
                         ticket.attendeeName.toLowerCase().contains('anonymous');
      
      if (ticket.status == TicketStatus.used) {
        _showValidationResult(false, 'Ticket already used at ${ticket.checkInTime}', isAnonymous: isAnonymous);
      } else {
        await ref.read(venueTicketingRepositoryProvider).checkInTicket(widget.eventId, ticket.id);
        _showValidationResult(true, 'Checked in: ${ticket.attendeeName}\nType: ${ticket.ticketTypeId}', isAnonymous: isAnonymous);
      }
    } catch (e) {
      _showValidationResult(false, 'Invalid Ticket', isAnonymous: false);
    }
  }

  void _showValidationResult(bool success, String message, {bool isAnonymous = false}) {
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(success ? Icons.check_circle : Icons.error, color: success ? Colors.green : Colors.red, size: 64),
            const SizedBox(height: 16),
            if (isAnonymous) 
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: Colors.orange.withAlpha(50), borderRadius: BorderRadius.circular(12)),
                child: const Text('ANONYMOUS TICKET', style: TextStyle(fontSize: 10, color: Colors.orange, fontWeight: FontWeight.bold)),
              ),
            Text(success ? 'VALID ENTRY' : 'INVALID', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Next Scan')),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendeeCard(IssuedTicketModel issued, TicketModel type, EventModel? event) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(issued.attendeeName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${type.title} • ${issued.attendeeEmail}'),
        trailing: IconButton(
          icon: const Icon(Icons.download_outlined),
          onPressed: () => _generateAndShare(issued, type, event),
        ),
      ),
    );
  }

  void _generateAndShare(IssuedTicketModel issued, TicketModel type, EventModel? event) async {
    if (event == null) return;
    
    // Default design if none exists
    const design = TicketDesignModel(eventId: '');
    
    final file = await TicketService.generateTicketPdf(event, type, issued, design);
    if (!mounted) return;
    await Share.shareXFiles([XFile(file.path)], text: 'Ticket for ${event.title}');
  }

  void _showIssueTicketDialog(List<TicketModel> types) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final countController = TextEditingController(text: '1');
    TicketModel? selectedTypeItem = types.first;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Issue New Ticket'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<TicketModel>(
                  value: selectedTypeItem,
                  items: types.map((t) => DropdownMenuItem(value: t, child: Text(t.title))).toList(),
                  onChanged: (v) => setState(() => selectedTypeItem = v),
                  decoration: const InputDecoration(labelText: 'Ticket Type'),
                ),
                const SizedBox(height: 8),
                if (selectedTypeItem?.allowAnonymous ?? false)
                  const Text('This ticket type allows anonymous issuance. Details are optional.', style: TextStyle(fontSize: 10, color: Colors.orange)),
                TextField(controller: nameController, decoration: InputDecoration(labelText: 'Name ${selectedTypeItem?.allowAnonymous == true ? "(Optional)" : ""}')),
                TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email ${selectedTypeItem?.allowAnonymous == true ? "(Optional)" : ""}')),
                TextField(controller: phoneController, decoration: InputDecoration(labelText: 'Phone ${selectedTypeItem?.allowAnonymous == true ? "(Optional)" : ""}')),
                TextField(controller: countController, decoration: const InputDecoration(labelText: 'No. of tickets'), keyboardType: TextInputType.number),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final count = int.tryParse(countController.text) ?? 1;
                final isAnon = selectedTypeItem?.allowAnonymous ?? false;
                final name = nameController.text.trim();
                
                if (!isAnon && name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Attendee name is mandatory for this ticket type')),
                  );
                  return;
                }
                
                for (int i = 0; i < count; i++) {
                  final id = const Uuid().v4();
                  final issued = IssuedTicketModel(
                    id: id,
                    ticketTypeId: selectedTypeItem!.id,
                    eventId: widget.eventId,
                    attendeeName: name.isEmpty && isAnon ? 'Guest - ${id.split("-").first.toUpperCase()}' : (name.isEmpty ? 'Anonymous' : name),
                    attendeeEmail: emailController.text.isEmpty && isAnon ? 'guest@eventcircle.internal' : emailController.text,
                    attendeePhone: phoneController.text,
                    qrData: 'eventcircle://$id',
                    issuedAt: DateTime.now(),
                  );
                  await ref.read(venueTicketingRepositoryProvider).issueTicket(issued, selectedTypeItem!.price);
                }
                
                if (!context.mounted) return;
                Navigator.pop(context);
              },
              child: const Text('Issue'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoTickets(EventModel? event) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.airplane_ticket_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text('No ticket types created'),
          Text('Define categories like VIP or General first', style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTicketCard(TicketModel ticket) {
    final soldProgress = ticket.capacity > 0 ? ticket.soldCount / ticket.capacity : 0.0;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(ticket.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('₹${ticket.price}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: soldProgress, minHeight: 8, borderRadius: BorderRadius.circular(4)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${ticket.soldCount} Sold'),
                Text('${ticket.capacity} Total'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTicketTypeDialog() {
    final titleController = TextEditingController();
    final priceController = TextEditingController();
    final capController = TextEditingController();
    bool allowAnon = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('New Ticket Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
              TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
              TextField(controller: capController, decoration: const InputDecoration(labelText: 'Capacity'), keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Anonymous Entry', style: TextStyle(fontSize: 14)),
                subtitle: const Text('Allow guest booking without mandatory details', style: TextStyle(fontSize: 11)),
                value: allowAnon,
                onChanged: (v) => setState(() => allowAnon = v),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final newTicket = TicketModel(
                  id: const Uuid().v4(),
                  eventId: widget.eventId,
                  title: titleController.text,
                  price: double.tryParse(priceController.text) ?? 0.0,
                  capacity: int.tryParse(capController.text) ?? 100,
                  allowAnonymous: allowAnon,
                );
                await ref.read(venueTicketingRepositoryProvider).addTicket(newTicket);
                if (!context.mounted) return;
                Navigator.pop(context);
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
