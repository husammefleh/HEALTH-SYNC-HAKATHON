import '../../models/api/user_profile.dart';
import 'api_base_service.dart';
import 'api_exception.dart';

class UserProfileApiService {
  UserProfileApiService(this._api);

  final ApiBaseService _api;

  static const String _basePath = '/api/UserProfiles';

  Future<List<UserProfileDto>> fetchProfiles() async {
    final response = await _api.get(_basePath);
    final data = response.data;
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(UserProfileDto.fromJson)
          .toList();
    }
    if (data is Map<String, dynamic>) {
      return [UserProfileDto.fromJson(data)];
    }
    return [];
  }

  Future<UserProfileDto> createProfile(UserProfileCreateDto dto) async {
    final response = await _api.post(_basePath, data: dto.toJson());
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return UserProfileDto.fromJson(data);
    }
    throw ApiException(
      message: 'Unexpected profile creation response',
      details: data,
    );
  }

  Future<UserProfileDto> updateProfile(int id, UserProfileCreateDto dto) async {
    final response = await _api.put('$_basePath/$id', data: dto.toJson());
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return UserProfileDto.fromJson(data);
    }
    throw ApiException(
      message: 'Unexpected profile update response',
      details: data,
    );
  }

  Future<void> deleteProfile(int id) => _api.delete('$_basePath/$id');
}
