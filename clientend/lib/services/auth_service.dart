import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  // Login methods
  Future<bool> signInWithKakao() async {
    // TODO: Kakao login
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  Future<bool> logout() async {
    // TODO: Logout
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  Future<bool> refreshToken() async {
    // TODO: refresh token
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  Future<bool> checkWallet() async {
    // TODO: Check if user has a wallet on the server
    await Future.delayed(const Duration(seconds: 1));
    return false;
  }

  Future<String> generatePrivateKey() async {
    // TODO: Generate a private key for wallet
    await Future.delayed(const Duration(seconds: 1));
    return "0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef";
  }

  Future<String> createWalletFromPrivateKey(String privateKey) async {
    // TODO: Create wallet from private key
    await Future.delayed(const Duration(seconds: 1));
    return "0x123...abc"; // Wallet address
  }

  Future<String> encryptPrivateKey(String privateKey, String pin) async {
    // TODO: Encrypt private key with PIN
    await Future.delayed(const Duration(seconds: 1));
    return "encrypted_${privateKey}_with_${pin}";
  }

  Future<bool> saveEncryptedWallet(
    String walletAddress,
    String encryptedPrivateKey,
  ) async {
    // TODO: Send encrypted wallet to server
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});
