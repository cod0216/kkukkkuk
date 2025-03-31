import 'package:kkuk_kkuk/data/dtos/wallet/wallet_update_request.dart';
import 'package:kkuk_kkuk/data/dtos/wallet/wallet_update_response.dart';
import 'package:kkuk_kkuk/domain/repositories/blockchain/wallet_repository_interface.dart';

class UpdateWalletUseCase {
  final IWalletRepository _walletRepository;

  UpdateWalletUseCase(this._walletRepository);

  /// 지갑 정보 업데이트
  /// 
  /// [did] 업데이트할 지갑의 DID
  /// [address] 업데이트할 지갑 주소
  /// [publicKey] 업데이트할 지갑의 공개키
  Future<WalletUpdateResponse> execute({
    required String did,
    required String address,
    required String publicKey,
  }) async {
    try {
      final request = WalletUpdateRequest(
        did: did,
        address: address,
        publicKey: publicKey,
      );
      
      return await _walletRepository.updateWallet(request);
    } catch (e) {
      print('지갑 정보 업데이트 실패: $e');
      throw Exception('지갑 정보 업데이트에 실패했습니다: $e');
    }
  }
}