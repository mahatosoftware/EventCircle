import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:share_plus/share_plus.dart';
import '../../providers/auth_provider.dart';
import '../../providers/event_provider.dart';
import '../widgets/summary_cards.dart';
import '../../providers/dashboard_provider.dart';
import '../../data/models/event_model.dart';
import '../../data/models/template_model.dart';
import '../../data/models/payment_model.dart';
import '../../data/models/event_role_model.dart';
import '../../data/models/event_module.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/template_provider.dart';

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
  bool _isSyncing = false;
  String? _syncStatus;
  bool _hasStartedSync = false;

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
    final user = ref.watch(currentUserProvider);
    final eventAsync = ref.watch(eventByIdStreamProvider(widget.eventId));
    final dashboardAsync = ref.watch(dashboardDataProvider(widget.eventId));

    final event = eventAsync.value ?? widget.initialEvent;
    final dashboard = dashboardAsync.value;

    if (event != null) {
      _checkAndRunLazySync(event);
    }

    if (eventAsync.hasError && event == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading event: ${eventAsync.error}'),
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
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Performance trace logging
    if (!_loggedFirstEvent && dashboard != null) {
      _loggedFirstEvent = true;
      _firstLoadStopwatch.stop();
      debugPrint('[EventDashboard] Loaded in ${_firstLoadStopwatch.elapsedMilliseconds}ms');
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
              if (dashboardAsync.isLoading) ...[
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
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded, size: 20),
              onSelected: (value) {
                switch (value) {
                  case 'edit': context.push('/event/${widget.eventId}/edit'); break;
                  case 'blueprint': context.push('/event/${widget.eventId}/save-template'); break;
                  case 'finance': context.push('/event/${widget.eventId}/finance-settings'); break;
                }
              },
              itemBuilder: (context) => [
                if (user != null && user.id == event.organizerId)
                  const PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit_outlined, size: 20),
                      title: Text('Edit Details', style: TextStyle(fontSize: 14)),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                const PopupMenuItem(
                  value: 'blueprint',
                  child: ListTile(
                    leading: Icon(Icons.auto_awesome_motion_outlined, size: 20),
                    title: Text('Save Blueprint', style: TextStyle(fontSize: 14)),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'finance',
                  child: ListTile(
                    leading: Icon(Icons.settings_outlined, size: 20),
                    title: Text('Finance Settings', style: TextStyle(fontSize: 14)),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
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
        body: Stack(
          children: [
            TabBarView(
              children: [
                _buildOverviewTab(context, event, dashboard),
                _buildLogisticsTab(context, enabledModules, dashboard),
                _buildTransparencyTab(context, event, dashboard),
              ],
            ),
            if (_isSyncing) _buildSyncingOverlay(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncingOverlay(BuildContext context) {
    return Container(
      color: Colors.white.withAlpha(220),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            const Text(
              'Setting up your event...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (_syncStatus != null) ...[
              const SizedBox(height: 8),
              Text(
                _syncStatus!,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
            const SizedBox(height: 12),
            const Text(
              'This happens only on first open',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _checkAndRunLazySync(EventModel event) async {
    if (_hasStartedSync) return;
    _hasStartedSync = true;

    if (event.templateId == null) return;

    try {
       // Check if ALREADY synced by looking for a marker
       final syncMarker = await FirebaseFirestore.instance
           .collection('events')
           .doc(widget.eventId)
           .collection('sync_metadata')
           .doc('status')
           .get();
          
       if (syncMarker.exists) return;

       if (!mounted) return;
       _runLazySync(event);
    } catch (_) {
       // If check fails, we reset so it can try again on next build
       _hasStartedSync = false;
    }
  }

  Future<void> _runLazySync(EventModel event) async {
    if (!mounted) return;
    setState(() {
      _isSyncing = true;
      _syncStatus = 'Fetching template...';
    });

    try {
      final template = await ref.read(templateByIdProvider(event.templateId!).future);
      if (template == null) {
        throw Exception('Template not found');
      }

      await _importTemplateBlueprints(
        db: FirebaseFirestore.instance,
        eventId: widget.eventId,
        template: template,
        event: event,
      );

      // Successfully synced! Save the marker doc.
      await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eventId)
          .collection('sync_metadata')
          .doc('status')
          .set({
            'syncedAt': FieldValue.serverTimestamp(),
            'templateId': event.templateId,
          });

      if (mounted) {
        setState(() {
          _isSyncing = false;
          _syncStatus = null;
        });
      }
    } catch (e) {
      debugPrint('EventDashboardScreen lazy sync failed: $e');
      if (mounted) {
        setState(() {
          _isSyncing = false;
          _syncStatus = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to setup event blueprints: $e')),
        );
      }
    }
  }

  Future<void> _commitBatch(
    WriteBatch batch, {
    required String label,
  }) async {
    debugPrint('EventDashboard: Committing batch ($label)...');
    await batch.commit().timeout(const Duration(seconds: 45));
    debugPrint('EventDashboard: Batch committed ($label).');
  }

  int _blueprintWriteCount(TemplateModel template) {
    return template.taskBlueprints.length +
        template.timelineBlueprints.length +
        template.vendorBlueprints.length +
        template.inventoryBlueprints.length +
        template.roleBlueprints.length +
        template.venueBlueprints.length +
        template.ticketBlueprints.length +
        template.budgetBlueprints.length;
  }

  Future<void> _importTemplateBlueprints({
    required FirebaseFirestore db,
    required String eventId,
    required TemplateModel template,
    required EventModel event,
  }) async {
    final uuid = const Uuid();
    final total = _blueprintWriteCount(template);
    if (total == 0) return;

    setState(() => _syncStatus = 'Preparing modules…');
    
    final actions = <void Function(WriteBatch batch)>[];
    void queueWrite(CollectionReference col, String id, Map<String, dynamic> data) {
      actions.add((batch) => batch.set(col.doc(id), data));
    }

    // Tasks
    for (final task in template.taskBlueprints) {
      final id = uuid.v4();
      queueWrite(db.collection('tasks'), id, task.copyWith(id: id, eventId: eventId).toJson());
    }
    // Timeline
    final baseDate = event.startDate ?? DateTime.now();
    for (final item in template.timelineBlueprints) {
      final id = uuid.v4();
      
      // Attempt to parse startTime from timeOrOffset if missing
      DateTime? startTime = item.startTime;
      if (startTime == null) {
        try {
          var raw = item.timeOrOffset.trim().toUpperCase();
          // Ensure space before AM/PM if missing for common formats
          if (RegExp(r'\d[AP]M$').hasMatch(raw)) {
            raw = raw.replaceFirst(RegExp(r'([AP]M)$'), r' $1');
          }

          DateFormat format;
          if (raw.contains(RegExp(r'[AP]M'))) {
             format = DateFormat('hh:mm a');
          } else {
             format = DateFormat('HH:mm');
          }
          final parsed = format.parse(raw);
          // Apply to the specific day
          final itemDate = baseDate.add(Duration(days: (item.dayNumber - 1).clamp(0, 365)));
          startTime = DateTime(itemDate.year, itemDate.month, itemDate.day, parsed.hour, parsed.minute);
        } catch (_) {}
      }

      queueWrite(db.collection('events').doc(eventId).collection('timeline'), id, item.copyWith(
        id: id, 
        eventId: eventId,
        startTime: startTime,
      ).toJson());
    }
    // Vendors
    for (final vendor in template.vendorBlueprints) {
      final id = uuid.v4();
      queueWrite(db.collection('events').doc(eventId).collection('vendors'), id, vendor.copyWith(id: id, eventId: eventId).toJson());
    }
    // Inventory
    for (final item in template.inventoryBlueprints) {
      final id = uuid.v4();
      queueWrite(db.collection('events').doc(eventId).collection('inventory'), id, item.copyWith(id: id, eventId: eventId).toJson());
    }
    // Roles
    for (final def in template.roleBlueprints) {
      if (def.name.trim().toLowerCase() == 'owner') continue;
      
      final id = uuid.v4();
      final role = EventRoleModel(
        id: id,
        eventId: eventId,
        name: def.name,
        description: def.description,
        moduleAccess: def.moduleAccess,
        userIds: const [],
      );
      queueWrite(db.collection('events').doc(eventId).collection('roles'), id, role.toJson());
    }
    // Venues
    for (final venue in template.venueBlueprints) {
      final id = uuid.v4();
      queueWrite(db.collection('events').doc(eventId).collection('venues'), id, venue.copyWith(id: id, eventId: eventId).toJson());
    }
    // Tickets
    for (final ticket in template.ticketBlueprints) {
      final id = uuid.v4();
      queueWrite(db.collection('events').doc(eventId).collection('tickets'), id, ticket.copyWith(id: id, eventId: eventId).toJson());
    }
    // Budget
    for (final item in template.budgetBlueprints) {
      final id = uuid.v4();
      queueWrite(db.collection('events').doc(eventId).collection('budget'), id, item.copyWith(id: id, eventId: eventId).toJson());
    }

    const chunkSize = 300; 
    final List<Future<void>> commitFutures = [];
    int batchCount = (actions.length / chunkSize).ceil();
    int finishedBatches = 0;

    for (int i = 0; i < actions.length; i += chunkSize) {
      final end = (i + chunkSize < actions.length) ? i + chunkSize : actions.length;
      final chunk = actions.sublist(i, end);
      final batch = db.batch();
      for (final action in chunk) {
        action(batch);
      }
      
      final label = 'Batch ${(i ~/ chunkSize) + 1}/$batchCount';
      commitFutures.add(_commitBatch(batch, label: label).then((_) {
        finishedBatches++;
        if (mounted) setState(() => _syncStatus = 'Setup $finishedBatches/$batchCount…');
      }));
    }

    if (mounted) setState(() => _syncStatus = 'Committing ${commitFutures.length} batches…');
    await Future.wait(commitFutures);
  }

  Widget _buildOverviewTab(
    BuildContext context, 
    EventModel event, 
    DashboardData? dashboard,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuickStats(context, dashboard, event),
          const SizedBox(height: 24),
          _buildInfoCard(context, event),
          const SizedBox(height: 24),
          _buildRecentActivityHeader(context),
          _buildRecentActivity(context, dashboard),
        ],
      ),
    );
  }

  Widget _buildLogisticsTab(BuildContext context, List<TemplateModule> enabledModules, DashboardData? dashboard) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ACTIVE MODULES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.grey.shade600, letterSpacing: 1.2)),
          const SizedBox(height: 20),
          _buildModuleGrid(context, enabledModules, dashboard),
        ],
      ),
    );
  }

  Widget _buildTransparencyTab(
    BuildContext context, 
    EventModel event, 
    DashboardData? dashboard,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTransparencySection(context, dashboard, event),
          const SizedBox(height: 24),
          if (event.contributionType == ContributionType.itemBased && event.itemTargets != null) ...[
            _buildItemBasedSection(context, event),
            const SizedBox(height: 24),
          ],
          SummaryCards(
            totalCollected: dashboard?.totalCollected ?? 0.0,
            totalExpenses: dashboard?.totalExpenses ?? 0.0,
            totalPlannedBudget: dashboard?.totalPlannedBudget,
            currencySymbol: event.currencySymbol,
          ),
          if (dashboard != null && (dashboard.totalPendingReimbursement > 0 || dashboard.totalPaidReimbursement > 0)) ...[
            const SizedBox(height: 16),
            _buildReimbursementLiabilityCard(context, dashboard, event),
          ],
          const SizedBox(height: 24),
          _buildAuditLogsCard(context),
        ],
      ),
    );
  }

  Widget _buildReimbursementLiabilityCard(BuildContext context, DashboardData dashboard, EventModel event) {
    return InkWell(
      onTap: () => context.push('/event/${widget.eventId}/expenses'),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.amber.shade50,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.amber.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.volunteer_activism_outlined, size: 16, color: Colors.amber),
                const SizedBox(width: 8),
                Text('REIMBURSEMENT SUMMARY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.amber.shade900, letterSpacing: 1)),
                const Spacer(),
                const Icon(Icons.chevron_right, size: 16, color: Colors.amber),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${event.currencySymbol}${dashboard.totalPendingReimbursement}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.amber)),
                      const Text('Pending Liability', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.amber.shade200),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${event.currencySymbol}${dashboard.totalPaidReimbursement}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.blue)),
                      const Text('Already Reimbursed', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuditLogsCard(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/event/${widget.eventId}/audit-logs'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.history_edu_outlined, color: Colors.blue, size: 20),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Audit Log', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text('View full history of all changes', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(
    BuildContext context, 
    DashboardData? dashboard,
    EventModel event,
  ) {
    if (dashboard == null) {
       return Row(
         children: [
            _buildStatLoadingItem(context),
            const SizedBox(width: 12),
            _buildStatLoadingItem(context),
            const SizedBox(width: 12),
            _buildStatLoadingItem(context),
         ],
       );
    }
    final collected = dashboard.totalCollected;
    final spent = dashboard.totalExpenses;
    final count = dashboard.members.length;
    final symbol = event.currencySymbol;

    return Row(
      children: [
        _buildStatItem(context, 'Collected', '$symbol${NumberFormat.compact().format(collected)}', Icons.payments_outlined, Colors.green),
        const SizedBox(width: 12),
        _buildStatItem(context, 'Spent', '$symbol${NumberFormat.compact().format(spent)}', Icons.receipt_long_outlined, Colors.red),
        const SizedBox(width: 12),
        _buildStatItem(context, 'Members', count.toString(), Icons.people_outline, Colors.blue),
      ],
    );
  }

  Widget _buildStatLoadingItem(BuildContext context) {
     return Expanded(
       child: Container(
         height: 80,
         padding: const EdgeInsets.all(16),
         decoration: BoxDecoration(
           color: Colors.grey.shade50,
           borderRadius: BorderRadius.circular(16),
           border: Border.all(color: Colors.grey.shade100),
         ),
         child: const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2,))),
       ),
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
    final dateText = () {
      final DateTime? start = event.startDate;
      final DateTime? end = event.endDate;
      if (start == null || end == null) return 'TBD';
      final s = DateFormat('MMM dd').format(start);
      final e = DateFormat('MMM dd').format(end);
      return s == e ? s : '$s - $e';
    }();

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
              _buildDetailCapsule(Icons.calendar_today_rounded, dateText),
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

  Widget _buildModuleGrid(BuildContext context, List<TemplateModule> enabledModules, DashboardData? dashboard) {
    final eventId = widget.eventId;
    final modules = enabledModules.isEmpty ? TemplateModule.values : enabledModules;
    
    // Performance: Filter modules once per build outside of the itemBuilder.
    final visibleModules = modules.where((m) {
      final key = _eventModuleKey(m);
      if (key == null) return true;
      final access = dashboard?.moduleAccess[key] ?? ModuleAccessLevel.none;
      return access != ModuleAccessLevel.none;
    }).toList();

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
          TextButton(
            onPressed: () => context.push('/event/${widget.eventId}/payments'), 
            child: const Text('View All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))
          ),
        ],
      ),
    );
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
                    Text('${event.currencySymbol}$collected / ${event.currencySymbol}$target', style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
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
    bool financeAdded = false;
    
    for (final v in raw) {
      if (v is! String) continue;
      final m = _templateModuleFromJsonValue(v);
      if (m == null) continue;
      
      if (m == TemplateModule.budget || m == TemplateModule.expenses) {
        if (!financeAdded) {
          modules.add(TemplateModule.budget); // Use budget as the representative
          financeAdded = true;
        }
      } else {
        modules.add(m);
      }
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

  String _moduleCardTitle(TemplateModule module) {
    if (module == TemplateModule.budget || module == TemplateModule.expenses) return 'BUDGET & EXPENSE TRACKING';
    if (module == TemplateModule.guestManagement) return 'ATTENDEES';
    return module.displayName.toUpperCase().replaceAll('MANAGEMENT', '').trim();
  }

  IconData _getModuleIcon(TemplateModule module) {
    switch (module) {
      case TemplateModule.task: return Icons.check_circle_outline;
      case TemplateModule.budget:
      case TemplateModule.expenses: return Icons.receipt_long_outlined;
      case TemplateModule.contribution: return Icons.payments_outlined;
      case TemplateModule.userManagement: return Icons.manage_accounts_outlined;
      case TemplateModule.guestManagement: return Icons.people_outline;
      case TemplateModule.timeline: return Icons.schedule_outlined;
      case TemplateModule.vendor: return Icons.storefront_outlined;
      case TemplateModule.inventory: return Icons.inventory_2_outlined;
      case TemplateModule.roles: return Icons.badge_outlined;
      case TemplateModule.location: return Icons.location_on_outlined;
      case TemplateModule.ticketing: return Icons.confirmation_number_outlined;
      case TemplateModule.invitation: return Icons.mail_outline;
    }
  }

  Widget _buildTransparencySection(
      BuildContext context, DashboardData? dashboard, EventModel event) {
    if (dashboard == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: const Center(child: Text('Calculating progress...', style: TextStyle(fontSize: 12, color: Colors.grey))),
      );
    }
    final totalCollected = dashboard.totalCollected;
    final memberCount = dashboard.members.length;
    final paidCount = dashboard.payments.where((p) => p.status == PaymentStatus.success).length;
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
              Text('${event.currencySymbol}${NumberFormat.compact().format(totalCollected)}',
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
      case TemplateModule.ticketing: return '/event/$eventId/ticketing';
      case TemplateModule.roles: return '/event/$eventId/roles';
      case TemplateModule.invitation: return '/event/$eventId/invitation';
      case TemplateModule.expenses: return '/event/$eventId/expenses';
      case TemplateModule.location: return '/event/$eventId/venues';
    }
  }

  Widget _buildRecentActivity(
    BuildContext context,
    DashboardData? dashboard,
  ) {
    if (dashboard == null) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(20.0),
        child: CircularProgressIndicator(strokeWidth: 2),
      ));
    }

    final recentPayments = dashboard.recentActivities;
    if (recentPayments.isEmpty) {
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

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentPayments.length,
      itemBuilder: (context, index) {
        final payment = recentPayments[index];
        final amount = payment.amount;
        final status = payment.status;
        final memberId = payment.memberId;
        final timestamp = payment.timestamp;
        
        // Performance: O(1) lookup in the pre-built memberMap
        final memberName = dashboard.memberMap[memberId]?.name ?? 'Unknown Member';
        final isSuccess = status == PaymentStatus.success;

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
              '${isSuccess ? "Contributed" : "Attempted"} ₹$amount • ${DateFormat('MMM dd, HH:mm').format(timestamp)}',
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
  }

}
