import 'package:flutter/material.dart';

import '../models/activity_entry.dart';
import '../models/app_settings.dart';
import '../models/food_entry.dart';
import '../models/health_reading.dart';
import '../models/medicine_entry.dart';
import '../models/session_user.dart';
import '../models/sleep_entry.dart';
import '../models/user_profile.dart';
import '../services/api/activity_service.dart';
import '../services/api/app_settings_service.dart';
import '../services/api/auth_service.dart';
import '../services/api/food_service.dart';
import '../services/api/health_reading_service.dart';
import '../services/api/medicine_service.dart';
import '../services/api/sleep_service.dart';
import '../services/api/user_profile_service.dart';
import '../services/api/ai_api_service.dart';
import '../services/api/hedera_mirror_service.dart';
import '../services/api/external_api_config.dart';
import '../services/app_storage.dart';
import '../models/api/activity_entry.dart' as api_activity;
import '../models/api/auth_models.dart';
import '../models/api/app_settings.dart' as api_settings;
import '../models/api/food_entry.dart' as api_food;
import '../models/api/health_reading.dart' as api_health;
import '../models/api/medicine_entry.dart' as api_medicine;
import '../models/api/sleep_entry.dart' as api_sleep;
import '../models/api/user_profile.dart' as api_profile;

class AppState extends ChangeNotifier {
  AppState({
    required AuthService authService,
    required UserProfileApiService userProfileApi,
    required AppSettingsApiService appSettingsApi,
    required FoodApiService foodApi,
    required SleepApiService sleepApi,
    required ActivityApiService activityApi,
    required MedicineApiService medicineApi,
    required HealthReadingApiService healthApi,
    required AiApiService aiApi,
    required HederaMirrorService hederaMirror,
  })  : _authService = authService,
        _userProfileApi = userProfileApi,
        _appSettingsApi = appSettingsApi,
        _foodApi = foodApi,
        _sleepApi = sleepApi,
        _activityApi = activityApi,
        _medicineApi = medicineApi,
        _healthApi = healthApi,
        _aiApi = aiApi,
        _hederaMirror = hederaMirror;

  final AuthService _authService;
  final UserProfileApiService _userProfileApi;
  final AppSettingsApiService _appSettingsApi;
  final FoodApiService _foodApi;
  final SleepApiService _sleepApi;
  final ActivityApiService _activityApi;
  final MedicineApiService _medicineApi;
  final HealthReadingApiService _healthApi;
  final AiApiService _aiApi;
  final HederaMirrorService _hederaMirror;

  bool _isInitialized = false;
  bool _isLoggedIn = false;
  bool _hasCompletedOnboarding = false;
  SessionUser? _user;
  UserProfile? _profile;
  AppSettings _settings = AppSettings.defaults;
  int? _settingsId;
  int? _profileId;

  final List<FoodEntry> _foodEntries = [];
  final List<SleepEntry> _sleepEntries = [];
  final List<ActivityEntry> _activityEntries = [];
  final List<MedicineEntry> _medicineEntries = [];
  final List<HealthReading> _healthReadings = [];

  Map<String, Map<String, dynamic>> _foodMetadata = {};
  Map<String, Map<String, dynamic>> _medicineMetadata = {};
  Map<String, Map<String, dynamic>> _sleepMetadata = {};
  Map<String, Map<String, dynamic>> _activityMetadata = {};
  Map<String, Map<String, dynamic>> _healthMetadata = {};

  bool get isInitialized => _isInitialized;
  bool get isLoggedIn => _isLoggedIn;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  bool get needsOnboarding => _isLoggedIn && !_hasCompletedOnboarding;
  SessionUser? get user => _user;
  UserProfile? get profile => _profile;
  AppSettings get settings => _settings;

  List<FoodEntry> get foodEntries => List.unmodifiable(_foodEntries);
  List<SleepEntry> get sleepEntries => List.unmodifiable(_sleepEntries);
  List<ActivityEntry> get activityEntries =>
      List.unmodifiable(_activityEntries);
  List<MedicineEntry> get medicineEntries =>
      List.unmodifiable(_medicineEntries);
  List<HealthReading> get healthReadings => List.unmodifiable(_healthReadings);

  Future<void> load() async {
    final storedToken = await AppStorage.readString(AppStorage.authTokenKey);
    _isLoggedIn = storedToken != null && storedToken.isNotEmpty;
    _aiApi.updateAuthToken(storedToken);
    _hasCompletedOnboarding =
        await AppStorage.readBool(AppStorage.onboardingKey);

    await _loadMetadata();

    if (_isLoggedIn) {
      await _refreshAll();
    }

    _isInitialized = true;
    notifyListeners();
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _authService.register(
        RegisterRequest(username: name, email: email, password: password),
      );
      return await login(email: email, password: password);
    } catch (_) {
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authService
          .login(LoginRequest(email: email, password: password));
      final userId = response.userId ?? -1;
      _aiApi.updateAuthToken(response.token);
      _user = SessionUser(
        id: userId,
        email: response.email ?? email,
        username: response.username,
      );

      _isLoggedIn = true;
      await AppStorage.setBool(AppStorage.loggedInKey, true);
      _hasCompletedOnboarding =
          await AppStorage.readBool(AppStorage.onboardingKey);
      await _refreshAll();
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.clearSession();
    _aiApi.updateAuthToken(null);
    await AppStorage.setBool(AppStorage.loggedInKey, false);
    await AppStorage.remove(AppStorage.userAccountKey);
    await AppStorage.remove(AppStorage.foodMetadataKey);
    await AppStorage.remove(AppStorage.medicineMetadataKey);
    await AppStorage.remove(AppStorage.sleepMetadataKey);
    await AppStorage.remove(AppStorage.activityMetadataKey);
    await AppStorage.remove(AppStorage.healthMetadataKey);

    _user = null;
    _profile = null;
    _settings = AppSettings.defaults;
    _settingsId = null;
    _profileId = null;
    _foodEntries.clear();
    _sleepEntries.clear();
    _activityEntries.clear();
    _medicineEntries.clear();
    _healthReadings.clear();
    _foodMetadata.clear();
    _medicineMetadata.clear();
    _sleepMetadata.clear();
    _activityMetadata.clear();
    _healthMetadata.clear();

    _isLoggedIn = false;
    _hasCompletedOnboarding = false;
    notifyListeners();
  }

  Future<void> completeOnboarding(UserProfile profile) async {
    _profile = profile;
    _hasCompletedOnboarding = true;
    await AppStorage.setBool(AppStorage.onboardingKey, true);

    if (_isLoggedIn) {
      final now = DateTime.now();
      final approximateDob = DateTime(now.year - profile.age, 1, 1);
      final dto = api_profile.UserProfileCreateDto(
        gender: profile.gender,
        height: profile.height,
        weight: profile.weight,
        dateOfBirth: approximateDob,
      );
      try {
        if (_profileId != null) {
          final updated = await _userProfileApi.updateProfile(_profileId!, dto);
          _profileId = updated.id;
        } else {
          final created = await _userProfileApi.createProfile(dto);
          _profileId = created.id;
        }
      } catch (_) {
        // Silently ignore API failures; onboarding data is kept locally.
      }
    }
    notifyListeners();
  }

  Future<void> updateSettings(AppSettings settings) async {
    _settings = settings;
    await _persistSettings();
    notifyListeners();
  }

  Future<void> toggleNotifications(bool value) async {
    _settings = _settings.copyWith(notificationsEnabled: value);
    notifyListeners();
    await _persistSettings();
  }

  Future<void> toggleDarkMode(bool value) async {
    _settings = _settings.copyWith(darkMode: value);
    notifyListeners();
    await _persistSettings();
  }

  Future<void> changeLanguage(String code) async {
    _settings = _settings.copyWith(languageCode: code);
    notifyListeners();
  }

  Future<void> addAnalysedMeal(FoodEntry entry) async {
    if (!_isLoggedIn) {
      _foodEntries.add(entry);
      _foodMetadata[entry.id] = {
        'mealType': entry.mealType,
        'drink': entry.drink,
        'dessert': entry.dessert,
        'recommendation': entry.aiSummary,
      };
      await _persistFoodMetadata();
      notifyListeners();
      return;
    }

    final dto = api_food.FoodEntryCreateDto(
      foodName: entry.description,
      calories: entry.calories.toDouble(),
      protein: entry.proteinGrams,
      carbs: entry.carbsGrams,
      fat: entry.fatGrams,
      date: entry.analysedAt,
    );

    try {
      final created = await _foodApi.createFood(dto);
      final remoteId = created.id?.toString() ?? entry.id;

      _foodMetadata[remoteId] = {
        'mealType': entry.mealType,
        'drink': entry.drink,
        'dessert': entry.dessert,
        'recommendation': entry.aiSummary,
      };
      await _persistFoodMetadata();

      final mapped = _mapFoodEntry(created, metadata: _foodMetadata[remoteId]);
      _foodEntries
        ..removeWhere((e) => e.id == remoteId)
        ..add(mapped)
        ..sort((a, b) => b.analysedAt.compareTo(a.analysedAt));
      notifyListeners();
    } catch (_) {
      _foodEntries.add(entry);
      _foodMetadata[entry.id] = {
        'mealType': entry.mealType,
        'drink': entry.drink,
        'dessert': entry.dessert,
        'recommendation': entry.aiSummary,
      };
      await _persistFoodMetadata();
      notifyListeners();
    }
  }

  Future<SleepEntry> addSleepEntry(DateTime date, double hours) async {
    final localEntry = SleepEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: date,
      hours: hours,
    );

    if (!_isLoggedIn) {
      _sleepEntries
        ..add(localEntry)
        ..sort((a, b) => b.date.compareTo(a.date));
      notifyListeners();
      return localEntry;
    }

    try {
      final created = await _sleepApi.createSleepEntry(
        api_sleep.SleepEntryCreateDto(
          hoursSlept: hours,
          sleepDate: date,
        ),
      );
      final mapped = _mapSleepEntry(created);
      _sleepEntries
        ..add(mapped)
        ..sort((a, b) => b.date.compareTo(a.date));
      notifyListeners();
      return mapped;
    } catch (_) {
      _sleepEntries
        ..add(localEntry)
        ..sort((a, b) => b.date.compareTo(a.date));
      notifyListeners();
      return localEntry;
    }
  }

  Future<ActivityEntry> addActivity({
    required String name,
    required int minutes,
  }) async {
    final localEntry = ActivityEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      minutes: minutes,
      calories: 0,
      createdAt: DateTime.now(),
    );

    if (!_isLoggedIn) {
      _activityEntries
        ..add(localEntry)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifyListeners();
      return localEntry;
    }

    try {
      final created = await _activityApi.createActivity(
        api_activity.ActivityEntryCreateDto(
          activityType: name,
          duration: minutes.toDouble(),
          caloriesBurned: null,
          date: DateTime.now(),
        ),
      );

      final mapped = _mapActivityEntry(created);
      _activityEntries
        ..add(mapped)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifyListeners();
      return mapped;
    } catch (_) {
      _activityEntries
        ..add(localEntry)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifyListeners();
      return localEntry;
    }
  }

  Future<void> addMedicine({
    required String medicineName,
    required String dosage,
    required int frequencyPerDay,
    required int durationDays,
    bool reminder = false,
    DateTime? startDate,
  }) async {
    final createdAt = startDate ?? DateTime.now();
    final baseMetadata = <String, dynamic>{
      'medicineName': medicineName,
      'dosage': dosage,
      'frequencyPerDay': frequencyPerDay,
      'durationDays': durationDays,
      'reminder': reminder,
      'createdAt': createdAt.toIso8601String(),
      'taken': false,
    };

    Future<void> insertLocal(String id) async {
      _medicineMetadata[id] = Map<String, dynamic>.from(baseMetadata);
      await _persistMedicineMetadata();
      final entry = MedicineEntry(
        id: id,
        medicineName: medicineName,
        dosage: dosage,
        frequencyPerDay: frequencyPerDay,
        durationDays: durationDays,
        createdAt: createdAt,
        taken: false,
      );
      _medicineEntries
        ..add(entry)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifyListeners();
    }

    if (!_isLoggedIn) {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      await insertLocal(id);
      return;
    }

    try {
      final created = await _medicineApi.createMedicine(
        api_medicine.MedicineEntryCreateDto(
          medicineName: medicineName,
          dosage: dosage,
          timeTaken: createdAt,
        ),
      );

      final remoteId = created.id?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString();
      _medicineMetadata[remoteId] = Map<String, dynamic>.from(baseMetadata);
      await _persistMedicineMetadata();

      final mapped = _mapMedicineEntry(
        created,
        metadata: _medicineMetadata[remoteId],
      );
      _medicineEntries
        ..add(mapped)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifyListeners();
    } catch (_) {
      final fallbackId = DateTime.now().millisecondsSinceEpoch.toString();
      await insertLocal(fallbackId);
    }
  }

  Future<void> toggleMedicineTaken(String id) async {
    final existing = _medicineMetadata[id] ?? {};
    final updated = {
      ...existing,
      'taken': !(existing['taken'] as bool? ?? false),
    };
    _medicineMetadata[id] = updated;
    await _persistMedicineMetadata();

    final index = _medicineEntries.indexWhere((e) => e.id == id);
    if (index != -1) {
      final current = _medicineEntries[index];
      _medicineEntries[index] =
          current.copyWith(taken: updated['taken'] as bool);
      notifyListeners();
    }
  }

  Future<void> addHealthReadings(List<HealthReading> readings) async {
    if (readings.isEmpty) return;
    if (!_isLoggedIn) {
      _healthReadings.insertAll(0, readings);
      _healthReadings.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
      notifyListeners();
      return;
    }

    try {
      for (final reading in readings) {
        await _healthApi.createHealthReading(
          api_health.HealthReadingCreateDto(
            bloodPressure: reading.bloodPressure,
            heartRate: reading.heartRate,
            sugarLevel: reading.sugarLevel,
            recordedAt: reading.recordedAt,
          ),
        );
      }
      await _refreshHealth();
      notifyListeners();
    } catch (_) {
      // Fallback to local insertion if the remote call fails.
      _healthReadings.insertAll(0, readings);
      _healthReadings.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
      notifyListeners();
    }
  }

  int totalFoodCaloriesToday() {
    final today = DateTime.now();
    return _foodEntries
        .where((entry) =>
            entry.analysedAt.year == today.year &&
            entry.analysedAt.month == today.month &&
            entry.analysedAt.day == today.day)
        .fold<int>(0, (sum, entry) => sum + entry.calories);
  }

  double totalSleepHoursThisWeek() {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 6));
    return _sleepEntries
        .where((entry) => !entry.date
            .isBefore(DateTime(weekAgo.year, weekAgo.month, weekAgo.day)))
        .fold<double>(0, (sum, entry) => sum + entry.hours);
  }

  int totalActivityMinutesThisWeek() {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 6));
    return _activityEntries
        .where((entry) => !entry.createdAt
            .isBefore(DateTime(weekAgo.year, weekAgo.month, weekAgo.day)))
        .fold<int>(0, (sum, entry) => sum + entry.minutes);
  }

  Future<void> _refreshAll() async {
    await Future.wait([
      _refreshProfile(),
      _refreshSettings(),
      _refreshFood(),
      _refreshSleep(),
      _refreshActivity(),
      _refreshMedicine(),
      _refreshHealth(),
    ]);
  }

  Future<void> _refreshProfile() async {
    final profiles = await _userProfileApi.fetchProfiles();
    if (profiles.isNotEmpty) {
      final profileDto = profiles.first;
      _profileId = profileDto.id;
      _profile = UserProfile(
        age: profileDto.dateOfBirth != null
            ? DateTime.now().year - profileDto.dateOfBirth!.year
            : 0,
        height: profileDto.height ?? 0,
        weight: profileDto.weight ?? 0,
        gender: profileDto.gender ?? '',
        hasDiabetes: false,
        hasHypertension: false,
        preferredName: profileDto.gender,
      );
      _hasCompletedOnboarding = true;
      await AppStorage.setBool(AppStorage.onboardingKey, true);
    } else {
      _profile = null;
      _profileId = null;
      _hasCompletedOnboarding =
          await AppStorage.readBool(AppStorage.onboardingKey);
    }
  }

  Future<void> _refreshSettings() async {
    final settings = await _appSettingsApi.fetchSettings();
    if (settings.isNotEmpty) {
      final dto = settings.first;
      _settings = AppSettings(
        notificationsEnabled: dto.notificationsEnabled ?? true,
        darkMode: (dto.theme ?? '').toLowerCase() == 'dark',
        languageCode: 'en',
      );
      _settingsId = dto.id;
    }
  }

  Future<void> _refreshFood() async {
    if (ExternalApiConfig.foodTopicId.isNotEmpty) {
      try {
        await syncFoodFromMirror(limit: 100, notify: false);
        return;
      } catch (_) {
        // Fallback to REST API below.
      }
    }

    final entries = await _foodApi.fetchFoods();
    _foodEntries
      ..clear()
      ..addAll(
        entries.map(
          (dto) => _mapFoodEntry(
            dto,
            metadata: _foodMetadata[dto.id?.toString() ?? ''],
          ),
        ),
      )
      ..sort((a, b) => b.analysedAt.compareTo(a.analysedAt));
  }

  Future<void> _refreshSleep() async {
    if (ExternalApiConfig.sleepTopicId.isNotEmpty) {
      try {
        await syncSleepFromMirror(limit: 100, notify: false);
        return;
      } catch (_) {
        // Fallback to REST API below.
      }
    }

    final entries = await _sleepApi.fetchSleepEntries();
    _sleepEntries
      ..clear()
      ..addAll(
        entries.map(
          (dto) => _mapSleepEntry(
            dto,
            metadata: _sleepMetadata[dto.id?.toString() ?? ''],
          ),
        ),
      )
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> _refreshActivity() async {
    if (ExternalApiConfig.activityTopicId.isNotEmpty) {
      try {
        await syncActivityFromMirror(limit: 100, notify: false);
        return;
      } catch (_) {
        // Fallback to REST API below.
      }
    }

    final entries = await _activityApi.fetchActivities();
    _activityEntries
      ..clear()
      ..addAll(
        entries.map(
          (dto) => _mapActivityEntry(
            dto,
            metadata: _activityMetadata[dto.id?.toString() ?? ''],
          ),
        ),
      )
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> _refreshMedicine() async {
    if (ExternalApiConfig.medicineTopicId.isNotEmpty) {
      try {
        await syncMedicineFromMirror(limit: 100, notify: false);
        return;
      } catch (_) {
        // Fallback to REST API below.
      }
    }

    final entries = await _medicineApi.fetchMedicines();
    _medicineEntries
      ..clear()
      ..addAll(
        entries.map(
          (dto) => _mapMedicineEntry(
            dto,
            metadata: _medicineMetadata[dto.id?.toString() ?? ''],
          ),
        ),
      )
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> _refreshHealth() async {
    if (ExternalApiConfig.healthTopicId.isNotEmpty) {
      try {
        await syncHealthFromMirror(limit: 100, notify: false);
        return;
      } catch (_) {
        // Fallback to REST API below.
      }
    }

    final entries = await _healthApi.fetchHealthReadings();
    _healthReadings
      ..clear()
      ..addAll(
        entries.map(
          (dto) => _mapHealthReading(
            dto,
            metadata: _healthMetadata[dto.id?.toString() ?? ''],
          ),
        ),
      )
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
  }

  Future<void> _loadMetadata() async {
    final foodMeta = await AppStorage.readMap(AppStorage.foodMetadataKey);
    if (foodMeta != null) {
      _foodMetadata = foodMeta.map(
        (key, value) => MapEntry(
          key,
          (value as Map).map(
            (k, v) => MapEntry(k.toString(), v),
          ),
        ),
      );
    }

    final medicineMeta =
        await AppStorage.readMap(AppStorage.medicineMetadataKey);
    if (medicineMeta != null) {
      _medicineMetadata = medicineMeta.map(
        (key, value) => MapEntry(
          key,
          (value as Map).map(
            (k, v) => MapEntry(k.toString(), v),
          ),
        ),
      );
    }

    final sleepMeta = await AppStorage.readMap(AppStorage.sleepMetadataKey);
    if (sleepMeta != null) {
      _sleepMetadata = sleepMeta.map(
        (key, value) => MapEntry(
          key,
          (value as Map).map((k, v) => MapEntry(k.toString(), v)),
        ),
      );
    }

    final activityMeta =
        await AppStorage.readMap(AppStorage.activityMetadataKey);
    if (activityMeta != null) {
      _activityMetadata = activityMeta.map(
        (key, value) => MapEntry(
          key,
          (value as Map).map((k, v) => MapEntry(k.toString(), v)),
        ),
      );
    }

    final healthMeta = await AppStorage.readMap(AppStorage.healthMetadataKey);
    if (healthMeta != null) {
      _healthMetadata = healthMeta.map(
        (key, value) => MapEntry(
          key,
          (value as Map).map((k, v) => MapEntry(k.toString(), v)),
        ),
      );
    }
  }

  Future<void> _persistFoodMetadata() async {
    await AppStorage.saveMap(AppStorage.foodMetadataKey, _foodMetadata);
  }

  Future<void> _persistMedicineMetadata() async {
    await AppStorage.saveMap(AppStorage.medicineMetadataKey, _medicineMetadata);
  }

  Future<void> _persistSleepMetadata() async {
    await AppStorage.saveMap(AppStorage.sleepMetadataKey, _sleepMetadata);
  }

  Future<void> _persistActivityMetadata() async {
    await AppStorage.saveMap(AppStorage.activityMetadataKey, _activityMetadata);
  }

  Future<void> _persistHealthMetadata() async {
    await AppStorage.saveMap(AppStorage.healthMetadataKey, _healthMetadata);
  }

  Future<void> syncFoodFromMirror({int limit = 50, bool notify = true}) async {
    final entries = await _loadFoodMessages(limit: limit);
    if (entries == null) return;
    _foodEntries
      ..clear()
      ..addAll(entries);
    if (notify) notifyListeners();
  }

  Future<void> refreshFoodEntries({bool notify = true}) async {
    await _refreshFood();
    if (notify) notifyListeners();
  }

  Future<void> syncSleepFromMirror({int limit = 50, bool notify = true}) async {
    final entries = await _loadSleepMessages(limit: limit);
    if (entries == null) return;
    _sleepEntries
      ..clear()
      ..addAll(entries);
    if (notify) notifyListeners();
  }

  Future<void> refreshSleepEntries({bool notify = true}) async {
    await _refreshSleep();
    if (notify) notifyListeners();
  }

  Future<void> syncActivityFromMirror({
    int limit = 50,
    bool notify = true,
  }) async {
    final entries = await _loadActivityMessages(limit: limit);
    if (entries == null) return;
    _activityEntries
      ..clear()
      ..addAll(entries);
    if (notify) notifyListeners();
  }

  Future<void> refreshActivityEntries({bool notify = true}) async {
    await _refreshActivity();
    if (notify) notifyListeners();
  }

  Future<void> syncMedicineFromMirror({
    int limit = 50,
    bool notify = true,
  }) async {
    final entries = await _loadMedicineMessages(limit: limit);
    if (entries == null) return;
    _medicineEntries
      ..clear()
      ..addAll(entries);
    if (notify) notifyListeners();
  }

  Future<void> refreshMedicineEntries({bool notify = true}) async {
    await _refreshMedicine();
    if (notify) notifyListeners();
  }

  Future<void> syncHealthFromMirror(
      {int limit = 50, bool notify = true}) async {
    final entries = await _loadHealthMessages(limit: limit);
    if (entries == null) return;
    _healthReadings
      ..clear()
      ..addAll(entries);
    if (notify) notifyListeners();
  }

  Future<void> refreshHealthEntries({bool notify = true}) async {
    await _refreshHealth();
    if (notify) notifyListeners();
  }

  Future<List<FoodEntry>?> _loadFoodMessages({int limit = 50}) async {
    final topicId = ExternalApiConfig.foodTopicId;
    if (topicId.isEmpty) return null;

    final messages = await _hederaMirror.fetchTopicMessages(
      topicId,
      limit: limit,
    );

    final results = <FoodEntry>[];
    for (final message in messages) {
      final payload = message.decodedJson;
      if (payload == null || payload.isEmpty) continue;

      final id = (payload['id'] as String?) ?? message.consensusTimestamp;
      if (id.isEmpty) continue;

      final metadata = _foodMetadata[id] ?? const <String, dynamic>{};
      final analysedAtIso = payload['analysedAt'] as String? ??
          payload['timestamp'] as String? ??
          metadata['analysedAt'] as String?;

      final entry = FoodEntry(
        id: id,
        description: payload['description'] as String? ??
            metadata['description'] as String? ??
            'Meal',
        mealType:
            payload['mealType'] as String? ?? metadata['mealType'] as String?,
        drink: payload['drink'] as String? ?? metadata['drink'] as String?,
        dessert:
            payload['dessert'] as String? ?? metadata['dessert'] as String?,
        calories: (payload['calories'] as num?)?.round() ??
            (payload['caloriesKcal'] as num?)?.round() ??
            0,
        proteinGrams: (payload['protein'] as num?)?.toDouble() ??
            (payload['proteinGrams'] as num?)?.toDouble() ??
            0,
        carbsGrams: (payload['carbs'] as num?)?.toDouble() ??
            (payload['carbsGrams'] as num?)?.toDouble() ??
            0,
        fatGrams: (payload['fat'] as num?)?.toDouble() ??
            (payload['fatGrams'] as num?)?.toDouble() ??
            0,
        cholesterolMg: (payload['cholesterol'] as num?)?.toDouble() ??
            (payload['cholesterolMg'] as num?)?.toDouble() ??
            0,
        aiSummary: metadata['recommendation'] as String? ?? '',
        analysedAt: _parseTimestamp(analysedAtIso, message.consensusTimestamp),
      );
      results.add(entry);
    }

    results.sort((a, b) => b.analysedAt.compareTo(a.analysedAt));
    return results;
  }

  Future<List<SleepEntry>?> _loadSleepMessages({int limit = 50}) async {
    final topicId = ExternalApiConfig.sleepTopicId;
    if (topicId.isEmpty) return null;

    final messages = await _hederaMirror.fetchTopicMessages(
      topicId,
      limit: limit,
    );

    final results = <SleepEntry>[];
    for (final message in messages) {
      final payload = message.decodedJson;
      if (payload == null || payload.isEmpty) continue;
      final id = (payload['id'] as String?) ?? message.consensusTimestamp;
      if (id.isEmpty) continue;

      final metadata = _sleepMetadata[id] ?? const <String, dynamic>{};
      final hours = (payload['sleepHours'] as num?)?.toDouble() ??
          (payload['hours'] as num?)?.toDouble() ??
          (metadata['hours'] as num?)?.toDouble() ??
          0;

      final dateIso = payload['sleepDate'] as String? ??
          payload['date'] as String? ??
          payload['timestamp'] as String? ??
          metadata['date'] as String?;

      results.add(
        SleepEntry(
          id: id,
          date: _parseTimestamp(dateIso, message.consensusTimestamp),
          hours: hours,
          recommendation: metadata['recommendation'] as String?,
        ),
      );
    }

    results.sort((a, b) => b.date.compareTo(a.date));
    return results;
  }

  Future<List<ActivityEntry>?> _loadActivityMessages({int limit = 50}) async {
    final topicId = ExternalApiConfig.activityTopicId;
    if (topicId.isEmpty) return null;

    final messages = await _hederaMirror.fetchTopicMessages(
      topicId,
      limit: limit,
    );

    final results = <ActivityEntry>[];
    for (final message in messages) {
      final payload = message.decodedJson;
      if (payload == null || payload.isEmpty) continue;
      final id = (payload['id'] as String?) ?? message.consensusTimestamp;
      if (id.isEmpty) continue;

      final metadata = _activityMetadata[id] ?? const <String, dynamic>{};
      final duration = (payload['durationMinutes'] as num?)?.toInt() ??
          (payload['duration'] as num?)?.toInt() ??
          (payload['Duration_Minutes'] as num?)?.toInt() ??
          (metadata['minutes'] as num?)?.toInt() ??
          0;
      final calories = (payload['caloriesBurned'] as num?)?.round() ??
          (payload['Calories_Burned'] as num?)?.round() ??
          (payload['calories'] as num?)?.round() ??
          (metadata['calories'] as num?)?.round() ??
          0;

      results.add(
        ActivityEntry(
          id: id,
          name: payload['exerciseType'] as String? ??
              payload['activityType'] as String? ??
              payload['Activity_Type'] as String? ??
              metadata['name'] as String? ??
              'Activity',
          minutes: duration,
          calories: calories,
          createdAt: _parseTimestamp(
            payload['timestamp'] as String? ??
                payload['recordedAt'] as String? ??
                metadata['createdAt'] as String?,
            message.consensusTimestamp,
          ),
          recommendation: metadata['recommendation'] as String?,
        ),
      );
    }

    results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return results;
  }

  Future<List<MedicineEntry>?> _loadMedicineMessages({int limit = 50}) async {
    final topicId = ExternalApiConfig.medicineTopicId;
    if (topicId.isEmpty) return null;

    final messages = await _hederaMirror.fetchTopicMessages(
      topicId,
      limit: limit,
    );

    final results = <MedicineEntry>[];
    for (final message in messages) {
      final payload = message.decodedJson;
      if (payload == null || payload.isEmpty) continue;
      final id = (payload['id'] as String?) ?? message.consensusTimestamp;
      if (id.isEmpty) continue;

      final metadata = _medicineMetadata[id] ?? const <String, dynamic>{};
      results.add(
        MedicineEntry(
          id: id,
          medicineName: payload['medicineName'] as String? ??
              metadata['medicineName'] as String? ??
              '',
          dosage: payload['dosage'] as String? ??
              metadata['dosage'] as String? ??
              '',
          frequencyPerDay: (payload['frequencyPerDay'] as num? ??
                  payload['frequency'] as num? ??
                  metadata['frequencyPerDay'] as num? ??
                  0)
              .toInt(),
          durationDays: (payload['durationDays'] as num? ??
                  payload['duration'] as num? ??
                  metadata['durationDays'] as num? ??
                  0)
              .toInt(),
          createdAt: _parseTimestamp(
            payload['startDate'] as String? ??
                payload['timestamp'] as String? ??
                metadata['createdAt'] as String?,
            message.consensusTimestamp,
          ),
          taken: metadata['taken'] as bool? ?? false,
          recommendation: metadata['recommendation'] as String?,
        ),
      );
    }

    results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return results;
  }

  Future<List<HealthReading>?> _loadHealthMessages({int limit = 50}) async {
    final topicId = ExternalApiConfig.healthTopicId;
    if (topicId.isEmpty) return null;

    final messages = await _hederaMirror.fetchTopicMessages(
      topicId,
      limit: limit,
    );

    final results = <HealthReading>[];
    for (final message in messages) {
      final payload = message.decodedJson;
      if (payload == null || payload.isEmpty) continue;
      final id = (payload['id'] as String?) ?? message.consensusTimestamp;
      if (id.isEmpty) continue;

      final metadata = _healthMetadata[id] ?? const <String, dynamic>{};
      final bloodPressure = (payload['bloodPressure'] as num?)?.toDouble() ??
          (payload['BloodPressure'] as num?)?.toDouble() ??
          (metadata['bloodPressure'] as num?)?.toDouble() ??
          0;
      final sugarLevel = (payload['sugarLevel'] as num?)?.toDouble() ??
          (payload['bloodSugar'] as num?)?.toDouble() ??
          (payload['glucose'] as num?)?.toDouble() ??
          (metadata['sugarLevel'] as num?)?.toDouble() ??
          0;
      final heartRate = (payload['heartRate'] as num?)?.toDouble() ??
          (payload['HeartRate'] as num?)?.toDouble() ??
          (metadata['heartRate'] as num?)?.toDouble();
      results.add(
        HealthReading(
          id: id,
          bloodPressure: bloodPressure,
          sugarLevel: sugarLevel,
          heartRate: heartRate != null && heartRate > 0 ? heartRate : null,
          recordedAt: _parseTimestamp(
            payload['recordedAt'] as String? ??
                payload['timestamp'] as String? ??
                metadata['recordedAt'] as String?,
            message.consensusTimestamp,
          ),
          recommendation: metadata['recommendation'] as String?,
          diastolic: (payload['bloodPressureDiastolic'] as num?)?.toDouble() ??
              (metadata['bloodPressureDiastolic'] as num?)?.toDouble(),
          bloodPressureLabel: (payload['bloodPressureDisplay'] as String?) ??
              metadata['bloodPressureDisplay'] as String?,
          sugarLevelLabel: (payload['bloodSugarLabel'] as String?) ??
              metadata['sugarLevelLabel'] as String?,
        ),
      );
    }

    results.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
    return results;
  }

  Future<void> cacheFoodMetadata({
    required String id,
    String? description,
    String? mealType,
    String? drink,
    String? dessert,
    String? recommendation,
    String? summary,
    DateTime? analysedAt,
  }) async {
    final current = Map<String, dynamic>.from(_foodMetadata[id] ?? {});
    if (description != null) current['description'] = description;
    if (mealType != null) current['mealType'] = mealType;
    if (drink != null) current['drink'] = drink;
    if (dessert != null) current['dessert'] = dessert;
    if (recommendation != null) current['recommendation'] = recommendation;
    if (summary != null) current['aiSummary'] = summary;
    if (analysedAt != null) {
      current['analysedAt'] = analysedAt.toIso8601String();
    }
    _foodMetadata[id] = current;
    await _persistFoodMetadata();
  }

  Future<void> cacheSleepRecommendation({
    required String id,
    String? recommendation,
    double? hours,
    DateTime? date,
  }) async {
    final current = Map<String, dynamic>.from(_sleepMetadata[id] ?? {});
    if (recommendation != null) current['recommendation'] = recommendation;
    if (hours != null) current['hours'] = hours;
    if (date != null) current['date'] = date.toIso8601String();
    _sleepMetadata[id] = current;
    await _persistSleepMetadata();
  }

  Future<void> cacheActivityRecommendation({
    required String id,
    String? recommendation,
    String? name,
    int? minutes,
    int? calories,
    DateTime? createdAt,
  }) async {
    final current = Map<String, dynamic>.from(_activityMetadata[id] ?? {});
    if (recommendation != null) current['recommendation'] = recommendation;
    if (name != null) current['name'] = name;
    if (minutes != null) current['minutes'] = minutes;
    if (calories != null) current['calories'] = calories;
    if (createdAt != null) {
      current['createdAt'] = createdAt.toIso8601String();
    }
    _activityMetadata[id] = current;
    await _persistActivityMetadata();
  }

  Future<void> cacheHealthRecommendation({
    required String id,
    String? recommendation,
    double? bloodPressure,
    double? sugarLevel,
    double? heartRate,
    DateTime? recordedAt,
    double? bloodPressureDiastolic,
    String? bloodPressureDisplay,
    String? sugarLevelLabel,
  }) async {
    final current = Map<String, dynamic>.from(_healthMetadata[id] ?? {});
    if (recommendation != null) current['recommendation'] = recommendation;
    if (bloodPressure != null) current['bloodPressure'] = bloodPressure;
    if (sugarLevel != null) current['sugarLevel'] = sugarLevel;
    if (heartRate != null) current['heartRate'] = heartRate;
    if (recordedAt != null) {
      current['recordedAt'] = recordedAt.toIso8601String();
    }
    if (bloodPressureDiastolic != null) {
      current['bloodPressureDiastolic'] = bloodPressureDiastolic;
    }
    if (bloodPressureDisplay != null && bloodPressureDisplay.isNotEmpty) {
      current['bloodPressureDisplay'] = bloodPressureDisplay;
    }
    if (sugarLevelLabel != null && sugarLevelLabel.isNotEmpty) {
      current['sugarLevelLabel'] = sugarLevelLabel;
    }
    _healthMetadata[id] = current;
    await _persistHealthMetadata();
  }

  Future<void> cacheMedicineMetadata({
    required String id,
    String? recommendation,
    String? dosage,
    int? frequencyPerDay,
    int? durationDays,
    String? medicineName,
    bool? taken,
    DateTime? createdAt,
  }) async {
    final current = Map<String, dynamic>.from(_medicineMetadata[id] ?? {});
    if (recommendation != null) current['recommendation'] = recommendation;
    if (dosage != null) current['dosage'] = dosage;
    if (frequencyPerDay != null) {
      current['frequencyPerDay'] = frequencyPerDay;
    }
    if (durationDays != null) current['durationDays'] = durationDays;
    if (medicineName != null) current['medicineName'] = medicineName;
    if (taken != null) current['taken'] = taken;
    if (createdAt != null) {
      current['createdAt'] = createdAt.toIso8601String();
    }
    _medicineMetadata[id] = current;
    await _persistMedicineMetadata();
  }

  Future<void> _persistSettings() async {
    if (!_isLoggedIn) return;
    final dto = api_settings.AppSettingsCreateDto(
      notificationsEnabled: _settings.notificationsEnabled,
      theme: _settings.darkMode ? 'dark' : 'light',
    );
    try {
      if (_settingsId != null) {
        await _appSettingsApi.updateSettings(_settingsId!, dto);
      } else {
        final created = await _appSettingsApi.createSettings(dto);
        _settingsId = created.id;
      }
    } catch (_) {
      // Ignore failures to keep UX smooth; settings persist locally.
    }
  }

  FoodEntry _mapFoodEntry(
    api_food.FoodEntryDto entry, {
    Map<String, dynamic>? metadata,
  }) {
    final id = entry.id?.toString() ??
        DateTime.now().millisecondsSinceEpoch.toString();
    final meta = metadata ?? const <String, dynamic>{};
    return FoodEntry(
      id: id,
      description: entry.foodName ?? meta['description'] as String? ?? 'Meal',
      mealType: meta['mealType'] as String?,
      drink: meta['drink'] as String?,
      dessert: meta['dessert'] as String?,
      calories:
          entry.calories?.round() ?? (meta['calories'] as num?)?.round() ?? 0,
      proteinGrams:
          entry.protein ?? (meta['proteinGrams'] as num?)?.toDouble() ?? 0,
      carbsGrams: entry.carbs ?? (meta['carbsGrams'] as num?)?.toDouble() ?? 0,
      fatGrams: entry.fat ?? (meta['fatGrams'] as num?)?.toDouble() ?? 0,
      cholesterolMg: (meta['cholesterolMg'] as num?)?.toDouble() ?? 0,
      aiSummary: meta['recommendation'] as String? ??
          meta['aiSummary'] as String? ??
          '',
      analysedAt: entry.date ?? DateTime.now(),
    );
  }

  SleepEntry _mapSleepEntry(
    api_sleep.SleepEntryDto entry, {
    Map<String, dynamic>? metadata,
  }) {
    final id = entry.id?.toString() ??
        DateTime.now().millisecondsSinceEpoch.toString();
    final meta = metadata ?? const <String, dynamic>{};
    return SleepEntry(
      id: id,
      date: entry.sleepDate ??
          DateTime.tryParse(meta['date'] as String? ?? '') ??
          DateTime.now(),
      hours: entry.hoursSlept ?? (meta['hours'] as num?)?.toDouble() ?? 0,
      recommendation: meta['recommendation'] as String?,
    );
  }

  ActivityEntry _mapActivityEntry(
    api_activity.ActivityEntryDto entry, {
    Map<String, dynamic>? metadata,
  }) {
    final id = entry.id?.toString() ??
        DateTime.now().millisecondsSinceEpoch.toString();
    final meta = metadata ?? const <String, dynamic>{};
    return ActivityEntry(
      id: id,
      name: entry.activityType ?? meta['name'] as String? ?? 'Activity',
      minutes: (entry.duration ?? meta['minutes'] ?? 0).round(),
      calories:
          (entry.caloriesBurned ?? (meta['calories'] as num?) ?? 0).round(),
      createdAt: entry.date ??
          DateTime.tryParse(meta['createdAt'] as String? ?? '') ??
          DateTime.now(),
      recommendation: meta['recommendation'] as String?,
    );
  }

  MedicineEntry _mapMedicineEntry(
    api_medicine.MedicineEntryDto entry, {
    Map<String, dynamic>? metadata,
  }) {
    final id = entry.id?.toString() ??
        DateTime.now().millisecondsSinceEpoch.toString();
    final meta = metadata ?? const <String, dynamic>{};
    return MedicineEntry(
      id: id,
      medicineName: entry.medicineName ?? meta['medicineName'] as String? ?? '',
      dosage: meta['dosage'] as String? ?? entry.dosage ?? '',
      frequencyPerDay: (meta['frequencyPerDay'] as num? ?? 0).toInt(),
      durationDays: (meta['durationDays'] as num? ?? 0).toInt(),
      createdAt: entry.timeTaken ??
          DateTime.tryParse(meta['createdAt'] as String? ?? '') ??
          DateTime.now(),
      taken: meta['taken'] as bool? ?? false,
      recommendation: meta['recommendation'] as String?,
    );
  }

  HealthReading _mapHealthReading(
    api_health.HealthReadingDto entry, {
    Map<String, dynamic>? metadata,
  }) {
    final id = entry.id?.toString() ??
        DateTime.now().millisecondsSinceEpoch.toString();
    final meta = metadata ?? const <String, dynamic>{};
    final diastolic = (meta['bloodPressureDiastolic'] as num?)?.toDouble();
    final bloodPressureLabel = meta['bloodPressureDisplay'] as String?;
    final resolvedBloodPressure =
        entry.bloodPressure ?? (meta['bloodPressure'] as num?)?.toDouble() ?? 0;
    final rawHeartRate =
        entry.heartRate ?? (meta['heartRate'] as num?)?.toDouble();
    final resolvedHeartRate =
        (rawHeartRate != null && rawHeartRate > 0) ? rawHeartRate : null;
    final resolvedSugar =
        entry.sugarLevel ?? (meta['sugarLevel'] as num?)?.toDouble() ?? 0;
    final recordedAt = entry.recordedAt ??
        DateTime.tryParse(meta['recordedAt'] as String? ?? '') ??
        DateTime.now();
    final label = (bloodPressureLabel != null &&
            bloodPressureLabel.trim().isNotEmpty)
        ? bloodPressureLabel.trim()
        : diastolic != null
            ? '${resolvedBloodPressure.toStringAsFixed(0)}/${diastolic.toStringAsFixed(0)}'
            : resolvedBloodPressure.toStringAsFixed(0);
    return HealthReading(
      id: id,
      bloodPressure: resolvedBloodPressure,
      sugarLevel: resolvedSugar,
      heartRate: resolvedHeartRate,
      recordedAt: recordedAt,
      recommendation: meta['recommendation'] as String?,
      diastolic: diastolic,
      bloodPressureLabel: label,
      sugarLevelLabel: meta['sugarLevelLabel'] as String?,
    );
  }

  DateTime _parseTimestamp(String? isoString, String? consensusTimestamp) {
    if (isoString != null && isoString.isNotEmpty) {
      final parsed = DateTime.tryParse(isoString);
      if (parsed != null) {
        return parsed.toLocal();
      }
    }
    return _consensusToDateTime(consensusTimestamp);
  }

  DateTime _consensusToDateTime(String? consensusTimestamp) {
    if (consensusTimestamp == null || consensusTimestamp.isEmpty) {
      return DateTime.now();
    }

    final parts = consensusTimestamp.split('.');
    final seconds = int.tryParse(parts[0]);
    if (seconds == null) return DateTime.now();

    int nanos = 0;
    if (parts.length > 1) {
      final padded = parts[1].padRight(9, '0');
      nanos = int.tryParse(padded.substring(0, 9)) ?? 0;
    }

    final dateTime = DateTime.fromMillisecondsSinceEpoch(
      seconds * 1000 + nanos ~/ 1000000,
      isUtc: true,
    );
    return dateTime.toLocal();
  }
}
