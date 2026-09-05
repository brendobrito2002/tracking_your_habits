import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/../l10n/app_localizations.dart';
import '../../viewmodels/habit_viewmodel.dart';
import 'habits_form_view.dart';

class HabitsView extends StatefulWidget {
  const HabitsView({super.key});

  @override
  State<HabitsView> createState() => _HabitsViewState();
}

class _HabitsViewState extends State<HabitsView> {
  @override
  void initState() {
    super.initState();

    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        context.read<HabitViewModel>().loadHabits(firebaseUser.uid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.habits)),
      body: Consumer<HabitViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.habits.isEmpty) {
            return Center(
              child: Text(
                l10n.noHabits,
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.habits.length,
            itemBuilder: (context, index) {
              final habit = viewModel.habits[index];

              return Card(
                child: ListTile(
                  title: Text(habit.name),
                  subtitle: Text(habit.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        switch (habit.frequency) {
                          'Diário' => l10n.daily,
                          'Semanal' => l10n.weekly,
                          'Personalizado' => l10n.custom,
                          _ => habit.frequency,
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: l10n.editHabit,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HabitFormView(habit: habit),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: l10n.deleteHabit,
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(l10n.deleteHabit),
                                content: Text(
                                  l10n.deleteHabitConfirmation(habit.name),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: Text(l10n.cancel),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    child: Text(l10n.deleteHabit),
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirm == true) {
                            await context
                                .read<HabitViewModel>()
                                .deleteHabit(
                              habit.id,
                              habit.userId,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const HabitFormView(),
            ),
          );
        },
        tooltip: l10n.newHabit,
        child: const Icon(Icons.add),
      ),
    );
  }
}