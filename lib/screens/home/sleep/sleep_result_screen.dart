import 'package:flutter/material.dart';

class SleepResultScreen extends StatelessWidget {
  const SleepResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double hours =
        ModalRoute.of(context)!.settings.arguments as double? ?? 0.0;

    late final String title;
    late final String advice;
    late final Color color;

    if (hours < 6) {
      title = 'Short sleep';
      advice =
          'Try to aim for at least 6 hours of rest tonight to help your body reset.';
      color = Colors.redAccent;
    } else if (hours <= 8) {
      title = 'Great sleep!';
      advice = 'That is a healthy amount of sleep. Keep following this rhythm.';
      color = Colors.teal;
    } else {
      title = 'Long sleep';
      advice =
          'You slept more than usual. Check in with your energy levels during the day.';
      color = Colors.orangeAccent;
    }

    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 2,
        title: const Text(
          'Sleep summary',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: primary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: color.withAlpha(26),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withAlpha(26), width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    '${hours.toStringAsFixed(1)} hours',
                    style: TextStyle(
                      fontSize: 32,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: primary.withAlpha(51)),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.insights, color: color, size: 30),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      advice,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Done'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    (route) => route.settings.name == null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

