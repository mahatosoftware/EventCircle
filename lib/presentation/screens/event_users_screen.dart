import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/event_model.dart';
import '../../data/models/event_role_model.dart';
import '../../data/models/event_user_model.dart';
import '../../data/models/user_model.dart';
import '../../providers/access_control_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/event_provider.dart';
import '../../providers/event_user_provider.dart';
import '../../providers/role_provider.dart';
import '../../providers/user_provider.dart';

class EventUsersScreen extends ConsumerWidget {
  final String eventId;
  const EventUsersScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventByIdStreamProvider(eventId));
    final usersAsync = ref.watch(eventUsersStreamProvider(eventId));
    final rolesAsync = ref.watch(rolesForEventStreamProvider(eventId));

    final canViewUsers = ref.watch(
      hasModuleAccessProvider((eventId: eventId, module: EventModules.users, required: ModuleAccessLevel.view)),
    );
    final canEditUsers = ref.watch(
      hasModuleAccessProvider((eventId: eventId, module: EventModules.users, required: ModuleAccessLevel.edit)),
    );
    final canEditRoles = ref.watch(
      hasModuleAccessProvider((eventId: eventId, module: EventModules.roles, required: ModuleAccessLevel.edit)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            tooltip: 'Add user',
            icon: const Icon(Icons.person_add_alt_1_outlined),
            onPressed: !canEditUsers ? null : () => _openAddUserSheet(context, ref),
          ),
        ],
      ),
      body: !canViewUsers
          ? const Center(child: Text('You do not have access to Users.'))
          : eventAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load event: $e')),
        data: (event) {
          if (event == null) return const Center(child: Text('Event not found'));
          return usersAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Failed to load users: $e')),
            data: (eventUsers) {
              final roles = rolesAsync.value ?? const <EventRoleModel>[];
              final active = eventUsers.where((u) => u.status == EventUserStatus.active).toList();
              final removed = eventUsers.where((u) => u.status == EventUserStatus.removed).toList();

              // Ensure the owner is always in the active list
              final ownerId = event.organizerId;
              if (!active.any((u) => u.id == ownerId)) {
                active.insert(0, EventUserModel(
                  id: ownerId, 
                  eventId: eventId, 
                  status: EventUserStatus.active,
                  addedAt: event.createdAt,
                ));
              }

              if (active.isEmpty) {
                return const Center(child: Text('No users added to this event yet.'));
              }

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text('Active (${active.length})', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ...active.map(
                    (eu) => _EventUserTile(
                      event: event,
                      eventUser: eu,
                      roles: roles,
                      canEditUsers: canEditUsers,
                      canEditRoles: canEditRoles,
                    ),
                  ),
                  if (removed.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text('Removed (${removed.length})', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ...removed.map((eu) => _EventUserTile(
                          event: event,
                          eventUser: eu,
                          roles: roles,
                          canEditUsers: false,
                          canEditRoles: false,
                        )),
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _openAddUserSheet(BuildContext context, WidgetRef ref) async {
    final userRepo = ref.read(userRepositoryProvider);
    final eventUserRepo = ref.read(eventUserRepositoryProvider);
    final currentUser = ref.read(currentUserProvider);

    String search = '';
    bool loading = false;
    List<UserModel> matches = const [];

    Future<void> runSearch(void Function(void Function()) setState) async {
      final q = search.trim();
      if (q.isEmpty) return;
      setState(() {
        loading = true;
        matches = const [];
      });
      try {
        final res = await userRepo.searchUsers(q);
        setState(() => matches = res);
      } finally {
        setState(() => loading = false);
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
              Text('Add user to event',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  labelText: 'Search by name / phone / email / UID',
                ),
                onChanged: (v) => search = v,
                onSubmitted: (_) => runSearch(setState),
              ),
              const SizedBox(height: 10),
              FilledButton.icon(
                onPressed: loading ? null : () => runSearch(setState),
                icon: loading
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.search),
                label: const Text('Search'),
              ),
              const SizedBox(height: 12),
              if (!loading && matches.isEmpty)
                const Text('Enter a query to find users.', style: TextStyle(color: Colors.grey)),
              if (matches.isNotEmpty) ...[
                const SizedBox(height: 8),
                ...matches.take(8).map(
                  (u) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.person_outline),
                    title: Text(u.name.isNotEmpty ? u.name : u.id),
                    subtitle: Text([u.email, u.phone].where((s) => s.toString().trim().isNotEmpty).join(' · ')),
                    trailing: const Icon(Icons.add),
                    onTap: () async {
                      try {
                        await eventUserRepo.addUserToEvent(
                          EventUserModel(
                            id: u.id,
                            eventId: eventId,
                            status: EventUserStatus.active,
                            addedAt: DateTime.now(),
                            addedBy: currentUser?.id,
                          ),
                        );
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('Added ${u.name.isEmpty ? u.id : u.name}')));
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add user: $e')));
                        }
                      }
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EventUserTile extends ConsumerWidget {
  final EventModel event;
  final EventUserModel eventUser;
  final List<EventRoleModel> roles;
  final bool canEditUsers;
  final bool canEditRoles;

  const _EventUserTile({
    required this.event,
    required this.eventUser,
    required this.roles,
    required this.canEditUsers,
    required this.canEditRoles,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userByIdProvider(eventUser.id));
    final assignedRoles = roles.where((r) => r.userIds.contains(eventUser.id)).toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    final isOwner = event.organizerId == eventUser.id;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: userAsync.when(
        loading: () => ListTile(
          leading: const Icon(Icons.person_outline),
          title: Text(eventUser.id),
          subtitle: const Text('Loading…'),
        ),
        error: (e, _) => ListTile(
          leading: const Icon(Icons.person_outline),
          title: Text(eventUser.id),
          subtitle: Text('Failed to load user: $e'),
        ),
        data: (u) {
          final name = u?.name.trim().isNotEmpty == true ? u!.name.trim() : eventUser.id;
          final subtitleBits = <String>[
            if (u?.email.trim().isNotEmpty == true) u!.email.trim(),
            if (u?.phone.trim().isNotEmpty == true) u!.phone.trim(),
          ];

          return ListTile(
            leading: CircleAvatar(child: Text(name[0].toUpperCase())),
            title: Row(
              children: [
                Expanded(child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis)),
                if (isOwner) ...[
                  const SizedBox(width: 6),
                  const Icon(Icons.workspace_premium_outlined, size: 16),
                ],
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (subtitleBits.isNotEmpty) Text(subtitleBits.join(' · ')),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (assignedRoles.isEmpty)
                      const _RoleChip(label: 'No roles', level: ModuleAccessLevel.none)
                    else
                      for (final r in assignedRoles) _RoleChip(label: r.name, level: _roleLevel(r)),
                  ],
                ),
              ],
            ),
            isThreeLine: subtitleBits.isNotEmpty,
            trailing: PopupMenuButton<String>(
              onSelected: (v) async {
                switch (v) {
                  case 'roles':
                    if (!canEditRoles || isOwner) return;
                    await _openRolePicker(context, ref);
                    return;
                  case 'details':
                    await _openDetails(context, ref);
                    return;
                  case 'remove':
                    if (!canEditUsers || isOwner) return;
                    await _removeFromEvent(context, ref);
                    return;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'details',
                  child: const Text('View access'),
                ),
                PopupMenuItem(
                  value: 'roles',
                  enabled: canEditRoles && !isOwner,
                  child: const Text('Assign roles'),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'remove',
                  enabled: canEditUsers && !isOwner,
                  child: const Text('Remove from event'),
                ),
              ],
            ),
            onTap: () => _openDetails(context, ref),
          );
        },
      ),
    );
  }

  static ModuleAccessLevel _roleLevel(EventRoleModel role) {
    // Best-effort: color chip based on role having any edit+ access.
    final any = role.moduleAccess.values.fold(ModuleAccessLevel.none, (best, lvl) {
      return accessRank(lvl) > accessRank(best) ? lvl : best;
    });
    return any;
  }

  Future<void> _openRolePicker(BuildContext context, WidgetRef ref) async {
    final roleRepo = ref.read(roleRepositoryProvider);

    final selectable = roles.where((r) => !(r.isSystem && r.systemKey == 'owner') && r.name.trim().toLowerCase() != 'owner').toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    final selected = <String>{
      for (final r in selectable)
        if (r.userIds.contains(eventUser.id)) r.id,
    };

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
              Text('Assign roles', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              if (selectable.isEmpty)
                const Text('No roles available. Create roles in Roles & Permissions.', style: TextStyle(color: Colors.grey))
              else
                ...selectable.map(
                  (r) => CheckboxListTile(
                    value: selected.contains(r.id),
                    title: Text(r.name),
                    subtitle: Text(r.description.isEmpty ? '—' : r.description),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (v) => setState(() {
                      if (v == true) {
                        selected.add(r.id);
                      } else {
                        selected.remove(r.id);
                      }
                    }),
                  ),
                ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: selectable.isEmpty
                    ? null
                    : () async {
                        try {
                          for (final r in selectable) {
                            final has = r.userIds.contains(eventUser.id);
                            final wants = selected.contains(r.id);
                            if (has == wants) continue;
                            final ids = wants
                                ? ([...r.userIds, eventUser.id]..sort())
                                : r.userIds.where((id) => id != eventUser.id).toList();
                            final resp = {...r.userResponsibilities};
                            if (!wants) resp.remove(eventUser.id);
                            await roleRepo.updateRole(r.copyWith(userIds: ids, userResponsibilities: resp));
                          }
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Roles updated')));
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update roles: $e')));
                          }
                        }
                      },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openDetails(BuildContext context, WidgetRef ref) async {
    final assigned = roles.where((r) => r.userIds.contains(eventUser.id)).toList();
    ModuleAccessLevel effectiveFor(String module) {
      ModuleAccessLevel best = ModuleAccessLevel.none;
      for (final r in assigned) {
        final lvl = r.moduleAccess[module] ?? ModuleAccessLevel.none;
        if (accessRank(lvl) > accessRank(best)) best = lvl;
      }
      if (event.organizerId == eventUser.id) return ModuleAccessLevel.full;
      return best;
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('User access', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            for (final m in EventModules.all)
              ListTile(
                dense: true,
                title: Text(_moduleLabel(m)),
                trailing: _AccessLevelChip(level: effectiveFor(m)),
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _removeFromEvent(BuildContext context, WidgetRef ref) async {
    final eventUserRepo = ref.read(eventUserRepositoryProvider);
    final roleRepo = ref.read(roleRepositoryProvider);

    try {
      await eventUserRepo.removeUserFromEvent(eventUser.eventId, eventUser.id);
      // Also remove from all roles (best-effort).
      for (final r in roles) {
        if (!r.userIds.contains(eventUser.id) && !r.userResponsibilities.containsKey(eventUser.id)) continue;
        final ids = r.userIds.where((id) => id != eventUser.id).toList();
        final resp = {...r.userResponsibilities}..remove(eventUser.id);
        await roleRepo.updateRole(r.copyWith(userIds: ids, userResponsibilities: resp));
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User removed')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to remove: $e')));
      }
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
      case EventModules.users:
        return 'Users';
      case EventModules.roles:
        return 'Roles';
      case EventModules.guests:
        return 'Guests';
      case EventModules.vendors:
        return 'Vendors';
      default:
        return module;
    }
  }
}

class _RoleChip extends StatelessWidget {
  final String label;
  final ModuleAccessLevel level;
  const _RoleChip({required this.label, required this.level});

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
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
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
