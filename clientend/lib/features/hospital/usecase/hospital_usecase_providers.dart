import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/features/hospital/api/repositories/hospital_repository.dart';
import 'package:kkuk_kkuk/features/hospital/usecase/get_hospital_info_usecase.dart';

final getHospitalUseCaseProvider = Provider<GetHospitalInfoUseCase>((ref) {
  final hospitalRepository = ref.watch(hospitalRepositoryProvider);
  return GetHospitalInfoUseCase(hospitalRepository);
});
