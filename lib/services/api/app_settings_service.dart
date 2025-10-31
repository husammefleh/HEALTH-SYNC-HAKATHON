import '../../models/api/app_settings.dart';
import 'api_base_service.dart';
import 'api_exception.dart';

class AppSettingsApiService {
  AppSettingsApiService(this._api);

  final ApiBaseService _api;

  static const String _basePath = '/api/AppSettings';

  Future<List<AppSettingsDto>> fetchSettings() async {
    final response = await _api.get(_basePath);
    final data = response.data;
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(AppSettingsDto.fromJson)
          .toList();
    }
    if (data is Map<String, dynamic>) {
      return [AppSettingsDto.fromJson(data)];
    }
    return [];
  }

  Future<AppSettingsDto> createSettings(AppSettingsCreateDto dto) async {
    final response = await _api.post(_basePath, data: dto.toJson());
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return AppSettingsDto.fromJson(data);
    }
    throw ApiException(
      message: 'Unexpected app settings creation response',
      details: data,
    );
  }

  Future<AppSettingsDto> updateSettings(int id, AppSettingsCreateDto dto) async {
    final response = await _api.put('$_basePath/$id', data: dto.toJson());
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return AppSettingsDto.fromJson(data);
    }
    throw ApiException(
      message: 'Unexpected app settings update response',
      details: data,
    );
  }

  Future<void> deleteSettings(int id) => _api.delete('$_basePath/$id');
}
