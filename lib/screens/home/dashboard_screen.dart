import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final pieData = _buildPieData(appState);
    final lineData = _buildWeeklySpots(appState);
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Health insights',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(color: primary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              'Visualise your recent progress and keep the momentum going.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: 'Daily contribution by habit',
              child: pieData.isEmpty
                  ? const _PlaceholderMessage(
                      message:
                          'Log meals, sleep, workouts or medication to see how your day is balanced.',
                    )
                  : SizedBox(
                      height: 220,
                      child: PieChart(
                        PieChartData(
                          sections: pieData,
                          centerSpaceRadius: 40,
                          sectionsSpace: 3,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 25),
            _buildSectionCard(
              title: 'Sleep trend over the last 7 days',
              child: lineData.isEmpty
                  ? const _PlaceholderMessage(
                      message:
                          'Add sleep sessions to unlock your weekly trend.',
                    )
                  : SizedBox(
                      height: 220,
                      child: LineChart(
                        LineChartData(
                          backgroundColor: Colors.white,
                          gridData: const FlGridData(show: true),
                          borderData: FlBorderData(show: true),
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: true),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, _) {
                                  const labels = [
                                    'Mon',
                                    'Tue',
                                    'Wed',
                                    'Thu',
                                    'Fri',
                                    'Sat',
                                    'Sun'
                                  ];
                                  final index = value.toInt();
                                  if (index >= 0 && index < labels.length) {
                                    return Text(labels[index]);
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              isCurved: true,
                              color: primary,
                              barWidth: 4,
                              dotData: const FlDotData(show: true),
                              belowBarData: BarAreaData(
                                show: true,
                                color: primary.withAlpha(26),
                              ),
                              spots: lineData,
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 25),
            _buildSectionCard(
              title: 'Highlights',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calories consumed today: ${appState.totalFoodCaloriesToday()}',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  Text(
                    'Sleep hours logged this week: ${appState.totalSleepHoursThisWeek().toStringAsFixed(1)}',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  Text(
                    'Activity minutes this week: ${appState.totalActivityMinutesThisWeek()}',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  Text(
                    'Medications tracked: ${appState.medicineEntries.length}',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieData(AppState appState) {
    final food = appState.totalFoodCaloriesToday().toDouble();
    final sleep = appState.totalSleepHoursThisWeek();
    final activity = appState.totalActivityMinutesThisWeek().toDouble();
    final medicine = appState.medicineEntries.length.toDouble();

    final total = food + sleep + activity + medicine;
    if (total == 0) return [];

    return [
      if (food > 0)
        PieChartSectionData(
          color: Colors.orangeAccent,
          value: food,
          title: 'Food',
          radius: 55,
          titleStyle: const TextStyle(color: Colors.white),
        ),
      if (sleep > 0)
        PieChartSectionData(
          color: Colors.indigoAccent,
          value: sleep,
          title: 'Sleep',
          radius: 55,
          titleStyle: const TextStyle(color: Colors.white),
        ),
      if (activity > 0)
        PieChartSectionData(
          color: Colors.green,
          value: activity,
          title: 'Activity',
          radius: 55,
          titleStyle: const TextStyle(color: Colors.white),
        ),
      if (medicine > 0)
        PieChartSectionData(
          color: Colors.redAccent,
          value: medicine,
          title: 'Medication',
          radius: 55,
          titleStyle: const TextStyle(color: Colors.white),
        ),
    ];
  }

  List<FlSpot> _buildWeeklySpots(AppState appState) {
    final now = DateTime.now();
    final List<FlSpot> spots = [];
    for (int i = 0; i < 7; i++) {
      final day = DateTime(now.year, now.month, now.day).subtract(
        Duration(days: 6 - i),
      );
      final hoursForDay = appState.sleepEntries
          .where((entry) =>
              entry.date.year == day.year &&
              entry.date.month == day.month &&
              entry.date.day == day.day)
          .fold<double>(0, (sum, entry) => sum + entry.hours);
      spots.add(FlSpot(i.toDouble(), hoursForDay));
    }

    final hasData = spots.any((spot) => spot.y > 0);
    return hasData ? spots : [];
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }
}

class _PlaceholderMessage extends StatelessWidget {
  final String message;

  const _PlaceholderMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Text(
          message,
          style: const TextStyle(color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
