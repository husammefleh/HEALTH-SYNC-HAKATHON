import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/analysis_models.dart';

class ActivityResultScreen extends StatelessWidget {
  const ActivityResultScreen({super.key, required this.result});

  final ActivityAnalysisOutput result;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final l10n = context.l10n;
    final name = result.exerciseType;
    final minutes = result.durationMinutes;
    final calories = result.caloriesBurned;
    final recommendation = result.recommendation;
    final tip = result.secondaryTip;
    final summary = result.summary ?? result.recommendation;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 2,
        centerTitle: true,
        title: Text(
          l10n.translate('activityResultTitle'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: primary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              name,
              style: TextStyle(
                fontSize: 24,
                color: primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: primary.withAlpha(26),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildRow(
                    context,
                    l10n.translate('activityResultDuration'),
                    l10n
                        .translate('activityResultDurationValue')
                        .replaceFirst('{minutes}', minutes.toString()),
                  ),
                  _buildRow(
                    context,
                    l10n.translate('activityResultCalories'),
                    l10n
                        .translate('activityResultCaloriesValue')
                        .replaceFirst('{calories}', calories.toString()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const SizedBox(height: 20),
            _InfoBanner(
              icon: Icons.auto_graph,
              title: l10n.translate('aiAnalysisTitle'),
              color: primary,
              text: summary,
            ),
            const SizedBox(height: 14),
            _InfoBanner(
              icon: Icons.lightbulb_outline,
              title: l10n.translate('aiTipTitle'),
              color: primary,
              text: tip != null && tip.isNotEmpty
                  ? '$recommendation\n$tip'
                  : recommendation,
            ),
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.home_outlined, color: Colors.white),
              label: Text(
                l10n.translate('backToHomeButton'),
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.popUntil(
                context,
                (route) => route.isFirst || route.settings.name == '/home',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
          ),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.black54, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({
    required this.icon,
    required this.title,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final String title;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
