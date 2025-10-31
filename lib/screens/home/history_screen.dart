import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/activity_entry.dart';
import '../../models/food_entry.dart';
import '../../models/health_reading.dart';
import '../../models/medicine_entry.dart';
import '../../models/sleep_entry.dart';
import '../../state/app_state.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final l10n = context.l10n;
    final items = _buildHistory(appState, l10n);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.translate('history'),
          style:
              theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: isDark ? 0 : 2,
        iconTheme: IconThemeData(color: primary),
      ),
      body: items.isEmpty
          ? _EmptyHistory(l10n: l10n)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: isDark ? 0 : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: Icon(item.icon, color: item.color, size: 32),
                    title: Text(
                      item.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${item.subtitle}\n${item.date}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                        height: 1.4,
                      ),
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }

  List<_HistoryItem> _buildHistory(
    AppState state,
    AppLocalizations l10n,
  ) {
    final localeTag = l10n.locale.toLanguageTag();
    final dateFormatter = DateFormat.yMMMd(localeTag).add_Hm();
    final hederaSource = l10n.translate('historySyncedViaHedera');

    final List<_HistoryItem> entries = [
      for (final FoodEntry entry in state.foodEntries)
        _HistoryItem(
          date: l10n
              .translate('historyRecordedOn')
              .replaceFirst('{date}', dateFormatter.format(entry.analysedAt)),
          icon: Icons.restaurant_menu,
          color: Colors.orangeAccent,
          title: l10n
              .translate('historyFoodTitle')
              .replaceFirst('{name}', entry.description),
          subtitle: [
            l10n
                .translate('historyFoodSubtitle')
                .replaceFirst('{calories}', entry.calories.toString())
                .replaceFirst(
                    '{protein}', entry.proteinGrams.toStringAsFixed(1))
                .replaceFirst('{carbs}', entry.carbsGrams.toStringAsFixed(1)),
            hederaSource,
          ].join('\n'),
          rawDate: entry.analysedAt,
        ),
      for (final SleepEntry entry in state.sleepEntries)
        _HistoryItem(
          date: l10n
              .translate('historyRecordedOn')
              .replaceFirst('{date}', dateFormatter.format(entry.date)),
          icon: Icons.nightlight_round,
          color: Colors.indigoAccent,
          title: l10n
              .translate('historySleepTitle')
              .replaceFirst('{hours}', entry.hours.toStringAsFixed(1)),
          subtitle: [
            if (entry.recommendation != null &&
                entry.recommendation!.isNotEmpty)
              l10n
                  .translate('historySleepRecommendation')
                  .replaceFirst('{tip}', entry.recommendation!)
            else
              l10n.translate('historySleepRecommendationPending'),
            hederaSource,
          ].join('\n'),
          rawDate: entry.date,
        ),
      for (final ActivityEntry entry in state.activityEntries)
        _HistoryItem(
          date: l10n
              .translate('historyRecordedOn')
              .replaceFirst('{date}', dateFormatter.format(entry.createdAt)),
          icon: Icons.fitness_center,
          color: Colors.green,
          title: l10n
              .translate('historyActivityTitle')
              .replaceFirst('{name}', entry.name),
          subtitle: [
            l10n
                .translate('historyActivitySubtitle')
                .replaceFirst('{minutes}', entry.minutes.toString())
                .replaceFirst('{calories}', entry.calories.toString()),
            hederaSource,
          ].join('\n'),
          rawDate: entry.createdAt,
        ),
      for (final MedicineEntry entry in state.medicineEntries)
        _HistoryItem(
          date: l10n
              .translate('historyRecordedOn')
              .replaceFirst('{date}', dateFormatter.format(entry.createdAt)),
          icon: Icons.medical_services_outlined,
          color: Colors.redAccent,
          title: l10n
              .translate('historyMedicineTitle')
              .replaceFirst('{name}', entry.medicineName),
          subtitle: [
            l10n
                .translate('historyMedicineSubtitle')
                .replaceFirst('{dosage}', entry.dosage)
                .replaceFirst('{frequency}', entry.frequencyPerDay.toString())
                .replaceFirst('{duration}', entry.durationDays.toString())
                .replaceFirst(
                  '{taken}',
                  entry.taken
                      ? l10n.translate('historyMedicineTakenSuffix')
                      : '',
                ),
            hederaSource,
          ].join('\n'),
          rawDate: entry.createdAt,
        ),
      for (final HealthReading reading in state.healthReadings)
        _HistoryItem(
          date: l10n
              .translate('historyRecordedOn')
              .replaceFirst('{date}', dateFormatter.format(reading.recordedAt)),
          icon: Icons.monitor_heart,
          color: Colors.purple,
          title: l10n.translate('historyHealthTitle'),
          subtitle: [
            l10n
                .translate('historyHealthSubtitle')
                .replaceFirst(
                  '{bloodPressure}',
                  reading.bloodPressure.toStringAsFixed(0),
                )
                .replaceFirst(
                  '{bloodSugar}',
                  reading.sugarLevel.toStringAsFixed(0),
                ),
            if (reading.recommendation != null &&
                reading.recommendation!.isNotEmpty)
              l10n
                  .translate('historyHealthRecommendation')
                  .replaceFirst('{tip}', reading.recommendation!)
            else
              l10n.translate('historyHealthRecommendationPending'),
            hederaSource,
          ].join('\n'),
          rawDate: reading.recordedAt,
        ),
    ];

    entries.sort((a, b) => b.rawDate.compareTo(a.rawDate));
    return entries;
  }
}

class _HistoryItem {
  final String title;
  final String subtitle;
  final String date;
  final IconData icon;
  final Color color;
  final DateTime rawDate;

  _HistoryItem({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.icon,
    required this.color,
    required this.rawDate,
  });
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, color: primary, size: 80),
            const SizedBox(height: 20),
            Text(
              l10n.translate('historyEmptyTitle'),
              style: theme.textTheme.titleMedium?.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              l10n.translate('historyEmptyDescription'),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.explore, color: theme.colorScheme.onPrimary),
              label: Text(
                l10n.translate('historyStartTracking'),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
