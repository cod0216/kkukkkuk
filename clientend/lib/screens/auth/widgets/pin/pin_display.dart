import 'package:flutter/material.dart';

class PinDisplay extends StatelessWidget {
  final int pinLength;
  final int maxLength;

  const PinDisplay({
    super.key,
    required this.pinLength,
    required this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        maxLength,
        (index) => Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < pinLength ? Colors.black : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}
