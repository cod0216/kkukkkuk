import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/features/wallet/model/generate_mnemonic_usecase.dart';
import 'package:kkuk_kkuk/features/wallet/model/validate_mnemonic_usecase.dart';

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
