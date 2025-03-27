import 'package:flutter/material.dart';
import 'package:kkuk_kkuk/domain/entities/pet_model.dart';
import 'package:kkuk_kkuk/screens/main/widgets/pet/card/pet_card_info.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final Function(Pet) onTap;

  const PetCard({
    super.key,
    required this.pet,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(pet),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          // Fix: Replace Column with SizedBox + Stack to avoid flex layout issues
          child: SizedBox(
            height: 200, // Fixed height for the card
            width: double.infinity,
            child: Stack(
              children: [
                // Pet image (or placeholder)
                Positioned.fill(
                  child: Image.network(
                    pet.imageUrl ?? 'https://via.placeholder.com/150',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(Icons.pets, size: 64, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
                // Pet info at the bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
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
      ),
    );
  }
}
