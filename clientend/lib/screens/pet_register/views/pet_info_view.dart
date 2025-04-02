import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/controllers/pet_register_controller.dart';
import 'package:kkuk_kkuk/domain/entities/pet/breed.dart';
import 'package:kkuk_kkuk/providers/pet/pet_register_provider.dart';
import 'package:kkuk_kkuk/screens/common/widgets/custom_dropdown_field.dart';
import 'package:kkuk_kkuk/screens/pet_register/widgets/pet_gender_selector.dart';
import 'package:kkuk_kkuk/screens/common/widgets/custom_text_field.dart';
import 'package:kkuk_kkuk/screens/common/widgets/dual_buttons.dart';
import 'package:kkuk_kkuk/screens/common/widgets/custom_header.dart';

// 반려동물 기본 정보 입력 화면
class PetInfoView extends ConsumerStatefulWidget {
  final PetRegisterController controller;

  const PetInfoView({super.key, required this.controller});

  @override
  ConsumerState<PetInfoView> createState() => _PetInfoViewState();
}

class _PetInfoViewState extends ConsumerState<PetInfoView> {
  // 폼 및 입력 컨트롤러
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime? _selectedBirthDate;

  // 선택된 값들 상태 관리
  String? _selectedSpecies;
  String? _selectedBreed;
  String _selectedGender = 'MALE'; // 기본값 수컷

  // 동물 종류 및 품종 목록
  List<Breed> _speciesList = [];
  List<Breed> _breedsList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSpecies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // 동물 종류 목록 로드
  Future<void> _loadSpecies() async {
    setState(() => _isLoading = true);
    try {
      final species = await widget.controller.getSpecies();
      setState(() {
        _speciesList = species;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // TODO: 에러 처리
    }
  }

  // 품종 목록 로드
  Future<void> _loadBreeds(int species) async {
    setState(() => _isLoading = true);
    try {
      final breeds = await widget.controller.getBreeds(species);
      setState(() {
        _breedsList = breeds;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // TODO: 에러 처리
    }
  }

  // 동물 종류 선택 시 호출
  void _onSpeciesChanged(String? value) {
    if (value != null && value != _selectedSpecies) {
      setState(() {
        _selectedSpecies = value;
        _selectedBreed = null;
        _breedsList = [];
      });
      // species 매칭 ID
      final speciesObj = _speciesList.firstWhere(
        (species) => species.name == value,
      );
      _loadBreeds(speciesObj.id);
    }
  }

  void _onGenderChanged(String gender) {
    setState(() => _selectedGender = gender);
  }

  void _onPrevious() {
    Navigator.of(context).pop();
  }

  // 생년월일 선택
  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  // 나이 계산
  String _calculateAge() {
    if (_selectedBirthDate == null) return '';

    final now = DateTime.now();
    final years = now.year - _selectedBirthDate!.year;
    if (years > 0) {
      return '$years세';
    } else {
      final months =
          now.month -
          _selectedBirthDate!.month +
          (now.year - _selectedBirthDate!.year) * 12;
      return '$months개월';
    }
  }

  // 다음 단계로 이동
  void _onNext() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.controller.setBasicInfo(
        name: _nameController.text,
        species: _selectedSpecies,
        breed: _selectedBreed,
        birth: _selectedBirthDate,
        gender: _selectedGender,
        flagNeutering: false, // TODO: 중성화 여부 입력 기능 추가
      );

      widget.controller.moveToNextStep();
    }
  }

  @override
  Widget build(BuildContext context) {
    final petRegisterState = ref.watch(petRegisterProvider);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PetRegisterHeader(title: '반려동물 정보를\n입력해주세요'),
              const SizedBox(height: 24),

              // 동물 종류 선택
              CustomDropdownField(
                label: '종류',
                hint: 'ex) 개, 고양이...',
                value: _selectedSpecies,
                items: _speciesList.map((species) => species.name).toList(),
                onChanged: _onSpeciesChanged,
              ),
              const SizedBox(height: 16),

              // 품종 선택
              CustomDropdownField(
                label: '품종',
                hint: 'ex) 삼, 스핑크스...',
                value: _selectedBreed,
                items: _breedsList.map((breed) => breed.name).toList(),
                onChanged: (value) => setState(() => _selectedBreed = value),
                enabled: _selectedSpecies != null,
              ),
              const SizedBox(height: 16),

              // 이름 입력
              CustomTextField(
                label: '동물 이름',
                hint: '반려동물의 이름을 입력하세요',
                controller: _nameController,
                isRequired: true,
              ),
              const SizedBox(height: 16),

              // 생년월일 선택
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '생년월일',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _selectBirthDate,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedBirthDate != null
                                ? '${_selectedBirthDate!.year}년 ${_selectedBirthDate!.month}월 ${_selectedBirthDate!.day}일 (${_calculateAge()})'
                                : '생년월일을 선택하세요',
                            style: TextStyle(
                              color:
                                  _selectedBirthDate != null
                                      ? Colors.black
                                      : Colors.grey,
                            ),
                          ),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 성별 선택
              PetGenderSelector(
                selectedGender: _selectedGender,
                onGenderChanged: _onGenderChanged,
              ),
              const SizedBox(height: 32),

              // 이전/다음 버튼
              DualButtons(
                onLeft: _onPrevious,
                onRight: _onNext,
                isLoading: petRegisterState.isLoading,
                leftLabel: '이전',
                rightLabel: '다음',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
