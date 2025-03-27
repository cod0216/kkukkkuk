import 'package:kkuk_kkuk/data/dtos/user/user_profile_response.dart';

abstract class IUserRepository {
  /// 현재 로그인한 사용자의 프로필 정보를 조회합니다.
  Future<UserProfileResponse> getUserProfile();
}
