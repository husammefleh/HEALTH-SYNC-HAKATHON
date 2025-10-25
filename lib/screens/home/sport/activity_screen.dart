import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/app_state.dart';
import 'add_activity_screen.dart';

class ActivityMainScreen extends StatelessWidget {
  const ActivityMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = [...context.watch<AppState>().activityEntries]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final totalCalories =
        entries.fold<int>(0, (sum, item) => sum + item.calories);
    final totalMinutes =
        entries.fold<int>(0, (sum, item) => sum + item.minutes);
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 2,
        title: const Text(
          'Activity tracking',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: primary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primary.withAlpha(26),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Summary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Calories burned: $totalCalories kcal\n'
                    'Total minutes: $totalMinutes min\n'
                    'Sessions logged: ${entries.length}',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Stay consistent and mix light and intense workouts to balance your week.',
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Recent sessions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
            const SizedBox(height: 10),
            entries.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Text(
                        'No workouts recorded yet. Add your first activity to begin tracking.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ),
                  )
                : Column(
                    children: entries.map((activity) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Icon(Icons.fitness_center, color: primary),
                          title: Text(
                            activity.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${activity.minutes} min - ${activity.calories} kcal',
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        onPressed: () => _addActivity(context),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  Future<void> _addActivity(BuildContext context) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final newActivity = await navigator.push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (context) => const AddActivityScreen()),
    );

    if (!context.mounted) return;
    if (newActivity != null) {
      await context.read<AppState>().addActivity(
            name: newActivity['name'] as String,
            minutes: newActivity['minutes'] as int,
            calories: newActivity['calories'] as int,
          );
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Activity saved to your log.'),
          backgroundColor: Colors.teal,
        ),
      );
    }
  }
}

