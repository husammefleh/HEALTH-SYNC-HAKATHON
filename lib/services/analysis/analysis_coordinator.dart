import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../models/analysis_models.dart';
import '../../state/app_state.dart';
import '../api/ai_api_service.dart';
import '../api/external_api_config.dart';
import '../api/hedera_writer_service.dart';

class AnalysisCoordinator {
  AnalysisCoordinator({
    required AiApiService aiApi,
    required HederaWriterService hederaWriter,
    required AppState appState,
    Uuid? uuid,
  })  : _aiApi = aiApi,
        _hederaWriter = hederaWriter,
        _appState = appState,
        _uuid = uuid ?? const Uuid();

  final AiApiService _aiApi;
  final HederaWriterService _hederaWriter;
  final AppState _appState;
  final Uuid _uuid;

  Future<FoodAnalysisOutput> performFoodAnalysis(
    FoodAnalysisInput input,
  ) async {
    final generatedAt = DateTime.now();

    final foodPrompt = _composeFoodPrompt(input);
    final requestPayload = <String, dynamic>{
      'foodName': input.description,
      'description': input.description,
      'date': generatedAt.toIso8601String(),
      if (input.mealType != null) 'mealType': input.mealType,
      if (input.drink != null) 'drink': input.drink,
      if (input.dessert != null) 'dessert': input.dessert,
      'jsonData': foodPrompt,
    };

    final aiResponse = await _aiApi.analyzeFood(requestPayload);
    final responseRecordId = _stringValue(
      _resolveField(aiResponse, const ['id', 'recordId', 'entryId']),
    );

    final calories = _parseInt(
      _resolveField(aiResponse, const ['calories', 'calorie', 'energy']),
    );
    final protein = _parseDouble(
      _resolveField(aiResponse, const ['protein', 'proteinGrams', 'protein_g']),
    );
    final carbs = _parseDouble(
      _resolveField(
          aiResponse, const ['carbs', 'carbohydrates', 'carbohydrates_g']),
    );
    final fat = _parseDouble(
      _resolveField(aiResponse, const ['fat', 'fats', 'fat_g']),
    );
    final cholesterol = _parseDouble(
      _resolveField(aiResponse, const ['cholesterol', 'cholesterolMg']),
    );
    final summary = _stringValue(
      _resolveField(aiResponse, const ['summary', 'analysis', 'insight']),
    );
    final recommendation = _extractRecommendation(aiResponse);

    final topicId = ExternalApiConfig.foodTopicId;
    final recordId =
        topicId.isNotEmpty ? _uuid.v4() : responseRecordId ?? _uuid.v4();

    HederaSubmissionResult? writerResult;
    bool persisted;

    if (topicId.isNotEmpty) {
      final payload = <String, dynamic>{
        'id': recordId,
        'description': input.description,
        if (input.mealType != null) 'mealType': input.mealType,
        if (input.drink != null) 'drink': input.drink,
        if (input.dessert != null) 'dessert': input.dessert,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        'cholesterol': cholesterol,
        'timestamp': generatedAt.toIso8601String(),
      };

      writerResult = await _hederaWriter.addRecord(
        topicId: topicId,
        message: payload,
      );

      await _appState.cacheFoodMetadata(
        id: recordId,
        description: input.description,
        mealType: input.mealType,
        drink: input.drink,
        dessert: input.dessert,
        recommendation: recommendation,
        summary: summary,
        analysedAt: generatedAt,
      );

      persisted = await _awaitMirrorSync(
        () => _appState.syncFoodFromMirror(notify: true),
        () => _appState.foodEntries.any((entry) => entry.id == recordId),
      );
    } else {
      writerResult = null;
      await _appState.cacheFoodMetadata(
        id: recordId,
        description: input.description,
        mealType: input.mealType,
        drink: input.drink,
        dessert: input.dessert,
        recommendation: recommendation,
        summary: summary,
        analysedAt: generatedAt,
      );
      await _appState.refreshFoodEntries();
      persisted = true;
    }

    return FoodAnalysisOutput(
      recordId: recordId,
      generatedAt: generatedAt,
      persisted: persisted,
      transactionId: writerResult?.transactionId,
      consensusTimestamp: writerResult?.consensusTimestamp,
      rawResponse: aiResponse,
      description: input.description,
      mealType: input.mealType,
      drink: input.drink,
      dessert: input.dessert,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      cholesterol: cholesterol,
      recommendation: recommendation,
      summary: summary,
    );
  }

  Future<SleepAnalysisOutput> performSleepAnalysis(
    SleepAnalysisInput input,
  ) async {
    final aiResponse = await _aiApi.analyzeSleep({
      'sleepHours': input.hours,
      'hours': input.hours,
      'hoursSlept': input.hours,
      'sleepDate': input.sleepDate.toIso8601String(),
    });

    final recommendation = _extractRecommendation(aiResponse);
    final summary = _stringValue(
      _resolveField(aiResponse, const ['summary', 'analysis', 'insight']),
    );
    final responseRecordId = _stringValue(
      _resolveField(aiResponse, const ['id', 'recordId', 'sleepEntryId']),
    );

    final generatedAt = DateTime.now();

    final topicId = ExternalApiConfig.sleepTopicId;
    final recordId =
        topicId.isNotEmpty ? _uuid.v4() : responseRecordId ?? _uuid.v4();

    HederaSubmissionResult? writerResult;
    bool persisted;

    if (topicId.isNotEmpty) {
      final payload = <String, dynamic>{
        'id': recordId,
        'sleepHours': input.hours,
        'sleepDate': input.sleepDate.toIso8601String(),
        'timestamp': generatedAt.toIso8601String(),
      };

      writerResult = await _hederaWriter.addRecord(
        topicId: topicId,
        message: payload,
      );

      await _appState.cacheSleepRecommendation(
        id: recordId,
        recommendation: recommendation,
        hours: input.hours,
        date: input.sleepDate,
      );

      persisted = await _awaitMirrorSync(
        () => _appState.syncSleepFromMirror(notify: true),
        () => _appState.sleepEntries.any((entry) => entry.id == recordId),
      );
    } else {
      writerResult = null;
      await _appState.cacheSleepRecommendation(
        id: recordId,
        recommendation: recommendation,
        hours: input.hours,
        date: input.sleepDate,
      );
      await _appState.refreshSleepEntries();
      persisted = true;
    }

    return SleepAnalysisOutput(
      recordId: recordId,
      generatedAt: generatedAt,
      persisted: persisted,
      transactionId: writerResult?.transactionId,
      consensusTimestamp: writerResult?.consensusTimestamp,
      rawResponse: aiResponse,
      hours: input.hours,
      sleepDate: input.sleepDate,
      recommendation: recommendation,
      summary: summary,
    );
  }

  Future<ActivityAnalysisOutput> performActivityAnalysis(
    ActivityAnalysisInput input,
  ) async {
    final activityPrompt = _composeActivityPrompt(input);
    final aiResponse = await _aiApi.analyzeActivity({
      'title': 'Activity analysis request',
      'activityType': input.exerciseType,
      'exerciseType': input.exerciseType,
      'durationMinutes': input.durationMinutes,
      'duration': input.durationMinutes,
      'jsonData': activityPrompt,
    });

    final calories = _parseInt(
      _resolveField(
        aiResponse,
        const [
          'caloriesBurned',
          'calories_burned',
          'burned_calories',
          'calories',
          'energySpent',
          'burnedCalories',
        ],
      ),
    );
    final recommendation = _extractRecommendation(aiResponse);
    final summary = _stringValue(
      _resolveField(aiResponse, const ['summary', 'analysis', 'insight']),
    );
    final secondaryTip = _stringValue(
      _resolveField(aiResponse, const ['tip', 'secondaryTip', 'note']),
    );
    final responseRecordId = _stringValue(
      _resolveField(aiResponse, const ['id', 'recordId', 'activityEntryId']),
    );

    final generatedAt = DateTime.now();

    final topicId = ExternalApiConfig.activityTopicId;
    final recordId =
        topicId.isNotEmpty ? _uuid.v4() : responseRecordId ?? _uuid.v4();

    HederaSubmissionResult? writerResult;
    bool persisted;

    if (topicId.isNotEmpty) {
      final payload = <String, dynamic>{
        'id': recordId,
        'exerciseType': input.exerciseType,
        'durationMinutes': input.durationMinutes,
        'caloriesBurned': calories,
        'timestamp': generatedAt.toIso8601String(),
        'Activity_Type': input.exerciseType,
        'Duration_Minutes': input.durationMinutes,
        'Calories_Burned': calories,
        'Category': 'Activity',
      };

      writerResult = await _hederaWriter.addRecord(
        topicId: topicId,
        message: payload,
      );

      await _appState.cacheActivityRecommendation(
        id: recordId,
        recommendation: recommendation,
        name: input.exerciseType,
        minutes: input.durationMinutes,
        calories: calories,
        createdAt: generatedAt,
      );

      persisted = await _awaitMirrorSync(
        () => _appState.syncActivityFromMirror(notify: true),
        () => _appState.activityEntries.any((entry) => entry.id == recordId),
      );
    } else {
      writerResult = null;
      await _appState.cacheActivityRecommendation(
        id: recordId,
        recommendation: recommendation,
        name: input.exerciseType,
        minutes: input.durationMinutes,
        calories: calories,
        createdAt: generatedAt,
      );
      await _appState.refreshActivityEntries();
      persisted = true;
    }

    return ActivityAnalysisOutput(
      recordId: recordId,
      generatedAt: generatedAt,
      persisted: persisted,
      transactionId: writerResult?.transactionId,
      consensusTimestamp: writerResult?.consensusTimestamp,
      rawResponse: aiResponse,
      exerciseType: input.exerciseType,
      durationMinutes: input.durationMinutes,
      caloriesBurned: calories,
      recommendation: recommendation,
      summary: summary,
      secondaryTip: secondaryTip,
    );
  }

  Future<HealthAnalysisOutput> performHealthAnalysis(
    HealthAnalysisInput input,
  ) async {
    final healthPrompt = _composeHealthPrompt(input);
    final aiResponse = await _aiApi.analyzeHealth({
      'bloodPressure': input.bloodPressure,
      'sugarLevel': input.sugarLevel,
      'bloodSugar': input.sugarLevel,
      if (input.heartRate != null) 'heartRate': input.heartRate,
      'recordedAt': input.recordedAt.toIso8601String(),
      'jsonData': healthPrompt,
    });

    final recommendation = _extractRecommendation(aiResponse);
    final summary = _stringValue(
      _resolveField(aiResponse, const ['summary', 'analysis', 'insight']),
    );
    final heartRateFromResponse = _parseDouble(
      _resolveField(aiResponse, const ['heartRate', 'pulse']),
      defaultValue: double.nan,
    );
    final heartRateValue = input.heartRate ??
        (heartRateFromResponse.isNaN ? null : heartRateFromResponse);
    final sugarFromResponse = _parseDouble(
      _resolveField(
        aiResponse,
        const [
          'sugarLevel',
          'bloodSugar',
          'glucose',
          'bloodGlucose',
          'glucoseMgDl',
        ],
      ),
      defaultValue: double.nan,
    );
    final sugarValue =
        sugarFromResponse.isNaN ? input.sugarLevel : sugarFromResponse;
    final diastolicFromResponse = _parseDouble(
      _resolveField(
        aiResponse,
        const [
          'bloodPressureDiastolic',
          'diastolic',
          'diastolicPressure',
          'bpDiastolic',
        ],
      ),
      defaultValue: double.nan,
    );
    final diastolicValue = input.diastolic ??
        (diastolicFromResponse.isNaN ? null : diastolicFromResponse);
    final sugarLabel = _stringValue(
      _resolveField(
        aiResponse,
        const [
          'sugarLevelLabel',
          'bloodSugarLabel',
          'glucoseLabel',
          'glucoseStatus',
        ],
      ),
    );
    final rawBloodPressureLabel = (input.bloodPressureLabel ??
            _stringValue(
              _resolveField(
                aiResponse,
                const [
                  'bloodPressureLabel',
                  'bloodPressureDisplay',
                  'bloodPressureReading',
                  'bloodPressureText',
                ],
              ),
            ))
        ?.trim();
    final bloodPressureLabel = (rawBloodPressureLabel != null &&
            rawBloodPressureLabel.isNotEmpty)
        ? rawBloodPressureLabel
        : diastolicValue != null
            ? '${input.bloodPressure.toStringAsFixed(0)}/${diastolicValue.toStringAsFixed(0)}'
            : input.bloodPressure.toStringAsFixed(0);
    final responseRecordId = _stringValue(
      _resolveField(aiResponse, const ['id', 'recordId', 'healthReadingId']),
    );

    final generatedAt = DateTime.now();

    final topicId = ExternalApiConfig.healthTopicId;
    final recordId =
        topicId.isNotEmpty ? _uuid.v4() : responseRecordId ?? _uuid.v4();

    HederaSubmissionResult? writerResult;
    bool persisted;

    if (topicId.isNotEmpty) {
      final payload = <String, dynamic>{
        'id': recordId,
        'bloodPressure': input.bloodPressure,
        'recordedAt': input.recordedAt.toIso8601String(),
        'timestamp': generatedAt.toIso8601String(),
        'Category': 'Health',
        'BloodPressure': input.bloodPressure,
        'sugarLevel': sugarValue,
        'BloodSugar': sugarValue,
      };
      if (diastolicValue != null) {
        payload['bloodPressureDiastolic'] = diastolicValue;
      }
      if (bloodPressureLabel.isNotEmpty) {
        payload['bloodPressureDisplay'] = bloodPressureLabel;
      }
      if (sugarLabel != null && sugarLabel.isNotEmpty) {
        payload['bloodSugarLabel'] = sugarLabel;
      }
      if (heartRateValue != null) {
        payload['heartRate'] = heartRateValue;
        payload['HeartRate'] = heartRateValue;
      }

      writerResult = await _hederaWriter.addRecord(
        topicId: topicId,
        message: payload,
      );

      await _appState.cacheHealthRecommendation(
        id: recordId,
        recommendation: recommendation,
        bloodPressure: input.bloodPressure,
        sugarLevel: sugarValue,
        heartRate: heartRateValue,
        recordedAt: input.recordedAt,
        bloodPressureDiastolic: diastolicValue,
        bloodPressureDisplay: bloodPressureLabel,
        sugarLevelLabel: sugarLabel,
      );

      persisted = await _awaitMirrorSync(
        () => _appState.syncHealthFromMirror(notify: true),
        () => _appState.healthReadings.any((entry) => entry.id == recordId),
      );
    } else {
      writerResult = null;
      await _appState.cacheHealthRecommendation(
        id: recordId,
        recommendation: recommendation,
        bloodPressure: input.bloodPressure,
        sugarLevel: sugarValue,
        heartRate: heartRateValue,
        recordedAt: input.recordedAt,
        bloodPressureDiastolic: diastolicValue,
        bloodPressureDisplay: bloodPressureLabel,
        sugarLevelLabel: sugarLabel,
      );
      await _appState.refreshHealthEntries();
      persisted = true;
    }

    return HealthAnalysisOutput(
      recordId: recordId,
      generatedAt: generatedAt,
      persisted: persisted,
      transactionId: writerResult?.transactionId,
      consensusTimestamp: writerResult?.consensusTimestamp,
      rawResponse: aiResponse,
      bloodPressure: input.bloodPressure,
      sugarLevel: sugarValue,
      heartRate: heartRateValue,
      recommendation: recommendation,
      summary: summary,
      bloodPressureLabel: bloodPressureLabel,
      diastolic: diastolicValue,
      sugarLevelLabel: sugarLabel,
    );
  }

  Future<MedicineAnalysisOutput> performMedicineAnalysis(
    MedicineAnalysisInput input,
  ) async {
    final medicinePrompt = _composeMedicinePrompt(input);
    final aiResponse = await _aiApi.analyzeMedicine({
      'medicineName': input.medicineName,
      'dosage': input.dosage,
      'frequencyPerDay': input.frequencyPerDay,
      'frequency': input.frequencyPerDay,
      'durationDays': input.durationDays,
      'duration': '${input.durationDays} days',
      'jsonData': medicinePrompt,
      'JsonData': medicinePrompt,
    });

    final recommendation = _extractRecommendation(aiResponse);
    final summary = _stringValue(
      _resolveField(aiResponse, const ['summary', 'analysis', 'insight']),
    );
    final responseRecordId = _stringValue(
      _resolveField(aiResponse, const ['id', 'recordId', 'medicineEntryId']),
    );

    final generatedAt = DateTime.now();

    final topicId = ExternalApiConfig.medicineTopicId;
    final recordId =
        topicId.isNotEmpty ? _uuid.v4() : responseRecordId ?? _uuid.v4();

    HederaSubmissionResult? writerResult;
    bool persisted;

    if (topicId.isNotEmpty) {
      final payload = <String, dynamic>{
        'id': recordId,
        'medicineName': input.medicineName,
        'dosage': input.dosage,
        'frequencyPerDay': input.frequencyPerDay,
        'durationDays': input.durationDays,
        'startDate': generatedAt.toIso8601String(),
        'Medicine_Name': input.medicineName,
        'Dosage': input.dosage,
        'Frequency_Per_Day': input.frequencyPerDay,
        'Duration_Days': input.durationDays,
        'Category': 'Medicine',
      };

      writerResult = await _hederaWriter.addRecord(
        topicId: topicId,
        message: payload,
      );

      await _appState.cacheMedicineMetadata(
        id: recordId,
        recommendation: recommendation,
        dosage: input.dosage,
        frequencyPerDay: input.frequencyPerDay,
        durationDays: input.durationDays,
        medicineName: input.medicineName,
        createdAt: generatedAt,
      );

      persisted = await _awaitMirrorSync(
        () => _appState.syncMedicineFromMirror(notify: true),
        () => _appState.medicineEntries.any((entry) => entry.id == recordId),
      );
    } else {
      writerResult = null;
      await _appState.cacheMedicineMetadata(
        id: recordId,
        recommendation: recommendation,
        dosage: input.dosage,
        frequencyPerDay: input.frequencyPerDay,
        durationDays: input.durationDays,
        medicineName: input.medicineName,
        createdAt: generatedAt,
      );
      await _appState.refreshMedicineEntries();
      persisted = true;
    }

    return MedicineAnalysisOutput(
      recordId: recordId,
      generatedAt: generatedAt,
      persisted: persisted,
      transactionId: writerResult?.transactionId,
      consensusTimestamp: writerResult?.consensusTimestamp,
      rawResponse: aiResponse,
      medicineName: input.medicineName,
      dosage: input.dosage,
      frequencyPerDay: input.frequencyPerDay,
      durationDays: input.durationDays,
      recommendation: recommendation,
      summary: summary,
    );
  }

  Future<bool> _awaitMirrorSync(
    Future<void> Function() refresh,
    bool Function() predicate,
  ) async {
    const maxAttempts = 5;
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      await refresh();
      if (predicate()) return true;
      await Future.delayed(Duration(milliseconds: 350 * (attempt + 1)));
    }
    return predicate();
  }

  static String _composeFoodPrompt(FoodAnalysisInput input) {
    final buffer = StringBuffer(input.description.trim());
    if (input.mealType != null && input.mealType!.isNotEmpty) {
      buffer.write('. Meal type: ${input.mealType}.');
    }
    if (input.drink != null && input.drink!.isNotEmpty) {
      buffer.write(' Drink: ${input.drink}.');
    }
    if (input.dessert != null &&
        input.dessert!.isNotEmpty &&
        input.dessert!.toLowerCase() != 'none') {
      buffer.write(' Dessert: ${input.dessert}.');
    }
    buffer.write(
        ' Provide a structured JSON response with key_metrics (calories, protein, fat, carbohydrates, cholesterol) and recommendations array.');
    return buffer.toString();
  }

  static String _composeActivityPrompt(ActivityAnalysisInput input) {
    return 'Activity: ${input.exerciseType} for ${input.durationMinutes} minutes. '
        'Estimate calories burned for an average adult and return JSON with '
        'summary, key_metrics.caloriesBurned, and recommendations.';
  }

  static String _composeMedicinePrompt(MedicineAnalysisInput input) {
    return 'Medicine: ${input.medicineName} with dosage ${input.dosage}, '
        'frequency ${input.frequencyPerDay} per day for ${input.durationDays} days. '
        'Provide adherence tips and highlight safety considerations in JSON with '
        'summary and recommendations array.';
  }

  static String _composeHealthPrompt(HealthAnalysisInput input) {
    final buffer = StringBuffer()
      ..write('Blood pressure: ${input.bloodPressure}');
    if (input.diastolic != null) {
      buffer.write('/${input.diastolic}');
    }
    buffer.write(' mmHg.');
    buffer.write(' Blood sugar: ${input.sugarLevel} mg/dL.');
    if (input.heartRate != null) {
      buffer.write(' Heart rate: ${input.heartRate} bpm.');
    }
    buffer.write(
        ' Return JSON with summary, key_metrics (bloodPressure, bloodSugar, heartRate) and recommendations.');
    return buffer.toString();
  }

  static String _extractRecommendation(Map<String, dynamic> data) {
    final value = _stringValue(
      _resolveField(
        data,
        const [
          'recommendation',
          'advice',
          'tip',
          'guidance',
          'recommendations',
          'tips',
        ],
      ),
    );
    if (value != null && value.isNotEmpty) return value;
    return 'No recommendation available yet.';
  }

  static dynamic _resolveField(
    Map<String, dynamic> data,
    List<String> keys, {
    int depth = 0,
  }) {
    if (depth > 4) return null;
    for (final key in keys) {
      if (data.containsKey(key)) {
        final value = data[key];
        if (value != null) return value;
      }
    }

    for (final value in data.values) {
      if (value is Map<String, dynamic>) {
        final nested = _resolveField(value, keys, depth: depth + 1);
        if (nested != null) return nested;
      } else if (value is List) {
        for (final element in value) {
          if (element is Map<String, dynamic>) {
            final nested = _resolveField(element, keys, depth: depth + 1);
            if (nested != null) return nested;
          }
        }
      }
    }
    return null;
  }

  static String? _stringValue(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    if (value is num) return value.toString();
    if (value is Iterable) {
      final buffer = <String>[];
      for (final element in value) {
        final elementString = _stringValue(element);
        if (elementString != null && elementString.isNotEmpty) {
          buffer.add(elementString);
        }
      }
      if (buffer.isNotEmpty) {
        return buffer.join('\n');
      }
      return null;
    }
    return null;
  }

  static double _parseDouble(
    dynamic value, {
    double defaultValue = 0,
  }) {
    if (value is num) return value.toDouble();
    if (value is String) {
      final normalized = value.replaceAll(',', '.');
      final match = RegExp(r'-?\d+(\.\d+)?').firstMatch(normalized);
      if (match != null) {
        return double.tryParse(match.group(0)!) ?? defaultValue;
      }
    }
    return defaultValue;
  }

  static int _parseInt(
    dynamic value, {
    int defaultValue = 0,
  }) {
    final doubleValue =
        _parseDouble(value, defaultValue: defaultValue.toDouble());
    return doubleValue.round();
  }
}
