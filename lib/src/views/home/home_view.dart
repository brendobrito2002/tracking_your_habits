import 'dart:io';
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
import '../statistics/statistics_view.dart';
import '../../viewmodels/habit_viewmodel.dart';
import '../../viewmodels/theme_viewmodel.dart';
import '../../viewmodels/photo_viewmodel.dart';

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

        context.read<HabitViewModel>().loadHabits(
          firebaseUser.uid,
        );

        context.read<PhotoViewModel>().loadPhoto(
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
            icon: Icon(
              context.watch<ThemeViewModel>().themeMode == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              context.read<ThemeViewModel>().toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: l10n.logout,
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

          return SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),

                if (user != null) ...[
                  Consumer<PhotoViewModel>(
                    builder: (context, photoViewModel, child) {
                      return GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SafeArea(
                                child: Wrap(
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.camera_alt),
                                      title: Text(l10n.takePhoto),
                                      onTap: () {
                                        Navigator.pop(context);
                                        photoViewModel.takePhoto(
                                          FirebaseAuth.instance.currentUser!.uid,
                                        );
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.photo_library),
                                      title: Text(l10n.chooseFromGallery),
                                      onTap: () {
                                        Navigator.pop(context);
                                        photoViewModel.pickPhoto(
                                          FirebaseAuth.instance.currentUser!.uid,
                                        );
                                      },
                                    ),
                                    if (photoViewModel.photoPath != null)
                                      ListTile(
                                        leading: const Icon(Icons.delete),
                                        title: Text(l10n.removePhoto),
                                        onTap: () {
                                          Navigator.pop(context);

                                          photoViewModel.removePhoto(
                                            FirebaseAuth.instance.currentUser!.uid,
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: photoViewModel.photoPath != null
                              ? FileImage(
                            File(photoViewModel.photoPath!),
                          )
                              : null,
                          child: photoViewModel.photoPath == null
                              ? const Icon(
                            Icons.person,
                            size: 50,
                          )
                              : null,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.level(user.level),
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
                          Text(
                            l10n.bestStreak,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.days(checkInViewModel.bestStreak),
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
              ],
            ),
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
                tooltip: l10n.calendar,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CalendarView(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 24),
              IconButton(
                icon: const Icon(Icons.bar_chart),
                tooltip: l10n.statistics,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const StatisticsView(),
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