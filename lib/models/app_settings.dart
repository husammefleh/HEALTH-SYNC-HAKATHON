class AppSettings {
  final bool notificationsEnabled;
  final bool darkMode;
  final String languageCode;

  const AppSettings({
    required this.notificationsEnabled,
    required this.darkMode,
    required this.languageCode,
  });

  AppSettings copyWith({
    bool? notificationsEnabled,
    bool? darkMode,
    String? languageCode,
  }) {
    return AppSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkMode: darkMode ?? this.darkMode,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'darkMode': darkMode,
      'languageCode': languageCode,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      notificationsEnabled: map['notificationsEnabled'] as bool? ?? true,
      darkMode: map['darkMode'] as bool? ?? false,
      languageCode: map['languageCode'] as String? ?? 'en',
    );
  }

  static const defaults = AppSettings(
    notificationsEnabled: true,
    darkMode: false,
    languageCode: 'en',
  );
}
