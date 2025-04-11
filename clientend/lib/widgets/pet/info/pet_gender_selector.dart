import 'package:flutter/material.dart';

class PetGenderSelector extends StatelessWidget {
  final String selectedGender;
  final Function(String) onGenderChanged;

  const PetGenderSelector({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    // PrimarySection에서 title을 처리하므로 여기서는 Row만 반환
    return Row(
      children: [
        Expanded(
          child: _buildGenderButton(
            label: '수컷',
            gender: 'MALE',
            context: context, // context 전달
          ),
        ),
        const SizedBox(width: 16), // 버튼 사이 간격
        Expanded(
          child: _buildGenderButton(
            label: '암컷',
            gender: 'FEMALE',
            context: context, // context 전달
          ),
        ),
      ],
    );
  }

  // 버튼 생성 헬퍼 함수 (스타일 수정)
  Widget _buildGenderButton({
    required String label,
    required String gender,
    required BuildContext context, // context 받기
  }) {
    final isSelected = selectedGender == gender;
    final theme = Theme.of(context);

    return OutlinedButton(
      onPressed: () => onGenderChanged(gender),
      style: OutlinedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : Colors.black87, // 텍스트 색상
        backgroundColor:
            isSelected ? theme.primaryColor : Colors.white, // 배경 색상
        padding: const EdgeInsets.symmetric(vertical: 14), // 내부 패딩
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // 둥근 모서리
        ),
        side: BorderSide(
          // 테두리 설정
          color:
              isSelected
                  ? theme.primaryColor
                  : Colors.grey.shade400, // 선택 시 Primary, 아니면 회색
          width: 1.0,
        ),
        textStyle: const TextStyle(
          // 텍스트 스타일
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        elevation: isSelected ? 1 : 0, // 선택 시 약간의 그림자 (선택 사항)
      ),
      child: Text(label),
    );
  }
}
