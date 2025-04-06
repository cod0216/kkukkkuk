// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'breeds_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BreedsResponse {

 String get status; String get message; List<Breed> get data;
/// Create a copy of BreedsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BreedsResponseCopyWith<BreedsResponse> get copyWith => _$BreedsResponseCopyWithImpl<BreedsResponse>(this as BreedsResponse, _$identity);

  /// Serializes this BreedsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BreedsResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'BreedsResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $BreedsResponseCopyWith<$Res>  {
  factory $BreedsResponseCopyWith(BreedsResponse value, $Res Function(BreedsResponse) _then) = _$BreedsResponseCopyWithImpl;
@useResult
$Res call({
 String status, String message, List<Breed> data
});




}
/// @nodoc
class _$BreedsResponseCopyWithImpl<$Res>
    implements $BreedsResponseCopyWith<$Res> {
  _$BreedsResponseCopyWithImpl(this._self, this._then);

  final BreedsResponse _self;
  final $Res Function(BreedsResponse) _then;

/// Create a copy of BreedsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<Breed>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _BreedsResponse implements BreedsResponse {
  const _BreedsResponse({required this.status, required this.message, required final  List<Breed> data}): _data = data;
  factory _BreedsResponse.fromJson(Map<String, dynamic> json) => _$BreedsResponseFromJson(json);

@override final  String status;
@override final  String message;
 final  List<Breed> _data;
@override List<Breed> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of BreedsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BreedsResponseCopyWith<_BreedsResponse> get copyWith => __$BreedsResponseCopyWithImpl<_BreedsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BreedsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BreedsResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'BreedsResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$BreedsResponseCopyWith<$Res> implements $BreedsResponseCopyWith<$Res> {
  factory _$BreedsResponseCopyWith(_BreedsResponse value, $Res Function(_BreedsResponse) _then) = __$BreedsResponseCopyWithImpl;
@override @useResult
$Res call({
 String status, String message, List<Breed> data
});




}
/// @nodoc
class __$BreedsResponseCopyWithImpl<$Res>
    implements _$BreedsResponseCopyWith<$Res> {
  __$BreedsResponseCopyWithImpl(this._self, this._then);

  final _BreedsResponse _self;
  final $Res Function(_BreedsResponse) _then;

/// Create a copy of BreedsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_BreedsResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<Breed>,
  ));
}


}

// dart format on
