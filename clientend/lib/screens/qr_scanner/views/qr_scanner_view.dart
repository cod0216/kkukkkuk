import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:kkuk_kkuk/models/hospital_qr_data.dart';
import 'package:kkuk_kkuk/models/qr_scanner_state.dart';
import 'package:kkuk_kkuk/controllers/qr_scanner_controller.dart';

class QRScannerView extends ConsumerStatefulWidget {
  final Function(HospitalQRData) onScanSuccess;
  final VoidCallback? onScanError;

  const QRScannerView({
    super.key,
    required this.onScanSuccess,
    this.onScanError,
  });

  @override
  ConsumerState<QRScannerView> createState() => _QRScannerViewState();
}

class _QRScannerViewState extends ConsumerState<QRScannerView> {
  final MobileScannerController controller = MobileScannerController();

  @override
  void initState() {
    super.initState();
    // 컨트롤러를 통해 카메라 권한 요청
    ref.read(qrScannerProvider.notifier).requestCameraPermission();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scannerState = ref.watch(qrScannerProvider);

    if (scannerState.status == QRScannerStatus.noPermission) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('카메라 권한이 필요합니다'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(qrScannerProvider.notifier).requestCameraPermission();
              },
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
            final scannerController = ref.read(qrScannerProvider.notifier);

            // 이미 처리 중이면 무시
            if (scannerController.isProcessing) return;

            final List<Barcode> barcodes = capture.barcodes;
            if (barcodes.isNotEmpty && barcodes[0].rawValue != null) {
              try {
                // 처리 중 상태로 설정
                scannerController.startProcessing();

                final hospitalData = HospitalQRData.fromQRData(
                  barcodes[0].rawValue!,
                );

                // 스캔 일시 중지
                controller.stop();

                // 상태 업데이트 및 성공 콜백 호출
                scannerController.setHospitalData(hospitalData);
                widget.onScanSuccess(hospitalData);
              } catch (e) {
                scannerController.setError(e.toString());
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
