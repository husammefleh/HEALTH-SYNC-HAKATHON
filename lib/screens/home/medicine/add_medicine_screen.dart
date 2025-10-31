import 'package:flutter/material.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _medicineController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  @override
  void dispose() {
    _medicineController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _saveMedicine() {
    if (!_formKey.currentState!.validate()) return;
    final medicineData = {
      'medicineName': _medicineController.text.trim(),
      'dosage': _dosageController.text.trim(),
      'frequencyPerDay': int.parse(_frequencyController.text.trim()),
      'durationDays': int.parse(_durationController.text.trim()),
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
                controller: _medicineController,
                decoration: InputDecoration(
                  labelText: 'Medication name',
                  prefixIcon: Icon(Icons.medication, color: primary),
                  border: const OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty
                    ? 'Please enter the medication'
                    : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _dosageController,
                decoration: InputDecoration(
                  labelText: 'Dosage (e.g. 500 mg)',
                  prefixIcon: Icon(Icons.scale, color: primary),
                  border: const OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty
                    ? 'Please enter the dosage'
                    : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _frequencyController,
                decoration: InputDecoration(
                  labelText: 'Frequency per day',
                  prefixIcon: Icon(Icons.schedule, color: primary),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || val.isEmpty
                    ? 'Please enter how many times per day'
                    : int.tryParse(val.trim()) == null
                        ? 'Frequency must be numeric'
                        : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _durationController,
                decoration: InputDecoration(
                  labelText: 'Duration (days)',
                  prefixIcon: Icon(Icons.calendar_today, color: primary),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || val.isEmpty
                    ? 'Please enter the duration'
                    : int.tryParse(val.trim()) == null
                        ? 'Duration must be numeric'
                        : null,
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
