import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/onboarding_primary_button.dart';
import 'step6_hypertension_screen.dart';

class DiabetesScreen extends StatefulWidget {
  final double height;
  final double weight;
  final String gender;
  final int age;

  const DiabetesScreen({
    super.key,
    required this.height,
    required this.weight,
    required this.gender,
    required this.age,
  });

  @override
  State<DiabetesScreen> createState() => _DiabetesScreenState();
}

class _DiabetesScreenState extends State<DiabetesScreen> {
  bool? hasDiabetes;

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
          children: [
            Text(
              l10n.translate('diabetesQuestion'),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            Text(
              l10n.translate('diabetesDescription'),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildChoiceChip(
                  context: context,
                  label: l10n.translate('optionYes'),
                  selected: hasDiabetes == true,
                  onSelected: () => setState(() => hasDiabetes = true),
                ),
                _buildChoiceChip(
                  context: context,
                  label: l10n.translate('optionNo'),
                  selected: hasDiabetes == false,
                  onSelected: () => setState(() => hasDiabetes = false),
                ),
              ],
            ),
            const SizedBox(height: 60),
            OnboardingPrimaryButton(
              label: l10n.translate('next'),
              onPressed: () {
                if (hasDiabetes == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.translate('snackSelectDiabetes')),
                      backgroundColor: colorScheme.error,
                    ),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HypertensionScreen(
                      height: widget.height,
                      weight: widget.weight,
                      gender: widget.gender,
                      hasDiabetes: hasDiabetes!,
                      age: widget.age,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceChip({
    required BuildContext context,
    required String label,
    required bool selected,
    required VoidCallback onSelected,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 18),
      ),
      selected: selected,
      selectedColor: colorScheme.primary,
      onSelected: (_) => onSelected(),
      labelStyle: TextStyle(
        color: selected ? Colors.white : colorScheme.primary,
      ),
      backgroundColor: colorScheme.primary.withOpacity(0.12),
    );
  }
}
