import 'dart:io';
import 'package:flutter/material.dart';

class CustomImagePlaceholder extends StatelessWidget {
  final bool hasImage;
  final File? imageFile;

  const CustomImagePlaceholder({
    super.key,
    required this.hasImage,
    this.imageFile,
  });

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
          imageFile != null
              ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  imageFile!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              )
              : hasImage
              ? const Center(
                child: Icon(Icons.check_circle, size: 64, color: Colors.green),
              )
              : const Center(
                child: Icon(Icons.pets, size: 64, color: Colors.grey),
              ),
    );
  }
}
