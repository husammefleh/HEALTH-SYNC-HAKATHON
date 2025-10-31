class HealthReading {
  const HealthReading({
    required this.id,
    required this.bloodPressure,
    required this.sugarLevel,
    this.heartRate,
    required this.recordedAt,
    this.recommendation,
    this.diastolic,
    this.bloodPressureLabel,
    this.sugarLevelLabel,
  });

  final String id;
  final double bloodPressure;
  final double sugarLevel;
  final double? heartRate;
  final DateTime recordedAt;
  final String? recommendation;
  final double? diastolic;
  final String? bloodPressureLabel;
  final String? sugarLevelLabel;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bloodPressure': bloodPressure,
      'sugarLevel': sugarLevel,
      'heartRate': heartRate,
      'recordedAt': recordedAt.toIso8601String(),
      'recommendation': recommendation,
      'diastolic': diastolic,
      'bloodPressureLabel': bloodPressureLabel,
      'sugarLevelLabel': sugarLevelLabel,
    };
  }

  factory HealthReading.fromMap(Map<String, dynamic> map) {
    return HealthReading(
      id: map['id'] as String,
      bloodPressure: (map['bloodPressure'] as num).toDouble(),
      sugarLevel: (map['sugarLevel'] as num).toDouble(),
      heartRate: (map['heartRate'] as num?)?.toDouble(),
      recordedAt: DateTime.parse(map['recordedAt'] as String),
      recommendation: map['recommendation'] as String?,
      diastolic: (map['diastolic'] as num?)?.toDouble(),
      bloodPressureLabel: map['bloodPressureLabel'] as String?,
      sugarLevelLabel: map['sugarLevelLabel'] as String?,
    );
  }
}
