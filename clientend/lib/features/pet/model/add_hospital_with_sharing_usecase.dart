import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kkuk_kkuk/features/pet/api/repositories/pet_repository_interface.dart';
import 'package:kkuk_kkuk/shared/utils/did_helper.dart';
import 'package:web3dart/web3dart.dart';

class AddHospitalWithSharingUseCase {
  static const String _privateKeyKey = 'eth_private_key';
  final IPetRepository _repository;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  AddHospitalWithSharingUseCase(this._repository);

  /// Grant access to a hospital for a pet's medical records
  ///
  /// [petDid] - The DID (blockchain address) of the pet
  /// [hospitalDid] - The DID (blockchain address) of the hospital
  /// [expiryDate] - The date when the access permission expires
  Future<String> execute({
    required String petDid,
    required String hospitalDid,
    required DateTime expiryDate,
  }) async {
    try {
      // Calculate sharing period in seconds from now until expiry date
      final now = DateTime.now();
      final sharingPeriod = expiryDate.difference(now).inSeconds;

      if (sharingPeriod <= 0) {
        throw Exception('만료 날짜는 현재 시간보다 이후여야 합니다.');
      }

      // Get the private key from secure storage
      final privateKeyHex = await _secureStorage.read(key: _privateKeyKey);
      if (privateKeyHex == null || privateKeyHex.isEmpty) {
        throw Exception('개인 키를 찾을 수 없습니다. 다시 로그인해주세요.');
      }

      final petAddress = DidHelper.extractAddressFromDid(petDid);
      final hospitalAddress = DidHelper.extractAddressFromDid(hospitalDid);

      print('Pet 주소: $petAddress');
      print('병원 주소: $hospitalAddress');

      final credentials = EthPrivateKey.fromHex(privateKeyHex);

      // Call the repository method to add hospital with sharing
      return await _repository.addHospitalWithSharing(
        credentials: credentials,
        petAddress: petAddress,
        hospitalAddress: hospitalAddress,
        scope: 'medical_records', // Default scope for medical records
        sharingPeriod: sharingPeriod,
      );
    } catch (e) {
      throw Exception('병원에 권한 부여에 실패했습니다: $e');
    }
  }
}
