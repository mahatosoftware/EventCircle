import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../providers/event_provider.dart';
import '../../providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Events'),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Account',
            onSelected: (value) async {
              switch (value) {
                case 'profile':
                  context.push('/profile');
                  return;
                case 'logout':
                  await ref.read(authRepositoryProvider).logout();
                  if (context.mounted) context.go('/login');
                  return;
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'profile', child: Text('Profile')),
              PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.account_circle_outlined),
            ),
          ),
        ],
      ),
      body: eventsAsync.when(
        data: (events) => events.isEmpty
            ? _buildEmptyState(context)
            : RefreshIndicator(
                onRefresh: () async => ref.refresh(eventsStreamProvider),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return _buildEventCard(context, event, ref);
                  },
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/create-event'),
        label: const Text('Create Event'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_available, size: 80, color: Colors.grey.withAlpha(128)),
          const SizedBox(height: 16),
          Text(
            'No events found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text('Create your first event to get started'),
        ],
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, dynamic event, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          ref.read(currentEventIdProvider.notifier).state = event.id;
          // Pass the already-loaded event so the dashboard can render instantly
          // while Firestore streams warm up on first navigation.
          context.push('/event/${event.id}', extra: event);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      event.category.displayName,
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange.withAlpha(25),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.orange.withAlpha(50)),
                    ),
                    child: Text(
                      event.contributionType.displayName,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                event.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(event.location ?? 'No location', style: const TextStyle(color: Colors.grey)),
                  const Spacer(),
                  const Icon(Icons.date_range_outlined, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    event.startDate != null
                        ? '${DateFormat('MMM dd').format(event.startDate!)} - ${DateFormat('MMM dd, yyyy').format(event.endDate!)}'
                        : DateFormat('MMM dd, yyyy').format(event.createdAt),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
