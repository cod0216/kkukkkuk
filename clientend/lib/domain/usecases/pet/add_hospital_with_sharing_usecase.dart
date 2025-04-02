import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kkuk_kkuk/domain/repositories/pet/pet_repository_interface.dart';
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

      // Extract Ethereum addresses from DIDs
      final petAddress = _extractAddressFromDid(petDid);
      final hospitalAddress = _extractAddressFromDid(hospitalDid);

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

  /// DID 문자열에서 이더리움 주소 추출
  /// 예: "did:pet:0x123..." -> "0x123..."
  /// 또는 "did:hospital:0x123..." -> "0x123..."
  String _extractAddressFromDid(String did) {
    // DID가 이미 이더리움 주소 형식인지 확인
    if (did.startsWith('0x') && did.length == 42) {
      return did;
    }

    // DID 형식에서 주소 부분 추출
    final parts = did.split(':');
    if (parts.length >= 3) {
      String address = parts[2];
      // 주소가 0x로 시작하지 않으면 추가
      if (!address.startsWith('0x')) {
        address = '0x$address';
      }
      return address;
    }

    // 형식이 맞지 않으면 원래 값 반환
    return did;
  }
}
