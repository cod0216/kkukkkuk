import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kkuk_kkuk/models/pet_model.dart';
import 'package:kkuk_kkuk/screens/main/widgets/pet/card/pet_card.dart';

class PetCarousel extends StatelessWidget {
  final List<Pet> pets;

  const PetCarousel({super.key, required this.pets});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: pets.length,
      options: CarouselOptions(
        height: 400,
        viewportFraction: 0.8,
        enlargeCenterPage: true,
        enableInfiniteScroll: pets.length > 1,
        enlargeStrategy: CenterPageEnlargeStrategy.height,
      ),
      itemBuilder: (context, index, realIndex) {
        final pet = pets[index];
        return PetCard(pet: pet);
      },
    );
  }
}
