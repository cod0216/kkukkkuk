import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double fontSize;
  final bool horizontal;

  const AppLogo({super.key, this.fontSize = 32, this.horizontal = true});

  @override
  Widget build(BuildContext context) {
    final logoText = Text(
      'KUKK\nKUKK',
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF2B3FF0),
        height: 1.1,
      ),
    );

    final pawIcon = Icon(
      Icons.pets,
      color: const Color(0xFF2B3FF0),
      size: fontSize * 1.2,
    );

    return horizontal
        ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [pawIcon, const SizedBox(width: 12), logoText],
        )
        : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [pawIcon, const SizedBox(height: 12), logoText],
        );
  }
}
