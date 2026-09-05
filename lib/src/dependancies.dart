import 'package:provider/provider.dart';

import 'datasources/auth_datasource.dart';
import 'repositories/auth_repository.dart';
import 'viewmodels/login_viewmodel.dart';

import 'datasources/habit_datasource.dart';
import 'repositories/habit_repository.dart';
import 'viewmodels/habit_viewmodel.dart';

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

  Provider<HabitDataSource>(
    create: (_) => HabitDataSource(),
  ),

  Provider<HabitRepository>(
    create: (context) {
      return HabitRepository(
        context.read<HabitDataSource>(),
      );
    },
  ),

  ChangeNotifierProvider<HabitViewModel>(
    create: (context) {
      final viewModel = HabitViewModel(
        context.read<HabitRepository>(),
      );

      viewModel.loadHabits();

      return viewModel;
    },
  ),
];