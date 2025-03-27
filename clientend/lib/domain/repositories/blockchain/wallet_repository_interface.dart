import 'package:kkuk_kkuk/data/dtos/wallet/wallet_info_response.dart';
import 'package:kkuk_kkuk/data/dtos/wallet/wallet_registration_request.dart';
import 'package:kkuk_kkuk/data/dtos/wallet/wallet_registration_response.dart';
import 'package:kkuk_kkuk/data/dtos/wallet/wallet_update_request.dart';
import 'package:kkuk_kkuk/data/dtos/wallet/wallet_update_response.dart';

abstract class IWalletRepository {
  /// 지갑 등록 API 호출
  Future<WalletRegistrationResponse> registerWallet(
    WalletRegistrationRequest request,
  );
  
  /// 현재 로그인한 사용자의 지갑 정보 조회
  Future<WalletInfoResponse> getWalletInfo();
  
  /// 지갑 정보 업데이트
  Future<WalletUpdateResponse> updateWallet(
    WalletUpdateRequest request,
  );
}
