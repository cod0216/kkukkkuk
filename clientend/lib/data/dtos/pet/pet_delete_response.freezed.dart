// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pet_delete_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PetDeleteResponse {

 String get status; String get message; dynamic get data;
/// Create a copy of PetDeleteResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PetDeleteResponseCopyWith<PetDeleteResponse> get copyWith => _$PetDeleteResponseCopyWithImpl<PetDeleteResponse>(this as PetDeleteResponse, _$identity);

  /// Serializes this PetDeleteResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PetDeleteResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'PetDeleteResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $PetDeleteResponseCopyWith<$Res>  {
  factory $PetDeleteResponseCopyWith(PetDeleteResponse value, $Res Function(PetDeleteResponse) _then) = _$PetDeleteResponseCopyWithImpl;
@useResult
$Res call({
 String status, String message, dynamic data
});




}
/// @nodoc
class _$PetDeleteResponseCopyWithImpl<$Res>
    implements $PetDeleteResponseCopyWith<$Res> {
  _$PetDeleteResponseCopyWithImpl(this._self, this._then);

  final PetDeleteResponse _self;
  final $Res Function(PetDeleteResponse) _then;

/// Create a copy of PetDeleteResponse
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

class _PetDeleteResponse implements PetDeleteResponse {
  const _PetDeleteResponse({required this.status, required this.message, this.data});
  factory _PetDeleteResponse.fromJson(Map<String, dynamic> json) => _$PetDeleteResponseFromJson(json);

@override final  String status;
@override final  String message;
@override final  dynamic data;

/// Create a copy of PetDeleteResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PetDeleteResponseCopyWith<_PetDeleteResponse> get copyWith => __$PetDeleteResponseCopyWithImpl<_PetDeleteResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PetDeleteResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PetDeleteResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'PetDeleteResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$PetDeleteResponseCopyWith<$Res> implements $PetDeleteResponseCopyWith<$Res> {
  factory _$PetDeleteResponseCopyWith(_PetDeleteResponse value, $Res Function(_PetDeleteResponse) _then) = __$PetDeleteResponseCopyWithImpl;
@override @useResult
$Res call({
 String status, String message, dynamic data
});




}
/// @nodoc
class __$PetDeleteResponseCopyWithImpl<$Res>
    implements _$PetDeleteResponseCopyWith<$Res> {
  __$PetDeleteResponseCopyWithImpl(this._self, this._then);

  final _PetDeleteResponse _self;
  final $Res Function(_PetDeleteResponse) _then;

/// Create a copy of PetDeleteResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? message = null,Object? data = freezed,}) {
  return _then(_PetDeleteResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

// dart format on
