import 'package:flutter/material.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _disease;
  String? _medicine;
  int? _durationDays;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);
  bool _enableReminder = false;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: _selectedTime);
    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
    }
  }

  void _saveMedicine() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final medicineData = {
      'disease': _disease!,
      'medicine': _medicine!,
      'duration': _durationDays!,
      'time': _selectedTime.format(context),
      'reminder': _enableReminder,
    };

    Navigator.pop(context, medicineData);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Add medication',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        backgroundColor: colorScheme.surface,
        elevation: isDark ? 0 : 3,
        centerTitle: true,
        iconTheme: IconThemeData(color: primary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Condition or purpose',
                  prefixIcon: Icon(Icons.sick, color: primary),
                  border: const OutlineInputBorder(),
                ),
                onSaved: (val) => _disease = val,
                validator: (val) => val == null || val.isEmpty
                    ? 'Please enter the condition'
                    : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Medication name',
                  prefixIcon: Icon(Icons.medication, color: primary),
                  border: const OutlineInputBorder(),
                ),
                onSaved: (val) => _medicine = val,
                validator: (val) => val == null || val.isEmpty
                    ? 'Please enter the medication'
                    : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Duration (days)',
                  prefixIcon: Icon(Icons.calendar_today, color: primary),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onSaved: (val) => _durationDays = int.tryParse(val ?? '0'),
                validator: (val) => val == null || val.isEmpty
                    ? 'Please enter the duration'
                    : int.tryParse(val) == null
                        ? 'Duration must be numeric'
                        : null,
              ),
              const SizedBox(height: 20),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.access_time, color: primary),
                title: Text(
                  'Reminder time: ${_selectedTime.format(context)}',
                  style: theme.textTheme.bodyLarge,
                ),
                trailing: TextButton(
                  onPressed: () => _selectTime(context),
                  child: Text(
                    'Change time',
                    style: theme.textTheme.bodyMedium?.copyWith(color: primary),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SwitchListTile(
                title: Text(
                  'Enable reminder',
                  style: theme.textTheme.bodyLarge,
                ),
                value: _enableReminder,
                activeThumbColor: primary,
                onChanged: (val) => setState(() => _enableReminder = val),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _saveMedicine,
                icon: const Icon(Icons.save, color: Colors.white),
                label: Text(
                  'Save medication',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 18,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
