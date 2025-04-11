import 'package:flutter/material.dart';

/// 마이페이지 등에서 사용될 공통 섹션 컨테이너 위젯
class PrimarySection extends StatelessWidget {
  final String title;
  final Widget child;
  final TextStyle? titleStyle;
  final double spacing; // 제목과 내용 사이 간격

  const PrimarySection({
    super.key,
    required this.title,
    required this.child,
    this.titleStyle,
    this.spacing = 12.0, // 기본 간격 12
  });

  @override
  Widget build(BuildContext context) {
    // 기본 타이틀 스타일 정의
    final defaultTitleStyle =
        Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 18, // 이미지와 유사하게 18로 조정
        ) ??
        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 제목
        Text(
          title,
          style: titleStyle ?? defaultTitleStyle, // 커스텀 스타일 또는 기본 스타일 적용
        ),
        // 제목과 내용 사이 간격
        SizedBox(height: spacing),
        // 섹션 내용
        child,
      ],
    );
  }
}
