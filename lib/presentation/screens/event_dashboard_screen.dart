import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:share_plus/share_plus.dart';
import '../../providers/event_provider.dart';
import '../../providers/member_provider.dart';
import '../../providers/payment_provider.dart';
import '../../providers/expense_provider.dart';
import '../../providers/access_control_provider.dart';
import '../widgets/summary_cards.dart';
import '../../data/models/event_model.dart';
import '../../data/models/template_model.dart';
import '../../data/models/payment_model.dart';
import '../../data/models/expense_model.dart';
import '../../data/models/event_role_model.dart';

class EventDashboardScreen extends ConsumerStatefulWidget {
  final String eventId;
  final EventModel? initialEvent;
  const EventDashboardScreen({super.key, required this.eventId, this.initialEvent});

  @override
  ConsumerState<EventDashboardScreen> createState() => _EventDashboardScreenState();
}

class _EventDashboardScreenState extends ConsumerState<EventDashboardScreen> {
  final Stopwatch _firstLoadStopwatch = Stopwatch();
  bool _loggedFirstEvent = false;

  @override
  void initState() {
    super.initState();
    _firstLoadStopwatch.start();
    final current = ref.read(currentEventIdProvider);
    if (current != widget.eventId) {
      ref.read(currentEventIdProvider.notifier).state = widget.eventId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventAsync = ref.watch(eventByIdStreamProvider(widget.eventId));
    final membersAsync = ref.watch(membersForEventStreamProvider(widget.eventId));
    final paymentsAsync = ref.watch(paymentsForEventStreamProvider(widget.eventId));
    final expensesAsync = ref.watch(expensesForEventStreamProvider(widget.eventId));

    final streamEvent = eventAsync.asData?.value;
    final event = streamEvent ?? widget.initialEvent;

    if (!_loggedFirstEvent && streamEvent != null) {
      _loggedFirstEvent = true;
      _firstLoadStopwatch.stop();
      assert(() {
        debugPrint('[EventDashboard] First event snapshot for ${widget.eventId} in ${_firstLoadStopwatch.elapsedMilliseconds}ms');
        return true;
      }());
    }

    if (eventAsync.hasError && event == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading event circle: ${eventAsync.error}'),
              ElevatedButton(
                onPressed: () => ref.refresh(eventByIdStreamProvider(widget.eventId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (event == null) {
      // No cached event available yet; keep the lightweight syncing state.
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Syncing event circle...', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    // If Firestore reports "not found" explicitly, surface that even if we had an initialEvent.
    if (!eventAsync.isLoading && streamEvent == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Event Not Found')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('The event circle could not be found.'),
              TextButton(onPressed: () => context.go('/home'), child: const Text('Return Home')),
            ],
          ),
        ),
      );
    }

    final enabledModules = _getEnabledModules(event);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(event.category.displayName, style: TextStyle(fontSize: 11, color: Theme.of(context).primaryColor)),
              if (eventAsync.isLoading) ...[
                const SizedBox(height: 6),
                const SizedBox(height: 2, child: LinearProgressIndicator(minHeight: 2)),
              ],
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share_outlined, size: 20),
              onPressed: () {
                Share.share('Check out our event collection transparency: https://eventcircle.com/public/${widget.eventId}');
              },
            ),
            IconButton(
              icon: const Icon(Icons.auto_awesome_motion_outlined, size: 20),
              tooltip: 'Save as Blueprint',
              onPressed: () => context.push('/event/${widget.eventId}/save-template'),
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined, size: 20),
              onPressed: () => context.push('/event/${widget.eventId}/finance-settings'),
            ),
          ],
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Logistics'),
              Tab(text: 'Transparency'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(context, event, paymentsAsync, expensesAsync, membersAsync),
            _buildLogisticsTab(context, enabledModules),
            _buildTransparencyTab(context, event, membersAsync, paymentsAsync, expensesAsync),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(
    BuildContext context, 
    EventModel event, 
    AsyncValue<List<dynamic>> payments, 
    AsyncValue<List<dynamic>> expenses,
    AsyncValue<List<dynamic>> members,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuickStats(context, payments, expenses, members),
          const SizedBox(height: 24),
          _buildInfoCard(context, event),
          const SizedBox(height: 24),
          _buildRecentActivityHeader(context),
          _buildRecentActivity(context, payments, members),
        ],
      ),
    );
  }

  Widget _buildLogisticsTab(BuildContext context, List<TemplateModule> enabledModules) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ACTIVE MODULES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.grey.shade600, letterSpacing: 1.2)),
          const SizedBox(height: 20),
          _buildModuleGrid(context, enabledModules),
        ],
      ),
    );
  }

  Widget _buildTransparencyTab(
    BuildContext context, 
    EventModel event, 
    AsyncValue<List<dynamic>> members, 
    AsyncValue<List<dynamic>> payments,
    AsyncValue<List<dynamic>> expenses,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTransparencySection(context, members, payments),
          const SizedBox(height: 24),
          if (event.contributionType == ContributionType.itemBased && event.itemTargets != null) ...[
            _buildItemBasedSection(context, event),
            const SizedBox(height: 24),
          ],
          SummaryCards(
            totalCollected: _calculateTotalCollected(payments),
            totalExpenses: _calculateTotalExpenses(expenses),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(
    BuildContext context, 
    AsyncValue<List<dynamic>> payments, 
    AsyncValue<List<dynamic>> expenses,
    AsyncValue<List<dynamic>> members,
  ) {
    final collected = _calculateTotalCollected(payments);
    final spent = _calculateTotalExpenses(expenses);
    final count = members.value?.length ?? 0;

    return Row(
      children: [
        _buildStatItem(context, 'Collected', '₹${NumberFormat.compact().format(collected)}', Icons.payments_outlined, Colors.green),
        const SizedBox(width: 12),
        _buildStatItem(context, 'Spent', '₹${NumberFormat.compact().format(spent)}', Icons.receipt_long_outlined, Colors.red),
        const SizedBox(width: 12),
        _buildStatItem(context, 'Members', count.toString(), Icons.people_outline, Colors.blue),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withAlpha(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 12),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color.withAlpha(200))),
            Text(label, style: TextStyle(fontSize: 10, color: color.withAlpha(150), fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, dynamic event) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, size: 18, color: Colors.blue),
              const SizedBox(width: 10),
              Text('EVENT DETAILS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.blue.shade800, letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 16),
          Text(event.description, style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5)),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildDetailCapsule(Icons.calendar_today_rounded, event.startDate != null ? DateFormat('MMM dd').format(event.startDate!) : 'TBD'),
              const SizedBox(width: 12),
              _buildDetailCapsule(Icons.location_on_rounded, event.location?.split(',').first ?? 'Remote'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCapsule(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
        ],
      ),
    );
  }

  Widget _buildModuleGrid(BuildContext context, List<TemplateModule> enabledModules) {
    final eventId = widget.eventId;
    final modules = enabledModules.isEmpty ? TemplateModule.values : enabledModules;
    final visibleModules = modules.where((m) => _isModuleVisibleForUser(eventId, m)).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.4,
      ),
      itemCount: visibleModules.length,
      itemBuilder: (context, index) {
        final m = visibleModules[index];
        final launch = _moduleLaunchTarget(eventId, m);
        final isEnabled = launch != null;
        
        return InkWell(
          onTap: isEnabled ? () => context.push(launch) : null,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isEnabled ? Colors.white : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isEnabled ? Colors.grey.shade200 : Colors.grey.shade100),
              boxShadow: isEnabled ? [
                BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 4))
              ] : [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (isEnabled ? Theme.of(context).primaryColor : Colors.grey).withAlpha(15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_getModuleIcon(m), size: 20, color: isEnabled ? Theme.of(context).primaryColor : Colors.grey),
                ),
                Text(
                  _moduleCardTitle(m),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: isEnabled ? Colors.black87 : Colors.grey,
                    letterSpacing: 0.5
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isModuleVisibleForUser(String eventId, TemplateModule module) {
    final key = _eventModuleKey(module);
    if (key == null) return true;
    final access = ref.watch(moduleAccessForEventProvider((eventId: eventId, module: key)));
    return access != ModuleAccessLevel.none;
  }

  String? _eventModuleKey(TemplateModule module) {
    switch (module) {
      case TemplateModule.budget:
      case TemplateModule.expenses:
        return EventModules.budget;
      case TemplateModule.contribution:
        return EventModules.contribution;
      case TemplateModule.task:
        return EventModules.tasks;
      case TemplateModule.userManagement:
        return EventModules.users;
      case TemplateModule.guestManagement:
        return EventModules.guests;
      case TemplateModule.vendor:
        return EventModules.vendors;
      case TemplateModule.roles:
        return EventModules.roles;
      default:
        return null;
    }
  }

  Widget _buildRecentActivityHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('RECENT ACTIVITY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.grey.shade600, letterSpacing: 1)),
          TextButton(onPressed: () {}, child: const Text('View All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic event) {
     return const SizedBox.shrink(); // Replaced by Tab Header
  }

  Widget _buildItemBasedSection(BuildContext context, EventModel event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ITEM TARGETS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.grey.shade600, letterSpacing: 1)),
        const SizedBox(height: 16),
        ...event.itemTargets!.entries.map((entry) {
          final target = (entry.value['target'] as num).toDouble();
          final collected = (entry.value['collected'] as num).toDouble();
          final progress = target > 0 ? collected / target : 0.0;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text('₹$collected / ₹$target', style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                LinearPercentIndicator(
                  lineHeight: 8.0,
                  percent: progress.clamp(0.0, 1.0),
                  backgroundColor: Colors.grey.shade100,
                  progressColor: Colors.orange.shade400,
                  barRadius: const Radius.circular(4),
                  animation: true,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  List<TemplateModule> _getEnabledModules(EventModel event) {
    final snapshot = event.templateSnapshot;
    if (snapshot is! Map<String, dynamic>) return const [];
    final raw = snapshot['enabledModules'];
    if (raw is! List) return const [];

    final modules = <TemplateModule>{};
    for (final v in raw) {
      if (v is! String) continue;
      final m = _templateModuleFromJsonValue(v);
      if (m != null) modules.add(m);
    }
    final order = {for (var i = 0; i < TemplateModule.values.length; i++) TemplateModule.values[i]: i};
    final list = modules.toList()..sort((a, b) => (order[a] ?? 0).compareTo(order[b] ?? 0));
    return list;
  }

  TemplateModule? _templateModuleFromJsonValue(String value) {
    for (final m in TemplateModule.values) {
      if (m.name == value) return m;
    }
    return null;
  }

  String _moduleLabel(TemplateModule module) {
    final base = module.displayName.trim();
    return base.toUpperCase().endsWith('MODULE') ? base : '$base MODULE';
  }

  String _moduleCardTitle(TemplateModule module) {
    if (module == TemplateModule.guestManagement) return 'ATTENDEES';
    return module.displayName.toUpperCase().replaceAll('MANAGEMENT', '').trim();
  }

  IconData _getModuleIcon(TemplateModule module) {
    switch (module) {
      case TemplateModule.task: return Icons.check_circle_outline;
      case TemplateModule.budget: return Icons.account_balance_wallet_outlined;
      case TemplateModule.contribution: return Icons.payments_outlined;
      case TemplateModule.userManagement: return Icons.manage_accounts_outlined;
      case TemplateModule.guestManagement: return Icons.people_outline;
      case TemplateModule.timeline: return Icons.schedule_outlined;
      case TemplateModule.vendor: return Icons.storefront_outlined;
      case TemplateModule.inventory: return Icons.inventory_2_outlined;
      case TemplateModule.communication: return Icons.chat_bubble_outline;
      case TemplateModule.roles: return Icons.badge_outlined;
      case TemplateModule.expenses: return Icons.receipt_long_outlined;
      case TemplateModule.location: return Icons.location_on_outlined;
      case TemplateModule.ticketing: return Icons.confirmation_number_outlined;
      case TemplateModule.customFields: return Icons.edit_note_outlined;
      case TemplateModule.announcements: return Icons.campaign_outlined;
    }
  }

  Widget _buildTransparencySection(
      BuildContext context, AsyncValue<List<dynamic>> members, AsyncValue<List<dynamic>> payments) {
    final totalCollected = _calculateTotalCollected(payments);
    final memberCount = members.value?.length ?? 0;
    final paidCount = payments.value?.length ?? 0;
    final progress = memberCount == 0 ? 0.0 : paidCount / memberCount;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withAlpha(10),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).primaryColor.withAlpha(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('COLLECTION PROGRESS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Theme.of(context).primaryColor, letterSpacing: 1)),
              Text('₹${NumberFormat.compact().format(totalCollected)}',
                  style: TextStyle(fontWeight: FontWeight.w900, color: Theme.of(context).primaryColor, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 20),
          LinearPercentIndicator(
            lineHeight: 12.0,
            percent: progress.clamp(0.0, 1.0),
            backgroundColor: Colors.white,
            progressColor: Theme.of(context).primaryColor,
            barRadius: const Radius.circular(6),
            animation: true,
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$paidCount members paid', style: TextStyle(color: Theme.of(context).primaryColor.withAlpha(180), fontSize: 11, fontWeight: FontWeight.bold)),
              Text('Target $memberCount', style: TextStyle(color: Theme.of(context).primaryColor.withAlpha(180), fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  double _calculateTotalCollected(AsyncValue<List<dynamic>> payments) {
    return payments.maybeWhen(
      data: (list) {
        double sum = 0.0;
        for (final p in list) {
          final status = _paymentStatusValue(p);
          if (status != PaymentStatus.success.name) continue;
          sum += _numValue(_fieldValue(p, 'amount'));
        }
        return sum;
      },
      orElse: () => 0.0,
    );
  }

  double _calculateTotalExpenses(AsyncValue<List<dynamic>> expenses) {
    return expenses.maybeWhen(
      data: (list) {
        double sum = 0.0;
        for (final e in list) {
          sum += _numValue(_fieldValue(e, 'amount'));
        }
        return sum;
      },
      orElse: () => 0.0,
    );
  }

  Object? _fieldValue(dynamic obj, String key) {
    if (obj is Map) return obj[key];
    if (obj is PaymentModel) {
      switch (key) {
        case 'status':
          return obj.status.name;
        case 'amount':
          return obj.amount;
      }
    }
    if (obj is ExpenseModel) {
      switch (key) {
        case 'amount':
          return obj.amount;
      }
    }
    // Best-effort: some screens used dynamic lists; fall back to property access if present.
    try {
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      return (obj as dynamic)[key];
    } catch (_) {
      return null;
    }
  }

  String _paymentStatusValue(dynamic payment) {
    if (payment is PaymentModel) return payment.status.name;
    final raw = _fieldValue(payment, 'status');
    if (raw is PaymentStatus) return raw.name;
    if (raw is String) return raw;
    return '';
  }

  double _numValue(Object? v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }

  String? _moduleLaunchTarget(String eventId, TemplateModule module) {
    switch (module) {
      case TemplateModule.task: return '/event/$eventId/tasks';
      case TemplateModule.budget: return '/event/$eventId/expenses';
      case TemplateModule.contribution: return '/event/$eventId/payments';
      case TemplateModule.userManagement: return '/event/$eventId/users';
      case TemplateModule.guestManagement: return '/event/$eventId/members';
      case TemplateModule.timeline: return '/event/$eventId/timeline';
      case TemplateModule.vendor: return '/event/$eventId/vendors';
      case TemplateModule.inventory: return '/event/$eventId/inventory';
      case TemplateModule.communication: return '/event/$eventId/chat';
      case TemplateModule.roles: return '/event/$eventId/roles';
      case TemplateModule.expenses: return '/event/$eventId/expenses';
      case TemplateModule.location: return '/event/$eventId/venues';
      case TemplateModule.ticketing: return '/event/$eventId/ticketing';
      case TemplateModule.customFields: return '/event/$eventId/custom-fields';
      case TemplateModule.announcements: return '/event/$eventId/announcements';
    }
  }

  Widget _buildRecentActivity(
    BuildContext context,
    AsyncValue<List<dynamic>> paymentsAsync,
    AsyncValue<List<dynamic>> membersAsync,
  ) {
    return paymentsAsync.when(
      data: (payments) {
        if (payments.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: const Center(
              child: Column(
                children: [
                  Icon(Icons.history, color: Colors.grey, size: 32),
                  SizedBox(height: 8),
                  Text('No recent activity yet', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          );
        }

        // Sort by timestamp if available
        final sortedPayments = [...payments];
        sortedPayments.sort((a, b) {
          final tA = _fieldValue(a, 'timestamp') as DateTime?;
          final tB = _fieldValue(b, 'timestamp') as DateTime?;
          if (tA == null || tB == null) return 0;
          return tB.compareTo(tA);
        });

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sortedPayments.length > 5 ? 5 : sortedPayments.length,
          itemBuilder: (context, index) {
            final payment = sortedPayments[index];
            final amount = _numValue(_fieldValue(payment, 'amount'));
            final statusStr = _paymentStatusValue(payment);
            final memberId = _fieldValue(payment, 'memberId') as String?;
            final timestamp = _fieldValue(payment, 'timestamp') as DateTime?;
            
            // Try to find member name
            String memberName = 'Unknown Member';
            if (membersAsync.hasValue) {
               final member = membersAsync.value!.where((m) => m.id == memberId).firstOrNull;
               if (member != null) memberName = member.name;
            }

            final isSuccess = statusStr == PaymentStatus.success.name;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withAlpha(20),
                  child: Icon(
                    isSuccess ? Icons.payments_outlined : Icons.history,
                    size: 20, 
                    color: Theme.of(context).primaryColor
                  ),
                ),
                title: Text(memberName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: Text(
                  '${isSuccess ? "Contributed" : "Attempted"} ₹$amount ${timestamp != null ? "• ${DateFormat('MMM dd, HH:mm').format(timestamp)}" : ""}',
                  style: const TextStyle(fontSize: 11),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (isSuccess ? Colors.green : Colors.orange).withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isSuccess ? 'Success' : 'Pending', 
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isSuccess ? Colors.green : Colors.orange)
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: Padding(
        padding: EdgeInsets.all(20.0),
        child: CircularProgressIndicator(strokeWidth: 2),
      )),
      error: (err, _) => Text('Critical feed error: $err', style: const TextStyle(fontSize: 10, color: Colors.red)),
    );
  }

}
