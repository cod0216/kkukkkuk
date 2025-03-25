import 'package:flutter/material.dart';
import 'package:kkuk_kkuk/domain/entities/pet_model.dart';
import 'package:kkuk_kkuk/screens/main/widgets/pet/card/pet_card_image.dart';
import 'package:kkuk_kkuk/screens/main/widgets/pet/card/pet_card_info.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final VoidCallback? onTap;

  const PetCard({super.key, required this.pet, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Pet image
              Expanded(flex: 3, child: PetCardImage(imageUrl: pet.imageUrl)),
              // Pet info
              Expanded(
                flex: 1,
                child: PetCardInfo(
                  name: pet.name,
                  age: pet.age,
                  breed: pet.breedName.isNotEmpty ? pet.breedName : '믹스',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
