import 'package:flutter/material.dart';

/// 마이페이지 설정 항목 하나를 나타내는 위젯 (버튼 형태)
class MySettingItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor; // 아이콘 색상을 지정할 수 있도록 추가

  const MySettingItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor, // 기본값은 Theme의 primaryColor 또는 회색 계열
  });

  @override
  Widget build(BuildContext context) {
    final Color defaultIconColor =
        Theme.of(context).iconTheme.color ?? Colors.grey.shade700;

    return Material(
      color: Colors.white, // 배경색 흰색
      borderRadius: BorderRadius.circular(8), // InkWell 효과를 위한 BorderRadius
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8), // 터치 효과 범위
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ), // 내부 패딩 조정
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1.0,
            ), // 이미지와 유사한 얇은 테두리
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: iconColor ?? defaultIconColor, // 지정된 색상 또는 기본 색상 사용
                size: 22, // 아이콘 크기 조정
              ),
              const SizedBox(width: 12), // 아이콘과 텍스트 사이 간격
              Expanded(
                // 텍스트가 영역을 차지하도록 Expanded 추가
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500, // 약간 굵게
                  ),
                ),
              ),
              // 오른쪽에 추가 아이콘이 필요하다면 여기에 추가 (예: >)
              // Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
