import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/analysis_models.dart';
import '../../common/ai_loading_screen.dart';
import 'health_result_screen.dart';

class AddHealthReadingScreen extends StatefulWidget {
  const AddHealthReadingScreen({super.key});

  @override
  State<AddHealthReadingScreen> createState() => _AddHealthReadingScreenState();
}

class _AddHealthReadingScreenState extends State<AddHealthReadingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bloodPressureController =
      TextEditingController();
  final TextEditingController _sugarController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    _bloodPressureController.dispose();
    _sugarController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  _BloodPressureReading? _parseBloodPressure(String? value) {
    if (value == null) return null;
    final cleaned = value.replaceAll(',', '.');
    final matches = _numberRegExp.allMatches(cleaned).toList();
    if (matches.isEmpty) return null;

    final systolicString = matches[0].group(0);
    final systolic =
        systolicString != null ? double.tryParse(systolicString) : null;
    if (systolic == null) return null;

    double? diastolic;
    String? diastolicString;
    if (matches.length > 1) {
      diastolicString = matches[1].group(0);
      diastolic =
          diastolicString != null ? double.tryParse(diastolicString) : null;
    }

    final label = diastolicString != null && diastolic != null
        ? '$systolicString/$diastolicString'
        : systolicString ?? systolic.toString();

    return _BloodPressureReading(
      systolic: systolic,
      diastolic: diastolic,
      label: label,
      rawInput: value.trim(),
    );
  }

  double? _parseNumericValue(String? value) {
    if (value == null) return null;
    final cleaned = value.replaceAll(',', '.');
    final match = _numberRegExp.firstMatch(cleaned);
    if (match == null) return null;
    final numericString = match.group(0);
    if (numericString == null) return null;
    return double.tryParse(numericString);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = context.l10n;

    final bloodPressureRaw = _bloodPressureController.text.trim();
    final sugarRaw = _sugarController.text.trim();
    final bloodPressureReading = _parseBloodPressure(bloodPressureRaw);
    final sugarLevel = _parseNumericValue(sugarRaw);

    if (bloodPressureReading == null || sugarLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.translate('generalError')),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    final recordedAt = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final result = await Navigator.of(context).push<HealthAnalysisOutput>(
      AiLoadingScreen.route(
        AiAnalysisRequest<HealthAnalysisOutput>(
          loadingTitle: 'Analysing your vitals...',
          loadingDescription:
              'We are comparing this reading with healthy ranges.',
          icon: Icons.favorite,
          perform: (coordinator, appState) => coordinator.performHealthAnalysis(
            HealthAnalysisInput(
              bloodPressure: bloodPressureReading.systolic,
              diastolic: bloodPressureReading.diastolic,
              bloodPressureLabel: bloodPressureReading.label,
              sugarLevel: sugarLevel,
              recordedAt: recordedAt,
            ),
          ),
          onResult: (context, analysis) =>
              HealthResultScreen(result: analysis, recordedAt: recordedAt),
        ),
      ),
    );

    if (!mounted) return;

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.translate('healthReadingSaved')),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
      Navigator.of(context).pop(true);
    }
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
          l10n.translate('addHealthReadingTitle'),
          style:
              theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _ReadingInput(
                controller: _bloodPressureController,
                label: l10n.translate('bloodPressureInputLabel'),
                hint: '120',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.translate('bloodPressureRequired');
                  }
                  return _parseBloodPressure(value) == null
                      ? l10n.translate('bloodPressureRequired')
                      : null;
                },
              ),
              _ReadingInput(
                controller: _sugarController,
                label: l10n.translate('bloodSugarInputLabel'),
                hint: '110',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.translate('bloodSugarRequired');
                  }
                  return _parseNumericValue(value) == null
                      ? l10n.translate('bloodSugarRequired')
                      : null;
                },
              ),
              const SizedBox(height: 12),
              Text(
                l10n.translate('dateAndTime'),
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickDate,
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        DateFormat.yMMMd(l10n.locale.toLanguageTag())
                            .format(_selectedDate),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickTime,
                      icon: const Icon(Icons.access_time),
                      label: Text(
                        _selectedTime.format(context),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.save_alt),
                  onPressed: _submit,
                  label: Text(l10n.translate('saveReading')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReadingInput extends StatelessWidget {
  const _ReadingInput({
    required this.controller,
    required this.label,
    required this.hint,
    required this.validator,
    this.keyboardType = TextInputType.text,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: validator,
      ),
    );
  }
}

class _BloodPressureReading {
  const _BloodPressureReading({
    required this.systolic,
    this.diastolic,
    required this.label,
    required this.rawInput,
  });

  final double systolic;
  final double? diastolic;
  final String label;
  final String rawInput;
}

final RegExp _numberRegExp = RegExp(r'-?\d+(\.\d+)?');
