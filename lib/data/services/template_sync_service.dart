import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/template_model.dart';
import '../system_templates/system_template_source.dart';
import 'template_firestore_dao.dart';
import 'template_version_manager.dart';
import '../constants/system_template_constants.dart';

class TemplateSyncService {
  final SystemTemplateSource source;
  final TemplateFirestoreDao dao;
  final TemplateVersionManager versionManager;

  const TemplateSyncService({
    required this.source,
    required this.dao,
    required this.versionManager,
  });

  Future<void> loadTemplatesIfNeeded() async {
    final empty = await dao.isTemplatesCollectionEmpty();
    if (!empty) {
      debugPrint('TemplateSyncService: Templates collection is not empty. Skipping seed.');
      return;
    }
    debugPrint('TemplateSyncService: Templates collection is empty. Seeding system templates...');
    await syncTemplates(force: true);
  }

  Future<bool> checkForTemplateUpdates() async {
    final pack = await source.loadPack();
    if (pack == null) {
      debugPrint('TemplateSyncService: No system template pack found. Skipping update check.');
      return false;
    }
    final installed = await versionManager.getInstalledVersion();
    final hasUpdate = pack.version > installed;
    debugPrint('TemplateSyncService: Update check - installed=$installed asset=${pack.version} hasUpdate=$hasUpdate');
    return hasUpdate;
  }

  Future<void> syncTemplates({
    bool force = false,
    void Function(int current, int total)? onProgress,
  }) async {
    final pack = await source.loadPack();
    if (pack == null) {
      debugPrint('TemplateSyncService: System templates JSON missing/corrupt. Sync skipped.');
      return;
    }

    final installed = await versionManager.getInstalledVersion();
    final shouldSync = force || pack.version > installed;
    if (!shouldSync) {
      debugPrint('TemplateSyncService: Already up to date (installed=$installed, asset=${pack.version}).');
      return;
    }

    if (pack.templates.isEmpty) {
      debugPrint('TemplateSyncService: Pack is empty. Marking version=${pack.version}.');
      await versionManager.setInstalledVersion(pack.version);
      return;
    }

    int created = 0;
    int updated = 0;
    int skipped = 0;
    int failed = 0;

    debugPrint('TemplateSyncService: Sync start (installed=$installed, asset=${pack.version}, templates=${pack.templates.length})');

    int current = 0;
    final total = pack.templates.length;

    final results = await Future.wait(pack.templates.map((def) async {
      try {
        final incoming = def.toTemplateModel(systemCreatedBy: systemTemplateCreatedBy);
        final existing = await dao.getTemplateById(incoming.id);

        if (existing != null && existing.createdBy != systemTemplateCreatedBy) {
          debugPrint('TemplateSyncService: Skip "${incoming.id}" (existing createdBy=${existing.createdBy})');
          _reportProgress(++current, total, onProgress);
          return 'skipped';
        }

        final toWrite = _mergePreservingStats(incoming, existing);
        await dao.upsertTemplate(
          toWrite,
          additionalFields: {
            'isSystem': true,
            'systemPackVersion': pack.version,
            'systemSchemaVersion': pack.schemaVersion,
          },
        );
        _reportProgress(++current, total, onProgress);
        return existing == null ? 'created' : 'updated';
      } catch (e, st) {
        debugPrint('TemplateSyncService: Failed to sync template "${def.templateId}": $e\n$st');
        _reportProgress(++current, total, onProgress);
        return 'failed';
      }
    }));

    for (final res in results) {
      if (res == 'created') created++;
      else if (res == 'updated') updated++;
      else if (res == 'skipped') skipped++;
      else failed++;
    }

    await versionManager.setInstalledVersion(pack.version);
    debugPrint('TemplateSyncService: Sync done (created=$created updated=$updated skipped=$skipped failed=$failed version=${pack.version})');
  }

  void _reportProgress(int current, int total, void Function(int, int)? onProgress) {
    onProgress?.call(current, total);
  }

  TemplateModel _mergePreservingStats(TemplateModel incoming, TemplateModel? existing) {
    if (existing == null) return incoming;
    return incoming.copyWith(
      usageCount: existing.usageCount,
      rating: existing.rating,
      createdAt: existing.createdAt,
      templateCode: existing.templateCode ?? incoming.templateCode,
    );
  }
}
