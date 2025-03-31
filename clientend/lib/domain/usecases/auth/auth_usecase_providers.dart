import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/repositories/auth/auth_repository.dart';
import 'package:kkuk_kkuk/data/repositories/auth/oauth_repository.dart';
import 'package:kkuk_kkuk/domain/usecases/auth/login_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/auth/logout_usecase.dart';

final loginUseCaseProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return LoginWithKakaoUseCase(authRepository);
});

final logoutUseCaseProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final oAuthRepository = ref.watch(oAuthRepositoryProvider);
  return LogoutUseCase(authRepository, oAuthRepository);
});
