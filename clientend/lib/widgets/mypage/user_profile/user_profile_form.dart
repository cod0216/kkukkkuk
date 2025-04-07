import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/entities/user/user.dart';
import 'package:kkuk_kkuk/pages/main/viewmodel/my_page_view_model.dart';
import 'package:kkuk_kkuk/widgets/mypage/user_profile/user_profile_image_form.dart';

/// 사용자 프로필 카드 위젯
class ProfileCard extends ConsumerWidget {
  final User user;

  const ProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myPageViewModel = ref.read(myPageViewModelProvider(ref));

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // 프로필 이미지 (클릭 가능)
                UserProfileImageForm(
                  myPageViewModel: myPageViewModel,
                  user: user,
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
            // const SizedBox(height: 8),
            // _buildInfoRow('성별', user.gender),
          ],
        ),
      ),
    );
  }

  /// 정보 행을 생성하는 헬퍼 메서드
  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }
}
