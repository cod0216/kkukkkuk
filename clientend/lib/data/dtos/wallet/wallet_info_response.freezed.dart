// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_info_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WalletInfoResponse {

 String get status; String get message; WalletInfoData? get data;
/// Create a copy of WalletInfoResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletInfoResponseCopyWith<WalletInfoResponse> get copyWith => _$WalletInfoResponseCopyWithImpl<WalletInfoResponse>(this as WalletInfoResponse, _$identity);

  /// Serializes this WalletInfoResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletInfoResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,data);

@override
String toString() {
  return 'WalletInfoResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $WalletInfoResponseCopyWith<$Res>  {
  factory $WalletInfoResponseCopyWith(WalletInfoResponse value, $Res Function(WalletInfoResponse) _then) = _$WalletInfoResponseCopyWithImpl;
@useResult
$Res call({
 String status, String message, WalletInfoData? data
});


$WalletInfoDataCopyWith<$Res>? get data;

}
/// @nodoc
class _$WalletInfoResponseCopyWithImpl<$Res>
    implements $WalletInfoResponseCopyWith<$Res> {
  _$WalletInfoResponseCopyWithImpl(this._self, this._then);

  final WalletInfoResponse _self;
  final $Res Function(WalletInfoResponse) _then;

/// Create a copy of WalletInfoResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? message = null,Object? data = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as WalletInfoData?,
  ));
}
/// Create a copy of WalletInfoResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletInfoDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $WalletInfoDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _WalletInfoResponse implements WalletInfoResponse {
  const _WalletInfoResponse({required this.status, required this.message, this.data});
  factory _WalletInfoResponse.fromJson(Map<String, dynamic> json) => _$WalletInfoResponseFromJson(json);

@override final  String status;
@override final  String message;
@override final  WalletInfoData? data;

/// Create a copy of WalletInfoResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletInfoResponseCopyWith<_WalletInfoResponse> get copyWith => __$WalletInfoResponseCopyWithImpl<_WalletInfoResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletInfoResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletInfoResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,data);

@override
String toString() {
  return 'WalletInfoResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$WalletInfoResponseCopyWith<$Res> implements $WalletInfoResponseCopyWith<$Res> {
  factory _$WalletInfoResponseCopyWith(_WalletInfoResponse value, $Res Function(_WalletInfoResponse) _then) = __$WalletInfoResponseCopyWithImpl;
@override @useResult
$Res call({
 String status, String message, WalletInfoData? data
});


@override $WalletInfoDataCopyWith<$Res>? get data;

}
/// @nodoc
class __$WalletInfoResponseCopyWithImpl<$Res>
    implements _$WalletInfoResponseCopyWith<$Res> {
  __$WalletInfoResponseCopyWithImpl(this._self, this._then);

  final _WalletInfoResponse _self;
  final $Res Function(_WalletInfoResponse) _then;

/// Create a copy of WalletInfoResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? message = null,Object? data = freezed,}) {
  return _then(_WalletInfoResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as WalletInfoData?,
  ));
}

/// Create a copy of WalletInfoResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletInfoDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $WalletInfoDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$WalletInfoData {

@JsonKey(name: 'wallet-id') int get walletId;@JsonKey(name: 'wallet-did') String get walletDid;@JsonKey(name: 'wallet-address') String get walletAddress;
/// Create a copy of WalletInfoData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletInfoDataCopyWith<WalletInfoData> get copyWith => _$WalletInfoDataCopyWithImpl<WalletInfoData>(this as WalletInfoData, _$identity);

  /// Serializes this WalletInfoData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletInfoData&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.walletDid, walletDid) || other.walletDid == walletDid)&&(identical(other.walletAddress, walletAddress) || other.walletAddress == walletAddress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,walletId,walletDid,walletAddress);

@override
String toString() {
  return 'WalletInfoData(walletId: $walletId, walletDid: $walletDid, walletAddress: $walletAddress)';
}


}

/// @nodoc
abstract mixin class $WalletInfoDataCopyWith<$Res>  {
  factory $WalletInfoDataCopyWith(WalletInfoData value, $Res Function(WalletInfoData) _then) = _$WalletInfoDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'wallet-id') int walletId,@JsonKey(name: 'wallet-did') String walletDid,@JsonKey(name: 'wallet-address') String walletAddress
});




}
/// @nodoc
class _$WalletInfoDataCopyWithImpl<$Res>
    implements $WalletInfoDataCopyWith<$Res> {
  _$WalletInfoDataCopyWithImpl(this._self, this._then);

  final WalletInfoData _self;
  final $Res Function(WalletInfoData) _then;

/// Create a copy of WalletInfoData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? walletId = null,Object? walletDid = null,Object? walletAddress = null,}) {
  return _then(_self.copyWith(
walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as int,walletDid: null == walletDid ? _self.walletDid : walletDid // ignore: cast_nullable_to_non_nullable
as String,walletAddress: null == walletAddress ? _self.walletAddress : walletAddress // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _WalletInfoData implements WalletInfoData {
  const _WalletInfoData({@JsonKey(name: 'wallet-id') required this.walletId, @JsonKey(name: 'wallet-did') required this.walletDid, @JsonKey(name: 'wallet-address') required this.walletAddress});
  factory _WalletInfoData.fromJson(Map<String, dynamic> json) => _$WalletInfoDataFromJson(json);

@override@JsonKey(name: 'wallet-id') final  int walletId;
@override@JsonKey(name: 'wallet-did') final  String walletDid;
@override@JsonKey(name: 'wallet-address') final  String walletAddress;

/// Create a copy of WalletInfoData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletInfoDataCopyWith<_WalletInfoData> get copyWith => __$WalletInfoDataCopyWithImpl<_WalletInfoData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletInfoDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletInfoData&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.walletDid, walletDid) || other.walletDid == walletDid)&&(identical(other.walletAddress, walletAddress) || other.walletAddress == walletAddress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,walletId,walletDid,walletAddress);

@override
String toString() {
  return 'WalletInfoData(walletId: $walletId, walletDid: $walletDid, walletAddress: $walletAddress)';
}


}

/// @nodoc
abstract mixin class _$WalletInfoDataCopyWith<$Res> implements $WalletInfoDataCopyWith<$Res> {
  factory _$WalletInfoDataCopyWith(_WalletInfoData value, $Res Function(_WalletInfoData) _then) = __$WalletInfoDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'wallet-id') int walletId,@JsonKey(name: 'wallet-did') String walletDid,@JsonKey(name: 'wallet-address') String walletAddress
});




}
/// @nodoc
class __$WalletInfoDataCopyWithImpl<$Res>
    implements _$WalletInfoDataCopyWith<$Res> {
  __$WalletInfoDataCopyWithImpl(this._self, this._then);

  final _WalletInfoData _self;
  final $Res Function(_WalletInfoData) _then;

/// Create a copy of WalletInfoData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? walletId = null,Object? walletDid = null,Object? walletAddress = null,}) {
  return _then(_WalletInfoData(
walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as int,walletDid: null == walletDid ? _self.walletDid : walletDid // ignore: cast_nullable_to_non_nullable
as String,walletAddress: null == walletAddress ? _self.walletAddress : walletAddress // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
