import 'package:flutter/material.dart';

/// 상태 표시 위젯
class StatusIndicator extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Color? iconColor;
  final double iconSize;
  final TextStyle? messageStyle;

  const StatusIndicator({
    super.key,
    required this.message,
    this.icon,
    this.iconColor,
    this.iconSize = 50,
    this.messageStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: iconSize,
            color: iconColor ?? Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 16),
        ],
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