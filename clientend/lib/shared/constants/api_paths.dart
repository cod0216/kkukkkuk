abstract class ApiPaths {
  // Auth
  static const String kakaoLogin = '/api/auths/owners/kakao/login';
  static const String logout = '/api/auths/logout';
  static const String refreshToken = '/api/refresh-token';

  // Owners (User)
  static const String ownersMe = '/api/owners/me';
  static const String ownersMeImages = '/api/owners/me/images';

  // Wallets
  static const String wallets = '/api/wallets';
  static String walletById(int walletId) => '/api/wallets/$walletId';

  // Breeds (Species 포함)
  static const String breeds = '/api/breeds';
  static String breedsBySpecies(int speciesId) => '/api/breeds/$speciesId';

  // Images
  static const String imagesPermanent = '/api/images/permanent';

  // Medical Records (OCR 처리) - 실제 엔드포인트 확인 필요
  static const String processOcr = '/api/medical-records/ocr'; // 예시 경로
}
