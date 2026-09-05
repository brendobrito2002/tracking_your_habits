import 'package:hive/hive.dart';

import '../models/habit.dart';

class HabitDataSource {
  final Box<Habit> _habitBox;

  HabitDataSource({
    Box<Habit>? habitBox,
  }) : _habitBox = habitBox ?? Hive.box<Habit>('habits');

  List<Habit> getHabits() {
    return _habitBox.values.toList();
  }

  Future<void> addHabit(Habit habit) async {
    await _habitBox.put(habit.id, habit);
  }

  Future<void> updateHabit(Habit habit) async {
    await _habitBox.put(habit.id, habit);
  }

  Future<void> deleteHabit(String id) async {
    await _habitBox.delete(id);
  }
}