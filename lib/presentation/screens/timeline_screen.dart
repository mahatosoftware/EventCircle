import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/timeline_provider.dart';
import '../../providers/event_provider.dart';
import '../../data/models/timeline_model.dart';
import '../../data/models/event_model.dart';
import '../../data/services/event_template_service.dart';
import '../../data/services/pdf_export_service.dart';
import 'pdf_preview_screen.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class TimelineScreen extends ConsumerWidget {
  final String eventId;
  const TimelineScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timelineAsync = ref.watch(timelineStreamProvider);
    final eventAsync = ref.watch(currentEventProvider);

    int totalDays = 1;
    final event = eventAsync.value;
    if (event?.startDate != null && event?.endDate != null) {
       final start = DateTime(event!.startDate!.year, event!.startDate!.month, event!.startDate!.day);
       final end = DateTime(event.endDate!.year, event.endDate!.month, event.endDate!.day);
       totalDays = end.difference(start).inDays + 1;
    }

    final tabs = [
      const Tab(text: 'Pre-event'),
      ...List.generate(totalDays, (i) => Tab(text: totalDays > 1 ? 'Day ${i + 1}' : 'Event Day')),
      const Tab(text: 'Post-event'),
    ];

    return DefaultTabController(
      length: tabs.length,
      initialIndex: 1, // Start on Day 1
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Event Timeline'),
          actions: [
            if (event != null)
              timelineAsync.maybeWhen(
                data: (items) => IconButton(
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  tooltip: 'Export PDF',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfPreviewScreen(event: event, items: items),
                    ),
                  ),
                ),
                orElse: () => const SizedBox.shrink(),
              ),
          ],
          bottom: TabBar(
            isScrollable: tabs.length > 4,
            tabs: tabs,
          ),
        ),
        body: timelineAsync.when(
          data: (items) => TabBarView(
            children: [
              _buildPhaseTimeline(context, items, TimelinePhase.preEvent, 1, ref, totalDays),
              ...List.generate(totalDays, (i) => _buildPhaseTimeline(context, items, TimelinePhase.eventDay, i + 1, ref, totalDays)),
              _buildPhaseTimeline(context, items, TimelinePhase.postEvent, 1, ref, totalDays),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddTimelineDialog(context, ref, totalDays),
          child: const Icon(Icons.add_task_outlined),
        ),
      ),
    );
  }

  Widget _buildPhaseTimeline(BuildContext context, List<TimelineItemModel> items, TimelinePhase phase, int dayNumber, WidgetRef ref, int totalDays) {
    final phaseItems = items
        .where((i) => i.phase == phase && (phase != TimelinePhase.eventDay || i.dayNumber == dayNumber))
        .toList();
    
    // Sort logic
    phaseItems.sort((a, b) {
      final aTime = a.startTime ?? _tryParseTime(a.timeOrOffset);
      final bTime = b.startTime ?? _tryParseTime(b.timeOrOffset);

      if (aTime != null && bTime != null) {
        return aTime.compareTo(bTime);
      }
      if (aTime != null) return -1;
      if (bTime != null) return 1;
      return a.title.compareTo(b.title);
    });
    
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
                          Expanded(
                            child: Text(item.timeOrOffset, 
                              style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 16, color: Colors.grey),
                                onPressed: () => _showEditTimelineDialog(context, ref, totalDays, item),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 16, color: Colors.grey),
                                onPressed: () => ref.read(timelineRepositoryProvider).deleteTimelineItem(eventId, item.id),
                              ),
                            ],
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
        ],
      ),
    );
  }


  void _showAddTimelineDialog(BuildContext context, WidgetRef ref, int totalDays) {
    _showTimelineItemDialog(context, ref, totalDays);
  }

  void _showEditTimelineDialog(BuildContext context, WidgetRef ref, int totalDays, TimelineItemModel item) {
    _showTimelineItemDialog(context, ref, totalDays, existingItem: item);
  }

  void _showTimelineItemDialog(BuildContext context, WidgetRef ref, int totalDays, {TimelineItemModel? existingItem}) {
    final titleController = TextEditingController(text: existingItem?.title);
    final timeController = TextEditingController(text: existingItem?.timeOrOffset);
    final descController = TextEditingController(text: existingItem?.description);
    TimelinePhase selectedPhase = existingItem?.phase ?? TimelinePhase.eventDay;
    int selectedDayNumber = existingItem?.dayNumber ?? 1;
    
    // Attempt to extract TimeOfDay from existing startTime
    TimeOfDay? selectedTime;
    if (existingItem?.startTime != null) {
      selectedTime = TimeOfDay.fromDateTime(existingItem!.startTime!);
    }

    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setDialogState) => ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
          child: Padding(
            padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              Text(existingItem == null ? 'Add Schedule Item' : 'Edit Schedule Item', 
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              DropdownButtonFormField<TimelinePhase>(
                value: selectedPhase,
                items: [
                  const DropdownMenuItem(value: TimelinePhase.preEvent, child: Text('Pre-Event (Setup)')),
                  const DropdownMenuItem(value: TimelinePhase.eventDay, child: Text('Event Day (Primary)')),
                  const DropdownMenuItem(value: TimelinePhase.postEvent, child: Text('Post-Event (Wrap-up)')),
                ],
                onChanged: isSaving ? null : (val) => setDialogState(() => selectedPhase = val!),
                decoration: const InputDecoration(labelText: 'Schedule Phase'),
              ),
              if (selectedPhase == TimelinePhase.eventDay && totalDays > 1) ...[
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  value: selectedDayNumber,
                  items: List.generate(totalDays, (i) => DropdownMenuItem(value: i + 1, child: Text('Day ${i + 1}'))),
                  onChanged: isSaving ? null : (val) => setDialogState(() => selectedDayNumber = val!),
                  decoration: const InputDecoration(labelText: 'Assign to Day'),
                ),
              ],
              const SizedBox(height: 8),
              TextField(
                controller: titleController, 
                enabled: !isSaving,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: timeController, 
                      enabled: !isSaving,
                      decoration: const InputDecoration(labelText: 'Time Label (e.g. Morning)')),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isSaving ? null : () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: selectedTime ?? TimeOfDay.now(),
                        );
                        if (time != null) {
                          setDialogState(() {
                            selectedTime = time;
                            if (timeController.text.isEmpty) {
                              timeController.text = time.format(context);
                            }
                          });
                        }
                      },
                      icon: const Icon(Icons.access_time, size: 18),
                      label: Text(selectedTime?.format(context) ?? 'Pick Time'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        backgroundColor: Colors.blue.shade50,
                        foregroundColor: Colors.blue.shade800,
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController, 
                enabled: !isSaving,
                decoration: const InputDecoration(labelText: 'Description (Optional)'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isSaving ? null : () async {
                  if (titleController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a title')));
                    return;
                  }
                  
                  setDialogState(() => isSaving = true);
                  
                  try {
                    DateTime? startTime;
                    if (selectedTime != null) {
                      final now = DateTime.now();
                      startTime = DateTime(now.year, now.month, now.day, selectedTime!.hour, selectedTime!.minute);
                    }

                    final newItem = (existingItem ?? TimelineItemModel(
                      id: const Uuid().v4(),
                      eventId: eventId,
                      title: '',
                      timeOrOffset: '',
                    )).copyWith(
                      title: titleController.text.trim(),
                      phase: selectedPhase,
                      dayNumber: selectedPhase == TimelinePhase.eventDay ? selectedDayNumber : 1,
                      timeOrOffset: timeController.text.trim().isEmpty && selectedTime != null 
                          ? selectedTime!.format(context) 
                          : timeController.text.trim(),
                      description: descController.text.trim().isEmpty ? null : descController.text.trim(),
                      startTime: startTime,
                    );

                    if (existingItem == null) {
                      await ref.read(timelineRepositoryProvider).addTimelineItem(newItem);
                    } else {
                      await ref.read(timelineRepositoryProvider).updateTimelineItem(newItem);
                    }
                    
                    if (context.mounted) Navigator.pop(context);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                      setDialogState(() => isSaving = false);
                    }
                  }
                },
                child: isSaving 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(existingItem == null ? 'Add to Schedule' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  DateTime? _tryParseTime(String timeStr) {
    try {
      var raw = timeStr.trim().toUpperCase();
      if (raw.isEmpty) return null;

      // Ensure space before AM/PM if missing
      if (RegExp(r'\d[AP]M$').hasMatch(raw)) {
        raw = raw.replaceFirst(RegExp(r'([AP]M)$'), r' $1');
      }

      // Try HH:mm AM/PM
      if (raw.contains('AM') || raw.contains('PM')) {
        return DateFormat('hh:mm a').parse(raw);
      }
      // Try HH:mm
      return DateFormat('HH:mm').parse(raw);
    } catch (_) {
      return null;
    }
  }
}
