import 'package:kkuk_kkuk/data/dtos/wallet/wallet_registration_request.dart';
import 'package:kkuk_kkuk/data/dtos/wallet/wallet_registration_response.dart';

abstract class IWalletRepository {
  /// 지갑 등록 API 호출
  Future<WalletRegistrationResponse> registerWallet(
    WalletRegistrationRequest request,
  );
}
