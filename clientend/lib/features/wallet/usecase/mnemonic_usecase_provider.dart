import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/features/wallet/usecase/generate_mnemonic_usecase.dart';
import 'package:kkuk_kkuk/features/wallet/usecase/validate_mnemonic_usecase.dart';

final generateMnemonicUseCaseProvider = Provider<GenerateMnemonicUseCase>((
  ref,
) {
  return GenerateMnemonicUseCase();
});

final validateMnemonicUseCaseProvider = Provider<ValidateMnemonicUseCase>((
  ref,
) {
  return ValidateMnemonicUseCase();
});
