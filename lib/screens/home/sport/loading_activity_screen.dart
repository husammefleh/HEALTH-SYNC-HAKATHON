import 'dart:async';

import 'package:flutter/material.dart';

import 'activity_result_screen.dart';

class LoadingActivityScreen extends StatefulWidget {
  final Map<String, dynamic> activityData;

  const LoadingActivityScreen({super.key, required this.activityData});

  @override
  State<LoadingActivityScreen> createState() => _LoadingActivityScreenState();
}

class _LoadingActivityScreenState extends State<LoadingActivityScreen> {
  @override
  void initState() {
    super.initState();
    _simulateAnalysis();
  }

  Future<void> _simulateAnalysis() async {
    await Future.delayed(const Duration(seconds: 2));

    final aiResult = {
      'name': widget.activityData['name'],
      'minutes': widget.activityData['minutes'],
      'calories': widget.activityData['calories'],
      'aiTip':
          'Great consistency! Try adding a few stretches after each workout to recover faster.',
    };

    if (!mounted) return;
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => ActivityResultScreen(result: aiResult),
      ),
    );

    if (!mounted) return;
    Navigator.pop(context, result ?? aiResult);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(
              color: Colors.teal,
              strokeWidth: 5,
            ),
            SizedBox(height: 25),
            Text(
              'Analysing your workout...',
              style: TextStyle(
                color: Colors.teal,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

