import 'package:flutter_dotenv/flutter_dotenv.dart';

/// 환경 설정 클래스
class AppConfig {
  // Private constructor
  AppConfig._();

  /// .env 파일 로드
  static Future<void> load() async {
    try {
      await dotenv.load(fileName: ".env");
      print('.env file loaded successfully.');
    } catch (e) {
      print('Error loading .env file: $e');
    }
  }

  // API 설정
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'DEFAULT_API_URL';

  // Blockchain 설정
  static String get blockchainRpcUrl => dotenv.env['BLOCKCHAIN_RPC_URL'] ?? '';
  static String get blockchainWsUrl => dotenv.env['BLOCKCHAIN_WS_URL'] ?? '';
  static int get blockchainChainId {
    try {
      return int.parse(dotenv.env['BLOCKCHAIN_CHAIN_ID'] ?? '0');
    } catch (e) {
      print('Error parsing BLOCKCHAIN_CHAIN_ID: $e');
      return 0;
    }
  }

  // Smart Contract 설정
  static String get petRegistryContractAddress =>
      dotenv.env['PET_REGISTRY_CONTRACT_ADDRESS'] ?? '';

  // Kakao 설정
  static String get kakaoAppKey => dotenv.env['KAKAO_APP_KEY'] ?? '';
  static String get kakaoJavaScriptKey => dotenv.env['KAKAO_JS_KEY'] ?? '';

}
