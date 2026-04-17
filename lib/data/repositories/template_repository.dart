import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/template_model.dart';

class TemplateRepository {
  final FirebaseFirestore _firestore;

  TemplateRepository(this._firestore);

  Stream<List<TemplateModel>> getSearchableTemplates(String? userId) {
    return _firestore
        .collection('templates')
        .where('isPublic', isEqualTo: true)
        .orderBy('usageCount', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TemplateModel.fromJson({...doc.data(), 'id': doc.id}))
            .where((t) {
              final isSystem = t.createdBy == '__system__';
              final isMine = userId != null && t.createdBy == userId;
              return isSystem || isMine;
            })
            .toList());
  }

  Future<void> createTemplate(TemplateModel template) async {
    // If the template doesn't already have a code, generate one (for new creations)
    if (template.templateCode == null) {
      final code = _generateTemplateCode();
      template = template.copyWith(templateCode: code);
    }
    // Versioning starts at the default specified in the model
    await _firestore.collection('templates').doc(template.id).set(template.toDeepJson());
  }

  String _generateTemplateCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return List.generate(7, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  Future<void> updateTemplate(TemplateModel template) async {
    final updated = template.copyWith(version: template.version + 1);
    await _firestore.collection('templates').doc(template.id).update(updated.toDeepJson());
  }

  Future<void> incrementUsage(String templateId) async {
    await _firestore.collection('templates').doc(templateId).update({
      'usageCount': FieldValue.increment(1),
    });
  }

  Future<TemplateModel?> getTemplateById(String id) async {
    final doc = await _firestore.collection('templates').doc(id).get();
    if (!doc.exists) return null;
    return TemplateModel.fromJson({...doc.data()!, 'id': doc.id});
  }
}
