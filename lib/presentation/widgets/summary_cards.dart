import 'package:flutter/material.dart';

class SummaryCards extends StatelessWidget {
  final double totalCollected;
  final double totalExpenses;

  const SummaryCards({
    super.key,
    required this.totalCollected,
    required this.totalExpenses,
  });

  @override
  Widget build(BuildContext context) {
    final balance = totalCollected - totalExpenses;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Financial Overview', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Collected',
                  '₹$totalCollected',
                  Colors.green,
                  Icons.arrow_downward_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Expenses',
                  '₹$totalExpenses',
                  Colors.red,
                  Icons.arrow_upward_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: _buildSummaryCard(
              context,
              'Remaining Balance',
              '₹$balance',
              Colors.blue,
              Icons.account_balance_wallet_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String label,
    String amount,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(13),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Icon(icon, size: 16, color: color),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}
