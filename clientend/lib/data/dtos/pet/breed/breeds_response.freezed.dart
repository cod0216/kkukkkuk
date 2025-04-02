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

 String get status; String get message; List<BreedsData> get data;
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
 String status, String message, List<BreedsData> data
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
as List<BreedsData>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _BreedsResponse implements BreedsResponse {
  const _BreedsResponse({required this.status, required this.message, required final  List<BreedsData> data}): _data = data;
  factory _BreedsResponse.fromJson(Map<String, dynamic> json) => _$BreedsResponseFromJson(json);

@override final  String status;
@override final  String message;
 final  List<BreedsData> _data;
@override List<BreedsData> get data {
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
 String status, String message, List<BreedsData> data
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
as List<BreedsData>,
  ));
}


}


/// @nodoc
mixin _$BreedsData {

 int get id; String get name;
/// Create a copy of BreedsData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BreedsDataCopyWith<BreedsData> get copyWith => _$BreedsDataCopyWithImpl<BreedsData>(this as BreedsData, _$identity);

  /// Serializes this BreedsData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BreedsData&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'BreedsData(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $BreedsDataCopyWith<$Res>  {
  factory $BreedsDataCopyWith(BreedsData value, $Res Function(BreedsData) _then) = _$BreedsDataCopyWithImpl;
@useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class _$BreedsDataCopyWithImpl<$Res>
    implements $BreedsDataCopyWith<$Res> {
  _$BreedsDataCopyWithImpl(this._self, this._then);

  final BreedsData _self;
  final $Res Function(BreedsData) _then;

/// Create a copy of BreedsData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _BreedsData implements BreedsData {
  const _BreedsData({required this.id, required this.name});
  factory _BreedsData.fromJson(Map<String, dynamic> json) => _$BreedsDataFromJson(json);

@override final  int id;
@override final  String name;

/// Create a copy of BreedsData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BreedsDataCopyWith<_BreedsData> get copyWith => __$BreedsDataCopyWithImpl<_BreedsData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BreedsDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BreedsData&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'BreedsData(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$BreedsDataCopyWith<$Res> implements $BreedsDataCopyWith<$Res> {
  factory _$BreedsDataCopyWith(_BreedsData value, $Res Function(_BreedsData) _then) = __$BreedsDataCopyWithImpl;
@override @useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class __$BreedsDataCopyWithImpl<$Res>
    implements _$BreedsDataCopyWith<$Res> {
  __$BreedsDataCopyWithImpl(this._self, this._then);

  final _BreedsData _self;
  final $Res Function(_BreedsData) _then;

/// Create a copy of BreedsData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_BreedsData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
