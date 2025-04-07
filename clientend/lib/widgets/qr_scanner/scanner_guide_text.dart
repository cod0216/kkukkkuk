import 'package:flutter/material.dart';

class ScannerGuideText extends StatelessWidget {
  const ScannerGuideText({
    super.key,
    required this.screenSize,
    required this.scannerSize,
  });

  final Size screenSize;
  final double scannerSize;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: (screenSize.height - scannerSize) / 2 - 60, // 스캐너 위에 텍스트 배치
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.black54,
        child: const Text(
          'QR 코드를 스캔해주세요',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
