// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vaccination.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Vaccination {

 String get key; String get value;
/// Create a copy of Vaccination
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VaccinationCopyWith<Vaccination> get copyWith => _$VaccinationCopyWithImpl<Vaccination>(this as Vaccination, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Vaccination&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,key,value);

@override
String toString() {
  return 'Vaccination(key: $key, value: $value)';
}


}

/// @nodoc
abstract mixin class $VaccinationCopyWith<$Res>  {
  factory $VaccinationCopyWith(Vaccination value, $Res Function(Vaccination) _then) = _$VaccinationCopyWithImpl;
@useResult
$Res call({
 String key, String value
});




}
/// @nodoc
class _$VaccinationCopyWithImpl<$Res>
    implements $VaccinationCopyWith<$Res> {
  _$VaccinationCopyWithImpl(this._self, this._then);

  final Vaccination _self;
  final $Res Function(Vaccination) _then;

/// Create a copy of Vaccination
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? value = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc


class _Vaccination implements Vaccination {
  const _Vaccination({required this.key, required this.value});
  

@override final  String key;
@override final  String value;

/// Create a copy of Vaccination
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VaccinationCopyWith<_Vaccination> get copyWith => __$VaccinationCopyWithImpl<_Vaccination>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Vaccination&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,key,value);

@override
String toString() {
  return 'Vaccination(key: $key, value: $value)';
}


}

/// @nodoc
abstract mixin class _$VaccinationCopyWith<$Res> implements $VaccinationCopyWith<$Res> {
  factory _$VaccinationCopyWith(_Vaccination value, $Res Function(_Vaccination) _then) = __$VaccinationCopyWithImpl;
@override @useResult
$Res call({
 String key, String value
});




}
/// @nodoc
class __$VaccinationCopyWithImpl<$Res>
    implements _$VaccinationCopyWith<$Res> {
  __$VaccinationCopyWithImpl(this._self, this._then);

  final _Vaccination _self;
  final $Res Function(_Vaccination) _then;

/// Create a copy of Vaccination
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? value = null,}) {
  return _then(_Vaccination(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
