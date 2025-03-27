import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kkuk_kkuk/domain/entities/pet_model.dart';
import 'package:kkuk_kkuk/models/hospital_qr_data.dart';
import 'package:kkuk_kkuk/domain/usecases/pet_medical_record/grant_hospital_access_usecase.dart';
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
  String transactionHash = '';

  @override
  void initState() {
    super.initState();
    _grantAccess();
  }

  // _grantAccess 메서드 내부 수정
  Future<void> _grantAccess() async {
    if (!mounted) return;
    
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Calculate expiry date (30 days from now by default)
      final expiryDate = DateTime.now().add(const Duration(days: 30));
      
      // Get the use case from the provider
      final grantHospitalAccessUseCase = ref.read(grantHospitalAccessUseCaseProvider);
      
      // 펫 DID와 병원 DID 확인
      final petDid = widget.pet.did ?? '';
      final hospitalDid = widget.hospital.did;
      
      print('펫 DID: $petDid');
      print('병원 DID: $hospitalDid');
      
      // Execute the use case with pet DID and hospital DID
      final result = await grantHospitalAccessUseCase.execute(
        petDid: petDid,
        hospitalDid: hospitalDid,
        expiryDate: expiryDate,
      );
      
      if (!mounted) return;
      
      setState(() {
        isLoading = false;
        success = true;
        transactionHash = result;
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        isLoading = false;
        success = false;
        errorMessage = e.toString();
      });
    }
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
                    Text('병원에 권한 부여 중...'),
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
                    if (success && transactionHash.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Text(
                        '트랜잭션 해시:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          transactionHash,
                          style: const TextStyle(fontFamily: 'monospace'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
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