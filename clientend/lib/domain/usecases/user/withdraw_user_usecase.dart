import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/repositories/auth/token_repository.dart';
import 'package:kkuk_kkuk/data/repositories/user/user_repository.dart';
import 'package:kkuk_kkuk/domain/repositories/auth/token_repository_interface.dart';
import 'package:kkuk_kkuk/domain/repositories/user/user_repository_interface.dart';

class WithdrawUserUseCase {
  final IUserRepository _userRepository;
  final ITokenRepository _tokenRepository;

  WithdrawUserUseCase(this._userRepository, this._tokenRepository);

  /// 회원 탈퇴를 실행하고 로컬 토큰을 삭제합니다.
  Future<bool> execute() async {
    try {
      // 회원 탈퇴 API 호출
      final response = await _userRepository.withdrawUser();

      // 성공 시 로컬 토큰 삭제
      if (response.status == 'success') {
        await _tokenRepository.clearTokens();
        return true;
      }

      return false;
    } catch (e) {
      print('회원 탈퇴 처리 중 오류 발생: $e');
      rethrow;
    }
  }
}

final withdrawUserUseCaseProvider = Provider<WithdrawUserUseCase>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  final tokenRepository = ref.watch(tokenRepositoryProvider);
  return WithdrawUserUseCase(userRepository, tokenRepository);
});
