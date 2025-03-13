import 'package:flutter/material.dart';

class CustomImagePlaceholder extends StatelessWidget {
  final bool hasImage;

  const CustomImagePlaceholder({super.key, required this.hasImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child:
          hasImage
              ? const Center(
                child: Icon(Icons.check_circle, size: 64, color: Colors.green),
              )
              : const Center(
                child: Icon(Icons.pets, size: 64, color: Colors.grey),
              ),
    );
  }
}
