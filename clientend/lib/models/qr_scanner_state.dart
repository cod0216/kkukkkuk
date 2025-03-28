import 'package:kkuk_kkuk/models/hospital_qr_data.dart';

enum QRScannerStatus {
  initial, // 초기 상태
  scanning, // 스캔 중
  processing, // QR 코드 처리 중
  success, // 스캔 성공
  error, // 에러 발생
  noPermission, // 카메라 권한 없음
}

class QRScannerState {
  final QRScannerStatus status;
  final HospitalQRData? hospitalData;
  final String? errorMessage;
  final bool isProcessing;

  const QRScannerState({
    this.status = QRScannerStatus.initial,
    this.hospitalData,
    this.errorMessage,
    this.isProcessing = false,
  });

  QRScannerState copyWith({
    QRScannerStatus? status,
    HospitalQRData? hospitalData,
    String? errorMessage,
    bool? isProcessing,
  }) {
    return QRScannerState(
      status: status ?? this.status,
      hospitalData: hospitalData ?? this.hospitalData,
      errorMessage: errorMessage ?? this.errorMessage,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }

  // 초기 상태
  factory QRScannerState.initial() {
    return const QRScannerState(status: QRScannerStatus.initial);
  }

  // 스캔 중 상태
  factory QRScannerState.scanning() {
    return const QRScannerState(status: QRScannerStatus.scanning);
  }

  // 처리 중 상태
  factory QRScannerState.processing() {
    return const QRScannerState(
      status: QRScannerStatus.processing,
      isProcessing: true,
    );
  }

  // 성공 상태
  factory QRScannerState.success(HospitalQRData data) {
    return QRScannerState(status: QRScannerStatus.success, hospitalData: data);
  }

  // 에러 상태
  factory QRScannerState.error(String message) {
    return QRScannerState(status: QRScannerStatus.error, errorMessage: message);
  }

  // 권한 없음 상태
  factory QRScannerState.noPermission() {
    return const QRScannerState(status: QRScannerStatus.noPermission);
  }
}
