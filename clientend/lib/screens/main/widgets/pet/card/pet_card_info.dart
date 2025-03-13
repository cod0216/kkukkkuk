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
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PetCardTitle(text: name),
          const SizedBox(height: 4),
          PetCardSubtitle(text: age),
          const SizedBox(height: 2),
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
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
      style: TextStyle(fontSize: 14, color: color ?? Colors.grey.shade700),
    );
  }
}
