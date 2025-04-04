import 'package:flutter/material.dart';
import 'package:kkuk_kkuk/domain/entities/user.dart';
import 'package:kkuk_kkuk/domain/entities/wallet.dart';

/// 마이페이지 위젯 모음 - UI 컴포넌트만 담당
class MyPageWidgets {
  /// 사용자 프로필 카드 위젯
  static Widget buildProfileCard(User user) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // 프로필 이미지
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[200],
                  backgroundImage:
                      user.profileImage != null
                          ? NetworkImage(user.profileImage!)
                          : null,
                  child:
                      user.profileImage == null
                          ? const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey,
                          )
                          : null,
                ),
                const SizedBox(width: 16),
                // 사용자 기본 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 추가 사용자 정보
            const Divider(),
            const SizedBox(height: 8),
            _buildInfoRow('생년월일', '${user.birthYear}년 ${user.birthDay}'),
            const SizedBox(height: 8),
            _buildInfoRow('성별', user.gender),
          ],
        ),
      ),
    );
  }

  /// 지갑 정보 카드 위젯
  /// 지갑 카드 위젯 생성
  static Widget buildWalletCard(
    List<Wallet> wallets, {
    String? activeWalletAddress,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '내 지갑',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 지갑 목록
            ...wallets.map((wallet) {
              final isActive =
                  activeWalletAddress != null &&
                  wallet.address.toLowerCase() ==
                      activeWalletAddress.toLowerCase();

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            wallet.name,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '${wallet.address.substring(0, 10)}...${wallet.address.substring(wallet.address.length - 8)}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 활성화된 지갑 표시
                    if (isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '활성화됨',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  /// 설정 카드 위젯
  static Widget buildSettingsCard({
    required User? user,
    required Function() onWalletDelete,
    required Function() onLogout,
  }) {
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
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('지갑 변경'),
              onTap: onWalletDelete,
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

  /// 정보 행을 생성하는 헬퍼 메서드
  static Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }
}
