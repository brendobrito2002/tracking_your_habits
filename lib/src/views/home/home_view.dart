import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/../l10n/app_localizations.dart';
import '../habits/habits_view.dart';
import '../login/login_view.dart';
import '../../repositories/auth_repository.dart';
import '../../viewmodels/user_viewmodel.dart';
import '../calendar/calendar_view.dart';
import '../../viewmodels/checkin_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();

    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        context.read<UserViewModel>().loadOrCreateUser(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
        );

        context.read<CheckInViewModel>().loadCheckIns(
          firebaseUser.uid,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () async {
              await context.read<AuthRepository>().logout();

              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginView(),
                ),
                    (route) => false,
              );
            },
          ),
        ],
      ),
      body: Consumer<UserViewModel>(
        builder: (context, viewModel, child) {
          final user = viewModel.user;

          return Column(
            children: [
              const SizedBox(height: 24),

              if (user != null) ...[
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Nível ${user.level}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${user.experience} XP / ${viewModel.requiredExperience} XP',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),

                Consumer<CheckInViewModel>(
                  builder: (context, checkInViewModel, child) {
                    return Column(
                      children: [
                        const SizedBox(height: 12),
                        const Text(
                          '🔥 Melhor sequência',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${checkInViewModel.bestStreak} dia(s)',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],

              const SizedBox(height: 24),

              Center(
                child: Text(l10n.loginSuccess),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.check_circle_outline),
                tooltip: l10n.habits,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HabitsView(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 24),
              IconButton(
                icon: const Icon(Icons.calendar_month),
                tooltip: 'Calendário',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CalendarView(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}