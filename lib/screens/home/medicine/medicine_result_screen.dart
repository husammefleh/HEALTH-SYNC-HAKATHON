import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/analysis_models.dart';

class MedicineResultScreen extends StatelessWidget {
  const MedicineResultScreen({super.key, required this.result});

  final MedicineAnalysisOutput result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    final dosageLabel = l10n
        .translate('medicineResultDosage')
        .replaceFirst('{dosage}', result.dosage);
    final frequencyValue = l10n
        .translate('medicineResultFrequencyValue')
        .replaceFirst('{count}', result.frequencyPerDay.toString());
    final durationValue = l10n
        .translate('medicineResultDurationValue')
        .replaceFirst('{days}', result.durationDays.toString());

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: theme.brightness == Brightness.dark ? 0 : 2,
        centerTitle: true,
        title: Text(
          l10n.translate('medicineResultTitle'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: colorScheme.primary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderCard(
              medicine: result.medicineName,
              dosageLabel: dosageLabel,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 24),
            _FactList(
              frequencyLabel: l10n.translate('medicineResultFrequency'),
              durationLabel: l10n.translate('medicineResultDuration'),
              frequencyValue: frequencyValue,
              durationValue: durationValue,
              theme: theme,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 24),
            if (result.summary != null && result.summary!.isNotEmpty)
              _ParagraphBlock(
                title: l10n.translate('aiAnalysisTitle'),
                message: result.summary!,
                theme: theme,
                colorScheme: colorScheme,
              ),
            _ParagraphBlock(
              title: l10n.translate('aiRecommendationTitle'),
              message: result.recommendation,
              theme: theme,
              colorScheme: colorScheme,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline),
                label: Text(l10n.translate('medicineResultDone')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.medicine,
    required this.dosageLabel,
    required this.colorScheme,
  });

  final String medicine;
  final String dosageLabel;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primary.withAlpha(26),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            medicine,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            dosageLabel,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _FactList extends StatelessWidget {
  const _FactList({
    required this.frequencyLabel,
    required this.durationLabel,
    required this.frequencyValue,
    required this.durationValue,
    required this.theme,
    required this.colorScheme,
  });

  final String frequencyLabel;
  final String durationLabel;
  final String frequencyValue;
  final String durationValue;
  final ThemeData theme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.primary.withAlpha(24)),
      ),
      child: Column(
        children: [
          _FactRow(
            icon: Icons.schedule,
            label: frequencyLabel,
            value: frequencyValue,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 12),
          _FactRow(
            icon: Icons.calendar_month,
            label: durationLabel,
            value: durationValue,
            color: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _FactRow extends StatelessWidget {
  const _FactRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: color.withOpacity(0.7)),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ParagraphBlock extends StatelessWidget {
  const _ParagraphBlock({
    required this.title,
    required this.message,
    required this.theme,
    required this.colorScheme,
  });

  final String title;
  final String message;
  final ThemeData theme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.primary.withAlpha(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}
