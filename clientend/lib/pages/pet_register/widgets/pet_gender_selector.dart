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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('성별', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildGenderButton(
                label: '수컷',
                gender: 'MALE',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildGenderButton(
                label: '암컷',
                gender: 'FEMALE',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderButton({
    required String label,
    required String gender,
  }) {
    final isSelected = selectedGender == gender;
    
    return GestureDetector(
      onTap: () => onGenderChanged(gender),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}