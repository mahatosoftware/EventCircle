import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/vendor_model.dart';
import '../data/models/inventory_model.dart';
import '../data/repositories/vendor_inventory_repository.dart';
import 'event_provider.dart';
import 'access_control_provider.dart';
import '../data/models/event_role_model.dart';

final vendorRepositoryProvider = Provider<VendorRepository>((ref) {
  return _GuardedVendorRepository(ref, FirebaseVendorRepository());
});
final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) => FirebaseInventoryRepository());

final vendorsStreamProvider = StreamProvider<List<VendorModel>>((ref) {
  final eventId = ref.watch(currentEventIdProvider);
  if (eventId == null) return Stream.value([]);
  return ref.watch(vendorRepositoryProvider).getVendors(eventId);
});

final vendorsForEventStreamProvider = StreamProvider.family<List<VendorModel>, String>((ref, eventId) {
  return ref.watch(vendorRepositoryProvider).getVendors(eventId);
});

final inventoryStreamProvider = StreamProvider<List<InventoryItemModel>>((ref) {
  final eventId = ref.watch(currentEventIdProvider);
  if (eventId == null) return Stream.value([]);
  return ref.watch(inventoryRepositoryProvider).getInventory(eventId);
});

class _GuardedVendorRepository implements VendorRepository {
  final Ref _ref;
  final VendorRepository _delegate;

  _GuardedVendorRepository(this._ref, this._delegate);

  Future<void> _requireEdit(String eventId) async {
    final access = await _ref.read(moduleAccessForEventFutureProvider((eventId: eventId, module: EventModules.vendors)).future);
    if (!hasAtLeastAccess(access, ModuleAccessLevel.edit)) {
      throw StateError('No permission to manage vendors');
    }
  }

  @override
  Stream<List<VendorModel>> getVendors(String eventId) => _delegate.getVendors(eventId);

  @override
  Future<void> addVendor(VendorModel vendor) async {
    await _requireEdit(vendor.eventId);
    return _delegate.addVendor(vendor);
  }

  @override
  Future<void> updateVendor(VendorModel vendor) async {
    await _requireEdit(vendor.eventId);
    return _delegate.updateVendor(vendor);
  }
}
