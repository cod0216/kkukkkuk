import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class OAuthService {
  /// 카카오 SDK를 통한 인증
  Future<User> kakaoOAuth() async {
    try {
      final installed = await isKakaoTalkInstalled();
      if (installed) {
        await UserApi.instance.loginWithKakaoTalk();
      } else {
        await UserApi.instance.loginWithKakaoAccount();
      }

      return await UserApi.instance.me();
    } catch (error) {
      print('kakaoOAuth Error: $error');
      rethrow;
    }
  }

  /// 카카오 로그아웃
  Future<void> kakaoLogout() async {
    try {
      await UserApi.instance.logout();
    } catch (error) {
      print('kakaoLogout: $error');
      rethrow;
    }
  }
}

final kakaoServiceProvider = Provider<OAuthService>((ref) {
  return OAuthService();
});
