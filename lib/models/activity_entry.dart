class ActivityEntry {
  final String id;
  final String name;
  final int minutes;
  final int calories;
  final DateTime createdAt;

  const ActivityEntry({
    required this.id,
    required this.name,
    required this.minutes,
    required this.calories,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'minutes': minutes,
      'calories': calories,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ActivityEntry.fromMap(Map<String, dynamic> map) {
    return ActivityEntry(
      id: map['id'] as String,
      name: map['name'] as String,
      minutes: (map['minutes'] as num).toInt(),
      calories: (map['calories'] as num).toInt(),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
