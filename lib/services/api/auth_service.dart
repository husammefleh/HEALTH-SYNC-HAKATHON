import 'package:dio/dio.dart';

import '../../models/api/auth_models.dart';
import 'api_base_service.dart';
import 'api_exception.dart';

class AuthService {
  AuthService(this._api);

  final ApiBaseService _api;

  static const String _registerPath = '/api/Auth/register';
  static const String _loginPath = '/api/Auth/login';

  Future<void> register(RegisterRequest request) async {
    await _api.post(
      _registerPath,
      data: request.toJson(),
    );
  }

  Future<AuthTokenResponse> login(LoginRequest request) async {
    try {
      final response = await _api.post(
        _loginPath,
        data: request.toJson(),
      );

      final token = _parseToken(response);
      await _api.setAuthToken(token.token);
      return token;
    } on ApiException {
      rethrow;
    } on DioException catch (error) {
      throw ApiException(
        message: error.message ?? 'Failed to login',
        statusCode: error.response?.statusCode,
        details: error.response?.data,
      );
    }
  }

  Future<void> clearSession() => _api.setAuthToken(null);

  AuthTokenResponse _parseToken(Response<dynamic> response) {
    final data = response.data;
    if (data is String) {
      return AuthTokenResponse(token: data);
    }

    if (data is Map<String, dynamic>) {
      final tokenValue = data['token'] ?? data['accessToken'] ?? data['jwt'];
      if (tokenValue is String && tokenValue.isNotEmpty) {
        DateTime? expiresAt;
        final expiresRaw = data['expiresAt'] ?? data['expires'];
        if (expiresRaw is String) {
          expiresAt = DateTime.tryParse(expiresRaw);
        }
        return AuthTokenResponse(
          token: tokenValue,
          expiresAt: expiresAt,
          userId: (data['userId'] as num?)?.toInt(),
          email: data['email'] as String?,
          username: data['username'] as String?,
        );
      }
    }

    throw ApiException(
      message: 'Unexpected login response format',
      details: data,
    );
  }
}
