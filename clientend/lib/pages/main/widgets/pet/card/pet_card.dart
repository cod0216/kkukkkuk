import 'package:flutter/material.dart';
import 'package:kkuk_kkuk/entities/pet/pet.dart';
import 'package:kkuk_kkuk/pages/main/widgets/pet/card/pet_card_info.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final Function(Pet) onTap;

  const PetCard({super.key, required this.pet, required this.onTap});

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
          child: SizedBox(
            height: 200,
            width: double.infinity,
            child: Stack(
              children: [
                // Pet image (or placeholder)
                Positioned.fill(child: _buildPetImage()),
                // Pet info at the bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: PetCardInfo(
                    name: pet.name,
                    age: pet.ageString,
                    breed: pet.breedName.isNotEmpty ? pet.breedName : '미등록',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPetImage() {
    // Check if the URL is valid and not empty
    if (pet.imageUrl != null && pet.imageUrl!.isNotEmpty) {
      return Image.network(
        pet.imageUrl!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value:
                  loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('Error loading image for ${pet.name}: $error');
          return _buildPlaceholder();
        },
      );
    } else {
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.pets, size: 64, color: Colors.grey),
      ),
    );
  }
}
