import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/custom_announcement_provider.dart';
import '../../providers/event_provider.dart';
import '../../data/models/custom_announcement_model.dart';
import '../../data/models/event_model.dart';
import '../../data/services/event_template_service.dart';
import 'package:uuid/uuid.dart';

class AnnouncementsScreen extends ConsumerWidget {
  final String eventId;
  const AnnouncementsScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsAsync = ref.watch(announcementsStreamProvider);
    final eventAsync = ref.watch(currentEventProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Announcements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            tooltip: 'Load Sample Announcements',
            onPressed: () => _loadSuggestedAnnouncements(ref, eventAsync.value!),
          ),
        ],
      ),
      body: announcementsAsync.when(
        data: (announcements) => announcements.isEmpty
            ? _buildNoAnnouncements(context)
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: announcements.length,
                itemBuilder: (context, index) {
                  final announcement = announcements[index];
                  return _buildAnnouncementCard(context, announcement);
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAnnouncementDialog(context, ref),
        label: const Text('Post Update'),
        icon: const Icon(Icons.campaign_outlined),
      ),
    );
  }

  Widget _buildNoAnnouncements(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.campaign_outlined, size: 80, color: Colors.grey.withAlpha(128)),
          const SizedBox(height: 16),
          const Text('No announcements yet. Keep your circle updated!'),
        ],
      ),
    );
  }

  void _loadSuggestedAnnouncements(WidgetRef ref, EventModel event) async {
    final suggestions = EventTemplateService.getSuggestedAnnouncements(event.id, event.category);
    final repo = ref.read(customAnnouncementRepositoryProvider);
    for (var a in suggestions) {
      await repo.addAnnouncement(a);
    }
  }

  Widget _buildAnnouncementCard(BuildContext context, AnnouncementModel announcement) {
    Color cardColor;
    IconData icon;
    switch (announcement.category) {
      case AnnouncementCategory.urgent:
        cardColor = Colors.red.withAlpha(20); icon = Icons.warning_amber_rounded; break;
      case AnnouncementCategory.logistics:
        cardColor = Colors.blue.withAlpha(20); icon = Icons.map_outlined; break;
      default:
        cardColor = Colors.grey.withAlpha(10); icon = Icons.info_outline;
    }

    return Card(
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(announcement.category.name.toUpperCase(), 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Theme.of(context).primaryColor)),
                const Spacer(),
                Text(announcement.postedBy, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 12),
            Text(announcement.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(announcement.message, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
            Text(announcement.createdAt.toString().split(' ')[0], 
              style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  void _showAddAnnouncementDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final messageController = TextEditingController();
    AnnouncementCategory selectedCategory = AnnouncementCategory.general;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Post New Announcement'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
              TextField(controller: messageController, decoration: const InputDecoration(labelText: 'Message Body'), maxLines: 3),
              const SizedBox(height: 12),
              DropdownButtonFormField<AnnouncementCategory>(
                value: selectedCategory,
                items: AnnouncementCategory.values.map((c) => DropdownMenuItem(value: c, child: Text(c.name.toUpperCase()))).toList(),
                onChanged: (val) => setDialogState(() => selectedCategory = val!),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final newAnnouncement = AnnouncementModel(
                  id: const Uuid().v4(),
                  eventId: eventId,
                  title: titleController.text,
                  message: messageController.text,
                  category: selectedCategory,
                  createdAt: DateTime.now(),
                  postedBy: 'Organizer', // Default for now
                );
                await ref.read(customAnnouncementRepositoryProvider).addAnnouncement(newAnnouncement);
                Navigator.pop(context);
              },
              child: const Text('Post Update'),
            ),
          ],
        ),
      ),
    );
  }
}
