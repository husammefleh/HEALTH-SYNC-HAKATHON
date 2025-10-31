import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  static const userAccountKey = 'user_account';
  static const loggedInKey = 'logged_in';
  static const profileKey = 'user_profile';
  static const settingsKey = 'app_settings';
  static const foodEntriesKey = 'food_entries';
  static const sleepEntriesKey = 'sleep_entries';
  static const activityEntriesKey = 'activity_entries';
  static const medicineEntriesKey = 'medicine_entries';
  static const onboardingKey = 'has_completed_onboarding';
  static const authTokenKey = 'auth_token';
  static const foodMetadataKey = 'food_metadata';
  static const medicineMetadataKey = 'medicine_metadata';
  static const sleepMetadataKey = 'sleep_metadata';
  static const activityMetadataKey = 'activity_metadata';
  static const healthMetadataKey = 'health_metadata';

  static Future<SharedPreferences> _prefs() => SharedPreferences.getInstance();

  static Future<void> saveMap(String key, Map<String, dynamic> value) async {
    final prefs = await _prefs();
    await prefs.setString(key, jsonEncode(value));
  }

  static Future<Map<String, dynamic>?> readMap(String key) async {
    final prefs = await _prefs();
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded;
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveList(
      String key, List<Map<String, dynamic>> value) async {
    final prefs = await _prefs();
    await prefs.setString(key, jsonEncode(value));
  }

  static Future<List<Map<String, dynamic>>> readList(String key) async {
    final prefs = await _prefs();
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  static Future<void> setBool(String key, bool value) async {
    final prefs = await _prefs();
    await prefs.setBool(key, value);
  }

  static Future<bool> readBool(String key, {bool defaultValue = false}) async {
    final prefs = await _prefs();
    return prefs.getBool(key) ?? defaultValue;
  }

  static Future<void> setString(String key, String value) async {
    final prefs = await _prefs();
    await prefs.setString(key, value);
  }

  static Future<String?> readString(String key) async {
    final prefs = await _prefs();
    return prefs.getString(key);
  }

  static Future<void> remove(String key) async {
    final prefs = await _prefs();
    await prefs.remove(key);
  }

  static Future<void> clearKeys(List<String> keys) async {
    final prefs = await _prefs();
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}
