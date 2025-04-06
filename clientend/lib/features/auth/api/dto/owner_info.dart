import 'package:freezed_annotation/freezed_annotation.dart';

part 'owner_info.freezed.dart';
part 'owner_info.g.dart';

@freezed
abstract class OwnerInfo with _$OwnerInfo {
  const factory OwnerInfo({
    required int id,
    String? did,
    required String name,
    required String email,
    String? birth,
    String? image,
  }) = _OwnerInfo;

  factory OwnerInfo.fromJson(Map<String, dynamic> json) =>
      _$OwnerInfoFromJson(json);
}
