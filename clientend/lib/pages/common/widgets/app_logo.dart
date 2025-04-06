import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double fontSize;

  const AppLogo({super.key, this.fontSize = 32});

  @override
  Widget build(BuildContext context) {
    return Text(
      '꾹꾹',
      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
    );
  }
}
