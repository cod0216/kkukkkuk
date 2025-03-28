// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_update_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WalletUpdateRequest {

 String get did; String get address;@JsonKey(name: 'public_key') String get publicKey;
/// Create a copy of WalletUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletUpdateRequestCopyWith<WalletUpdateRequest> get copyWith => _$WalletUpdateRequestCopyWithImpl<WalletUpdateRequest>(this as WalletUpdateRequest, _$identity);

  /// Serializes this WalletUpdateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletUpdateRequest&&(identical(other.did, did) || other.did == did)&&(identical(other.address, address) || other.address == address)&&(identical(other.publicKey, publicKey) || other.publicKey == publicKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,did,address,publicKey);

@override
String toString() {
  return 'WalletUpdateRequest(did: $did, address: $address, publicKey: $publicKey)';
}


}

/// @nodoc
abstract mixin class $WalletUpdateRequestCopyWith<$Res>  {
  factory $WalletUpdateRequestCopyWith(WalletUpdateRequest value, $Res Function(WalletUpdateRequest) _then) = _$WalletUpdateRequestCopyWithImpl;
@useResult
$Res call({
 String did, String address,@JsonKey(name: 'public_key') String publicKey
});




}
/// @nodoc
class _$WalletUpdateRequestCopyWithImpl<$Res>
    implements $WalletUpdateRequestCopyWith<$Res> {
  _$WalletUpdateRequestCopyWithImpl(this._self, this._then);

  final WalletUpdateRequest _self;
  final $Res Function(WalletUpdateRequest) _then;

/// Create a copy of WalletUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? did = null,Object? address = null,Object? publicKey = null,}) {
  return _then(_self.copyWith(
did: null == did ? _self.did : did // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,publicKey: null == publicKey ? _self.publicKey : publicKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _WalletUpdateRequest implements WalletUpdateRequest {
  const _WalletUpdateRequest({required this.did, required this.address, @JsonKey(name: 'public_key') required this.publicKey});
  factory _WalletUpdateRequest.fromJson(Map<String, dynamic> json) => _$WalletUpdateRequestFromJson(json);

@override final  String did;
@override final  String address;
@override@JsonKey(name: 'public_key') final  String publicKey;

/// Create a copy of WalletUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletUpdateRequestCopyWith<_WalletUpdateRequest> get copyWith => __$WalletUpdateRequestCopyWithImpl<_WalletUpdateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletUpdateRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletUpdateRequest&&(identical(other.did, did) || other.did == did)&&(identical(other.address, address) || other.address == address)&&(identical(other.publicKey, publicKey) || other.publicKey == publicKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,did,address,publicKey);

@override
String toString() {
  return 'WalletUpdateRequest(did: $did, address: $address, publicKey: $publicKey)';
}


}

/// @nodoc
abstract mixin class _$WalletUpdateRequestCopyWith<$Res> implements $WalletUpdateRequestCopyWith<$Res> {
  factory _$WalletUpdateRequestCopyWith(_WalletUpdateRequest value, $Res Function(_WalletUpdateRequest) _then) = __$WalletUpdateRequestCopyWithImpl;
@override @useResult
$Res call({
 String did, String address,@JsonKey(name: 'public_key') String publicKey
});




}
/// @nodoc
class __$WalletUpdateRequestCopyWithImpl<$Res>
    implements _$WalletUpdateRequestCopyWith<$Res> {
  __$WalletUpdateRequestCopyWithImpl(this._self, this._then);

  final _WalletUpdateRequest _self;
  final $Res Function(_WalletUpdateRequest) _then;

/// Create a copy of WalletUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? did = null,Object? address = null,Object? publicKey = null,}) {
  return _then(_WalletUpdateRequest(
did: null == did ? _self.did : did // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,publicKey: null == publicKey ? _self.publicKey : publicKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
