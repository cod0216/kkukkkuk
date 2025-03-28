import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/domain/entities/pet_model.dart';
import 'package:kkuk_kkuk/models/hospital_qr_data.dart';
import 'package:kkuk_kkuk/models/sharing_state.dart';
import 'package:kkuk_kkuk/domain/usecases/pet_medical_record/grant_hospital_access_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/pet_medical_record/pet_medical_record_usecase_providers.dart';

final sharingProvider = StateNotifierProvider<SharingController, SharingState>(
  (ref) => SharingController(ref.read(grantHospitalAccessUseCaseProvider)),
);

class SharingController extends StateNotifier<SharingState> {
  final GrantHospitalAccessUseCase _grantHospitalAccessUseCase;

  SharingController(this._grantHospitalAccessUseCase)
    : super(SharingState.initial());

  // 권한 부여 시작
  Future<void> startSharing({
    required Pet pet,
    required HospitalQRData hospital,
  }) async {
    try {
      // 기본 만료일 설정 (30일)
      final expiryDate = DateTime.now().add(const Duration(days: 30));

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
