import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_exception.dart';
import 'external_api_config.dart';

class HederaWriterService {
  HederaWriterService({Dio? dio}) : _dio = dio ?? _buildDio();

  final Dio _dio;

  static Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ExternalApiConfig.hederaWriterBaseUrl,
        connectTimeout: ExternalApiConfig.connectTimeout,
        receiveTimeout: ExternalApiConfig.receiveTimeout,
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
              (X509Certificate cert, String host, int port) => host == 'localhost';
          return client;
        };
      }
    }

    return dio;
  }

  Future<HederaSubmissionResult> addRecord({
    required String topicId,
    required Map<String, dynamic> message,
  }) async {
    final payload = {
      'topicId': topicId,
      'message': message,
    };

    try {
      final response = await _dio.post<dynamic>(
        ExternalApiConfig.hederaAddRecordPath,
        data: payload,
      );

      if (response.data is Map<String, dynamic>) {
        return HederaSubmissionResult.fromJson(
          response.data as Map<String, dynamic>,
        );
      }

      if (response.data is String) {
        final decoded = jsonDecode(response.data as String);
        if (decoded is Map<String, dynamic>) {
          return HederaSubmissionResult.fromJson(decoded);
        }
      }

      throw ApiException(
        message: 'Unexpected add-record response shape',
        details: response.data,
      );
    } on DioException catch (error) {
      final message = error.response?.data is Map<String, dynamic>
          ? (error.response?.data['message'] as String?) ??
              error.response?.data['error'] as String? ??
              error.message ??
              'Failed to publish Hedera message'
          : error.message ?? 'Failed to publish Hedera message';
      throw ApiException(
        message: message,
        statusCode: error.response?.statusCode,
        details: error.response?.data,
      );
    }
  }
}

class HederaSubmissionResult {
  HederaSubmissionResult({
    required this.topicId,
    required this.transactionId,
    this.consensusTimestamp,
    this.sequenceNumber,
    this.raw,
  });

  factory HederaSubmissionResult.fromJson(Map<String, dynamic> json) {
    return HederaSubmissionResult(
      topicId: json['topicId'] as String? ?? '',
      transactionId: json['transactionId'] as String? ??
          json['transactionID'] as String? ??
          json['txId'] as String? ??
          '',
      consensusTimestamp: json['consensusTimestamp'] as String?,
      sequenceNumber: json['sequenceNumber'] as int?,
      raw: json,
    );
  }

  final String topicId;
  final String transactionId;
  final String? consensusTimestamp;
  final int? sequenceNumber;
  final Map<String, dynamic>? raw;

  bool get hasConsensus => consensusTimestamp != null && consensusTimestamp!.isNotEmpty;
}
