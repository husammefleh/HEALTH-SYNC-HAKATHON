import 'package:flutter/foundation.dart';

import 'api_config.dart';

/// Central place for remote service configuration outside of the core REST API.
///
/// Values are read from compile-time environment variables so they can be
/// supplied via `--dart-define` during builds without checking secrets into the
/// repository.
class ExternalApiConfig {
  const ExternalApiConfig._();

  /// Base URL for the AI analysis service.
  static final String aiBaseUrl = _readEnv(
    'AI_API_BASE_URL',
    fallback: ApiConfig.baseUrl,
  );

  /// Base URL for the Hedera writer facade that publishes messages to topics.
  static final String hederaWriterBaseUrl = _readEnv(
    'HEDERA_WRITER_API_BASE_URL',
    fallback: _defaultLocalHttps(port: 7400),
  );

  /// Base URL for the mirror (reader) API that exposes topic messages.
  static final String hederaMirrorBaseUrl = _readEnv(
    'HEDERA_MIRROR_API_BASE_URL',
    fallback: _defaultLocalHttps(port: 7500),
  );

  /// Mirror endpoints (paths appended to [hederaMirrorBaseUrl]).
  static final String mirrorMessagesPathTemplate = _readEnv(
    'HEDERA_MIRROR_MESSAGES_PATH',
    fallback: '/api/get-messages/{topicId}',
  );

  /// Writer endpoint path appended to [hederaWriterBaseUrl].
  static final String hederaAddRecordPath =
      _readEnv('HEDERA_WRITER_ADD_RECORD_PATH', fallback: '/api/add-record');

  /// Topic identifiers for each feature area.
  static final String foodTopicId =
      _readEnv('HEDERA_TOPIC_ID_FOOD', fallback: '');
  static final String sleepTopicId =
      _readEnv('HEDERA_TOPIC_ID_SLEEP', fallback: '');
  static final String activityTopicId =
      _readEnv('HEDERA_TOPIC_ID_ACTIVITY', fallback: '');
  static final String healthTopicId =
      _readEnv('HEDERA_TOPIC_ID_HEALTH', fallback: '');
  static final String medicineTopicId =
      _readEnv('HEDERA_TOPIC_ID_MEDICINE', fallback: '');

  /// Request timeouts for long running operations.
  static const Duration connectTimeout = Duration(seconds: 25);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static String _readEnv(String key, {required String fallback}) {
    final value = _envOverrides[key];
    if (value != null && value.isNotEmpty) return value;
    return fallback;
  }

  static const Map<String, String> _envOverrides = {
    'AI_API_BASE_URL': String.fromEnvironment(
      'AI_API_BASE_URL',
      defaultValue: '',
    ),
    'HEDERA_WRITER_API_BASE_URL': String.fromEnvironment(
      'HEDERA_WRITER_API_BASE_URL',
      defaultValue: '',
    ),
    'HEDERA_MIRROR_API_BASE_URL': String.fromEnvironment(
      'HEDERA_MIRROR_API_BASE_URL',
      defaultValue: '',
    ),
    'HEDERA_MIRROR_MESSAGES_PATH': String.fromEnvironment(
      'HEDERA_MIRROR_MESSAGES_PATH',
      defaultValue: '',
    ),
    'HEDERA_WRITER_ADD_RECORD_PATH': String.fromEnvironment(
      'HEDERA_WRITER_ADD_RECORD_PATH',
      defaultValue: '',
    ),
    'HEDERA_TOPIC_ID_FOOD': String.fromEnvironment(
      'HEDERA_TOPIC_ID_FOOD',
      defaultValue: '',
    ),
    'HEDERA_TOPIC_ID_SLEEP': String.fromEnvironment(
      'HEDERA_TOPIC_ID_SLEEP',
      defaultValue: '',
    ),
    'HEDERA_TOPIC_ID_ACTIVITY': String.fromEnvironment(
      'HEDERA_TOPIC_ID_ACTIVITY',
      defaultValue: '',
    ),
    'HEDERA_TOPIC_ID_HEALTH': String.fromEnvironment(
      'HEDERA_TOPIC_ID_HEALTH',
      defaultValue: '',
    ),
    'HEDERA_TOPIC_ID_MEDICINE': String.fromEnvironment(
      'HEDERA_TOPIC_ID_MEDICINE',
      defaultValue: '',
    ),
  };

  static String _defaultLocalHttps({required int port}) {
    if (kIsWeb) {
      return 'http://localhost:$port';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:$port';
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return 'https://localhost:$port';
    }
  }
}
