import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/event_model.dart';
import '../data/models/event_role_model.dart';
import 'auth_provider.dart';
import 'event_provider.dart';
import 'role_provider.dart';

ModuleAccessLevel _maxLevel(ModuleAccessLevel a, ModuleAccessLevel b) {
  return accessRank(a) >= accessRank(b) ? a : b;
}

final moduleAccessForEventProvider =
    Provider.family<ModuleAccessLevel, ({String eventId, String module})>((ref, args) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return ModuleAccessLevel.none;

  final EventModel? event = ref.watch(eventByIdStreamProvider(args.eventId)).value;
  if (event != null && event.organizerId == user.id) return ModuleAccessLevel.full;

  final roles = ref.watch(rolesForEventStreamProvider(args.eventId)).value ?? const <EventRoleModel>[];
  if (roles.isEmpty) return ModuleAccessLevel.none;

  ModuleAccessLevel best = ModuleAccessLevel.none;
  for (final r in roles) {
    if (!r.userIds.contains(user.id)) continue;
    final lvl = r.moduleAccess[args.module] ?? ModuleAccessLevel.none;
    best = _maxLevel(best, lvl);
    if (best == ModuleAccessLevel.full) break;
  }
  return best;
});

final moduleAccessForEventFutureProvider =
    FutureProvider.family<ModuleAccessLevel, ({String eventId, String module})>((ref, args) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return ModuleAccessLevel.none;

  final event = await ref.watch(eventByIdStreamProvider(args.eventId).future);
  if (event != null && event.organizerId == user.id) return ModuleAccessLevel.full;

  final roles = await ref.watch(rolesForEventStreamProvider(args.eventId).future);
  if (roles.isEmpty) return ModuleAccessLevel.none;

  ModuleAccessLevel best = ModuleAccessLevel.none;
  for (final r in roles) {
    if (!r.userIds.contains(user.id)) continue;
    final lvl = r.moduleAccess[args.module] ?? ModuleAccessLevel.none;
    best = _maxLevel(best, lvl);
    if (best == ModuleAccessLevel.full) break;
  }
  return best;
});

final hasModuleAccessProvider = Provider.family<bool, ({String eventId, String module, ModuleAccessLevel required})>(
  (ref, args) {
    final actual = ref.watch(moduleAccessForEventProvider((eventId: args.eventId, module: args.module)));
    return hasAtLeastAccess(actual, args.required);
  },
);
