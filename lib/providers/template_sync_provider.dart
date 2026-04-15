import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/template_firestore_dao.dart';
import '../data/services/template_sync_service.dart';
import '../data/services/template_version_manager.dart';
import '../data/system_templates/asset_system_template_source.dart';
import '../data/system_templates/system_template_source.dart';

final systemTemplateSourceProvider = Provider<SystemTemplateSource>((ref) {
  return const AssetSystemTemplateSource();
});

final templateFirestoreDaoProvider = Provider<TemplateFirestoreDao>((ref) {
  return TemplateFirestoreDao(FirebaseFirestore.instance);
});

final templateVersionManagerProvider = Provider<TemplateVersionManager>((ref) {
  return TemplateVersionManager();
});

final templateSyncServiceProvider = Provider<TemplateSyncService>((ref) {
  return TemplateSyncService(
    source: ref.watch(systemTemplateSourceProvider),
    dao: ref.watch(templateFirestoreDaoProvider),
    versionManager: ref.watch(templateVersionManagerProvider),
  );
});

