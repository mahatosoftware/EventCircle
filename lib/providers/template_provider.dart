import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/template_repository.dart';
import '../data/models/template_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final templateRepositoryProvider = Provider<TemplateRepository>((ref) {
  return TemplateRepository(FirebaseFirestore.instance);
});

final publicTemplatesProvider = StreamProvider<List<TemplateModel>>((ref) {
  return ref.watch(templateRepositoryProvider).getPublicTemplates();
});

final selectedTemplateProvider = StateProvider<TemplateModel?>((ref) => null);
