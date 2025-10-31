import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/analysis_models.dart';
import '../../../models/medicine_entry.dart';
import '../../../state/app_state.dart';
import '../../common/ai_loading_screen.dart';
import '../../common/hedera_badge.dart';
import 'add_medicine_screen.dart';
import 'medicine_result_screen.dart';

class MedicineScreen extends StatelessWidget {
  const MedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final medicines = List<MedicineEntry>.from(
      context.watch<AppState>().medicineEntries,
    )..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: isDark ? 0 : 3,
        centerTitle: true,
        title: Text(
          'Medication',
          style:
              theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: primary),
      ),
      body: medicines.isEmpty
          ? const _EmptyMedicineState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: medicines.length,
              itemBuilder: (context, index) {
                final medicine = medicines[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: isDark ? 0 : 3,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      medicine.medicineName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: medicine.taken ? Colors.grey : primary,
                        decoration: medicine.taken
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dosage: ${medicine.dosage}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          'Frequency: ${medicine.frequencyPerDay} / day',
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          'Duration: ${medicine.durationDays} days',
                          style: theme.textTheme.bodyMedium,
                        ),
                        if (medicine.recommendation != null &&
                            medicine.recommendation!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              medicine.recommendation!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.textTheme.bodySmall?.color
                                    ?.withOpacity(0.7),
                              ),
                            ),
                          ),
                        Text(
                          'Added: ${medicine.createdAt.toLocal().toString().split(' ').first}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 6),
                        const HederaBadge(compact: true),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        medicine.taken
                            ? Icons.check_circle
                            : Icons.alarm_add_rounded,
                        color:
                            medicine.taken ? Colors.green : Colors.orangeAccent,
                        size: 30,
                      ),
                      onPressed: () => context
                          .read<AppState>()
                          .toggleMedicineTaken(medicine.id),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addMedicine(context),
        backgroundColor: primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> _addMedicine(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final theme = Theme.of(context);
    final data = await navigator.push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (context) => const AddMedicineScreen()),
    );

    if (!context.mounted) return;
    if (!context.mounted || data == null) return;

    final name = data['medicineName'] as String;
    final dosage = data['dosage'] as String;
    final frequency = data['frequencyPerDay'] as int;
    final duration = data['durationDays'] as int;

    final result = await navigator.push<MedicineAnalysisOutput>(
      AiLoadingScreen.route(
        AiAnalysisRequest<MedicineAnalysisOutput>(
          loadingTitle: 'Analysing your medication...',
          loadingDescription:
              'We are preparing adherence insights and reminder guidance.',
          icon: Icons.medication,
          perform: (coordinator, appState) =>
              coordinator.performMedicineAnalysis(
            MedicineAnalysisInput(
              medicineName: name,
              dosage: dosage,
              frequencyPerDay: frequency,
              durationDays: duration,
            ),
          ),
          onResult: (context, analysis) =>
              MedicineResultScreen(result: analysis),
        ),
      ),
    );

    if (!context.mounted) return;

    if (result != null) {
      messenger.showSnackBar(
        SnackBar(
          content: const Text('Medication saved to your history.'),
          backgroundColor: theme.colorScheme.primary,
        ),
      );
    }
  }
}

class _EmptyMedicineState extends StatelessWidget {
  const _EmptyMedicineState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.medication_outlined, color: primary, size: 80),
            const SizedBox(height: 20),
            Text(
              'No medication tracked yet.',
              style: theme.textTheme.titleMedium?.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Add a prescription to receive reminders and keep your adherence history.',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
