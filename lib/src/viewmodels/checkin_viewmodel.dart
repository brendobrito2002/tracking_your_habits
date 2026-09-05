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
}