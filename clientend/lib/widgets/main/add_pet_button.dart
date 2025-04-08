import 'package:flutter/material.dart';
// import 'package:kkuk_kkuk/widgets/common/add_circle_icon.dart'; // 이 import는 제거합니다.

class AddNewPetInlineButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;

  const AddNewPetInlineButton({
    super.key,
    required this.onTap,
    this.label = '새 동물 등록하기',
  });

  @override
  Widget build(BuildContext context) {
    // 버튼 스타일 정의
    final buttonStyle = OutlinedButton.styleFrom(
      shape: const CircleBorder(), // 모양을 원형으로 지정
      padding: const EdgeInsets.all(
        12,
      ), // 아이콘 주변 여백으로 크기 조절 (기존 size: 50과 유사하게)
      side: BorderSide(
        // 테두리 스타일
        color: Colors.grey.shade500, // 테두리 색상 (약간 진하게)
        width: 1.5, // 테두리 두께
      ),
      foregroundColor: Colors.grey.shade700, // 아이콘 색상
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8), // 전체 위젯 터치 영역
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // OutlinedButton을 사용하여 동그란 '+' 버튼 생성
            OutlinedButton(
              onPressed: onTap,
              style: buttonStyle,
              child: const Icon(
                Icons.add,
                size: 25, // 아이콘 크기
              ),
            ),
            const SizedBox(height: 8), // 버튼과 텍스트 사이 간격
            // '새 동물 등록하기' 텍스트
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
