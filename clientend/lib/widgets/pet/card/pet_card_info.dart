import 'package:flutter/material.dart';

class PetCardInfo extends StatelessWidget {
  final String name;
  final String age;
  final String breed;

  const PetCardInfo({
    super.key,
    required this.name,
    required this.age,
    required this.breed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      height: 75,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          PetCardTitle(text: name),
          const SizedBox(height: 2),
          PetCardSubtitle(text: age),
          const SizedBox(height: 1),
          PetCardSubtitle(text: breed, color: Colors.grey.shade600),
        ],
      ),
    );
  }
}

class PetCardTitle extends StatelessWidget {
  final String text;

  const PetCardTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class PetCardSubtitle extends StatelessWidget {
  final String text;
  final Color? color;

  const PetCardSubtitle({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 12, color: color ?? Colors.grey.shade700),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
