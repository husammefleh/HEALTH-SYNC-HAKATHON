import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/sleep_entry.dart';
import '../../../state/app_state.dart';
import '../../common/hedera_badge.dart';

class SleepScreen extends StatelessWidget {
  const SleepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final entries = [...appState.sleepEntries]
      ..sort((a, b) => b.date.compareTo(a.date));
    final latest = entries.isNotEmpty ? entries.first : null;
    final double totalHours =
        entries.fold<double>(0, (sum, item) => sum + item.hours);
    final double average =
        entries.isNotEmpty ? totalHours / entries.length : 0.0;
    final double weekHours = appState.totalSleepHoursThisWeek();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: theme.brightness == Brightness.dark ? 0 : 2,
        centerTitle: true,
        title: Text(
          l10n.translate('sleepTracking'),
          style:
              theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: primary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SleepHeader(
              latest: latest,
              average: average,
              weekHours: weekHours,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.translate('sleepHistoryTitle'),
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: entries.isEmpty
                  ? Center(
                      child: Text(
                        l10n.translate('sleepHistoryEmpty'),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                          color: theme.textTheme.bodyMedium?.color
                              ?.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading:
                                Icon(Icons.nightlight_round, color: primary),
                            title: Text(
                              '${entry.hours.toStringAsFixed(1)} hours of sleep',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _formatDate(entry.date),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.textTheme.bodySmall?.color
                                        ?.withOpacity(0.7),
                                  ),
                                ),
                                if (entry.recommendation != null &&
                                    entry.recommendation!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      entry.recommendation!,
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ),
                              ],
                            ),
                            trailing: const HederaBadge(compact: true),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: Text(
                  l10n.translate('sleepAddSessionButton'),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimary,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, '/add_sleep'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }
}

class _SleepHeader extends StatelessWidget {
  final SleepEntry? latest;
  final double average;
  final double weekHours;

  const _SleepHeader({
    required this.latest,
    required this.average,
    required this.weekHours,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final l10n = context.l10n;
    final recommendation = latest?.recommendation?.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primary.withAlpha(20),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            latest != null
                ? l10n
                    .translate('sleepSummaryLastSession')
                    .replaceFirst('{hours}', latest!.hours.toStringAsFixed(1))
                : l10n.translate('sleepSummaryNoData'),
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n
                .translate('sleepSummaryAverage')
                .replaceFirst('{hours}', average.toStringAsFixed(1)),
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            l10n
                .translate('sleepSummaryWeek')
                .replaceFirst('{hours}', weekHours.toStringAsFixed(1)),
            style: theme.textTheme.bodyMedium,
          ),
          if (recommendation != null && recommendation.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              l10n.translate('sleepLatestRecommendation'),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              recommendation,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ],
        ],
      ),
    );
  }
}
