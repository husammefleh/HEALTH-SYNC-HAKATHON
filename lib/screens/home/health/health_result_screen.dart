import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/analysis_models.dart';

class HealthResultScreen extends StatelessWidget {
  const HealthResultScreen({
    super.key,
    required this.result,
    required this.recordedAt,
  });

  final HealthAnalysisOutput result;
  final DateTime recordedAt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;
    final bp = result.bloodPressure;
    final heartRate = result.heartRate;
    final summary = result.summary ?? result.recommendation;
    final tip = result.recommendation;
    final status = _deriveStatus(bp);
    final statusLabel = l10n.translate(status.labelKey);
    final formattedDate = DateFormat.yMMMd().add_jm().format(recordedAt);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: theme.brightness == Brightness.dark ? 0 : 2,
        centerTitle: true,
        title: Text(
          l10n.translate('healthResultTitle'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: colorScheme.primary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              statusLabel,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: status.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n
                  .translate('healthResultRecordedOn')
                  .replaceFirst('{timestamp}', formattedDate),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            _VitalsCard(
              bloodPressure: bp,
              sugarLevel: result.sugarLevel,
              heartRate: heartRate,
              bloodPressureLabel: result.bloodPressureLabel,
              diastolic: result.diastolic,
              sugarLabel: result.sugarLevelLabel,
              l10n: l10n,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 24),
            _AnalysisBlock(
              icon: Icons.auto_graph,
              title: l10n.translate('aiAnalysisTitle'),
              message: summary,
              theme: theme,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 16),
            _AnalysisBlock(
              icon: Icons.lightbulb_outline,
              title: l10n.translate('aiRecommendationTitle'),
              message: tip,
              theme: theme,
              colorScheme: colorScheme,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.home_outlined),
                label: Text(l10n.translate('backToHomeButton')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.popUntil(
                  context,
                  (route) => route.isFirst || route.settings.name == '/home',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _StatusIndicator _deriveStatus(double bloodPressure) {
    if (bloodPressure < 90) {
      return const _StatusIndicator('healthStatusLow', Colors.orangeAccent);
    }
    if (bloodPressure <= 120) {
      return const _StatusIndicator('healthStatusHealthy', Colors.teal);
    }
    if (bloodPressure <= 140) {
      return const _StatusIndicator('healthStatusElevated', Colors.amber);
    }
    return const _StatusIndicator('healthStatusHigh', Colors.redAccent);
  }
}

class _StatusIndicator {
  const _StatusIndicator(this.labelKey, this.color);
  final String labelKey;
  final Color color;
}

class _VitalsCard extends StatelessWidget {
  const _VitalsCard({
    required this.bloodPressure,
    required this.sugarLevel,
    this.heartRate,
    this.bloodPressureLabel,
    this.diastolic,
    this.sugarLabel,
    required this.l10n,
    required this.colorScheme,
  });

  final double bloodPressure;
  final double sugarLevel;
  final double? heartRate;
  final String? bloodPressureLabel;
  final double? diastolic;
  final String? sugarLabel;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final resolvedBpLabel =
        (bloodPressureLabel != null && bloodPressureLabel!.trim().isNotEmpty)
            ? bloodPressureLabel!.trim()
            : diastolic != null && !diastolic!.isNaN
                ? '${_formatNumber(bloodPressure)}/${_formatNumber(diastolic!)}'
                : _formatNumber(bloodPressure);

    final tiles = <Widget>[
      _VitalTile(
        label: l10n.translate('healthVitalBloodPressure'),
        value: '$resolvedBpLabel mmHg',
        icon: Icons.monitor_heart,
        color: colorScheme.primary,
      ),
      _VitalTile(
        label: l10n.translate('healthVitalSugar'),
        value: sugarLabel != null && sugarLabel!.isNotEmpty
            ? '${sugarLabel!} (${_formatNumber(sugarLevel)} mg/dL)'
            : '${_formatNumber(sugarLevel)} mg/dL',
        icon: Icons.water_drop,
        color: Colors.deepPurpleAccent,
      ),
    ];

    if (heartRate != null && !heartRate!.isNaN) {
      tiles.add(
        _VitalTile(
          label: l10n.translate('healthVitalHeartRate'),
          value: '${_formatNumber(heartRate!)} bpm',
          icon: Icons.favorite,
          color: Colors.pinkAccent,
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.primary.withAlpha(24)),
      ),
      child: Wrap(
        spacing: 24,
        runSpacing: 16,
        children: tiles,
      ),
    );
  }
}

class _VitalTile extends StatelessWidget {
  const _VitalTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(color: color),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalysisBlock extends StatelessWidget {
  const _AnalysisBlock({
    required this.icon,
    required this.title,
    required this.message,
    required this.theme,
    required this.colorScheme,
  });

  final IconData icon;
  final String title;
  final String message;
  final ThemeData theme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.primary.withAlpha(16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
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
                const SizedBox(height: 8),
                Text(
                  message,
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _formatNumber(double value) {
  final rounded = value.roundToDouble();
  if ((rounded - value).abs() < 0.001) {
    return rounded.toStringAsFixed(0);
  }
  return value.toStringAsFixed(1);
}
