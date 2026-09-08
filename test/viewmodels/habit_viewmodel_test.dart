import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_your_habits/src/models/habit.dart';
import 'package:tracking_your_habits/src/repositories/habit_repository.dart';
import 'package:tracking_your_habits/src/viewmodels/habit_viewmodel.dart';

import 'habit_viewmodel_test.mocks.dart';

@GenerateMocks([HabitRepository])
void main() {
  late MockHabitRepository repository;
  late HabitViewModel viewModel;

  setUp(() {
    repository = MockHabitRepository();
    viewModel = HabitViewModel(repository);
  });

  group('HabitViewModel', () {
    test('habits should start empty', () {
      expect(viewModel.habits, isEmpty);
    });

    test('loadHabits should load habits from repository', () {
      final habits = [
        Habit(
          id: '1',
          name: 'Estudar',
          description: 'Estudar Flutter',
          frequency: 'Diário',
          userId: 'user1',
          createdAt: DateTime(2026, 1, 1),
        ),
      ];

      when(repository.getHabits('user1')).thenReturn(habits);

      viewModel.loadHabits('user1');

      expect(viewModel.habits, equals(habits));
      verify(repository.getHabits('user1')).called(1);
    });

    test('addHabit should add the habit and reload the list', () async {
      final habit = Habit(
        id: '1',
        name: 'Estudar',
        description: 'Estudar Flutter',
        frequency: 'Diário',
        userId: 'user1',
        createdAt: DateTime(2026, 1, 1),
      );

      when(repository.addHabit(habit)).thenAnswer((_) async {});
      when(repository.getHabits('user1')).thenReturn([habit]);

      await viewModel.addHabit(habit);

      expect(viewModel.habits, equals([habit]));
      verify(repository.addHabit(habit)).called(1);
      verify(repository.getHabits('user1')).called(1);
    });

    test('updateHabit should update the habit and reload the list', () async {
      final habit = Habit(
        id: '1',
        name: 'Estudar Flutter',
        description: 'Estudar para a prova',
        frequency: 'Diário',
        userId: 'user1',
        createdAt: DateTime(2026, 1, 1),
      );

      when(repository.updateHabit(habit)).thenAnswer((_) async {});
      when(repository.getHabits('user1')).thenReturn([habit]);

      await viewModel.updateHabit(habit);

      expect(viewModel.habits, equals([habit]));
      verify(repository.updateHabit(habit)).called(1);
      verify(repository.getHabits('user1')).called(1);
    });

    test('deleteHabit should delete the habit and reload the list', () async {
      when(repository.deleteHabit('1')).thenAnswer((_) async {});
      when(repository.getHabits('user1')).thenReturn([]);

      await viewModel.deleteHabit('1', 'user1');

      expect(viewModel.habits, isEmpty);
      verify(repository.deleteHabit('1')).called(1);
      verify(repository.getHabits('user1')).called(1);
    });
  });
}