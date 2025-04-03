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

 String get name;
/// Create a copy of WalletUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletUpdateRequestCopyWith<WalletUpdateRequest> get copyWith => _$WalletUpdateRequestCopyWithImpl<WalletUpdateRequest>(this as WalletUpdateRequest, _$identity);

  /// Serializes this WalletUpdateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletUpdateRequest&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'WalletUpdateRequest(name: $name)';
}


}

/// @nodoc
abstract mixin class $WalletUpdateRequestCopyWith<$Res>  {
  factory $WalletUpdateRequestCopyWith(WalletUpdateRequest value, $Res Function(WalletUpdateRequest) _then) = _$WalletUpdateRequestCopyWithImpl;
@useResult
$Res call({
 String name
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
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _WalletUpdateRequest implements WalletUpdateRequest {
  const _WalletUpdateRequest({required this.name});
  factory _WalletUpdateRequest.fromJson(Map<String, dynamic> json) => _$WalletUpdateRequestFromJson(json);

@override final  String name;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletUpdateRequest&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'WalletUpdateRequest(name: $name)';
}


}

/// @nodoc
abstract mixin class _$WalletUpdateRequestCopyWith<$Res> implements $WalletUpdateRequestCopyWith<$Res> {
  factory _$WalletUpdateRequestCopyWith(_WalletUpdateRequest value, $Res Function(_WalletUpdateRequest) _then) = __$WalletUpdateRequestCopyWithImpl;
@override @useResult
$Res call({
 String name
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
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_WalletUpdateRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
