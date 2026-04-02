import 'package:freezed_annotation/freezed_annotation.dart';

part 'vendor_model.freezed.dart';
part 'vendor_model.g.dart';

enum VendorStatus { searching, shortlisted, contracted, paid }

@freezed
class VendorModel with _$VendorModel {
  const factory VendorModel({
    required String id,
    required String eventId,
    required String title, // e.g. "Catering Service"
    required String role, // e.g. "Food and Beverages"
    @Default(VendorStatus.searching) VendorStatus status,
    String? name, // Actual vendor name after selection
    String? contact,
    String? selectionCriteria,
    String? suggestions, // AI/Blueprint suggestions
    double? quotedPrice,
    double? finalPrice,
  }) = _VendorModel;

  factory VendorModel.fromJson(Map<String, dynamic> json) => _$VendorModelFromJson(json);
}
