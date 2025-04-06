import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet.freezed.dart';

@freezed
abstract class Wallet with _$Wallet {
  const factory Wallet({
    required int id,
    required String address,
    required String name,
    List<Owner>? owners,
  }) = _Wallet;
}

@freezed
abstract class Owner with _$Owner {
  const factory Owner({required int id, required String name, String? image}) =
      _Owner;
}
