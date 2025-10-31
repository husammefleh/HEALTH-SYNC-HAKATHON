import '../../models/api/medicine_entry.dart';
import 'api_base_service.dart';
import 'api_exception.dart';

class MedicineApiService {
  MedicineApiService(this._api);

  final ApiBaseService _api;

  static const String _basePath = '/api/MedicineEntries';

  Future<List<MedicineEntryDto>> fetchMedicines() async {
    final response = await _api.get(_basePath);
    final data = response.data;
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(MedicineEntryDto.fromJson)
          .toList();
    }
    if (data is Map<String, dynamic>) {
      return [MedicineEntryDto.fromJson(data)];
    }
    return [];
  }

  Future<MedicineEntryDto> createMedicine(MedicineEntryCreateDto dto) async {
    final response = await _api.post(_basePath, data: dto.toJson());
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return MedicineEntryDto.fromJson(data);
    }
    throw ApiException(
      message: 'Unexpected medicine creation response',
      details: data,
    );
  }

  Future<MedicineEntryDto> updateMedicine(int id, MedicineEntryCreateDto dto) async {
    final response = await _api.put('$_basePath/$id', data: dto.toJson());
    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return MedicineEntryDto.fromJson(responseData);
    }
    throw ApiException(
      message: 'Unexpected medicine update response',
      details: responseData,
    );
  }

  Future<void> deleteMedicine(int id) => _api.delete('$_basePath/$id');
}
