import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/entities/pet/pet.dart';
import 'package:kkuk_kkuk/features/pet/usecase/pet_usecase_providers.dart';
import 'package:kkuk_kkuk/widgets/pet/card/pet_card_image.dart';
import 'package:kkuk_kkuk/shared/utils/did_helper.dart';
import 'package:web3dart/web3dart.dart';

/// 반려동물 상세 정보 헤더 위젯 (스타일 수정)
class PetProfileHeader extends ConsumerWidget {
  final Pet pet;
  static const String _privateKeyKey = 'eth_private_key';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  const PetProfileHeader({super.key, required this.pet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      // 배경색은 Scaffold 배경색과 동일하게 하거나 약간 다르게 설정 가능
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 내용 왼쪽 정렬
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 반려동물 이미지 (둥근 사각형)
              SizedBox(
                width: 100, // 크기 조정
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: PetCardImage(imageUrl: pet.imageUrl),
                ),
              ),
              const SizedBox(width: 16),
              // 반려동물 기본 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 이름 (더 크게)
                    Text(
                      pet.name,
                      style: const TextStyle(
                        fontSize: 20, // 크기 증가
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8), // 간격 조정
                    // 상세 정보들을 작은 텍스트로 나열
                    _buildInfoRow(Icons.pets_outlined, pet.species),
                    _buildInfoRow(
                      Icons.category_outlined,
                      pet.breedName.isNotEmpty ? pet.breedName : '믹스',
                    ),
                    _buildInfoRow(Icons.cake_outlined, pet.ageString),
                    _buildInfoRow(
                      pet.gender == 'MALE' ? Icons.male : Icons.female,
                      pet.gender == 'MALE' ? '수컷' : '암컷',
                      pet.gender == 'MALE' ? Colors.blue : Colors.pink,
                    ), // 성별 아이콘 및 색상
                    _buildInfoRow(
                      Icons.health_and_safety_outlined,
                      pet.flagNeutering ? '중성화 완료' : '중성화 안함',
                      pet.flagNeutering ? Colors.green : Colors.orange,
                    ), // 중성화 정보 아이콘 및 색상
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20), // 정보와 버튼 사이 간격
          // 버튼 영역 (스타일 변경)
          Row(
            children: [
              // 수정 버튼 (OutlinedButton)
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('정보 수정'),
                  onPressed: () => _navigateToEditPet(context, pet),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor, // 버튼 내부 색상
                    side: BorderSide(
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                    ), // 테두리 색상
                    padding: const EdgeInsets.symmetric(vertical: 12), // 패딩 조정
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // 삭제 버튼 (OutlinedButton, 빨간색 계열)
              Expanded(
                child: OutlinedButton.icon(
                  icon: Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Colors.red.shade700,
                  ),
                  label: Text(
                    '기록 삭제',
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                  onPressed: () => _showDeleteConfirmation(context, ref),
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        Colors.red.shade700, // 버튼 내부 색상 (사실상 사용 안됨)
                    side: BorderSide(color: Colors.red.shade300), // 테두리 색상
                    padding: const EdgeInsets.symmetric(vertical: 12), // 패딩 조정
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8), // 헤더 하단 여백 추가
        ],
      ),
    );
  }

  // 정보 행 위젯 생성 함수
  Widget _buildInfoRow(IconData icon, String text, [Color? iconColor]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0), // 행 간 간격 조정
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 16,
            color: iconColor ?? Colors.grey.shade600,
          ), // 아이콘 크기 및 색상
          const SizedBox(width: 6),
          Expanded(
            // 텍스트가 길어질 경우 대비
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade800,
              ), // 텍스트 스타일
              overflow: TextOverflow.ellipsis, // 넘칠 경우 ... 처리
            ),
          ),
        ],
      ),
    );
  }

  // 수정 화면 이동 함수 (변경 없음)
  void _navigateToEditPet(BuildContext context, Pet pet) {
    context.push('/pet/edit', extra: pet);
  }

  // 삭제 확인 다이얼로그 표시 함수 (변경 없음)
  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('반려동물 삭제'),
            content: Text('${pet.name}을(를) 정말 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _deletePet(context, ref);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('삭제'),
              ),
            ],
          ),
    );
  }

  // 반려동물 삭제 처리 함수 (변경 없음)
  Future<void> _deletePet(BuildContext context, WidgetRef ref) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (dialogContext) => const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    '반려동물 삭제 중...\n블록체인 트랜잭션이 완료될 때까지 기다려주세요.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
      );

      final privateKeyHex = await _secureStorage.read(key: _privateKeyKey);
      if (privateKeyHex == null || privateKeyHex.isEmpty) {
        throw Exception('개인 키를 찾을 수 없습니다. 다시 로그인해주세요.');
      }
      final credentials = EthPrivateKey.fromHex(privateKeyHex);
      final deleteUseCase = ref.read(deletePetUseCaseProvider);
      final success = await deleteUseCase.execute(
        credentials,
        DidHelper.extractAddressFromDid(pet.did!),
      );

      await Future.delayed(const Duration(seconds: 5));

      if (!navigator.mounted) return;
      navigator.pop(); // 로딩 다이얼로그 닫기

      if (success) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('${pet.name}이(가) 삭제되었습니다.')),
        );
        // popUntil 대신 goNamed 사용 (경로 이름이 있다면) 또는 go('/') 사용
        GoRouter.of(context).go('/pets'); // 예시: pets 목록 화면으로 이동
      } else {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('반려동물 삭제에 실패했습니다.')),
        );
      }
    } catch (e) {
      if (!navigator.mounted) return;
      navigator.pop();
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('오류 발생: ${e.toString()}')),
      );
    }
  }
}
