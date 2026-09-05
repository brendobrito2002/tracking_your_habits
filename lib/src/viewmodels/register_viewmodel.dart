import 'package:flutter/foundation.dart';

import '../repositories/auth_repository.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthRepository repository;

  RegisterViewModel(this.repository);

  bool _isLoading = false;
  String? _errorCode;

  bool get isLoading => _isLoading;
  String? get errorCode => _errorCode;

  Future<bool> register(
      String name,
      String email,
      String password,
      ) async {
    _isLoading = true;
    _errorCode = null;

    notifyListeners();

    try {
      await repository.register(name, email, password);
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