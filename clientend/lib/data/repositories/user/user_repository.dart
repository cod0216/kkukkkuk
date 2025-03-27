import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/datasource/api/api_client.dart';
import 'package:kkuk_kkuk/data/dtos/user/user_profile_response.dart';
import 'package:kkuk_kkuk/data/dtos/user/user_withdrawal_response.dart';
import 'package:kkuk_kkuk/domain/repositories/user/user_repository_interface.dart';

class UserRepository implements IUserRepository {
  final ApiClient _apiClient;

  UserRepository(this._apiClient);

  @override
  Future<UserProfileResponse> getUserProfile() async {
    try {
      final response = await _apiClient.get('/api/owners/me');
      return UserProfileResponse.fromJson(response.data);
    } catch (e) {
      print('사용자 프로필 조회 실패: $e');
      rethrow;
    }
  }

  @override
  Future<UserWithdrawalResponse> withdrawUser() async {
    try {
      final response = await _apiClient.delete('/api/owners/me');
      return UserWithdrawalResponse.fromJson(response.data);
    } catch (e) {
      print('회원 탈퇴 실패: $e');
      rethrow;
    }
  }
}

final userRepositoryProvider = Provider<IUserRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserRepository(apiClient);
});
