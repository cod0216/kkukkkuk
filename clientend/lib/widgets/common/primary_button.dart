import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isFullWidth;
  final Color? backgroundColor; // 배경색 설정 가능
  final Color? textColor; // 텍스트색 설정 가능
  final Widget? leadingIcon; // 아이콘 추가 가능하도록 수정
  final double iconSpacing; // 아이콘과 텍스트 사이 간격

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isFullWidth = true,
    this.backgroundColor, // 기본값은 null (테마 따름)
    this.textColor = Colors.white, // 기본 텍스트 색상은 흰색
    this.leadingIcon,
    this.iconSpacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    // 배경색이 지정되지 않으면 테마의 primary color 사용
    final bgColor = backgroundColor ?? Theme.of(context).primaryColor;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor, // foregroundColor로 아이콘/텍스트 색상 한번에 제어
        minimumSize: Size(isFullWidth ? double.infinity : 0, 50), // 높이 고정
        padding: const EdgeInsets.symmetric(
          vertical: 14.0,
          horizontal: 16.0,
        ), // 패딩 조정
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2, // 약간의 그림자
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // 아이콘 없을 때 텍스트만 중앙 정렬
        mainAxisAlignment: MainAxisAlignment.center, // 기본 가운데 정렬
        children: [
          if (leadingIcon != null) ...[
            // 아이콘이 있으면 표시
            leadingIcon!,
            SizedBox(width: iconSpacing), // 아이콘과 텍스트 간격
          ],
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ), // 텍스트 스타일
          ),
        ],
      ),
    );
  }
}
