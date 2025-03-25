import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/repositories/mnemonic_repository.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/mnemonic/generate_korean_mnemonic_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/mnemonic/get_saved_mnemonic_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/mnemonic/save_mnemonic_usecase.dart';
import 'package:kkuk_kkuk/domain/usecases/block_chain/mnemonic/validate_korean_mnemonic_usecase.dart';

final generateKoreanMnemonicUseCaseProvider =
    Provider<GenerateKoreanMnemonicUseCase>((ref) {
      return GenerateKoreanMnemonicUseCase();
    });

final validateKoreanMnemonicUseCaseProvider =
    Provider<ValidateKoreanMnemonicUseCase>((ref) {
      return ValidateKoreanMnemonicUseCase();
    });

final saveMnemonicUseCaseProvider = Provider<SaveMnemonicUseCase>((ref) {
  final repository = ref.watch(mnemonicRepositoryProvider);
  return SaveMnemonicUseCase(repository);
});

final getSavedMnemonicUseCaseProvider = Provider<GetSavedMnemonicUseCase>((
  ref,
) {
  final repository = ref.watch(mnemonicRepositoryProvider);
  return GetSavedMnemonicUseCase(repository);
});
