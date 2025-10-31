import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/analysis_models.dart';
import '../../common/ai_loading_screen.dart';
import 'sleep_result_screen.dart';

class AddSleepScreen extends StatefulWidget {
  const AddSleepScreen({super.key});

  @override
  State<AddSleepScreen> createState() => _AddSleepScreenState();
}

class _AddSleepScreenState extends State<AddSleepScreen> {
  DateTime selectedDate = DateTime.now();
  double sleepHours = 7;
  bool _isSaving = false;

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.translate('sleepAddEntry')),
        backgroundColor: colorScheme.surface,
        elevation: 2,
        centerTitle: true,
        iconTheme: IconThemeData(color: primary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: primary.withAlpha(51)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.08),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${l10n.translate('dateAndTime')}: ${selectedDate.toLocal().toString().split(' ')[0]}',
                    style: theme.textTheme.bodyLarge,
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today, color: primary),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.translate('sleepHours'),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Slider(
                  value: sleepHours,
                  min: 1,
                  max: 12,
                  divisions: 11,
                  activeColor: primary,
                  label: '${sleepHours.toStringAsFixed(1)} h',
                  onChanged: (value) => setState(() => sleepHours = value),
                ),
                Center(
                  child: Text(
                    '${sleepHours.toStringAsFixed(1)} h',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: primary,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: _isSaving
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : const Icon(Icons.analytics_outlined),
                label: Text(
                  _isSaving ? 'Analysing...' : l10n.translate('sleepSubmit'),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimary,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isSaving ? null : () => _submitSleep(context),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _submitSleep(BuildContext context) async {
    final navigator = Navigator.of(context);
    setState(() => _isSaving = true);
    try {
      final result = await navigator.push<SleepAnalysisOutput>(
        AiLoadingScreen.route(
          AiAnalysisRequest<SleepAnalysisOutput>(
            loadingTitle: 'Analysing your sleep...',
            loadingDescription:
                'We are preparing personalised feedback to help you recover better.',
            icon: Icons.nightlight_round,
            perform: (coordinator, appState) =>
                coordinator.performSleepAnalysis(
              SleepAnalysisInput(
                hours: sleepHours,
                sleepDate: selectedDate,
              ),
            ),
            onResult: (context, analysis) =>
                SleepResultScreen(result: analysis),
          ),
        ),
      );

      if (!mounted) return;
      if (result != null) {
        navigator.pop();
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
