import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../providers/auth_provider.dart';
import '../../providers/template_provider.dart';
import '../../providers/template_search_feedback_provider.dart';
import '../../data/models/event_model.dart';
import '../../data/models/event_role_model.dart';
import '../../data/models/event_user_model.dart';
import '../../data/models/template_model.dart';
import '../../data/models/currency.dart';
import '../../data/constants/system_template_constants.dart';

class CreateEventScreen extends ConsumerStatefulWidget {
  const CreateEventScreen({super.key});

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _locationController = TextEditingController();
  final _noteController = TextEditingController();
  final _searchController = TextEditingController();
  
  DateTime? _startDate;
  DateTime? _endDate;
  EventCategory? _selectedCategory;
  ContributionType _selectedContributionType = ContributionType.fixed;
  TemplateModel? _selectedTemplate;
  bool _isTemplateSelected = false;
  String _searchQuery = '';
  bool _isSubmitting = false;
  String? _submitStatus;
  Currency? _selectedCurrencyItem;
  Timer? _noResultSearchDebounce;
  String? _lastLoggedNoResultQuery;
  List<TemplateModel> _latestTemplates = const [];

  static const int _maxWritesPerBatch = 450; // Firestore limit is 500. Keep headroom.
  static const Duration _batchCommitTimeout = Duration(seconds: 45);

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _locationController.dispose();
    _noteController.dispose();
    _searchController.dispose();
    _noResultSearchDebounce?.cancel();
    super.dispose();
  }

  bool _matchesTemplate(TemplateModel t, String rawQuery) {
    final query = rawQuery.trim().toLowerCase();
    if (query.isEmpty) return true;
    
    final terms = query.split(RegExp(r'\s+')).where((x) => x.isNotEmpty).toList();
    
    final haystack = [
      t.title,
      t.description,
      t.category.displayName,
      if (t.templateCode != null) t.templateCode!,
      ...t.tags,
    ].join(' ').toLowerCase();

    return terms.every((term) => haystack.contains(term));
  }

  bool _isSystemTemplate(TemplateModel t) => t.createdBy == systemTemplateCreatedBy;

  List<TemplateModel> _filterTemplates(List<TemplateModel> templates, String rawQuery) {
    return templates.where((t) => _matchesTemplate(t, rawQuery)).toList();
  }

  void _scheduleNoResultQueryLogIfNeeded({
    required int systemMatchCount,
    required int customMatchCount,
  }) {
    final normalized = _searchQuery.trim().toLowerCase();
    if (normalized.isEmpty) return;
    if (systemMatchCount > 0) return;
    if (_lastLoggedNoResultQuery == normalized) return;

    _noResultSearchDebounce?.cancel();
    _noResultSearchDebounce = Timer(const Duration(milliseconds: 800), () async {
      if (!mounted) return;
      final stableNormalized = _searchQuery.trim().toLowerCase();
      if (stableNormalized.isEmpty) return;
      if (stableNormalized != normalized) return; // User kept typing; skip this run.

      final systemTemplates = _latestTemplates.where(_isSystemTemplate).toList();
      final customTemplates = _latestTemplates.where((t) => !_isSystemTemplate(t)).toList();
      final systemMatches = _filterTemplates(systemTemplates, _searchQuery);
      if (systemMatches.isNotEmpty) return;
      final customMatches = _filterTemplates(customTemplates, _searchQuery);
      if (_lastLoggedNoResultQuery == stableNormalized) return;

      _lastLoggedNoResultQuery = stableNormalized;
      final user = ref.read(currentUserProvider);
      try {
        await ref.read(templateSearchFeedbackRepositoryProvider).logNoMatchQuery(
              query: _searchQuery,
              userId: user?.id,
              publicTemplateCount: _latestTemplates.length,
              systemMatchCount: systemMatches.length,
              customMatchCount: customMatches.length,
            );
      } catch (_) {
        // Best-effort analytics; ignore failures.
      }
    });
  }

  void _applyTemplate(TemplateModel template) {
    setState(() {
      _selectedTemplate = template;
      _isTemplateSelected = true;
      _titleController.text = template.title;
      _descriptionController.text = template.description;
      _selectedCategory = template.category;
      _selectedContributionType = template.contributionType;
      // Pre-fill amount if available in config
      if (template.config != null && template.config!['amount'] != null) {
        _amountController.text = template.config!['amount'].toString();
      }
    });
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );
    if (range != null) {
      setState(() {
        _startDate = range.start;
        _endDate = range.end;
      });
    }
  }

  void _setSubmitStatus(String? status) {
    if (!mounted) return;
    setState(() => _submitStatus = status);
  }

  Map<String, dynamic>? _buildTemplateSnapshot(TemplateModel? template) {
    if (template == null) return null;
    // Keep this intentionally light to avoid hitting Firestore's 1MiB document limit.
    return {
      'id': template.id,
      'title': template.title,
      'version': template.version,
      'templateCode': template.templateCode,
      'enabledModules': template.enabledModules.map((m) => m.name).toList(),
      'createdAt': template.createdAt?.toIso8601String(),
    };
  }

  Future<void> _commitBatch(
    WriteBatch batch, {
    required String label,
  }) async {
    debugPrint('CreateEventScreen: Committing batch ($label)...');
    await batch.commit().timeout(_batchCommitTimeout);
    debugPrint('CreateEventScreen: Batch committed ($label).');
  }

  int _blueprintWriteCount(TemplateModel template) {
    return template.taskBlueprints.length +
        template.timelineBlueprints.length +
        template.vendorBlueprints.length +
        template.inventoryBlueprints.length +
        template.roleBlueprints.length +
        template.venueBlueprints.length +
        template.ticketBlueprints.length +
        template.customFieldBlueprints.length +
        template.announcementBlueprints.length +
        template.budgetBlueprints.length;
  }

  Future<void> _importTemplateBlueprints({
    required FirebaseFirestore db,
    required String eventId,
    required TemplateModel template,
  }) async {
    final uuid = const Uuid();
    final total = _blueprintWriteCount(template);
    if (total == 0) return;

    int done = 0;
    int inBatch = 0;
    WriteBatch batch = db.batch();
    int lastUiDone = -1;
    DateTime lastUiAt = DateTime.fromMillisecondsSinceEpoch(0);

    _setSubmitStatus('Setup 0/$total');

    Future<void> flush(String label) async {
      if (inBatch == 0) return;
      _setSubmitStatus('Setup $done/$total');
      await _commitBatch(batch, label: label);
      batch = db.batch();
      inBatch = 0;
      // Yield to the UI thread between commits so the app doesn't look frozen.
      await Future<void>.delayed(Duration.zero);
    }

    Future<void> addWrite(void Function(WriteBatch b) write) async {
      write(batch);
      done++;
      inBatch++;

      final now = DateTime.now();
      final shouldUpdate =
          done == 1 || done == total || (done - lastUiDone) >= 10 || now.difference(lastUiAt).inMilliseconds >= 250;
      if (shouldUpdate) {
        lastUiDone = done;
        lastUiAt = now;
        _setSubmitStatus('Setup $done/$total');
      }

      // Allow the UI to paint intermediate progress, especially when total is small
      // (otherwise all writes run before the first await/flush).
      if (shouldUpdate) {
        await Future<void>.delayed(Duration.zero);
      }

      if (inBatch >= _maxWritesPerBatch) {
        // Commit boundary handled by callers (loop awaits flush()).
      }
    }

    // Task Blueprints (global tasks collection)
    for (final task in template.taskBlueprints) {
      final taskId = uuid.v4();
      await addWrite((b) => b.set(
            db.collection('tasks').doc(taskId),
            task.copyWith(id: taskId, eventId: eventId).toJson(),
          ));
      if (inBatch >= _maxWritesPerBatch) await flush('tasks');
    }

    // Timeline Blueprints
    for (final item in template.timelineBlueprints) {
      final itemId = uuid.v4();
      await addWrite((b) => b.set(
            db.collection('events').doc(eventId).collection('timeline').doc(itemId),
            item.copyWith(id: itemId, eventId: eventId).toJson(),
          ));
      if (inBatch >= _maxWritesPerBatch) await flush('timeline');
    }

    // Vendor Blueprints
    for (final vendor in template.vendorBlueprints) {
      final vendorId = uuid.v4();
      await addWrite((b) => b.set(
            db.collection('events').doc(eventId).collection('vendors').doc(vendorId),
            vendor.copyWith(id: vendorId, eventId: eventId).toJson(),
          ));
      if (inBatch >= _maxWritesPerBatch) await flush('vendors');
    }

    // Inventory Blueprints
    for (final item in template.inventoryBlueprints) {
      final itemId = uuid.v4();
      await addWrite((b) => b.set(
            db.collection('events').doc(eventId).collection('inventory').doc(itemId),
            item.copyWith(id: itemId, eventId: eventId).toJson(),
          ));
      if (inBatch >= _maxWritesPerBatch) await flush('inventory');
    }

    // Role Blueprints
    for (final def in template.roleBlueprints) {
      final roleId = uuid.v4();
      final role = EventRoleModel(
        id: roleId,
        eventId: eventId,
        name: def.name,
        description: def.description,
        moduleAccess: def.moduleAccess,
        userIds: const [],
      );
      await addWrite((b) => b.set(
            db.collection('events').doc(eventId).collection('roles').doc(roleId),
            role.toJson(),
          ));
      if (inBatch >= _maxWritesPerBatch) await flush('roles');
    }

    // Venue Blueprints
    for (final venue in template.venueBlueprints) {
      final venueId = uuid.v4();
      await addWrite((b) => b.set(
            db.collection('events').doc(eventId).collection('venues').doc(venueId),
            venue.copyWith(id: venueId, eventId: eventId).toJson(),
          ));
      if (inBatch >= _maxWritesPerBatch) await flush('venues');
    }

    // Ticket Blueprints
    for (final ticket in template.ticketBlueprints) {
      final ticketId = uuid.v4();
      await addWrite((b) => b.set(
            db.collection('events').doc(eventId).collection('tickets').doc(ticketId),
            ticket.copyWith(id: ticketId, eventId: eventId).toJson(),
          ));
      if (inBatch >= _maxWritesPerBatch) await flush('tickets');
    }

    // Custom Fields
    for (final field in template.customFieldBlueprints) {
      final fieldId = uuid.v4();
      await addWrite((b) => b.set(
            db.collection('events').doc(eventId).collection('customFields').doc(fieldId),
            field.copyWith(id: fieldId, eventId: eventId).toJson(),
          ));
      if (inBatch >= _maxWritesPerBatch) await flush('customFields');
    }

    // Announcements
    for (final announcement in template.announcementBlueprints) {
      final announcementId = uuid.v4();
      await addWrite((b) => b.set(
            db.collection('events').doc(eventId).collection('announcements').doc(announcementId),
            announcement
                .copyWith(id: announcementId, eventId: eventId, createdAt: DateTime.now())
                .toJson(),
          ));
      if (inBatch >= _maxWritesPerBatch) await flush('announcements');
    }

    // Budget
    for (final item in template.budgetBlueprints) {
      final itemId = uuid.v4();
      await addWrite((b) => b.set(
            db.collection('events').doc(eventId).collection('budget').doc(itemId),
            item.copyWith(id: itemId, eventId: eventId).toJson(),
          ));
      if (inBatch >= _maxWritesPerBatch) await flush('budget');
    }

    await flush('final');
    _setSubmitStatus(null);
  }

  Future<void> _handleSave() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    if (_selectedCurrencyItem == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a currency')),
      );
      return;
    }

    final user = ref.read(currentUserProvider);
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: You must be logged in')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    _setSubmitStatus(_selectedTemplate == null ? 'Creating event…' : 'Creating event & modules…');

    try {
      final newEvent = EventModel(
        id: const Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        organizerId: user.id,
        currency: _selectedCurrencyItem!.code,
        amount: double.tryParse(_amountController.text) ?? 0.0,
        createdAt: DateTime.now(),
        category: _selectedCategory!,
        contributionType: _selectedContributionType,
        location: _locationController.text,
        startDate: _startDate,
        endDate: _endDate,
        note: _noteController.text.isEmpty ? null : _noteController.text,
        templateId: _selectedTemplate?.id,
        templateSnapshot: _buildTemplateSnapshot(_selectedTemplate),
      );

      final db = FirebaseFirestore.instance;
      final uuid = const Uuid();

      // 1) Create Event + required docs (small batch)
      final initBatch = db.batch();
      initBatch.set(db.collection('events').doc(newEvent.id), newEvent.toJson());

      // 2) Create Owner Role
      final ownerRoleId = uuid.v4();
      final ownerRole = EventRoleModel(
        id: ownerRoleId,
        eventId: newEvent.id,
        name: 'Owner',
        description: 'Event owner with full access.',
        moduleAccess: fullAccessForAllModules(),
        userIds: [newEvent.organizerId],
        isSystem: true,
        systemKey: 'owner',
      );
      initBatch.set(
        db.collection('events').doc(newEvent.id).collection('roles').doc(ownerRoleId),
        ownerRole.toJson(),
      );

      // 3) Add User to Event
      final eventUser = EventUserModel(
        id: newEvent.organizerId,
        eventId: newEvent.id,
        status: EventUserStatus.active,
        addedAt: DateTime.now(),
        addedBy: newEvent.organizerId,
      );
      initBatch.set(
        db.collection('events').doc(newEvent.id).collection('users').doc(eventUser.id),
        eventUser.toJson(),
      );

      // Template usage bump should not block event creation if it fails.
      final template = _selectedTemplate;
      if (template != null) {
        initBatch.update(
          db.collection('templates').doc(template.id),
          {'usageCount': FieldValue.increment(1)},
        );
      }

      _setSubmitStatus('Creating event…');
      await _commitBatch(initBatch, label: 'init');

      // 2) Import template blueprints in chunked batches (avoids Firestore batch-size limit + UI freezes).
      if (template != null) {
        await _importTemplateBlueprints(db: db, eventId: newEvent.id, template: template);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Event created successfully')));
        context.go('/home');
      }
    } on TimeoutException catch (e, st) {
      debugPrint('CreateEventScreen event creation timed out: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Network is slow — creation timed out. Please check Home; the event may appear shortly.'),
          ),
        );
      }
    } on FirebaseException catch (e, st) {
      debugPrint('CreateEventScreen event creation failed: ${e.code} ${e.message}\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed (${e.code}): ${e.message ?? 'Unknown error'}')));
      }
    } catch (e, st) {
      debugPrint('CreateEventScreen event creation error: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _submitStatus = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isTemplateSelected) {
      return _buildTemplateSearch();
    }
    return _buildEventForm();
  }

  Widget _buildTemplateSearch() {
    final templatesAsync = ref.watch(publicTemplatesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('New Event')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search templates (e.g. Ganesh Puja)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty 
                  ? IconButton(icon: const Icon(Icons.clear), onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    }) 
                  : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Icon(Icons.local_fire_department, color: Colors.orange, size: 20),
                SizedBox(width: 8),
                Text('Suggested Templates', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: templatesAsync.when(
              data: (templates) {
                _latestTemplates = templates;
                final systemTemplates = templates.where(_isSystemTemplate).toList();
                final customTemplates = templates.where((t) => !_isSystemTemplate(t)).toList();
                final filteredSystem = _filterTemplates(systemTemplates, _searchQuery);
                final filteredCustom = _filterTemplates(customTemplates, _searchQuery);
                final filtered = [...filteredSystem, ...filteredCustom];

                _scheduleNoResultQueryLogIfNeeded(
                  systemMatchCount: filteredSystem.length,
                  customMatchCount: filteredCustom.length,
                );

                if (filtered.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final template = filtered[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: InkWell(
                        onTap: () => _applyTemplate(template),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      template.category.displayName.toUpperCase(),
                                      style: TextStyle(color: Colors.blue.shade800, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _isSystemTemplate(template) ? Colors.green.shade50 : Colors.deepPurple.shade50,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      _isSystemTemplate(template) ? 'SYSTEM' : 'COMMUNITY',
                                      style: TextStyle(
                                        color: _isSystemTemplate(template) ? Colors.green.shade800 : Colors.deepPurple.shade800,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'V${template.version}', 
                                    style: TextStyle(color: Colors.grey.shade400, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.star, size: 14, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text('${template.rating}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(template.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              const SizedBox(height: 4),
                              Text(
                                template.description,
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 16),
                              const Text('LOGISTICS INCLUDED:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  ...template.enabledModules.take(6).map((m) {
                                    return Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(_getModuleIcon(m), size: 16, color: Colors.grey.shade700),
                                    );
                                  }),
                                  if (template.enabledModules.length > 6)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text('+${template.enabledModules.length - 6} more', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  if (template.templateCode != null) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
                                      child: Text('#${template.templateCode}', style: TextStyle(fontSize: 10, color: Colors.grey.shade700, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  Icon(Icons.trending_up, size: 14, color: Colors.green.shade600),
                                  const SizedBox(width: 4),
                                  Text('${template.usageCount} community uses', style: TextStyle(fontSize: 11, color: Colors.green.shade700, fontWeight: FontWeight.w500)),
                                  const Spacer(),
                                  Text('Apply Template', style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold, fontSize: 13)),
                                  const SizedBox(width: 4),
                                  Icon(Icons.arrow_forward, size: 14, color: Colors.blue.shade700),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    final title = _searchController.text.trim();
                    final qp = title.isEmpty ? '' : '?title=${Uri.encodeComponent(title)}';
                    context.push('/create-template$qp');
                  },
                  icon: const Icon(Icons.auto_awesome_outlined),
                  label: const Text('Design New Blueprint'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => setState(() {
                    _selectedTemplate = null;
                    _isTemplateSelected = true;
                  }),
                  icon: const Icon(Icons.add),
                  label: const Text('Create Custom Event (No Blueprint)'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text("Didn't find what you need?", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Design a new blueprint to get started'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              final title = _searchController.text.trim();
              final qp = title.isEmpty ? '' : '?title=${Uri.encodeComponent(title)}';
              context.push('/create-template$qp');
            },
            child: const Text('Design New Blueprint'),
          ),
        ],
      ),
    );
  }

  Widget _buildEventForm() {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedTemplate == null ? 'New Blueprint' : 'Finalize Event'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() {
            _isTemplateSelected = false;
            _selectedTemplate = null;
          }),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_selectedTemplate != null) ...[
                _buildBlueprintHero(),
                const SizedBox(height: 24),
              ],
              TextFormField(
                controller: _titleController,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  labelText: 'Event Title',
                  prefixIcon: Icon(Icons.event),
                  hintText: 'e.g. Community Sports Day 2024',
                ),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 420;

                  final categoryField = DropdownButtonFormField<EventCategory>(
                    isExpanded: true,
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    items: EventCategory.values.map((EventCategory category) {
                      return DropdownMenuItem<EventCategory>(
                        value: category,
                        child: Text(
                          category.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedCategory = value),
                    validator: (v) => v == null ? 'Required' : null,
                  );

                  final contributionField = DropdownButtonFormField<ContributionType>(
                    isExpanded: true,
                    value: _selectedContributionType,
                    decoration: const InputDecoration(
                      labelText: 'Contribution',
                      prefixIcon: Icon(Icons.payments_outlined),
                    ),
                    items: ContributionType.values.map((ContributionType type) {
                      return DropdownMenuItem<ContributionType>(
                        value: type,
                        child: Text(
                          type.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _selectedContributionType = value);
                    },
                  );

                  if (isNarrow) {
                    return Column(
                      children: [
                        categoryField,
                        const SizedBox(height: 16),
                        contributionField,
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(child: categoryField),
                      const SizedBox(width: 16),
                      Expanded(child: contributionField),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                maxLines: 2,
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location / Venue',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Currency>(
                isExpanded: true,
                value: _selectedCurrencyItem,
                decoration: const InputDecoration(
                  labelText: 'Currency',
                  prefixIcon: Icon(Icons.currency_exchange_outlined),
                ),
                items: storeCurrencies.map((Currency c) {
                  return DropdownMenuItem<Currency>(
                    value: c,
                    child: Text(
                      '${c.code} (${c.symbol}) - ${c.name}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCurrencyItem = value),
                validator: (v) => v == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                   Expanded(
                    child: TextFormField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: 'Target / Amount',
                        prefixIcon: Icon(_selectedCurrencyItem != null 
                             ? Icons.payments_outlined
                             : Icons.currency_rupee),
                        prefixText: _selectedCurrencyItem?.symbol != null ? '${_selectedCurrencyItem!.symbol} ' : null,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: _pickDateRange,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Event Period',
                          prefixIcon: Icon(Icons.date_range_outlined),
                        ),
                        child: Text(
                          _startDate == null 
                            ? 'Select Dates' 
                            : '${DateFormat('MMM dd').format(_startDate!)} - ${DateFormat('MMM dd').format(_endDate!)}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_selectedTemplate != null) ...[
                const SizedBox(height: 32),
                const Text('Modules & Blueprints Included', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                _buildModulesGrid(),
              ],
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                ),
                child: _isSubmitting
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              _submitStatus ?? 'Working…',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      )
                    : Text(_selectedTemplate == null ? 'Create Custom Event' : 'Create Event',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlueprintHero() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'PREMIUM BLUEPRINT',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    fontSize: 12,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                child: const Icon(Icons.star, color: Colors.amber, size: 16),
              ),
              const SizedBox(width: 4),
              Text(
                '${_selectedTemplate!.rating}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _selectedTemplate!.title,
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            _selectedTemplate!.description,
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildModulesGrid() {
    final rawModules = _selectedTemplate!.enabledModules;
    final modules = <TemplateModule>[];
    bool financeAdded = false;
    
    for (final m in rawModules) {
      if (m == TemplateModule.budget || m == TemplateModule.expenses) {
        if (!financeAdded) {
          modules.add(TemplateModule.budget);
          financeAdded = true;
        }
      } else {
        modules.add(m);
      }
    }
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 76,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: modules.length,
      itemBuilder: (context, index) {
        final module = modules[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Icon(_getModuleIcon(module), size: 20, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      module.displayName,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _getModuleSummary(module),
                      style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
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
      case TemplateModule.communication: return Icons.chat_bubble_outline;
      case TemplateModule.roles: return Icons.badge_outlined;
      case TemplateModule.location: return Icons.location_on_outlined;
      case TemplateModule.ticketing: return Icons.confirmation_number_outlined;
      case TemplateModule.customFields: return Icons.edit_note_outlined;
      case TemplateModule.announcements: return Icons.campaign_outlined;
    }
  }

  String _getModuleSummary(TemplateModule module) {
    switch (module) {
      case TemplateModule.task: return '${_selectedTemplate!.taskBlueprints.length} tasks pre-filled';
      case TemplateModule.budget:
      case TemplateModule.expenses: return 'Budget items & Expense workflow';
      case TemplateModule.contribution: return 'Auto-configured targets';
      case TemplateModule.userManagement: return 'Team members can be added';
      case TemplateModule.guestManagement: return 'RSVP & Categories active';
      case TemplateModule.timeline: return '${_selectedTemplate!.timelineBlueprints.length} phases';
      case TemplateModule.vendor: return '${_selectedTemplate!.vendorBlueprints.length} vendor roles';
      case TemplateModule.inventory: return '${_selectedTemplate!.inventoryBlueprints.length} items';
      case TemplateModule.communication: return 'Group messaging enabled';
      case TemplateModule.roles: return 'Team hierarchy set';
      case TemplateModule.location: return 'Venue ground blueprints';
      case TemplateModule.ticketing: return 'Standard ticket tiers';
      case TemplateModule.customFields: return 'Metadata fields active';
      case TemplateModule.announcements: return 'Welcome alerts ready';
    }
  }
}
