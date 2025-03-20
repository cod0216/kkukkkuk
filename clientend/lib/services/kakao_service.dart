import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoService {
  /// 카카오 SDK를 통한 인증
  Future<User> authenticate() async {
    try {
      final installed = await isKakaoTalkInstalled();
      if (installed) {
        await UserApi.instance.loginWithKakaoTalk();
      } else {
        await UserApi.instance.loginWithKakaoAccount();
      }

      return await UserApi.instance.me();
    } catch (error) {
      print('카카오 인증 실패: $error');
      throw Exception('카카오 인증 실패: $error');
    }
  }

  /// 카카오 로그아웃
  Future<void> logout() async {
    try {
      await UserApi.instance.logout();
    } catch (error) {
      print('카카오 로그아웃 실패: $error');
      throw Exception('카카오 로그아웃 실패: $error');
    }
  }
}

final kakaoServiceProvider = Provider<KakaoService>((ref) {
  return KakaoService();
});
