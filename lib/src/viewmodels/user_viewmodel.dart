import 'package:flutter/foundation.dart';

import '../models/user.dart';
import '../repositories/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository repository;

  UserViewModel(this.repository);

  User? _user;

  User? get user => _user;

  int get level => _user?.level ?? 1;

  int get experience => _user?.experience ?? 0;

  int get requiredExperience {
    return 100 + ((level - 1) * 50);
  }

  double get experienceProgress {
    if (requiredExperience == 0) {
      return 0;
    }

    return experience / requiredExperience;
  }

  void loadUser(String id) {
    _user = repository.getUser(id);

    notifyListeners();
  }

  Future<void> loadOrCreateUser({
    required String id,
    required String name,
    required String email,
  }) async {
    final existingUser = repository.getUser(id);

    if (existingUser != null) {
      _user = existingUser;
      notifyListeners();
      return;
    }

    final newUser = User(
      id: id,
      name: name,
      email: email,
    );

    await repository.saveUser(newUser);

    _user = newUser;

    notifyListeners();
  }

  Future<void> saveUser(User user) async {
    await repository.saveUser(user);

    _user = user;

    notifyListeners();
  }

  Future<void> addExperience(int amount) async {
    if (_user == null) {
      return;
    }

    _user!.experience += amount;

    while (_user!.experience >= requiredExperience) {
      _user!.experience -= requiredExperience;
      _user!.level++;
    }

    await repository.updateUser(_user!);

    notifyListeners();
  }
}