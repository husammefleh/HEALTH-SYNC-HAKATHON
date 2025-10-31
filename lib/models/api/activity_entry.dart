import '../../utils/json_utils.dart';

class ActivityEntryDto {
  ActivityEntryDto({
    this.id,
    this.userId,
    this.activityType,
    this.duration,
    this.caloriesBurned,
    this.date,
  });

  factory ActivityEntryDto.fromJson(Map<String, dynamic> json) => ActivityEntryDto(
        id: parseNullableInt(json['id']),
        userId: parseNullableInt(json['userId']),
        activityType: json['activityType'] as String?,
        duration: parseNullableDouble(json['duration']),
        caloriesBurned: parseNullableDouble(json['caloriesBurned']),
        date: json['date'] != null ? DateTime.tryParse(json['date'] as String) : null,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'userId': userId,
        'activityType': activityType,
        'duration': duration,
        'caloriesBurned': caloriesBurned,
        'date': date?.toIso8601String(),
      };

  final int? id;
  final int? userId;
  final String? activityType;
  final double? duration;
  final double? caloriesBurned;
  final DateTime? date;
}

class ActivityEntryCreateDto {
  ActivityEntryCreateDto({
    this.activityType,
    this.duration,
    this.caloriesBurned,
    this.date,
  });

  factory ActivityEntryCreateDto.fromJson(Map<String, dynamic> json) =>
      ActivityEntryCreateDto(
        activityType: json['activityType'] as String?,
        duration: (json['duration'] as num?)?.toDouble(),
        caloriesBurned: (json['caloriesBurned'] as num?)?.toDouble(),
        date: json['date'] != null ? DateTime.tryParse(json['date'] as String) : null,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'activityType': activityType,
        'duration': duration,
        'caloriesBurned': caloriesBurned,
        'date': date?.toIso8601String(),
      };

  final String? activityType;
  final double? duration;
  final double? caloriesBurned;
  final DateTime? date;
}
