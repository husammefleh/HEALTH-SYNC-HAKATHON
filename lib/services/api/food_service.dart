import '../../models/api/food_entry.dart';
import 'api_base_service.dart';
import 'api_exception.dart';

class FoodApiService {
  FoodApiService(this._api);

  final ApiBaseService _api;

  static const String _basePath = '/api/FoodEntries';

  Future<List<FoodEntryDto>> fetchFoods() async {
    final response = await _api.get(_basePath);
    final data = response.data;
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(FoodEntryDto.fromJson)
          .toList();
    }
    if (data is Map<String, dynamic>) {
      return [FoodEntryDto.fromJson(data)];
    }
    return [];
  }

  Future<FoodEntryDto> createFood(FoodEntryCreateDto dto) async {
    final response = await _api.post(_basePath, data: dto.toJson());
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return FoodEntryDto.fromJson(data);
    }
    throw ApiException(
      message: 'Unexpected food creation response',
      details: data,
    );
  }

  Future<FoodEntryDto> updateFood(int id, FoodEntryCreateDto dto) async {
    final response = await _api.put('$_basePath/$id', data: dto.toJson());
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return FoodEntryDto.fromJson(data);
    }
    throw ApiException(
      message: 'Unexpected food update response',
      details: data,
    );
  }

  Future<void> deleteFood(int id) => _api.delete('$_basePath/$id');
}
