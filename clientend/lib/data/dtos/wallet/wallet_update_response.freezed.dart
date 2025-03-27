// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_update_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WalletUpdateResponse {

 String get status; String get message; WalletData get data;
/// Create a copy of WalletUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletUpdateResponseCopyWith<WalletUpdateResponse> get copyWith => _$WalletUpdateResponseCopyWithImpl<WalletUpdateResponse>(this as WalletUpdateResponse, _$identity);

  /// Serializes this WalletUpdateResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletUpdateResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,data);

@override
String toString() {
  return 'WalletUpdateResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $WalletUpdateResponseCopyWith<$Res>  {
  factory $WalletUpdateResponseCopyWith(WalletUpdateResponse value, $Res Function(WalletUpdateResponse) _then) = _$WalletUpdateResponseCopyWithImpl;
@useResult
$Res call({
 String status, String message, WalletData data
});


$WalletDataCopyWith<$Res> get data;

}
/// @nodoc
class _$WalletUpdateResponseCopyWithImpl<$Res>
    implements $WalletUpdateResponseCopyWith<$Res> {
  _$WalletUpdateResponseCopyWithImpl(this._self, this._then);

  final WalletUpdateResponse _self;
  final $Res Function(WalletUpdateResponse) _then;

/// Create a copy of WalletUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as WalletData,
  ));
}
/// Create a copy of WalletUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletDataCopyWith<$Res> get data {
  
  return $WalletDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _WalletUpdateResponse implements WalletUpdateResponse {
  const _WalletUpdateResponse({required this.status, required this.message, required this.data});
  factory _WalletUpdateResponse.fromJson(Map<String, dynamic> json) => _$WalletUpdateResponseFromJson(json);

@override final  String status;
@override final  String message;
@override final  WalletData data;

/// Create a copy of WalletUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletUpdateResponseCopyWith<_WalletUpdateResponse> get copyWith => __$WalletUpdateResponseCopyWithImpl<_WalletUpdateResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletUpdateResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletUpdateResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,data);

@override
String toString() {
  return 'WalletUpdateResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$WalletUpdateResponseCopyWith<$Res> implements $WalletUpdateResponseCopyWith<$Res> {
  factory _$WalletUpdateResponseCopyWith(_WalletUpdateResponse value, $Res Function(_WalletUpdateResponse) _then) = __$WalletUpdateResponseCopyWithImpl;
@override @useResult
$Res call({
 String status, String message, WalletData data
});


@override $WalletDataCopyWith<$Res> get data;

}
/// @nodoc
class __$WalletUpdateResponseCopyWithImpl<$Res>
    implements _$WalletUpdateResponseCopyWith<$Res> {
  __$WalletUpdateResponseCopyWithImpl(this._self, this._then);

  final _WalletUpdateResponse _self;
  final $Res Function(_WalletUpdateResponse) _then;

/// Create a copy of WalletUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_WalletUpdateResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as WalletData,
  ));
}

/// Create a copy of WalletUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletDataCopyWith<$Res> get data {
  
  return $WalletDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

// dart format on
