import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../providers/payment_provider.dart';
import '../../providers/member_provider.dart';
import '../../providers/event_provider.dart';
import '../../providers/access_control_provider.dart';
import '../../data/models/payment_model.dart';
import '../../data/models/event_model.dart';
import '../../data/models/member_model.dart';
import '../../data/models/event_role_model.dart';

class PaymentsScreen extends ConsumerWidget {
  final String eventId;
  const PaymentsScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventByIdStreamProvider(eventId));
    final paymentsAsync = ref.watch(paymentsForEventStreamProvider(eventId));
    final membersAsync = ref.watch(membersForEventStreamProvider(eventId));
    final canAddContribution = ref.watch(
      hasModuleAccessProvider((eventId: eventId, module: EventModules.contribution, required: ModuleAccessLevel.update)),
    );
    final canAddAttendee = ref.watch(
      hasModuleAccessProvider((eventId: eventId, module: EventModules.guests, required: ModuleAccessLevel.edit)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Collection'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'View Audit Logs',
            onPressed: () => context.push('/event/$eventId/audit-logs'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(eventByIdStreamProvider(eventId));
              ref.invalidate(paymentsForEventStreamProvider(eventId));
              ref.invalidate(membersForEventStreamProvider(eventId));
            },
          ),
        ],
      ),
      body: eventAsync.when(
        data: (event) {
          if (event == null) return const Center(child: Text('Event not found'));
          
          return membersAsync.when(
            data: (members) {
              if (members.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline, size: 80, color: Colors.grey.withAlpha(128)),
                      const SizedBox(height: 16),
                      const Text('No members added yet', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text('Add members in the Attendee Management screen', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  final payments = paymentsAsync.value ?? [];

                  // payments are sorted by timestamp desc from the repository.
                  PaymentModel? latestPayment;
                  for (final p in payments) {
                    if (p.memberId == member.id) {
                      latestPayment = p;
                      break;
                    }
                  }

                  return _buildPaymentTile(
                    context,
                    event,
                    member,
                    latestPayment,
                    ref,
                    canAddContribution: canAddContribution,
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error loading members: $err')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading event: $err')),
      ),
      floatingActionButton: canAddContribution
          ? membersAsync.maybeWhen(
              data: (members) => eventAsync.maybeWhen(
                data: (event) => event == null
                    ? null
                    : FloatingActionButton.extended(
                        onPressed: () => _showContributionEntryOptions(
                          context,
                          event,
                          members,
                          ref,
                          canAddAttendee: canAddAttendee,
                        ),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Payment'),
                      ),
                orElse: () => null,
              ),
              orElse: () => null,
            )
          : null,
    );
  }

  void _showContributionEntryOptions(
    BuildContext context,
    EventModel event,
    List<MemberModel> members,
    WidgetRef ref, {
    required bool canAddAttendee,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(color: Colors.black.withAlpha(30), borderRadius: BorderRadius.circular(99)),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Add payment',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.person_search_outlined),
                title: const Text('Record payment for existing attendees'),
                subtitle: Text(members.isEmpty ? 'No attendees yet' : 'Select an attendee and record payment'),
                enabled: members.isNotEmpty,
                onTap: members.isEmpty
                    ? null
                    : () {
                        Navigator.pop(context);
                        _showAddContribution(context, event, members, ref);
                      },
              ),
              ListTile(
                leading: const Icon(Icons.person_add_alt_1_outlined),
                title: const Text('Add attendee and record payment'),
                subtitle: Text(
                  canAddAttendee ? 'Create an attendee then record payment' : 'You don’t have permission to add attendees',
                ),
                enabled: canAddAttendee,
                onTap: !canAddAttendee
                    ? null
                    : () {
                        Navigator.pop(context);
                        _showAddAttendeeAndRecordPayment(context, event, ref);
                      },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddAttendeeAndRecordPayment(BuildContext context, EventModel event, WidgetRef ref) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final identifierController = TextEditingController();

    final amountController = TextEditingController();
    final refController = TextEditingController();

    final uuid = const Uuid();

    final List<String> methods = ['Cash', 'UPI', 'Cheque', 'NEFT', 'RTGS', 'EFT'];
    if (event.allowedPaymentMethods.isNotEmpty) {
      for (final m in event.allowedPaymentMethods) {
        if (!methods.contains(m)) methods.insert(0, m);
      }
    }

    String selectedMethod = event.allowedPaymentMethods.isNotEmpty ? event.allowedPaymentMethods.first : 'Cash';
    DateTime receivedDate = DateTime.now();
    String? selectedCategory;
    if (event.guestCategories.isNotEmpty) selectedCategory = event.guestCategories.first;

    final double initialAmount = switch (event.contributionType) {
      ContributionType.voluntary => 0.0,
      _ => event.amount,
    };
    amountController.text = initialAmount > 0 ? initialAmount.toString() : '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final bool needsRef = ['Cheque', 'NEFT', 'RTGS', 'EFT', 'UPI'].contains(selectedMethod);
          return Padding(
            padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Add attendee & record payment',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Attendee name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Phone (optional)',
                            prefixIcon: Icon(Icons.phone_outlined),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: identifierController,
                          decoration: const InputDecoration(
                            labelText: 'Identifier (optional)',
                            prefixIcon: Icon(Icons.badge_outlined),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (event.guestCategories.isNotEmpty)
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category (optional)',
                        prefixIcon: Icon(Icons.category_outlined),
                      ),
                      items: event.guestCategories
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) => setState(() => selectedCategory = v),
                    ),
                  if (event.guestCategories.isNotEmpty) const SizedBox(height: 12),
                  const Divider(height: 28),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount (₹)',
                      prefixIcon: const Icon(Icons.currency_rupee),
                      hintText: event.contributionType == ContributionType.voluntary ? 'Enter any amount' : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedMethod,
                    decoration: const InputDecoration(labelText: 'Payment method'),
                    items: methods.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                    onChanged: (m) => setState(() => selectedMethod = m ?? selectedMethod),
                  ),
                  const SizedBox(height: 12),
                  if (needsRef)
                    TextField(
                      controller: refController,
                      decoration: InputDecoration(
                        labelText: selectedMethod == 'Cheque' ? 'Cheque / Ref Number' : 'Transaction / Reference Number',
                        prefixIcon: const Icon(Icons.confirmation_number_outlined),
                      ),
                    ),
                  if (needsRef) const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Received date'),
                    subtitle: Text(DateFormat('MMM dd, yyyy').format(receivedDate)),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: receivedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) setState(() => receivedDate = picked);
                    },
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () async {
                      final name = nameController.text.trim();
                      if (name.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter attendee name')));
                        return;
                      }
                      final amount = double.tryParse(amountController.text);
                      if (amount == null || amount <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid amount')));
                        return;
                      }
                      if (needsRef && refController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reference number is required for this method')));
                        return;
                      }

                      final member = MemberModel(
                        id: uuid.v4(),
                        eventId: event.id,
                        name: name,
                        phone: phoneController.text.trim(),
                        identifier: identifierController.text.trim(),
                        status: MemberStatus.invited,
                        joinedAt: DateTime.now(),
                        guestCategory: selectedCategory,
                      );

                      try {
                        await ref.read(memberRepositoryProvider).addMember(member);

                        final payment = PaymentModel(
                          id: uuid.v4(),
                          memberId: member.id,
                          eventId: event.id,
                          status: PaymentStatus.success,
                          amount: amount,
                          timestamp: receivedDate,
                          paymentMethod: selectedMethod,
                          referenceNumber: refController.text.trim().isNotEmpty ? refController.text.trim() : null,
                          metadata: const {'recordedBy': 'manual'},
                        );
                        await ref.read(paymentRepositoryProvider).initiatePayment(payment);

                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Attendee added and payment recorded')));
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
                        }
                      }
                    },
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Save'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentTile(
    BuildContext context,
    EventModel event,
    MemberModel member,
    PaymentModel? payment,
    WidgetRef ref, {
    required bool canAddContribution,
  }) {
    final bool isPaid = payment?.status == PaymentStatus.success;
    double expectedAmount = event.amount;

    if (event.contributionType == ContributionType.variable) {
      expectedAmount = member.assignedAmount ?? event.amount;
    } else if (event.contributionType == ContributionType.tierBased && member.selectedTier != null) {
      expectedAmount = event.tiers?[member.selectedTier] ?? event.amount;
    } else if (event.contributionType == ContributionType.voluntary) {
      expectedAmount = 0; // No obligation
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(child: Text(member.name[0])),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(member.name, style: Theme.of(context).textTheme.titleSmall),
                  Text(
                    '${event.contributionType == ContributionType.voluntary ? "Any amount" : "₹$expectedAmount"} • ${member.identifier}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            if (isPaid) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₹${payment!.amount}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const Text('PAID', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 9)),
                  Text(_paymentMethodLabel(payment), style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
              const SizedBox(width: 8),
              if (canAddContribution)
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.blue),
                  onPressed: () => _showEditPayment(context, event, member, payment!, ref),
                ),
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
            ] else ...[
              ElevatedButton(
                onPressed: !canAddContribution ? null : () => _showPaymentOptions(context, event, member, ref),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: Size.zero,
                  backgroundColor: Theme.of(context).primaryColor.withAlpha(25),
                  foregroundColor: Theme.of(context).primaryColor,
                  elevation: 0,
                ),
                child: const Text('Collect', style: TextStyle(fontSize: 12)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showPaymentOptions(BuildContext context, EventModel event, MemberModel member, WidgetRef ref) {
    final amountController = TextEditingController();
    double expectedAmount = event.amount;

    if (event.contributionType == ContributionType.variable) {
      expectedAmount = member.assignedAmount ?? event.amount;
    } else if (event.contributionType == ContributionType.tierBased && member.selectedTier != null) {
      expectedAmount = event.tiers?[member.selectedTier] ?? event.amount;
    }
    amountController.text = expectedAmount > 0 ? expectedAmount.toString() : "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Collect Payment from ${member.name}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (event.contributionType == ContributionType.voluntary || event.contributionType == ContributionType.variable)
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount (₹)',
                  prefixIcon: const Icon(Icons.currency_rupee),
                  hintText: event.contributionType == ContributionType.voluntary ? "Enter donation amount" : "Assigned: ₹$expectedAmount",
                ),
              ),
            if (event.contributionType == ContributionType.tierBased)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'Tier: ${member.selectedTier ?? "None selected"} - ₹$expectedAmount',
                  style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.blue),
                ),
              ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.money, color: Colors.green),
              title: const Text('Mark as Paid (Cash/Manual)'),
              subtitle: const Text('Use only for cash collection'),
              onTap: () async {
                final double? collectedAmount = double.tryParse(amountController.text);
                if (collectedAmount == null || collectedAmount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid amount')));
                  return;
                }
                final payment = PaymentModel(
                  id: const Uuid().v4(),
                  memberId: member.id,
                  eventId: event.id,
                  status: PaymentStatus.success,
                  amount: collectedAmount,
                  timestamp: DateTime.now(),
                  metadata: {
                    'method': 'cash',
                    'recordedBy': 'manual',
                  },
                );
                await ref.read(paymentRepositoryProvider).initiatePayment(payment);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Recorded ₹$collectedAmount from ${member.name}')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.qr_code, color: Colors.purple),
              title: const Text('Generate UPI QR'),
              subtitle: const Text('For instant mobile payment'),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.account_balance_outlined, color: Colors.blue),
              title: const Text('Bank Transfer (NEFT/RTGS/EFT)'),
              subtitle: const Text('Record bank transactions'),
              onTap: () {
                Navigator.pop(context);
                _showAddContribution(context, event, [member], ref, initialMethod: 'NEFT');
              },
            ),
            ListTile(
              leading: const Icon(Icons.description_outlined, color: Colors.orange),
              title: const Text('Cheque Payment'),
              subtitle: const Text('Record cheque details'),
              onTap: () {
                Navigator.pop(context);
                _showAddContribution(context, event, [member], ref, initialMethod: 'Cheque');
              },
            ),
          ],
        ),
      ),
    );
  }

  String _paymentMethodLabel(PaymentModel? payment) {
    final method = payment?.paymentMethod ?? payment?.metadata?['method']?.toString();
    if (method == null || method.isEmpty) return '—';
    
    String label = 'via $method';
    final refNum = payment?.referenceNumber;
    if (refNum != null && refNum.isNotEmpty) {
      label += ' (#$refNum)';
    }
    return label;
  }

  void _showAddContribution(BuildContext context, EventModel event, List<MemberModel> members, WidgetRef ref, {String? initialMethod}) {
    MemberModel selectedMember = members.first;
    final amountController = TextEditingController(text: event.amount > 0 ? event.amount.toString() : '');
    final refController = TextEditingController();
    
    final List<String> methods = ['Cash', 'UPI', 'Cheque', 'NEFT', 'RTGS', 'EFT'];
    if (event.allowedPaymentMethods.isNotEmpty) {
       for (var m in event.allowedPaymentMethods) {
         if (!methods.contains(m)) methods.insert(0, m);
       }
    }

    String selectedMethod = initialMethod ?? (event.allowedPaymentMethods.isNotEmpty ? event.allowedPaymentMethods.first : 'Cash');
    PaymentStatus selectedStatus = PaymentStatus.success;
    DateTime receivedDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final bool needsRef = ['Cheque', 'NEFT', 'RTGS', 'EFT', 'UPI'].contains(selectedMethod);
          
          return Padding(
            padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                Text('Add Contribution', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                if (members.length > 1) 
                  DropdownButtonFormField<MemberModel>(
                    value: selectedMember,
                    decoration: const InputDecoration(labelText: 'Select user'),
                    items: members
                        .map((m) => DropdownMenuItem(
                              value: m,
                              child: Text('${m.name} • ${m.identifier}'),
                            ))
                        .toList(),
                    onChanged: (m) => setState(() => selectedMember = m ?? members.first),
                  )
                else 
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text('Recording for: ${selectedMember.name}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                  ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount (₹)',
                    prefixIcon: Icon(Icons.currency_rupee),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedMethod,
                  decoration: const InputDecoration(labelText: 'Payment method'),
                  items: methods
                      .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                      .toList(),
                  onChanged: (m) => setState(() => selectedMethod = m ?? selectedMethod),
                ),
                const SizedBox(height: 12),
                if (needsRef)
                  TextField(
                    controller: refController,
                    decoration: InputDecoration(
                      labelText: selectedMethod == 'Cheque' ? 'Cheque / Ref Number' : 'Transaction / Reference Number',
                      hintText: 'Enter reference number',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                const SizedBox(height: 12),
                DropdownButtonFormField<PaymentStatus>(
                  value: selectedStatus,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: const [
                    DropdownMenuItem(value: PaymentStatus.success, child: Text('Success')),
                    DropdownMenuItem(value: PaymentStatus.pending, child: Text('Pending')),
                    DropdownMenuItem(value: PaymentStatus.failed, child: Text('Failed')),
                  ],
                  onChanged: (s) => setState(() => selectedStatus = s ?? PaymentStatus.success),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Received Date'),
                  subtitle: Text(DateFormat('MMM dd, yyyy').format(receivedDate)),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: receivedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) {
                      setState(() => receivedDate = picked);
                    }
                  },
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () async {
                    final amount = double.tryParse(amountController.text);
                    if (amount == null || amount <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid amount')));
                      return;
                    }
                    if (needsRef && refController.text.isEmpty) {
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reference number is required for this method')));
                       return;
                    }

                    final payment = PaymentModel(
                      id: const Uuid().v4(),
                      memberId: selectedMember.id,
                      eventId: event.id,
                      status: selectedStatus,
                      amount: amount,
                      timestamp: receivedDate,
                      paymentMethod: selectedMethod,
                      referenceNumber: refController.text.isNotEmpty ? refController.text : null,
                      metadata: {
                        'recordedBy': 'manual',
                      },
                    );
                    await ref.read(paymentRepositoryProvider).initiatePayment(payment);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contribution recorded')));
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showEditPayment(BuildContext context, EventModel event, MemberModel member, PaymentModel payment, WidgetRef ref) {
    final amountController = TextEditingController(text: payment.amount.toString());
    final refController = TextEditingController(text: payment.referenceNumber ?? '');
    String selectedMethod = payment.paymentMethod ?? 'Cash';
    final List<String> methods = ['Cash', 'UPI', 'Cheque', 'NEFT', 'RTGS', 'EFT'];
    DateTime receivedDate = payment.timestamp;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final bool needsRef = ['Cheque', 'NEFT', 'RTGS', 'EFT', 'UPI'].contains(selectedMethod);
          return Padding(
            padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                Text('Edit Contribution for ${member.name}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Amount (₹)', prefixIcon: Icon(Icons.currency_rupee)),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedMethod,
                  decoration: const InputDecoration(labelText: 'Payment method'),
                  items: methods.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                  onChanged: (m) => setState(() => selectedMethod = m ?? selectedMethod),
                ),
                const SizedBox(height: 12),
                if (needsRef)
                  TextField(
                    controller: refController,
                    decoration: const InputDecoration(labelText: 'Reference Number', border: OutlineInputBorder()),
                  ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Received Date'),
                  subtitle: Text(DateFormat('MMM dd, yyyy').format(receivedDate)),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: receivedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) {
                      setState(() => receivedDate = picked);
                    }
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => _confirmDeletePayment(context, event.id, payment.id, ref),
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('Delete'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: FilledButton(
                        onPressed: () async {
                          final amount = double.tryParse(amountController.text);
                          if (amount == null || amount <= 0) return;
                          
                          final updated = payment.copyWith(
                            amount: amount,
                            timestamp: receivedDate,
                            paymentMethod: selectedMethod,
                            referenceNumber: refController.text.isNotEmpty ? refController.text : null,
                          );
                          await ref.read(paymentRepositoryProvider).updatePayment(updated);
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: const Text('Update'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmDeletePayment(BuildContext context, String eventId, String paymentId, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Record?'),
        content: const Text('This will permanently remove this contribution from the event circle. This action is audited.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await ref.read(paymentRepositoryProvider).deletePayment(eventId, paymentId);
              if (context.mounted) {
                Navigator.pop(context); // Dialog
                Navigator.pop(context); // Bottom sheet
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
