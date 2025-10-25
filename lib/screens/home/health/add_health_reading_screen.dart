import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/health_reading.dart';
import '../../../state/app_state.dart';

class AddHealthReadingScreen extends StatefulWidget {
  const AddHealthReadingScreen({super.key});

  @override
  State<AddHealthReadingScreen> createState() =>
      _AddHealthReadingScreenState();
}

class _AddHealthReadingScreenState extends State<AddHealthReadingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bloodPressureController =
      TextEditingController();
  final TextEditingController _bloodSugarController = TextEditingController();

  bool _trackBloodPressure = true;
  bool _trackBloodSugar = true;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    _bloodPressureController.dispose();
    _bloodSugarController.dispose();
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = context.l10n;

    final recordedAt = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final List<HealthReading> readings = [];
    if (_trackBloodPressure) {
      readings.add(
        HealthReading(
          id: const Uuid().v4(),
          kind: HealthReadingKind.bloodPressure,
          value: _bloodPressureController.text.trim(),
          recordedAt: recordedAt,
        ),
      );
    }

    if (_trackBloodSugar) {
      readings.add(
        HealthReading(
          id: const Uuid().v4(),
          kind: HealthReadingKind.bloodSugar,
          value: _bloodSugarController.text.trim(),
          recordedAt: recordedAt,
        ),
      );
    }

    await context.read<AppState>().addHealthReadings(readings);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.translate('healthReadingSaved')),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
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
              Text(
                l10n.translate('selectReadingType'),
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                value: _trackBloodPressure,
                onChanged: (value) => setState(() => _trackBloodPressure = value),
                title: Text(l10n.translate('bloodPressure')),
                subtitle: Text(l10n.translate('bloodPressureHint')),
              ),
              SwitchListTile(
                value: _trackBloodSugar,
                onChanged: (value) => setState(() => _trackBloodSugar = value),
                title: Text(l10n.translate('bloodSugar')),
                subtitle: Text(l10n.translate('bloodSugarHint')),
              ),
              const SizedBox(height: 12),
              if (_trackBloodPressure)
                _ReadingInput(
                  controller: _bloodPressureController,
                  label: l10n.translate('bloodPressureInputLabel'),
                  hint: '120/80',
                  validator: (value) {
                    if (!_trackBloodPressure) return null;
                    if (value == null || value.trim().isEmpty) {
                      return l10n.translate('bloodPressureRequired');
                    }
                    return null;
                  },
                ),
              if (_trackBloodSugar)
                _ReadingInput(
                  controller: _bloodSugarController,
                  label: l10n.translate('bloodSugarInputLabel'),
                  hint: '105',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (!_trackBloodSugar) return null;
                    if (value == null || value.trim().isEmpty) {
                      return l10n.translate('bloodSugarRequired');
                    }
                    return null;
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
                  onPressed:
                      _trackBloodPressure || _trackBloodSugar ? _submit : null,
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
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

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
