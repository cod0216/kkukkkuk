import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kkuk_kkuk/entities/pet/breed.dart';
import 'package:kkuk_kkuk/entities/pet/pet.dart';
import 'package:kkuk_kkuk/features/pet/usecase/get_breeds_usecase.dart';
import 'package:kkuk_kkuk/features/pet/usecase/get_species_usecase.dart';
import 'package:kkuk_kkuk/features/pet/usecase/pet_usecase_providers.dart';
import 'package:kkuk_kkuk/features/pet/usecase/register_pet_usecase.dart';
import 'package:kkuk_kkuk/pages/pet_register/state/pet_register_state.dart';
import 'package:kkuk_kkuk/pages/pet_register/state/pet_register_step.dart';
import 'package:web3dart/web3dart.dart';

/// 반려동물 등록 상태 관리 노티파이어
class PetRegisterNotifier extends StateNotifier<PetRegisterState> {
  static const String _privateKeyKey = 'eth_private_key';

  final FlutterSecureStorage _secureStorage =
      const FlutterSecureStorage(); // TODO: SecureStorageProvider로 변경

  final GetBreedsUseCase _getBreedsUseCase;
  final GetSpeciesUseCase _getSpeciesUseCase;
  final RegisterPetUseCase _registerPetUseCase;

  PetRegisterNotifier(
    this._getBreedsUseCase,
    this._registerPetUseCase,
    this._getSpeciesUseCase,
  ) : super(PetRegisterState());

  // ... (setImageUrl, setBasicInfo, moveToNextStep, moveToPreviousStep, getSpecies, getBreeds, registerPet 메서드는 기존과 동일) ...

  /// 반려동물 기본 정보 설정
  void setImageUrl(String imageUrl) {
    final currentPet = state.pet;
    if (currentPet == null) return;

    final updatedPet = currentPet.copyWith(imageUrl: imageUrl);
    state = state.copyWith(pet: updatedPet);
  }

  void setBasicInfo({
    required String name,
    String? species,
    String? breed,
    DateTime? birth,
    String? gender,
    bool? flagNeutering,
  }) {
    final currentPet =
        state.pet ??
        Pet(
          flagNeutering: false,
          name: '',
          gender: '',
          breedName: '',
          species: '',
        );

    final updatedPet = currentPet.copyWith(
      name: name,
      species: species ?? currentPet.species,
      breedName: breed ?? currentPet.breedName,
      birth: birth,
      gender: gender ?? currentPet.gender,
      flagNeutering: flagNeutering ?? currentPet.flagNeutering,
    );

    state = state.copyWith(pet: updatedPet);
  }

  /// 다음 등록 단계로 이동
  void moveToNextStep() {
    final currentStep = state.currentStep;
    PetRegisterStep nextStep;

    switch (currentStep) {
      case PetRegisterStep.info:
        nextStep = PetRegisterStep.image;
        break;
      case PetRegisterStep.image:
        // 등록 로직은 registerPet에서 처리하고 상태 변경
        return; // registerPet 호출 후 완료 단계로 이동
      case PetRegisterStep.completed:
        return; // 마지막 단계
    }

    state = state.copyWith(currentStep: nextStep);
  }

  /// 이전 등록 단계로 이동
  void moveToPreviousStep() {
    final currentStep = state.currentStep;
    PetRegisterStep previousStep;

    switch (currentStep) {
      case PetRegisterStep.info:
        return; // 첫 단계
      case PetRegisterStep.image:
        previousStep = PetRegisterStep.info;
        break;
      case PetRegisterStep.completed:
        previousStep = PetRegisterStep.image; // 완료 화면에서 이전으로 갈 경우 이미지 단계로
        break;
    }

    state = state.copyWith(
      currentStep: previousStep,
      error: null,
    ); // 에러 상태도 초기화
  }

  /// 동물 종류 목록 조회
  Future<List<Breed>> getSpecies() async {
    try {
      final species = await _getSpeciesUseCase.execute();
      // state = state.copyWith(isLoading: false); // 로딩 상태는 호출부에서 관리하는 것이 좋을 수 있음
      return species;
    } catch (e) {
      // state = state.copyWith(isLoading: false, error: '품종 목록을 불러오는데 실패했습니다: ${e.toString()}');
      print('종 목록 조회 실패: $e');
      rethrow; // 에러를 다시 던져서 호출부에서 처리하도록 함
    }
  }

  /// 품종 목록 조회
  Future<List<Breed>> getBreeds(int speciesId) async {
    // state = state.copyWith(isLoading: true, error: null); // 로딩 상태는 호출부(View)에서 관리

    try {
      final breeds = await _getBreedsUseCase.execute(speciesId);
      // state = state.copyWith(isLoading: false);
      return breeds;
    } catch (e) {
      // state = state.copyWith(isLoading: false, error: '품종 목록을 불러오는데 실패했습니다: ${e.toString()}');
      print('품종 목록 조회 실패: $e');
      rethrow; // 에러를 다시 던져서 호출부에서 처리하도록 함
    }
  }

  /// 반려동물 등록 처리
  Future<void> registerPet() async {
    if (state.pet == null) {
      state = state.copyWith(
        error: '등록할 반려동물 정보가 없습니다.',
        isLoading: false,
      ); // 로딩 중단
      return;
    }

    state = state.copyWith(isLoading: true, error: null); // 로딩 시작

    try {
      final privateKeyHex = await _secureStorage.read(key: _privateKeyKey);
      if (privateKeyHex == null || privateKeyHex.isEmpty) {
        throw Exception('개인 키를 찾을 수 없습니다. 다시 로그인해주세요.');
      }
      final credentials = EthPrivateKey.fromHex(privateKeyHex);

      await _registerPetUseCase.execute(credentials, state.pet!);
      // 등록 성공 시 상태 업데이트
      state = state.copyWith(
        isLoading: false,
        currentStep: PetRegisterStep.completed, // 완료 단계로 이동
        error: null,
        // pet: null, // 완료 화면에서 이름 등을 표시해야 할 수 있으므로 유지
      );
    } catch (e) {
      print('반려동물 등록 실패: $e');
      state = state.copyWith(
        isLoading: false,
        error: '반려동물 등록에 실패했습니다: ${e.toString()}',
        // 실패 시 현재 단계 유지 (예: 이미지 단계에서 실패하면 이미지 단계에 머무름)
        // currentStep: PetRegisterStep.image,
      );
      // 에러를 다시 던져서 View에서 사용자에게 알릴 수 있도록 함
      rethrow;
    }
  }

  /// 등록 상태 초기화 (autoDispose 사용 시 필요 없을 수 있으나, 명시적 초기화 위해 유지)
  void reset() {
    print("PetRegisterNotifier resetting state.");
    state = PetRegisterState(); // 초기 상태로 되돌림
  }
}

final petRegisterNotifierProvider =
    StateNotifierProvider.autoDispose<PetRegisterNotifier, PetRegisterState>((
      ref,
    ) {
      final getBreedsUseCase = ref.watch(getBreedsUseCaseProvider);
      final registerPetUseCase = ref.watch(registerPetUseCaseProvider);
      final getSpeciesUseCase = ref.watch(getSpeciesUseCaseProvider);

      return PetRegisterNotifier(
        getBreedsUseCase,
        registerPetUseCase,
        getSpeciesUseCase,
      );
    });
