import 'package:meta/meta.dart';

abstract class AnalysisResultBase {
  const AnalysisResultBase({
    required this.recordId,
    required this.generatedAt,
    required this.persisted,
    this.transactionId,
    this.consensusTimestamp,
    this.rawResponse,
  });

  final String recordId;
  final DateTime generatedAt;
  final bool persisted;
  final String? transactionId;
  final String? consensusTimestamp;
  final Map<String, dynamic>? rawResponse;
}

@immutable
class FoodAnalysisInput {
  const FoodAnalysisInput({
    required this.description,
    this.mealType,
    this.drink,
    this.dessert,
  });

  final String description;
  final String? mealType;
  final String? drink;
  final String? dessert;
}

class FoodAnalysisOutput extends AnalysisResultBase {
  FoodAnalysisOutput({
    required super.recordId,
    required super.generatedAt,
    required super.persisted,
    super.transactionId,
    super.consensusTimestamp,
    super.rawResponse,
    required this.description,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.cholesterol,
    required this.recommendation,
    this.summary,
    this.mealType,
    this.drink,
    this.dessert,
  });

  final String description;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final double cholesterol;
  final String recommendation;
  final String? summary;
  final String? mealType;
  final String? drink;
  final String? dessert;
}

@immutable
class SleepAnalysisInput {
  const SleepAnalysisInput({
    required this.hours,
    required this.sleepDate,
  });

  final double hours;
  final DateTime sleepDate;
}

class SleepAnalysisOutput extends AnalysisResultBase {
  SleepAnalysisOutput({
    required super.recordId,
    required super.generatedAt,
    required super.persisted,
    super.transactionId,
    super.consensusTimestamp,
    super.rawResponse,
    required this.hours,
    required this.sleepDate,
    required this.recommendation,
    this.summary,
  });

  final double hours;
  final DateTime sleepDate;
  final String recommendation;
  final String? summary;
}

@immutable
class ActivityAnalysisInput {
  const ActivityAnalysisInput({
    required this.exerciseType,
    required this.durationMinutes,
  });

  final String exerciseType;
  final int durationMinutes;
}

class ActivityAnalysisOutput extends AnalysisResultBase {
  ActivityAnalysisOutput({
    required super.recordId,
    required super.generatedAt,
    required super.persisted,
    super.transactionId,
    super.consensusTimestamp,
    super.rawResponse,
    required this.exerciseType,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.recommendation,
    this.summary,
    this.secondaryTip,
  });

  final String exerciseType;
  final int durationMinutes;
  final int caloriesBurned;
  final String recommendation;
  final String? summary;
  final String? secondaryTip;
}

@immutable
class HealthAnalysisInput {
  const HealthAnalysisInput({
    required this.bloodPressure,
    required this.sugarLevel,
    required this.recordedAt,
    this.bloodPressureLabel,
    this.diastolic,
    this.heartRate,
  });

  final double bloodPressure;
  final double sugarLevel;
  final DateTime recordedAt;
  final String? bloodPressureLabel;
  final double? diastolic;
  final double? heartRate;
}

class HealthAnalysisOutput extends AnalysisResultBase {
  HealthAnalysisOutput({
    required super.recordId,
    required super.generatedAt,
    required super.persisted,
    super.transactionId,
    super.consensusTimestamp,
    super.rawResponse,
    required this.bloodPressure,
    required this.sugarLevel,
    required this.recommendation,
    this.heartRate,
    this.summary,
    this.bloodPressureLabel,
    this.diastolic,
    this.sugarLevelLabel,
  });

  final double bloodPressure;
  final double sugarLevel;
  final double? heartRate;
  final String recommendation;
  final String? summary;
  final String? bloodPressureLabel;
  final double? diastolic;
  final String? sugarLevelLabel;
}

@immutable
class MedicineAnalysisInput {
  const MedicineAnalysisInput({
    required this.medicineName,
    required this.dosage,
    required this.frequencyPerDay,
    required this.durationDays,
  });

  final String medicineName;
  final String dosage;
  final int frequencyPerDay;
  final int durationDays;
}

class MedicineAnalysisOutput extends AnalysisResultBase {
  MedicineAnalysisOutput({
    required super.recordId,
    required super.generatedAt,
    required super.persisted,
    super.transactionId,
    super.consensusTimestamp,
    super.rawResponse,
    required this.medicineName,
    required this.dosage,
    required this.frequencyPerDay,
    required this.durationDays,
    required this.recommendation,
    this.summary,
  });

  final String medicineName;
  final String dosage;
  final int frequencyPerDay;
  final int durationDays;
  final String recommendation;
  final String? summary;
}
