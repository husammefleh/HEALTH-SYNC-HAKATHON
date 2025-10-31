import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/analysis_models.dart';

class FoodAnalysisScreen extends StatefulWidget {
  const FoodAnalysisScreen({super.key, required this.result});

  final FoodAnalysisOutput result;

  @override
  State<FoodAnalysisScreen> createState() => _FoodAnalysisScreenState();
}

class _FoodAnalysisScreenState extends State<FoodAnalysisScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;
    final analysis = widget.result;
    final description = analysis.description.isNotEmpty
        ? analysis.description
        : l10n.translate('mealAnalysis');
    final mealType = analysis.mealType;
    final drink = analysis.drink;
    final dessert = analysis.dessert;

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
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AnalysisSummary(
              description: description,
              mealType: mealType != null
                  ? l10n.translate('mealType_$mealType')
                  : null,
              drink: drink != null ? l10n.translate(drink) : null,
              dessert: dessert != null && dessert != 'none'
                  ? l10n.translate(dessert)
                  : null,
              summary: analysis.summary ?? analysis.recommendation,
              theme: theme,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 24),
            _MacrosCard(
              colorScheme: colorScheme,
              calories: analysis.calories,
              protein: analysis.protein,
              carbs: analysis.carbs,
              fats: analysis.fat,
              cholesterol: analysis.cholesterol,
              l10n: l10n,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.check),
                onPressed: () => Navigator.of(context).pop(),
                label: Text(l10n.translate('saveToHistory')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalysisSummary extends StatelessWidget {
  const _AnalysisSummary({
    required this.description,
    required this.summary,
    required this.theme,
    required this.colorScheme,
    this.mealType,
    this.drink,
    this.dessert,
  });

  final String description;
  final String summary;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final String? mealType;
  final String? drink;
  final String? dessert;

  @override
  Widget build(BuildContext context) {
    final tags = <String>[];
    if (mealType != null) tags.add(mealType!);
    if (drink != null) {
      tags.add('${context.l10n.translate('drinkLabel')}: $drink');
    }
    if (dessert != null) {
      tags.add('${context.l10n.translate('dessertLabel')}: $dessert');
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: theme.brightness == Brightness.dark
            ? const []
            : [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
        border: Border.all(
          color: theme.brightness == Brightness.dark
              ? colorScheme.outlineVariant
              : Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          if (tags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: tags
                  .map(
                    (tag) => Chip(
                      label: Text(tag),
                      backgroundColor: colorScheme.primary.withAlpha(24),
                    ),
                  )
                  .toList(),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            summary,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _MacrosCard extends StatelessWidget {
  const _MacrosCard({
    required this.colorScheme,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.cholesterol,
    required this.l10n,
  });

  final ColorScheme colorScheme;
  final int calories;
  final double protein;
  final double carbs;
  final double fats;
  final double cholesterol;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.primary.withAlpha(40)),
      ),
      child: Column(
        children: [
          _MacroRow(
            label: l10n.translate('calories'),
            value: '$calories kcal',
          ),
          const Divider(),
          _MacroRow(
            label: l10n.translate('protein'),
            value: '${protein.toStringAsFixed(1)} g',
          ),
          const Divider(),
          _MacroRow(
            label: l10n.translate('carbs'),
            value: '${carbs.toStringAsFixed(1)} g',
          ),
          const Divider(),
          _MacroRow(
            label: l10n.translate('fats'),
            value: '${fats.toStringAsFixed(1)} g',
          ),
          const Divider(),
          _MacroRow(
            label: l10n.translate('cholesterol'),
            value: '${cholesterol.toStringAsFixed(0)} mg',
          ),
        ],
      ),
    );
  }
}

class _MacroRow extends StatelessWidget {
  const _MacroRow({required this.label, required this.value});

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
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
