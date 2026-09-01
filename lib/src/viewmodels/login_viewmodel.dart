import 'package:flutter/foundation.dart';

import '../repositories/auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository repository;

  LoginViewModel(this.repository);

  bool _isLoading = false;
  String? _errorCode;

  bool get isLoading => _isLoading;
  String? get errorCode => _errorCode;

  Future<bool> login(
    String email,
    String password,
  ) async {
    _isLoading = true;
    _errorCode = null;

    notifyListeners();

    try {
      await repository.login(email, password);

      return true;
    } on AuthException catch (e) {
      _errorCode = e.code;

      return false;
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  void clearError() {
    _errorCode = null;

    notifyListeners();
  }
}