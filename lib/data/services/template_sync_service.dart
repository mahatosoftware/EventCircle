import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/template_model.dart';
import '../system_templates/system_template_source.dart';
import 'template_firestore_dao.dart';
import 'template_version_manager.dart';
import '../constants/system_template_constants.dart';
import '../system_templates/system_template_models.dart';

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

  Future<String> syncSingleTemplate({
    required SystemTemplateDefinition def,
    required int packVersion,
    required int packSchemaVersion,
    String? remoteHash,
    bool force = false,
  }) async {
    try {
      final incoming = def.toTemplateModel(systemCreatedBy: systemTemplateCreatedBy);
      final localHash = incoming.config?['contentHash'];

      // Skip if not forced AND hash matches
      if (!force && remoteHash != null && remoteHash == localHash) {
        return 'skipped_hash';
      }

      // Needs update or creation
      final existing = await dao.getTemplateById(incoming.id);

      if (existing != null && existing.createdBy != systemTemplateCreatedBy) {
        debugPrint('TemplateSyncService: Skip "${incoming.id}" (not a system template).');
        return 'skipped_owner';
      }

      final isNew = existing == null;
      final toWrite = _mergePreservingStats(incoming, existing);

      await dao.upsertTemplate(
        toWrite,
        additionalFields: {
          'isSystem': true,
          'systemPackVersion': packVersion,
          'systemSchemaVersion': packSchemaVersion,
          'lastSyncedAt': FieldValue.serverTimestamp(),
          'contentHash': localHash,
        },
      );

      return isNew ? 'created' : 'updated';
    } catch (e, st) {
      debugPrint('TemplateSyncService: CRITICAL FAILURE for "${def.templateId}": $e\n$st');
      return 'failed';
    }
  }

  Future<void> syncTemplates({
    bool force = false,
    bool smartSync = false,
    void Function(int current, int total)? onProgress,
  }) async {
    final pack = await source.loadPack();
    if (pack == null) {
      debugPrint('TemplateSyncService: System templates JSON missing/corrupt. Sync skipped.');
      return;
    }

    final installed = await versionManager.getInstalledVersion();
    
    // 1. Fetch EVERYTHING from remote first to know what's truly missing
    debugPrint('TemplateSyncService: Fetching remote system templates...');
    final remoteTemplatesList = await dao.getAllSystemTemplates();
    final remoteMap = {for (var t in remoteTemplatesList) t.id: t};

    final hasContentChanges = pack.templates.any((def) {
      final remote = remoteMap[def.templateId];
      return remote == null || (def.contentHash != null && remote.config?['contentHash'] != def.contentHash);
    });

    final shouldSync = force || smartSync || pack.version > installed || hasContentChanges;

    if (!shouldSync) {
      debugPrint('TemplateSyncService: Already up to date (installed=$installed, asset=${pack.version}, remoteCount=${remoteMap.length}).');
      return;
    }

    if (pack.templates.isEmpty) {
      debugPrint('TemplateSyncService: Pack is empty. Marking version=${pack.version}.');
      await versionManager.setInstalledVersion(pack.version);
      return;
    }

    debugPrint('TemplateSyncService: Sync start (asset version=${pack.version}, local=${pack.templates.length}, remote=${remoteMap.length}, force=$force, smartSync=$smartSync)');
    
    int created = 0;
    int updated = 0;
    int skipped = 0;
    int failed = 0;

    final toUpsert = <TemplateModel>[];
    final total = pack.templates.length;

    // 2. Process locally to prepare the batch
    for (int i = 0; i < pack.templates.length; i++) {
      final def = pack.templates[i];
      try {
        final incoming = def.toTemplateModel(systemCreatedBy: systemTemplateCreatedBy);
        final existing = remoteMap[incoming.id];
        final isNew = existing == null;

        final localHash = def.contentHash;
        final remoteHash = existing?.config?['contentHash'] as String?;

        // Skip if hash matches and not forced
        if (!force && remoteHash != null && remoteHash == localHash) {
          skipped++;
          _reportProgress(i + 1, total, onProgress);
          continue;
        }

        // Check ownership
        if (existing != null && existing.createdBy != systemTemplateCreatedBy) {
          debugPrint('TemplateSyncService: Skip "${incoming.id}" (not a system template owner).');
          skipped++;
          _reportProgress(i + 1, total, onProgress);
          continue;
        }

        // Proactive validation
        try {
          incoming.toJson();
        } catch (e) {
          debugPrint('TemplateSyncService: [ERROR] VALIDATION FAILED for "${def.templateId}": $e');
          failed++;
          _reportProgress(i + 1, total, onProgress);
          continue;
        }

        final merged = _mergePreservingStats(incoming, existing);
        toUpsert.add(merged);
        
        if (isNew) created++; else updated++;
        debugPrint('TemplateSyncService: [SYNC] Queued "${def.templateName}" (${def.templateId})');
        _reportProgress(i + 1, total, onProgress);
      } catch (e) {
        debugPrint('TemplateSyncService: [ERROR] Failed to process "${def.templateId}": $e');
        failed++;
        _reportProgress(i + 1, total, onProgress);
      }
    }

    // 3. Commit all changes in chunks (Firestore limit is 500 per batch)
    if (toUpsert.isNotEmpty) {
      const int chunkSize = 400; // Safe margin
      for (int i = 0; i < toUpsert.length; i += chunkSize) {
        final end = (i + chunkSize < toUpsert.length) ? i + chunkSize : toUpsert.length;
        final chunk = toUpsert.sublist(i, end);
        
        debugPrint('TemplateSyncService: Committing chunk ${ (i ~/ chunkSize) + 1} (${chunk.length} templates)...');
        try {
          await dao.upsertTemplatesBatch(
            chunk,
            additionalFields: {
              'isSystem': true,
              'systemPackVersion': pack.version,
              'systemSchemaVersion': pack.schemaVersion,
              'lastSyncedAt': FieldValue.serverTimestamp(),
            },
          );
        } catch (e) {
          debugPrint('TemplateSyncService: [FATAL ERROR] Batch commit failed for chunk ${ (i ~/ chunkSize) + 1}: $e');
          rethrow;
        }
      }
    }

    // 4. Cleanup orphans (one batch of deletes if you like, but let's keep it simple for now as it's less frequent)
    int deleted = 0;
    try {
      final localIds = pack.templates.map((t) => t.templateId).toSet();
      final toDelete = remoteMap.keys.where((id) => !localIds.contains(id)).toList();
      
      if (toDelete.isNotEmpty) {
        debugPrint('TemplateSyncService: Cleaning up ${toDelete.length} orphaned templates...');
        await Future.wait(toDelete.map((id) => dao.deleteTemplate(id)));
        deleted = toDelete.length;
      }
    } catch (e) {
      debugPrint('TemplateSyncService: Cleanup error: $e');
    }

    await versionManager.setInstalledVersion(pack.version);
    debugPrint('TemplateSyncService: Sync operation summary - Created: $created, Updated: $updated, Deleted: $deleted, Skipped: $skipped, Failed: $failed');
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
