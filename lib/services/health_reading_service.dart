import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/health_reading.dart';

class HealthReadingService {
  static const _storageKey = 'health_readings';

  Future<List<HealthReading>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) =>
            HealthReading.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> save(List<HealthReading> readings) async {
    final prefs = await SharedPreferences.getInstance();
    final payload =
        jsonEncode(readings.map((reading) => reading.toMap()).toList());
    await prefs.setString(_storageKey, payload);
  }
}
