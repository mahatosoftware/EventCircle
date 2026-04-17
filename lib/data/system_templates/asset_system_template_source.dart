import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'system_template_models.dart';
import 'system_template_source.dart';

class AssetSystemTemplateSource implements SystemTemplateSource {
  final String manifestPath;

  const AssetSystemTemplateSource({
    this.manifestPath = 'assets/template/templates_manifest.json',
  });

  @override
  Future<SystemTemplatePack?> loadPack() async {
    try {
      // 1. Load the manual manifest
      final manifestRaw = await rootBundle.loadString(manifestPath);
      final manifestJson = jsonDecode(manifestRaw);
      
      if (manifestJson is! Map<String, dynamic> || manifestJson['templates'] is! List) {
        debugPrint('AssetSystemTemplateSource: Invalid manifest format in "$manifestPath"');
        return null;
      }

      final templatePaths = (manifestJson['templates'] as List).cast<String>();
      final allTemplates = <SystemTemplateDefinition>[];
      int maxSchemaVersion = 1;
      int maxPackVersion = 1;

      // 2. Load only the templates listed in the manifest
      for (final path in templatePaths) {
        try {
          final raw = await rootBundle.loadString(path);
          
          // Calculate content hash for delta sync
          final hash = sha256.convert(utf8.encode(raw)).toString();
          
          final decoded = jsonDecode(raw);
          if (decoded is! Map<String, dynamic>) continue;

          final pack = SystemTemplatePack.fromJson(decoded, contentHash: hash);
          
          allTemplates.addAll(pack.templates);
          
          if (pack.schemaVersion > maxSchemaVersion) {
            maxSchemaVersion = pack.schemaVersion;
          }
          if (pack.version > maxPackVersion) {
            maxPackVersion = pack.version;
          }
        } catch (e) {
          debugPrint('AssetSystemTemplateSource: Error loading template at $path: $e');
        }
      }

      if (allTemplates.isEmpty) return null;

      return SystemTemplatePack(
        schemaVersion: maxSchemaVersion,
        version: maxPackVersion,
        templates: allTemplates,
      );
    } catch (e) {
      debugPrint('AssetSystemTemplateSource: Failed to load manifest "$manifestPath": $e');
      return null;
    }
  }
}
