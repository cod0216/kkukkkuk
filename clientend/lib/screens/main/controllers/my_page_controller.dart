import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/data/datasource/local/secure_storage.dart';
import 'package:kkuk_kkuk/domain/usecases/auth/auth_usecase_providers.dart';
import 'package:kkuk_kkuk/viewmodels/auth_view_model.dart';
import 'package:kkuk_kkuk/viewmodels/wallet_view_model.dart';

/// 마이페이지 컨트롤러 - 마이페이지의 비즈니스 로직을 처리하는 클래스
class MyPageController {
  final WidgetRef ref;

  MyPageController(this.ref);

  /// 로그아웃 처리 함수
  Future<void> handleLogout(BuildContext context) async {
    try {
      // 로그아웃 유스케이스 호출
      final logoutUseCase = ref.read(logoutUseCaseProvider);
      await logoutUseCase.execute();

      // 로그아웃 후 상태 초기화
      ref.read(authViewModelProvider.notifier).reset();

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('로그아웃 되었습니다.')));
        context.go('/');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('로그아웃 실패: $e')));
      }
    }
  }

  static const String _privateKeyKey = 'eth_private_key';

  /// 지갑 정보 삭제 함수
  Future<void> handleWalletDelete(BuildContext context) async {
    final secureStorage = ref.read(secureStorageProvider);
    await secureStorage.removeValue(_privateKeyKey);

    // Reset wallet view model before navigation
    ref.read(walletViewModelProvider.notifier).reset();

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('지갑 정보가 삭제되었습니다.')));

      // TODO: navigate 수정 필요 push -> go, 로그인->지갑생성 로직 같이 수정
      context.push('/wallet-creation', extra: walletViewModelProvider);
    }
  }
}

/// 마이페이지 컨트롤러 프로바이더
final myPageControllerProvider = Provider.family<MyPageController, WidgetRef>(
  (ref, widgetRef) => MyPageController(widgetRef),
);
