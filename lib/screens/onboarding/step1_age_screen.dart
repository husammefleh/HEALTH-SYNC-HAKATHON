import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/onboarding_primary_button.dart';
import 'step2_height_screen.dart';

class Step1AgeScreen extends StatefulWidget {
  const Step1AgeScreen({super.key});

  @override
  State<Step1AgeScreen> createState() => _Step1AgeScreenState();
}

class _Step1AgeScreenState extends State<Step1AgeScreen> {
  int age = 18;

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
            Text(
              l10n.translate('ageQuestion'),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (age > 1) setState(() => age--);
                  },
                  icon: Icon(Icons.remove_circle, color: colorScheme.primary, size: 40),
                ),
                Text(
                  '$age',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (age < 100) setState(() => age++);
                  },
                  icon: Icon(Icons.add_circle, color: colorScheme.primary, size: 40),
                ),
              ],
            ),
            const SizedBox(height: 50),
            OnboardingPrimaryButton(
              label: l10n.translate('next'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Step2HeightScreen(age: age),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
