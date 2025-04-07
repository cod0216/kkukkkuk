import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/entities/user/user.dart';
import 'package:kkuk_kkuk/pages/main/viewmodel/my_page_view_model.dart';
import 'package:kkuk_kkuk/widgets/mypage/user_profile/user_profile_image_form.dart';

/// 사용자 프로필 카드 위젯 (스타일 통일)
class ProfileCard extends ConsumerWidget {
  final User user;

  const ProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myPageViewModel = ref.read(myPageViewModelProvider(ref));

    // 생년월일 포맷 변경 (YYYY.MM.DD.)
    String formattedBirthDate = '';
    if (user.birthYear.isNotEmpty && user.birthDay.length == 4) {
      formattedBirthDate =
          '${user.birthYear}.${user.birthDay.substring(0, 2)}.${user.birthDay.substring(2)}.';
    } else if (user.birthYear.isNotEmpty) {
      formattedBirthDate = user.birthYear; // 혹시 연도만 있을 경우
    }

    // Card 대신 Container 와 BoxDecoration 사용
    return Container(
      padding: const EdgeInsets.all(16.0), // 내부 패딩
      decoration: BoxDecoration(
        // 스타일 통일
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        // Column 구조는 유지
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center, // 세로 중앙 정렬
            children: [
              // 프로필 이미지 (UserProfileImageForm 사용 유지)
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
                        fontSize: 18, // 폰트 크기 약간 조정
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
          Text(
            '생년월일 : $formattedBirthDate',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ), // 스타일 통일
          ),
        ],
      ),
    );
  }
}
