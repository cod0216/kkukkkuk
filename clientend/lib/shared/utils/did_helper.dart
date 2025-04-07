/// DID 관련 유틸리티 함수들을 제공하는 클래스
class DidHelper {
  /// DID 문자열에서 이더리움 주소 추출
  /// 예: "did:pet:0x123..." -> "0x123..."
  /// 또는 "did:hospital:0x123..." -> "0x123..."
  static String extractAddressFromDid(String did) {
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

  /// 이더리움 주소를 특정 타입의 DID로 변환
  /// 예: "0x123..." -> "did:pet:0x123..."
  static String createDid(String address, String type) {
    // 주소가 0x로 시작하는지 확인하고 필요시 제거
    String cleanAddress = address;
    if (cleanAddress.startsWith('0x')) {
      cleanAddress = cleanAddress.substring(2);
    }

    return 'did:$type:$cleanAddress';
  }

  /// 이더리움 주소를 반려동물 DID로 변환
  /// 예: "0x123..." -> "did:pet:0x123..."
  static String createPetDid(String address) {
    return createDid(address, 'pet');
  }

  /// 이더리움 주소를 병원 DID로 변환
  /// 예: "0x123..." -> "did:hospital:0x123..."
  static String createHospitalDid(String address) {
    return createDid(address, 'hospital');
  }

  /// 이더리움 주소를 소유자 DID로 변환
  /// 예: "0x123..." -> "did:owner:0x123..."
  static String createOwnerDid(String address) {
    return createDid(address, 'owner');
  }

  /// DID가 유효한지 검증
  static bool isValidDid(String did) {
    // DID 형식 검증 (did:type:address)
    final parts = did.split(':');
    if (parts.length < 3) return false;

    // 이더리움 주소 부분 검증 (0x로 시작하는 42자 문자열)
    final address = extractAddressFromDid(did);
    return address.startsWith('0x') && address.length == 42;
  }
}
