import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/expense_provider.dart';
import '../../providers/budget_provider.dart';
import '../../providers/event_provider.dart';
import '../../providers/access_control_provider.dart';
import '../../data/models/expense_model.dart';
import '../../data/models/event_model.dart';
import '../../data/models/budget_model.dart';
import '../../data/models/event_role_model.dart';
import '../../data/services/event_template_service.dart';
import 'package:uuid/uuid.dart';
import '../../providers/auth_provider.dart';
import '../../providers/event_user_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  final String eventId;
  const ExpensesScreen({super.key, required this.eventId});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> budgetCategories = ['Venue', 'Food', 'Decoration', 'Miscellaneous'];

  Future<void> _loadSuggestedBudget(EventModel event) async {
    final suggestions = EventTemplateService.getSuggestedBudget(event.id, event.category);
    final repo = ref.read(budgetRepositoryProvider);
    
    for (var item in suggestions) {
      await repo.addBudgetItem(item);
    }
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added ${suggestions.length} suggested budget items.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Add listener to rebuild when tab changes
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    
    // Use a microtask to avoid setting state during build
    Future.microtask(() {
      ref.read(currentEventIdProvider.notifier).state = widget.eventId;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(expensesForEventStreamProvider(widget.eventId));
    final budgetAsync = ref.watch(budgetForEventStreamProvider(widget.eventId));
    final eventAsync = ref.watch(eventByIdStreamProvider(widget.eventId));
    
    // Also watch currentEventProvider to ensure we have it for dialogs
    final currentEvent = eventAsync.value;

    final canEditBudget = ref.watch(
      hasModuleAccessProvider((eventId: widget.eventId, module: EventModules.budget, required: ModuleAccessLevel.edit)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget & Expense Tracking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export Financial Report (PDF/CSV)')),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Actual Expenses', icon: Icon(Icons.receipt_long_outlined)),
            Tab(text: 'Budget Planning', icon: Icon(Icons.analytics_outlined)),
            Tab(text: 'Pending Payouts', icon: Icon(Icons.volunteer_activism_outlined)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
            // Tab 1: Actual Expenses
            expensesAsync.when(
              data: (expenses) => Column(
                children: [
                  _buildMyReimbursementSummary(context, ref, expenses),
                  Expanded(
                    child: expenses.isEmpty
                        ? _buildNoData(context, 'No expenses recorded yet', Icons.receipt_outlined)
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                            itemCount: expenses.length,
                            itemBuilder: (context, index) {
                              final users = ref.watch(eventUsersWithDetailsProvider(widget.eventId)).value;
                              return _buildExpenseTile(context, expenses[index], ref, currentEvent, users);
                            },
                          ),
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
            // Tab 2: Budget Planning
            budgetAsync.when(
              data: (budget) {
                if (budget.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.analytics_outlined, size: 80, color: Colors.grey.withAlpha(128)),
                        const SizedBox(height: 16),
                        const Text('No budget planned yet'),
                        const SizedBox(height: 24),
                        eventAsync.maybeWhen(
                          data: (event) => event != null ? ElevatedButton.icon(
                            onPressed: () => _loadSuggestedBudget(event),
                            icon: const Icon(Icons.auto_fix_high),
                            label: const Text('Load Suggested Budget'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[50], 
                              foregroundColor: Colors.blue[700],
                            ),
                          ) : const SizedBox.shrink(),
                          orElse: () => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  );
                }
                return Column(
                  children: [
                    _buildBudgetSummary(budget),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                        itemCount: budget.length,
                        itemBuilder: (context, index) => _buildBudgetTile(context, budget[index], ref),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
            // Tab 3: Reimbursement Management
            expensesAsync.when(
              data: (expenses) => _buildReimbursementsTab(context, expenses, ref),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: !canEditBudget
              ? () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No permission to edit budget')))
              : () {
                  final tabIndex = _tabController.index;
                  if (tabIndex == 0) {
                    _showAddExpenseDialog(context, ref, currentEvent);
                  } else if (tabIndex == 1) {
                    _showAddBudgetDialog(context, ref);
                  } else {
                    _showBatchPayDialog(context, ref, allExpenses: expensesAsync.value ?? []);
                  }
                },
          label: Text(_tabController.index == 0 ? 'Add Expense' : (_tabController.index == 1 ? 'Add Budget' : 'Batch Pay')),
          icon: Icon(_tabController.index == 0 ? Icons.add : (_tabController.index == 1 ? Icons.add_chart_outlined : Icons.payments_outlined)),
        ),
      );
    }

  Widget _buildNoData(BuildContext context, String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey.withAlpha(80)),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildReimbursementsTab(BuildContext context, List<ExpenseModel> allExpenses, WidgetRef ref) {
    final reimbursable = allExpenses.where((e) => e.isReimbursable).toList();
    if (reimbursable.isEmpty) {
      return _buildNoData(context, 'No volunteer claims found', Icons.volunteer_activism_outlined);
    }

    final usersAsync = ref.watch(eventUsersWithDetailsProvider(widget.eventId));
    final Map<String, List<ExpenseModel>> groupedByVolunteer = {};
    for (var e in reimbursable) {
      final uid = e.paidByUserId ?? 'unknown';
      groupedByVolunteer.putIfAbsent(uid, () => []).add(e);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      children: [
        Text(
          'VOLUNTEER PAYOUTS',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.grey.shade600, letterSpacing: 1),
        ),
        const SizedBox(height: 16),
        ...groupedByVolunteer.entries.map((group) {
          final userId = group.key;
          final claims = group.value;
          final pendingCount = claims.where((c) => c.reimbursementStatus == ReimbursementStatus.pending).length;
          final approvedCount = claims.where((c) => c.reimbursementStatus == ReimbursementStatus.approved).length;
          final totalToPay = claims
              .where((c) => c.reimbursementStatus == ReimbursementStatus.approved)
              .fold(0.0, (sum, c) => sum + c.amount);

          return usersAsync.when(
            data: (users) {
              final userName = users.firstWhere((u) => u.id == userId, orElse: () => (id: userId, name: 'User $userId')).name;
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.grey.shade200)),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: Text(userName[0], style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('$pendingCount pending · $approvedCount approved'),
                  trailing: approvedCount > 0 
                    ? Text('₹$totalToPay', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.green)) 
                    : null,
                  children: [
                    ...claims.map((c) => ListTile(
                      title: Text(c.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      subtitle: Text(c.category),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('₹${c.amount}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          if (c.reimbursementStatus == ReimbursementStatus.pending) ...[
                             IconButton(onPressed: () => _handleReimbursementAction(context, ref, c, ReimbursementStatus.rejected), icon: const Icon(Icons.close, color: Colors.red, size: 18)),
                             IconButton(onPressed: () => _handleReimbursementAction(context, ref, c, ReimbursementStatus.approved), icon: const Icon(Icons.check, color: Colors.green, size: 18)),
                          ] else
                            _buildStatusTag(c.reimbursementStatus),
                        ],
                      ),
                    )),
                    if (pendingCount > 0)
                       Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextButton.icon(
                          onPressed: () => _showApproveAllDialog(context, ref, claims, userName),
                          icon: const Icon(Icons.playlist_add_check, size: 20),
                          label: Text('Review & Approve All ($pendingCount)'),
                          style: TextButton.styleFrom(
                            minimumSize: const Size(double.infinity, 45),
                            foregroundColor: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    if (approvedCount > 0)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton.icon(
                          onPressed: () => _showBatchPayDialog(
                            context, 
                            ref, 
                            targetVolunteerId: userId,
                            allExpenses: claims,
                          ),
                          icon: const Icon(Icons.payments_outlined),
                          label: Text('Pay ₹$totalToPay to $userName'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 45),
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => Text('Error loading user $userId'),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildStatusTag(ReimbursementStatus status) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withAlpha(20), borderRadius: BorderRadius.circular(4)),
      child: Text(status.name.toUpperCase(), style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: color)),
    );
  }

  Widget _buildMyReimbursementSummary(BuildContext context, WidgetRef ref, List<ExpenseModel> expenses) {
    final user = ref.watch(currentUserProvider);
    if (user == null) return const SizedBox.shrink();

    final myExpenses = expenses.where((e) => e.paidByUserId == user.id && e.paidByType == PaidByType.volunteer).toList();
    if (myExpenses.isEmpty) return const SizedBox.shrink();

    double totalSpent = 0;
    double pending = 0;
    double approved = 0;
    double paid = 0;

    for (final e in myExpenses) {
      totalSpent += e.amount;
      switch (e.reimbursementStatus) {
        case ReimbursementStatus.pending: pending += e.amount; break;
        case ReimbursementStatus.approved: approved += e.amount; break;
        case ReimbursementStatus.paid: paid += e.amount; break;
        default: break;
      }
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue.shade800, Colors.blue.shade600]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.blue.withAlpha(60), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('MY REIMBURSEMENT STATUS', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _buildSimpleStat('Total Spent', '₹$totalSpent')),
              Expanded(child: _buildSimpleStat('Pending', '₹$pending')),
              Expanded(child: _buildSimpleStat('Approved', '₹$approved')),
              Expanded(child: _buildSimpleStat('Paid', '₹$paid')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }

  Future<void> _showDeleteConfirmation({
    required BuildContext context,
    required String title,
    required Function(String reason) onDelete,
  }) async {
    final reasonController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete $title?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Are you sure you want to delete this? This action will be audited.'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for deletion',
                hintText: 'e.g. Added by mistake',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please provide a reason')));
                return;
              }
              onDelete(reasonController.text);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseTile(BuildContext context, ExpenseModel expense, WidgetRef ref, EventModel? event, List<({String id, String name})>? users) {
    final isVolunteerPaid = expense.paidByType == PaidByType.volunteer;
    final statusColor = _getStatusColor(expense.reimbursementStatus);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: ExpansionTile(
        key: PageStorageKey(expense.id),
        leading: CircleAvatar(
          backgroundColor: isVolunteerPaid ? Colors.deepPurple.shade50 : Colors.red.shade50,
          child: Icon(
            isVolunteerPaid ? Icons.person_outline : Icons.arrow_upward, 
            color: isVolunteerPaid ? Colors.deepPurple : Colors.red, 
            size: 18
          ),
        ),
        title: Row(
          children: [
            Expanded(child: Text(expense.title, style: const TextStyle(fontWeight: FontWeight.bold))),
            Text('₹${expense.amount}', style: TextStyle(fontWeight: FontWeight.w900, color: isVolunteerPaid ? Colors.deepPurple : Colors.red)),
          ],
        ),
        subtitle: Row(
          children: [
            Text(expense.category, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            if (isVolunteerPaid) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  expense.reimbursementStatus.name.toUpperCase(),
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: statusColor),
                ),
              ),
            ],
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isVolunteerPaid) ...[
                  _buildDetailRow('Paid By', 'Volunteer: ${users?.firstWhere((u) => u.id == expense.paidByUserId, orElse: () => (id: expense.paidByUserId!, name: 'User ${expense.paidByUserId}')).name ?? expense.paidByUserId}'),
                  _buildDetailRow('Reimbursement', expense.reimbursementStatus.name.toUpperCase()),
                  if (expense.reimbursementStatus == ReimbursementStatus.paid) ...[
                    _buildDetailRow('Paid At', expense.paidAt?.toString().split('.').first ?? 'N/A'),
                    _buildDetailRow('Mode', expense.paymentMode ?? 'N/A'),
                    _buildDetailRow('Ref', expense.transactionRef ?? 'N/A'),
                  ],
                  if (expense.reimbursementStatus == ReimbursementStatus.rejected)
                    _buildDetailRow('Reason', expense.rejectionReason ?? 'No reason provided', color: Colors.red),
                ],
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isVolunteerPaid && expense.reimbursementStatus == ReimbursementStatus.pending) ...[
                      TextButton(
                        onPressed: () => _handleReimbursementAction(context, ref, expense, ReimbursementStatus.rejected),
                        child: const Text('Reject', style: TextStyle(color: Colors.red)),
                      ),
                      ElevatedButton(
                        onPressed: () => _handleReimbursementAction(context, ref, expense, ReimbursementStatus.approved),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, elevation: 0),
                        child: const Text('Approve'),
                      ),
                    ] else if (isVolunteerPaid && expense.reimbursementStatus == ReimbursementStatus.approved)
                      ElevatedButton.icon(
                        onPressed: () => _showMarkAsPaidDialog(context, ref, expense),
                        icon: const Icon(Icons.check_circle_outline, size: 16),
                        label: const Text('Mark as Reimbursed'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, elevation: 0),
                      ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                      onPressed: () => _showDeleteConfirmation(
                        context: context,
                        title: expense.title,
                        onDelete: (reason) => ref.read(expenseRepositoryProvider).deleteExpense(
                          expense.eventId,
                          expense.id,
                          reason: reason,
                          prevData: expense.toJson(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Color _getStatusColor(ReimbursementStatus status) {
    switch (status) {
      case ReimbursementStatus.pending: return Colors.orange;
      case ReimbursementStatus.approved: return Colors.blue;
      case ReimbursementStatus.paid: return Colors.green;
      case ReimbursementStatus.rejected: return Colors.red;
      default: return Colors.grey;
    }
  }

  Future<void> _handleReimbursementAction(BuildContext context, WidgetRef ref, ExpenseModel expense, ReimbursementStatus nextStatus) async {
    String? reason;
    
    if (nextStatus == ReimbursementStatus.approved) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Approve Reimbursement?'),
          content: Text('Are you sure you want to approve ₹${expense.amount} for "${expense.title}"? This action will be audited.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true), 
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              child: const Text('Yes, Approve'),
            ),
          ],
        ),
      );
      if (confirm != true) return;
    }

    if (nextStatus == ReimbursementStatus.rejected) {
      final controller = TextEditingController();
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Reject Reimbursement?'),
          content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Reason for rejection')),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Reject')),
          ],
        ),
      );
      if (confirm != true) return;
      reason = controller.text;
    }

    final updated = expense.copyWith(
      reimbursementStatus: nextStatus,
      approvedBy: nextStatus == ReimbursementStatus.approved ? ref.read(currentUserProvider)?.id : null,
      approvedAt: nextStatus == ReimbursementStatus.approved ? DateTime.now() : null,
      rejectionReason: reason,
    );
    await ref.read(expenseRepositoryProvider).updateExpense(updated);
  }

  void _showMarkAsPaidDialog(BuildContext context, WidgetRef ref, ExpenseModel expense) {
    final refController = TextEditingController();
    String selectedMode = 'UPI';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Reimbursement Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Mark this expense as fully reimbursed.'),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedMode,
                items: ['UPI', 'Bank Transfer', 'Cash'].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                onChanged: (val) => setState(() => selectedMode = val!),
                decoration: const InputDecoration(labelText: 'Payment Mode'),
              ),
              TextField(controller: refController, decoration: const InputDecoration(labelText: 'Transaction Reference (Optional)')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final updated = expense.copyWith(
                  reimbursementStatus: ReimbursementStatus.paid,
                  paidAt: DateTime.now(),
                  paymentMode: selectedMode,
                  transactionRef: refController.text,
                );
                await ref.read(expenseRepositoryProvider).updateExpense(updated);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Confirm Payment'),
            ),
          ],
        ),
      ),
    );
  }

  void _showBatchPayDialog(BuildContext context, WidgetRef ref, {String? targetVolunteerId, required List<ExpenseModel> allExpenses}) {
    final toPay = allExpenses.where((e) => 
      e.reimbursementStatus == ReimbursementStatus.approved && 
      (targetVolunteerId == null || e.paidByUserId == targetVolunteerId)
    ).toList();

    if (toPay.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No approved claims to pay')));
      return;
    }

    final total = toPay.fold(0.0, (sum, e) => sum + e.amount);
    final refController = TextEditingController();
    String selectedMode = 'UPI';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(targetVolunteerId == null ? 'Global Batch Payout' : 'Settle Payout'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Settling ${toPay.length} approved claims totaling ₹$total.'),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedMode,
                items: ['UPI', 'Bank Transfer', 'Cash'].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                onChanged: (val) => setState(() => selectedMode = val!),
                decoration: const InputDecoration(labelText: 'Payment Mode'),
              ),
              TextField(controller: refController, decoration: const InputDecoration(labelText: 'Common Ref (Optional)')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final repo = ref.read(expenseRepositoryProvider);
                for (var e in toPay) {
                  final updated = e.copyWith(
                    reimbursementStatus: ReimbursementStatus.paid,
                    paidAt: DateTime.now(),
                    paymentMode: selectedMode,
                    transactionRef: refController.text,
                  );
                  await repo.updateExpense(updated);
                }
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Paid ₹$total across ${toPay.length} claims')));
                }
              },
              child: const Text('Process Payouts'),
            ),
          ],
        ),
      ),
    );
  }

  void _showApproveAllDialog(BuildContext context, WidgetRef ref, List<ExpenseModel> volunteerClaims, String userName) {
    final pending = volunteerClaims.where((e) => e.reimbursementStatus == ReimbursementStatus.pending).toList();
    if (pending.isEmpty) return;

    final total = pending.fold(0.0, (sum, e) => sum + e.amount);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Approve all for $userName?'),
        content: Text('Are you sure you want to approve ${pending.length} pending claims totaling ₹$total?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final repo = ref.read(expenseRepositoryProvider);
              final organizerId = ref.read(currentUserProvider)?.id;
              for (var e in pending) {
                final updated = e.copyWith(
                  reimbursementStatus: ReimbursementStatus.approved,
                  approvedBy: organizerId,
                  approvedAt: DateTime.now(),
                );
                await repo.updateExpense(updated);
              }
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Approved ${pending.length} claims for $userName')));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            child: const Text('Approve All'),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetSummary(List<BudgetItemModel> budget) {
    final totalPlanned = budget.fold(0.0, (sum, b) => sum + b.estimatedCost);
    final totalActual = budget.fold(0.0, (sum, b) => sum + b.actualCost);
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _buildSimpleSummary('TOTAL PLANNED', '₹${totalPlanned.toStringAsFixed(0)}', Colors.blue)),
              const SizedBox(width: 16),
              Expanded(child: _buildSimpleSummary('TOTAL ACTUAL', '₹${totalActual.toStringAsFixed(0)}', totalActual > totalPlanned ? Colors.red : Colors.green)),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearPercentIndicator(
              lineHeight: 8.0,
              percent: totalPlanned > 0 ? (totalActual / totalPlanned).clamp(0.0, 1.0) : 0.0,
              backgroundColor: Colors.grey.shade100,
              progressColor: totalActual > totalPlanned ? Colors.red : Colors.blue,
              barRadius: const Radius.circular(4),
              animation: true,
              padding: EdgeInsets.zero,
            ),
          ),
          if (totalActual > totalPlanned)
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text('Warning: Total actual spending exceeds planned budget!', style: TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  Widget _buildSimpleSummary(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.grey.shade600, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: color)),
        ),
      ],
    );
  }

  Widget _buildBudgetTile(BuildContext context, BudgetItemModel item, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showEditBudgetDialog(context, ref, item),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue.shade50,
                radius: 18,
                child: Icon(Icons.calculate_outlined, color: Colors.blue.shade800, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text(
                          item.category,
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                        ),
                        const SizedBox(width: 4),
                        if (item.isMandatory)
                          const Icon(Icons.priority_high, size: 10, color: Colors.red)
                        else
                          const Icon(Icons.check_circle_outline, size: 10, color: Colors.green),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '₹${item.actualCost.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        color: item.actualCost > item.estimatedCost ? Colors.red : Colors.green,
                      ),
                    ),
                  ),
                  Text('Actual', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                ],
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '₹${item.estimatedCost.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                  Text(item.isMandatory ? 'Planned' : 'Optional', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                ],
              ),
              const SizedBox(width: 4),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
                padding: EdgeInsets.zero,
                onSelected: (val) {
                  if (val == 'edit') {
                    _showEditBudgetDialog(context, ref, item);
                  } else if (val == 'delete') {
                    _showDeleteConfirmation(
                      context: context,
                      title: item.title,
                      onDelete: (reason) => ref.read(budgetRepositoryProvider).deleteBudgetItem(
                            item.eventId,
                            item.id,
                            reason: reason,
                            prevData: item.toJson(),
                          ),
                    );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: ListTile(leading: Icon(Icons.edit_outlined, size: 20), title: Text('Edit'), contentPadding: EdgeInsets.zero)),
                  const PopupMenuItem(value: 'delete', child: ListTile(leading: Icon(Icons.delete_outline, color: Colors.red, size: 20), title: Text('Delete', style: TextStyle(color: Colors.red)), contentPadding: EdgeInsets.zero)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditBudgetDialog(BuildContext context, WidgetRef ref, BudgetItemModel item) {
    final categories = List<String>.from(budgetCategories);
    if (!categories.contains(item.category)) {
      categories.add(item.category);
    }

    String selectedCategory = item.category;
    bool isMandatory = item.isMandatory;

    final titleController = TextEditingController(text: item.title);
    final estimatedController = TextEditingController(text: item.estimatedCost.toStringAsFixed(0));
    final noteController = TextEditingController(text: item.note ?? '');

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Budget Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) => setDialogState(() => selectedCategory = val ?? selectedCategory),
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: estimatedController,
                  decoration: const InputDecoration(labelText: 'Planned Amount'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Mandatory'),
                  value: isMandatory,
                  onChanged: (v) => setDialogState(() => isMandatory = v),
                ),
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(labelText: 'Note (optional)'),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                if (title.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Title is required.')));
                  return;
                }

                final planned = double.tryParse(estimatedController.text.trim()) ?? item.estimatedCost;
                final next = item.copyWith(
                  title: title,
                  category: selectedCategory,
                  estimatedCost: planned,
                  isMandatory: isMandatory,
                  note: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
                );

                try {
                  await ref.read(budgetRepositoryProvider).updateBudgetItem(next);
                  if (context.mounted) Navigator.pop(context);
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Update failed: $e')));
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context, WidgetRef ref, EventModel? event) {
    final categories = event?.expenseCategories ?? ['Miscellaneous'];
    String selectedCategory = categories.first;
    PaidByType selectedPaidBy = PaidByType.organizer;
    String? selectedVolunteerId;

    final titleController = TextEditingController();
    final amountController = TextEditingController();
    String? selectedBudgetItemId;

    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final usersAsync = ref.watch(eventUsersWithDetailsProvider(widget.eventId));
          
          return StatefulBuilder(
            builder: (context, setDialogState) => AlertDialog(
              title: const Text('Record Expense'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Expense Title', hintText: 'e.g. Catering, Taxi')),
                    TextField(controller: amountController, decoration: const InputDecoration(labelText: 'Amount'), keyboardType: TextInputType.number),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (val) => setDialogState(() => selectedCategory = val!),
                      decoration: const InputDecoration(labelText: 'Category'),
                    ),
                    const SizedBox(height: 12),
                    ref.watch(budgetForEventStreamProvider(widget.eventId)).when(
                      data: (budget) => DropdownButtonFormField<String?>(
                        value: selectedBudgetItemId,
                        isExpanded: true,
                        hint: const Text('Link to Budget Item (Optional)', style: TextStyle(fontSize: 13)),
                        selectedItemBuilder: (context) {
                          return [
                            const Text('None', style: TextStyle(fontSize: 13, overflow: TextOverflow.ellipsis)),
                            ...budget.map((b) => Text('${b.title} (₹${b.estimatedCost})', style: const TextStyle(fontSize: 13, overflow: TextOverflow.ellipsis))),
                          ];
                        },
                        items: [
                          const DropdownMenuItem<String?>(value: null, child: Text('None', style: TextStyle(fontSize: 13))),
                          ...budget.map((b) => DropdownMenuItem(
                            value: b.id, 
                            child: Text('${b.title} (₹${b.estimatedCost})', style: const TextStyle(fontSize: 13, overflow: TextOverflow.ellipsis))
                          )),
                        ],
                        onChanged: (val) {
                          setDialogState(() {
                            selectedBudgetItemId = val;
                            if (val != null) {
                              final item = budget.firstWhere((i) => i.id == val);
                              selectedCategory = item.category;
                              if (titleController.text.isEmpty) {
                                titleController.text = item.title;
                              }
                            }
                          });
                        },
                        decoration: const InputDecoration(labelText: 'Budget Alignment', contentPadding: EdgeInsets.symmetric(horizontal: 0)),
                      ),
                      loading: () => const LinearProgressIndicator(),
                      error: (err, _) => Text('Error loading budget: $err'),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    const Text('PAYMENT DETAILS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('Organizer Paid'),
                            selected: selectedPaidBy == PaidByType.organizer,
                            onSelected: (val) => setDialogState(() => selectedPaidBy = PaidByType.organizer),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('Volunteer Paid'),
                            selected: selectedPaidBy == PaidByType.volunteer,
                            onSelected: (val) => setDialogState(() => selectedPaidBy = PaidByType.volunteer),
                          ),
                        ),
                      ],
                    ),
                    if (selectedPaidBy == PaidByType.volunteer) ...[
                      const SizedBox(height: 12),
                      usersAsync.when(
                        data: (users) => DropdownButtonFormField<String>(
                          hint: const Text('Select Volunteer'),
                          value: selectedVolunteerId,
                          items: users.map((u) => DropdownMenuItem(value: u.id, child: Text(u.name))).toList(),
                          onChanged: (val) => setDialogState(() => selectedVolunteerId = val),
                          decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12)),
                        ),
                        loading: () => const Center(heightFactor: 1, child: LinearProgressIndicator()),
                        error: (_, __) => const Text('Error loading users'),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedPaidBy == PaidByType.volunteer && selectedVolunteerId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select the volunteer who paid')));
                      return;
                    }
                    
                    final isVolunteer = selectedPaidBy == PaidByType.volunteer;
                    final newExpense = ExpenseModel(
                      id: const Uuid().v4(),
                      eventId: widget.eventId,
                      title: titleController.text,
                      amount: double.tryParse(amountController.text) ?? 0.0,
                      category: selectedCategory,
                      createdAt: DateTime.now(),
                      status: (event?.isExpenseApprovalRequired ?? false) ? ExpenseStatus.pending : ExpenseStatus.approved,
                      paidByType: selectedPaidBy,
                      paidByUserId: selectedVolunteerId,
                      isReimbursable: isVolunteer,
                      reimbursementStatus: isVolunteer ? ReimbursementStatus.pending : ReimbursementStatus.none,
                      budgetItemId: selectedBudgetItemId,
                    );
                    await ref.read(expenseRepositoryProvider).addExpense(newExpense);
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text('Record'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddBudgetDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final costController = TextEditingController();
    String selectedCategory = budgetCategories.first;
    bool isMandatory = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 24, left: 24, right: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Add Planned Item', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Item Name')),
              TextField(controller: costController, decoration: const InputDecoration(labelText: 'Estimated Cost')),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: budgetCategories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setDialogState(() => selectedCategory = val!),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              SwitchListTile(
                title: const Text('Is this expense mandatory?'),
                value: isMandatory,
                onChanged: (val) => setDialogState(() => isMandatory = val),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final cost = double.tryParse(costController.text);
                  if (cost == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid amount')));
                    return;
                  }
                  final newItem = BudgetItemModel(
                    id: const Uuid().v4(),
                    eventId: widget.eventId,
                    category: selectedCategory,
                    title: titleController.text,
                    estimatedCost: cost,
                    isMandatory: isMandatory,
                  );
                  await ref.read(budgetRepositoryProvider).addBudgetItem(newItem);
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text('Add to Plan'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
