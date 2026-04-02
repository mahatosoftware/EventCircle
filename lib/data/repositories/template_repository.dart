import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/template_model.dart';

class TemplateRepository {
  final FirebaseFirestore _firestore;

  TemplateRepository(this._firestore);

  Stream<List<TemplateModel>> getPublicTemplates() {
    return _firestore
        .collection('templates')
        .where('isPublic', isEqualTo: true)
        .orderBy('usageCount', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TemplateModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  Future<void> createTemplate(TemplateModel template) async {
    await _firestore.collection('templates').doc(template.id).set(template.toDeepJson());
  }

  Future<void> incrementUsage(String templateId) async {
    await _firestore.collection('templates').doc(templateId).update({
      'usageCount': FieldValue.increment(1),
    });
  }
}
