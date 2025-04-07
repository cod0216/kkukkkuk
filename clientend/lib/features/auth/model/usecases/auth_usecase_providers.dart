import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/features/auth/api/repositories/auth_repository.dart';
import 'package:kkuk_kkuk/features/auth/api/repositories/oauth_repository.dart';
import 'package:kkuk_kkuk/features/auth/model/usecases/login_usecase.dart';
import 'package:kkuk_kkuk/features/auth/model/usecases/logout_usecase.dart';

final loginUseCaseProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return LoginWithKakaoUseCase(authRepository);
});

final logoutUseCaseProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final oAuthRepository = ref.watch(oAuthRepositoryProvider);
  return LogoutUseCase(authRepository, oAuthRepository);
});
