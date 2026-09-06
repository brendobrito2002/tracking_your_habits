import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/checkin_viewmodel.dart';
import '../../viewmodels/habit_viewmodel.dart';

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estatísticas'),
      ),
      body: Consumer2<CheckInViewModel, HabitViewModel>(
        builder: (
            context,
            checkInViewModel,
            habitViewModel,
            child,
            ) {
          final bestStreak = checkInViewModel.bestStreak;

          final successRate =
          checkInViewModel.getSuccessRate(
            habitViewModel.habits,
          );

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Desempenho',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 32),

                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 50,
                      sections: [
                        PieChartSectionData(
                          value: successRate * 100,
                          color: Colors.green,
                          title: '${(successRate * 100).round()}%',
                          radius: 70,
                          titleStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PieChartSectionData(
                          value: (1 - successRate) * 100,
                          color: Colors.red,
                          title: '',
                          radius: 70,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  'Taxa de sucesso: '
                      '${(successRate * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 32),

                Text(
                  '🔥 Melhor sequência: $bestStreak dias',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}