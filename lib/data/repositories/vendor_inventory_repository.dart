import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vendor_model.dart';
import '../models/inventory_model.dart';

abstract class VendorRepository {
  Stream<List<VendorModel>> getVendors(String eventId);
  Future<void> addVendor(VendorModel vendor);
  Future<void> updateVendor(VendorModel vendor);
}

class FirebaseVendorRepository implements VendorRepository {
  final _db = FirebaseFirestore.instance;

  @override
  Stream<List<VendorModel>> getVendors(String eventId) {
    return _db.collection('events').doc(eventId).collection('vendors')
        .snapshots().map((s) => s.docs.map((d) => VendorModel.fromJson(d.data())).toList());
  }

  @override
  Future<void> addVendor(VendorModel vendor) =>
      _db.collection('events').doc(vendor.eventId).collection('vendors').doc(vendor.id).set(vendor.toJson());

  @override
  Future<void> updateVendor(VendorModel vendor) =>
      _db.collection('events').doc(vendor.eventId).collection('vendors').doc(vendor.id).update(vendor.toJson());
}

abstract class InventoryRepository {
  Stream<List<InventoryItemModel>> getInventory(String eventId);
  Future<void> addInventoryItem(InventoryItemModel item);
  Future<void> updateInventoryItem(InventoryItemModel item);
}

class FirebaseInventoryRepository implements InventoryRepository {
  final _db = FirebaseFirestore.instance;

  @override
  Stream<List<InventoryItemModel>> getInventory(String eventId) {
    return _db.collection('events').doc(eventId).collection('inventory')
        .snapshots().map((s) => s.docs.map((d) => InventoryItemModel.fromJson(d.data())).toList());
  }

  @override
  Future<void> addInventoryItem(InventoryItemModel item) =>
      _db.collection('events').doc(item.eventId).collection('inventory').doc(item.id).set(item.toJson());

  @override
  Future<void> updateInventoryItem(InventoryItemModel item) =>
      _db.collection('events').doc(item.eventId).collection('inventory').doc(item.id).update(item.toJson());
}
