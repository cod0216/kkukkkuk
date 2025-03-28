// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_registration_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WalletRegistrationRequest {

 String get did; String get address;@JsonKey(name: 'private_key') String get privateKey;@JsonKey(name: 'public_key') String get publicKey;
/// Create a copy of WalletRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletRegistrationRequestCopyWith<WalletRegistrationRequest> get copyWith => _$WalletRegistrationRequestCopyWithImpl<WalletRegistrationRequest>(this as WalletRegistrationRequest, _$identity);

  /// Serializes this WalletRegistrationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletRegistrationRequest&&(identical(other.did, did) || other.did == did)&&(identical(other.address, address) || other.address == address)&&(identical(other.privateKey, privateKey) || other.privateKey == privateKey)&&(identical(other.publicKey, publicKey) || other.publicKey == publicKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,did,address,privateKey,publicKey);

@override
String toString() {
  return 'WalletRegistrationRequest(did: $did, address: $address, privateKey: $privateKey, publicKey: $publicKey)';
}


}

/// @nodoc
abstract mixin class $WalletRegistrationRequestCopyWith<$Res>  {
  factory $WalletRegistrationRequestCopyWith(WalletRegistrationRequest value, $Res Function(WalletRegistrationRequest) _then) = _$WalletRegistrationRequestCopyWithImpl;
@useResult
$Res call({
 String did, String address,@JsonKey(name: 'private_key') String privateKey,@JsonKey(name: 'public_key') String publicKey
});




}
/// @nodoc
class _$WalletRegistrationRequestCopyWithImpl<$Res>
    implements $WalletRegistrationRequestCopyWith<$Res> {
  _$WalletRegistrationRequestCopyWithImpl(this._self, this._then);

  final WalletRegistrationRequest _self;
  final $Res Function(WalletRegistrationRequest) _then;

/// Create a copy of WalletRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? did = null,Object? address = null,Object? privateKey = null,Object? publicKey = null,}) {
  return _then(_self.copyWith(
did: null == did ? _self.did : did // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,privateKey: null == privateKey ? _self.privateKey : privateKey // ignore: cast_nullable_to_non_nullable
as String,publicKey: null == publicKey ? _self.publicKey : publicKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _WalletRegistrationRequest implements WalletRegistrationRequest {
  const _WalletRegistrationRequest({required this.did, required this.address, @JsonKey(name: 'private_key') required this.privateKey, @JsonKey(name: 'public_key') required this.publicKey});
  factory _WalletRegistrationRequest.fromJson(Map<String, dynamic> json) => _$WalletRegistrationRequestFromJson(json);

@override final  String did;
@override final  String address;
@override@JsonKey(name: 'private_key') final  String privateKey;
@override@JsonKey(name: 'public_key') final  String publicKey;

/// Create a copy of WalletRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletRegistrationRequestCopyWith<_WalletRegistrationRequest> get copyWith => __$WalletRegistrationRequestCopyWithImpl<_WalletRegistrationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletRegistrationRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletRegistrationRequest&&(identical(other.did, did) || other.did == did)&&(identical(other.address, address) || other.address == address)&&(identical(other.privateKey, privateKey) || other.privateKey == privateKey)&&(identical(other.publicKey, publicKey) || other.publicKey == publicKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,did,address,privateKey,publicKey);

@override
String toString() {
  return 'WalletRegistrationRequest(did: $did, address: $address, privateKey: $privateKey, publicKey: $publicKey)';
}


}

/// @nodoc
abstract mixin class _$WalletRegistrationRequestCopyWith<$Res> implements $WalletRegistrationRequestCopyWith<$Res> {
  factory _$WalletRegistrationRequestCopyWith(_WalletRegistrationRequest value, $Res Function(_WalletRegistrationRequest) _then) = __$WalletRegistrationRequestCopyWithImpl;
@override @useResult
$Res call({
 String did, String address,@JsonKey(name: 'private_key') String privateKey,@JsonKey(name: 'public_key') String publicKey
});




}
/// @nodoc
class __$WalletRegistrationRequestCopyWithImpl<$Res>
    implements _$WalletRegistrationRequestCopyWith<$Res> {
  __$WalletRegistrationRequestCopyWithImpl(this._self, this._then);

  final _WalletRegistrationRequest _self;
  final $Res Function(_WalletRegistrationRequest) _then;

/// Create a copy of WalletRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? did = null,Object? address = null,Object? privateKey = null,Object? publicKey = null,}) {
  return _then(_WalletRegistrationRequest(
did: null == did ? _self.did : did // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,privateKey: null == privateKey ? _self.privateKey : privateKey // ignore: cast_nullable_to_non_nullable
as String,publicKey: null == publicKey ? _self.publicKey : publicKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
