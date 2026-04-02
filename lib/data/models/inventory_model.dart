import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_model.freezed.dart';
part 'inventory_model.g.dart';

enum InventoryStatus { needed, procured, consumed }

@freezed
class InventoryItemModel with _$InventoryItemModel {
  const factory InventoryItemModel({
    required String id,
    required String eventId,
    required String name,
    required double quantity,
    required String unit, // kg, pieces, etc.
    required String category, // Decoration, Food, etc.
    @Default(InventoryStatus.needed) InventoryStatus status,
    double? estimatedCost,
    String? responsibleRole,
    String? note,
  }) = _InventoryItemModel;

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) => _$InventoryItemModelFromJson(json);
}
