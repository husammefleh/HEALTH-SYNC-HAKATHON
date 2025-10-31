import '../../utils/json_utils.dart';

class FoodEntryDto {
  FoodEntryDto({
    this.id,
    this.userId,
    this.foodName,
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
    this.date,
  });

  factory FoodEntryDto.fromJson(Map<String, dynamic> json) => FoodEntryDto(
        id: parseNullableInt(json['id']),
        userId: parseNullableInt(json['userId']),
        foodName: json['foodName'] as String?,
        calories: parseNullableDouble(json['calories']),
        protein: parseNullableDouble(json['protein']),
        carbs: parseNullableDouble(json['carbs']),
        fat: parseNullableDouble(json['fat']),
        date: json['date'] != null ? DateTime.tryParse(json['date'] as String) : null,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'userId': userId,
        'foodName': foodName,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        'date': date?.toIso8601String(),
      };

  final int? id;
  final int? userId;
  final String? foodName;
  final double? calories;
  final double? protein;
  final double? carbs;
  final double? fat;
  final DateTime? date;
}

class FoodEntryCreateDto {
  FoodEntryCreateDto({
    this.foodName,
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
    this.date,
  });

  factory FoodEntryCreateDto.fromJson(Map<String, dynamic> json) =>
      FoodEntryCreateDto(
        foodName: json['foodName'] as String?,
        calories: (json['calories'] as num?)?.toDouble(),
        protein: (json['protein'] as num?)?.toDouble(),
        carbs: (json['carbs'] as num?)?.toDouble(),
        fat: (json['fat'] as num?)?.toDouble(),
        date: json['date'] != null ? DateTime.tryParse(json['date'] as String) : null,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'foodName': foodName,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        'date': date?.toIso8601String(),
      };

  final String? foodName;
  final double? calories;
  final double? protein;
  final double? carbs;
  final double? fat;
  final DateTime? date;
}
