import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/widgets/qr_scanner/scanner_guide_text.dart';
import 'package:kkuk_kkuk/widgets/qr_scanner/scanner_overlay.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:kkuk_kkuk/features/qr_scanner/model/hospital_qr_data.dart';
import 'package:kkuk_kkuk/pages/qr_scanner/notifiers/qr_scanner_notifier.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(qrScannerNotifierProvider.notifier).resetScanner();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 화면 크기 가져오기
    final screenSize = MediaQuery.of(context).size;
    final scannerSize = screenSize.width * 0.7; // 스캐너 크기를 화면 너비의 70%로 조정

    return Stack(
      children: [
        MobileScanner(
          controller: controller,
          onDetect: (capture) {
            final scannerNotifier = ref.read(
              qrScannerNotifierProvider.notifier,
            );

            // 이미 처리 중이면 무시
            if (scannerNotifier.isProcessing) return;

            final List<Barcode> barcodes = capture.barcodes;
            if (barcodes.isNotEmpty && barcodes[0].rawValue != null) {
              try {
                // 처리 중 상태로 설정
                scannerNotifier.startProcessing();

                final hospitalData = HospitalQRData.fromQRData(
                  barcodes[0].rawValue!,
                );

                // 스캔 일시 중지
                controller.stop();

                // 상태 업데이트 및 성공 콜백 호출
                scannerNotifier.setHospitalData(hospitalData);
                widget.onScanSuccess(hospitalData);
              } catch (e) {
                scannerNotifier.setError(e.toString());
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
        ScannerGuideText(screenSize: screenSize, scannerSize: scannerSize),
      ],
    );
  }
}
