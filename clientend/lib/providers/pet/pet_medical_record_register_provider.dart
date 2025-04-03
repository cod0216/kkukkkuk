import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/domain/entities/pet/pet_medical_record.dart';
import 'package:kkuk_kkuk/domain/usecases/pet/add_medical_record_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/pet/pet_usecase_providers.dart';

class MedicalRecordRegisterState {
  final bool isLoading;
  final String? error;
  final String? transactionHash;

  const MedicalRecordRegisterState({
    this.isLoading = false,
    this.error,
    this.transactionHash,
  });

  MedicalRecordRegisterState copyWith({
    bool? isLoading,
    String? error,
    String? transactionHash,
  }) {
    return MedicalRecordRegisterState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      transactionHash: transactionHash ?? this.transactionHash,
    );
  }
}

class MedicalRecordRegisterNotifier
    extends StateNotifier<MedicalRecordRegisterState> {
  final AddMedicalRecordUseCase _addMedicalRecordUseCase;

  MedicalRecordRegisterNotifier(this._addMedicalRecordUseCase)
    : super(const MedicalRecordRegisterState());

  Future<void> registerMedicalRecord(String petDid) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // 더미 데이터 생성
      final dummyRecord = PetMedicalRecord(
        treatmentDate: DateTime.now(),
        diagnosis: '감기 증상',
        veterinarian: '김수의사',
        hospitalName: '행복동물병원',
        hospitalAddress: '',
        examinations: [
          Examination(type: '체온', key: 'temperature', value: '38.5°C'),
        ],
        medications: [Medication(key: '감기약', value: '1일 2회')],
        vaccinations: [],
        memo: '3일간 경과 관찰 필요',
        status: 'NONE',
        flagCertificated: false,
        pictures: [
          "https://s3.ap-northeast-2.amazonaws.com/kkukkkuk/pet/7cb6f0ff-2587-41a2-b43a-e81f7097b5bc.jpg",
        ],
      );

      final txHash = await _addMedicalRecordUseCase.execute(
        petDid: petDid,
        record: dummyRecord,
      );

      state = state.copyWith(isLoading: false, transactionHash: txHash);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final medicalRecordRegisterProvider = StateNotifierProvider<
  MedicalRecordRegisterNotifier,
  MedicalRecordRegisterState
>((ref) {
  final addMedicalRecordUseCase = ref.watch(addMedicalRecordUseCaseProvider);
  return MedicalRecordRegisterNotifier(addMedicalRecordUseCase);
});
