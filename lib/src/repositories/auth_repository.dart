import 'package:firebase_auth/firebase_auth.dart';

import '../datasources/auth_datasource.dart';

class AuthException implements Exception {
  final String code;

  AuthException(this.code);
}

class AuthRepository {
  final AuthDataSource dataSource;

  AuthRepository(this.dataSource);

  Future<void> login(
      String email,
      String password,
      ) async {
    try {
      await dataSource.login(email, password);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code);
    }
  }

  Future<void> register(
      String name,
      String email,
      String password,
      ) async {
    try {
      await dataSource.register(name, email, password);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code);
    }
  }

  Future<void> resendEmailVerification() async {
    try {
      await dataSource.resendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code);
    }
  }

  Future<bool> checkEmailVerified() async {
    try {
      return await dataSource.checkEmailVerified();
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code);
    }
  }

  Future<void> logout() async {
    await dataSource.logout();
  }

  Future<void> resetPassword(String email) async {
    try {
      await dataSource.resetPassword(email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code);
    }
  }

  User? get currentUser => dataSource.currentUser;
}