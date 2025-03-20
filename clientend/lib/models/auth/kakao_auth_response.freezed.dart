// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kakao_auth_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KakaoAuthResponse {

 String get status; String get message; KakaoAuthData get data;
/// Create a copy of KakaoAuthResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KakaoAuthResponseCopyWith<KakaoAuthResponse> get copyWith => _$KakaoAuthResponseCopyWithImpl<KakaoAuthResponse>(this as KakaoAuthResponse, _$identity);

  /// Serializes this KakaoAuthResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KakaoAuthResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,data);

@override
String toString() {
  return 'KakaoAuthResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $KakaoAuthResponseCopyWith<$Res>  {
  factory $KakaoAuthResponseCopyWith(KakaoAuthResponse value, $Res Function(KakaoAuthResponse) _then) = _$KakaoAuthResponseCopyWithImpl;
@useResult
$Res call({
 String status, String message, KakaoAuthData data
});


$KakaoAuthDataCopyWith<$Res> get data;

}
/// @nodoc
class _$KakaoAuthResponseCopyWithImpl<$Res>
    implements $KakaoAuthResponseCopyWith<$Res> {
  _$KakaoAuthResponseCopyWithImpl(this._self, this._then);

  final KakaoAuthResponse _self;
  final $Res Function(KakaoAuthResponse) _then;

/// Create a copy of KakaoAuthResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as KakaoAuthData,
  ));
}
/// Create a copy of KakaoAuthResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KakaoAuthDataCopyWith<$Res> get data {
  
  return $KakaoAuthDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _KakaoAuthResponse implements KakaoAuthResponse {
  const _KakaoAuthResponse({required this.status, required this.message, required this.data});
  factory _KakaoAuthResponse.fromJson(Map<String, dynamic> json) => _$KakaoAuthResponseFromJson(json);

@override final  String status;
@override final  String message;
@override final  KakaoAuthData data;

/// Create a copy of KakaoAuthResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KakaoAuthResponseCopyWith<_KakaoAuthResponse> get copyWith => __$KakaoAuthResponseCopyWithImpl<_KakaoAuthResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KakaoAuthResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KakaoAuthResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,data);

@override
String toString() {
  return 'KakaoAuthResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$KakaoAuthResponseCopyWith<$Res> implements $KakaoAuthResponseCopyWith<$Res> {
  factory _$KakaoAuthResponseCopyWith(_KakaoAuthResponse value, $Res Function(_KakaoAuthResponse) _then) = __$KakaoAuthResponseCopyWithImpl;
@override @useResult
$Res call({
 String status, String message, KakaoAuthData data
});


@override $KakaoAuthDataCopyWith<$Res> get data;

}
/// @nodoc
class __$KakaoAuthResponseCopyWithImpl<$Res>
    implements _$KakaoAuthResponseCopyWith<$Res> {
  __$KakaoAuthResponseCopyWithImpl(this._self, this._then);

  final _KakaoAuthResponse _self;
  final $Res Function(_KakaoAuthResponse) _then;

/// Create a copy of KakaoAuthResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_KakaoAuthResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as KakaoAuthData,
  ));
}

/// Create a copy of KakaoAuthResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KakaoAuthDataCopyWith<$Res> get data {
  
  return $KakaoAuthDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$KakaoAuthData {

 OwnerInfo get owner; TokenInfo get tokens; WalletInfo? get wallet;
/// Create a copy of KakaoAuthData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KakaoAuthDataCopyWith<KakaoAuthData> get copyWith => _$KakaoAuthDataCopyWithImpl<KakaoAuthData>(this as KakaoAuthData, _$identity);

  /// Serializes this KakaoAuthData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KakaoAuthData&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.tokens, tokens) || other.tokens == tokens)&&(identical(other.wallet, wallet) || other.wallet == wallet));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,owner,tokens,wallet);

@override
String toString() {
  return 'KakaoAuthData(owner: $owner, tokens: $tokens, wallet: $wallet)';
}


}

/// @nodoc
abstract mixin class $KakaoAuthDataCopyWith<$Res>  {
  factory $KakaoAuthDataCopyWith(KakaoAuthData value, $Res Function(KakaoAuthData) _then) = _$KakaoAuthDataCopyWithImpl;
@useResult
$Res call({
 OwnerInfo owner, TokenInfo tokens, WalletInfo? wallet
});


$OwnerInfoCopyWith<$Res> get owner;$TokenInfoCopyWith<$Res> get tokens;$WalletInfoCopyWith<$Res>? get wallet;

}
/// @nodoc
class _$KakaoAuthDataCopyWithImpl<$Res>
    implements $KakaoAuthDataCopyWith<$Res> {
  _$KakaoAuthDataCopyWithImpl(this._self, this._then);

  final KakaoAuthData _self;
  final $Res Function(KakaoAuthData) _then;

/// Create a copy of KakaoAuthData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? owner = null,Object? tokens = null,Object? wallet = freezed,}) {
  return _then(_self.copyWith(
owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as OwnerInfo,tokens: null == tokens ? _self.tokens : tokens // ignore: cast_nullable_to_non_nullable
as TokenInfo,wallet: freezed == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as WalletInfo?,
  ));
}
/// Create a copy of KakaoAuthData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerInfoCopyWith<$Res> get owner {
  
  return $OwnerInfoCopyWith<$Res>(_self.owner, (value) {
    return _then(_self.copyWith(owner: value));
  });
}/// Create a copy of KakaoAuthData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TokenInfoCopyWith<$Res> get tokens {
  
  return $TokenInfoCopyWith<$Res>(_self.tokens, (value) {
    return _then(_self.copyWith(tokens: value));
  });
}/// Create a copy of KakaoAuthData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletInfoCopyWith<$Res>? get wallet {
    if (_self.wallet == null) {
    return null;
  }

  return $WalletInfoCopyWith<$Res>(_self.wallet!, (value) {
    return _then(_self.copyWith(wallet: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _KakaoAuthData implements KakaoAuthData {
  const _KakaoAuthData({required this.owner, required this.tokens, this.wallet});
  factory _KakaoAuthData.fromJson(Map<String, dynamic> json) => _$KakaoAuthDataFromJson(json);

@override final  OwnerInfo owner;
@override final  TokenInfo tokens;
@override final  WalletInfo? wallet;

/// Create a copy of KakaoAuthData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KakaoAuthDataCopyWith<_KakaoAuthData> get copyWith => __$KakaoAuthDataCopyWithImpl<_KakaoAuthData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KakaoAuthDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KakaoAuthData&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.tokens, tokens) || other.tokens == tokens)&&(identical(other.wallet, wallet) || other.wallet == wallet));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,owner,tokens,wallet);

@override
String toString() {
  return 'KakaoAuthData(owner: $owner, tokens: $tokens, wallet: $wallet)';
}


}

/// @nodoc
abstract mixin class _$KakaoAuthDataCopyWith<$Res> implements $KakaoAuthDataCopyWith<$Res> {
  factory _$KakaoAuthDataCopyWith(_KakaoAuthData value, $Res Function(_KakaoAuthData) _then) = __$KakaoAuthDataCopyWithImpl;
@override @useResult
$Res call({
 OwnerInfo owner, TokenInfo tokens, WalletInfo? wallet
});


@override $OwnerInfoCopyWith<$Res> get owner;@override $TokenInfoCopyWith<$Res> get tokens;@override $WalletInfoCopyWith<$Res>? get wallet;

}
/// @nodoc
class __$KakaoAuthDataCopyWithImpl<$Res>
    implements _$KakaoAuthDataCopyWith<$Res> {
  __$KakaoAuthDataCopyWithImpl(this._self, this._then);

  final _KakaoAuthData _self;
  final $Res Function(_KakaoAuthData) _then;

/// Create a copy of KakaoAuthData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? owner = null,Object? tokens = null,Object? wallet = freezed,}) {
  return _then(_KakaoAuthData(
owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as OwnerInfo,tokens: null == tokens ? _self.tokens : tokens // ignore: cast_nullable_to_non_nullable
as TokenInfo,wallet: freezed == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as WalletInfo?,
  ));
}

/// Create a copy of KakaoAuthData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerInfoCopyWith<$Res> get owner {
  
  return $OwnerInfoCopyWith<$Res>(_self.owner, (value) {
    return _then(_self.copyWith(owner: value));
  });
}/// Create a copy of KakaoAuthData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TokenInfoCopyWith<$Res> get tokens {
  
  return $TokenInfoCopyWith<$Res>(_self.tokens, (value) {
    return _then(_self.copyWith(tokens: value));
  });
}/// Create a copy of KakaoAuthData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletInfoCopyWith<$Res>? get wallet {
    if (_self.wallet == null) {
    return null;
  }

  return $WalletInfoCopyWith<$Res>(_self.wallet!, (value) {
    return _then(_self.copyWith(wallet: value));
  });
}
}


/// @nodoc
mixin _$OwnerInfo {

 int get id; String? get did; String get name; String get email;
/// Create a copy of OwnerInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnerInfoCopyWith<OwnerInfo> get copyWith => _$OwnerInfoCopyWithImpl<OwnerInfo>(this as OwnerInfo, _$identity);

  /// Serializes this OwnerInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnerInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.did, did) || other.did == did)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,did,name,email);

@override
String toString() {
  return 'OwnerInfo(id: $id, did: $did, name: $name, email: $email)';
}


}

/// @nodoc
abstract mixin class $OwnerInfoCopyWith<$Res>  {
  factory $OwnerInfoCopyWith(OwnerInfo value, $Res Function(OwnerInfo) _then) = _$OwnerInfoCopyWithImpl;
@useResult
$Res call({
 int id, String? did, String name, String email
});




}
/// @nodoc
class _$OwnerInfoCopyWithImpl<$Res>
    implements $OwnerInfoCopyWith<$Res> {
  _$OwnerInfoCopyWithImpl(this._self, this._then);

  final OwnerInfo _self;
  final $Res Function(OwnerInfo) _then;

/// Create a copy of OwnerInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? did = freezed,Object? name = null,Object? email = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,did: freezed == did ? _self.did : did // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _OwnerInfo implements OwnerInfo {
  const _OwnerInfo({required this.id, this.did, required this.name, required this.email});
  factory _OwnerInfo.fromJson(Map<String, dynamic> json) => _$OwnerInfoFromJson(json);

@override final  int id;
@override final  String? did;
@override final  String name;
@override final  String email;

/// Create a copy of OwnerInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnerInfoCopyWith<_OwnerInfo> get copyWith => __$OwnerInfoCopyWithImpl<_OwnerInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwnerInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwnerInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.did, did) || other.did == did)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,did,name,email);

@override
String toString() {
  return 'OwnerInfo(id: $id, did: $did, name: $name, email: $email)';
}


}

/// @nodoc
abstract mixin class _$OwnerInfoCopyWith<$Res> implements $OwnerInfoCopyWith<$Res> {
  factory _$OwnerInfoCopyWith(_OwnerInfo value, $Res Function(_OwnerInfo) _then) = __$OwnerInfoCopyWithImpl;
@override @useResult
$Res call({
 int id, String? did, String name, String email
});




}
/// @nodoc
class __$OwnerInfoCopyWithImpl<$Res>
    implements _$OwnerInfoCopyWith<$Res> {
  __$OwnerInfoCopyWithImpl(this._self, this._then);

  final _OwnerInfo _self;
  final $Res Function(_OwnerInfo) _then;

/// Create a copy of OwnerInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? did = freezed,Object? name = null,Object? email = null,}) {
  return _then(_OwnerInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,did: freezed == did ? _self.did : did // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TokenInfo {

@JsonKey(name: 'access_token') String get accessToken;@JsonKey(name: 'refresh_token') String get refreshToken;
/// Create a copy of TokenInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TokenInfoCopyWith<TokenInfo> get copyWith => _$TokenInfoCopyWithImpl<TokenInfo>(this as TokenInfo, _$identity);

  /// Serializes this TokenInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TokenInfo&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken);

@override
String toString() {
  return 'TokenInfo(accessToken: $accessToken, refreshToken: $refreshToken)';
}


}

/// @nodoc
abstract mixin class $TokenInfoCopyWith<$Res>  {
  factory $TokenInfoCopyWith(TokenInfo value, $Res Function(TokenInfo) _then) = _$TokenInfoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'access_token') String accessToken,@JsonKey(name: 'refresh_token') String refreshToken
});




}
/// @nodoc
class _$TokenInfoCopyWithImpl<$Res>
    implements $TokenInfoCopyWith<$Res> {
  _$TokenInfoCopyWithImpl(this._self, this._then);

  final TokenInfo _self;
  final $Res Function(TokenInfo) _then;

/// Create a copy of TokenInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? refreshToken = null,}) {
  return _then(_self.copyWith(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _TokenInfo implements TokenInfo {
  const _TokenInfo({@JsonKey(name: 'access_token') required this.accessToken, @JsonKey(name: 'refresh_token') required this.refreshToken});
  factory _TokenInfo.fromJson(Map<String, dynamic> json) => _$TokenInfoFromJson(json);

@override@JsonKey(name: 'access_token') final  String accessToken;
@override@JsonKey(name: 'refresh_token') final  String refreshToken;

/// Create a copy of TokenInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TokenInfoCopyWith<_TokenInfo> get copyWith => __$TokenInfoCopyWithImpl<_TokenInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TokenInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TokenInfo&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken);

@override
String toString() {
  return 'TokenInfo(accessToken: $accessToken, refreshToken: $refreshToken)';
}


}

/// @nodoc
abstract mixin class _$TokenInfoCopyWith<$Res> implements $TokenInfoCopyWith<$Res> {
  factory _$TokenInfoCopyWith(_TokenInfo value, $Res Function(_TokenInfo) _then) = __$TokenInfoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'access_token') String accessToken,@JsonKey(name: 'refresh_token') String refreshToken
});




}
/// @nodoc
class __$TokenInfoCopyWithImpl<$Res>
    implements _$TokenInfoCopyWith<$Res> {
  __$TokenInfoCopyWithImpl(this._self, this._then);

  final _TokenInfo _self;
  final $Res Function(_TokenInfo) _then;

/// Create a copy of TokenInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? refreshToken = null,}) {
  return _then(_TokenInfo(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$WalletInfo {

 int get id; String get did; String get address;
/// Create a copy of WalletInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletInfoCopyWith<WalletInfo> get copyWith => _$WalletInfoCopyWithImpl<WalletInfo>(this as WalletInfo, _$identity);

  /// Serializes this WalletInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.did, did) || other.did == did)&&(identical(other.address, address) || other.address == address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,did,address);

@override
String toString() {
  return 'WalletInfo(id: $id, did: $did, address: $address)';
}


}

/// @nodoc
abstract mixin class $WalletInfoCopyWith<$Res>  {
  factory $WalletInfoCopyWith(WalletInfo value, $Res Function(WalletInfo) _then) = _$WalletInfoCopyWithImpl;
@useResult
$Res call({
 int id, String did, String address
});




}
/// @nodoc
class _$WalletInfoCopyWithImpl<$Res>
    implements $WalletInfoCopyWith<$Res> {
  _$WalletInfoCopyWithImpl(this._self, this._then);

  final WalletInfo _self;
  final $Res Function(WalletInfo) _then;

/// Create a copy of WalletInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? did = null,Object? address = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,did: null == did ? _self.did : did // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _WalletInfo implements WalletInfo {
  const _WalletInfo({required this.id, required this.did, required this.address});
  factory _WalletInfo.fromJson(Map<String, dynamic> json) => _$WalletInfoFromJson(json);

@override final  int id;
@override final  String did;
@override final  String address;

/// Create a copy of WalletInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletInfoCopyWith<_WalletInfo> get copyWith => __$WalletInfoCopyWithImpl<_WalletInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.did, did) || other.did == did)&&(identical(other.address, address) || other.address == address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,did,address);

@override
String toString() {
  return 'WalletInfo(id: $id, did: $did, address: $address)';
}


}

/// @nodoc
abstract mixin class _$WalletInfoCopyWith<$Res> implements $WalletInfoCopyWith<$Res> {
  factory _$WalletInfoCopyWith(_WalletInfo value, $Res Function(_WalletInfo) _then) = __$WalletInfoCopyWithImpl;
@override @useResult
$Res call({
 int id, String did, String address
});




}
/// @nodoc
class __$WalletInfoCopyWithImpl<$Res>
    implements _$WalletInfoCopyWith<$Res> {
  __$WalletInfoCopyWithImpl(this._self, this._then);

  final _WalletInfo _self;
  final $Res Function(_WalletInfo) _then;

/// Create a copy of WalletInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? did = null,Object? address = null,}) {
  return _then(_WalletInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,did: null == did ? _self.did : did // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
