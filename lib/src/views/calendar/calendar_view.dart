import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/habit.dart';
import '../../viewmodels/checkin_viewmodel.dart';
import '../../viewmodels/habit_viewmodel.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();

    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        context.read<HabitViewModel>().loadHabits(firebaseUser.uid);
        context.read<CheckInViewModel>().loadCheckIns(firebaseUser.uid);
      });
    }
  }

  bool _isHabitScheduledForDay(
      Habit habit,
      DateTime day,
      ) {
    switch (habit.frequency) {
      case 'Diário':
        return true;

      case 'Semanal':
        return habit.customDays.contains(day.weekday);

      case 'Personalizado':
        return habit.customDays.contains(day.weekday);

      default:
        return false;
    }
  }

  bool _isCheckedIn(
      Habit habit,
      DateTime day,
      CheckInViewModel checkInViewModel,
      ) {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      return false;
    }

    return checkInViewModel.isCheckedIn(
      habit.id,
      firebaseUser.uid,
      day,
    );
  }

  List<Habit> _getHabitsForDay(
      DateTime day,
      HabitViewModel habitViewModel,
      ) {
    return habitViewModel.habits
        .where((habit) => _isHabitScheduledForDay(habit, day))
        .toList();
  }

  List<Habit> _getCompletedHabitsForDay(
      DateTime day,
      HabitViewModel habitViewModel,
      CheckInViewModel checkInViewModel,
      ) {
    return _getHabitsForDay(day, habitViewModel)
        .where(
          (habit) => _isCheckedIn(
        habit,
        day,
        checkInViewModel,
      ),
    )
        .toList();
  }

  List<Habit> _getPendingHabitsForDay(
      DateTime day,
      HabitViewModel habitViewModel,
      CheckInViewModel checkInViewModel,
      ) {
    return _getHabitsForDay(day, habitViewModel)
        .where(
          (habit) => !_isCheckedIn(
        habit,
        day,
        checkInViewModel,
      ),
    )
        .toList();
  }

  String _getMonthName(DateTime date) {
    const months = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];

    return months[date.month - 1];
  }

  void _previousMonth() {
    setState(() {
      _focusedDay = DateTime(
        _focusedDay.year,
        _focusedDay.month - 1,
        1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedDay = DateTime(
        _focusedDay.year,
        _focusedDay.month + 1,
        1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendário'),
      ),
      body: Consumer2<CheckInViewModel, HabitViewModel>(
        builder: (
            context,
            checkInViewModel,
            habitViewModel,
            child,
            ) {
          final completedHabits = _getCompletedHabitsForDay(
            _selectedDay,
            habitViewModel,
            checkInViewModel,
          );

          final pendingHabits = _getPendingHabitsForDay(
            _selectedDay,
            habitViewModel,
            checkInViewModel,
          );

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: _previousMonth,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          '${_getMonthName(_focusedDay)} ${_focusedDay.year}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: _nextMonth,
                    ),
                  ],
                ),
              ),

              TableCalendar(
                locale: 'pt_BR',
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2035, 12, 31),
                focusedDay: _focusedDay,
                headerVisible: false,

                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },

                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },

                eventLoader: (day) {
                  return _getCompletedHabitsForDay(
                    day,
                    habitViewModel,
                    checkInViewModel,
                  );
                },

                calendarStyle: const CalendarStyle(
                  markerSize: 8,
                  markersMaxCount: 3,
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  children: [
                    ...completedHabits.map(
                          (habit) {
                        return ListTile(
                          leading: const Icon(
                            Icons.check_circle,
                          ),
                          title: Text(habit.name),
                          subtitle: Text(
                            habit.description,
                          ),
                        );
                      },
                    ),

                    ...pendingHabits.map(
                          (habit) {
                        return ListTile(
                          leading: const Icon(
                            Icons.radio_button_unchecked,
                          ),
                          title: Text(habit.name),
                          subtitle: Text(
                            habit.description,
                          ),
                        );
                      },
                    ),

                    if (completedHabits.isEmpty &&
                        pendingHabits.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 32),
                        child: Center(
                          child: Text(
                            'Nenhum hábito previsto para este dia.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}