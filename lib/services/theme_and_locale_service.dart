import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';

class ThemeAndLocaleService extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  final Locale _locale = const Locale('en');
  bool _initialized = false;

  static const _themeModeKey = 'theme_and_locale.theme_mode';

  Future<void> initialize() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeModeKey);

    if (themeString != null) {
      _themeMode = _themeModeFromString(themeString);
    }
    _initialized = true;
    notifyListeners();
  }

  bool get isInitialized => _initialized;
  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  String get languageCode => _locale.languageCode;
  TextDirection get textDirection => TextDirection.ltr;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  Iterable<Locale> get supportedLocales => AppLocalizations.supportedLocales;

  Future<void> toggleDarkMode(bool enabled) async {
    final mode = enabled ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(mode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    await _persistThemeMode();
    notifyListeners();
  }

  Locale? localeResolutionCallback(Locale? deviceLocale, Iterable<Locale> supportedLocales) {
    final preferred = supportedLocales.firstWhere(
      (item) => item.languageCode == _locale.languageCode,
      orElse: () => supportedLocales.isNotEmpty ? supportedLocales.first : const Locale('en'),
    );
    return preferred;
  }

  ThemeMode _themeModeFromString(String value) {
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }

  Future<void> _persistThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, _themeMode.name);
  }

  // Locale is fixed to English, so persistence is unnecessary.
}
