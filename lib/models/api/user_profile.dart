class UserDto {
  UserDto({
    this.id,
    this.username,
    this.email,
    this.passwordHash,
    this.profile,
    this.createdAt,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
        id: json['id'] as int?,
        username: json['username'] as String?,
        email: json['email'] as String?,
        passwordHash: json['passwordHash'] as String?,
        profile: json['profile'] != null
            ? UserProfileDto.fromJson(json['profile'] as Map<String, dynamic>)
            : null,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'username': username,
        'email': email,
        'passwordHash': passwordHash,
        'profile': profile?.toJson(),
        'createdAt': createdAt?.toIso8601String(),
      };

  final int? id;
  final String? username;
  final String? email;
  final String? passwordHash;
  final UserProfileDto? profile;
  final DateTime? createdAt;
}

class UserProfileDto {
  UserProfileDto({
    this.id,
    this.userId,
    this.gender,
    this.dateOfBirth,
    this.height,
    this.weight,
  });

  factory UserProfileDto.fromJson(Map<String, dynamic> json) => UserProfileDto(
        id: json['id'] as int?,
        userId: json['userId'] as int?,
        gender: json['gender'] as String?,
        dateOfBirth: json['dateOfBirth'] != null
            ? DateTime.tryParse(json['dateOfBirth'] as String)
            : null,
        height: (json['height'] as num?)?.toDouble(),
        weight: (json['weight'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'userId': userId,
        'gender': gender,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'height': height,
        'weight': weight,
      };

  final int? id;
  final int? userId;
  final String? gender;
  final DateTime? dateOfBirth;
  final double? height;
  final double? weight;
}

class UserProfileCreateDto {
  UserProfileCreateDto({
    this.gender,
    this.dateOfBirth,
    this.height,
    this.weight,
  });

  factory UserProfileCreateDto.fromJson(Map<String, dynamic> json) =>
      UserProfileCreateDto(
        gender: json['gender'] as String?,
        dateOfBirth: json['dateOfBirth'] != null
            ? DateTime.tryParse(json['dateOfBirth'] as String)
            : null,
        height: (json['height'] as num?)?.toDouble(),
        weight: (json['weight'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'gender': gender,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'height': height,
        'weight': weight,
      };

  final String? gender;
  final DateTime? dateOfBirth;
  final double? height;
  final double? weight;
}
