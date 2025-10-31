import '../../utils/json_utils.dart';

class MedicineEntryDto {
  MedicineEntryDto({
    this.id,
    this.userId,
    this.medicineName,
    this.dosage,
    this.timeTaken,
  });

  factory MedicineEntryDto.fromJson(Map<String, dynamic> json) =>
      MedicineEntryDto(
        id: parseNullableInt(json['id']),
        userId: parseNullableInt(json['userId']),
        medicineName: json['medicineName'] as String?,
        dosage: json['dosage'] as String?,
        timeTaken: json['timeTaken'] != null
            ? DateTime.tryParse(json['timeTaken'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'userId': userId,
        'medicineName': medicineName,
        'dosage': dosage,
        'timeTaken': timeTaken?.toIso8601String(),
      };

  final int? id;
  final int? userId;
  final String? medicineName;
  final String? dosage;
  final DateTime? timeTaken;
}

class MedicineEntryCreateDto {
  MedicineEntryCreateDto({
    this.medicineName,
    this.dosage,
    this.timeTaken,
  });

  factory MedicineEntryCreateDto.fromJson(Map<String, dynamic> json) =>
      MedicineEntryCreateDto(
        medicineName: json['medicineName'] as String?,
        dosage: json['dosage'] as String?,
        timeTaken: json['timeTaken'] != null
            ? DateTime.tryParse(json['timeTaken'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'medicineName': medicineName,
        'dosage': dosage,
        'timeTaken': timeTaken?.toIso8601String(),
      };

  final String? medicineName;
  final String? dosage;
  final DateTime? timeTaken;
}
