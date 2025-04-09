import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/entities/pet/breed.dart';
import 'package:kkuk_kkuk/pages/pet_register/notifiers/pet_register_notifier.dart';
import 'package:kkuk_kkuk/widgets/pet/info/pet_gender_selector.dart';
import 'package:kkuk_kkuk/widgets/common/custom_header.dart';
import 'package:kkuk_kkuk/widgets/common/primary_section.dart';
import 'package:kkuk_kkuk/widgets/common/animated_dropdown.dart'; // AnimatedDropdown import

// 반려동물 기본 정보 입력 화면
class PetInfoView extends ConsumerStatefulWidget {
  const PetInfoView({super.key});

  @override
  ConsumerState<PetInfoView> createState() => _PetInfoViewState();
}

class _PetInfoViewState extends ConsumerState<PetInfoView> {
  // 폼 및 입력 컨트롤러
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime? _selectedBirthDate;

  // 선택된 값들 상태 관리 (Breed 객체로 관리)
  Breed? _selectedSpecies;
  Breed? _selectedBreed;
  String _selectedGender = 'MALE';
  bool _isNeutered = false;

  // 동물 종류 및 품종 목록
  List<Breed> _speciesList = [];
  List<Breed> _breedsList = [];
  bool _isLoadingSpecies = false;
  bool _isLoadingBreeds = false;

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
    setState(() => _isLoadingSpecies = true);
    try {
      final species =
          await ref.read(petRegisterNotifierProvider.notifier).getSpecies();
      setState(() {
        _speciesList = species;
        _isLoadingSpecies = false;
      });
    } catch (e) {
      setState(() => _isLoadingSpecies = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('종 목록 로드 실패: $e')));
      }
    }
  }

  // 품종 목록 로드
  Future<void> _loadBreeds(int speciesId) async {
    setState(() => _isLoadingBreeds = true);
    try {
      final breeds = await ref
          .read(petRegisterNotifierProvider.notifier)
          .getBreeds(speciesId);
      setState(() {
        _breedsList = breeds;
        _isLoadingBreeds = false;
      });
    } catch (e) {
      setState(() => _isLoadingBreeds = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('품종 목록 로드 실패: $e')));
      }
    }
  }

  // 동물 종류 선택 시 호출 (Breed 객체 사용)
  void _onSpeciesChanged(Breed? value) {
    if (value != null && value.id != _selectedSpecies?.id) {
      setState(() {
        _selectedSpecies = value;
        _selectedBreed = null;
        _breedsList = [];
      });
      _loadBreeds(value.id);
    }
  }

  void _onGenderChanged(String gender) {
    setState(() => _selectedGender = gender);
  }

  void _onPrevious() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  // 생년월일 선택
  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      helpText: '생년월일 선택',
      cancelText: '취소',
      confirmText: '확인',
    );
    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  // 나이 계산 (12개월 미만 시 개월, 최소 1개월 표시)
  String _calculateAge() {
    if (_selectedBirthDate == null) return '';
    final now = DateTime.now();
    final birthDate = _selectedBirthDate!;
    int totalMonths =
        (now.year - birthDate.year) * 12 + (now.month - birthDate.month);
    if (now.day < birthDate.day) {
      totalMonths--;
    }
    if (totalMonths >= 12) {
      int years = totalMonths ~/ 12;
      return '$years세';
    } else {
      int displayMonths = (totalMonths < 1) ? 1 : totalMonths;
      return '$displayMonths개월';
    }
  }

  // 다음 단계로 이동 (Breed 객체 이름 전달)
  void _onNext() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedSpecies == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('동물 종류를 선택해주세요.')));
        return;
      }

      ref
          .read(petRegisterNotifierProvider.notifier)
          .setBasicInfo(
            name: _nameController.text.trim(),
            species: _selectedSpecies!.name, // 이름 전달
            breed: _selectedBreed?.name, // 이름 전달 (null 가능)
            birth: _selectedBirthDate,
            gender: _selectedGender,
            flagNeutering: _isNeutered,
          );
      ref.read(petRegisterNotifierProvider.notifier).moveToNextStep();
    }
  }

  // InputDecoration 스타일 정의
  InputDecoration _buildInputDecoration(String? hintText) {
    // hintText Nullable로 변경
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey[600]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red.shade700, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final petRegisterState = ref.watch(petRegisterNotifierProvider);
    final bool isProcessing = petRegisterState.isLoading; // 다음 단계 이동 시 로딩 상태

    // 종 목록 로딩 중일 때만 전체 로딩 표시
    if (_isLoadingSpecies && _speciesList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      // Scaffold 추가 (페이지 구성 요소)
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PetRegisterHeader(title: '반려동물 정보를\n입력해주세요'),
                const SizedBox(height: 24),

                // 동물 종류 섹션 (AnimatedDropdown 사용)
                PrimarySection(
                  title: '종류',
                  child: AnimatedDropdown(
                    decoration: _buildInputDecoration(null), // 기본 스타일만 전달
                    hintText: 'ex) 개, 고양이...',
                    value: _selectedSpecies,
                    items: _speciesList,
                    onChanged: _onSpeciesChanged,
                    validator: (value) {
                      if (value == null) {
                        return '동물 종류를 선택해주세요';
                      }
                      return null;
                    },
                    enabled: !_isLoadingSpecies,
                  ),
                ),
                const SizedBox(height: 16),

                // 품종 섹션 (AnimatedDropdown 사용)
                PrimarySection(
                  title: '품종',
                  child: AnimatedDropdown(
                    decoration: _buildInputDecoration(null), // 기본 스타일만 전달
                    hintText: 'ex) 말티즈, 코리안숏헤어...',
                    value: _selectedBreed,
                    items: _breedsList,
                    onChanged:
                        (value) => setState(() => _selectedBreed = value),
                    validator: null,
                    enabled: _selectedSpecies != null && !_isLoadingBreeds,
                  ),
                ),
                const SizedBox(height: 16),

                // 동물 이름 섹션
                PrimarySection(
                  title: '동물 이름',
                  child: TextFormField(
                    controller: _nameController,
                    decoration: _buildInputDecoration('반려동물의 이름을 입력하세요'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '동물 이름을 입력해주세요';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(height: 16),

                // 생년월일 섹션
                PrimarySection(
                  title: '생년월일',
                  spacing: 8,
                  child: InkWell(
                    onTap: _selectBirthDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedBirthDate != null
                                ? '${_selectedBirthDate!.year}년 ${_selectedBirthDate!.month}월 ${_selectedBirthDate!.day}일 (${_calculateAge()})'
                                : '생년월일을 선택하세요 (선택)',
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  _selectedBirthDate != null
                                      ? Colors.black87
                                      : Colors.grey[600],
                            ),
                          ),
                          Icon(Icons.calendar_today, color: Colors.grey[600]),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 성별 섹션
                PrimarySection(
                  title: '성별',
                  spacing: 8,
                  child: PetGenderSelector(
                    // 수정된 스타일 적용됨
                    selectedGender: _selectedGender,
                    onGenderChanged: _onGenderChanged,
                  ),
                ),
                const SizedBox(height: 16),

                // 중성화 여부 섹션
                PrimarySection(
                  title: '중성화 여부',
                  spacing: 0,
                  child: Row(
                    children: [
                      Switch(
                        value: _isNeutered,
                        onChanged: (value) {
                          setState(() {
                            _isNeutered = value;
                          });
                        },
                      ),
                      Text(
                        _isNeutered ? '중성화 완료' : '중성화 안함',
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              _isNeutered
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // 버튼 섹션 (MyPage 스타일)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.arrow_back, size: 18),
                        label: const Text('취소'),
                        onPressed: isProcessing ? null : _onPrevious,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black87,
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          disabledForegroundColor: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon:
                            isProcessing
                                ? Container()
                                : const Icon(
                                  Icons.arrow_forward,
                                  size: 18,
                                  color: Colors.white,
                                ),
                        label:
                            isProcessing
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                                : const Text('다음'),
                        onPressed: isProcessing ? null : _onNext,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 1,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          disabledBackgroundColor: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
