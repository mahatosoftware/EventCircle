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

class ExpensesScreen extends ConsumerStatefulWidget {
  final String eventId;
  const ExpensesScreen({super.key, required this.eventId});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
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
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(expensesStreamProvider);
    final budgetAsync = ref.watch(budgetStreamProvider);
    final eventAsync = ref.watch(currentEventProvider);
    final canEditBudget = ref.watch(
      hasModuleAccessProvider((eventId: widget.eventId, module: EventModules.budget, required: ModuleAccessLevel.edit)),
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Finance Management'),
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
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Actual Expenses', icon: Icon(Icons.receipt_long_outlined)),
              Tab(text: 'Budget Planning', icon: Icon(Icons.analytics_outlined)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Actual Expenses
            expensesAsync.when(
              data: (expenses) => expenses.isEmpty
                  ? _buildNoData(context, 'No expenses recorded yet', Icons.receipt_outlined)
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: expenses.length,
                      itemBuilder: (context, index) => _buildExpenseTile(context, expenses[index], ref),
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
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: budget.length,
                  itemBuilder: (context, index) => _buildBudgetTile(context, budget[index], ref),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton.extended(
            onPressed: !canEditBudget
                ? () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No permission to edit budget')))
                : () {
                    final tabIndex = DefaultTabController.of(context).index;
                    if (tabIndex == 0) {
                      _showAddExpenseDialog(context, ref);
                    } else {
                      _showAddBudgetDialog(context, ref);
                    }
                  },
            label: Text(DefaultTabController.of(context).index == 0 ? 'Add Expense' : 'Add Budget'),
            icon: Icon(DefaultTabController.of(context).index == 0 ? Icons.add : Icons.add_chart_outlined),
          ),
        ),
      ),
    );
  }

  Widget _buildNoData(BuildContext context, String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey.withAlpha(128)),
          const SizedBox(height: 16),
          Text(message),
        ],
      ),
    );
  }

  Widget _buildExpenseTile(BuildContext context, ExpenseModel expense, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: Colors.redAccent, child: Icon(Icons.arrow_upward, color: Colors.white, size: 16)),
        title: Text(expense.title),
        subtitle: Text(expense.category),
        trailing: Text('₹${expense.amount}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
      ),
    );
  }

  Widget _buildBudgetTile(BuildContext context, BudgetItemModel item, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: Colors.blueAccent, child: Icon(Icons.calculate_outlined, color: Colors.white, size: 16)),
        title: Text(item.title),
        subtitle: Row(
          children: [
            Text(item.category, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 8),
            if (item.isMandatory) 
              const Icon(Icons.priority_high, size: 12, color: Colors.red)
            else 
              const Icon(Icons.check_circle_outline, size: 12, color: Colors.green),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('₹${item.estimatedCost}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            Text(item.isMandatory ? 'Mandatory' : 'Optional', style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context, WidgetRef ref) {
    final event = ref.read(currentEventProvider).value;
    final categories = event?.expenseCategories ?? ['Miscellaneous'];
    String selectedCategory = categories.first;

    final titleController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Expense Record'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Expense Title')),
              TextField(controller: amountController, decoration: const InputDecoration(labelText: 'Amount'), keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setDialogState(() => selectedCategory = val!),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final newExpense = ExpenseModel(
                  id: const Uuid().v4(),
                  eventId: widget.eventId,
                  title: titleController.text,
                  amount: double.tryParse(amountController.text) ?? 0.0,
                  category: selectedCategory,
                  createdAt: DateTime.now(),
                  status: (event?.isExpenseApprovalRequired ?? false) ? ExpenseStatus.pending : ExpenseStatus.approved,
                );
                await ref.read(expenseRepositoryProvider).addExpense(newExpense);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Record Expense'),
            ),
          ],
        ),
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
                  final newItem = BudgetItemModel(
                    id: const Uuid().v4(),
                    eventId: widget.eventId,
                    category: selectedCategory,
                    title: titleController.text,
                    estimatedCost: double.parse(costController.text),
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
