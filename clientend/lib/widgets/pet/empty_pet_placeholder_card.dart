// 예시: EmptyPetPlaceholderCard 위젯
import 'package:flutter/material.dart';

class EmptyPetPlaceholderCard extends StatelessWidget {
  final VoidCallback onTap;

  const EmptyPetPlaceholderCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 400, // PetCarousel과 유사한 높이 설정
        width:
            MediaQuery.of(context).size.width *
            0.75, // PetCarousel viewportFraction과 유사하게
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets, size: 60, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              '새 반려동물을\n등록해보세요!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
