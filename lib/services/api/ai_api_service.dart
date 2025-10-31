import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../app_storage.dart';
import 'api_config.dart';
import 'api_exception.dart';
import 'external_api_config.dart';

class AiApiService {
  AiApiService({Dio? dio}) : _dio = dio ?? _buildDio() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token =
              _token ?? await AppStorage.readString(AppStorage.authTokenKey);
          if (token != null && token.isNotEmpty) {
            _token = token;
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            _token = null;
          }
          handler.next(error);
        },
      ),
    );
  }

  final Dio _dio;
  String? _token;

  void updateAuthToken(String? token) {
    _token = token;
  }

  static Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ExternalApiConfig.aiBaseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          compact: true,
        ),
      );
    }

    if (!kIsWeb) {
      final adapter = dio.httpClientAdapter;
      if (adapter is IOHttpClientAdapter) {
        adapter.createHttpClient = () {
          final client = HttpClient();
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) =>
                  host == 'localhost';
          return client;
        };
      }
    }

    return dio;
  }

  Future<Map<String, dynamic>> analyzeFood(Map<String, dynamic> payload) {
    return _post<Map<String, dynamic>>(
      '/api/FoodEntries',
      payload,
      description: 'food analysis',
    );
  }

  Future<Map<String, dynamic>> analyzeSleep(Map<String, dynamic> payload) {
    return _post<Map<String, dynamic>>(
      '/api/SleepEntries',
      payload,
      description: 'sleep analysis',
    );
  }

  Future<Map<String, dynamic>> analyzeActivity(Map<String, dynamic> payload) {
    return _post<Map<String, dynamic>>(
      '/api/ActivityEntries',
      payload,
      description: 'activity analysis',
    );
  }

  Future<Map<String, dynamic>> analyzeHealth(Map<String, dynamic> payload) {
    return _post<Map<String, dynamic>>(
      '/api/HealthReadings',
      payload,
      description: 'health analysis',
    );
  }

  Future<Map<String, dynamic>> analyzeMedicine(Map<String, dynamic> payload) {
    return _post<Map<String, dynamic>>(
      '/api/MedicineEntries',
      payload,
      description: 'medicine analysis',
    );
  }

  Future<T> _post<T>(
    String path,
    Map<String, dynamic> payload, {
    required String description,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        path,
        data: payload,
      );
      final data = response.data;

      if (data == null && T == Map<String, dynamic>) {
        return <String, dynamic>{} as T;
      }

      if (data is T) return data;
      if (data is Map<String, dynamic> && T == Map<String, dynamic>) {
        return data as T;
      }
      if (data is String && T == Map<String, dynamic>) {
        final decoded = _decodeStringMap(data);
        if (decoded != null) return decoded as T;
      }
      throw ApiException(
        message: 'Unexpected $description response shape',
        details: data,
      );
    } on DioException catch (error) {
      final message = error.response?.data is Map<String, dynamic>
          ? (error.response?.data['message'] as String?) ??
              error.response?.data['error'] as String? ??
              error.message ??
              'Unable to complete $description'
          : error.message ?? 'Unable to complete $description';
      throw ApiException(
        message: message,
        statusCode: error.response?.statusCode,
        details: error.response?.data,
      );
    }
  }

  Map<String, dynamic>? _decodeStringMap(String raw) {
    var trimmed = raw.trim();
    if (trimmed.startsWith('```')) {
      final firstLineEnd = trimmed.indexOf('\n');
      if (firstLineEnd != -1) {
        trimmed = trimmed.substring(firstLineEnd + 1);
      }
      final closingFence = trimmed.lastIndexOf('```');
      if (closingFence != -1) {
        trimmed = trimmed.substring(0, closingFence);
      }
      trimmed = trimmed.trim();
    }

    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {/* ignore */}

    final start = trimmed.indexOf('{');
    final end = trimmed.lastIndexOf('}');
    if (start != -1 && end != -1 && end > start) {
      final candidate = trimmed.substring(start, end + 1);
      try {
        final decoded = jsonDecode(candidate);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
      } catch (_) {/* ignore */}
    }

    if (trimmed.isNotEmpty) {
      return {'message': trimmed};
    }
    return null;
  }
}
