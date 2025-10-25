import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/sleep_entry.dart';
import '../../../state/app_state.dart';

class SleepScreen extends StatelessWidget {
  const SleepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final entries = [...appState.sleepEntries]
      ..sort((a, b) => b.date.compareTo(a.date));
    final latest = entries.isNotEmpty ? entries.first : null;
    final double totalHours =
        entries.fold<double>(0, (sum, item) => sum + item.hours);
    final double average =
        entries.isNotEmpty ? totalHours / entries.length : 0.0;
    final double weekHours = appState.totalSleepHoursThisWeek();
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 2,
        centerTitle: true,
        title: const Text(
          'Sleep',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: primary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SleepHeader(
                latest: latest, average: average, weekHours: weekHours),
            const SizedBox(height: 24),
            Text(
              'History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: entries.isEmpty
                  ? const Center(
                      child: Text(
                        'No sleep sessions logged yet. Add your first sleep record.',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading:
                                Icon(Icons.nightlight_round, color: primary),
                            title: Text(
                              '${entry.hours.toStringAsFixed(1)} hours of sleep',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              _formatDate(entry.date),
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text(
                  'Add sleep session',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/add_sleep'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }
}

class _SleepHeader extends StatelessWidget {
  final SleepEntry? latest;
  final double average;
  final double weekHours;

  const _SleepHeader({
    required this.latest,
    required this.average,
    required this.weekHours,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final subtitleStyle = const TextStyle(fontSize: 16, color: Colors.black87);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primary.withAlpha(20),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            latest != null
                ? 'Last session: ${latest!.hours.toStringAsFixed(1)} hours'
                : 'No sleep data recorded yet',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text('Average duration: ${average.toStringAsFixed(1)} hours',
              style: subtitleStyle),
          const SizedBox(height: 4),
          Text('Past 7 days total: ${weekHours.toStringAsFixed(1)} hours',
              style: subtitleStyle),
        ],
      ),
    );
  }
}

