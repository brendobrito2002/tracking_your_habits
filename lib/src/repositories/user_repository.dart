import '../datasources/user_datasource.dart';
import '../models/user.dart';

class UserRepository {
  final UserDataSource dataSource;

  UserRepository(this.dataSource);

  User? getUser(String id) {
    return dataSource.getUser(id);
  }

  Future<void> saveUser(User user) async {
    await dataSource.saveUser(user);
  }

  Future<void> updateUser(User user) async {
    await dataSource.updateUser(user);
  }
}