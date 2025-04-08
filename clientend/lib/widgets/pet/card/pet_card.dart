import 'package:flutter/material.dart';
import 'package:kkuk_kkuk/entities/pet/pet.dart';
import 'package:kkuk_kkuk/widgets/pet/card/pet_card_image.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final Function(Pet) onTap;

  const PetCard({super.key, required this.pet, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(pet),
      child: Container(
        // 카드 컨테이너 스타일
        decoration: BoxDecoration(
          color: Colors.grey.shade200, // 이미지 없을 때 배경색
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. 배경 이미지
              PetCardImage(imageUrl: pet.imageUrl),

              // 2. 전체 텍스트 영역을 덮는 그래디언트 오버레이
              _buildGradientOverlay(), // 이름/나이/품종 모두 덮도록 조정
              // 3. 이름 + 나이 + 품종 텍스트 오버레이
              _buildTextInfoOverlay(), // 하나의 메서드로 통합
            ],
          ),
        ),
      ),
    );
  }

  // 그래디언트 오버레이 위젯 생성 (텍스트 영역 전체 커버하도록 높이 조정)
  Widget _buildGradientOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      // 이름/나이/품종 세 줄을 충분히 덮을 높이
      // 필요시 Text 위젯들의 실제 높이를 계산하여 동적으로 조절할 수도 있음
      height: 100,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.7), // 하단은 더 진하게
              Colors.black.withOpacity(0.0), // 상단은 투명하게
            ],
            stops: const [0.0, 0.9], // 그래디언트 범위 조절 (0.0 ~ 0.9 사이에서 색상 변화)
          ),
        ),
      ),
    );
  }

  // 이름 + 나이 + 품종 텍스트 오버레이 위젯 생성
  Widget _buildTextInfoOverlay() {
    return Positioned(
      bottom: 0, // 카드 하단에 붙임
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(12.0), // 텍스트 주변 여백
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          mainAxisSize: MainAxisSize.min, // 내용물 크기만큼만 차지
          children: [
            // 이름 + 나이 Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                // 이름
                NameText(pet: pet),
                const SizedBox(width: 8),
                // 나이
                AgeText(pet: pet),
              ],
            ),
            // 이름/나이 와 품종 사이 간격
            const SizedBox(height: 4),
            // 품종
            BreedText(pet: pet),
          ],
        ),
      ),
    );
  }
}

class NameText extends StatelessWidget {
  const NameText({super.key, required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return Text(
      pet.name,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class AgeText extends StatelessWidget {
  const AgeText({super.key, required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return Text(
      pet.ageString,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class BreedText extends StatelessWidget {
  const BreedText({super.key, required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return Text(
      pet.breedName.isNotEmpty ? pet.breedName : '품종 미상',
      style: TextStyle(
        // 이미지에서는 흰색 계열로 보이므로 흰색으로 변경
        color: Colors.white.withOpacity(0.9), // 약간 투명도 조절
        fontSize: 12,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
