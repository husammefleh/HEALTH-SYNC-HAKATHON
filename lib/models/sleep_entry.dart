class SleepEntry {
  final String id;
  final DateTime date;
  final double hours;

  const SleepEntry({
    required this.id,
    required this.date,
    required this.hours,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'hours': hours,
    };
  }

  factory SleepEntry.fromMap(Map<String, dynamic> map) {
    return SleepEntry(
      id: map['id'] as String,
      date: DateTime.parse(map['date'] as String),
      hours: (map['hours'] as num).toDouble(),
    );
  }
}
