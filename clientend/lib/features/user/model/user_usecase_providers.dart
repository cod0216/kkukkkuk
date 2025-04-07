import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/features/auth/api/repositories/token_repository.dart';
import 'package:kkuk_kkuk/features/user/api/repositories/user_repository.dart';
import 'package:kkuk_kkuk/features/user/model/get_user_profile_usecase.dart';
import 'package:kkuk_kkuk/features/user/model/update_user_usecase.dart';
import 'package:kkuk_kkuk/features/user/model/upload_profile_image_usecase.dart';
import 'package:kkuk_kkuk/features/user/model/withdraw_user_usecase.dart';

final getUserProfileUseCaseProvider = Provider<GetUserProfileUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetUserProfileUseCase(repository);
});

final updateUserUseCaseProvider = Provider<UpdateUserUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UpdateUserUseCase(repository);
});

final uploadProfileImageUseCaseProvider = Provider<UploadProfileImageUseCase>((
  ref,
) {
  final repository = ref.watch(userRepositoryProvider);
  return UploadProfileImageUseCase(repository);
});

final withdrawUserUseCaseProvider = Provider<WithdrawUserUseCase>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  final tokenRepository = ref.watch(tokenRepositoryProvider);
  return WithdrawUserUseCase(userRepository, tokenRepository);
});
