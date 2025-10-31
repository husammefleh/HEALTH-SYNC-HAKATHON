class MedicineEntry {
  final String id;
  final String medicineName;
  final String dosage;
  final int frequencyPerDay;
  final int durationDays;
  final DateTime createdAt;
  final bool taken;
  final String? recommendation;

  const MedicineEntry({
    required this.id,
    required this.medicineName,
    required this.dosage,
    required this.frequencyPerDay,
    required this.durationDays,
    required this.createdAt,
    this.taken = false,
    this.recommendation,
  });

  MedicineEntry copyWith({
    bool? taken,
    String? recommendation,
  }) {
    return MedicineEntry(
      id: id,
      medicineName: medicineName,
      dosage: dosage,
      frequencyPerDay: frequencyPerDay,
      durationDays: durationDays,
      createdAt: createdAt,
      taken: taken ?? this.taken,
      recommendation: recommendation ?? this.recommendation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicineName': medicineName,
      'dosage': dosage,
      'frequencyPerDay': frequencyPerDay,
      'durationDays': durationDays,
      'createdAt': createdAt.toIso8601String(),
      'taken': taken,
      'recommendation': recommendation,
    };
  }

  factory MedicineEntry.fromMap(Map<String, dynamic> map) {
    return MedicineEntry(
      id: map['id'] as String,
      medicineName: map['medicineName'] as String? ??
          map['medicine'] as String? ??
          '',
      dosage: map['dosage'] as String? ?? '',
      frequencyPerDay: (map['frequencyPerDay'] as num? ??
              map['frequency'] as num? ??
              map['timesPerDay'] as num? ??
              0)
          .toInt(),
      durationDays: (map['durationDays'] as num? ??
              map['duration'] as num? ??
              0)
          .toInt(),
      createdAt: DateTime.parse(
        map['createdAt'] as String? ??
            map['timestamp'] as String? ??
            DateTime.now().toIso8601String(),
      ),
      taken: map['taken'] as bool? ?? false,
      recommendation: map['recommendation'] as String?,
    );
  }
}
