import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/data/dtos/wallet/wallet_detail_response.dart';
import 'package:kkuk_kkuk/domain/entities/wallet.dart';
import 'package:kkuk_kkuk/domain/usecases/auth/auth_usecase_providers.dart';
import 'package:kkuk_kkuk/domain/usecases/wallet/wallet_usecase_providers.dart';
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

  /// 지갑 정보 삭제 함수
  Future<void> handleWalletChange(BuildContext context) async {
    ref.read(walletViewModelProvider.notifier).reset();

    if (context.mounted) {
      context.push('/wallet-creation', extra: walletViewModelProvider);
    }
  }

  /// 지갑 상세 정보 조회 함수
  Future<WalletDetailResponse?> getWalletDetail(int walletId) async {
    try {
      final getWalletDetailUseCase = ref.read(getWalletDetailUseCaseProvider);
      final response = await getWalletDetailUseCase.execute(walletId);
      return response;
    } catch (e) {
      print('지갑 상세 정보 조회 실패: $e');
      return null;
    }
  }

  /// 지갑 소유자 정보를 포함한 지갑 목록 조회
  Future<List<Wallet>> getWalletsWithOwners(List<Wallet> wallets) async {
    final List<Wallet> updatedWallets = [];

    for (final wallet in wallets) {
      try {
        final detailResponse = await getWalletDetail(wallet.id);
        if (detailResponse != null) {
          // DTO에서 엔티티로 변환
          final owners =
              detailResponse.data.owners
                  .map(
                    (ownerDto) => Owner(
                      id: ownerDto.id,
                      name: ownerDto.name,
                      image: ownerDto.image,
                    ),
                  )
                  .toList();

          // 소유자 정보가 포함된 새 지갑 객체 생성
          final updatedWallet = Wallet(
            id: wallet.id,
            address: wallet.address,
            name: wallet.name,
            owners: owners,
          );

          updatedWallets.add(updatedWallet);
        } else {
          updatedWallets.add(wallet);
        }
      } catch (e) {
        print('지갑 $wallet 소유자 정보 조회 실패: $e');
        updatedWallets.add(wallet);
      }
    }

    return updatedWallets;
  }
}

/// 마이페이지 컨트롤러 프로바이더
final myPageControllerProvider = Provider.family<MyPageController, WidgetRef>(
  (ref, widgetRef) => MyPageController(widgetRef),
);
