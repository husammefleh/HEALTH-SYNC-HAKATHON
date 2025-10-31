import 'package:flutter/material.dart';
import '../../../models/analysis_models.dart';
import '../../common/ai_loading_screen.dart';
import 'activity_result_screen.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();
  bool _isSaving = false;

  Future<void> _saveActivity() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final name = _nameController.text.trim();
    final minutes = int.parse(_minutesController.text.trim());

    try {
      final result = await Navigator.of(context).push<ActivityAnalysisOutput>(
        AiLoadingScreen.route(
          AiAnalysisRequest<ActivityAnalysisOutput>(
            loadingTitle: 'Analysing your workout...',
            loadingDescription:
                'We are estimating energy use and coaching tips for this session.',
            icon: Icons.fitness_center,
            perform: (coordinator, appState) =>
                coordinator.performActivityAnalysis(
              ActivityAnalysisInput(
                exerciseType: name,
                durationMinutes: minutes,
              ),
            ),
            onResult: (context, analysis) =>
                ActivityResultScreen(result: analysis),
          ),
        ),
      );

      if (!mounted) return;
      if (result != null) {
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Add workout'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        iconTheme: IconThemeData(color: primary),
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Workout details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Activity name',
                  prefixIcon: const Icon(Icons.fitness_center),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the activity name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _minutesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Duration (minutes)',
                  prefixIcon: const Icon(Icons.timer),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the duration';
                  }
                  if (int.tryParse(value.trim()) == null) {
                    return 'Duration must be numeric';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Add activity',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isSaving ? null : _saveActivity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
