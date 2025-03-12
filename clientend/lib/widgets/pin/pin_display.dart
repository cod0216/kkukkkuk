import 'package:flutter/material.dart';

class PinDisplay extends StatelessWidget {
  final int pinLength;
  final int maxLength;

  const PinDisplay({
    super.key,
    required this.pinLength,
    this.maxLength = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        maxLength,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < pinLength ? Colors.black : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}