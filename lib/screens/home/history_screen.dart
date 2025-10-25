import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/activity_entry.dart';
import '../../models/food_entry.dart';
import '../../models/medicine_entry.dart';
import '../../models/sleep_entry.dart';
import '../../state/app_state.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final items = _buildHistory(appState);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'History',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: isDark ? 0 : 2,
        iconTheme: IconThemeData(color: primary),
      ),
      body: items.isEmpty
          ? const _EmptyHistory()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: isDark ? 0 : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: Icon(item.icon, color: item.color, size: 32),
                    title: Text(
                      item.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${item.subtitle}\n${item.date}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                        height: 1.4,
                      ),
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }

  List<_HistoryItem> _buildHistory(AppState state) {
    final dateFormatter = DateFormat('yyyy/MM/dd - HH:mm');
    final List<_HistoryItem> entries = [
      for (final FoodEntry entry in state.foodEntries)
        _HistoryItem(
          date: dateFormatter.format(entry.analysedAt),
          icon: Icons.restaurant_menu,
          color: Colors.orangeAccent,
          title: 'Meal logged: ${entry.description}',
          subtitle:
              '${entry.calories} kcal · ${entry.proteinGrams.toStringAsFixed(1)} g protein · ${entry.carbsGrams.toStringAsFixed(1)} g carbs',
          rawDate: entry.analysedAt,
        ),
      for (final SleepEntry entry in state.sleepEntries)
        _HistoryItem(
          date: dateFormatter.format(entry.date),
          icon: Icons.nightlight_round,
          color: Colors.indigoAccent,
          title: 'Sleep session: ${entry.hours.toStringAsFixed(1)} h',
          subtitle: 'Manual entry saved',
          rawDate: entry.date,
        ),
      for (final ActivityEntry entry in state.activityEntries)
        _HistoryItem(
          date: dateFormatter.format(entry.createdAt),
          icon: Icons.fitness_center,
          color: Colors.green,
          title: 'Activity: ${entry.name}',
          subtitle: '${entry.minutes} min - ${entry.calories} kcal burned',
          rawDate: entry.createdAt,
        ),
      for (final MedicineEntry entry in state.medicineEntries)
        _HistoryItem(
          date: dateFormatter.format(entry.createdAt),
          icon: Icons.medical_services_outlined,
          color: Colors.redAccent,
          title: 'Medication: ${entry.medicine}',
          subtitle:
              'For ${entry.disease} - reminder at ${entry.time} - ${entry.taken ? 'taken' : 'pending'}',
          rawDate: entry.createdAt,
        ),
    ];

    entries.sort((a, b) => b.rawDate.compareTo(a.rawDate));
    return entries;
  }
}

class _HistoryItem {
  final String title;
  final String subtitle;
  final String date;
  final IconData icon;
  final Color color;
  final DateTime rawDate;

  _HistoryItem({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.icon,
    required this.color,
    required this.rawDate,
  });
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, color: primary, size: 80),
            const SizedBox(height: 20),
            Text(
              'No activity recorded yet.',
              style: theme.textTheme.titleMedium?.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Log meals, sleep, workouts or medication to build your personal history.',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.explore, color: theme.colorScheme.onPrimary),
              label: Text(
                'Start tracking',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
