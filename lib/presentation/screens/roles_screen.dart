import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/event_model.dart';
import '../../data/models/event_role_model.dart';
import '../../data/models/event_user_model.dart';
import '../../data/models/template_model.dart';
import '../../data/models/user_model.dart';
import '../../providers/access_control_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/event_provider.dart';
import '../../providers/event_user_provider.dart';
import '../../providers/role_provider.dart';
import '../../providers/user_provider.dart';

class RolesScreen extends ConsumerWidget {
  final String eventId;
  const RolesScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventByIdStreamProvider(eventId));
    final rolesAsync = ref.watch(rolesForEventStreamProvider(eventId));
    final eventUsersAsync = ref.watch(eventUsersStreamProvider(eventId));

    final canView = ref.watch(
      hasModuleAccessProvider((eventId: eventId, module: EventModules.roles, required: ModuleAccessLevel.view)),
    );
    final canEdit = ref.watch(
      hasModuleAccessProvider((eventId: eventId, module: EventModules.roles, required: ModuleAccessLevel.edit)),
    );

    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Roles & Permissions'),
        actions: [
          if (canEdit)
            rolesAsync.maybeWhen(
              data: (roles) => IconButton(
                tooltip: 'Assign user',
                icon: const Icon(Icons.person_add_alt_1_outlined),
                onPressed: roles.isEmpty ? null : () => _openAssignUserSheet(context, ref, roles),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
          eventAsync.maybeWhen(
            data: (event) {
              final isOwner = event != null && currentUser != null && event.organizerId == currentUser.id;
              if (!isOwner) return const SizedBox.shrink();
              return IconButton(
                tooltip: 'Transfer ownership',
                icon: const Icon(Icons.swap_horiz),
                onPressed: () {
                  final roles = rolesAsync.value ?? const <EventRoleModel>[];
                  final users = eventUsersAsync.value ?? const <EventUserModel>[];
                  _openTransferOwnershipSheet(context, ref, event, roles, users);
                },
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: !canView
          ? const Center(child: Text('You do not have access to Roles & Permissions.'))
          : rolesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Failed to load roles: $e')),
              data: (roles) {
                final event = eventAsync.value;
                final enabledModules = _enabledEventModules(event);

                // Ensure Owner is first, then alphabetical.
                final sorted = [...roles]..sort((a, b) {
                    final ao = _isOwnerRole(a) ? 0 : 1;
                    final bo = _isOwnerRole(b) ? 0 : 1;
                    if (ao != bo) return ao.compareTo(bo);
                    return a.name.toLowerCase().compareTo(b.name.toLowerCase());
                  });

                if (sorted.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('No roles created for this event yet.'),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: !canEdit ? null : () => _openRoleEditor(context, ref, enabledModules, roles: const []),
                          icon: const Icon(Icons.add),
                          label: const Text('Create role'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Permissions Matrix',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                        if (canEdit)
                          FilledButton.icon(
                            onPressed: () => _openRoleEditor(context, ref, enabledModules, roles: sorted),
                            icon: const Icon(Icons.add),
                            label: const Text('Add role'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _RoleMatrix(
                      roles: sorted,
                      modules: enabledModules,
                      canEdit: canEdit,
                      onChange: (role, module, level) async {
                        if (_isOwnerRole(role)) return;
                        final updated = {...role.moduleAccess, module: level};
                        await ref.read(roleRepositoryProvider).updateRole(role.copyWith(moduleAccess: updated));
                      },
                    ),
                    const SizedBox(height: 20),
                    Text('Roles (${sorted.length})',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                    ...sorted.map((r) => _RoleCard(
                          eventId: eventId,
                          role: r,
                          allRoles: sorted,
                          enabledModules: enabledModules,
                          canEdit: canEdit,
                        )),
                  ],
                );
              },
            ),
    );
  }

  static bool _isOwnerRole(EventRoleModel role) {
    if (role.isSystem && role.systemKey == 'owner') return true;
    return role.name.trim().toLowerCase() == 'owner';
  }

  static List<String> _enabledEventModules(EventModel? event) {
    // If the event came from a template, show only modules enabled in the template snapshot.
    final snapshot = event?.templateSnapshot;
    if (snapshot is! Map<String, dynamic>) return EventModules.all;
    final raw = snapshot['enabledModules'];
    if (raw is! List) return EventModules.all;

    final out = <String>{EventModules.roles, EventModules.users}; // Always allow configuring these.

    for (final v in raw) {
      if (v is! String) continue;
      final tm = _firstOrNull(TemplateModule.values.where((m) => m.name == v));
      if (tm == null) continue;
      switch (tm) {
        case TemplateModule.budget:
        case TemplateModule.expenses:
          out.add(EventModules.budget);
          break;
        case TemplateModule.contribution:
          out.add(EventModules.contribution);
          break;
        case TemplateModule.task:
          out.add(EventModules.tasks);
          break;
        case TemplateModule.guestManagement:
          out.add(EventModules.guests);
          break;
        case TemplateModule.vendor:
          out.add(EventModules.vendors);
          break;
        case TemplateModule.inventory:
          out.add(EventModules.inventory);
          break;
        case TemplateModule.userManagement:
          out.add(EventModules.users);
          break;
        case TemplateModule.roles:
          out.add(EventModules.roles);
          break;
        case TemplateModule.timeline:
          out.add(EventModules.timeline);
          break;
        case TemplateModule.location:
          out.add(EventModules.location);
          break;
        case TemplateModule.ticketing:
          out.add(EventModules.ticketing);
          break;
        case TemplateModule.invitation:
          out.add(EventModules.invitation);
          break;
        default:
          break;
      }
    }

    final ordered = EventModules.all.where(out.contains).toList();
    return ordered.isEmpty ? EventModules.all : ordered;
  }

  Future<void> _openRoleEditor(
    BuildContext context,
    WidgetRef ref,
    List<String> enabledModules, {
    required List<EventRoleModel> roles,
    EventRoleModel? existing,
  }) async {
    final roleRepo = ref.read(roleRepositoryProvider);
    final uuid = const Uuid();
    final roleId = existing?.id ?? uuid.v4();
    final nameController = TextEditingController(text: existing?.name ?? '');
    final descController = TextEditingController(text: existing?.description ?? '');

    final Map<String, bool> moduleEnabled = {
      for (final m in enabledModules)
        m: (existing?.moduleAccess[m] ?? ModuleAccessLevel.none) != ModuleAccessLevel.none,
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
                Text(existing == null ? 'Add Role' : 'Edit Role',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
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
                  onPressed: () async {
                    final name = nameController.text.trim();
                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Role name is required')));
                      return;
                    }
                    final lower = name.toLowerCase();
                    if (lower == 'owner') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('“Owner” is a system role name. Choose a different name.')),
                      );
                      return;
                    }
                    final duplicate = roles.any((x) => x.id != roleId && x.name.trim().toLowerCase() == lower);
                    if (duplicate) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Role name already exists.')));
                      return;
                    }
  
                    final access = <String, ModuleAccessLevel>{for (final m in EventModules.all) m: ModuleAccessLevel.none};
                    for (final m in enabledModules) {
                      if (moduleEnabled[m] == true) {
                        access[m] = moduleLevels[m] ?? ModuleAccessLevel.view;
                      }
                    }
  
                    final model = EventRoleModel(
                      id: roleId,
                      eventId: eventId,
                      name: name,
                      description: descController.text.trim(),
                      moduleAccess: access,
                      userIds: existing?.userIds ?? const [],
                      userResponsibilities: existing?.userResponsibilities ?? const {},
                    );
  
                    try {
                      if (existing == null) {
                        await roleRepo.addRole(model);
                      } else {
                        await roleRepo.updateRole(model);
                      }
                      if (context.mounted) Navigator.pop(context);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save role: $e')));
                      }
                    }
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

  Future<void> _openAssignUserSheet(BuildContext context, WidgetRef ref, List<EventRoleModel> roles) async {
    final roleRepo = ref.read(roleRepositoryProvider);
    final userRepo = ref.read(userRepositoryProvider);
    final eventUserRepo = ref.read(eventUserRepositoryProvider);
    final currentUser = ref.read(currentUserProvider);

    EventRoleModel selectedRole = roles.firstWhere((r) => !_isOwnerRole(r), orElse: () => roles.first);
    String responsibility = '';
    String search = '';
    bool isLoading = false;
    List<UserModel> matches = const [];
    UserModel? selectedUser;

    Future<void> runSearch(void Function(void Function()) setState) async {
      setState(() {
        isLoading = true;
        matches = const [];
        selectedUser = null;
      });
      try {
        final found = await userRepo.searchUsers(search);
        setState(() => matches = found);
      } finally {
        setState(() => isLoading = false);
      }
    }

    Future<void> assign(void Function(void Function()) setState) async {
      if (selectedUser == null) return;
      final userId = selectedUser!.id;

      setState(() => isLoading = true);
      try {
        // Ensure the user is in the event's participants list.
        await eventUserRepo.addUserToEvent(
          EventUserModel(
            id: userId,
            eventId: eventId,
            status: EventUserStatus.active,
            addedAt: DateTime.now(),
            addedBy: currentUser?.id,
          ),
        );

        final updatedIds = {...selectedRole.userIds, userId}.toList();
        final updatedResp = {...selectedRole.userResponsibilities};
        if (responsibility.trim().isNotEmpty) {
          updatedResp[userId] = responsibility.trim();
        } else {
          updatedResp.remove(userId);
        }
        await roleRepo.updateRole(selectedRole.copyWith(userIds: updatedIds, userResponsibilities: updatedResp));

        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User assigned')));
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to assign: $e')));
        }
      } finally {
        setState(() => isLoading = false);
      }
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Assign user to role',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              DropdownButtonFormField<EventRoleModel>(
                value: selectedRole,
                decoration: const InputDecoration(labelText: 'Role'),
                items: roles
                    .where((r) => !_isOwnerRole(r))
                    .map((r) => DropdownMenuItem(value: r, child: Text(r.name)))
                    .toList(),
                onChanged: isLoading ? null : (v) => setState(() => selectedRole = v ?? selectedRole),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(prefixIcon: Icon(Icons.search), labelText: 'Find user (name / email / phone / UID)'),
                onChanged: (v) => search = v,
                onSubmitted: (_) => runSearch(setState),
              ),
              const SizedBox(height: 10),
              FilledButton.icon(
                onPressed: isLoading ? null : () => runSearch(setState),
                icon: isLoading
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.search),
                label: const Text('Search'),
              ),
              const SizedBox(height: 12),
              if (matches.isNotEmpty) ...[
                const Text('Select user', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                ...matches.take(6).map((u) {
                  final isSelected = selectedUser?.id == u.id;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off),
                    title: Text(u.name.isNotEmpty ? u.name : u.id),
                    subtitle: Text([u.email, u.phone].where((s) => s.toString().trim().isNotEmpty).join(' · ')),
                    onTap: () => setState(() => selectedUser = u),
                  );
                }),
              ],
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Responsibility label (optional)',
                  hintText: 'e.g. Budget, Logistics, Guest Coordination',
                ),
                onChanged: (v) => responsibility = v,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: (selectedUser == null || isLoading) ? null : () => assign(setState),
                child: const Text('Assign'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openTransferOwnershipSheet(
    BuildContext context,
    WidgetRef ref,
    EventModel event,
    List<EventRoleModel> roles,
    List<EventUserModel> eventUsers,
  ) async {
    final activeUsers = eventUsers.where((u) => u.status == EventUserStatus.active).toList();
    final currentOwnerId = event.organizerId;

    final candidates = activeUsers.where((u) => u.id != currentOwnerId).toList();
    if (candidates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add another user to the event before transferring ownership.')),
      );
      return;
    }

    String selectedNewOwner = candidates.first.id;

    // Downgrade role for previous owner.
    final nonOwnerRoles = roles.where((r) => !_isOwnerRole(r)).toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    final manager = _firstOrNull(nonOwnerRoles.where((r) => r.name.trim().toLowerCase() == 'manager'));
    String? downgradeRoleId = manager?.id ?? (nonOwnerRoles.isEmpty ? null : nonOwnerRoles.first.id);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Transfer ownership',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const Text('The new owner gets full access. You will lose Owner access.', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 12),
              const Text('Select new owner', style: TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              ...candidates.map(
                (u) => _UserRadioTile(
                  userId: u.id,
                  selected: selectedNewOwner == u.id,
                  onTap: () => setState(() => selectedNewOwner = u.id),
                ),
              ),
              const SizedBox(height: 12),
              if (downgradeRoleId != null) ...[
                DropdownButtonFormField<String>(
                  value: downgradeRoleId,
                  decoration: const InputDecoration(labelText: 'Your new role'),
                  items: nonOwnerRoles.map((r) => DropdownMenuItem(value: r.id, child: Text(r.name))).toList(),
                  onChanged: (v) => setState(() => downgradeRoleId = v),
                ),
                const SizedBox(height: 12),
              ],
              FilledButton(
                onPressed: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm transfer'),
                      content: const Text('Transfer ownership? This cannot be undone automatically.'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                        ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Transfer')),
                      ],
                    ),
                  );
                  if (ok != true) return;

                  await _transferOwnership(
                    context,
                    ref,
                    event,
                    roles,
                    newOwnerId: selectedNewOwner,
                    downgradeRoleId: downgradeRoleId,
                  );
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text('Transfer ownership'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _transferOwnership(
    BuildContext context,
    WidgetRef ref,
    EventModel event,
    List<EventRoleModel> roles, {
    required String newOwnerId,
    required String? downgradeRoleId,
  }) async {
    final roleRepo = ref.read(roleRepositoryProvider);
    final eventRepo = ref.read(eventRepositoryProvider);
    final uuid = const Uuid();

    final ownerRole = _firstOrNull(roles.where(_isOwnerRole));
    if (ownerRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Owner role missing.')));
      return;
    }

    final previousOwner = event.organizerId;

    try {
      await eventRepo.updateEvent(event.copyWith(organizerId: newOwnerId));

      await roleRepo.updateRole(ownerRole.copyWith(userIds: [newOwnerId]));

      if (downgradeRoleId != null) {
        final downgrade = _firstOrNull(roles.where((r) => r.id == downgradeRoleId));
        if (downgrade != null) {
          final ids = {...downgrade.userIds, previousOwner}.toList();
          await roleRepo.updateRole(downgrade.copyWith(userIds: ids));
        }
      } else {
        // Ensure the previous owner still has a sensible default role.
        final enabledModules = _enabledEventModules(event);
        final access = <String, ModuleAccessLevel>{for (final m in EventModules.all) m: ModuleAccessLevel.none};
        for (final m in enabledModules) {
          access[m] = ModuleAccessLevel.edit;
        }
        final managerRole = EventRoleModel(
          id: uuid.v4(),
          eventId: eventId,
          name: 'Manager',
          description: 'Default role after ownership transfer.',
          moduleAccess: access,
          userIds: [previousOwner],
        );
        await roleRepo.addRole(managerRole);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ownership transferred')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Transfer failed: $e')));
      }
    }
  }
}

class _UserRadioTile extends ConsumerWidget {
  final String userId;
  final bool selected;
  final VoidCallback onTap;

  const _UserRadioTile({required this.userId, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userByIdProvider(userId));
    return userAsync.maybeWhen(
      data: (u) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off),
        title: Text(u?.name.trim().isNotEmpty == true ? u!.name.trim() : userId),
        subtitle: Text([u?.email, u?.phone].where((s) => (s ?? '').trim().isNotEmpty).join(' · ')),
        onTap: onTap,
      ),
      orElse: () => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off),
        title: Text(userId),
        onTap: onTap,
      ),
    );
  }
}

class _RoleCard extends ConsumerWidget {
  final String eventId;
  final EventRoleModel role;
  final List<EventRoleModel> allRoles;
  final List<String> enabledModules;
  final bool canEdit;

  const _RoleCard({
    required this.eventId,
    required this.role,
    required this.allRoles,
    required this.enabledModules,
    required this.canEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOwner = RolesScreen._isOwnerRole(role);

    return Card(
      child: ExpansionTile(
        leading: Icon(isOwner ? Icons.verified_user_outlined : Icons.badge_outlined),
        title: Text(isOwner ? 'Owner (System)' : role.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (role.description.isNotEmpty) ...[
              Text(role.description, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 4),
            ],
            Text(
              _roleAccessSummary(role),
              style: TextStyle(color: Colors.blue.shade700, fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: (!canEdit || isOwner)
                        ? null
                        : () => RolesScreen(eventId: eventId)
                            ._openRoleEditor(context, ref, enabledModules, roles: allRoles, existing: role),
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit role'),
                  ),
                  OutlinedButton.icon(
                    onPressed: (!canEdit || isOwner)
                        ? null
                        : () async {
                            await ref.read(roleRepositoryProvider).updateRole(role.copyWith(userIds: const [], userResponsibilities: const {}));
                          },
                    icon: const Icon(Icons.group_remove_outlined),
                    label: const Text('Clear users'),
                  ),
                  OutlinedButton.icon(
                    onPressed: (!canEdit || isOwner)
                        ? null
                        : () async {
                            final ok = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete role'),
                                content: Text('Delete “${role.name}”? This will not remove users from the event.'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                                  ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                                ],
                              ),
                            );
                            if (ok != true) return;
                            await ref.read(roleRepositoryProvider).deleteRole(eventId: role.eventId, roleId: role.id);
                          },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete'),
                  ),
                ],
              ),
            ),
          ),
          if (role.userIds.isEmpty)
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Align(alignment: Alignment.centerLeft, child: Text('No users assigned.', style: TextStyle(color: Colors.grey))),
            )
          else
            ...role.userIds.map((uid) => _AssignedUserTile(role: role, userId: uid)),
        ],
      ),
    );
  }

  String _roleAccessSummary(EventRoleModel role) {
    final parts = <String>[];
    for (final m in enabledModules) {
      final lvl = role.moduleAccess[m] ?? ModuleAccessLevel.none;
      if (lvl == ModuleAccessLevel.none) continue;
      parts.add('${_moduleLabel(m)}: ${accessLevelLabel(lvl)}');
    }
    return parts.isEmpty ? 'No module access' : parts.join(' · ');
  }
}

class _AssignedUserTile extends ConsumerWidget {
  final EventRoleModel role;
  final String userId;
  const _AssignedUserTile({required this.role, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userByIdProvider(userId));
    final responsibility = role.userResponsibilities[userId]?.trim();

    return userAsync.when(
      data: (u) => ListTile(
        dense: true,
        leading: const Icon(Icons.person_outline),
        title: Text(u?.name.isNotEmpty == true ? u!.name : userId),
        subtitle: Text(
          [
            if (u?.email.isNotEmpty == true) u!.email,
            if (u?.phone.isNotEmpty == true) u!.phone,
            if (responsibility != null && responsibility.isNotEmpty) 'Responsibility: $responsibility',
          ].join(' · '),
        ),
        trailing: RolesScreen._isOwnerRole(role)
            ? null
            : IconButton(
                tooltip: 'Remove',
                icon: const Icon(Icons.close),
                onPressed: () async {
                  final updatedIds = role.userIds.where((id) => id != userId).toList();
                  final updatedResp = {...role.userResponsibilities}..remove(userId);
                  await ref.read(roleRepositoryProvider).updateRole(role.copyWith(userIds: updatedIds, userResponsibilities: updatedResp));
                },
              ),
      ),
      loading: () => ListTile(
        dense: true,
        leading: const Icon(Icons.person_outline),
        title: Text(userId),
        subtitle: Text(responsibility == null || responsibility.isEmpty ? 'Loading user…' : 'Responsibility: $responsibility'),
      ),
      error: (e, _) => ListTile(
        dense: true,
        leading: const Icon(Icons.person_outline),
        title: Text(userId),
        subtitle: Text(responsibility == null || responsibility.isEmpty ? 'Failed to load user: $e' : 'Responsibility: $responsibility'),
      ),
    );
  }
}

class _RoleMatrix extends StatelessWidget {
  final List<EventRoleModel> roles;
  final List<String> modules;
  final bool canEdit;
  final Future<void> Function(EventRoleModel role, String module, ModuleAccessLevel level) onChange;

  const _RoleMatrix({required this.roles, required this.modules, required this.canEdit, required this.onChange});

  @override
  Widget build(BuildContext context) {
    final columns = <DataColumn>[
      const DataColumn(label: Text('Role')),
      for (final module in modules) DataColumn(label: Text(_moduleLabel(module))),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: columns,
        rows: roles
            .map(
              (role) => DataRow(
                cells: [
                  DataCell(Text(RolesScreen._isOwnerRole(role) ? 'Owner' : role.name)),
                  for (final module in modules)
                    DataCell(
                      PopupMenuButton<ModuleAccessLevel>(
                        tooltip: 'Change access',
                        enabled: canEdit && !RolesScreen._isOwnerRole(role),
                        onSelected: (lvl) => onChange(role, module, lvl),
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: ModuleAccessLevel.full, child: Text('Full')),
                          PopupMenuItem(value: ModuleAccessLevel.edit, child: Text('Edit')),
                          PopupMenuItem(value: ModuleAccessLevel.update, child: Text('Update')),
                          PopupMenuItem(value: ModuleAccessLevel.view, child: Text('View')),
                          PopupMenuItem(value: ModuleAccessLevel.none, child: Text('No Access')),
                        ],
                        child: _AccessLevelChip(level: role.moduleAccess[module] ?? ModuleAccessLevel.none),
                      ),
                    ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

class _AccessLevelChip extends StatelessWidget {
  final ModuleAccessLevel level;
  const _AccessLevelChip({required this.level});

  @override
  Widget build(BuildContext context) {
    final color = _levelColor(level);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Text(
        accessLevelLabel(level),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: color),
      ),
    );
  }
}

String _moduleLabel(String module) {
  switch (module) {
    case EventModules.budget:
      return 'Budget';
    case EventModules.contribution:
      return 'Contribution';
    case EventModules.tasks:
      return 'Tasks';
    case EventModules.guests:
      return 'Guests';
    case EventModules.vendors:
      return 'Vendors';
    case EventModules.users:
      return 'Users';
    case EventModules.roles:
      return 'Roles';
    default:
      return module;
  }
}

Color _levelColor(ModuleAccessLevel level) {
  switch (level) {
    case ModuleAccessLevel.full:
      return Colors.deepPurple;
    case ModuleAccessLevel.edit:
      return Colors.blue;
    case ModuleAccessLevel.update:
      return Colors.green;
    case ModuleAccessLevel.view:
      return Colors.grey;
    case ModuleAccessLevel.none:
      return Colors.black54;
  }
}

T? _firstOrNull<T>(Iterable<T> items) {
  for (final x in items) {
    return x;
  }
  return null;
}
