import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../../state/app_state.dart';
import '../../common/hedera_badge.dart';
import 'add_activity_screen.dart';

class ActivityMainScreen extends StatelessWidget {
  const ActivityMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = [...context.watch<AppState>().activityEntries]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final totalCalories =
        entries.fold<int>(0, (sum, item) => sum + item.calories);
    final totalMinutes =
        entries.fold<int>(0, (sum, item) => sum + item.minutes);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: theme.brightness == Brightness.dark ? 0 : 2,
        title: Text(
          l10n.translate('activityTracking'),
          style:
              theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: primary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primary.withAlpha(26),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.translate('activitySummaryTitle'),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primary,
                          ),
                        ),
                      ),
                      const HederaBadge(compact: true),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n
                        .translate('activitySummaryCalories')
                        .replaceFirst('{calories}', totalCalories.toString()),
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n
                        .translate('activitySummaryMinutes')
                        .replaceFirst('{minutes}', totalMinutes.toString()),
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n
                        .translate('activitySummarySessions')
                        .replaceFirst('{count}', entries.length.toString()),
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.translate('activitySummaryTip'),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Text(
              l10n.translate('activityHistoryTitle'),
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
            const SizedBox(height: 10),
            entries.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Text(
                        l10n.translate('activityHistoryEmpty'),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                          color: theme.textTheme.bodyMedium?.color
                              ?.withOpacity(0.7),
                        ),
                      ),
                    ),
                  )
                : Column(
                    children: entries.map((activity) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Icon(Icons.fitness_center, color: primary),
                          title: Text(
                            activity.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activity.calories > 0
                                    ? l10n
                                        .translate('activitySessionDetail')
                                        .replaceFirst('{minutes}',
                                            activity.minutes.toString())
                                        .replaceFirst('{calories}',
                                            activity.calories.toString())
                                    : '${activity.minutes} min',
                              ),
                              if (activity.recommendation != null &&
                                  activity.recommendation!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    activity.recommendation!,
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ),
                            ],
                          ),
                          trailing: const HederaBadge(compact: true),
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        onPressed: () => _addActivity(context),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  Future<void> _addActivity(BuildContext context) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final primary = theme.colorScheme.primary;
    await navigator.push<void>(
      MaterialPageRoute(builder: (context) => const AddActivityScreen()),
    );

    if (!context.mounted) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.translate('activitySavedMessage')),
        backgroundColor: primary,
      ),
    );
  }
}
