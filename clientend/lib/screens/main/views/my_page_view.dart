import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/domain/entities/wallet.dart';
import 'package:kkuk_kkuk/viewmodels/auth_view_model.dart';
import 'package:kkuk_kkuk/screens/main/controllers/my_page_controller.dart';
import 'package:kkuk_kkuk/screens/main/widgets/mypage/profile_card.dart';
import 'package:kkuk_kkuk/screens/main/widgets/mypage/wallet_card.dart';
import 'package:kkuk_kkuk/screens/main/widgets/mypage/settings_card.dart';
import 'package:kkuk_kkuk/data/datasource/local/secure_storage.dart';

class MyPageView extends ConsumerWidget {
  const MyPageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 상태 관리
    final authState = ref.watch(authViewModelProvider);
    final user = authState.user;

    // 컨트롤러 초기화
    final controller = ref.watch(myPageControllerProvider(ref));

    // 현재 활성화된 지갑 주소 가져오기
    final activeWalletAddressFuture = _getActiveWalletAddress(ref);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더 섹션
            const Text(
              '마이페이지',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // 사용자 정보가 없는 경우
            if (user == null)
              const Center(child: Text('로그인이 필요합니다.'))
            else
              // 사용자 프로필 섹션
              ProfileCard(user: user),

            const SizedBox(height: 24),

            // 지갑 정보 섹션
            if (user != null &&
                user.wallets != null &&
                user.wallets!.isNotEmpty)
              FutureBuilder<Map<String, dynamic>>(
                future: _getWalletData(ref, user.wallets!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final data =
                      snapshot.data ??
                      {'wallets': user.wallets!, 'activeAddress': null};
                  final wallets = data['wallets'] as List<Wallet>;
                  final activeWalletAddress = data['activeAddress'] as String?;

                  return WalletCard(
                    wallets: wallets,
                    activeWalletAddress: activeWalletAddress,
                  );
                },
              ),

            const Spacer(),

            // 설정 섹션
            SettingsCard(
              user: user,
              onWalletDelete: () => controller.handleWalletDelete(context),
              onLogout: () => controller.handleLogout(context),
            ),
          ],
        ),
      ),
    );
  }

  /// 현재 활성화된 지갑 주소 가져오기
  Future<String?> _getActiveWalletAddress(WidgetRef ref) async {
    try {
      final secureStorage = ref.read(secureStorageProvider);
      final walletAddress = await secureStorage.getValue('eth_address');
      return walletAddress;
    } catch (e) {
      print('활성화된 지갑 주소 조회 실패: $e');
      return null;
    }
  }

  /// 지갑 데이터와 활성화된 지갑 주소를 함께 가져오기
  Future<Map<String, dynamic>> _getWalletData(
    WidgetRef ref,
    List<Wallet> wallets,
  ) async {
    final controller = ref.read(myPageControllerProvider(ref));

    // 병렬로 데이터 가져오기
    final activeAddressFuture = _getActiveWalletAddress(ref);
    final walletsWithOwnersFuture = controller.getWalletsWithOwners(wallets);

    // 두 Future 모두 완료될 때까지 기다림
    final results = await Future.wait([
      activeAddressFuture,
      walletsWithOwnersFuture,
    ]);

    return {
      'activeAddress': results[0] as String?,
      'wallets': results[1] as List<Wallet>,
    };
  }
}
