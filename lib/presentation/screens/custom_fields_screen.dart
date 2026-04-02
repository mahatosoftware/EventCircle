import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/custom_announcement_provider.dart';
import '../../providers/event_provider.dart';
import '../../data/models/custom_announcement_model.dart';
import '../../data/models/event_model.dart';
import '../../data/services/event_template_service.dart';
import 'package:uuid/uuid.dart';

class CustomFieldsScreen extends ConsumerWidget {
  final String eventId;
  const CustomFieldsScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fieldsAsync = ref.watch(customFieldsStreamProvider);
    final eventAsync = ref.watch(currentEventProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Member Data'),
      ),
      body: fieldsAsync.when(
        data: (fields) => fields.isEmpty
            ? _buildNoFields(context, ref, eventAsync.value)
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: fields.length,
                itemBuilder: (context, index) {
                  final field = fields[index];
                  return _buildFieldCard(context, field, ref);
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddFieldDialog(context, ref),
        label: const Text('Add Custom Field'),
        icon: const Icon(Icons.add_task_outlined),
      ),
    );
  }

  Widget _buildNoFields(BuildContext context, WidgetRef ref, EventModel? event) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.dynamic_form_outlined, size: 80, color: Colors.grey.withAlpha(128)),
          const SizedBox(height: 16),
          const Text('No custom fields defined for this event'),
          const SizedBox(height: 24),
          if (event != null) 
            ElevatedButton.icon(
              onPressed: () => _loadSuggestedFields(ref, event),
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Load Suggested Fields'),
            ),
        ],
      ),
    );
  }

  void _loadSuggestedFields(WidgetRef ref, EventModel event) async {
    final suggestions = EventTemplateService.getSuggestedCustomFields(event.id, event.category);
    final repo = ref.read(customAnnouncementRepositoryProvider);
    for (var f in suggestions) {
      await repo.addCustomField(f);
    }
  }

  Widget _buildFieldCard(BuildContext context, CustomFieldDefinitionModel field, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(_getFieldIcon(field.type), color: Theme.of(context).primaryColor),
        title: Text(field.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Type: ${field.type.name.toUpperCase()} • ${field.isRequired ? "Required" : "Optional"}'),
        trailing: field.type == CustomFieldType.dropdown 
          ? Text('${field.options?.length ?? 0} options', style: const TextStyle(fontSize: 10))
          : null,
      ),
    );
  }

  IconData _getFieldIcon(CustomFieldType type) {
    switch (type) {
      case CustomFieldType.text: return Icons.text_fields_outlined;
      case CustomFieldType.number: return Icons.numbers_outlined;
      case CustomFieldType.dropdown: return Icons.arrow_drop_down_circle_outlined;
    }
  }

  void _showAddFieldDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    CustomFieldType selectedType = CustomFieldType.text;
    bool isRequired = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Custom Member Field'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Field Name (e.g. Allergies)')),
              const SizedBox(height: 12),
              DropdownButtonFormField<CustomFieldType>(
                value: selectedType,
                items: CustomFieldType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.name.toUpperCase()))).toList(),
                onChanged: (val) => setDialogState(() => selectedType = val!),
                decoration: const InputDecoration(labelText: 'Data Type'),
              ),
              SwitchListTile(
                title: const Text('Mandatory Field', style: TextStyle(fontSize: 13)),
                value: isRequired,
                onChanged: (val) => setDialogState(() => isRequired = val),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final newField = CustomFieldDefinitionModel(
                  id: const Uuid().v4(),
                  eventId: eventId,
                  name: nameController.text,
                  type: selectedType,
                  isRequired: isRequired,
                );
                await ref.read(customAnnouncementRepositoryProvider).addCustomField(newField);
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
