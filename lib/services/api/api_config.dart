import 'package:flutter/foundation.dart';

class ApiConfig {
  const ApiConfig._();

  /// Default base URL for the backend API.
  ///
  /// - Android emulator cannot reach host `localhost`, لذا نستخدم `10.0.2.2`.
  /// - iOS/macOS أو تشغيل مباشر على الكمبيوتر يمكنه استخدام `localhost`.
  /// - في أجهزة حقيقية على الشبكة، غيّر القيمة إلى IP الجهاز الذي يشغّل الخادم.
  static final String baseUrl = _resolveBaseUrl();

  static String _resolveBaseUrl() {
    const override = String.fromEnvironment('API_BASE_URL', defaultValue: '');
    if (override.isNotEmpty) {
      return override;
    }

    if (kIsWeb) {
      // HACKATHON: Align web client with secure local backend endpoint.
      return 'https://localhost:7100';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        // HACKATHON: Use emulator loopback with HTTPS port for backend access.
        return 'https://10.0.2.2:7100';
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        // HACKATHON: Default to secure localhost backend for remaining platforms.
        return 'https://localhost:7100';
    }
  }

  /// Timeout for API requests.
  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);
}
