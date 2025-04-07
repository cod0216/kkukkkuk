import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/pages/qr_scanner/notifiers/qr_scanner_notifier.dart';
import 'package:kkuk_kkuk/features/qr_scanner/model/hospital_qr_data.dart';
import 'package:kkuk_kkuk/entities/pet/pet.dart';
import 'package:kkuk_kkuk/pages/qr_scanner/views/hospital_qr_result_view.dart';
import 'package:kkuk_kkuk/pages/qr_scanner/views/pet_selection_view.dart';
import 'package:kkuk_kkuk/pages/qr_scanner/views/qr_scanner_view.dart';
import 'package:kkuk_kkuk/pages/qr_scanner/views/sharing_result_view.dart';
import 'package:kkuk_kkuk/widgets/common/app_bar.dart';

final List<RouteBase> qrScannerRoutes = [
  GoRoute(
    path: '/qr-scanner',
    name: 'qr_scanner',
    builder: (context, state) {
      return Scaffold(
        appBar: CustomAppBar(),
        body: Consumer(
          builder: (context, ref, _) {
            final qrScannerNotifierProvier = ref.watch(
              qrScannerNotifierProvider.notifier,
            );

            return QRScannerView(
              onScanSuccess: (hospitalData) {
                qrScannerNotifierProvier.setHospitalData(hospitalData);
                // 스캔 성공 시 바로 펫 선택 화면으로 이동하지 않고 결과 화면으로 이동
                context.push('/qr-scanner/result', extra: hospitalData);
              },
              onScanError: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('유효하지 않은 QR 코드입니다.')),
                );
              },
            );
          },
        ),
      );
    },
  ),

  // 펫 선택 화면 라우트
  GoRoute(
    path: '/qr-scanner/pet-selection',
    name: 'pet_selection',
    builder: (context, state) {
      final hospitalData = state.extra as HospitalQRData;
      return PetSelectionView(hospitalData: hospitalData);
    },
  ),

  // 공유 결과 화면 라우트
  GoRoute(
    path: '/qr-scanner/sharing-result',
    name: 'sharing_result',
    builder: (context, state) {
      final Map<String, dynamic> params = state.extra as Map<String, dynamic>;
      return SharingResultView(
        pet: params['pet'] as Pet,
        hospital: params['hospital'] as HospitalQRData,
      );
    },
  ),

  // 병원 정보 결과 화면 라우트 수정
  GoRoute(
    path: '/qr-scanner/result',
    name: 'qr_result',
    builder: (context, state) {
      final hospitalData = state.extra as HospitalQRData;
      return HospitalQRResultView(hospitalData: hospitalData);
    },
  ),
];
