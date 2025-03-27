import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/domain/entities/pet_model.dart';
import 'package:kkuk_kkuk/models/hospital_qr_data.dart';
import 'package:kkuk_kkuk/domain/usecases/pet_medical_record/grant_access_permission_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/pet_medical_record/pet_medical_record_usecase_providers.dart';

class SharingResultView extends ConsumerStatefulWidget {
  final Pet pet;
  final HospitalQRData hospital;

  const SharingResultView({
    super.key,
    required this.pet,
    required this.hospital,
  });

  @override
  ConsumerState<SharingResultView> createState() => _SharingResultViewState();
}

class _SharingResultViewState extends ConsumerState<SharingResultView> {
  bool isLoading = true;
  bool success = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    // 여기서는 권한 부여 로직을 실행하지 않고 단순히 성공 상태로 표시
    // 실제 권한 부여 로직은 다음 단계에서 구현
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          isLoading = false;
          success = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('권한 부여 결과'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: isLoading
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 24),
                    Text('권한 부여 중...'),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      success ? Icons.check_circle : Icons.error,
                      size: 80,
                      color: success ? Colors.green : Colors.red,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      success ? '권한 부여 완료' : '권한 부여 실패',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      success
                          ? '${widget.pet.name}의 진료 기록에 대한 접근 권한이 ${widget.hospital.name}에 부여되었습니다.'
                          : '${widget.hospital.name}에 권한을 부여하는 중 오류가 발생했습니다.\n$errorMessage',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        context.go('/pets');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      child: const Text('홈으로 돌아가기'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}