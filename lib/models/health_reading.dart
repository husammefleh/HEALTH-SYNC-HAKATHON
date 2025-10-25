enum HealthReadingKind {
  bloodPressure,
  bloodSugar,
}

class HealthReading {
  final String id;
  final HealthReadingKind kind;
  final String value;
  final DateTime recordedAt;

  const HealthReading({
    required this.id,
    required this.kind,
    required this.value,
    required this.recordedAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'kind': kind.name,
        'value': value,
        'recordedAt': recordedAt.toIso8601String(),
      };

  factory HealthReading.fromMap(Map<String, dynamic> map) {
    final kindName = map['kind'] as String? ?? HealthReadingKind.bloodPressure.name;
    final kind = HealthReadingKind.values.firstWhere(
      (element) => element.name == kindName,
      orElse: () => HealthReadingKind.bloodPressure,
    );

    return HealthReading(
      id: map['id'] as String,
      kind: kind,
      value: map['value'] as String? ?? '',
      recordedAt: DateTime.parse(map['recordedAt'] as String),
    );
  }
}
