import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/template_search_feedback_repository.dart';

final templateSearchFeedbackRepositoryProvider = Provider<TemplateSearchFeedbackRepository>((ref) {
  return TemplateSearchFeedbackRepository(FirebaseFirestore.instance);
});

