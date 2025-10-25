import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/health_reading.dart';
import '../../../state/app_state.dart';
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
    final summary = _buildLatestSummary(l10n, readings);

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
            _InsightCard(summary: summary),
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
    final grouped = LinkedHashMap<String, List<HealthReading>>();
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

      String label;
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

  String _buildLatestSummary(
    AppLocalizations l10n,
    List<HealthReading> readings,
  ) {
    if (readings.isEmpty) {
      return l10n.translate('healthSummaryPlaceholder');
    }

    final latestPressure =
        readings.firstWhere((r) => r.kind == HealthReadingKind.bloodPressure,
            orElse: () =>
                readings.firstWhere((_) => false, orElse: () => readings.first));
    final latestSugar = readings.firstWhere(
      (r) => r.kind == HealthReadingKind.bloodSugar,
      orElse: () =>
          readings.firstWhere((_) => false, orElse: () => readings.first),
    );

    final parts = <String>[];
    if (latestPressure.kind == HealthReadingKind.bloodPressure) {
      parts.add(
          l10n.translate('latestBloodPressure').replaceFirst('{value}', latestPressure.value));
    }
    if (latestSugar.kind == HealthReadingKind.bloodSugar) {
      parts.add(l10n.translate('latestBloodSugar')
          .replaceFirst('{value}', latestSugar.value));
    }
    return parts.isEmpty
        ? l10n.translate('healthSummaryPlaceholder')
        : parts.join(' · ');
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.summary});

  final String summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

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
            l10n.translate('todayInsight'),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            summary,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
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
              icon: reading.kind == HealthReadingKind.bloodPressure
                  ? Icons.monitor_heart
                  : Icons.water_drop,
              color: reading.kind == HealthReadingKind.bloodPressure
                  ? Colors.orange
                  : Colors.green,
              label: reading.kind == HealthReadingKind.bloodPressure
                  ? context.l10n.translate('bloodPressure')
                  : context.l10n.translate('bloodSugar'),
              value: reading.value,
              time: timeFormatter.format(reading.recordedAt),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadingCard extends StatelessWidget {
  const _ReadingCard({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.time,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final String time;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: theme.brightness == Brightness.dark ? 0 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: color.withAlpha(32),
          child: Icon(icon, color: color),
        ),
        title: Text(
          value,
          style:
              theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(time),
        trailing: Text(
          label,
          style: theme.textTheme.labelSmall,
        ),
      ),
    );
  }
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
            Icon(Icons.monitor_heart, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              l10n.translate('noReadingsYet'),
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.translate('noReadingsHint'),
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
