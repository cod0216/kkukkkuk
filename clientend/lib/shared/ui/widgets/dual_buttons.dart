import 'package:flutter/material.dart';

class DualButtons extends StatelessWidget {
  final VoidCallback onLeft;
  final VoidCallback onRight;
  final bool isLoading;
  final String? leftLabel;
  final String? rightLabel;
  final Color? leftColor;
  final Color? rightColor;
  final Color? leftTextColor;
  final Color? rightTextColor;

  const DualButtons({
    super.key,
    required this.onLeft,
    required this.onRight,
    this.isLoading = false,
    this.leftLabel,
    this.rightLabel,
    this.leftColor,
    this.rightColor,
    this.leftTextColor,
    this.rightTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onLeft,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: leftColor ?? Colors.black),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Text(
              leftLabel ?? '이전',
              style: TextStyle(color: leftTextColor ?? Colors.black),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: isLoading ? null : onRight,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: rightColor ?? Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child:
                isLoading
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : Text(
                      rightLabel ?? '다음',
                      style: TextStyle(color: rightTextColor ?? Colors.white),
                    ),
          ),
        ),
      ],
    );
  }
}
