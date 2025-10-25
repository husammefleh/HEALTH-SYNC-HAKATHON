import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../services/meal_analysis_service.dart';

class FoodAnalysisScreen extends StatefulWidget {
  const FoodAnalysisScreen({
    super.key,
    required this.description,
    this.mealType,
    this.drink,
    this.dessert,
  });

  final String description;
  final String? mealType;
  final String? drink;
  final String? dessert;

  @override
  State<FoodAnalysisScreen> createState() => _FoodAnalysisScreenState();
}

class _FoodAnalysisScreenState extends State<FoodAnalysisScreen> {
  Map<String, dynamic>? _analysis;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _simulateAnalysis();
  }

  Future<void> _simulateAnalysis() async {
    final service = MealAnalysisService();
    final result = await service.analyseMeal(
      description: widget.description,
      mealType: widget.mealType,
      drink: widget.drink,
      dessert: widget.dessert,
    );
    if (!mounted) return;
    setState(() => _analysis = result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: theme.brightness == Brightness.dark ? 0 : 2,
        title: Text(
          l10n.translate('mealAnalysis'),
          style:
              theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _analysis == null
            ? _AnalysisLoading(description: widget.description)
            : _AnalysisResult(
                result: _analysis!,
                description: widget.description,
                mealType: widget.mealType,
                drink: widget.drink,
                dessert: widget.dessert,
                isSaving: _isSaving,
                onSave: () async {
                  if (_analysis == null || _isSaving) return;
                  final navigator = Navigator.of(context);
                  setState(() => _isSaving = true);
                  await Future.delayed(const Duration(milliseconds: 250));
                  if (!mounted) return;
                  navigator.pop(_analysis);
                },
              ),
      ),
    );
  }
}

class _AnalysisLoading extends StatelessWidget {
  const _AnalysisLoading({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: theme.colorScheme.primary),
          const SizedBox(height: 24),
          Text(
            l10n.translate('analysingMealPlaceholder'),
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.primary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _AnalysisResult extends StatelessWidget {
  const _AnalysisResult({
    required this.result,
    required this.description,
    required this.mealType,
    required this.drink,
    required this.dessert,
    required this.onSave,
    required this.isSaving,
  });

  final Map<String, dynamic> result;
  final String description;
  final String? mealType;
  final String? drink;
  final String? dessert;
  final VoidCallback onSave;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: theme.textTheme.titleLarge,
          ),
          if (mealType != null || drink != null || dessert != null) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                if (mealType != null)
                  _Tag(label: l10n.translate('mealType_$mealType')),
                if (drink != null)
                  _Tag(label: '${l10n.translate('drinkLabel')}: ${l10n.translate(drink!)}'),
                if (dessert != null && dessert != 'none')
                  _Tag(label: '${l10n.translate('dessertLabel')}: ${l10n.translate(dessert!)}'),
              ],
            ),
          ],
          const SizedBox(height: 24),
          _NutritionRow(
            label: l10n.translate('calories'),
            value: '${result['calories']} kcal',
          ),
          const Divider(),
          _NutritionRow(
            label: l10n.translate('protein'),
            value: '${result['protein']} g',
          ),
          _NutritionRow(
            label: l10n.translate('carbs'),
            value: '${result['carbs']} g',
          ),
          _NutritionRow(
            label: l10n.translate('fats'),
            value: '${result['fats']} g',
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(30),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              result['summary'] as String? ?? '',
              style: theme.textTheme.bodyLarge,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              icon: isSaving
                  ? SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onPrimary,
                      ),
                    )
                  : const Icon(Icons.check_circle_outline),
              onPressed: isSaving ? null : onSave,
              label: Text(l10n.translate('saveToHistory')),
            ),
          ),
        ],
      ),
    );
  }
}

class _NutritionRow extends StatelessWidget {
  const _NutritionRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.titleMedium,
          ),
          Text(
            value,
            style: theme.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withAlpha(80),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium,
      ),
    );
  }
}
