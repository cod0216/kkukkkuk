import 'package:kkuk_kkuk/domain/entities/wallet.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String birthYear;
  final String birthDay;
  final String gender;
  final String providerId;
  final Wallet? wallet;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.birthYear,
    required this.birthDay,
    required this.gender,
    required this.providerId,
    this.wallet,
  });
}
