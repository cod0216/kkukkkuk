import 'package:kkuk_kkuk/features/hospital/api/dto/hospital_info_response.dart';

abstract class IHospitalRepository {
  Future<HospitalInfoResponse> getNearHospitals(
      double x, double y, int radius
      );
}
