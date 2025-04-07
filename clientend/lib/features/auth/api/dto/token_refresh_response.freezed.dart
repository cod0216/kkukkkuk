// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'token_refresh_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TokenRefreshResponse {

 String get status; String get message; TokenRefreshData get data;
/// Create a copy of TokenRefreshResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TokenRefreshResponseCopyWith<TokenRefreshResponse> get copyWith => _$TokenRefreshResponseCopyWithImpl<TokenRefreshResponse>(this as TokenRefreshResponse, _$identity);

  /// Serializes this TokenRefreshResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TokenRefreshResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,data);

@override
String toString() {
  return 'TokenRefreshResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $TokenRefreshResponseCopyWith<$Res>  {
  factory $TokenRefreshResponseCopyWith(TokenRefreshResponse value, $Res Function(TokenRefreshResponse) _then) = _$TokenRefreshResponseCopyWithImpl;
@useResult
$Res call({
 String status, String message, TokenRefreshData data
});


$TokenRefreshDataCopyWith<$Res> get data;

}
/// @nodoc
class _$TokenRefreshResponseCopyWithImpl<$Res>
    implements $TokenRefreshResponseCopyWith<$Res> {
  _$TokenRefreshResponseCopyWithImpl(this._self, this._then);

  final TokenRefreshResponse _self;
  final $Res Function(TokenRefreshResponse) _then;

/// Create a copy of TokenRefreshResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as TokenRefreshData,
  ));
}
/// Create a copy of TokenRefreshResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TokenRefreshDataCopyWith<$Res> get data {
  
  return $TokenRefreshDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _TokenRefreshResponse implements TokenRefreshResponse {
  const _TokenRefreshResponse({required this.status, required this.message, required this.data});
  factory _TokenRefreshResponse.fromJson(Map<String, dynamic> json) => _$TokenRefreshResponseFromJson(json);

@override final  String status;
@override final  String message;
@override final  TokenRefreshData data;

/// Create a copy of TokenRefreshResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TokenRefreshResponseCopyWith<_TokenRefreshResponse> get copyWith => __$TokenRefreshResponseCopyWithImpl<_TokenRefreshResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TokenRefreshResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TokenRefreshResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,data);

@override
String toString() {
  return 'TokenRefreshResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$TokenRefreshResponseCopyWith<$Res> implements $TokenRefreshResponseCopyWith<$Res> {
  factory _$TokenRefreshResponseCopyWith(_TokenRefreshResponse value, $Res Function(_TokenRefreshResponse) _then) = __$TokenRefreshResponseCopyWithImpl;
@override @useResult
$Res call({
 String status, String message, TokenRefreshData data
});


@override $TokenRefreshDataCopyWith<$Res> get data;

}
/// @nodoc
class __$TokenRefreshResponseCopyWithImpl<$Res>
    implements _$TokenRefreshResponseCopyWith<$Res> {
  __$TokenRefreshResponseCopyWithImpl(this._self, this._then);

  final _TokenRefreshResponse _self;
  final $Res Function(_TokenRefreshResponse) _then;

/// Create a copy of TokenRefreshResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_TokenRefreshResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as TokenRefreshData,
  ));
}

/// Create a copy of TokenRefreshResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TokenRefreshDataCopyWith<$Res> get data {
  
  return $TokenRefreshDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$TokenRefreshData {

@JsonKey(name: 'access_token') String get accessToken;@JsonKey(name: 'refresh_token') String get refreshToken;
/// Create a copy of TokenRefreshData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TokenRefreshDataCopyWith<TokenRefreshData> get copyWith => _$TokenRefreshDataCopyWithImpl<TokenRefreshData>(this as TokenRefreshData, _$identity);

  /// Serializes this TokenRefreshData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TokenRefreshData&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken);

@override
String toString() {
  return 'TokenRefreshData(accessToken: $accessToken, refreshToken: $refreshToken)';
}


}

/// @nodoc
abstract mixin class $TokenRefreshDataCopyWith<$Res>  {
  factory $TokenRefreshDataCopyWith(TokenRefreshData value, $Res Function(TokenRefreshData) _then) = _$TokenRefreshDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'access_token') String accessToken,@JsonKey(name: 'refresh_token') String refreshToken
});




}
/// @nodoc
class _$TokenRefreshDataCopyWithImpl<$Res>
    implements $TokenRefreshDataCopyWith<$Res> {
  _$TokenRefreshDataCopyWithImpl(this._self, this._then);

  final TokenRefreshData _self;
  final $Res Function(TokenRefreshData) _then;

/// Create a copy of TokenRefreshData
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

class _TokenRefreshData implements TokenRefreshData {
  const _TokenRefreshData({@JsonKey(name: 'access_token') required this.accessToken, @JsonKey(name: 'refresh_token') required this.refreshToken});
  factory _TokenRefreshData.fromJson(Map<String, dynamic> json) => _$TokenRefreshDataFromJson(json);

@override@JsonKey(name: 'access_token') final  String accessToken;
@override@JsonKey(name: 'refresh_token') final  String refreshToken;

/// Create a copy of TokenRefreshData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TokenRefreshDataCopyWith<_TokenRefreshData> get copyWith => __$TokenRefreshDataCopyWithImpl<_TokenRefreshData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TokenRefreshDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TokenRefreshData&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken);

@override
String toString() {
  return 'TokenRefreshData(accessToken: $accessToken, refreshToken: $refreshToken)';
}


}

/// @nodoc
abstract mixin class _$TokenRefreshDataCopyWith<$Res> implements $TokenRefreshDataCopyWith<$Res> {
  factory _$TokenRefreshDataCopyWith(_TokenRefreshData value, $Res Function(_TokenRefreshData) _then) = __$TokenRefreshDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'access_token') String accessToken,@JsonKey(name: 'refresh_token') String refreshToken
});




}
/// @nodoc
class __$TokenRefreshDataCopyWithImpl<$Res>
    implements _$TokenRefreshDataCopyWith<$Res> {
  __$TokenRefreshDataCopyWithImpl(this._self, this._then);

  final _TokenRefreshData _self;
  final $Res Function(_TokenRefreshData) _then;

/// Create a copy of TokenRefreshData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? refreshToken = null,}) {
  return _then(_TokenRefreshData(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
