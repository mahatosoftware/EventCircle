import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/audit_log_model.dart';
import '../data/repositories/audit_log_repository.dart';
import 'event_provider.dart';

final auditLogRepositoryProvider = Provider<AuditLogRepository>((ref) => FirebaseAuditLogRepository());

final auditLogsStreamProvider = StreamProvider<List<AuditLogModel>>((ref) {
  final eventId = ref.watch(currentEventIdProvider);
  if (eventId == null) return Stream.value([]);
  return ref.watch(auditLogRepositoryProvider).getAuditLogs(eventId);
});

final auditLogsForEventStreamProvider = StreamProvider.family<List<AuditLogModel>, String>((ref, eventId) {
  return ref.watch(auditLogRepositoryProvider).getAuditLogs(eventId);
});
