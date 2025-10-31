import '../../models/api/activity_entry.dart';
import 'api_base_service.dart';
import 'api_exception.dart';

class ActivityApiService {
  ActivityApiService(this._api);

  final ApiBaseService _api;

  static const String _basePath = '/api/ActivityEntries';

  Future<List<ActivityEntryDto>> fetchActivities() async {
    final response = await _api.get(_basePath);
    final data = response.data;
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(ActivityEntryDto.fromJson)
          .toList();
    }
    if (data is Map<String, dynamic>) {
      return [ActivityEntryDto.fromJson(data)];
    }
    return [];
  }

  Future<ActivityEntryDto> createActivity(ActivityEntryCreateDto dto) async {
    final response = await _api.post(_basePath, data: dto.toJson());
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return ActivityEntryDto.fromJson(data);
    }
    throw ApiException(
      message: 'Unexpected activity creation response',
      details: data,
    );
  }

  Future<ActivityEntryDto> updateActivity(int id, ActivityEntryCreateDto dto) async {
    final response = await _api.put('$_basePath/$id', data: dto.toJson());
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return ActivityEntryDto.fromJson(data);
    }
    throw ApiException(
      message: 'Unexpected activity update response',
      details: data,
    );
  }

  Future<void> deleteActivity(int id) => _api.delete('$_basePath/$id');
}
