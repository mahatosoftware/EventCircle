import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/template_model.dart';

class TemplateFirestoreDao {
  final FirebaseFirestore firestore;
  final String collectionPath;

  const TemplateFirestoreDao(
    this.firestore, {
    this.collectionPath = 'templates',
  });

  CollectionReference<Map<String, dynamic>> get _col => firestore.collection(collectionPath);

  Future<bool> isTemplatesCollectionEmpty() async {
    final snap = await _col.limit(1).get();
    return snap.docs.isEmpty;
  }

  Future<TemplateModel?> getTemplateById(String templateId) async {
    final doc = await _col.doc(templateId).get();
    final data = doc.data();
    if (!doc.exists || data == null) return null;
    return TemplateModel.fromJson({...data, 'id': doc.id});
  }

  Future<void> upsertSystemTemplate(TemplateModel template) async {
    await upsertTemplate(template, additionalFields: const {'isSystem': true});
  }

  Future<void> upsertTemplate(
    TemplateModel template, {
    Map<String, dynamic> additionalFields = const {},
  }) async {
    final data = template.toDeepJson()..addAll(additionalFields);
    await _col.doc(template.id).set(data, SetOptions(merge: true));
  }
}
