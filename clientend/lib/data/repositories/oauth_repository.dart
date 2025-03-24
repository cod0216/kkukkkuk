import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kkuk_kkuk/domain/repositories/oauth_repository_interface.dart';

class OAuthRepository implements IOAuthRepository {
  @override
  Future<User> kakaoLogin() async {
    try {
      final installed = await isKakaoTalkInstalled();
      if (installed) {
        await UserApi.instance.loginWithKakaoTalk();
      } else {
        await UserApi.instance.loginWithKakaoAccount();
      }
      return await UserApi.instance.me();
    } catch (error) {
      throw Exception('Failed to login with Kakao: $error');
    }
  }

  @override
  Future<void> kakaoLogout() async {
    try {
      await UserApi.instance.logout();
    } catch (error) {
      throw Exception('Failed to logout from Kakao: $error');
    }
  }
}

final oAuthRepositoryProvider = Provider<IOAuthRepository>((ref) {
  return OAuthRepository();
});