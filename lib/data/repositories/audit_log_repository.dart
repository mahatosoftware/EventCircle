import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/audit_log_model.dart';

abstract class AuditLogRepository {
  Future<void> logAction(AuditLogModel log);
  Stream<List<AuditLogModel>> getAuditLogs(String eventId);
}

class FirebaseAuditLogRepository implements AuditLogRepository {
  final _db = FirebaseFirestore.instance;

  @override
  Future<void> logAction(AuditLogModel log) async {
    await _db.collection('events').doc(log.eventId).collection('auditLogs').doc(log.id).set(log.toJson());
  }

  @override
  Stream<List<AuditLogModel>> getAuditLogs(String eventId) {
    return _db.collection('events').doc(eventId).collection('auditLogs')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => AuditLogModel.fromJson(d.data())).toList());
  }
}
