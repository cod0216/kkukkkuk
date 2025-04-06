import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/entities/pet/pet.dart';
import 'package:kkuk_kkuk/features/pet/model/pet_usecase_providers.dart';
import 'package:kkuk_kkuk/features/qr_scanner/model/hospital_qr_data.dart';
import 'package:kkuk_kkuk/features/pet/model/sharing_state.dart';
import 'package:kkuk_kkuk/features/pet/model/add_hospital_with_sharing_usecase.dart';

final sharingViewModel = StateNotifierProvider<SharingViewModel, SharingState>(
  (ref) => SharingViewModel(ref.read(grantHospitalAccessUseCaseProvider)),
);

class SharingViewModel extends StateNotifier<SharingState> {
  final AddHospitalWithSharingUseCase _grantHospitalAccessUseCase;

  SharingViewModel(this._grantHospitalAccessUseCase)
    : super(SharingState.initial());

  // 권한 부여 시작
  Future<void> startSharing({
    required Pet pet,
    required HospitalQRData hospital,
  }) async {
    try {
      // 기본 만료일 설정 (1일)
      final expiryDate = DateTime.now().add(
        const Duration(days: 1, minutes: 10), // 트랜잭션 시간 고려 위해 10분 추가
      );

      // 처리 중 상태로 변경
      state = SharingState.processing(
        pet: pet,
        hospital: hospital,
        expiryDate: expiryDate,
      );

      // 권한 부여 실행
      final transactionHash = await _grantHospitalAccessUseCase.execute(
        petDid: pet.did ?? '',
        hospitalDid: hospital.did,
        expiryDate: expiryDate,
      );

      // 성공 상태로 변경
      state = SharingState.success(
        pet: pet,
        hospital: hospital,
        transactionHash: transactionHash,
        expiryDate: expiryDate,
      );
    } catch (e) {
      // 에러 상태로 변경
      state = SharingState.error(
        message: e.toString(),
        pet: pet,
        hospital: hospital,
      );
    }
  }

  // 상태 초기화
  void resetState() {
    state = SharingState.initial();
  }

  // 현재 처리 중인지 확인
  bool get isProcessing => state.status == SharingStatus.processing;

  // 현재 에러 상태인지 확인
  bool get hasError => state.status == SharingStatus.error;

  // 현재 성공 상태인지 확인
  bool get isSuccess => state.status == SharingStatus.success;
}
