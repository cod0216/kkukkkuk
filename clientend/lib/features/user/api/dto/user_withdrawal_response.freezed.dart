// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_withdrawal_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserWithdrawalResponse {

 String get status; String get message; dynamic get data;
/// Create a copy of UserWithdrawalResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserWithdrawalResponseCopyWith<UserWithdrawalResponse> get copyWith => _$UserWithdrawalResponseCopyWithImpl<UserWithdrawalResponse>(this as UserWithdrawalResponse, _$identity);

  /// Serializes this UserWithdrawalResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserWithdrawalResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'UserWithdrawalResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $UserWithdrawalResponseCopyWith<$Res>  {
  factory $UserWithdrawalResponseCopyWith(UserWithdrawalResponse value, $Res Function(UserWithdrawalResponse) _then) = _$UserWithdrawalResponseCopyWithImpl;
@useResult
$Res call({
 String status, String message, dynamic data
});




}
/// @nodoc
class _$UserWithdrawalResponseCopyWithImpl<$Res>
    implements $UserWithdrawalResponseCopyWith<$Res> {
  _$UserWithdrawalResponseCopyWithImpl(this._self, this._then);

  final UserWithdrawalResponse _self;
  final $Res Function(UserWithdrawalResponse) _then;

/// Create a copy of UserWithdrawalResponse
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

class _UserWithdrawalResponse implements UserWithdrawalResponse {
  const _UserWithdrawalResponse({required this.status, required this.message, this.data});
  factory _UserWithdrawalResponse.fromJson(Map<String, dynamic> json) => _$UserWithdrawalResponseFromJson(json);

@override final  String status;
@override final  String message;
@override final  dynamic data;

/// Create a copy of UserWithdrawalResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserWithdrawalResponseCopyWith<_UserWithdrawalResponse> get copyWith => __$UserWithdrawalResponseCopyWithImpl<_UserWithdrawalResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserWithdrawalResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserWithdrawalResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'UserWithdrawalResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$UserWithdrawalResponseCopyWith<$Res> implements $UserWithdrawalResponseCopyWith<$Res> {
  factory _$UserWithdrawalResponseCopyWith(_UserWithdrawalResponse value, $Res Function(_UserWithdrawalResponse) _then) = __$UserWithdrawalResponseCopyWithImpl;
@override @useResult
$Res call({
 String status, String message, dynamic data
});




}
/// @nodoc
class __$UserWithdrawalResponseCopyWithImpl<$Res>
    implements _$UserWithdrawalResponseCopyWith<$Res> {
  __$UserWithdrawalResponseCopyWithImpl(this._self, this._then);

  final _UserWithdrawalResponse _self;
  final $Res Function(_UserWithdrawalResponse) _then;

/// Create a copy of UserWithdrawalResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? message = null,Object? data = freezed,}) {
  return _then(_UserWithdrawalResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

// dart format on
