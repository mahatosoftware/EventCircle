import 'package:freezed_annotation/freezed_annotation.dart';

part 'audit_log_model.freezed.dart';
part 'audit_log_model.g.dart';

@freezed
class AuditLogModel with _$AuditLogModel {
  const factory AuditLogModel({
    required String id,
    required String eventId,
    required String userId, // User who performed the action
    required String action, // 'create', 'update', 'delete'
    required String entityType, // 'payment', 'member', 'event', etc.
    required String entityId,
    required DateTime timestamp,
    Map<String, dynamic>? previousData,
    Map<String, dynamic>? newData,
    String? reason,
  }) = _AuditLogModel;

  factory AuditLogModel.fromJson(Map<String, dynamic> json) => _$AuditLogModelFromJson(json);
}
