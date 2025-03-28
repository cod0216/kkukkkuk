import 'package:flutter/material.dart';

class AddPetButtonCircle extends StatelessWidget {
  final VoidCallback onTap;
  final double size;
  final double iconSize;
  final double borderWidth;

  const AddPetButtonCircle({
    super.key,
    required this.onTap,
    this.size = 48.0,
    this.iconSize = 24.0,
    this.borderWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: borderWidth,
          ),
        ),
        child: Icon(
          Icons.add,
          color: Colors.black,
          size: iconSize,
        ),
      ),
    );
  }
}