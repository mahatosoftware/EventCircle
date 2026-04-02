import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_model.freezed.dart';
part 'budget_model.g.dart';

@freezed
class BudgetItemModel with _$BudgetItemModel {
  const factory BudgetItemModel({
    required String id,
    required String eventId,
    required String category, // Venue, Food, Decoration, Miscellaneous
    required String title,
    required double estimatedCost,
    @Default(true) bool isMandatory,
    @Default(0.0) double actualCost, // Updated when an expense is linked
    String? note,
  }) = _BudgetItemModel;

  factory BudgetItemModel.fromJson(Map<String, dynamic> json) => _$BudgetItemModelFromJson(json);
}
