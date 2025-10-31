import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/health_reading.dart';
import '../../../state/app_state.dart';
import '../../common/hedera_badge.dart';
import 'add_health_reading_screen.dart';

class HealthMainScreen extends StatelessWidget {
  const HealthMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;
    final readings = context.watch<AppState>().healthReadings;

    final grouped = _groupReadingsByDay(context, readings);
    final latestReading = readings.isNotEmpty ? readings.first : null;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: theme.brightness == Brightness.dark ? 0 : 2,
        title: Text(
          l10n.translate('vitalsAndHealth'),
          style:
              theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InsightCard(latest: latestReading),
            const SizedBox(height: 24),
            Text(
              l10n.translate('recentReadings'),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: readings.isEmpty
                  ? _EmptyReadingsPlaceholder()
                  : ListView(
                      children: grouped.entries
                          .map(
                            (entry) => _ReadingGroup(
                              title: entry.key,
                              readings: entry.value,
                            ),
                          )
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const AddHealthReadingScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.translate('addHealthReadingButton')),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  LinkedHashMap<String, List<HealthReading>> _groupReadingsByDay(
    BuildContext context,
    List<HealthReading> readings,
  ) {
    final grouped =
        LinkedHashMap<String, List<HealthReading>>(); // HACKATHON: Preserve insertion order while satisfying return type.
    final l10n = context.l10n;
    final localeCode = l10n.locale.toLanguageTag();
    final dateFormatter = DateFormat.yMMMMd(localeCode);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (final reading in readings) {
      final date = DateTime(
        reading.recordedAt.year,
        reading.recordedAt.month,
        reading.recordedAt.day,
      );

      late final String label;
      if (date == today) {
        label = l10n.translate('todayLabel');
      } else if (date == yesterday) {
        label = l10n.translate('yesterdayLabel');
      } else {
        label = dateFormatter.format(date);
      }

      grouped.putIfAbsent(label, () => []).add(reading);
    }

    return grouped;
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.latest});

  final HealthReading? latest;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    final hasData = latest != null;
    final metrics = _buildMetrics(context, latest);
    final recommendation = hasData ? latest!.recommendation?.trim() : null;
    final recordedAt = hasData
        ? DateFormat.yMMMd(l10n.locale.toLanguageTag())
            .add_jm()
            .format(latest!.recordedAt)
        : null;

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  l10n.translate('todayInsight'),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              if (hasData) const HederaBadge(compact: true),
            ],
          ),
          const SizedBox(height: 16),
          if (metrics.isEmpty)
            Text(
              l10n.translate('healthSummaryPlaceholder'),
              style: theme.textTheme.bodyLarge,
            )
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: metrics,
            ),
          if (recordedAt != null) ...[
            const SizedBox(height: 12),
            Text(
              l10n
                  .translate('healthRecordedAt')
                  .replaceFirst('{time}', recordedAt),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
            ),
          ],
          if (recommendation != null && recommendation.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              l10n.translate('healthRecommendationHeading'),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              recommendation,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ] else if (hasData) ...[
            const SizedBox(height: 16),
            Text(
              l10n.translate('healthRecommendationFallback'),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ],
          if (!hasData) ...[
            const SizedBox(height: 16),
            Text(
              l10n.translate('healthSummaryPlaceholder'),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildMetrics(
    BuildContext context,
    HealthReading? reading,
  ) {
    if (reading == null) return const [];
    final l10n = context.l10n;
    final metrics = <Widget>[];
    if (reading.bloodPressure > 0) {
      final bpLabel = reading.bloodPressureLabel ??
          (reading.diastolic != null
              ? '${_formatNumber(reading.bloodPressure)}/${_formatNumber(reading.diastolic!)}'
              : _formatNumber(reading.bloodPressure));
      metrics.add(
        _MetricPill(
          icon: Icons.monitor_heart,
          color: Colors.orange,
          label: l10n.translate('bloodPressure'),
          value: '$bpLabel mmHg',
        ),
      );
    }
    if (reading.sugarLevel > 0) {
      metrics.add(
        _MetricPill(
          icon: Icons.water_drop,
          color: Colors.deepPurpleAccent,
          label: l10n.translate('bloodSugar'),
          value: '${_formatNumber(reading.sugarLevel)} mg/dL',
        ),
      );
    }
    return metrics;
  }
}

class _ReadingGroup extends StatelessWidget {
  const _ReadingGroup({
    required this.title,
    required this.readings,
  });

  final String title;
  final List<HealthReading> readings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localeCode = context.l10n.locale.toLanguageTag();
    final timeFormatter = DateFormat.jm(localeCode);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...readings.map(
            (reading) => _ReadingCard(
              reading: reading,
              timeLabel: timeFormatter.format(reading.recordedAt),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadingCard extends StatelessWidget {
  const _ReadingCard({
    required this.reading,
    required this.timeLabel,
  });

  final HealthReading reading;
  final String timeLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final recommendation = reading.recommendation?.trim();

    final metricChips = <Widget>[];
    if (reading.bloodPressure > 0) {
      final bpLabel = reading.bloodPressureLabel ??
          (reading.diastolic != null
              ? '${_formatNumber(reading.bloodPressure)}/${_formatNumber(reading.diastolic!)}'
              : _formatNumber(reading.bloodPressure));
      metricChips.add(
        _MetricPill(
          icon: Icons.monitor_heart,
          color: Colors.orange,
          label: l10n.translate('bloodPressure'),
          value: '$bpLabel mmHg',
        ),
      );
    }
    if (reading.sugarLevel > 0) {
      metricChips.add(
        _MetricPill(
          icon: Icons.water_drop,
          color: Colors.deepPurpleAccent,
          label: l10n.translate('bloodSugar'),
          value: '${_formatNumber(reading.sugarLevel)} mg/dL',
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: theme.brightness == Brightness.dark ? 0 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.favorite, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: metricChips,
                  ),
                ),
                const SizedBox(width: 12),
                const HederaBadge(compact: true),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 6),
                Text(
                  l10n
                      .translate('healthRecordedAt')
                      .replaceFirst('{time}', timeLabel),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            if (recommendation != null && recommendation.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                l10n.translate('healthRecommendationHeading'),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
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
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(color: color),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
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

class _EmptyReadingsPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.monitor_heart,
                size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              l10n.translate('noReadingsYet'),
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.translate('noReadingsHint'),
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
