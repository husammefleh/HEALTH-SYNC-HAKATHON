import '../../utils/json_utils.dart';

class SleepEntryDto {
  SleepEntryDto({
    this.id,
    this.userId,
    this.hoursSlept,
    this.sleepDate,
  });

  factory SleepEntryDto.fromJson(Map<String, dynamic> json) => SleepEntryDto(
        id: parseNullableInt(json['id']),
        userId: parseNullableInt(json['userId']),
        hoursSlept: parseNullableDouble(json['hoursSlept']),
        sleepDate: json['sleepDate'] != null
            ? DateTime.tryParse(json['sleepDate'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'userId': userId,
        'hoursSlept': hoursSlept,
        'sleepDate': sleepDate?.toIso8601String(),
      };

  final int? id;
  final int? userId;
  final double? hoursSlept;
  final DateTime? sleepDate;
}

class SleepEntryCreateDto {
  SleepEntryCreateDto({
    this.hoursSlept,
    this.sleepDate,
  });

  factory SleepEntryCreateDto.fromJson(Map<String, dynamic> json) =>
      SleepEntryCreateDto(
        hoursSlept: parseNullableDouble(json['hoursSlept']),
        sleepDate: json['sleepDate'] != null
            ? DateTime.tryParse(json['sleepDate'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'hoursSlept': hoursSlept,
        'sleepDate': sleepDate?.toIso8601String(),
      };

  final double? hoursSlept;
  final DateTime? sleepDate;
}
