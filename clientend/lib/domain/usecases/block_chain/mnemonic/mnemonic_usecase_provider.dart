import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/mnemonic/generate_korean_mnemonic_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/mnemonic/validate_korean_mnemonic_usecase.dart';

final generateKoreanMnemonicUseCaseProvider =
    Provider<GenerateKoreanMnemonicUseCase>((ref) {
      return GenerateKoreanMnemonicUseCase();
    });

final validateKoreanMnemonicUseCaseProvider =
    Provider<ValidateKoreanMnemonicUseCase>((ref) {
      return ValidateKoreanMnemonicUseCase();
    });
