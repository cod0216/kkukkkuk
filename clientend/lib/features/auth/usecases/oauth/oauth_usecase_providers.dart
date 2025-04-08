import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/features/auth/api/repositories/oauth_repository.dart';
import 'package:kkuk_kkuk/features/auth/usecases/oauth/kakao_login_usecase.dart';
import 'package:kkuk_kkuk/features/auth/usecases/oauth/kakao_logout_usecase.dart';

final kakaoLoginUseCaseProvider = Provider((ref) {
  final repository = ref.watch(oAuthRepositoryProvider);
  return KakaoLoginUseCase(repository);
});

final kakaoLogoutUseCaseProvider = Provider((ref) {
  final repository = ref.watch(oAuthRepositoryProvider);
  return KakaoLogoutUseCase(repository);
});
