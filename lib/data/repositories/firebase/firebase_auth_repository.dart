import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';
import '../auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAuthRepository() {
    GoogleSignIn.instance.initialize();
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return await _ensureUserDoc(user);
    });
  }

  @override
  UserModel? get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return UserModel(
      id: user.uid,
      name: user.displayName ?? '',
      phone: user.phoneNumber ?? '',
      email: user.email ?? '',
      role: UserRole.organizer,
    );
  }

  Future<UserModel> _ensureUserDoc(auth.User user) async {
    final uid = user.uid;
    final ref = _firestore.collection('users').doc(uid);
    final doc = await ref.get();

    final existing = doc.data();
    final existingName = (existing?['name'] as String?)?.trim() ?? '';
    final existingPhone = (existing?['phone'] as String?)?.trim() ?? '';
    final existingEmail = (existing?['email'] as String?)?.trim() ?? '';

    final derivedName = (user.displayName ?? '').trim().isNotEmpty
        ? user.displayName!.trim()
        : (existingName.isNotEmpty
            ? existingName
            : ((user.email ?? '').contains('@') ? user.email!.split('@').first : 'User'));
    final derivedPhone = (user.phoneNumber ?? '').trim().isNotEmpty ? user.phoneNumber!.trim() : existingPhone;
    final derivedEmail = (user.email ?? '').trim().isNotEmpty ? user.email!.trim() : existingEmail;

    final model = UserModel(
      id: uid,
      name: derivedName,
      phone: derivedPhone,
      email: derivedEmail,
      role: UserRole.organizer,
    );

    // Always upsert so the users table is populated and stays in sync.
    await ref.set(model.toJson(), SetOptions(merge: true));
    return model;
  }

  @override
  Future<UserModel?> loginWithEmailPassword(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (credential.user != null) {
      return await _ensureUserDoc(credential.user!);
    }
    return null;
  }

  @override
  Future<UserModel?> registerWithEmailPassword(String email, String password) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (credential.user != null) {
      final userModel = UserModel(
        id: credential.user!.uid,
        name: email.split('@')[0],
        phone: '',
        email: email,
        role: UserRole.organizer,
      );
      // Upsert ensures name/email/phone are present in users table.
      await _firestore.collection('users').doc(userModel.id).set(userModel.toJson(), SetOptions(merge: true));
      return await _ensureUserDoc(credential.user!);
    }
    return null;
  }

  @override
  Future<UserModel?> loginWithGoogle() async {
    await GoogleSignIn.instance.initialize();
    final googleUser = await GoogleSignIn.instance.authenticate();
    
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;
    final authorized = await googleUser.authorizationClient.authorizeScopes(['email', 'profile']);
    
    final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
      accessToken: authorized.accessToken,
      idToken: googleAuth.idToken,
    );
    
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    if (userCredential.user != null) {
      // This will create/update the user doc with best available details.
      return await _ensureUserDoc(userCredential.user!);
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await GoogleSignIn.instance.signOut();
    await _firebaseAuth.signOut();
  }
}
