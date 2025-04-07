import 'package:flutter/material.dart';

class ScannerOverlay extends CustomPainter {
  final Color borderColor;
  final double scannerSize;

  ScannerOverlay({required this.borderColor, required this.scannerSize});

  @override
  void paint(Canvas canvas, Size size) {
    final double screenWidth = size.width;
    final double screenHeight = size.height;

    // 스캐너를 화면 중앙에 배치
    final double scannerLeft = (screenWidth - scannerSize) / 2;
    final double scannerTop = (screenHeight - scannerSize) / 2;
    final double scannerRight = scannerLeft + scannerSize;
    final double scannerBottom = scannerTop + scannerSize;

    // Background with hole
    final backgroundPaint =
        Paint()
          ..color = Colors.black.withAlpha(128)
          ..style = PaintingStyle.fill;

    final backgroundPath =
        Path()
          ..addRect(Rect.fromLTWH(0, 0, screenWidth, screenHeight))
          ..addRect(
            Rect.fromLTWH(scannerLeft, scannerTop, scannerSize, scannerSize),
          )
          ..fillType = PathFillType.evenOdd;

    canvas.drawPath(backgroundPath, backgroundPaint);

    // Border
    final borderPaint =
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;

    // Draw the border
    canvas.drawRect(
      Rect.fromLTRB(scannerLeft, scannerTop, scannerRight, scannerBottom),
      borderPaint,
    );

    // Draw corner markers
    final cornerLength = scannerSize * 0.1;
    final cornerPaint =
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5;

    // Top left corner
    canvas.drawLine(
      Offset(scannerLeft, scannerTop + cornerLength),
      Offset(scannerLeft, scannerTop),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(scannerLeft, scannerTop),
      Offset(scannerLeft + cornerLength, scannerTop),
      cornerPaint,
    );

    // Top right corner
    canvas.drawLine(
      Offset(scannerRight - cornerLength, scannerTop),
      Offset(scannerRight, scannerTop),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(scannerRight, scannerTop),
      Offset(scannerRight, scannerTop + cornerLength),
      cornerPaint,
    );

    // Bottom left corner
    canvas.drawLine(
      Offset(scannerLeft, scannerBottom - cornerLength),
      Offset(scannerLeft, scannerBottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(scannerLeft, scannerBottom),
      Offset(scannerLeft + cornerLength, scannerBottom),
      cornerPaint,
    );

    // Bottom right corner
    canvas.drawLine(
      Offset(scannerRight - cornerLength, scannerBottom),
      Offset(scannerRight, scannerBottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(scannerRight, scannerBottom),
      Offset(scannerRight, scannerBottom - cornerLength),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
