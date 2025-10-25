import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/onboarding_primary_button.dart';
import 'summary_screen.dart';

class GoalScreen extends StatefulWidget {
  final double height;
  final double weight;
  final String gender;
  final bool hasDiabetes;
  final bool hasHypertension;
  final int age;

  const GoalScreen({
    super.key,
    required this.height,
    required this.weight,
    required this.gender,
    required this.hasDiabetes,
    required this.hasHypertension,
    required this.age,
  });

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  String? _selectedGoalKey;

  final List<_GoalOption> _goals = const [
    _GoalOption(
      key: 'goalLoseWeight',
      icon: Icons.arrow_downward,
      color: Colors.redAccent,
    ),
    _GoalOption(
      key: 'goalMaintain',
      icon: Icons.straighten,
      color: Colors.amber,
    ),
    _GoalOption(
      key: 'goalGain',
      icon: Icons.arrow_upward,
      color: Colors.green,
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
              value: 1.0,
              backgroundColor: colorScheme.surfaceVariant,
              color: colorScheme.primary,
              minHeight: 6,
            ),
            const SizedBox(height: 40),
            Text(
              l10n.translate('goalQuestion'),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Column(
              children: _goals.map((goal) {
                final isSelected = _selectedGoalKey == goal.key;
                return _GoalTile(
                  option: goal,
                  isSelected: isSelected,
                  onTap: () => setState(() => _selectedGoalKey = goal.key),
                );
              }).toList(),
            ),
            const SizedBox(height: 50),
            OnboardingPrimaryButton(
              label: l10n.translate('viewSummary'),
              onPressed: () {
                if (_selectedGoalKey == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.translate('snackSelectGoal')),
                      backgroundColor: colorScheme.error,
                    ),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SummaryScreen(
                      height: widget.height,
                      weight: widget.weight,
                      gender: widget.gender,
                      hasDiabetes: widget.hasDiabetes,
                      hasHypertension: widget.hasHypertension,
                      goal: _selectedGoalKey!,
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
                style: TextStyle(color: colorScheme.primary, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalOption {
  const _GoalOption({
    required this.key,
    required this.icon,
    required this.color,
  });

  final String key;
  final IconData icon;
  final Color color;
}

class _GoalTile extends StatelessWidget {
  const _GoalTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final _GoalOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;
    final backgroundColor =
        isSelected ? option.color.withOpacity(0.2) : colorScheme.surface;
    final borderColor =
        isSelected ? option.color : colorScheme.outlineVariant;
    final boxShadow = theme.brightness == Brightness.dark
        ? <BoxShadow>[]
        : <BoxShadow>[
            BoxShadow(
              color: (isSelected ? option.color : Colors.black12)
                  .withOpacity(isSelected ? 0.25 : 0.08),
              blurRadius: 8,
              offset: const Offset(0, 5),
            ),
          ];

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(18),
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
          boxShadow: boxShadow,
        ),
        child: Row(
          children: [
            Icon(option.icon, color: option.color, size: 40),
            const SizedBox(width: 20),
            Text(
              l10n.translate(option.key),
              style: TextStyle(
                fontSize: 20,
                color: option.color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
