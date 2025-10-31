import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_exception.dart';
import 'external_api_config.dart';

class HederaMirrorService {
  HederaMirrorService({Dio? dio}) : _dio = dio ?? _buildDio();

  final Dio _dio;

  static Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ExternalApiConfig.hederaMirrorBaseUrl,
        connectTimeout: ExternalApiConfig.connectTimeout,
        receiveTimeout: ExternalApiConfig.receiveTimeout,
        headers: const {
          'Accept': 'application/json',
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          responseHeader: false,
          requestBody: true,
          responseBody: true,
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

  Future<List<HederaTopicMessage>> fetchTopicMessages(
    String topicId, {
    int? limit,
    String? next,
  }) async {
    if (topicId.isEmpty) {
      throw ApiException(message: 'Missing Hedera topic id');
    }

    final path = ExternalApiConfig.mirrorMessagesPathTemplate.replaceAll(
      '{topicId}',
      Uri.encodeComponent(topicId),
    );

    final query = <String, dynamic>{};
    if (limit != null) query['limit'] = limit;
    if (next != null) query['next'] = next;

    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: query.isEmpty ? null : query,
      );
      final data = response.data;

      if (data is Map<String, dynamic>) {
        final messages = data['messages'];
        if (messages is List) {
          return messages
              .whereType<Map<String, dynamic>>()
              .map(HederaTopicMessage.fromJson)
              .toList();
        }
      }

      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(HederaTopicMessage.fromJson)
            .toList();
      }

      throw ApiException(
        message: 'Unexpected mirror response shape',
        details: data,
      );
    } on DioException catch (error) {
      final message = error.response?.data is Map<String, dynamic>
          ? (error.response?.data['message'] as String?) ??
              error.response?.data['error'] as String? ??
              error.message ??
              'Failed to load Hedera messages'
          : error.message ?? 'Failed to load Hedera messages';
      throw ApiException(
        message: message,
        statusCode: error.response?.statusCode,
        details: error.response?.data,
      );
    }
  }
}

class HederaTopicMessage {
  HederaTopicMessage({
    required this.topicId,
    required this.consensusTimestamp,
    this.sequenceNumber,
    this.messageUtf8,
    this.rawPayload,
    this.decodedJson,
  });

  factory HederaTopicMessage.fromJson(Map<String, dynamic> json) {
    final messageObj = json['messageObject'];
    Map<String, dynamic>? decodedJson;
    String? messageUtf8 = json['messageUtf8'] as String?;

    if (messageObj is Map<String, dynamic>) {
      decodedJson = messageObj;
    } else if (messageUtf8 != null && messageUtf8.isNotEmpty) {
      decodedJson = _tryParseJson(messageUtf8);
    } else {
      final messageBase64 = json['message'] as String?;
      if (messageBase64 != null && messageBase64.isNotEmpty) {
        try {
          final decoded = utf8.decode(base64.decode(messageBase64));
          messageUtf8 = decoded;
          decodedJson = _tryParseJson(decoded);
        } catch (_) {
          messageUtf8 = null;
        }
      }
    }

    return HederaTopicMessage(
      topicId: json['topicId'] as String? ?? json['topic_id'] as String? ?? '',
      consensusTimestamp: json['consensusTimestamp'] as String? ??
          json['consensus_timestamp'] as String? ??
          '',
      sequenceNumber: (json['sequenceNumber'] ??
          json['sequence_number'] ??
          json['chunkNumber']) as int?,
      messageUtf8: messageUtf8,
      rawPayload: json,
      decodedJson: decodedJson,
    );
  }

  final String topicId;
  final String consensusTimestamp;
  final int? sequenceNumber;
  final String? messageUtf8;
  final Map<String, dynamic>? rawPayload;
  final Map<String, dynamic>? decodedJson;

  static Map<String, dynamic>? _tryParseJson(String value) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {
      // no-op: treat as plain text
    }
    return null;
  }
}
