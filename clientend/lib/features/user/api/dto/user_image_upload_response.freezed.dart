// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_image_upload_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserImageUploadResponse {

 String get status; String get message; UserImageUploadData get data;
/// Create a copy of UserImageUploadResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserImageUploadResponseCopyWith<UserImageUploadResponse> get copyWith => _$UserImageUploadResponseCopyWithImpl<UserImageUploadResponse>(this as UserImageUploadResponse, _$identity);

  /// Serializes this UserImageUploadResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserImageUploadResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,data);

@override
String toString() {
  return 'UserImageUploadResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $UserImageUploadResponseCopyWith<$Res>  {
  factory $UserImageUploadResponseCopyWith(UserImageUploadResponse value, $Res Function(UserImageUploadResponse) _then) = _$UserImageUploadResponseCopyWithImpl;
@useResult
$Res call({
 String status, String message, UserImageUploadData data
});


$UserImageUploadDataCopyWith<$Res> get data;

}
/// @nodoc
class _$UserImageUploadResponseCopyWithImpl<$Res>
    implements $UserImageUploadResponseCopyWith<$Res> {
  _$UserImageUploadResponseCopyWithImpl(this._self, this._then);

  final UserImageUploadResponse _self;
  final $Res Function(UserImageUploadResponse) _then;

/// Create a copy of UserImageUploadResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as UserImageUploadData,
  ));
}
/// Create a copy of UserImageUploadResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserImageUploadDataCopyWith<$Res> get data {
  
  return $UserImageUploadDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _UserImageUploadResponse implements UserImageUploadResponse {
  const _UserImageUploadResponse({required this.status, required this.message, required this.data});
  factory _UserImageUploadResponse.fromJson(Map<String, dynamic> json) => _$UserImageUploadResponseFromJson(json);

@override final  String status;
@override final  String message;
@override final  UserImageUploadData data;

/// Create a copy of UserImageUploadResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserImageUploadResponseCopyWith<_UserImageUploadResponse> get copyWith => __$UserImageUploadResponseCopyWithImpl<_UserImageUploadResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserImageUploadResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserImageUploadResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,data);

@override
String toString() {
  return 'UserImageUploadResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$UserImageUploadResponseCopyWith<$Res> implements $UserImageUploadResponseCopyWith<$Res> {
  factory _$UserImageUploadResponseCopyWith(_UserImageUploadResponse value, $Res Function(_UserImageUploadResponse) _then) = __$UserImageUploadResponseCopyWithImpl;
@override @useResult
$Res call({
 String status, String message, UserImageUploadData data
});


@override $UserImageUploadDataCopyWith<$Res> get data;

}
/// @nodoc
class __$UserImageUploadResponseCopyWithImpl<$Res>
    implements _$UserImageUploadResponseCopyWith<$Res> {
  __$UserImageUploadResponseCopyWithImpl(this._self, this._then);

  final _UserImageUploadResponse _self;
  final $Res Function(_UserImageUploadResponse) _then;

/// Create a copy of UserImageUploadResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_UserImageUploadResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as UserImageUploadData,
  ));
}

/// Create a copy of UserImageUploadResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserImageUploadDataCopyWith<$Res> get data {
  
  return $UserImageUploadDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$UserImageUploadData {

 String get image;
/// Create a copy of UserImageUploadData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserImageUploadDataCopyWith<UserImageUploadData> get copyWith => _$UserImageUploadDataCopyWithImpl<UserImageUploadData>(this as UserImageUploadData, _$identity);

  /// Serializes this UserImageUploadData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserImageUploadData&&(identical(other.image, image) || other.image == image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,image);

@override
String toString() {
  return 'UserImageUploadData(image: $image)';
}


}

/// @nodoc
abstract mixin class $UserImageUploadDataCopyWith<$Res>  {
  factory $UserImageUploadDataCopyWith(UserImageUploadData value, $Res Function(UserImageUploadData) _then) = _$UserImageUploadDataCopyWithImpl;
@useResult
$Res call({
 String image
});




}
/// @nodoc
class _$UserImageUploadDataCopyWithImpl<$Res>
    implements $UserImageUploadDataCopyWith<$Res> {
  _$UserImageUploadDataCopyWithImpl(this._self, this._then);

  final UserImageUploadData _self;
  final $Res Function(UserImageUploadData) _then;

/// Create a copy of UserImageUploadData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? image = null,}) {
  return _then(_self.copyWith(
image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _UserImageUploadData implements UserImageUploadData {
  const _UserImageUploadData({required this.image});
  factory _UserImageUploadData.fromJson(Map<String, dynamic> json) => _$UserImageUploadDataFromJson(json);

@override final  String image;

/// Create a copy of UserImageUploadData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserImageUploadDataCopyWith<_UserImageUploadData> get copyWith => __$UserImageUploadDataCopyWithImpl<_UserImageUploadData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserImageUploadDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserImageUploadData&&(identical(other.image, image) || other.image == image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,image);

@override
String toString() {
  return 'UserImageUploadData(image: $image)';
}


}

/// @nodoc
abstract mixin class _$UserImageUploadDataCopyWith<$Res> implements $UserImageUploadDataCopyWith<$Res> {
  factory _$UserImageUploadDataCopyWith(_UserImageUploadData value, $Res Function(_UserImageUploadData) _then) = __$UserImageUploadDataCopyWithImpl;
@override @useResult
$Res call({
 String image
});




}
/// @nodoc
class __$UserImageUploadDataCopyWithImpl<$Res>
    implements _$UserImageUploadDataCopyWith<$Res> {
  __$UserImageUploadDataCopyWithImpl(this._self, this._then);

  final _UserImageUploadData _self;
  final $Res Function(_UserImageUploadData) _then;

/// Create a copy of UserImageUploadData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? image = null,}) {
  return _then(_UserImageUploadData(
image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
