import 'dart:math';

class MealAnalysisService {
  const MealAnalysisService();

  Future<Map<String, dynamic>> analyseMeal({
    required String description,
    String? mealType,
    String? drink,
    String? dessert,
  }) async {
    // Simulate backend latency.
    await Future.delayed(const Duration(seconds: 3));

    final seed = description.hashCode ^
        (mealType?.hashCode ?? 0) ^
        (drink?.hashCode ?? 0) ^
        (dessert?.hashCode ?? 0);
    final random = Random(seed);

    final calories = 350 + random.nextInt(251);
    final protein = 12 + random.nextDouble() * 18;
    final carbs = 25 + random.nextDouble() * 45;
    final fats = 8 + random.nextDouble() * 20;

    final summaryBuffer = StringBuffer('Balanced ');
    summaryBuffer.write(mealType ?? 'meal');
    summaryBuffer.write(' with ');
    summaryBuffer.write(protein < 20 ? 'moderate protein' : 'high protein');
    summaryBuffer.write(' and ');
    summaryBuffer.write(carbs < 40 ? 'controlled carbs' : 'satisfying carbs');
    if (drink != null && drink.isNotEmpty) {
      summaryBuffer.write('. Paired with $drink');
    }
    if (dessert != null && dessert.isNotEmpty && dessert != 'none') {
      summaryBuffer.write(' and $dessert for dessert');
    }
    summaryBuffer.write('.');

    return {
      'calories': calories,
      'protein': double.parse(protein.toStringAsFixed(1)),
      'carbs': double.parse(carbs.toStringAsFixed(1)),
      'fats': double.parse(fats.toStringAsFixed(1)),
      'summary': summaryBuffer.toString(),
    };
  }
}
