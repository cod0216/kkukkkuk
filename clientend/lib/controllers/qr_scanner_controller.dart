import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/models/hospital_qr_data.dart';

final qrScannerProvider =
    StateNotifierProvider<QRScannerController, AsyncValue<HospitalQRData?>>(
      (ref) => QRScannerController(),
    );

class QRScannerController extends StateNotifier<AsyncValue<HospitalQRData?>> {
  QRScannerController() : super(const AsyncValue.data(null));

  void handleScanSuccess(HospitalQRData hospitalData) {
    state = AsyncValue.data(hospitalData);
  }

  void handleScanError() {
    state = const AsyncValue.error('QR 코드 스캔에 실패했습니다', StackTrace.empty);
  }

  void resetState() {
    state = const AsyncValue.data(null);
  }
}
