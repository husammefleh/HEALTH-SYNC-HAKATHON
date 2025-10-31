import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/user_profile.dart';
import '../../state/app_state.dart';
import '../../widgets/onboarding_primary_button.dart';
import '../home/home_screen.dart';

class SummaryScreen extends StatelessWidget {
  final double height;
  final double weight;
  final String gender;
  final bool hasDiabetes;
  final bool hasHypertension;
  final int age;

  const SummaryScreen({
    super.key,
    required this.height,
    required this.weight,
    required this.gender,
    required this.hasDiabetes,
    required this.hasHypertension,
    required this.age,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;
    final userName = appState.user?.username ?? appState.user?.email;
    final displayName =
        (userName != null && userName.isNotEmpty) ? userName : l10n.translate('defaultDisplayName');

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.summaryGreeting(displayName),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.translate('summaryDescription'),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.bodyLarge?.color?.withOpacity(0.72),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildSummaryCard(context),
            const SizedBox(height: 32),
            OnboardingPrimaryButton(
              label: l10n.translate('finishSetup'),
              onPressed: () async {
                final profile = UserProfile(
                  age: age,
                  height: height,
                  weight: weight,
                  gender: gender,
                  hasDiabetes: hasDiabetes,
                  hasHypertension: hasHypertension,
                  preferredName: displayName,
                );

                await context.read<AppState>().completeOnboarding(profile);

                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (_) => false,
                );
              },
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                l10n.translate('backToEdit'),
                style: TextStyle(color: colorScheme.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: theme.brightness == Brightness.dark
            ? const []
            : const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
        border: Border.all(
          color: theme.brightness == Brightness.dark
              ? colorScheme.outlineVariant
              : Colors.transparent,
        ),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            context,
            label: l10n.translate('ageLabel'),
            value: l10n.ageLabelValue(age),
          ),
          const Divider(),
          _buildInfoRow(
            context,
            label: l10n.translate('heightShort'),
            value: l10n.heightLabelValue(height),
          ),
          const Divider(),
          _buildInfoRow(
            context,
            label: l10n.translate('weightShort'),
            value: l10n.weightLabelValue(weight),
          ),
          const Divider(),
          _buildInfoRow(
            context,
            label: l10n.translate('genderLabel'),
            value: l10n.genderLabel(gender),
          ),
          const Divider(),
          _buildInfoRow(
            context,
            label: l10n.translate('diabetesLabel'),
            value: l10n.booleanLabel(hasDiabetes),
          ),
          const Divider(),
          _buildInfoRow(
            context,
            label: l10n.translate('hypertensionLabel'),
            value: l10n.booleanLabel(hasHypertension),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
