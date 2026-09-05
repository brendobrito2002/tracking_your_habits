import 'package:flutter/foundation.dart';

import '../models/habit.dart';
import '../repositories/habit_repository.dart';

class HabitViewModel extends ChangeNotifier {
  final HabitRepository repository;

  HabitViewModel(this.repository);

  List<Habit> _habits = [];

  List<Habit> get habits => List.unmodifiable(_habits);

  void loadHabits() {
    _habits = repository.getHabits();

    notifyListeners();
  }

  Future<void> addHabit(Habit habit) async {
    await repository.addHabit(habit);

    _habits = repository.getHabits();

    notifyListeners();
  }

  Future<void> updateHabit(Habit habit) async {
    await repository.updateHabit(habit);

    _habits = repository.getHabits();

    notifyListeners();
  }

  Future<void> deleteHabit(String id) async {
    await repository.deleteHabit(id);

    _habits = repository.getHabits();

    notifyListeners();
  }
}