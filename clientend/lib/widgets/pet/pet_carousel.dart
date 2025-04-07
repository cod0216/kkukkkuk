import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kkuk_kkuk/entities/pet/pet.dart';
import 'package:kkuk_kkuk/widgets/pet/card/pet_card.dart';

class PetCarousel extends StatelessWidget {
  final List<Pet> pets;
  final void Function(Pet pet)? onPetTap;

  const PetCarousel({super.key, required this.pets, this.onPetTap});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: pets.length,
      options: CarouselOptions(
        height: 400,
        viewportFraction: 0.75,
        enlargeCenterPage: true,
        enlargeStrategy: CenterPageEnlargeStrategy.scale,
        enlargeFactor: 0.3,
        enableInfiniteScroll: false,
      ),
      itemBuilder: (context, index, realIndex) {
        final pet = pets[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: PetCard(pet: pet, onTap: onPetTap ?? (_) {}),
        );
      },
    );
  }
}
