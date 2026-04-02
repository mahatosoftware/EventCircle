import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/vendor_inventory_provider.dart';
import '../../providers/event_provider.dart';
import '../../providers/access_control_provider.dart';
import '../../data/models/vendor_model.dart';
import '../../data/models/event_model.dart';
import '../../data/models/event_role_model.dart';
import '../../data/services/event_template_service.dart';
import 'package:uuid/uuid.dart';

class VendorsScreen extends ConsumerWidget {
  final String eventId;
  const VendorsScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vendorsAsync = ref.watch(vendorsStreamProvider);
    final eventAsync = ref.watch(currentEventProvider);
    final canEditVendors = ref.watch(
      hasModuleAccessProvider((eventId: eventId, module: EventModules.vendors, required: ModuleAccessLevel.edit)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Management'),
      ),
      body: vendorsAsync.when(
        data: (vendors) => vendors.isEmpty
            ? _buildNoVendors(context, ref, eventAsync.value, canEdit: canEditVendors)
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: vendors.length,
                itemBuilder: (context, index) {
                  final vendor = vendors[index];
                  return _buildVendorTile(context, vendor, ref, canEdit: canEditVendors);
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: !canEditVendors
            ? () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No permission to add vendors')))
            : () => _showAddVendorDialog(context, ref),
        label: const Text('Add Vendor Role'),
        icon: const Icon(Icons.add_business_outlined),
      ),
    );
  }

  Widget _buildNoVendors(BuildContext context, WidgetRef ref, EventModel? event, {required bool canEdit}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.business_outlined, size: 80, color: Colors.grey.withAlpha(128)),
          const SizedBox(height: 16),
          const Text('No vendors listed for this event'),
          const SizedBox(height: 24),
          if (event != null)
            ElevatedButton.icon(
              onPressed: canEdit ? () => _loadSuggestedVendors(ref, event) : null,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Load Suggested Vendors'),
            ),
        ],
      ),
    );
  }

  void _loadSuggestedVendors(WidgetRef ref, EventModel event) async {
    final suggestions = EventTemplateService.getSuggestedVendors(event.id, event.category);
    final repo = ref.read(vendorRepositoryProvider);
    for (var v in suggestions) {
      await repo.addVendor(v);
    }
  }

  Widget _buildVendorTile(BuildContext context, VendorModel vendor, WidgetRef ref, {required bool canEdit}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(vendor.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Role: ${vendor.role} • Status: ${vendor.status.name.toUpperCase()}'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (vendor.selectionCriteria != null) ...[
                  const Text('Selection Criteria:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blue)),
                  Text(vendor.selectionCriteria!, style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 8),
                ],
                if (vendor.suggestions != null) ...[
                  const Text('Blueprint Tips:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.green)),
                  Text(vendor.suggestions!, style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 12),
                ],
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: VendorStatus.values.map((status) {
                    return ChoiceChip(
                      label: Text(status.name, style: const TextStyle(fontSize: 10)),
                      selected: vendor.status == status,
                      onSelected: !canEdit
                          ? null
                          : (val) {
                              if (val) ref.read(vendorRepositoryProvider).updateVendor(vendor.copyWith(status: status));
                            },
                    );
                  }).toList(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showAddVendorDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final roleController = TextEditingController();
    final criteriaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Vendor Role'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title (e.g. Caterer)')),
            TextField(controller: roleController, decoration: const InputDecoration(labelText: 'Functional Role')),
            TextField(controller: criteriaController, decoration: const InputDecoration(labelText: 'Selection Criteria')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final newVendor = VendorModel(
                id: const Uuid().v4(),
                eventId: eventId,
                title: titleController.text,
                role: roleController.text,
                selectionCriteria: criteriaController.text,
              );
              await ref.read(vendorRepositoryProvider).addVendor(newVendor);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
