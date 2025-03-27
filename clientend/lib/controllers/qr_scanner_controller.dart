import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/models/hospital_qr_data.dart';

final qrScannerProvider =
    StateNotifierProvider<QRScannerController, AsyncValue<HospitalQRData?>>(
      (ref) => QRScannerController(),
    );

class QRScannerController extends StateNotifier<AsyncValue<HospitalQRData?>> {
  QRScannerController() : super(const AsyncValue.data(null));

  void setHospitalData(HospitalQRData data) {
    state = AsyncValue.data(data);
  }

  void resetState() {
    state = const AsyncValue.data(null);
  }

  void setError(String message) {
    state = AsyncValue.error(message, StackTrace.current);
  }
}
