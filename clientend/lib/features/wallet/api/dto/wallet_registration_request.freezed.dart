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

 String get name; String get address;
/// Create a copy of WalletRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletRegistrationRequestCopyWith<WalletRegistrationRequest> get copyWith => _$WalletRegistrationRequestCopyWithImpl<WalletRegistrationRequest>(this as WalletRegistrationRequest, _$identity);

  /// Serializes this WalletRegistrationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletRegistrationRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,address);

@override
String toString() {
  return 'WalletRegistrationRequest(name: $name, address: $address)';
}


}

/// @nodoc
abstract mixin class $WalletRegistrationRequestCopyWith<$Res>  {
  factory $WalletRegistrationRequestCopyWith(WalletRegistrationRequest value, $Res Function(WalletRegistrationRequest) _then) = _$WalletRegistrationRequestCopyWithImpl;
@useResult
$Res call({
 String name, String address
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
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? address = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _WalletRegistrationRequest implements WalletRegistrationRequest {
  const _WalletRegistrationRequest({required this.name, required this.address});
  factory _WalletRegistrationRequest.fromJson(Map<String, dynamic> json) => _$WalletRegistrationRequestFromJson(json);

@override final  String name;
@override final  String address;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletRegistrationRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,address);

@override
String toString() {
  return 'WalletRegistrationRequest(name: $name, address: $address)';
}


}

/// @nodoc
abstract mixin class _$WalletRegistrationRequestCopyWith<$Res> implements $WalletRegistrationRequestCopyWith<$Res> {
  factory _$WalletRegistrationRequestCopyWith(_WalletRegistrationRequest value, $Res Function(_WalletRegistrationRequest) _then) = __$WalletRegistrationRequestCopyWithImpl;
@override @useResult
$Res call({
 String name, String address
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
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? address = null,}) {
  return _then(_WalletRegistrationRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
