import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../providers/public_dashboard_provider.dart';
import '../../data/models/event_model.dart';
import '../widgets/summary_cards.dart';

class PublicDashboardScreen extends ConsumerWidget {
  final String eventId;
  const PublicDashboardScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(publicDashboardDataProvider(eventId));

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Public Transparency Dashboard', style: TextStyle(fontSize: 16)),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: dashboardAsync.when(
        data: (dashboard) {
          final event = dashboard.event;
          final totalCollected = dashboard.totalCollected;
          final totalSpent = dashboard.totalExpenses;
          
          final memberCount = dashboard.members.length;
          final paidCount = dashboard.memberPaymentMap.length;
          final progress = memberCount == 0 ? 0.0 : paidCount / memberCount;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context, event, totalCollected, progress, paidCount, memberCount),
                const SizedBox(height: 24),
                SummaryCards(
                  totalCollected: totalCollected,
                  totalExpenses: totalSpent,
                ),
                const SizedBox(height: 24),
                Text('Member Payment List', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildMemberList(context, dashboard),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, EventModel event, double total, double progress, int paid, int totalCount) {
    return Card(
      elevation: 0,
       shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: Theme.of(context).primaryColor.withAlpha(25)),
        ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
             Text(
              event.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              event.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            if (event.note != null && event.note!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Note: ${event.note!}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontStyle: FontStyle.italic,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text('Total Collected', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text('₹$total', style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    )),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            LinearPercentIndicator(
              lineHeight: 12.0,
              percent: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.grey.withAlpha(13),
              progressColor: Theme.of(context).primaryColor,
              barRadius: const Radius.circular(6),
              animation: true,
            ),
             const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMiniStat(context, 'Paid Count', '$paid'),
                _buildMiniStat(context, 'Pending', '${totalCount - paid}'),
                _buildMiniStat(context, 'Progress', '${(progress * 100).toInt()}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _buildMemberList(BuildContext context, PublicDashboardData dashboard) {
    final members = dashboard.members;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        final isPaid = dashboard.memberPaymentMap.containsKey(member.id);

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              CircleAvatar(radius: 18, child: Text(member.name[0])),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(member.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(member.identifier, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPaid ? Colors.green.withAlpha(25) : Colors.orange.withAlpha(25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isPaid ? 'PAID' : 'PENDING',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: isPaid ? Colors.green : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
