// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hospital.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Hospital {

 int get id; String get name; String get address;@JsonKey(name: 'phone_number') String? get phoneNumber;@JsonKey(name: 'x_axis') double get xAxis;// 경도 (longitude)
@JsonKey(name: 'y_axis') double get yAxis;
/// Create a copy of Hospital
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HospitalCopyWith<Hospital> get copyWith => _$HospitalCopyWithImpl<Hospital>(this as Hospital, _$identity);

  /// Serializes this Hospital to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Hospital&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.xAxis, xAxis) || other.xAxis == xAxis)&&(identical(other.yAxis, yAxis) || other.yAxis == yAxis));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,phoneNumber,xAxis,yAxis);

@override
String toString() {
  return 'Hospital(id: $id, name: $name, address: $address, phoneNumber: $phoneNumber, xAxis: $xAxis, yAxis: $yAxis)';
}


}

/// @nodoc
abstract mixin class $HospitalCopyWith<$Res>  {
  factory $HospitalCopyWith(Hospital value, $Res Function(Hospital) _then) = _$HospitalCopyWithImpl;
@useResult
$Res call({
 int id, String name, String address,@JsonKey(name: 'phone_number') String? phoneNumber,@JsonKey(name: 'x_axis') double xAxis,@JsonKey(name: 'y_axis') double yAxis
});




}
/// @nodoc
class _$HospitalCopyWithImpl<$Res>
    implements $HospitalCopyWith<$Res> {
  _$HospitalCopyWithImpl(this._self, this._then);

  final Hospital _self;
  final $Res Function(Hospital) _then;

/// Create a copy of Hospital
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

class _Hospital implements Hospital {
  const _Hospital({required this.id, required this.name, required this.address, @JsonKey(name: 'phone_number') this.phoneNumber, @JsonKey(name: 'x_axis') required this.xAxis, @JsonKey(name: 'y_axis') required this.yAxis});
  factory _Hospital.fromJson(Map<String, dynamic> json) => _$HospitalFromJson(json);

@override final  int id;
@override final  String name;
@override final  String address;
@override@JsonKey(name: 'phone_number') final  String? phoneNumber;
@override@JsonKey(name: 'x_axis') final  double xAxis;
// 경도 (longitude)
@override@JsonKey(name: 'y_axis') final  double yAxis;

/// Create a copy of Hospital
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HospitalCopyWith<_Hospital> get copyWith => __$HospitalCopyWithImpl<_Hospital>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HospitalToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Hospital&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.xAxis, xAxis) || other.xAxis == xAxis)&&(identical(other.yAxis, yAxis) || other.yAxis == yAxis));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,phoneNumber,xAxis,yAxis);

@override
String toString() {
  return 'Hospital(id: $id, name: $name, address: $address, phoneNumber: $phoneNumber, xAxis: $xAxis, yAxis: $yAxis)';
}


}

/// @nodoc
abstract mixin class _$HospitalCopyWith<$Res> implements $HospitalCopyWith<$Res> {
  factory _$HospitalCopyWith(_Hospital value, $Res Function(_Hospital) _then) = __$HospitalCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String address,@JsonKey(name: 'phone_number') String? phoneNumber,@JsonKey(name: 'x_axis') double xAxis,@JsonKey(name: 'y_axis') double yAxis
});




}
/// @nodoc
class __$HospitalCopyWithImpl<$Res>
    implements _$HospitalCopyWith<$Res> {
  __$HospitalCopyWithImpl(this._self, this._then);

  final _Hospital _self;
  final $Res Function(_Hospital) _then;

/// Create a copy of Hospital
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? address = null,Object? phoneNumber = freezed,Object? xAxis = null,Object? yAxis = null,}) {
  return _then(_Hospital(
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
