import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/event_provider.dart';
import '../../data/models/event_model.dart';
import '../../data/services/event_template_service.dart';

class FinanceSettingsScreen extends ConsumerStatefulWidget {
  final String eventId;
  const FinanceSettingsScreen({super.key, required this.eventId});

  @override
  ConsumerState<FinanceSettingsScreen> createState() => _FinanceSettingsScreenState();
}

class _FinanceSettingsScreenState extends ConsumerState<FinanceSettingsScreen> {
  final List<String> availablePaymentMethods = ['UPI', 'Cash', 'Bank Transfer', 'Cheque'];
  late EventModel _initialEvent;
  bool _isInit = false;

  // Local state for edits
  late List<ContributionType> _selectedModels;
  late List<String> _selectedPaymentMethods;
  late String _targetGroup;
  late bool _expenseApprovalRequired;
  late List<String> _expenseCategories;

  @override
  Widget build(BuildContext context) {
    final eventAsync = ref.watch(eventStreamProvider(widget.eventId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance & Expense Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tips_and_updates_outlined),
            tooltip: 'Load Financial Suggestion',
            onPressed: () => _loadSuggestion(),
          ),
          TextButton(
            onPressed: () => _saveSettings(),
            child: const Text('SAVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: eventAsync.when(
        data: (event) {
          if (!_isInit) {
            _initialEvent = event!;
            _selectedModels = List.from(event.activeModels);
            if (_selectedModels.isEmpty) _selectedModels.add(event.contributionType);
            _selectedPaymentMethods = List.from(event.allowedPaymentMethods);
            _targetGroup = event.contributionTargetGroup ?? 'All Members';
            _expenseApprovalRequired = event.isExpenseApprovalRequired;
            _expenseCategories = List.from(event.expenseCategories);
            _isInit = true;
          }
          return _buildContent(context);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _loadSuggestion() {
    final contribution = EventTemplateService.getSuggestedContribution(_initialEvent.category);
    final expense = EventTemplateService.getSuggestedExpenseSettings(_initialEvent.category);
    
    setState(() {
      _selectedModels = [contribution.type];
      _selectedPaymentMethods = List.from(contribution.paymentMethods);
      _targetGroup = contribution.target;
      _expenseApprovalRequired = expense.approvalRequired;
      _expenseCategories = List.from(expense.categories);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Applied ${_initialEvent.category.displayName} suggestions')),
    );
  }

  void _saveSettings() async {
    final updatedEvent = _initialEvent.copyWith(
      activeModels: _selectedModels,
      allowedPaymentMethods: _selectedPaymentMethods,
      contributionTargetGroup: _targetGroup,
      isHybrid: _selectedModels.length > 1,
      isExpenseApprovalRequired: _expenseApprovalRequired,
      expenseCategories: _expenseCategories,
    );
    
    await ref.read(eventRepositoryProvider).updateEvent(updatedEvent);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Financial settings saved successfully')));
    }
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Financial Collection Strategy', Icons.payments_outlined),
          const SizedBox(height: 16),
          ...ContributionType.values.map((type) => CheckboxListTile(
            title: Text(type.displayName),
            subtitle: Text(type.description, style: const TextStyle(fontSize: 11)),
            value: _selectedModels.contains(type),
            onChanged: (val) {
              setState(() {
                if (val!) {
                  _selectedModels.add(type);
                } else if (_selectedModels.length > 1) {
                  _selectedModels.remove(type);
                }
              });
            },
          )),
          const Divider(height: 48),
          _buildHeader('Expense Tracking Strategy', Icons.receipt_long_outlined),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Require Financial Approval'),
            subtitle: const Text('Expenses must be approved by an authorized organizer'),
            value: _expenseApprovalRequired,
            onChanged: (val) => setState(() => _expenseApprovalRequired = val),
          ),
          const SizedBox(height: 16),
          const Text('Expense Categories:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _expenseCategories.map((c) => Chip(
              label: Text(c, style: const TextStyle(fontSize: 11)),
              onDeleted: () => setState(() => _expenseCategories.remove(c)),
              backgroundColor: Colors.blue[50],
            )).toList(),
          ),
          TextButton.icon(
            onPressed: () => _showAddCategoryDialog(),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add Category', style: TextStyle(fontSize: 12)),
          ),
          const Divider(height: 48),
          _buildHeader('Who Should Contribute?', Icons.people_outline),
          const SizedBox(height: 16),
          _buildChoiceChipGroup(
            ['All Members', 'Only Heads/Units', 'Specific Groups', 'Voluntary Only'],
            _targetGroup,
            (val) => setState(() => _targetGroup = val),
          ),
          const Divider(height: 48),
          _buildHeader('Allowed Payment Methods', Icons.account_balance_outlined),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            children: availablePaymentMethods.map((method) {
              final isSelected = _selectedPaymentMethods.contains(method);
              return FilterChip(
                label: Text(method),
                selected: isSelected,
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      _selectedPaymentMethods.add(method);
                    } else {
                      _selectedPaymentMethods.remove(method);
                    }
                  });
                },
                selectedColor: Theme.of(context).primaryColor.withAlpha(50),
              );
            }).toList(),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  void _showAddCategoryDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Expense Category'),
        content: TextField(controller: controller, decoration: const InputDecoration(hintText: 'e.g., Marketing')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() => _expenseCategories.add(controller.text));
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 20),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildChoiceChipGroup(List<String> options, String current, Function(String) onSelected) {
    return Wrap(
      spacing: 8,
      children: options.map((opt) => ChoiceChip(
        label: Text(opt),
        selected: current == opt,
        onSelected: (_) => onSelected(opt),
      )).toList(),
    );
  }
}
