class UserProfile {
  final int age;
  final double height;
  final double weight;
  final String gender;
  final bool hasDiabetes;
  final bool hasHypertension;
  final String goal;
  final String? preferredName;

  const UserProfile({
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    required this.hasDiabetes,
    required this.hasHypertension,
    required this.goal,
    this.preferredName,
  });

  UserProfile copyWith({
    int? age,
    double? height,
    double? weight,
    String? gender,
    bool? hasDiabetes,
    bool? hasHypertension,
    String? goal,
    String? preferredName,
  }) {
    return UserProfile(
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      hasDiabetes: hasDiabetes ?? this.hasDiabetes,
      hasHypertension: hasHypertension ?? this.hasHypertension,
      goal: goal ?? this.goal,
      preferredName: preferredName ?? this.preferredName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'age': age,
      'height': height,
      'weight': weight,
      'gender': gender,
      'hasDiabetes': hasDiabetes,
      'hasHypertension': hasHypertension,
      'goal': goal,
      'preferredName': preferredName,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      age: map['age'] as int,
      height: (map['height'] as num).toDouble(),
      weight: (map['weight'] as num).toDouble(),
      gender: map['gender'] as String,
      hasDiabetes: map['hasDiabetes'] as bool,
      hasHypertension: map['hasHypertension'] as bool,
      goal: map['goal'] as String,
      preferredName: map['preferredName'] as String?,
    );
  }
}
