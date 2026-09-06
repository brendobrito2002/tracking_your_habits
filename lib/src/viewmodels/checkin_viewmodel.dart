import 'package:flutter/foundation.dart';

import '../models/checkin.dart';
import '../models/habit.dart';
import '../repositories/checkin_repository.dart';
import 'user_viewmodel.dart';

class CheckInViewModel extends ChangeNotifier {
  final CheckInRepository repository;
  final UserViewModel userViewModel;

  CheckInViewModel(
      this.repository,
      this.userViewModel,
      );

  List<CheckIn> _checkIns = [];

  List<CheckIn> get checkIns => List.unmodifiable(_checkIns);

  void loadCheckIns(String userId) {
    _checkIns = repository.getCheckIns(userId);

    notifyListeners();
  }

  bool isCheckedIn(
      String habitId,
      String userId,
      DateTime date,
      ) {
    return repository.getCheckIn(
      habitId,
      userId,
      date,
    ) !=
        null;
  }

  int _getExperience(Habit habit) {
    switch (habit.frequency) {
      case 'Diário':
        return 10;

      case 'Semanal':
        return 70;

      case 'Personalizado':
        return 10 * habit.customDays.length;

      default:
        return 10;
    }
  }

  Future<void> checkIn({
    required Habit habit,
    required String userId,
    required DateTime date,
  }) async {
    final today = DateTime.now();

    final currentDate = DateTime(
      today.year,
      today.month,
      today.day,
    );

    final checkInDate = DateTime(
      date.year,
      date.month,
      date.day,
    );

    if (checkInDate.isAfter(currentDate)) {
      return;
    }

    final existingCheckIn = repository.getCheckIn(
      habit.id,
      userId,
      date,
    );

    if (existingCheckIn != null) {
      return;
    }

    final checkIn = CheckIn(
      id: '${habit.id}_${date.year}_${date.month}_${date.day}',
      habitId: habit.id,
      userId: userId,
      date: date,
    );

    await repository.addCheckIn(checkIn);

    final experience = _getExperience(habit);

    await userViewModel.addExperience(experience);

    _checkIns = repository.getCheckIns(userId);

    notifyListeners();
  }

  Future<void> removeCheckIn({
    required Habit habit,
    required String userId,
    required DateTime date,
  }) async {
    final existingCheckIn = repository.getCheckIn(
      habit.id,
      userId,
      date,
    );

    if (existingCheckIn == null) {
      return;
    }

    await repository.deleteCheckIn(existingCheckIn.id);

    final experience = _getExperience(habit);

    await userViewModel.removeExperience(experience);

    _checkIns = repository.getCheckIns(userId);

    notifyListeners();
  }

  int get bestStreak {
    if (_checkIns.isEmpty) {
      return 0;
    }

    final dates = _checkIns
        .map(
          (checkIn) => DateTime(
        checkIn.date.year,
        checkIn.date.month,
        checkIn.date.day,
      ),
    )
        .toSet()
        .toList();

    dates.sort();

    int best = 1;
    int current = 1;

    for (int i = 1; i < dates.length; i++) {
      final difference = dates[i].difference(dates[i - 1]).inDays;

      if (difference == 1) {
        current++;
      } else {
        current = 1;
      }

      if (current > best) {
        best = current;
      }
    }

    return best;
  }
}