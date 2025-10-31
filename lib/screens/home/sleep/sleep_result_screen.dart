import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/analysis_models.dart';

class SleepResultScreen extends StatelessWidget {
  const SleepResultScreen({super.key, required this.result});

  final SleepAnalysisOutput result;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final l10n = context.l10n;
    final hours = result.hours;
    final score = _calculateSleepScore(hours);
    final title = _headlineForHours(hours);
    final advice = result.summary ?? result.recommendation;
    final tip = result.recommendation;
    final hoursLabel = l10n
        .translate('sleepResultHoursLabel')
        .replaceFirst('{hours}', hours.toStringAsFixed(1));
    final qualityLabel = l10n
        .translate('sleepResultQualityLabel')
        .replaceFirst('{score}', score.toString());

    final Color accentColor;
    if (hours < 6) {
      accentColor = Colors.redAccent;
    } else if (hours <= 8) {
      accentColor = Colors.teal;
    } else {
      accentColor = Colors.orangeAccent;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 2,
        title: Text(
          l10n.translate('sleepResultTitle'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: primary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: accentColor.withAlpha(26),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: accentColor.withAlpha(26), width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    hoursLabel,
                    style: TextStyle(
                      fontSize: 32,
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Chip(
                    label: Text(qualityLabel),
                    backgroundColor: accentColor.withAlpha(36),
                    labelStyle: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _InsightCard(
              icon: Icons.auto_graph,
              title: l10n.translate('aiAnalysisTitle'),
              message: advice,
              accent: accentColor,
            ),
            const SizedBox(height: 16),
            _InsightCard(
              icon: Icons.lightbulb_outline,
              title: l10n.translate('aiTipTitle'),
              message: tip,
              accent: primary,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.home_outlined),
                label: Text(l10n.translate('backToHomeButton')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
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

  int _calculateSleepScore(double hours) {
    if (hours <= 0) return 0;
    if (hours >= 8) return 90;
    if (hours >= 7) return 80;
    if (hours >= 6) return 70;
    if (hours >= 5) return 60;
    return 50;
  }

  String _headlineForHours(double hours) {
    if (hours < 6) return 'Short sleep';
    if (hours <= 8) return 'Rested well';
    return 'Extra rest';
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String message;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: accent.withAlpha(40)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: accent,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
