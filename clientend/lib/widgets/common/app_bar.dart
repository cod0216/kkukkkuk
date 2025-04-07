import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; // AppBar 제목 (기본값: KUKK KUKK)
  final List<Widget>? actions; // 오른쪽에 추가될 위젯들 (예: 아이콘 버튼)
  final Color? backgroundColor; // 배경색
  final Color? foregroundColor; // 전경색 (텍스트, 아이콘 색상)

  const CustomAppBar({
    super.key,
    this.title = 'KUKK KUKK',
    this.actions,
    this.backgroundColor, // 기본값은 ThemeData의 AppBar 테마를 따름
    this.foregroundColor, // 기본값은 ThemeData의 AppBar 테마를 따름
  });

  @override
  Widget build(BuildContext context) {
    // 이미지에 있는 앱 로고 스타일 (아이콘 + 텍스트)
    final logoTitle = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // TODO: 실제 앱 로고 아이콘으로 교체 (예: Icon(Icons.pets) 또는 Image.asset(...))
        Icon(
          Icons.pets, // 임시 아이콘
          color:
              foregroundColor ?? Theme.of(context).appBarTheme.foregroundColor,
          size: 24, // 아이콘 크기 조절
        ),
        const SizedBox(width: 8), // 아이콘과 텍스트 사이 간격
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20, // 폰트 크기 조절
            color:
                foregroundColor ??
                Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
      ],
    );

    return AppBar(
      // title을 Row 위젯으로 설정하여 아이콘과 텍스트 함께 표시
      title: logoTitle,
      actions: actions,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: 0, // 그림자 제거 (이미지 디자인과 유사하게)
      centerTitle: false, // 제목을 왼쪽 정렬 (기본값은 플랫폼에 따라 다름)
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // AppBar 기본 높이
}
