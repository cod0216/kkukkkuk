import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

abstract class IOAuthRepository {
  Future<User> kakaoLogin();
  Future<void> kakaoLogout();
}