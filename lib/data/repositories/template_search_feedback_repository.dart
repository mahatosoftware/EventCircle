import 'package:cloud_firestore/cloud_firestore.dart';

class TemplateSearchFeedbackRepository {
  final FirebaseFirestore _firestore;
  final String collectionPath;

  const TemplateSearchFeedbackRepository(
    this._firestore, {
    this.collectionPath = 'template_search_feedback',
  });

  CollectionReference<Map<String, dynamic>> get _col => _firestore.collection(collectionPath);

  Future<void> logNoMatchQuery({
    required String query,
    String? userId,
    int? publicTemplateCount,
    int? systemMatchCount,
    int? customMatchCount,
    String screen = 'create_event_template_search',
  }) async {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return;

    // Store only one aggregated document per normalized query (no per-search
    // event documents) to avoid duplicate data and make demand ranking easy.
    final data = <String, dynamic>{
      'normalizedQuery': normalized,
      'count': FieldValue.increment(1),
      'lastSeenAt': FieldValue.serverTimestamp(),
      'latestQuery': query.trim(),
      'latestScreen': screen,
    };
    if (publicTemplateCount != null) data['publicTemplateCountLast'] = publicTemplateCount;
    if (systemMatchCount != null) data['systemMatchCountLast'] = systemMatchCount;
    if (customMatchCount != null) data['customMatchCountLast'] = customMatchCount;
    if (customMatchCount != null) {
      data['customMatchFoundCount'] = FieldValue.increment(customMatchCount > 0 ? 1 : 0);
      data['customMatchNotFoundCount'] = FieldValue.increment(customMatchCount > 0 ? 0 : 1);
    }
    if (userId != null && userId.trim().isNotEmpty) data['hasUserIdLast'] = true;

    final docId = 'q_${_fnv1a64Hex(normalized)}';
    await _col.doc(docId).set(data, SetOptions(merge: true));
  }

  String _fnv1a64Hex(String input) {
    const int fnvOffsetBasis = 0xcbf29ce484222325;
    const int fnvPrime = 0x100000001b3;
    const int mask64 = 0xFFFFFFFFFFFFFFFF;

    int hash = fnvOffsetBasis;
    for (final unit in input.codeUnits) {
      hash ^= unit;
      hash = (hash * fnvPrime) & mask64;
    }
    return hash.toRadixString(16).padLeft(16, '0');
  }
}
