class SleepEntry {
  final String id;
  final DateTime date;
  final double hours;
  final String? recommendation;

  const SleepEntry({
    required this.id,
    required this.date,
    required this.hours,
    this.recommendation,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'hours': hours,
      'recommendation': recommendation,
    };
  }

  factory SleepEntry.fromMap(Map<String, dynamic> map) {
    return SleepEntry(
      id: map['id'] as String,
      date: DateTime.parse(map['date'] as String),
      hours: (map['hours'] as num).toDouble(),
      recommendation: map['recommendation'] as String?,
    );
  }
}
