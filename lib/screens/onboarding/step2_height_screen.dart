import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/onboarding_primary_button.dart';
import 'step3_weight_screen.dart';

class Step2HeightScreen extends StatefulWidget {
  final int age;

  const Step2HeightScreen({super.key, required this.age});

  @override
  State<Step2HeightScreen> createState() => _Step2HeightScreenState();
}

class _Step2HeightScreenState extends State<Step2HeightScreen> {
  final TextEditingController _heightController = TextEditingController();

  @override
  void dispose() {
    _heightController.dispose();
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
              value: 0.4,
              backgroundColor: colorScheme.surfaceVariant,
              color: colorScheme.primary,
              minHeight: 6,
            ),
            const SizedBox(height: 40),
            Text(
              l10n.translate('heightQuestion'),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.translate('heightLabel'),
                hintText: l10n.translate('heightHint'),
                prefixIcon: Icon(Icons.height, color: colorScheme.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 40),
            OnboardingPrimaryButton(
              label: l10n.translate('next'),
              onPressed: () {
                final height = double.tryParse(_heightController.text);
                if (height == null || height <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.translate('snackInvalidHeight')),
                      backgroundColor: colorScheme.error,
                    ),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Step3WeightScreen(
                      height: height,
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
