import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../data/models/template_model.dart';
import '../../data/models/event_model.dart';
import '../../data/models/event_role_model.dart';
import '../../data/models/role_definition_model.dart';
import '../../providers/template_provider.dart';
import '../../data/services/event_template_service.dart';
import '../../providers/auth_provider.dart';

class CreateTemplateScreen extends ConsumerStatefulWidget {
  final String? fromEventId;
  final String? initialTitle;
  final String? initialDescription;

  const CreateTemplateScreen({
    super.key,
    this.fromEventId,
    this.initialTitle,
    this.initialDescription,
  });

  @override
  ConsumerState<CreateTemplateScreen> createState() => _CreateTemplateScreenState();
}

class _CreateTemplateScreenState extends ConsumerState<CreateTemplateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _keywordsController = TextEditingController();
  
  EventCategory _category = EventCategory.socialAndPersonal;
  
  // Module selection state
  final Map<TemplateModule, bool> _selectedModules = {
    for (var m in TemplateModule.values) m: true,
  };

  final List<RoleDefinitionModel> _roleDefinitions = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialTitle != null && _titleController.text.isEmpty) {
      _titleController.text = widget.initialTitle!;
    }
    if (widget.initialDescription != null && _descriptionController.text.isEmpty) {
      _descriptionController.text = widget.initialDescription!;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _keywordsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fromEventId == null ? 'Design New Blueprint' : 'Save as Blueprint'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('BLUEPRINT IDENTITY', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.1)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  labelText: 'Blueprint Title',
                  prefixIcon: Icon(Icons.auto_awesome_outlined),
                  hintText: 'e.g. Annual Sports Meet 2024',
                ),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'General Description',
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                maxLines: 2,
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _keywordsController,
                decoration: const InputDecoration(
                  labelText: 'Search Keywords (Optional)',
                  prefixIcon: Icon(Icons.tag_outlined),
                  hintText: 'e.g. puja, festival, ganesh, visarjan',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<EventCategory>(
                value: _category,
                items: EventCategory.values.map((c) => DropdownMenuItem(value: c, child: Text(c.displayName))).toList(),
                onChanged: (val) => setState(() => _category = val!),
                decoration: const InputDecoration(
                  labelText: 'Primary Event Category',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
              ),
              const SizedBox(height: 40),
              const Text('LOGISTICAL MODULES', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.1)),
              const SizedBox(height: 8),
              const Text('Choose which management modules to pre-configure for this blueprint.', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: TemplateModule.values.where((m) => m != TemplateModule.expenses).map((module) {
                    final isLast = module == TemplateModule.ticketing; // Ticketing is usually near the end, but let's be safe.
                    // Actually, let's just find the last visible one.
                    final visible = TemplateModule.values.where((m) => m != TemplateModule.expenses).toList();
                    final isReallyLast = module == visible.last;
                    
                    return Column(
                      children: [
                        CheckboxListTile(
                          title: Text(module.displayName, style: const TextStyle(fontWeight: FontWeight.w600)),
                          secondary: Icon(_getModuleIcon(module), color: _selectedModules[module]! ? Colors.blue.shade700 : Colors.grey),
                          value: _selectedModules[module],
                          onChanged: (val) => setState(() {
                            _selectedModules[module] = val!;
                            if (module == TemplateModule.budget) {
                              _selectedModules[TemplateModule.expenses] = val;
                            }
                          }),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          controlAffinity: ListTileControlAffinity.trailing,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        if (!isReallyLast) Divider(height: 1, indent: 64, color: Colors.grey.shade200),
                      ],
                    );
                  }).toList(),
                ),
              ),
              if (_selectedModules[TemplateModule.roles] == true) ...[
                const SizedBox(height: 40),
                const Text('ROLE DEFINITIONS', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.1)),
                const SizedBox(height: 8),
                const Text('Define custom roles and module-level access for this blueprint.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text('Roles (${_roleDefinitions.length})', style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    FilledButton.icon(
                      onPressed: () => _openRoleEditor(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Role'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Card(
                  child: ExpansionTile(
                    leading: const Icon(Icons.verified_user_outlined, color: Colors.blue),
                    title: const Text('Owner (System)', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      'Full access to all logistical modules.',
                      style: TextStyle(color: Colors.blue.shade700, fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'The Owner role is the primary organizer and holds absolute management rights over all modules. This role is automatically assigned to the creator of the event circle.',
                              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
                            ),
                            const SizedBox(height: 12),
                            const Text('ENABLED PERMISSIONS:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _enabledRoleModules().map((m) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.blue.shade100),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(_moduleLabel(m), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue.shade800)),
                                      const SizedBox(width: 4),
                                      const Text('· FULL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.green)),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (_roleDefinitions.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const Text(
                      'No roles yet. Add roles like “Finance Manager”, “Volunteer”, or “Guest Coordinator”.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else
                  ..._roleDefinitions.map(
                    (r) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.badge_outlined),
                        title: Text(r.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (r.description.isNotEmpty) ...[
                              Text(r.description, style: const TextStyle(fontSize: 12)),
                              const SizedBox(height: 4),
                            ],
                            Text(
                              _roleAccessSummary(r),
                              style: TextStyle(color: Colors.blue.shade700, fontSize: 11, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                        trailing: PopupMenuButton<String>(
                          onSelected: (v) {
                            switch (v) {
                              case 'edit':
                                _openRoleEditor(context, existing: r);
                                return;
                              case 'delete':
                                setState(() => _roleDefinitions.removeWhere((x) => x.id == r.id));
                                return;
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(value: 'edit', child: Text('Edit')),
                            PopupMenuItem(value: 'delete', child: Text('Delete')),
                          ],
                        ),
                        onTap: () => _openRoleEditor(context, existing: r),
                      ),
                    ),
                  ),
              ],
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                ),
                child: const Text('Publish Blueprint', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
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
      case TemplateModule.roles: return Icons.badge_outlined;
      case TemplateModule.location: return Icons.location_on_outlined;
      case TemplateModule.ticketing: return Icons.confirmation_number_outlined;
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final uuid = const Uuid();
    final templateId = uuid.v4();

    try {
      TemplateModel template;

      if (widget.fromEventId != null) {
        template = await _buildTemplateFromExistingEvent(templateId, user.id);
      } else {
        template = _buildTemplateFromSuggestions(templateId, user.id);
      }

      await ref.read(templateRepositoryProvider).createTemplate(template);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Blueprint published successfully')));
        context.pop();
      }
    } on FirebaseException catch (e, st) {
      debugPrint('CreateTemplateScreen publish failed: ${e.code} ${e.message}\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Publish failed (${e.code}): ${e.message ?? 'Unknown error'}')),
        );
      }
    } catch (e, st) {
      debugPrint('CreateTemplateScreen publish failed: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  TemplateModel _buildTemplateFromSuggestions(String templateId, String userId) {
    final dummyEventId = 'blueprint_dummy'; 
    
    // Build hybrid config for settings-based modules
    final config = <String, dynamic>{};
    if (_selectedModules[TemplateModule.guestManagement]!) {
      final guestSuggestion = EventTemplateService.getSuggestedGuestSettings(_category);
      config['guestSettings'] = {
        'categories': guestSuggestion.categories,
        'rsvpRequired': guestSuggestion.rsvpRequired,
        'maxGuests': guestSuggestion.maxGuests,
        'metadataFields': guestSuggestion.metadataFields,
      };
    }
    if (_selectedModules[TemplateModule.expenses]!) {
      final expenseSuggestion = EventTemplateService.getSuggestedExpenseSettings(_category);
      config['expenseSettings'] = {
        'categories': expenseSuggestion.categories,
        'approvalRequired': expenseSuggestion.approvalRequired,
      };
    }
    if (_selectedModules[TemplateModule.contribution]!) {
      final contributionSuggestion = EventTemplateService.getSuggestedContribution(_category);
      final contributionSettings = <String, dynamic>{
        'paymentMethods': contributionSuggestion.paymentMethods,
        'target': contributionSuggestion.target,
      };
      if (contributionSuggestion.suggestedAmounts != null) {
        contributionSettings['suggestedAmounts'] = contributionSuggestion.suggestedAmounts;
      }
      config['contributionSettings'] = contributionSettings;
    }

    final keywords = _parseKeywords(_keywordsController.text);

    return TemplateModel(
      id: templateId,
      title: _titleController.text,
      description: _descriptionController.text,
      category: _category,
      contributionType: _selectedModules[TemplateModule.contribution]! 
          ? EventTemplateService.getSuggestedContribution(_category).type 
          : ContributionType.voluntary,
      createdBy: userId,
      tags: keywords,
      enabledModules: _selectedModules.entries.where((e) => e.value).map((e) => e.key).toList(),
      config: config,
      taskBlueprints: _selectedModules[TemplateModule.task]! ? EventTemplateService.getSuggestedTasks(dummyEventId, _category) : [],
      timelineBlueprints: _selectedModules[TemplateModule.timeline]! ? EventTemplateService.getSuggestedTimeline(dummyEventId, _category) : [],
      vendorBlueprints: _selectedModules[TemplateModule.vendor]! ? EventTemplateService.getSuggestedVendors(dummyEventId, _category) : [],
      inventoryBlueprints: _selectedModules[TemplateModule.inventory]! ? EventTemplateService.getSuggestedInventory(dummyEventId, _category) : [],
      roleBlueprints: _selectedModules[TemplateModule.roles]! ? List<RoleDefinitionModel>.from(_roleDefinitions) : [],
      venueBlueprints: [],
      ticketBlueprints: _selectedModules[TemplateModule.ticketing]! ? EventTemplateService.getSuggestedTickets(dummyEventId, _category) : [],
      budgetBlueprints: _selectedModules[TemplateModule.budget]! ? EventTemplateService.getSuggestedBudget(dummyEventId, _category) : [],
      createdAt: DateTime.now(),
    );
  }

  Future<TemplateModel> _buildTemplateFromExistingEvent(String templateId, String userId) async {
    return _buildTemplateFromSuggestions(templateId, userId);
  }

  List<String> _parseKeywords(String raw) {
    final parts = raw
        .split(RegExp(r'[,\n]'))
        .map((s) => s.trim().toLowerCase())
        .where((s) => s.isNotEmpty)
        .toList();
    return parts.toSet().toList();
  }

  List<String> _enabledRoleModules() {
    final modules = <String>[];
    if (_selectedModules[TemplateModule.budget] == true || _selectedModules[TemplateModule.expenses] == true) {
      modules.add(EventModules.budget);
    }
    if (_selectedModules[TemplateModule.contribution] == true) modules.add(EventModules.contribution);
    if (_selectedModules[TemplateModule.task] == true) modules.add(EventModules.tasks);
    if (_selectedModules[TemplateModule.userManagement] == true) modules.add(EventModules.users);
    if (_selectedModules[TemplateModule.guestManagement] == true) modules.add(EventModules.guests);
    if (_selectedModules[TemplateModule.vendor] == true) modules.add(EventModules.vendors);
    if (_selectedModules[TemplateModule.inventory] == true) modules.add(EventModules.inventory);
    if (_selectedModules[TemplateModule.roles] == true) modules.add(EventModules.roles);
    if (_selectedModules[TemplateModule.timeline] == true) modules.add(EventModules.timeline);
    if (_selectedModules[TemplateModule.location] == true) modules.add(EventModules.location);
    if (_selectedModules[TemplateModule.ticketing] == true) modules.add(EventModules.ticketing);
    return modules;
  }

  String _moduleLabel(String module) {
    switch (module) {
      case EventModules.budget:
        return 'Budget & Expense Tracking';
      case EventModules.contribution:
        return 'Contribution';
      case EventModules.tasks:
        return 'Tasks';
      case EventModules.users:
        return 'Users';
      case EventModules.guests:
        return 'Guests';
      case EventModules.vendors:
        return 'Vendors';
      case EventModules.inventory:
        return 'Inventory';
      case EventModules.roles:
        return 'Roles';
      case EventModules.timeline:
        return 'Timeline';
      case EventModules.location:
        return 'Venues & Location';
      case EventModules.ticketing:
        return 'Ticketing';
      default:
        return module;
    }
  }

  String _roleAccessSummary(RoleDefinitionModel role) {
    final enabled = _enabledRoleModules();
    if (enabled.isEmpty) return 'No modules enabled';
    final parts = <String>[];
    for (final m in enabled) {
      final lvl = role.moduleAccess[m] ?? ModuleAccessLevel.none;
      if (lvl == ModuleAccessLevel.none) continue;
      parts.add('${_moduleLabel(m)}: ${accessLevelLabel(lvl)}');
    }
    return parts.isEmpty ? 'No module access' : parts.join(' · ');
  }

  String enabledModulesSummary(List<String> enabledModules) {
    if (enabledModules.isEmpty) return 'Full access to all enabled modules';
    return 'Full access: ${enabledModules.map(_moduleLabel).join(' · ')}';
  }

  Future<void> _openRoleEditor(BuildContext context, {RoleDefinitionModel? existing}) async {
    final uuid = const Uuid();
    final roleId = existing?.id ?? uuid.v4();
    final nameController = TextEditingController(text: existing?.name ?? '');
    final descController = TextEditingController(text: existing?.description ?? '');
    final enabledModules = _enabledRoleModules();

    final Map<String, bool> moduleEnabled = {
      for (final m in enabledModules) m: (existing?.moduleAccess[m] ?? ModuleAccessLevel.none) != ModuleAccessLevel.none,
    };
    final Map<String, ModuleAccessLevel> moduleLevels = {
      for (final m in enabledModules)
        m: (() {
          final current = existing?.moduleAccess[m];
          if (current != null && current != ModuleAccessLevel.none) return current;
          return ModuleAccessLevel.view;
        })(),
    };

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(existing == null ? 'Add Role' : 'Edit Role', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Role name (required)', prefixIcon: Icon(Icons.badge_outlined)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Description (optional)', prefixIcon: Icon(Icons.notes_outlined)),
                ),
                const SizedBox(height: 16),
                const Text('Module access', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                if (enabledModules.isEmpty)
                  const Text('Enable modules above to assign access.', style: TextStyle(color: Colors.grey))
                else
                  ...enabledModules.map((m) {
                    final on = moduleEnabled[m] ?? false;
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Expanded(child: Text(_moduleLabel(m), style: const TextStyle(fontWeight: FontWeight.w700))),
                                Switch(
                                  value: on,
                                  onChanged: (v) => setSheetState(() => moduleEnabled[m] = v),
                                ),
                              ],
                            ),
                            if (on) ...[
                              const SizedBox(height: 8),
                              DropdownButtonFormField<ModuleAccessLevel>(
                                value: moduleLevels[m] ?? ModuleAccessLevel.view,
                                decoration: const InputDecoration(labelText: 'Permission level'),
                                items: const [
                                  DropdownMenuItem(value: ModuleAccessLevel.full, child: Text('Full')),
                                  DropdownMenuItem(value: ModuleAccessLevel.edit, child: Text('Edit')),
                                  DropdownMenuItem(value: ModuleAccessLevel.update, child: Text('Update')),
                                  DropdownMenuItem(value: ModuleAccessLevel.view, child: Text('View')),
                                ],
                                onChanged: (v) => setSheetState(() => moduleLevels[m] = v ?? ModuleAccessLevel.view),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Role name is required')));
                      return;
                    }
                    final lower = name.toLowerCase();
                    if (lower == 'owner') {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('“Owner” is a system role name. Choose a different name.')));
                      return;
                    }
                    final duplicate = _roleDefinitions.any((x) => x.id != roleId && x.name.trim().toLowerCase() == lower);
                    if (duplicate) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Role name already exists.')));
                      return;
                    }
  
                    final access = <String, ModuleAccessLevel>{};
                    for (final m in enabledModules) {
                      if (moduleEnabled[m] == true) {
                        access[m] = moduleLevels[m] ?? ModuleAccessLevel.view;
                      } else {
                        access[m] = ModuleAccessLevel.none;
                      }
                    }
  
                    final model = RoleDefinitionModel(
                      id: roleId,
                      name: name,
                      description: descController.text.trim(),
                      moduleAccess: access,
                    );
  
                    setState(() {
                      final i = _roleDefinitions.indexWhere((x) => x.id == roleId);
                      if (i >= 0) {
                        _roleDefinitions[i] = model;
                      } else {
                        _roleDefinitions.add(model);
                      }
                    });
  
                    Navigator.pop(context);
                  },
                  child: const Text('Save Role'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
