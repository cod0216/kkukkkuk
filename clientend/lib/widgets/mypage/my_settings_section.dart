import 'package:flutter/material.dart';
import 'package:kkuk_kkuk/entities/user/user.dart';
import 'package:kkuk_kkuk/widgets/common/primary_section.dart';
import 'package:kkuk_kkuk/widgets/mypage/my_setting_item.dart';

/// 마이페이지 설정 섹션 위젯 (MyPageSection 사용하도록 리팩토링)
class MySettingsSection extends StatelessWidget {
  final User? user;
  final VoidCallback onWalletChange;
  final VoidCallback onLogout;

  const MySettingsSection({
    super.key,
    required this.user,
    required this.onWalletChange,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    // MyPageSection 위젯을 사용하여 제목과 내용을 감쌉니다.
    return PrimarySection(
      title: '설정', // 섹션 제목 전달
      child: Column(
        // 설정 항목들을 Column으로 묶어 child로 전달
        children: [
          // 지갑 변경 버튼
          MySettingItem(
            icon: Icons.account_balance_wallet_outlined,
            label: '지갑 변경',
            onTap: onWalletChange,
            iconColor: Colors.red,
          ),
          const SizedBox(height: 8), // 항목 사이 간격
          // 로그아웃 버튼 (로그인 상태일 때만 표시)
          if (user != null)
            MySettingItem(
              icon: Icons.logout,
              label: '로그 아웃',
              onTap: onLogout,
              iconColor: Colors.blue,
            ),
        ],
      ),
    );
  }
}
