import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/entities/pet/pet.dart';
import 'package:kkuk_kkuk/features/pet/model/pet_usecase_providers.dart';
import 'package:kkuk_kkuk/pages/main/widgets/pet/card/pet_card_image.dart';
import 'package:kkuk_kkuk/pages/main/widgets/pet/card/pet_card_info.dart';
import 'package:kkuk_kkuk/shared/utils/did_helper.dart';
import 'package:web3dart/web3dart.dart';

/// 반려동물 상세 정보 헤더 위젯
class PetProfileHeader extends ConsumerWidget {
  final Pet pet;
  static const String _privateKeyKey = 'eth_private_key';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  const PetProfileHeader({super.key, required this.pet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 반려동물 이미지
              SizedBox(
                width: 120,
                height: 120,
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
                    // 이름
                    PetCardTitle(text: pet.name),
                    const SizedBox(height: 4),
                    // 종종
                    PetCardSubtitle(text: pet.species),
                    const SizedBox(height: 8),
                    // 품종
                    PetCardSubtitle(
                      text: pet.breedName.isNotEmpty ? pet.breedName : '믹스',
                    ),
                    const SizedBox(height: 4),
                    // 나이
                    PetCardSubtitle(text: pet.ageString),
                    const SizedBox(height: 4),
                    // 성별
                    PetCardSubtitle(text: pet.gender),
                    const SizedBox(height: 4),
                    // 중성화여부
                    PetCardSubtitle(text: pet.flagNeutering ? '중성화' : '미중성화'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 버튼 영역
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 수정 버튼
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _navigateToEditPet(context, pet),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade100,
                    foregroundColor: Colors.blue.shade900,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_outlined, size: 18),
                      SizedBox(width: 8),
                      Text('반려동물 수정'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // 삭제 버튼
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showDeleteConfirmation(context, ref),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade100,
                    foregroundColor: Colors.red.shade900,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.delete_outline, size: 18),
                      SizedBox(width: 8),
                      Text('반려동물 삭제'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 반려동물 수정 화면으로 이동
  void _navigateToEditPet(BuildContext context, Pet pet) {
    // 수정 화면으로 이동하면서 현재 반려동물 정보 전달
    context.push('/pet/edit', extra: pet);
  }

  /// 삭제 확인 다이얼로그 표시
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
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                  await _deletePet(context, ref);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('삭제'),
              ),
            ],
          ),
    );
  }

  /// 반려동물 삭제 처리
  Future<void> _deletePet(BuildContext context, WidgetRef ref) async {
    // Store the context for later use
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      // 로딩 표시
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

      // 개인 키 가져오기
      final privateKeyHex = await _secureStorage.read(key: _privateKeyKey);
      if (privateKeyHex == null || privateKeyHex.isEmpty) {
        throw Exception('개인 키를 찾을 수 없습니다. 다시 로그인해주세요.');
      }

      // 자격 증명 생성
      final credentials = EthPrivateKey.fromHex(privateKeyHex);

      // 반려동물 삭제 실행
      final deleteUseCase = ref.read(deletePetUseCaseProvider);
      final success = await deleteUseCase.execute(
        credentials,
        DidHelper.extractAddressFromDid(pet.did!),
      );

      // TODO: 트랜잭션이 블록체인에 기록될 때까지 추가 대기
      await Future.delayed(const Duration(seconds: 5));

      // Check if the widget is still mounted before proceeding
      if (!navigator.mounted) return;

      // 로딩 다이얼로그 닫기
      navigator.pop();

      if (success) {
        // 삭제 성공 시 메인 화면으로 이동
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('${pet.name}이(가) 삭제되었습니다.')),
        );
        navigator.popUntil((route) => route.isFirst);
      } else {
        // 삭제 실패 시 오류 메시지 표시
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('반려동물 삭제에 실패했습니다.')),
        );
      }
    } catch (e) {
      // Check if the widget is still mounted before proceeding
      if (!navigator.mounted) return;

      // 로딩 다이얼로그 닫기
      navigator.pop();

      // 오류 메시지 표시
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('오류 발생: ${e.toString()}')),
      );
    }
  }
}
