class UserProfile {
  final int age;
  final double height;
  final double weight;
  final String gender;
  final bool hasDiabetes;
  final bool hasHypertension;
  final String? preferredName;

  const UserProfile({
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    required this.hasDiabetes,
    required this.hasHypertension,
    this.preferredName,
  });

  UserProfile copyWith({
    int? age,
    double? height,
    double? weight,
    String? gender,
    bool? hasDiabetes,
    bool? hasHypertension,
    String? preferredName,
  }) {
    return UserProfile(
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      hasDiabetes: hasDiabetes ?? this.hasDiabetes,
      hasHypertension: hasHypertension ?? this.hasHypertension,
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
      preferredName: map['preferredName'] as String?,
    );
  }
}
