// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_delete_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WalletDeleteResponse {

 String get status; String get message; dynamic get data;
/// Create a copy of WalletDeleteResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletDeleteResponseCopyWith<WalletDeleteResponse> get copyWith => _$WalletDeleteResponseCopyWithImpl<WalletDeleteResponse>(this as WalletDeleteResponse, _$identity);

  /// Serializes this WalletDeleteResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletDeleteResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'WalletDeleteResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $WalletDeleteResponseCopyWith<$Res>  {
  factory $WalletDeleteResponseCopyWith(WalletDeleteResponse value, $Res Function(WalletDeleteResponse) _then) = _$WalletDeleteResponseCopyWithImpl;
@useResult
$Res call({
 String status, String message, dynamic data
});




}
/// @nodoc
class _$WalletDeleteResponseCopyWithImpl<$Res>
    implements $WalletDeleteResponseCopyWith<$Res> {
  _$WalletDeleteResponseCopyWithImpl(this._self, this._then);

  final WalletDeleteResponse _self;
  final $Res Function(WalletDeleteResponse) _then;

/// Create a copy of WalletDeleteResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? message = null,Object? data = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _WalletDeleteResponse implements WalletDeleteResponse {
  const _WalletDeleteResponse({required this.status, required this.message, this.data});
  factory _WalletDeleteResponse.fromJson(Map<String, dynamic> json) => _$WalletDeleteResponseFromJson(json);

@override final  String status;
@override final  String message;
@override final  dynamic data;

/// Create a copy of WalletDeleteResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletDeleteResponseCopyWith<_WalletDeleteResponse> get copyWith => __$WalletDeleteResponseCopyWithImpl<_WalletDeleteResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletDeleteResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletDeleteResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'WalletDeleteResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$WalletDeleteResponseCopyWith<$Res> implements $WalletDeleteResponseCopyWith<$Res> {
  factory _$WalletDeleteResponseCopyWith(_WalletDeleteResponse value, $Res Function(_WalletDeleteResponse) _then) = __$WalletDeleteResponseCopyWithImpl;
@override @useResult
$Res call({
 String status, String message, dynamic data
});




}
/// @nodoc
class __$WalletDeleteResponseCopyWithImpl<$Res>
    implements _$WalletDeleteResponseCopyWith<$Res> {
  __$WalletDeleteResponseCopyWithImpl(this._self, this._then);

  final _WalletDeleteResponse _self;
  final $Res Function(_WalletDeleteResponse) _then;

/// Create a copy of WalletDeleteResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? message = null,Object? data = freezed,}) {
  return _then(_WalletDeleteResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

// dart format on
