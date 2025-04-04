import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/viewmodels/auth_view_model.dart';
import 'package:kkuk_kkuk/screens/main/controllers/my_page_controller.dart';
import 'package:kkuk_kkuk/screens/main/widgets/my_page_widgets.dart';
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

    // 현재 활성화된 지갑 주소 가져오기 (비동기 작업이지만 UI에서는 간단하게 처리)
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
              // 사용자 프로필 섹션 - 위젯 컴포넌트 사용
              MyPageWidgets.buildProfileCard(user),

            const SizedBox(height: 24),

            // 지갑 정보 섹션 - 위젯 컴포넌트 사용
            if (user != null &&
                user.wallets != null &&
                user.wallets!.isNotEmpty)
              FutureBuilder<String?>(
                future: activeWalletAddressFuture,
                builder: (context, snapshot) {
                  final activeWalletAddress = snapshot.data;
                  return MyPageWidgets.buildWalletCard(
                    user.wallets!,
                    activeWalletAddress: activeWalletAddress,
                  );
                },
              ),

            const Spacer(),

            // 설정 섹션 - 위젯 컴포넌트 사용 및 콜백 함수 전달
            MyPageWidgets.buildSettingsCard(
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
      // 로컬 저장소에서 지갑 주소 가져오기
      // 참고: 실제 구현에서는 지갑 주소를 저장하는 키가 다를 수 있음
      final walletAddress = await secureStorage.getValue('eth_address');
      return walletAddress;
    } catch (e) {
      print('활성화된 지갑 주소 조회 실패: $e');
      return null;
    }
  }
}
