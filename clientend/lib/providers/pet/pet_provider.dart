import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kkuk_kkuk/domain/entities/pet_model.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/registry/get_pet_list_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/registry/register_pet_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/registry/registry_usecase_providers.dart'
    as registry_usecase_providers;
import 'package:kkuk_kkuk/domain/usecases/pet/update_pet_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/pet/delete_pet_usecase.dart';
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
  final UpdatePetUseCase _updatePetUseCase;
  final DeletePetUseCase _deletePetUseCase;

  PetNotifier(
    this._getPetListUseCase,
    this._registerPetUseCase,
    this._updatePetUseCase,
    this._deletePetUseCase,
  ) : super(PetState());

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

  /// 반려동물 정보 수정
  Future<void> updatePet(Pet pet) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: 반려동물 정보 수정 로직 구현
      Exception('updatePet is Not implemented');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '반려동물 정보 수정에 실패했습니다: ${e.toString()}',
      );
    }
  }

  /// 반려동물 삭제
  Future<void> deletePet(int petId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final success = await _deletePetUseCase.execute(
        EthPrivateKey.fromHex(
          (await _secureStorage.read(key: _privateKeyKey)) ?? '',
        ),
        petId,
      );

      if (success) {
        // 삭제 성공 시 목록에서 해당 반려동물 제거
        final updatedPets = state.pets.where((p) => p.id != petId).toList();
        state = state.copyWith(pets: updatedPets, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false, error: '반려동물 삭제에 실패했습니다.');
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '반려동물 삭제에 실패했습니다: ${e.toString()}',
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
          breedId: '',
          breedName: '',
          age: '',
          species: '',
          flagNeutering: true,
        );

    final updatedPet = currentPet.copyWith(
      name: name,
      species: species,
      breedId: breed,
      breedName: breed,
      age: age != null ? '$age세' : null,
      gender: gender,
      flagNeutering: flagNeutering,
    );

    state = state.copyWith(currentPet: updatedPet);
  }
}

/// 반려동물 프로바이더
final petProvider = StateNotifierProvider<PetNotifier, PetState>((ref) {
  final getPetListUseCase = ref.watch(
    registry_usecase_providers.getPetListUseCaseProvider,
  );
  final registerPetUseCase = ref.watch(
    registry_usecase_providers.registerPetUseCaseProvider,
  );
  final updatePetUseCase = ref.watch(updatePetUseCaseProvider);
  final deletePetUseCase = ref.watch(deletePetUseCaseProvider);

  return PetNotifier(
    getPetListUseCase,
    registerPetUseCase,
    updatePetUseCase,
    deletePetUseCase,
  );
});
