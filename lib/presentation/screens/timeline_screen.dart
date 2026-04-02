import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/timeline_provider.dart';
import '../../providers/event_provider.dart';
import '../../data/models/timeline_model.dart';
import '../../data/models/event_model.dart';
import '../../data/services/event_template_service.dart';
import 'package:uuid/uuid.dart';

class TimelineScreen extends ConsumerWidget {
  final String eventId;
  const TimelineScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timelineAsync = ref.watch(timelineStreamProvider);
    final eventAsync = ref.watch(currentEventProvider);

    return DefaultTabController(
      length: 3,
      initialIndex: 1, // Start on Event Day
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Event Timeline'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pre-event'),
              Tab(text: 'Event Day'),
              Tab(text: 'Post-event'),
            ],
          ),
        ),
        body: timelineAsync.when(
          data: (items) => TabBarView(
            children: [
              _buildPhaseTimeline(context, items, TimelinePhase.preEvent, ref),
              _buildPhaseTimeline(context, items, TimelinePhase.eventDay, ref),
              _buildPhaseTimeline(context, items, TimelinePhase.postEvent, ref),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddTimelineDialog(context, ref),
          child: const Icon(Icons.add_task_outlined),
        ),
      ),
    );
  }

  Widget _buildPhaseTimeline(BuildContext context, List<TimelineItemModel> items, TimelinePhase phase, WidgetRef ref) {
    final phaseItems = items.where((i) => i.phase == phase).toList();
    
    if (phaseItems.isEmpty) {
      return _buildEmptyState(context, phase, ref);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: phaseItems.length,
      itemBuilder: (context, index) {
        final item = phaseItems[index];
        final isLast = index == phaseItems.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: Theme.of(context).primaryColor.withAlpha(50),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.timeOrOffset, 
                            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 16, color: Colors.grey),
                            onPressed: () => ref.read(timelineRepositoryProvider).deleteTimelineItem(eventId, item.id),
                          ),
                        ],
                      ),
                      Text(item.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      if (item.description != null) ...[
                        const SizedBox(height: 4),
                        Text(item.description!, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, TimelinePhase phase, WidgetRef ref) {
    final event = ref.read(currentEventProvider).value;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timeline_outlined, size: 64, color: Colors.grey.withAlpha(100)),
          const SizedBox(height: 16),
          Text('No ${phase.name} items scheduled'),
          const SizedBox(height: 24),
          if (event != null) 
            ElevatedButton.icon(
              onPressed: () => _loadSuggestedTimeline(ref, event),
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Load Suggested Timeline'),
            ),
        ],
      ),
    );
  }

  void _loadSuggestedTimeline(WidgetRef ref, EventModel event) async {
    final suggestions = EventTemplateService.getSuggestedTimeline(event.id, event.category);
    final repo = ref.read(timelineRepositoryProvider);
    for (var item in suggestions) {
      await repo.addTimelineItem(item);
    }
  }

  void _showAddTimelineDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final timeController = TextEditingController();
    final descController = TextEditingController();
    TimelinePhase selectedPhase = TimelinePhase.eventDay;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Add Schedule Item', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              DropdownButtonFormField<TimelinePhase>(
                value: selectedPhase,
                items: TimelinePhase.values.map((p) => DropdownMenuItem(value: p, child: Text(p.name.toUpperCase()))).toList(),
                onChanged: (val) => setDialogState(() => selectedPhase = val!),
                decoration: const InputDecoration(labelText: 'Phase'),
              ),
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
              TextField(controller: timeController, decoration: const InputDecoration(labelText: 'Time / Offset (e.g. 10:00 AM)')),
              TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description (Optional)')),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final newItem = TimelineItemModel(
                    id: const Uuid().v4(),
                    eventId: eventId,
                    title: titleController.text,
                    phase: selectedPhase,
                    timeOrOffset: timeController.text,
                    description: descController.text.isEmpty ? null : descController.text,
                  );
                  await ref.read(timelineRepositoryProvider).addTimelineItem(newItem);
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text('Add to Schedule'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
