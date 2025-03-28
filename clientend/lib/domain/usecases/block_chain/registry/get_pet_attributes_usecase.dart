import 'package:kkuk_kkuk/domain/repositories/blockchain/registry_contract_repository_interface.dart';

class GetPetAttributesUseCase {
  final IRegistryContractRepository _repository;

  GetPetAttributesUseCase(this._repository);

  Future<Map<String, dynamic>> execute(String petAddress) async {
    try {
      // DID 형식(did:pet:0x...)에서 이더리움 주소 추출
      String cleanAddress = _extractEthereumAddress(petAddress);

      return await _repository.getAllAttributes(cleanAddress);
    } catch (e) {
      throw Exception('반려동물 속성 조회에 실패했습니다: $e');
    }
  }

  /// DID 형식의 주소에서 이더리움 주소 부분만 추출
  ///
  /// 예: "did:pet:0x184d1595e0943c5a6460c355613548b619b58ac5" -> "0x184d1595e0943c5a6460c355613548b619b58ac5"
  String _extractEthereumAddress(String address) {
    if (address.startsWith('did:pet:')) {
      return address.substring(8); // 'did:pet:' 제거 (8자)
    }
    return address; // 이미 이더리움 주소 형식이면 그대로 반환
  }
}
