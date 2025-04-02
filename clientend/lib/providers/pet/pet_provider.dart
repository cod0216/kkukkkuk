import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kkuk_kkuk/domain/entities/pet/pet.dart';
import 'package:kkuk_kkuk/domain/usecases/pet/get_pet_list_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/pet/register_pet_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/pet/pet_usecase_providers.dart';
import 'package:web3dart/web3dart.dart';

/// 반려동물 상태 관리 클래스
class PetState {
  final List<Pet> pets;
  final bool isLoading;
  final String? error;
  final Pet? currentPet;

  PetState({
    this.pets = const [],
    this.isLoading = false,
    this.error,
    this.currentPet,
  });

  PetState copyWith({
    List<Pet>? pets,
    bool? isLoading,
    String? error,
    Pet? currentPet,
  }) {
    return PetState(
      pets: pets ?? this.pets,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPet: currentPet ?? this.currentPet,
    );
  }
}

/// 반려동물 상태 관리 노티파이어
class PetNotifier extends StateNotifier<PetState> {
  static const String _privateKeyKey = 'eth_private_key';
  static const String _addressKey = 'eth_address';

  final FlutterSecureStorage _secureStorage =
      const FlutterSecureStorage(); // TODO: SecureStorageProvider로 변경
  final GetPetListUseCase _getPetListUseCase;
  final RegisterPetUseCase _registerPetUseCase;

  PetNotifier(this._getPetListUseCase, this._registerPetUseCase)
    : super(PetState());

  /// 반려동물 목록 조회
  Future<void> getPetList() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final pets = await _getPetListUseCase.execute(
        (await _secureStorage.read(key: _addressKey)) ?? '',
      );
      state = state.copyWith(pets: pets, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '반려동물 목록을 불러오는데 실패했습니다: ${e.toString()}',
      );
    }
  }

  /// 반려동물 등록
  Future<void> registerPet() async {
    if (state.currentPet == null) {
      state = state.copyWith(error: '등록할 반려동물 정보가 없습니다.');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final registeredPet = await _registerPetUseCase.execute(
        EthPrivateKey.fromHex(
          (await _secureStorage.read(key: _privateKeyKey)) ?? '',
        ),
        state.currentPet!,
      );

      final updatedPets = [...state.pets, registeredPet];
      state = state.copyWith(
        pets: updatedPets,
        isLoading: false,
        currentPet: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '반려동물 등록에 실패했습니다: ${e.toString()}',
      );
    }
  }

  /// 현재 반려동물 정보 설정
  void setCurrentPet({
    required String name,
    String? species,
    String? breed,
    int? age,
    String? gender,
    bool? flagNeutering,
  }) {
    final currentPet =
        state.currentPet ??
        Pet(
          name: '',
          gender: '',
          breedName: '',
          species: '',
          flagNeutering: true,
        );

    final updatedPet = currentPet.copyWith(
      name: name,
      species: species ?? currentPet.species,
      breedName: breed ?? currentPet.breedName,
      age: age,
      gender: gender ?? currentPet.gender,
      flagNeutering: flagNeutering ?? currentPet.flagNeutering,
    );

    state = state.copyWith(currentPet: updatedPet);
  }
}

/// 반려동물 프로바이더
final petProvider = StateNotifierProvider<PetNotifier, PetState>((ref) {
  final getPetListUseCase = ref.watch(getPetListUseCaseProvider);
  final registerPetUseCase = ref.watch(registerPetUseCaseProvider);

  return PetNotifier(getPetListUseCase, registerPetUseCase);
});
