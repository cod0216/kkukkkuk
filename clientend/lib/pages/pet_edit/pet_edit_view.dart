import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/entities/pet/breed.dart';
import 'package:kkuk_kkuk/entities/pet/pet.dart';
import 'package:kkuk_kkuk/features/pet/usecase/pet_usecase_providers.dart';
import 'package:web3dart/web3dart.dart';

class PetEditView extends ConsumerStatefulWidget {
  final Pet pet;

  const PetEditView({super.key, required this.pet});

  @override
  ConsumerState<PetEditView> createState() => _PetEditViewState();
}

class _PetEditViewState extends ConsumerState<PetEditView> {
  static const String _privateKeyKey = 'eth_private_key';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late String _selectedGender;
  late bool _isNeutered;
  late DateTime? _birthDate;
  late List<Breed> _speciesList = [];
  late List<Breed> _breedList = [];
  late Breed? _selectedSpecies;
  late Breed? _selectedBreed;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pet.name);
    _selectedGender = widget.pet.gender;
    _isNeutered = widget.pet.flagNeutering;
    _birthDate = widget.pet.birth;

    // 종 및 품종 데이터 로드
    _loadSpeciesAndBreeds();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadSpeciesAndBreeds() async {
    setState(() => _isLoading = true);

    try {
      // 종 목록 로드
      final speciesUseCase = ref.read(getSpeciesUseCaseProvider);
      _speciesList = await speciesUseCase.execute();

      // 현재 반려동물의 종 찾기
      _selectedSpecies = _speciesList.firstWhere(
        (species) => species.name == widget.pet.species,
        orElse: () => _speciesList.first,
      );

      // 해당 종의 품종 목록 로드
      if (_selectedSpecies != null) {
        final breedsUseCase = ref.read(getBreedsUseCaseProvider);
        _breedList = await breedsUseCase.execute(_selectedSpecies!.id);

        // 현재 반려동물의 품종 찾기
        _selectedBreed = _breedList.firstWhere(
          (breed) => breed.name == widget.pet.breedName,
          orElse: () => _breedList.first,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('데이터 로드 실패: ${e.toString()}')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  Future<void> _updatePet() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 개인 키 가져오기
      final privateKeyHex = await _secureStorage.read(key: _privateKeyKey);
      if (privateKeyHex == null || privateKeyHex.isEmpty) {
        throw Exception('개인 키를 찾을 수 없습니다. 다시 로그인해주세요.');
      }

      // 자격 증명 생성
      final credentials = EthPrivateKey.fromHex(privateKeyHex);

      // 업데이트할 반려동물 정보 생성
      final updatedPet = widget.pet.copyWith(
        name: _nameController.text,
        gender: _selectedGender,
        species: _selectedSpecies?.name ?? widget.pet.species,
        breedName: _selectedBreed?.name ?? widget.pet.breedName,
        birth: _birthDate,
        flagNeutering: _isNeutered,
      );

      // 반려동물 정보 업데이트
      final updateUseCase = ref.read(updatePetUseCaseProvider);
      final result = await updateUseCase.execute(credentials, updatedPet);

      // 트랜잭션이 블록체인에 기록될 때까지 추가 대기
      await Future.delayed(const Duration(seconds: 5));

      // 성공 메시지 표시 및 이전 화면으로 이동
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${result.name} 정보가 업데이트되었습니다.')));
      context.pop(result); // 업데이트된 반려동물 정보 반환
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('반려동물 정보 업데이트 실패: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 이름 입력
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: '이름',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '이름을 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // 종 선택
                      DropdownButtonFormField<Breed>(
                        decoration: const InputDecoration(
                          labelText: '종',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedSpecies,
                        items:
                            _speciesList.map((species) {
                              return DropdownMenuItem<Breed>(
                                value: species,
                                child: Text(species.name),
                              );
                            }).toList(),
                        onChanged: (Breed? newValue) async {
                          setState(() {
                            _selectedSpecies = newValue;
                            _selectedBreed = null;
                            _breedList = [];
                          });

                          if (newValue != null) {
                            setState(() => _isLoading = true);
                            try {
                              final breedsUseCase = ref.read(
                                getBreedsUseCaseProvider,
                              );
                              _breedList = await breedsUseCase.execute(
                                newValue.id,
                              );
                              if (_breedList.isNotEmpty) {
                                _selectedBreed = _breedList.first;
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('품종 목록 로드 실패: ${e.toString()}'),
                                ),
                              );
                            } finally {
                              setState(() => _isLoading = false);
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // 품종 선택
                      DropdownButtonFormField<Breed>(
                        decoration: const InputDecoration(
                          labelText: '품종',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedBreed,
                        items:
                            _breedList.map((breed) {
                              return DropdownMenuItem<Breed>(
                                value: breed,
                                child: Text(breed.name),
                              );
                            }).toList(),
                        onChanged: (Breed? newValue) {
                          setState(() {
                            _selectedBreed = newValue;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // 생년월일 선택
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: '생년월일',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            _birthDate == null
                                ? '생년월일을 선택해주세요'
                                : '${_birthDate!.year}년 ${_birthDate!.month}월 ${_birthDate!.day}일',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 성별 선택
                      Row(
                        children: [
                          const Text('성별:', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 16),
                          Radio<String>(
                            value: '수컷',
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                          ),
                          const Text('수컷'),
                          const SizedBox(width: 16),
                          Radio<String>(
                            value: '암컷',
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                          ),
                          const Text('암컷'),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 중성화 여부
                      Row(
                        children: [
                          Checkbox(
                            value: _isNeutered,
                            onChanged: (value) {
                              setState(() {
                                _isNeutered = value!;
                              });
                            },
                          ),
                          const Text('중성화 완료'),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // 저장 버튼
                      ElevatedButton(
                        onPressed: _isLoading ? null : _updatePet,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child:
                            _isLoading
                                ? const CircularProgressIndicator()
                                : const Text(
                                  '저장하기',
                                  style: TextStyle(fontSize: 16),
                                ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
