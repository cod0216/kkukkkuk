// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_update_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserUpdateResponse {

 String get status; String get message; UserUpdateData get data;
/// Create a copy of UserUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserUpdateResponseCopyWith<UserUpdateResponse> get copyWith => _$UserUpdateResponseCopyWithImpl<UserUpdateResponse>(this as UserUpdateResponse, _$identity);

  /// Serializes this UserUpdateResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserUpdateResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,data);

@override
String toString() {
  return 'UserUpdateResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $UserUpdateResponseCopyWith<$Res>  {
  factory $UserUpdateResponseCopyWith(UserUpdateResponse value, $Res Function(UserUpdateResponse) _then) = _$UserUpdateResponseCopyWithImpl;
@useResult
$Res call({
 String status, String message, UserUpdateData data
});


$UserUpdateDataCopyWith<$Res> get data;

}
/// @nodoc
class _$UserUpdateResponseCopyWithImpl<$Res>
    implements $UserUpdateResponseCopyWith<$Res> {
  _$UserUpdateResponseCopyWithImpl(this._self, this._then);

  final UserUpdateResponse _self;
  final $Res Function(UserUpdateResponse) _then;

/// Create a copy of UserUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as UserUpdateData,
  ));
}
/// Create a copy of UserUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserUpdateDataCopyWith<$Res> get data {
  
  return $UserUpdateDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _UserUpdateResponse implements UserUpdateResponse {
  const _UserUpdateResponse({required this.status, required this.message, required this.data});
  factory _UserUpdateResponse.fromJson(Map<String, dynamic> json) => _$UserUpdateResponseFromJson(json);

@override final  String status;
@override final  String message;
@override final  UserUpdateData data;

/// Create a copy of UserUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserUpdateResponseCopyWith<_UserUpdateResponse> get copyWith => __$UserUpdateResponseCopyWithImpl<_UserUpdateResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserUpdateResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserUpdateResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,data);

@override
String toString() {
  return 'UserUpdateResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$UserUpdateResponseCopyWith<$Res> implements $UserUpdateResponseCopyWith<$Res> {
  factory _$UserUpdateResponseCopyWith(_UserUpdateResponse value, $Res Function(_UserUpdateResponse) _then) = __$UserUpdateResponseCopyWithImpl;
@override @useResult
$Res call({
 String status, String message, UserUpdateData data
});


@override $UserUpdateDataCopyWith<$Res> get data;

}
/// @nodoc
class __$UserUpdateResponseCopyWithImpl<$Res>
    implements _$UserUpdateResponseCopyWith<$Res> {
  __$UserUpdateResponseCopyWithImpl(this._self, this._then);

  final _UserUpdateResponse _self;
  final $Res Function(_UserUpdateResponse) _then;

/// Create a copy of UserUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_UserUpdateResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as UserUpdateData,
  ));
}

/// Create a copy of UserUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserUpdateDataCopyWith<$Res> get data {
  
  return $UserUpdateDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$UserUpdateData {

 int get id; String? get did; String get name; String get email; String? get birth;
/// Create a copy of UserUpdateData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserUpdateDataCopyWith<UserUpdateData> get copyWith => _$UserUpdateDataCopyWithImpl<UserUpdateData>(this as UserUpdateData, _$identity);

  /// Serializes this UserUpdateData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserUpdateData&&(identical(other.id, id) || other.id == id)&&(identical(other.did, did) || other.did == did)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.birth, birth) || other.birth == birth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,did,name,email,birth);

@override
String toString() {
  return 'UserUpdateData(id: $id, did: $did, name: $name, email: $email, birth: $birth)';
}


}

/// @nodoc
abstract mixin class $UserUpdateDataCopyWith<$Res>  {
  factory $UserUpdateDataCopyWith(UserUpdateData value, $Res Function(UserUpdateData) _then) = _$UserUpdateDataCopyWithImpl;
@useResult
$Res call({
 int id, String? did, String name, String email, String? birth
});




}
/// @nodoc
class _$UserUpdateDataCopyWithImpl<$Res>
    implements $UserUpdateDataCopyWith<$Res> {
  _$UserUpdateDataCopyWithImpl(this._self, this._then);

  final UserUpdateData _self;
  final $Res Function(UserUpdateData) _then;

/// Create a copy of UserUpdateData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? did = freezed,Object? name = null,Object? email = null,Object? birth = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,did: freezed == did ? _self.did : did // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,birth: freezed == birth ? _self.birth : birth // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _UserUpdateData implements UserUpdateData {
  const _UserUpdateData({required this.id, this.did, required this.name, required this.email, this.birth});
  factory _UserUpdateData.fromJson(Map<String, dynamic> json) => _$UserUpdateDataFromJson(json);

@override final  int id;
@override final  String? did;
@override final  String name;
@override final  String email;
@override final  String? birth;

/// Create a copy of UserUpdateData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserUpdateDataCopyWith<_UserUpdateData> get copyWith => __$UserUpdateDataCopyWithImpl<_UserUpdateData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserUpdateDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserUpdateData&&(identical(other.id, id) || other.id == id)&&(identical(other.did, did) || other.did == did)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.birth, birth) || other.birth == birth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,did,name,email,birth);

@override
String toString() {
  return 'UserUpdateData(id: $id, did: $did, name: $name, email: $email, birth: $birth)';
}


}

/// @nodoc
abstract mixin class _$UserUpdateDataCopyWith<$Res> implements $UserUpdateDataCopyWith<$Res> {
  factory _$UserUpdateDataCopyWith(_UserUpdateData value, $Res Function(_UserUpdateData) _then) = __$UserUpdateDataCopyWithImpl;
@override @useResult
$Res call({
 int id, String? did, String name, String email, String? birth
});




}
/// @nodoc
class __$UserUpdateDataCopyWithImpl<$Res>
    implements _$UserUpdateDataCopyWith<$Res> {
  __$UserUpdateDataCopyWithImpl(this._self, this._then);

  final _UserUpdateData _self;
  final $Res Function(_UserUpdateData) _then;

/// Create a copy of UserUpdateData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? did = freezed,Object? name = null,Object? email = null,Object? birth = freezed,}) {
  return _then(_UserUpdateData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,did: freezed == did ? _self.did : did // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,birth: freezed == birth ? _self.birth : birth // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
