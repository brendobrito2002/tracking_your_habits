import 'package:firebase_auth/firebase_auth.dart';

class AuthDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthDataSource({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<UserCredential> login(
      String email,
      String password,
      ) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> register(
      String name,
      String email,
      String password,
      ) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await credential.user?.updateDisplayName(name);

    await credential.user?.sendEmailVerification();

    return credential;
  }

  Future<void> resendEmailVerification() async {
    await _firebaseAuth.currentUser?.sendEmailVerification();
  }

  Future<bool> checkEmailVerified() async {
    await _firebaseAuth.currentUser?.reload();

    return _firebaseAuth.currentUser?.emailVerified ?? false;
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(
      email: email,
    );
  }

  User? get currentUser => _firebaseAuth.currentUser;
}