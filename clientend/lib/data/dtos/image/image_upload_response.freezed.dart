// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_upload_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ImageUploadResponse {

 String get data;
/// Create a copy of ImageUploadResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageUploadResponseCopyWith<ImageUploadResponse> get copyWith => _$ImageUploadResponseCopyWithImpl<ImageUploadResponse>(this as ImageUploadResponse, _$identity);

  /// Serializes this ImageUploadResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageUploadResponse&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'ImageUploadResponse(data: $data)';
}


}

/// @nodoc
abstract mixin class $ImageUploadResponseCopyWith<$Res>  {
  factory $ImageUploadResponseCopyWith(ImageUploadResponse value, $Res Function(ImageUploadResponse) _then) = _$ImageUploadResponseCopyWithImpl;
@useResult
$Res call({
 String data
});




}
/// @nodoc
class _$ImageUploadResponseCopyWithImpl<$Res>
    implements $ImageUploadResponseCopyWith<$Res> {
  _$ImageUploadResponseCopyWithImpl(this._self, this._then);

  final ImageUploadResponse _self;
  final $Res Function(ImageUploadResponse) _then;

/// Create a copy of ImageUploadResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ImageUploadResponse implements ImageUploadResponse {
  const _ImageUploadResponse({required this.data});
  factory _ImageUploadResponse.fromJson(Map<String, dynamic> json) => _$ImageUploadResponseFromJson(json);

@override final  String data;

/// Create a copy of ImageUploadResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImageUploadResponseCopyWith<_ImageUploadResponse> get copyWith => __$ImageUploadResponseCopyWithImpl<_ImageUploadResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImageUploadResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImageUploadResponse&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'ImageUploadResponse(data: $data)';
}


}

/// @nodoc
abstract mixin class _$ImageUploadResponseCopyWith<$Res> implements $ImageUploadResponseCopyWith<$Res> {
  factory _$ImageUploadResponseCopyWith(_ImageUploadResponse value, $Res Function(_ImageUploadResponse) _then) = __$ImageUploadResponseCopyWithImpl;
@override @useResult
$Res call({
 String data
});




}
/// @nodoc
class __$ImageUploadResponseCopyWithImpl<$Res>
    implements _$ImageUploadResponseCopyWith<$Res> {
  __$ImageUploadResponseCopyWithImpl(this._self, this._then);

  final _ImageUploadResponse _self;
  final $Res Function(_ImageUploadResponse) _then;

/// Create a copy of ImageUploadResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_ImageUploadResponse(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
