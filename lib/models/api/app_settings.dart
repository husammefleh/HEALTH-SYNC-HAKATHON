class AppSettingsDto {
  AppSettingsDto({
    this.id,
    this.userId,
    this.notificationsEnabled,
    this.theme,
  });

  factory AppSettingsDto.fromJson(Map<String, dynamic> json) => AppSettingsDto(
        id: json['id'] as int?,
        userId: json['userId'] as int?,
        notificationsEnabled: json['notificationsEnabled'] as bool?,
        theme: json['theme'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'userId': userId,
        'notificationsEnabled': notificationsEnabled,
        'theme': theme,
      };

  final int? id;
  final int? userId;
  final bool? notificationsEnabled;
  final String? theme;
}

class AppSettingsCreateDto {
  AppSettingsCreateDto({
    this.notificationsEnabled,
    this.theme,
  });

  factory AppSettingsCreateDto.fromJson(Map<String, dynamic> json) =>
      AppSettingsCreateDto(
        notificationsEnabled: json['notificationsEnabled'] as bool?,
        theme: json['theme'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'notificationsEnabled': notificationsEnabled,
        'theme': theme,
      };

  final bool? notificationsEnabled;
  final String? theme;
}
