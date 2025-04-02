import 'package:flutter/material.dart';
import 'package:kkuk_kkuk/domain/entities/pet/pet.dart';
import 'package:kkuk_kkuk/screens/main/widgets/pet/card/pet_card_image.dart';
import 'package:kkuk_kkuk/screens/main/widgets/pet/card/pet_card_info.dart';

/// 반려동물 상세 정보 헤더 위젯
class PetProfileHeader extends StatelessWidget {
  final Pet pet;

  const PetProfileHeader({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 반려동물 이미지
          SizedBox(
            width: 120,
            height: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: PetCardImage(imageUrl: pet.imageUrl),
            ),
          ),
          const SizedBox(width: 16),
          // 반려동물 기본 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 이름
                PetCardTitle(text: pet.name),
                const SizedBox(height: 4),
                // ID
                PetCardSubtitle(text: 'ID:${pet.did ?? "미등록"}'),
                const SizedBox(height: 8),
                // 품종
                PetCardSubtitle(
                  text: pet.breedName.isNotEmpty ? pet.breedName : '믹스',
                ),
                const SizedBox(height: 4),
                // 나이
                PetCardSubtitle(text: pet.ageString),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
