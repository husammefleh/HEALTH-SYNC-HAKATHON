import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/analysis_models.dart';
import '../../common/ai_loading_screen.dart';
import 'food_analysis_screen.dart';

class FoodAddScreen extends StatefulWidget {
  const FoodAddScreen({super.key});

  @override
  State<FoodAddScreen> createState() => _FoodAddScreenState();
}

class _FoodAddScreenState extends State<FoodAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  String? _mealType;
  String? _drink;
  String? _dessert;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _startAnalysis() async {
    if (!_formKey.currentState!.validate()) return;
    final description = _descriptionController.text.trim();
    final l10n = context.l10n;

    final result = await Navigator.of(context).push<FoodAnalysisOutput>(
      AiLoadingScreen.route(
        AiAnalysisRequest<FoodAnalysisOutput>(
          loadingTitle: l10n.translate('analysingMealPlaceholder'),
          loadingDescription:
              'We are estimating macros and tailoring feedback for this meal.',
          icon: Icons.fastfood,
          perform: (coordinator, appState) => coordinator.performFoodAnalysis(
            FoodAnalysisInput(
              description: description,
              mealType: _mealType,
              drink: _drink,
              dessert: _dessert,
            ),
          ),
          onResult: (context, analysis) => FoodAnalysisScreen(result: analysis),
        ),
      ),
    );

    if (!mounted || result == null) return;
    if (!mounted) return;
    Navigator.of(context).pop(true);
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
          l10n.translate('foodAddTitle'),
          style:
              theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: colorScheme.primary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: l10n.translate('mealDescriptionLabel'),
                  hintText: l10n.translate('mealDescriptionHint'),
                  prefixIcon: Icon(Icons.fastfood, color: colorScheme.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.translate('mealDescriptionError');
                  }
                  final trimmed = value.trim();
                  if (trimmed.length < 12 || !trimmed.contains(' ')) {
                    return l10n.translate('mealDescriptionDetailError');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text(
                l10n.translate('mealTypeLabel'),
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                children: _MealChips.mealTypes
                    .map(
                      (type) => ChoiceChip(
                        label: Text(l10n.translate('mealType_$type')),
                        selected: _mealType == type,
                        onSelected: (selected) => setState(
                          () => _mealType = selected ? type : null,
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),
              _OptionalChoiceGroup(
                title: l10n.translate('drinkLabel'),
                values: _MealChips.drinks,
                selectedValue: _drink,
                onChanged: (value) => setState(() => _drink = value),
              ),
              const SizedBox(height: 24),
              _OptionalChoiceGroup(
                title: l10n.translate('dessertLabel'),
                values: _MealChips.desserts,
                selectedValue: _dessert,
                onChanged: (value) => setState(() => _dessert = value),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.analytics_outlined),
                  onPressed: _startAnalysis,
                  label: Text(l10n.translate('mealAnalyse')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MealChips {
  static const mealTypes = ['breakfast', 'lunch', 'dinner'];
  static const drinks = ['water', 'coffee', 'tea', 'juice'];
  static const desserts = ['fruit', 'cake', 'iceCream', 'none'];
}

class _OptionalChoiceGroup extends StatelessWidget {
  const _OptionalChoiceGroup({
    required this.title,
    required this.values,
    required this.selectedValue,
    required this.onChanged,
  });

  final String title;
  final List<String> values;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title (${l10n.translate('optional')})',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: values
              .map(
                (value) => ChoiceChip(
                  label: Text(l10n.translate(value)),
                  selected: selectedValue == value,
                  onSelected: (selected) => onChanged(selected ? value : null),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
