import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/repositories/auth_repository.dart';
import 'package:kkuk_kkuk/data/repositories/oauth_repository.dart';
import 'package:kkuk_kkuk/domain/usecases/auth/login_with_kakao_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/auth/logout_usecase.dart';

final loginWithKakaoUseCaseProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final oAuthRepository = ref.watch(oAuthRepositoryProvider);
  return LoginWithKakaoUseCase(authRepository, oAuthRepository);
});

final logoutUseCaseProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final oAuthRepository = ref.watch(oAuthRepositoryProvider);
  return LogoutUseCase(authRepository, oAuthRepository);
});
