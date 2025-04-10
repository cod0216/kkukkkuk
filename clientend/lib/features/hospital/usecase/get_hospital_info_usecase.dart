import 'package:kkuk_kkuk/features/hospital/api/dto/hospital_info_response.dart';
import 'package:kkuk_kkuk/features/hospital/api/repositories/hospital_repository_interface.dart';

class GetHospitalInfoUseCase {
  final IHospitalRepository _hospitalRepository;

  GetHospitalInfoUseCase(this._hospitalRepository);

  Future<HospitalInfoResponse> getNearHospitals(double x, double y, int radius) async {
    try {
      return await _hospitalRepository.getNearHospitals(x, y, radius);
    } catch (e) {
      throw Exception('지도 정보 조회에 실패했습니다: $e');
    }
  }
}
