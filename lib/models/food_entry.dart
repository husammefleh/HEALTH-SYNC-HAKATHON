class FoodEntry {
  final String id;
  final String description;
  final String? mealType;
  final String? drink;
  final String? dessert;
  final int calories;
  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;
  final String aiSummary;
  final DateTime analysedAt;

  const FoodEntry({
    required this.id,
    required this.description,
    required this.calories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.aiSummary,
    required this.analysedAt,
    this.mealType,
    this.drink,
    this.dessert,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'mealType': mealType,
      'drink': drink,
      'dessert': dessert,
      'calories': calories,
      'proteinGrams': proteinGrams,
      'carbsGrams': carbsGrams,
      'fatGrams': fatGrams,
      'aiSummary': aiSummary,
      'analysedAt': analysedAt.toIso8601String(),
    };
  }

  factory FoodEntry.fromMap(Map<String, dynamic> map) {
    // Backwards compatibility: older entries stored a simple name + calories.
    final hasAnalysis = map.containsKey('description');
    if (!hasAnalysis) {
      return FoodEntry(
        id: map['id'] as String,
        description: map['name'] as String? ?? 'Meal',
        calories: (map['calories'] as num?)?.toInt() ?? 0,
        proteinGrams: 0,
        carbsGrams: 0,
        fatGrams: 0,
        aiSummary: '',
        analysedAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
      );
    }

    return FoodEntry(
      id: map['id'] as String,
      description: map['description'] as String? ?? 'Meal',
      mealType: map['mealType'] as String?,
      drink: map['drink'] as String?,
      dessert: map['dessert'] as String?,
      calories: (map['calories'] as num).toInt(),
      proteinGrams: (map['proteinGrams'] as num).toDouble(),
      carbsGrams: (map['carbsGrams'] as num).toDouble(),
      fatGrams: (map['fatGrams'] as num).toDouble(),
      aiSummary: map['aiSummary'] as String? ?? '',
      analysedAt: DateTime.parse(
        map['analysedAt'] as String? ?? map['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
