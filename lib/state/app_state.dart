import 'dart:math';

import 'package:flutter/material.dart';

import '../models/activity_entry.dart';
import '../models/app_settings.dart';
import '../models/food_entry.dart';
import '../models/health_reading.dart';
import '../models/local_user.dart';
import '../models/medicine_entry.dart';
import '../models/sleep_entry.dart';
import '../models/user_profile.dart';
import '../services/app_storage.dart';
import '../services/health_reading_service.dart';

class AppState extends ChangeNotifier {
  AppState();

  bool _isInitialized = false;
  LocalUser? _user;
  bool _isLoggedIn = false;
  bool _hasCompletedOnboarding = false;
  UserProfile? _profile;
  AppSettings _settings = AppSettings.defaults;

  final List<FoodEntry> _foodEntries = [];
  final List<SleepEntry> _sleepEntries = [];
  final List<ActivityEntry> _activityEntries = [];
  final List<MedicineEntry> _medicineEntries = [];
  final List<HealthReading> _healthReadings = [];
  final HealthReadingService _healthReadingService = HealthReadingService();

  bool get isInitialized => _isInitialized;
  LocalUser? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  bool get needsOnboarding => _isLoggedIn && !_hasCompletedOnboarding;
  UserProfile? get profile => _profile;
  AppSettings get settings => _settings;

  List<FoodEntry> get foodEntries => List.unmodifiable(_foodEntries);
  List<SleepEntry> get sleepEntries => List.unmodifiable(_sleepEntries);
  List<ActivityEntry> get activityEntries =>
      List.unmodifiable(_activityEntries);
  List<MedicineEntry> get medicineEntries =>
      List.unmodifiable(_medicineEntries);
  List<HealthReading> get healthReadings =>
      List.unmodifiable(_healthReadings);

  Future<void> load() async {
    final userMap = await AppStorage.readMap(AppStorage.userAccountKey);
    if (userMap != null) {
      _user = LocalUser.fromMap(userMap);
    }

    _isLoggedIn = await AppStorage.readBool(AppStorage.loggedInKey);
    _hasCompletedOnboarding =
        await AppStorage.readBool(AppStorage.onboardingKey);

    final profileMap = await AppStorage.readMap(AppStorage.profileKey);
    if (profileMap != null) {
      _profile = UserProfile.fromMap(profileMap);
    }

    final settingsMap = await AppStorage.readMap(AppStorage.settingsKey);
    if (settingsMap != null) {
      _settings = AppSettings.fromMap(settingsMap);
    }

    final foodList = await AppStorage.readList(AppStorage.foodEntriesKey);
    _foodEntries
      ..clear()
      ..addAll(foodList.map(FoodEntry.fromMap));

    final sleepList = await AppStorage.readList(AppStorage.sleepEntriesKey);
    _sleepEntries
      ..clear()
      ..addAll(sleepList.map(SleepEntry.fromMap));

    final activityList =
        await AppStorage.readList(AppStorage.activityEntriesKey);
    _activityEntries
      ..clear()
      ..addAll(activityList.map(ActivityEntry.fromMap));

    final medicineList =
        await AppStorage.readList(AppStorage.medicineEntriesKey);
    _medicineEntries
      ..clear()
      ..addAll(medicineList.map(MedicineEntry.fromMap));

    final readingList = await _healthReadingService.load();
    _healthReadings
      ..clear()
      ..addAll(readingList..sort((a, b) => b.recordedAt.compareTo(a.recordedAt)));

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _user = LocalUser(name: name, email: email, password: password);
    _isLoggedIn = true;
    _hasCompletedOnboarding = false;
    _profile = null;
    await AppStorage.saveMap(AppStorage.userAccountKey, _user!.toMap());
    await AppStorage.setBool(AppStorage.loggedInKey, true);
    await AppStorage.setBool(AppStorage.onboardingKey, false);
    await AppStorage.clearKeys([
      AppStorage.profileKey,
      AppStorage.foodEntriesKey,
      AppStorage.sleepEntriesKey,
      AppStorage.activityEntriesKey,
      AppStorage.medicineEntriesKey,
    ]);
    _foodEntries.clear();
    _sleepEntries.clear();
    _activityEntries.clear();
    _medicineEntries.clear();
    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    final stored = await AppStorage.readMap(AppStorage.userAccountKey);
    if (stored == null) return false;
    final account = LocalUser.fromMap(stored);
    if (account.email == email && account.password == password) {
      await AppStorage.setBool(AppStorage.loggedInKey, true);
      await load();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _user = null;
    _profile = null;
    _foodEntries.clear();
    _sleepEntries.clear();
    _activityEntries.clear();
    _medicineEntries.clear();

    await AppStorage.setBool(AppStorage.loggedInKey, false);
    notifyListeners();
  }

  Future<void> completeOnboarding(UserProfile profile) async {
    final enriched = profile.preferredName != null || _user == null
        ? profile
        : profile.copyWith(preferredName: _user!.name);
    _profile = enriched;
    _hasCompletedOnboarding = true;
    await AppStorage.saveMap(AppStorage.profileKey, enriched.toMap());
    await AppStorage.setBool(AppStorage.onboardingKey, true);
    notifyListeners();
  }

  Future<void> updateSettings(AppSettings settings) async {
    _settings = settings;
    await AppStorage.saveMap(AppStorage.settingsKey, settings.toMap());
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    await updateSettings(_settings.copyWith(darkMode: value));
  }

  Future<void> toggleNotifications(bool value) async {
    await updateSettings(_settings.copyWith(notificationsEnabled: value));
  }

  Future<void> changeLanguage(String code) async {
    await updateSettings(_settings.copyWith(languageCode: code));
  }

  Future<void> addAnalysedMeal(FoodEntry entry) async {
    _foodEntries.add(entry);
    _foodEntries.sort((a, b) => b.analysedAt.compareTo(a.analysedAt));
    await _persistFood();
    notifyListeners();
  }

  Future<void> addFoodEntry(String name, int calories) async {
    final legacy = FoodEntry(
      id: _generateId(),
      description: name,
      calories: calories,
      proteinGrams: 0,
      carbsGrams: 0,
      fatGrams: 0,
      aiSummary: '',
      analysedAt: DateTime.now(),
    );
    await addAnalysedMeal(legacy);
  }

  Future<void> addSleepEntry(DateTime date, double hours) async {
    final entry = SleepEntry(
      id: _generateId(),
      date: date,
      hours: hours,
    );
    _sleepEntries.add(entry);
    await _persistSleep();
    notifyListeners();
  }

  Future<void> addActivity({
    required String name,
    required int minutes,
    required int calories,
  }) async {
    final entry = ActivityEntry(
      id: _generateId(),
      name: name,
      minutes: minutes,
      calories: calories,
      createdAt: DateTime.now(),
    );
    _activityEntries.add(entry);
    await _persistActivity();
    notifyListeners();
  }

  Future<void> addMedicine({
    required String disease,
    required String medicine,
    required int durationDays,
    required String time,
    required bool reminder,
  }) async {
    final entry = MedicineEntry(
      id: _generateId(),
      disease: disease,
      medicine: medicine,
      durationDays: durationDays,
      time: time,
      reminder: reminder,
      taken: false,
      createdAt: DateTime.now(),
    );
    _medicineEntries.add(entry);
    await _persistMedicine();
    notifyListeners();
  }

  Future<void> toggleMedicineTaken(String id) async {
    final index = _medicineEntries.indexWhere((m) => m.id == id);
    if (index == -1) return;
    final current = _medicineEntries[index];
    _medicineEntries[index] = current.copyWith(taken: !current.taken);
    await _persistMedicine();
    notifyListeners();
  }

  int totalFoodCaloriesToday() {
    final today = DateTime.now();
    return _foodEntries
        .where((e) =>
            e.analysedAt.year == today.year &&
            e.analysedAt.month == today.month &&
            e.analysedAt.day == today.day)
        .fold<int>(0, (sum, entry) => sum + entry.calories);
  }

  double totalSleepHoursThisWeek() {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 6));
    return _sleepEntries
        .where((e) => !e.date
            .isBefore(DateTime(weekAgo.year, weekAgo.month, weekAgo.day)))
        .fold<double>(0, (sum, entry) => sum + entry.hours);
  }

  int totalActivityMinutesThisWeek() {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 6));
    return _activityEntries
        .where((e) => !e.createdAt.isBefore(
              DateTime(weekAgo.year, weekAgo.month, weekAgo.day),
            ))
        .fold<int>(0, (sum, entry) => sum + entry.minutes);
  }

  Future<void> _persistFood() async {
    await AppStorage.saveList(
      AppStorage.foodEntriesKey,
      _foodEntries.map((e) => e.toMap()).toList(),
    );
  }

  Future<void> _persistSleep() async {
    await AppStorage.saveList(
      AppStorage.sleepEntriesKey,
      _sleepEntries.map((e) => e.toMap()).toList(),
    );
  }

  Future<void> _persistActivity() async {
    await AppStorage.saveList(
      AppStorage.activityEntriesKey,
      _activityEntries.map((e) => e.toMap()).toList(),
    );
  }

  Future<void> _persistMedicine() async {
    await AppStorage.saveList(
      AppStorage.medicineEntriesKey,
      _medicineEntries.map((e) => e.toMap()).toList(),
    );
  }

  Future<void> addHealthReading(HealthReading reading) async {
    _healthReadings.insert(0, reading);
    await _healthReadingService.save(_healthReadings);
    notifyListeners();
  }

  Future<void> addHealthReadings(List<HealthReading> readings) async {
    if (readings.isEmpty) return;
    _healthReadings.insertAll(0, readings);
    _healthReadings.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
    await _healthReadingService.save(_healthReadings);
    notifyListeners();
  }

  String _generateId() {
    final random = Random();
    final millis = DateTime.now().millisecondsSinceEpoch;
    final randomPart = random.nextInt(999999);
    return '$millis-$randomPart';
  }
}
