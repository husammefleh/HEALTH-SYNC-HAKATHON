import '../../models/api/health_reading.dart';
import 'api_base_service.dart';
import 'api_exception.dart';

class HealthReadingApiService {
  HealthReadingApiService(this._api);

  final ApiBaseService _api;

  static const String _basePath = '/api/HealthReadings';

  Future<List<HealthReadingDto>> fetchHealthReadings() async {
    final response = await _api.get(_basePath);
    final data = response.data;
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(HealthReadingDto.fromJson)
          .toList();
    }
    if (data is Map<String, dynamic>) {
      return [HealthReadingDto.fromJson(data)];
    }
    return [];
  }

  Future<HealthReadingDto> createHealthReading(HealthReadingCreateDto dto) async {
    final response = await _api.post(_basePath, data: dto.toJson());
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return HealthReadingDto.fromJson(data);
    }
    throw ApiException(
      message: 'Unexpected health reading creation response',
      details: data,
    );
  }

  Future<HealthReadingDto> updateHealthReading(
    int id,
    HealthReadingCreateDto dto,
  ) async {
    final response = await _api.put('$_basePath/$id', data: dto.toJson());
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return HealthReadingDto.fromJson(data);
    }
    throw ApiException(
      message: 'Unexpected health reading update response',
      details: data,
    );
  }

  Future<void> deleteHealthReading(int id) => _api.delete('$_basePath/$id');
}
