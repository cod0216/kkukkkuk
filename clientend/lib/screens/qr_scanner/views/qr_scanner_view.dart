import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:kkuk_kkuk/models/hospital_qr_data.dart';

class QRScannerView extends StatefulWidget {
  final Function(HospitalQRData) onScanSuccess;
  final VoidCallback? onScanError;

  const QRScannerView({
    super.key,
    required this.onScanSuccess,
    this.onScanError,
  });

  @override
  State<QRScannerView> createState() => _QRScannerViewState();
}

class _QRScannerViewState extends State<QRScannerView> {
  final MobileScannerController controller = MobileScannerController();
  bool hasPermission = false;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      hasPermission = status.isGranted;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!hasPermission) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('카메라 권한이 필요합니다'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _requestCameraPermission,
              child: const Text('권한 요청'),
            ),
          ],
        ),
      );
    }

    // 화면 크기 가져오기
    final screenSize = MediaQuery.of(context).size;
    final scannerSize = screenSize.width * 0.7; // 스캐너 크기를 화면 너비의 70%로 조정

    return Stack(
      children: [
        MobileScanner(
          controller: controller,
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            if (barcodes.isNotEmpty && barcodes[0].rawValue != null) {
              try {
                final hospitalData = HospitalQRData.fromQRData(
                  barcodes[0].rawValue!,
                );
                widget.onScanSuccess(hospitalData);
              } catch (e) {
                widget.onScanError?.call();
              }
            }
          },
        ),
        // 스캐너 오버레이 위치 조정
        CustomPaint(
          size: Size(screenSize.width, screenSize.height),
          painter: ScannerOverlay(
            borderColor: Theme.of(context).primaryColor,
            scannerSize: scannerSize,
          ),
        ),
        Positioned(
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
        ),
      ],
    );
  }
}

// Custom painter for scanner overlay
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
          ..color = Colors.black.withOpacity(0.5)
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
