import 'package:flutter/material.dart';
import 'package:kkuk_kkuk/entities/user/user.dart';
import 'package:kkuk_kkuk/widgets/mypage/my_setting_item.dart'; // 새로 만든 위젯 import

/// 마이페이지 설정 섹션 위젯
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '설정',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ), // 타이틀 스타일
        ),
        const SizedBox(height: 12), // 타이틀과 항목 사이 간격
        // 지갑 변경 버튼
        MySettingItem(
          icon:
              Icons
                  .account_balance_wallet_outlined, // 아이콘 변경 (change_circle 대신 지갑 관련 아이콘)
          label: '지갑 변경',
          onTap: onWalletChange,
          iconColor: Colors.red, // 이미지 참조
        ),

        const SizedBox(height: 8), // 항목 사이 간격
        // 로그아웃 버튼 (로그인 상태일 때만 표시)
        if (user != null)
          MySettingItem(
            icon: Icons.logout, // 이미지 참조 (오른쪽 화살표 모양)
            label: '로그 아웃',
            onTap: onLogout,
            iconColor: Colors.blue, // 이미지 참조
          ),
      ],
    );
  }
}
