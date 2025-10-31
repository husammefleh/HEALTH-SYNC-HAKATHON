import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../app_storage.dart';
import 'api_config.dart';
import 'api_exception.dart';

typedef UnauthorizedHandler = void Function();

class ApiBaseService {
  ApiBaseService({
    Dio? dio,
    UnauthorizedHandler? onUnauthorized,
  }) : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiConfig.baseUrl,
                connectTimeout: ApiConfig.connectTimeout,
                receiveTimeout: ApiConfig.receiveTimeout,
                headers: const {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ),
        _onUnauthorized = onUnauthorized {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = _token ?? await AppStorage.readString(AppStorage.authTokenKey);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final statusCode = error.response?.statusCode;
          if (statusCode == 401) {
            _token = null;
            await AppStorage.remove(AppStorage.authTokenKey);
            _onUnauthorized?.call();
          }
          handler.next(error);
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          compact: true,
        ),
      );
    }

    if (!kIsWeb) {
      final adapter = _dio.httpClientAdapter;
      if (adapter is IOHttpClientAdapter) {
        adapter.createHttpClient = () {
          final client = HttpClient();
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) =>
                  host == 'localhost' ||
                  host ==
                      '10.0.2.2'; // HACKATHON: Trust loopback certs for secure local dev.
          return client;
        };
      }
    }
  }

  final Dio _dio;
  final UnauthorizedHandler? _onUnauthorized;

  String? _token;

  Future<void> setAuthToken(String? token) async {
    _token = token;
    if (token == null || token.isEmpty) {
      await AppStorage.remove(AppStorage.authTokenKey);
    } else {
      await AppStorage.setString(AppStorage.authTokenKey, token);
    }
  }

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (error) {
      throw _mapException(error);
    }
  }

  Future<Response<dynamic>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (error) {
      throw _mapException(error);
    }
  }

  Future<Response<dynamic>> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (error) {
      throw _mapException(error);
    }
  }

  Future<Response<dynamic>> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (error) {
      throw _mapException(error);
    }
  }

  ApiException _mapException(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode;
    final message = response?.data is Map<String, dynamic>
        ? (response?.data['message'] as String?) ??
            response?.data['error'] as String? ??
            error.message ??
            'Unexpected error occurred'
        : error.message ?? 'Unexpected error occurred';

    return ApiException(
      message: message,
      statusCode: statusCode,
      details: response?.data,
    );
  }
}
