import 'package:flutter/material.dart';

class KakaoStartButton extends StatelessWidget {
  final Animation<double> buttonFadeAnimation;
  final bool showButton;
  final bool isConnected;
  final VoidCallback onPressed;

  const KakaoStartButton({
    super.key,
    required this.buttonFadeAnimation,
    required this.showButton,
    required this.isConnected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: buttonFadeAnimation,
      child: IgnorePointer(
        ignoring: !showButton || !isConnected,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFEE500),
            foregroundColor: Colors.black87,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ).copyWith(
            backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.disabled)) {
                return Colors.grey[300];
              }
              return const Color(0xFFFEE500);
            }),
            foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.disabled)) {
                return Colors.grey[600];
              }
              return Colors.black87;
            }),
          ),
          onPressed: (isConnected && showButton) ? onPressed : null,
          child: const Text(
            '시작하기',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
