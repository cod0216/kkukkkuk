import 'package:flutter/material.dart';

class KakaoLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  // TODO: 실제 카카오 로고 에셋 추가

  const KakaoLoginButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const CircularProgressIndicator();
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFEE500),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble, color: Colors.black87, size: 20),
          SizedBox(width: 8),
          Text(
            '카카오로 시작하기',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
