import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/vendor_inventory_provider.dart';
import '../../providers/event_provider.dart';
import '../../data/models/inventory_model.dart';
import '../../data/models/event_model.dart';
import '../../data/services/event_template_service.dart';
import 'package:uuid/uuid.dart';

class InventoryScreen extends ConsumerWidget {
  final String eventId;
  const InventoryScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryAsync = ref.watch(inventoryStreamProvider);
    final eventAsync = ref.watch(currentEventProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Procurement & Supplies'),
      ),
      body: inventoryAsync.when(
        data: (items) {
          if (items.isEmpty) return _buildNoInventory(context, ref, eventAsync.value);

          // Group by category
          final Map<String, List<InventoryItemModel>> grouped = {};
          for (var item in items) {
            grouped.putIfAbsent(item.category, () => []).add(item);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: grouped.keys.length,
            itemBuilder: (context, index) {
              final cat = grouped.keys.elementAt(index);
              final catItems = grouped[cat]!;
              return _buildCategorySection(context, cat, catItems, ref);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddItemDialog(context, ref),
        label: const Text('Add Item'),
        icon: const Icon(Icons.add_shopping_cart_outlined),
      ),
    );
  }

  Widget _buildNoInventory(BuildContext context, WidgetRef ref, EventModel? event) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey.withAlpha(128)),
          const SizedBox(height: 16),
          const Text('No items listed for procurement'),
          const SizedBox(height: 24),
          if (event != null) 
            ElevatedButton.icon(
              onPressed: () => _loadSuggestedInventory(ref, event),
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Load Suggested Items'),
            ),
        ],
      ),
    );
  }

  void _loadSuggestedInventory(WidgetRef ref, EventModel event) async {
    final suggestions = EventTemplateService.getSuggestedInventory(event.id, event.category);
    final repo = ref.read(inventoryRepositoryProvider);
    for (var item in suggestions) {
      await repo.addInventoryItem(item);
    }
  }

  Widget _buildCategorySection(BuildContext context, String category, List<InventoryItemModel> items, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Text(category, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
        ),
        ...items.map((item) => _buildItemTile(context, item, ref)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildItemTile(BuildContext context, InventoryItemModel item, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(item.name),
        subtitle: Text('Qty: ${item.quantity} ${item.unit} • Role: ${item.responsibleRole ?? "Unassigned"}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('₹${item.estimatedCost ?? 0}', style: const TextStyle(fontWeight: FontWeight.bold)),
            _buildStatusChip(item.status),
          ],
        ),
        onTap: () {
          // Toggle status
          final nextStatus = _getNextStatus(item.status);
          ref.read(inventoryRepositoryProvider).updateInventoryItem(item.copyWith(status: nextStatus));
        },
      ),
    );
  }

  InventoryStatus _getNextStatus(InventoryStatus status) {
    switch (status) {
      case InventoryStatus.needed: return InventoryStatus.procured;
      case InventoryStatus.procured: return InventoryStatus.consumed;
      case InventoryStatus.consumed: return InventoryStatus.needed;
    }
  }

  Widget _buildStatusChip(InventoryStatus status) {
    Color color;
    switch (status) {
      case InventoryStatus.procured: color = Colors.green; break;
      case InventoryStatus.consumed: color = Colors.grey; break;
      default: color = Colors.orange;
    }
    return Text(status.name.toUpperCase(), 
      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold));
  }

  void _showAddItemDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final qtyController = TextEditingController();
    final unitController = TextEditingController();
    final catController = TextEditingController();
    final costController = TextEditingController();
    final roleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Procurement Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Item Name')),
              Row(
                children: [
                  Expanded(child: TextField(controller: qtyController, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: TextField(controller: unitController, decoration: const InputDecoration(labelText: 'Unit (e.g. kg, pcs)'))),
                ],
              ),
              TextField(controller: catController, decoration: const InputDecoration(labelText: 'Category (e.g. Food, Decor)')),
              TextField(controller: costController, decoration: const InputDecoration(labelText: 'Estimated Cost'), keyboardType: TextInputType.number),
              TextField(controller: roleController, decoration: const InputDecoration(labelText: 'Responsible Role')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final newItem = InventoryItemModel(
                id: const Uuid().v4(),
                eventId: eventId,
                name: nameController.text,
                quantity: double.tryParse(qtyController.text) ?? 1.0,
                unit: unitController.text,
                category: catController.text,
                estimatedCost: double.tryParse(costController.text),
                responsibleRole: roleController.text.isEmpty ? null : roleController.text,
              );
              await ref.read(inventoryRepositoryProvider).addInventoryItem(newItem);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
