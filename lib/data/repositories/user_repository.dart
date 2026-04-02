import '../models/user_model.dart';

abstract class UserRepository {
  Future<UserModel?> getUserById(String userId);

  /// Returns users matching email/phone exactly (or by prefix when supported).
  ///
  /// Keep this lightweight; for large datasets, prefer server-side search/indexing later.
  Future<List<UserModel>> searchUsers(String query);

  Future<void> upsertUser(UserModel user);
}
