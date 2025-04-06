import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_info.freezed.dart';
part 'wallet_info.g.dart';

@freezed
abstract class WalletInfo with _$WalletInfo {
  const factory WalletInfo({
    required int id,
    String? name,
    required String address,
  }) = _WalletInfo;

  factory WalletInfo.fromJson(Map<String, dynamic> json) =>
      _$WalletInfoFromJson(json);
}
