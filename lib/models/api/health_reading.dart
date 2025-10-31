import '../../utils/json_utils.dart';

class HealthReadingDto {
  HealthReadingDto({
    this.id,
    this.userId,
    this.bloodPressure,
    this.heartRate,
    this.sugarLevel,
    this.recordedAt,
  });

  factory HealthReadingDto.fromJson(Map<String, dynamic> json) =>
      HealthReadingDto(
        id: parseNullableInt(json['id']),
        userId: parseNullableInt(json['userId']),
        bloodPressure: parseNullableDouble(json['bloodPressure']),
        heartRate: parseNullableDouble(json['heartRate']),
        sugarLevel: parseNullableDouble(json['sugarLevel'] ?? json['glucose']),
        recordedAt: json['recordedAt'] != null
            ? DateTime.tryParse(json['recordedAt'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'userId': userId,
        'bloodPressure': bloodPressure,
        'heartRate': heartRate,
        'sugarLevel': sugarLevel,
        'recordedAt': recordedAt?.toIso8601String(),
      };

  final int? id;
  final int? userId;
  final double? bloodPressure;
  final double? heartRate;
  final double? sugarLevel;
  final DateTime? recordedAt;
}

class HealthReadingCreateDto {
  HealthReadingCreateDto({
    this.bloodPressure,
    this.heartRate,
    this.sugarLevel,
    this.recordedAt,
  });

  factory HealthReadingCreateDto.fromJson(Map<String, dynamic> json) =>
      HealthReadingCreateDto(
        bloodPressure: parseNullableDouble(json['bloodPressure']),
        heartRate: parseNullableDouble(json['heartRate']),
        sugarLevel: parseNullableDouble(json['sugarLevel'] ?? json['glucose']),
        recordedAt: json['recordedAt'] != null
            ? DateTime.tryParse(json['recordedAt'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'bloodPressure': bloodPressure,
        'heartRate': heartRate,
        'sugarLevel': sugarLevel,
        'recordedAt': recordedAt?.toIso8601String(),
      };

  final double? bloodPressure;
  final double? heartRate;
  final double? sugarLevel;
  final DateTime? recordedAt;
}
