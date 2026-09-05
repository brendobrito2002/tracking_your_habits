import 'package:hive/hive.dart';

import '../models/user.dart';

class UserDataSource {
  final Box<User> _userBox;

  UserDataSource({
    Box<User>? userBox,
  }) : _userBox = userBox ?? Hive.box<User>('users');

  User? getUser(String id) {
    return _userBox.get(id);
  }

  Future<void> saveUser(User user) async {
    await _userBox.put(user.id, user);
  }

  Future<void> updateUser(User user) async {
    await _userBox.put(user.id, user);
  }
}