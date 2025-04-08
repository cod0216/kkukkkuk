// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hospital_info_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HospitalInfoResponse {

 String get status; String get message; List<HospitalInfo> get data;
/// Create a copy of HospitalInfoResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HospitalInfoResponseCopyWith<HospitalInfoResponse> get copyWith => _$HospitalInfoResponseCopyWithImpl<HospitalInfoResponse>(this as HospitalInfoResponse, _$identity);

  /// Serializes this HospitalInfoResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HospitalInfoResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'HospitalInfoResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $HospitalInfoResponseCopyWith<$Res>  {
  factory $HospitalInfoResponseCopyWith(HospitalInfoResponse value, $Res Function(HospitalInfoResponse) _then) = _$HospitalInfoResponseCopyWithImpl;
@useResult
$Res call({
 String status, String message, List<HospitalInfo> data
});




}
/// @nodoc
class _$HospitalInfoResponseCopyWithImpl<$Res>
    implements $HospitalInfoResponseCopyWith<$Res> {
  _$HospitalInfoResponseCopyWithImpl(this._self, this._then);

  final HospitalInfoResponse _self;
  final $Res Function(HospitalInfoResponse) _then;

/// Create a copy of HospitalInfoResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<HospitalInfo>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _HospitalInfoResponse implements HospitalInfoResponse {
  const _HospitalInfoResponse({required this.status, required this.message, required final  List<HospitalInfo> data}): _data = data;
  factory _HospitalInfoResponse.fromJson(Map<String, dynamic> json) => _$HospitalInfoResponseFromJson(json);

@override final  String status;
@override final  String message;
 final  List<HospitalInfo> _data;
@override List<HospitalInfo> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of HospitalInfoResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HospitalInfoResponseCopyWith<_HospitalInfoResponse> get copyWith => __$HospitalInfoResponseCopyWithImpl<_HospitalInfoResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HospitalInfoResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HospitalInfoResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'HospitalInfoResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$HospitalInfoResponseCopyWith<$Res> implements $HospitalInfoResponseCopyWith<$Res> {
  factory _$HospitalInfoResponseCopyWith(_HospitalInfoResponse value, $Res Function(_HospitalInfoResponse) _then) = __$HospitalInfoResponseCopyWithImpl;
@override @useResult
$Res call({
 String status, String message, List<HospitalInfo> data
});




}
/// @nodoc
class __$HospitalInfoResponseCopyWithImpl<$Res>
    implements _$HospitalInfoResponseCopyWith<$Res> {
  __$HospitalInfoResponseCopyWithImpl(this._self, this._then);

  final _HospitalInfoResponse _self;
  final $Res Function(_HospitalInfoResponse) _then;

/// Create a copy of HospitalInfoResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_HospitalInfoResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<HospitalInfo>,
  ));
}


}


/// @nodoc
mixin _$HospitalInfo {

 int get id; String get name; String get address;@JsonKey(name: 'phone_number') String? get phoneNumber;@JsonKey(name: 'x_axis') double get xAxis;// 경도 (longitude)
@JsonKey(name: 'y_axis') double get yAxis;
/// Create a copy of HospitalInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HospitalInfoCopyWith<HospitalInfo> get copyWith => _$HospitalInfoCopyWithImpl<HospitalInfo>(this as HospitalInfo, _$identity);

  /// Serializes this HospitalInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HospitalInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.xAxis, xAxis) || other.xAxis == xAxis)&&(identical(other.yAxis, yAxis) || other.yAxis == yAxis));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,phoneNumber,xAxis,yAxis);

@override
String toString() {
  return 'HospitalInfo(id: $id, name: $name, address: $address, phoneNumber: $phoneNumber, xAxis: $xAxis, yAxis: $yAxis)';
}


}

/// @nodoc
abstract mixin class $HospitalInfoCopyWith<$Res>  {
  factory $HospitalInfoCopyWith(HospitalInfo value, $Res Function(HospitalInfo) _then) = _$HospitalInfoCopyWithImpl;
@useResult
$Res call({
 int id, String name, String address,@JsonKey(name: 'phone_number') String? phoneNumber,@JsonKey(name: 'x_axis') double xAxis,@JsonKey(name: 'y_axis') double yAxis
});




}
/// @nodoc
class _$HospitalInfoCopyWithImpl<$Res>
    implements $HospitalInfoCopyWith<$Res> {
  _$HospitalInfoCopyWithImpl(this._self, this._then);

  final HospitalInfo _self;
  final $Res Function(HospitalInfo) _then;

/// Create a copy of HospitalInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? address = null,Object? phoneNumber = freezed,Object? xAxis = null,Object? yAxis = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,xAxis: null == xAxis ? _self.xAxis : xAxis // ignore: cast_nullable_to_non_nullable
as double,yAxis: null == yAxis ? _self.yAxis : yAxis // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _HospitalInfo implements HospitalInfo {
  const _HospitalInfo({required this.id, required this.name, required this.address, @JsonKey(name: 'phone_number') this.phoneNumber, @JsonKey(name: 'x_axis') required this.xAxis, @JsonKey(name: 'y_axis') required this.yAxis});
  factory _HospitalInfo.fromJson(Map<String, dynamic> json) => _$HospitalInfoFromJson(json);

@override final  int id;
@override final  String name;
@override final  String address;
@override@JsonKey(name: 'phone_number') final  String? phoneNumber;
@override@JsonKey(name: 'x_axis') final  double xAxis;
// 경도 (longitude)
@override@JsonKey(name: 'y_axis') final  double yAxis;

/// Create a copy of HospitalInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HospitalInfoCopyWith<_HospitalInfo> get copyWith => __$HospitalInfoCopyWithImpl<_HospitalInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HospitalInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HospitalInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.xAxis, xAxis) || other.xAxis == xAxis)&&(identical(other.yAxis, yAxis) || other.yAxis == yAxis));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,phoneNumber,xAxis,yAxis);

@override
String toString() {
  return 'HospitalInfo(id: $id, name: $name, address: $address, phoneNumber: $phoneNumber, xAxis: $xAxis, yAxis: $yAxis)';
}


}

/// @nodoc
abstract mixin class _$HospitalInfoCopyWith<$Res> implements $HospitalInfoCopyWith<$Res> {
  factory _$HospitalInfoCopyWith(_HospitalInfo value, $Res Function(_HospitalInfo) _then) = __$HospitalInfoCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String address,@JsonKey(name: 'phone_number') String? phoneNumber,@JsonKey(name: 'x_axis') double xAxis,@JsonKey(name: 'y_axis') double yAxis
});




}
/// @nodoc
class __$HospitalInfoCopyWithImpl<$Res>
    implements _$HospitalInfoCopyWith<$Res> {
  __$HospitalInfoCopyWithImpl(this._self, this._then);

  final _HospitalInfo _self;
  final $Res Function(_HospitalInfo) _then;

/// Create a copy of HospitalInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? address = null,Object? phoneNumber = freezed,Object? xAxis = null,Object? yAxis = null,}) {
  return _then(_HospitalInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,xAxis: null == xAxis ? _self.xAxis : xAxis // ignore: cast_nullable_to_non_nullable
as double,yAxis: null == yAxis ? _self.yAxis : yAxis // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
