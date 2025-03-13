import 'package:flutter/material.dart';

class AuthStatusIndicator extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color? iconColor;
  final double iconSize;
  final TextStyle? messageStyle;

  const AuthStatusIndicator({
    super.key,
    required this.message,
    required this.icon,
    this.iconColor,
    this.iconSize = 50,
    this.messageStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: iconSize,
          color: iconColor ?? Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 16),
        Text(
          message,
          style: messageStyle ?? const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}