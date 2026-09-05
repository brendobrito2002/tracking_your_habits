import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/../l10n/app_localizations.dart';
import '../../models/habit.dart';
import '../../viewmodels/habit_viewmodel.dart';

class HabitFormView extends StatefulWidget {
  final Habit? habit;

  const HabitFormView({super.key, this.habit});

  @override
  State<HabitFormView> createState() => _HabitFormViewState();
}

class _HabitFormViewState extends State<HabitFormView> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _frequency = 'Diário';

  final List<int> _customDays = [];

  @override
  void initState() {
    super.initState();

    final habit = widget.habit;

    if (habit != null) {
      _nameController.text = habit.name;
      _descriptionController.text = habit.description;
      _frequency = habit.frequency;
      _customDays.addAll(habit.customDays);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveHabit() async {
    final l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_frequency == 'Personalizado' && _customDays.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.selectCustomDay)));
      return;
    }

    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      return;
    }

    final habit = Habit(
      id: widget.habit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      frequency: _frequency,
      customDays: _frequency == 'Personalizado' ? List.from(_customDays) : [],
      userId: firebaseUser.uid,
    );

    final viewModel = context.read<HabitViewModel>();

    if (widget.habit == null) {
      await viewModel.addHabit(habit);
    } else {
      await viewModel.updateHabit(habit);
    }

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final List<String> weekDays = [
      l10n.monday,
      l10n.tuesday,
      l10n.wednesday,
      l10n.thursday,
      l10n.friday,
      l10n.saturday,
      l10n.sunday,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit == null ? l10n.newHabit : l10n.editHabit),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.name,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.enterHabitName;
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: l10n.description,
                  border: const OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _frequency,
                decoration: InputDecoration(
                  labelText: l10n.frequency,
                  border: const OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(value: 'Diário', child: Text(l10n.daily)),
                  DropdownMenuItem(value: 'Semanal', child: Text(l10n.weekly)),
                  DropdownMenuItem(
                    value: 'Personalizado',
                    child: Text(l10n.custom),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _frequency = value;
                    });
                  }
                },
              ),

              if (_frequency == 'Personalizado') ...[
                const SizedBox(height: 16),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.customDays,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                ...List.generate(weekDays.length, (index) {
                  final day = index + 1;

                  return CheckboxListTile(
                    title: Text(weekDays[index]),
                    value: _customDays.contains(day),
                    contentPadding: EdgeInsets.zero,
                    onChanged: (selected) {
                      setState(() {
                        if (selected == true) {
                          _customDays.add(day);
                        } else {
                          _customDays.remove(day);
                        }
                      });
                    },
                  );
                }),
              ],

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveHabit,
                  child: Text(
                    widget.habit == null ? l10n.saveHabit : l10n.saveChanges,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
