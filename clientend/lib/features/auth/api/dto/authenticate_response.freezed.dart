// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authenticate_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthenticateResponse {

 String get status; String get message; AuthenticateData get data;
/// Create a copy of AuthenticateResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticateResponseCopyWith<AuthenticateResponse> get copyWith => _$AuthenticateResponseCopyWithImpl<AuthenticateResponse>(this as AuthenticateResponse, _$identity);

  /// Serializes this AuthenticateResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticateResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,data);

@override
String toString() {
  return 'AuthenticateResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $AuthenticateResponseCopyWith<$Res>  {
  factory $AuthenticateResponseCopyWith(AuthenticateResponse value, $Res Function(AuthenticateResponse) _then) = _$AuthenticateResponseCopyWithImpl;
@useResult
$Res call({
 String status, String message, AuthenticateData data
});


$AuthenticateDataCopyWith<$Res> get data;

}
/// @nodoc
class _$AuthenticateResponseCopyWithImpl<$Res>
    implements $AuthenticateResponseCopyWith<$Res> {
  _$AuthenticateResponseCopyWithImpl(this._self, this._then);

  final AuthenticateResponse _self;
  final $Res Function(AuthenticateResponse) _then;

/// Create a copy of AuthenticateResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AuthenticateData,
  ));
}
/// Create a copy of AuthenticateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthenticateDataCopyWith<$Res> get data {
  
  return $AuthenticateDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _AuthenticateResponse implements AuthenticateResponse {
  const _AuthenticateResponse({required this.status, required this.message, required this.data});
  factory _AuthenticateResponse.fromJson(Map<String, dynamic> json) => _$AuthenticateResponseFromJson(json);

@override final  String status;
@override final  String message;
@override final  AuthenticateData data;

/// Create a copy of AuthenticateResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthenticateResponseCopyWith<_AuthenticateResponse> get copyWith => __$AuthenticateResponseCopyWithImpl<_AuthenticateResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthenticateResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthenticateResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,data);

@override
String toString() {
  return 'AuthenticateResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$AuthenticateResponseCopyWith<$Res> implements $AuthenticateResponseCopyWith<$Res> {
  factory _$AuthenticateResponseCopyWith(_AuthenticateResponse value, $Res Function(_AuthenticateResponse) _then) = __$AuthenticateResponseCopyWithImpl;
@override @useResult
$Res call({
 String status, String message, AuthenticateData data
});


@override $AuthenticateDataCopyWith<$Res> get data;

}
/// @nodoc
class __$AuthenticateResponseCopyWithImpl<$Res>
    implements _$AuthenticateResponseCopyWith<$Res> {
  __$AuthenticateResponseCopyWithImpl(this._self, this._then);

  final _AuthenticateResponse _self;
  final $Res Function(_AuthenticateResponse) _then;

/// Create a copy of AuthenticateResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_AuthenticateResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AuthenticateData,
  ));
}

/// Create a copy of AuthenticateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthenticateDataCopyWith<$Res> get data {
  
  return $AuthenticateDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$AuthenticateData {

 OwnerInfo get owner; TokenInfo get tokens; List<WalletInfo>? get wallets;
/// Create a copy of AuthenticateData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticateDataCopyWith<AuthenticateData> get copyWith => _$AuthenticateDataCopyWithImpl<AuthenticateData>(this as AuthenticateData, _$identity);

  /// Serializes this AuthenticateData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticateData&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.tokens, tokens) || other.tokens == tokens)&&const DeepCollectionEquality().equals(other.wallets, wallets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,owner,tokens,const DeepCollectionEquality().hash(wallets));

@override
String toString() {
  return 'AuthenticateData(owner: $owner, tokens: $tokens, wallets: $wallets)';
}


}

/// @nodoc
abstract mixin class $AuthenticateDataCopyWith<$Res>  {
  factory $AuthenticateDataCopyWith(AuthenticateData value, $Res Function(AuthenticateData) _then) = _$AuthenticateDataCopyWithImpl;
@useResult
$Res call({
 OwnerInfo owner, TokenInfo tokens, List<WalletInfo>? wallets
});


$OwnerInfoCopyWith<$Res> get owner;$TokenInfoCopyWith<$Res> get tokens;

}
/// @nodoc
class _$AuthenticateDataCopyWithImpl<$Res>
    implements $AuthenticateDataCopyWith<$Res> {
  _$AuthenticateDataCopyWithImpl(this._self, this._then);

  final AuthenticateData _self;
  final $Res Function(AuthenticateData) _then;

/// Create a copy of AuthenticateData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? owner = null,Object? tokens = null,Object? wallets = freezed,}) {
  return _then(_self.copyWith(
owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as OwnerInfo,tokens: null == tokens ? _self.tokens : tokens // ignore: cast_nullable_to_non_nullable
as TokenInfo,wallets: freezed == wallets ? _self.wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<WalletInfo>?,
  ));
}
/// Create a copy of AuthenticateData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerInfoCopyWith<$Res> get owner {
  
  return $OwnerInfoCopyWith<$Res>(_self.owner, (value) {
    return _then(_self.copyWith(owner: value));
  });
}/// Create a copy of AuthenticateData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TokenInfoCopyWith<$Res> get tokens {
  
  return $TokenInfoCopyWith<$Res>(_self.tokens, (value) {
    return _then(_self.copyWith(tokens: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _AuthenticateData implements AuthenticateData {
  const _AuthenticateData({required this.owner, required this.tokens, final  List<WalletInfo>? wallets}): _wallets = wallets;
  factory _AuthenticateData.fromJson(Map<String, dynamic> json) => _$AuthenticateDataFromJson(json);

@override final  OwnerInfo owner;
@override final  TokenInfo tokens;
 final  List<WalletInfo>? _wallets;
@override List<WalletInfo>? get wallets {
  final value = _wallets;
  if (value == null) return null;
  if (_wallets is EqualUnmodifiableListView) return _wallets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of AuthenticateData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthenticateDataCopyWith<_AuthenticateData> get copyWith => __$AuthenticateDataCopyWithImpl<_AuthenticateData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthenticateDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthenticateData&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.tokens, tokens) || other.tokens == tokens)&&const DeepCollectionEquality().equals(other._wallets, _wallets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,owner,tokens,const DeepCollectionEquality().hash(_wallets));

@override
String toString() {
  return 'AuthenticateData(owner: $owner, tokens: $tokens, wallets: $wallets)';
}


}

/// @nodoc
abstract mixin class _$AuthenticateDataCopyWith<$Res> implements $AuthenticateDataCopyWith<$Res> {
  factory _$AuthenticateDataCopyWith(_AuthenticateData value, $Res Function(_AuthenticateData) _then) = __$AuthenticateDataCopyWithImpl;
@override @useResult
$Res call({
 OwnerInfo owner, TokenInfo tokens, List<WalletInfo>? wallets
});


@override $OwnerInfoCopyWith<$Res> get owner;@override $TokenInfoCopyWith<$Res> get tokens;

}
/// @nodoc
class __$AuthenticateDataCopyWithImpl<$Res>
    implements _$AuthenticateDataCopyWith<$Res> {
  __$AuthenticateDataCopyWithImpl(this._self, this._then);

  final _AuthenticateData _self;
  final $Res Function(_AuthenticateData) _then;

/// Create a copy of AuthenticateData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? owner = null,Object? tokens = null,Object? wallets = freezed,}) {
  return _then(_AuthenticateData(
owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as OwnerInfo,tokens: null == tokens ? _self.tokens : tokens // ignore: cast_nullable_to_non_nullable
as TokenInfo,wallets: freezed == wallets ? _self._wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<WalletInfo>?,
  ));
}

/// Create a copy of AuthenticateData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerInfoCopyWith<$Res> get owner {
  
  return $OwnerInfoCopyWith<$Res>(_self.owner, (value) {
    return _then(_self.copyWith(owner: value));
  });
}/// Create a copy of AuthenticateData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TokenInfoCopyWith<$Res> get tokens {
  
  return $TokenInfoCopyWith<$Res>(_self.tokens, (value) {
    return _then(_self.copyWith(tokens: value));
  });
}
}

// dart format on
