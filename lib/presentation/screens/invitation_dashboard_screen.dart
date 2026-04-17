import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../providers/guest_invitation_provider.dart';
import '../../providers/member_provider.dart';
import '../../providers/event_provider.dart';
import '../../data/models/member_model.dart';
import '../../data/models/template_model.dart';

class InvitationDashboardScreen extends ConsumerWidget {
  final String eventId;

  const InvitationDashboardScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(rsvpStatsProvider(eventId));
    final membersAsync = ref.watch(membersProvider(eventId));
    final primaryColor = Theme.of(context).primaryColor;
    final eventAsync = ref.watch(eventByIdStreamProvider(eventId));
    final isLocationEnabled = eventAsync.maybeWhen(
      data: (e) {
        final snapshot = e?.templateSnapshot;
        if (snapshot == null) return true;
        final modules = snapshot?['enabledModules'] as List? ?? [];
        return modules.contains('location');
      },
      orElse: () => true,
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Invitation & RSVP', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/event/$eventId/invitation/edit'),
            icon: const Icon(Icons.edit_note, color: Colors.blue),
            tooltip: 'Edit Invitation Design',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(rsvpStatsProvider(eventId)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isLocationEnabled)
                _buildWarningBanner(
                  context,
                  'Location module is not enabled for this event. Venue details in invitations may be incomplete.',
                ),
              _buildStatsGrid(statsAsync, context),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Guest Responses',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: () => context.push('/event/$eventId/members'),
                    icon: const Icon(Icons.group, size: 18),
                    label: const Text('Manage List'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildGuestList(membersAsync, eventId),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _sharePublicLink(context),
        label: const Text('Share Invite Link', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.share, color: Colors.white),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildWarningBanner(BuildContext context, String message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.amber.shade900, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.amber.shade900, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(AsyncValue<Map<String, int>> statsAsync, BuildContext context) {
    return statsAsync.when(
      data: (stats) => GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.4,
        children: [
          _buildStatCard(context, 'Total Guests', stats['total']?.toString() ?? '0', Colors.indigo, Icons.people_outline),
          _buildStatCard(context, 'Total Heads', stats['totalHeads']?.toString() ?? '0', Colors.deepPurple, Icons.groups_outlined),
          _buildStatCard(context, 'Attending', stats['attending']?.toString() ?? '0', Colors.green, Icons.check_circle_outline),
          _buildStatCard(context, 'Invited', stats['pending']?.toString() ?? '0', Colors.blue, Icons.mail_outline),
          _buildStatCard(context, 'Maybe', stats['maybe']?.toString() ?? '0', Colors.orange, Icons.help_outline),
          _buildStatCard(context, 'Declined', stats['declined']?.toString() ?? '0', Colors.red, Icons.cancel_outlined),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildGuestList(AsyncValue<List<MemberModel>> membersAsync, String eventId) {
    return membersAsync.when(
      data: (members) {
        if (members.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  Icon(Icons.people_outline, size: 48, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  const Text('No guests found', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          );
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: members.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final guest = members[index];
            return _buildGuestTile(context, guest, eventId);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildGuestTile(BuildContext context, MemberModel guest, String eventId) {
    Color statusColor;
    String statusText;

    switch (guest.rsvpStatus) {
      case RsvpStatus.attending:
        statusColor = Colors.green;
        statusText = 'Attending';
        break;
      case RsvpStatus.maybe:
        statusColor = Colors.orange;
        statusText = 'Maybe';
        break;
      case RsvpStatus.declined:
        statusColor = Colors.red;
        statusText = 'Declined';
        break;
      case RsvpStatus.none:
        statusColor = Colors.grey;
        statusText = 'Pending';
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.1),
          child: Text(guest.name[0], style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
        ),
        title: Text(guest.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(guest.phone, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                statusText,
                style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.ios_share, color: Colors.blue.shade400, size: 20),
              onPressed: () => _shareIndividualInvite(guest, eventId),
            ),
          ],
        ),
      ),
    );
  }

  void _shareIndividualInvite(MemberModel guest, String eventId) {
    final url = 'https://eventcircle.mahato.in/public/invite/$eventId/${guest.id}';
    final message = 'Hi ${guest.name}, you are cordially invited to our event! Please RSVP here: $url';
    Share.share(message);
  }

  void _sharePublicLink(BuildContext context) {
    final url = 'https://eventcircle.mahato.in/public/invite/$eventId/new'; 
    final message = 'Join us for our event! Click here to RSVP: $url';
    Share.share(message);
  }
}
