import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kkuk_kkuk/entities/wallet/owner.dart';

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
