import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/controllers/qr_scanner_controller.dart';
import 'package:kkuk_kkuk/models/hospital_qr_data.dart';
import 'package:kkuk_kkuk/screens/qr_scanner/views/qr_scanner_view.dart';
import 'package:kkuk_kkuk/screens/qr_scanner/views/hospital_qr_result_view.dart';

final List<RouteBase> qrScannerRoutes = [
  GoRoute(
    path: '/qr-scanner',
    name: 'qr_scanner',
    builder: (context, state) {
      return Scaffold(
        appBar: AppBar(title: const Text('QR 스캐너')),
        body: Consumer(
          builder: (context, ref, _) {
            return QRScannerView(
              onScanSuccess: (hospitalData) {
                ref
                    .read(qrScannerProvider.notifier)
                    .handleScanSuccess(hospitalData);
                context.pushNamed('hospital_qr_result', extra: hospitalData);
              },
              onScanError: () {
                ref.read(qrScannerProvider.notifier).handleScanError();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('유효하지 않은 QR 코드입니다')),
                );
              },
            );
          },
        ),
      );
    },
  ),
  GoRoute(
    path: '/hospital-qr-result',
    name: 'hospital_qr_result',
    builder: (context, state) {
      final hospitalData = state.extra as HospitalQRData;
      return HospitalQRResultView(hospitalData: hospitalData);
    },
  ),
];
