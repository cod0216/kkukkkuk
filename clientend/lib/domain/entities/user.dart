import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kkuk_kkuk/domain/entities/wallet.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required int id,
    String? did,
    required String name,
    required String email,
    required String birthYear,
    required String birthDay,
    required String gender,
    String? profileImage,
    required int providerId,
    List<Wallet>? wallets,
  }) = _User;
}
