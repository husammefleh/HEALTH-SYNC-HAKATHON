import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/onboarding_primary_button.dart';
import 'step4_gender_screen.dart';

class Step3WeightScreen extends StatefulWidget {
  final double height;
  final int age;

  const Step3WeightScreen({
    super.key,
    required this.height,
    required this.age,
  });

  @override
  State<Step3WeightScreen> createState() => _Step3WeightScreenState();
}

class _Step3WeightScreenState extends State<Step3WeightScreen> {
  final TextEditingController _weightController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LinearProgressIndicator(
              value: 0.6,
              backgroundColor: colorScheme.surfaceContainerHighest,
              color: colorScheme.primary,
              minHeight: 6,
            ),
            const SizedBox(height: 40),
            Text(
              l10n.translate('weightQuestion'),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.translate('weightLabel'),
                hintText: l10n.translate('weightHint'),
                prefixIcon: Icon(Icons.monitor_weight, color: colorScheme.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 40),
            OnboardingPrimaryButton(
              label: l10n.translate('next'),
              onPressed: () {
                final weight = double.tryParse(_weightController.text);
                if (weight == null || weight <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.translate('snackInvalidWeight')),
                      backgroundColor: colorScheme.error,
                    ),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Step4GenderScreen(
                      height: widget.height,
                      weight: weight,
                      age: widget.age,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                l10n.translate('back'),
                style: TextStyle(color: colorScheme.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
