import 'package:flutter/foundation.dart';
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

  Future<List<String>> getSystemTemplateIds() async {
    final snap = await _col.where('isSystem', isEqualTo: true).get();
    return snap.docs.map((d) => d.id).toList();
  }

  Future<void> deleteTemplate(String templateId) async {
    await _col.doc(templateId).delete();
  }

  Future<Map<String, String?>> getSystemTemplateHashes() async {
    final snap = await _col.where('isSystem', isEqualTo: true).get();
    return {
      for (var doc in snap.docs) doc.id: doc.data()['contentHash'] as String?,
    };
  }

  Future<List<TemplateModel>> getAllSystemTemplates() async {
    final snap = await _col.where('isSystem', isEqualTo: true).get();
    return snap.docs
        .map((doc) => TemplateModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  Future<void> upsertTemplatesBatch(List<TemplateModel> templates, {Map<String, dynamic>? additionalFields}) async {
    final batch = firestore.batch();
    for (final template in templates) {
      try {
        final data = template.toDeepJson()..addAll(additionalFields ?? {});
        batch.set(_col.doc(template.id), data, SetOptions(merge: true));
      } catch (e) {
        debugPrint('TemplateFirestoreDao: Failed to serialize template "${template.id}": $e');
        rethrow;
      }
    }
    await batch.commit();
  }
}
