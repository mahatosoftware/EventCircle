import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/repositories/template_repository.dart';
import '../data/models/template_model.dart';
import 'auth_provider.dart';

final templateRepositoryProvider = Provider<TemplateRepository>((ref) {
  return TemplateRepository(FirebaseFirestore.instance);
});

final publicTemplatesProvider = StreamProvider<List<TemplateModel>>((ref) {
  final user = ref.watch(currentUserProvider);
  return ref.watch(templateRepositoryProvider).getSearchableTemplates(user?.id);
});

final templateByIdProvider = FutureProvider.family<TemplateModel?, String>((ref, id) {
  return ref.watch(templateRepositoryProvider).getTemplateById(id);
});

final selectedTemplateProvider = StateProvider<TemplateModel?>((ref) => null);
