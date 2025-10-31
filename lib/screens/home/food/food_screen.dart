import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/food_entry.dart';
import '../../../state/app_state.dart';
import '../../common/hedera_badge.dart';
import 'food_add_screen.dart';

class FoodScreen extends StatelessWidget {
  const FoodScreen({super.key});

  static const int _dailyGoal = 2200;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final List<FoodEntry> entries = List<FoodEntry>.from(appState.foodEntries);
    final today = DateTime.now();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final l10n = context.l10n;

    final todaysCalories = entries
        .where((entry) =>
            entry.analysedAt.year == today.year &&
            entry.analysedAt.month == today.month &&
            entry.analysedAt.day == today.day)
        .fold<int>(0, (sum, entry) => sum + entry.calories);

    final remaining = (_dailyGoal - todaysCalories).clamp(0, _dailyGoal);
    final progress = (todaysCalories / _dailyGoal).clamp(0, 1).toDouble();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: theme.brightness == Brightness.dark ? 0 : 2,
        title: Text(
          l10n.translate('mealsNutrition'),
          style:
              theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: primary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primary.withAlpha(26),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s overview',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: progress,
                    color: primary,
                    backgroundColor: primary.withAlpha(51),
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Calories today: $todaysCalories / $_dailyGoal',
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    remaining > 0
                        ? l10n
                            .translate('remainingCaloriesMessage')
                            .replaceFirst('{remaining}', remaining.toString())
                        : l10n.translate('calorieGoalReached'),
                    style: TextStyle(
                      fontSize: 15,
                      color: remaining > 0 ? primary : theme.colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.translate('mealHistory'),
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
                        l10n.translate('noMealsPlaceholder'),
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
                        final meal = entries[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation:
                              theme.brightness == Brightness.dark ? 0 : 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.fastfood, color: primary),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            meal.description,
                                            style: theme.textTheme.titleMedium
                                                ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _formatDate(
                                                context, meal.analysedAt),
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                              color: theme
                                                  .textTheme.bodySmall?.color
                                                  ?.withOpacity(0.6),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const HederaBadge(),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${meal.calories} kcal',
                                          style: theme.textTheme.titleMedium,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: [
                                    if (meal.mealType != null)
                                      _MealTag(
                                          label: l10n.translate(
                                              'mealType_${meal.mealType}')),
                                    if (meal.drink != null)
                                      _MealTag(
                                          label:
                                              '${l10n.translate('drinkLabel')}: ${l10n.translate(meal.drink!)}'),
                                    if (meal.dessert != null &&
                                        meal.dessert != 'none')
                                      _MealTag(
                                        label:
                                            '${l10n.translate('dessertLabel')}: ${l10n.translate(meal.dessert!)}',
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 8,
                                  children: [
                                    _MacroBadge(
                                      label: l10n.translate('protein'),
                                      value:
                                          '${meal.proteinGrams.toStringAsFixed(1)} g',
                                      color: Colors.green,
                                    ),
                                    _MacroBadge(
                                      label: l10n.translate('carbs'),
                                      value:
                                          '${meal.carbsGrams.toStringAsFixed(1)} g',
                                      color: Colors.orange,
                                    ),
                                    _MacroBadge(
                                      label: l10n.translate('fats'),
                                      value:
                                          '${meal.fatGrams.toStringAsFixed(1)} g',
                                      color: Colors.redAccent,
                                    ),
                                    _MacroBadge(
                                      label: 'Cholesterol',
                                      value:
                                          '${meal.cholesterolMg.toStringAsFixed(0)} mg',
                                      color: Colors.deepPurple,
                                    ),
                                  ],
                                ),
                                if (meal.aiSummary.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                    meal.aiSummary,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addMeal(context),
        backgroundColor: primary,
        label: Text(l10n.translate('addMeal')),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addMeal(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    final added = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (context) => const FoodAddScreen()),
    );

    if (!context.mounted) return;

    if (added == true) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(context.l10n.translate('mealSavedMessage')),
          backgroundColor: theme.colorScheme.primary,
        ),
      );
    }
  }

  static String _formatDate(BuildContext context, DateTime date) {
    final localeCode = context.l10n.locale.toLanguageTag();
    final formatter = DateFormat.yMMMd(localeCode).add_jm();
    return formatter.format(date);
  }
}

class _MealTag extends StatelessWidget {
  const _MealTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(90),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium,
      ),
    );
  }
}

class _MacroBadge extends StatelessWidget {
  const _MacroBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelMedium),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withAlpha(40),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: theme.textTheme.labelMedium?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
