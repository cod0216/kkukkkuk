import 'package:kkuk_kkuk/features/wallet/api/dto/wallet_registration_request.dart';
import 'package:kkuk_kkuk/features/wallet/api/dto/wallet_registration_response.dart';
import 'package:kkuk_kkuk/features/wallet/api/repositories/wallet_repository_interface.dart';

class RegisterWalletUseCase {
  final IWalletRepository _walletRepository;

  RegisterWalletUseCase(this._walletRepository);

  Future<WalletRegistrationResponse> execute({
    required String address,
    required String name,
  }) async {
    try {
      final request = WalletRegistrationRequest(address: address, name: name);
      return await _walletRepository.registerWallet(request);
    } catch (e) {
      print('지갑 등록 실패: $e');
      rethrow;
    }
  }
}
