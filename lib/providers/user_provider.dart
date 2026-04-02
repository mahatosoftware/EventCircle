import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/user_model.dart';
import '../data/repositories/firebase/firebase_user_repository.dart';
import '../data/repositories/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) => FirebaseUserRepository());

final userByIdProvider = FutureProvider.family<UserModel?, String>((ref, userId) async {
  return ref.watch(userRepositoryProvider).getUserById(userId);
});

