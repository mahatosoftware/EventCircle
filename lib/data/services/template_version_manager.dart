import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class TemplateVersionManager {
  static const String _fileName = 'system_template_version.json';

  Future<int> getInstalledVersion() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) return 0;
      final raw = await file.readAsString();
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return 0;
      final v = decoded['installedVersion'];
      return (v is num) ? v.toInt() : 0;
    } catch (_) {
      return 0;
    }
  }

  Future<void> setInstalledVersion(int version) async {
    final file = await _getFile();
    await file.parent.create(recursive: true);
    await file.writeAsString(jsonEncode({'installedVersion': version, 'updatedAt': DateTime.now().toIso8601String()}));
  }

  Future<File> _getFile() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/$_fileName');
  }
}

