import 'dart:io'; // dart:io import 추가
import 'package:flutter/material.dart';
import 'package:kkuk_kkuk/entities/pet/pet.dart';
import 'package:kkuk_kkuk/widgets/pet/card/pet_card_image.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final Function(Pet) onTap;
  final File? imageFile; // 로컬 파일 추가

  const PetCard({
    super.key,
    required this.pet,
    required this.onTap,
    this.imageFile, // 생성자에 추가
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(pet),
      child: Container(
        // 카드 컨테이너 스타일 (기존 유지)
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. 배경 이미지 (imageFile 전달)
              PetCardImage(
                imageUrl: pet.imageUrl,
                imageFile: imageFile, // imageFile 전달
              ),

              // 2. 그래디언트 오버레이 (기존 유지)
              _buildGradientOverlay(),
              // 3. 텍스트 정보 오버레이 (기존 유지)
              _buildTextInfoOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  // _buildGradientOverlay, _buildTextInfoOverlay 및 하위 텍스트 위젯들 (기존 유지)
  Widget _buildGradientOverlay() {
    // ... (기존 코드) ...
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 100,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.black.withOpacity(0.0),
            ],
            stops: const [0.0, 0.9],
          ),
        ),
      ),
    );
  }

  Widget _buildTextInfoOverlay() {
    // ... (기존 코드) ...
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                NameText(pet: pet),
                const SizedBox(width: 8),
                AgeText(pet: pet),
              ],
            ),
            const SizedBox(height: 4),
            BreedText(pet: pet),
          ],
        ),
      ),
    );
  }
}

// NameText, AgeText, BreedText 위젯 (기존 유지)
class NameText extends StatelessWidget {
  const NameText({super.key, required this.pet});
  final Pet pet;
  @override
  Widget build(BuildContext context) {
    // ... (기존 코드) ...
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
    // ... (기존 코드) ...
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
    // ... (기존 코드) ...
    return Text(
      pet.breedName.isNotEmpty ? pet.breedName : '품종 미상',
      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
