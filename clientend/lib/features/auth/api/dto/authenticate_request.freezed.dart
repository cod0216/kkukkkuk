// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authenticate_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthenticateRequest {

 String get name; String get email; String get birthyear; String get birthday; String get gender;@JsonKey(name: 'provider_id') String get providerId;
/// Create a copy of AuthenticateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticateRequestCopyWith<AuthenticateRequest> get copyWith => _$AuthenticateRequestCopyWithImpl<AuthenticateRequest>(this as AuthenticateRequest, _$identity);

  /// Serializes this AuthenticateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticateRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.birthyear, birthyear) || other.birthyear == birthyear)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.providerId, providerId) || other.providerId == providerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,email,birthyear,birthday,gender,providerId);

@override
String toString() {
  return 'AuthenticateRequest(name: $name, email: $email, birthyear: $birthyear, birthday: $birthday, gender: $gender, providerId: $providerId)';
}


}

/// @nodoc
abstract mixin class $AuthenticateRequestCopyWith<$Res>  {
  factory $AuthenticateRequestCopyWith(AuthenticateRequest value, $Res Function(AuthenticateRequest) _then) = _$AuthenticateRequestCopyWithImpl;
@useResult
$Res call({
 String name, String email, String birthyear, String birthday, String gender,@JsonKey(name: 'provider_id') String providerId
});




}
/// @nodoc
class _$AuthenticateRequestCopyWithImpl<$Res>
    implements $AuthenticateRequestCopyWith<$Res> {
  _$AuthenticateRequestCopyWithImpl(this._self, this._then);

  final AuthenticateRequest _self;
  final $Res Function(AuthenticateRequest) _then;

/// Create a copy of AuthenticateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? email = null,Object? birthyear = null,Object? birthday = null,Object? gender = null,Object? providerId = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,birthyear: null == birthyear ? _self.birthyear : birthyear // ignore: cast_nullable_to_non_nullable
as String,birthday: null == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,providerId: null == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _AuthenticateRequest implements AuthenticateRequest {
  const _AuthenticateRequest({required this.name, required this.email, required this.birthyear, required this.birthday, required this.gender, @JsonKey(name: 'provider_id') required this.providerId});
  factory _AuthenticateRequest.fromJson(Map<String, dynamic> json) => _$AuthenticateRequestFromJson(json);

@override final  String name;
@override final  String email;
@override final  String birthyear;
@override final  String birthday;
@override final  String gender;
@override@JsonKey(name: 'provider_id') final  String providerId;

/// Create a copy of AuthenticateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthenticateRequestCopyWith<_AuthenticateRequest> get copyWith => __$AuthenticateRequestCopyWithImpl<_AuthenticateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthenticateRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthenticateRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.birthyear, birthyear) || other.birthyear == birthyear)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.providerId, providerId) || other.providerId == providerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,email,birthyear,birthday,gender,providerId);

@override
String toString() {
  return 'AuthenticateRequest(name: $name, email: $email, birthyear: $birthyear, birthday: $birthday, gender: $gender, providerId: $providerId)';
}


}

/// @nodoc
abstract mixin class _$AuthenticateRequestCopyWith<$Res> implements $AuthenticateRequestCopyWith<$Res> {
  factory _$AuthenticateRequestCopyWith(_AuthenticateRequest value, $Res Function(_AuthenticateRequest) _then) = __$AuthenticateRequestCopyWithImpl;
@override @useResult
$Res call({
 String name, String email, String birthyear, String birthday, String gender,@JsonKey(name: 'provider_id') String providerId
});




}
/// @nodoc
class __$AuthenticateRequestCopyWithImpl<$Res>
    implements _$AuthenticateRequestCopyWith<$Res> {
  __$AuthenticateRequestCopyWithImpl(this._self, this._then);

  final _AuthenticateRequest _self;
  final $Res Function(_AuthenticateRequest) _then;

/// Create a copy of AuthenticateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? email = null,Object? birthyear = null,Object? birthday = null,Object? gender = null,Object? providerId = null,}) {
  return _then(_AuthenticateRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,birthyear: null == birthyear ? _self.birthyear : birthyear // ignore: cast_nullable_to_non_nullable
as String,birthday: null == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,providerId: null == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
