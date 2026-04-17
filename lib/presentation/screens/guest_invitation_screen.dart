import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/guest_invitation_provider.dart';
import '../../providers/member_provider.dart';
import '../../data/models/member_model.dart';
import '../../data/models/invitation_config_model.dart';

class GuestInvitationScreen extends ConsumerStatefulWidget {
  final String eventId;
  final String memberId;

  const GuestInvitationScreen({
    super.key,
    required this.eventId,
    required this.memberId,
  });

  @override
  ConsumerState<GuestInvitationScreen> createState() => _GuestInvitationScreenState();
}

class _GuestInvitationScreenState extends ConsumerState<GuestInvitationScreen> {
  RsvpStatus _selectedRsvp = RsvpStatus.none;
  int _plusOnes = 0;
  final Map<String, dynamic> _responses = {};
  bool _isSubmitting = false;
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    final configAsync = ref.watch(invitationConfigProvider(widget.eventId));
    final memberAsync = ref.watch(memberByIdProvider((widget.eventId, widget.memberId)));

    return Scaffold(
      backgroundColor: Colors.white,
      body: configAsync.when(
        data: (config) {
          if (config == null) return const Center(child: Text('Invitation not found'));
          
          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(config),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(config, memberAsync.value),
                      const SizedBox(height: 32),
                      _buildEventDetails(config),
                      const SizedBox(height: 40),
                      if (!_submitted)
                        _buildRsvpForm(config)
                      else
                        _buildSuccessState(),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildSliverAppBar(InvitationConfigModel config) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              config.bannerUrl ?? 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?q=80&w=2069&auto=format&fit=crop',
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    Colors.black.withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(InvitationConfigModel config, MemberModel? member) {
    return Column(
      children: [
        if (member != null)
          Text(
            'Hello ${member.name},',
            style: const TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        const SizedBox(height: 12),
        Text(
          config.title?.toUpperCase() ?? 'YOU ARE INVITED',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: 40,
          height: 2,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 24),
        Text(
          config.message ?? 'Please join us for a celebration of love and community.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade700,
            height: 1.5,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildEventDetails(InvitationConfigModel config) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          _buildDetailRow(Icons.calendar_today_outlined, 'DATE', config.eventDate?.toString().split(' ')[0] ?? 'TBA'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(),
          ),
          _buildDetailRow(Icons.access_time, 'TIME', 'Starts at 7:00 PM'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(),
          ),
          _buildDetailRow(Icons.location_on_outlined, 'LOCATION', config.venueName ?? 'Secret Location'),
          if (config.venueAddress != null) ...[
            const SizedBox(height: 4),
            Text(config.venueAddress!, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.bold, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRsvpForm(InvitationConfigModel config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Will you join us?",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: _buildRsvpOption(RsvpStatus.attending, 'YES', Colors.green)),
            const SizedBox(width: 12),
            Expanded(child: _buildRsvpOption(RsvpStatus.maybe, 'MAYBE', Colors.orange)),
            const SizedBox(width: 12),
            Expanded(child: _buildRsvpOption(RsvpStatus.declined, 'NO', Colors.red)),
          ],
        ),
        if (_selectedRsvp == RsvpStatus.attending) ...[
          const SizedBox(height: 32),
          const Text('Number of Additional Guests', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildPlusOneBtn(Icons.remove, () => setState(() => _plusOnes = (_plusOnes - 1).clamp(0, 5))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text('$_plusOnes', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              _buildPlusOneBtn(Icons.add, () => setState(() => _plusOnes = (_plusOnes + 1).clamp(0, 5))),
            ],
          ),
        ],
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: _selectedRsvp == RsvpStatus.none || _isSubmitting ? null : _submitRsvp,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          child: _isSubmitting
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text('SUBMIT RSVP', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        ),
      ],
    );
  }

  Widget _buildRsvpOption(RsvpStatus status, String label, Color color) {
    final isSelected = _selectedRsvp == status;
    return GestureDetector(
      onTap: () => setState(() => _selectedRsvp = status),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? color : Colors.grey.shade200, width: 2),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildPlusOneBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }

  Widget _buildSuccessState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 64),
          const SizedBox(height: 16),
          const Text('RSVP Submitted!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green)),
          const SizedBox(height: 8),
          Text(
            _selectedRsvp == RsvpStatus.attending
                ? 'Thank you! We look forward to seeing you.'
                : 'Thank you for letting us know.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.green.shade700),
          ),
        ],
      ),
    );
  }

  Future<void> _submitRsvp() async {
    setState(() => _isSubmitting = true);
    try {
      await ref.read(guestInvitationRepositoryProvider).submitRsvp(
        eventId: widget.eventId,
        memberId: widget.memberId,
        status: _selectedRsvp,
        plusOnes: _plusOnes,
        customResponses: _responses,
      );
      setState(() {
        _submitted = true;
        _isSubmitting = false;
      });
    } catch (e) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}
