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

  /// 반려동물 기본 정보 설정
  /// 이미지 URL 설정
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
        nextStep = PetRegisterStep.completed;
        break;
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
        previousStep = PetRegisterStep.image;
        break;
    }

    state = state.copyWith(currentStep: previousStep);
  }

  /// 동물 종류 목록 조회
  Future<List<Breed>> getSpecies() async {
    try {
      final species = await _getSpeciesUseCase.execute();
      state = state.copyWith(isLoading: false);
      return species;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '품종 목록을 불러오는데 실패했습니다: ${e.toString()}',
      );
      return [];
    }
  }

  /// 품종 목록 조회
  Future<List<Breed>> getBreeds(int speciesId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final breeds = await _getBreedsUseCase.execute(speciesId);
      state = state.copyWith(isLoading: false);
      return breeds;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '품종 목록을 불러오는데 실패했습니다: ${e.toString()}',
      );
      return [];
    }
  }

  /// 반려동물 등록 처리
  Future<void> registerPet() async {
    if (state.pet == null) {
      state = state.copyWith(error: '등록할 반려동물 정보가 없습니다.');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      await _registerPetUseCase.execute(
        EthPrivateKey.fromHex(
          (await _secureStorage.read(key: _privateKeyKey)) ?? '',
        ),
        state.pet!,
      );
      state = state.copyWith(
        isLoading: false,
        currentStep: PetRegisterStep.completed,
        // pet: null, // 완료 화면에서 이름을 표시하기 위해 유지
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '반려동물 등록에 실패했습니다: ${e.toString()}',
      );
    }
  }

  /// 등록 상태 초기화
  void reset() {
    state = PetRegisterState();
  }
}

/// 반려동물 등록 프로바이더
final petRegisterNotifierProvider =
    StateNotifierProvider<PetRegisterNotifier, PetRegisterState>((ref) {
      final getBreedsUseCase = ref.watch(getBreedsUseCaseProvider);
      final registerPetUseCase = ref.watch(registerPetUseCaseProvider);
      final getSpeciesUseCase = ref.watch(getSpeciesUseCaseProvider);

      return PetRegisterNotifier(
        getBreedsUseCase,
        registerPetUseCase,
        getSpeciesUseCase,
      );
    });
