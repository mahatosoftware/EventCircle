import '../models/user_model.dart';

abstract class AuthRepository {
  Stream<UserModel?> get authStateChanges;
  Future<UserModel?> loginWithEmailPassword(String email, String password);
  Future<UserModel?> registerWithEmailPassword(String email, String password);
  Future<UserModel?> loginWithGoogle();
  Future<void> logout();
  UserModel? get currentUser;
}
