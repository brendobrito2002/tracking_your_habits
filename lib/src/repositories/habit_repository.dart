import '../datasources/habit_datasource.dart';
import '../models/habit.dart';

class HabitRepository {
  final HabitDataSource dataSource;

  HabitRepository(this.dataSource);

  List<Habit> getHabits(String userId) {
    return dataSource.getHabits(userId);
  }

  Future<void> addHabit(Habit habit) async {
    await dataSource.addHabit(habit);
  }

  Future<void> updateHabit(Habit habit) async {
    await dataSource.updateHabit(habit);
  }

  Future<void> deleteHabit(String id) async {
    await dataSource.deleteHabit(id);
  }
}