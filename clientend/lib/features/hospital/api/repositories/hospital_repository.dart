import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/shared/api/client/api_client.dart';

import 'package:kkuk_kkuk/features/hospital/api/dto/hospital_info_response.dart';
import 'package:kkuk_kkuk/features/hospital/api/repositories/hospital_repository_interface.dart';

class HospitalRepository implements IHospitalRepository {
  final ApiClient _apiClient;
  HospitalRepository(this._apiClient);

  @override
  Future<HospitalInfoResponse> getNearHospitals(double x, double y, int radius) async {
    try {
      final response = await _apiClient.get('/api/hospitals?xAxis=${x.toStringAsFixed(2)}&yAxis=${y.toStringAsFixed(2)}&radius=$radius');
      return HospitalInfoResponse.fromJson(response.data);
    } catch (e) {
      print('병원 목록 정보 조회 실패: $e');
      rethrow;
    }
  }
}

final hospitalRepositoryProvider = Provider<IHospitalRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return HospitalRepository(apiClient);
});
