import 'package:flutter/material.dart';
import 'package:kkuk_kkuk/entities/user/user.dart';

/// 설정 카드 위젯
class SettingsCard extends StatelessWidget {
  final User? user;
  final Function() onWalletChange;
  final Function() onLogout;

  const SettingsCard({
    super.key,
    required this.user,
    required this.onWalletChange,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '설정',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // 지갑 삭제 버튼
            ListTile(
              leading: const Icon(Icons.change_circle, color: Colors.red),
              title: const Text('지갑 변경'),
              onTap: onWalletChange,
            ),
            // 로그아웃 버튼
            if (user != null)
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.blue),
                title: const Text('로그아웃'),
                onTap: onLogout,
              ),
          ],
        ),
      ),
    );
  }
}
