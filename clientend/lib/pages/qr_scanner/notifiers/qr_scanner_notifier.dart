import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/features/qr_scanner/model/hospital_qr_data.dart';
import 'package:kkuk_kkuk/pages/qr_scanner/states/qr_scanner_state.dart';

class QRScannerNotifier extends StateNotifier<QRScannerState> {
  QRScannerNotifier() : super(QRScannerState.initial());

  // QR 코드 처리 시작
  void startProcessing() {
    state = QRScannerState.processing();
  }

  // 병원 데이터 설정 (스캔 성공)
  void setHospitalData(HospitalQRData data) {
    state = QRScannerState.success(data);
  }

  // 에러 설정
  void setError(String message) {
    state = QRScannerState.error(message);
  }

  // 스캐너 초기화
  void resetScanner() {
    state = QRScannerState.scanning();
  }

  // 상태 초기화
  void resetState() {
    state = QRScannerState.initial();
  }

  // 현재 스캐너가 처리 중인지 확인
  bool get isProcessing => state.isProcessing;

  // 현재 스캐너가 에러 상태인지 확인
  bool get hasError => state.status == QRScannerStatus.error;
}

final qrScannerNotifierProvider =
    StateNotifierProvider<QRScannerNotifier, QRScannerState>(
      (ref) => QRScannerNotifier(),
    );
