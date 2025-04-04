// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_update_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserUpdateRequest {

 String? get name; String? get birth;
/// Create a copy of UserUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserUpdateRequestCopyWith<UserUpdateRequest> get copyWith => _$UserUpdateRequestCopyWithImpl<UserUpdateRequest>(this as UserUpdateRequest, _$identity);

  /// Serializes this UserUpdateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserUpdateRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.birth, birth) || other.birth == birth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,birth);

@override
String toString() {
  return 'UserUpdateRequest(name: $name, birth: $birth)';
}


}

/// @nodoc
abstract mixin class $UserUpdateRequestCopyWith<$Res>  {
  factory $UserUpdateRequestCopyWith(UserUpdateRequest value, $Res Function(UserUpdateRequest) _then) = _$UserUpdateRequestCopyWithImpl;
@useResult
$Res call({
 String? name, String? birth
});




}
/// @nodoc
class _$UserUpdateRequestCopyWithImpl<$Res>
    implements $UserUpdateRequestCopyWith<$Res> {
  _$UserUpdateRequestCopyWithImpl(this._self, this._then);

  final UserUpdateRequest _self;
  final $Res Function(UserUpdateRequest) _then;

/// Create a copy of UserUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? birth = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,birth: freezed == birth ? _self.birth : birth // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _UserUpdateRequest implements UserUpdateRequest {
  const _UserUpdateRequest({this.name, this.birth});
  factory _UserUpdateRequest.fromJson(Map<String, dynamic> json) => _$UserUpdateRequestFromJson(json);

@override final  String? name;
@override final  String? birth;

/// Create a copy of UserUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserUpdateRequestCopyWith<_UserUpdateRequest> get copyWith => __$UserUpdateRequestCopyWithImpl<_UserUpdateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserUpdateRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserUpdateRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.birth, birth) || other.birth == birth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,birth);

@override
String toString() {
  return 'UserUpdateRequest(name: $name, birth: $birth)';
}


}

/// @nodoc
abstract mixin class _$UserUpdateRequestCopyWith<$Res> implements $UserUpdateRequestCopyWith<$Res> {
  factory _$UserUpdateRequestCopyWith(_UserUpdateRequest value, $Res Function(_UserUpdateRequest) _then) = __$UserUpdateRequestCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? birth
});




}
/// @nodoc
class __$UserUpdateRequestCopyWithImpl<$Res>
    implements _$UserUpdateRequestCopyWith<$Res> {
  __$UserUpdateRequestCopyWithImpl(this._self, this._then);

  final _UserUpdateRequest _self;
  final $Res Function(_UserUpdateRequest) _then;

/// Create a copy of UserUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? birth = freezed,}) {
  return _then(_UserUpdateRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,birth: freezed == birth ? _self.birth : birth // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
