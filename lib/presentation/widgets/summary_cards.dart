import 'package:flutter/material.dart';

class SummaryCards extends StatelessWidget {
  final double totalCollected;
  final double totalExpenses;
  final double? totalPlannedBudget;

  const SummaryCards({
    super.key,
    required this.totalCollected,
    required this.totalExpenses,
    this.totalPlannedBudget,
  });

  @override
  Widget build(BuildContext context) {
    final balance = totalCollected - totalExpenses;
    final budgetProgress = totalPlannedBudget != null && totalPlannedBudget! > 0 
        ? totalExpenses / totalPlannedBudget! 
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Financial Overview', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
          const SizedBox(height: 16),
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
          if (totalPlannedBudget != null && totalPlannedBudget! > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withAlpha(10),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.withAlpha(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text('Budget Performance', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue)),
                      ),
                      Text('₹${totalExpenses.toStringAsFixed(0)} / ₹${totalPlannedBudget?.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.blue)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: budgetProgress.clamp(0.0, 1.0),
                      backgroundColor: Colors.white,
                      color: budgetProgress > 1.0 ? Colors.red : Colors.blue,
                      minHeight: 8,
                    ),
                  ),
                  if (budgetProgress > 1.0)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text('Note: You have exceeded the planned budget!', style: TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: _buildSummaryCard(
              context,
              'Remaining Balance',
              '₹$balance',
              balance >= 0 ? Colors.blue : Colors.red,
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
