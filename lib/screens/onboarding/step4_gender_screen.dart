import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/onboarding_primary_button.dart';
import 'step5_diabetes_screen.dart';

class Step4GenderScreen extends StatefulWidget {
  final double height;
  final double weight;
  final int age;

  const Step4GenderScreen({
    super.key,
    required this.height,
    required this.weight,
    required this.age,
  });

  @override
  State<Step4GenderScreen> createState() => _Step4GenderScreenState();
}

class _Step4GenderScreenState extends State<Step4GenderScreen> {
  String? _selectedGenderKey;

  final List<_GenderOption> _options = const [
    _GenderOption(
      key: 'female',
      labelKey: 'genderFemale',
      icon: Icons.female,
      accent: Colors.pinkAccent,
    ),
    _GenderOption(
      key: 'male',
      labelKey: 'genderMale',
      icon: Icons.male,
      accent: Colors.blueAccent,
    ),
  ];

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
            LinearProgressIndicator(
              value: 0.8,
              backgroundColor: colorScheme.surfaceVariant,
              color: colorScheme.primary,
              minHeight: 6,
            ),
            const SizedBox(height: 40),
            Text(
              l10n.translate('genderQuestion'),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _options
                  .map(
                    (option) => _buildGenderCard(
                      context: context,
                      option: option,
                      isSelected: _selectedGenderKey == option.key,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 50),
            OnboardingPrimaryButton(
              label: l10n.translate('next'),
              onPressed: () {
                if (_selectedGenderKey == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.translate('snackSelectGender')),
                      backgroundColor: colorScheme.error,
                    ),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DiabetesScreen(
                      height: widget.height,
                      weight: widget.weight,
                      gender: _selectedGenderKey!,
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

  Widget _buildGenderCard({
    required BuildContext context,
    required _GenderOption option,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;
    final backgroundColor =
        isSelected ? option.accent.withOpacity(0.2) : colorScheme.surface;
    final borderColor =
        isSelected ? option.accent : colorScheme.outlineVariant;
    final boxShadow = theme.brightness == Brightness.dark
        ? <BoxShadow>[]
        : <BoxShadow>[
            BoxShadow(
              color: (isSelected ? option.accent : Colors.black12)
                  .withOpacity(isSelected ? 0.3 : 0.08),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ];

    return GestureDetector(
      onTap: () => setState(() => _selectedGenderKey = option.key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 130,
        height: 160,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
          boxShadow: boxShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(option.icon, size: 70, color: option.accent),
            const SizedBox(height: 10),
            Text(
              l10n.translate(option.labelKey),
              style: TextStyle(
                fontSize: 20,
                color: option.accent,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GenderOption {
  const _GenderOption({
    required this.key,
    required this.labelKey,
    required this.icon,
    required this.accent,
  });

  final String key;
  final String labelKey;
  final IconData icon;
  final Color accent;
}
