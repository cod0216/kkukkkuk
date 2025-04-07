import 'package:flutter/material.dart';

class SkipButton extends StatelessWidget {
  final VoidCallback onSkip;

  const SkipButton({super.key, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onSkip,
      child: const Center(
        child: Text(
          '건너뛰기',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
