import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/repositories/oauth_repository.dart';
import 'package:kkuk_kkuk/domain/usecases/auth/kakao_oauth_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/auth/kakao_logout_usecase.dart';

final kakaoOAuthUseCaseProvider = Provider((ref) {
  final repository = ref.watch(oAuthRepositoryProvider);
  return KakaoOAuthUseCase(repository);
});

final kakaoLogoutUseCaseProvider = Provider((ref) {
  final repository = ref.watch(oAuthRepositoryProvider);
  return KakaoLogoutUseCase(repository);
});