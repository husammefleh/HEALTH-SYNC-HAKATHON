import '../../models/api/sleep_entry.dart';
import 'api_base_service.dart';
import 'api_exception.dart';

class SleepApiService {
  SleepApiService(this._api);

  final ApiBaseService _api;

  static const String _basePath = '/api/SleepEntries';

  Future<List<SleepEntryDto>> fetchSleepEntries() async {
    final response = await _api.get(_basePath);
    final data = response.data;
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(SleepEntryDto.fromJson)
          .toList();
    }
    if (data is Map<String, dynamic>) {
      return [SleepEntryDto.fromJson(data)];
    }
    return [];
  }

  Future<SleepEntryDto> createSleepEntry(SleepEntryCreateDto dto) async {
    final response = await _api.post(_basePath, data: dto.toJson());
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return SleepEntryDto.fromJson(data);
    }
    throw ApiException(
      message: 'Unexpected sleep creation response',
      details: data,
    );
  }

  Future<SleepEntryDto> updateSleepEntry(int id, SleepEntryCreateDto dto) async {
    final response = await _api.put('$_basePath/$id', data: dto.toJson());
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return SleepEntryDto.fromJson(data);
    }
    throw ApiException(
      message: 'Unexpected sleep update response',
      details: data,
    );
  }

  Future<void> deleteSleepEntry(int id) => _api.delete('$_basePath/$id');
}
