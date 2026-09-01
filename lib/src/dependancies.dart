import 'package:provider/provider.dart';

import 'datasources/auth_datasource.dart';
import 'repositories/auth_repository.dart';
import 'viewmodels/login_viewmodel.dart';

final appProviders = [
  Provider<AuthDataSource>(
    create: (_) => AuthDataSource(),
  ),

  Provider<AuthRepository>(
    create: (context) {
      return AuthRepository(
        context.read<AuthDataSource>(),
      );
    },
  ),

  ChangeNotifierProvider<LoginViewModel>(
    create: (context) {
      return LoginViewModel(
        context.read<AuthRepository>(),
      );
    },
  ),
];