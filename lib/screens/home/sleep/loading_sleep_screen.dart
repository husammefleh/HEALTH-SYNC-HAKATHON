import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/app_state.dart';

class LoadingSleepScreen extends StatefulWidget {
  const LoadingSleepScreen({super.key});

  @override
  State<LoadingSleepScreen> createState() => _LoadingSleepScreenState();
}

class _LoadingSleepScreenState extends State<LoadingSleepScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double hours = 0;
  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);

    Timer(const Duration(seconds: 2), () async {
      await context.read<AppState>().addSleepEntry(date, hours);
      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        '/sleep_result',
        arguments: hours,
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      hours = (arguments['hours'] as num?)?.toDouble() ?? 0;
      date = arguments['date'] as DateTime? ?? DateTime.now();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotationTransition(
              turns: _animation,
              child: Icon(
                Icons.nightlight_round,
                size: 80,
                color: primary,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Analysing your sleep...',
              style: TextStyle(
                fontSize: 20,
                color: primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'We are preparing quick feedback to help you rest better.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

