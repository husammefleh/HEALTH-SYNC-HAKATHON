class MedicineEntry {
  final String id;
  final String disease;
  final String medicine;
  final int durationDays;
  final String time;
  final bool reminder;
  final bool taken;
  final DateTime createdAt;

  const MedicineEntry({
    required this.id,
    required this.disease,
    required this.medicine,
    required this.durationDays,
    required this.time,
    required this.reminder,
    required this.taken,
    required this.createdAt,
  });

  MedicineEntry copyWith({bool? taken}) {
    return MedicineEntry(
      id: id,
      disease: disease,
      medicine: medicine,
      durationDays: durationDays,
      time: time,
      reminder: reminder,
      taken: taken ?? this.taken,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'disease': disease,
      'medicine': medicine,
      'durationDays': durationDays,
      'time': time,
      'reminder': reminder,
      'taken': taken,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory MedicineEntry.fromMap(Map<String, dynamic> map) {
    return MedicineEntry(
      id: map['id'] as String,
      disease: map['disease'] as String,
      medicine: map['medicine'] as String,
      durationDays: (map['durationDays'] as num).toInt(),
      time: map['time'] as String,
      reminder: map['reminder'] as bool? ?? false,
      taken: map['taken'] as bool? ?? false,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
