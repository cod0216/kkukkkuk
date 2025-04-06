// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalletDetailResponse _$WalletDetailResponseFromJson(
  Map<String, dynamic> json,
) => _WalletDetailResponse(
  status: json['status'] as String,
  message: json['message'] as String,
  data: WalletDetailData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$WalletDetailResponseToJson(
  _WalletDetailResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

_WalletDetailData _$WalletDetailDataFromJson(Map<String, dynamic> json) =>
    _WalletDetailData(
      id: (json['id'] as num).toInt(),
      address: json['address'] as String,
      name: json['name'] as String,
      owners:
          (json['owners'] as List<dynamic>)
              .map((e) => WalletOwner.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$WalletDetailDataToJson(_WalletDetailData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'name': instance.name,
      'owners': instance.owners,
    };

_WalletOwner _$WalletOwnerFromJson(Map<String, dynamic> json) => _WalletOwner(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  image: json['image'] as String?,
);

Map<String, dynamic> _$WalletOwnerToJson(_WalletOwner instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
    };
