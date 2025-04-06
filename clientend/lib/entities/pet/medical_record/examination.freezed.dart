// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'examination.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Examination {

 String get type; String get key; String get value;
/// Create a copy of Examination
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExaminationCopyWith<Examination> get copyWith => _$ExaminationCopyWithImpl<Examination>(this as Examination, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Examination&&(identical(other.type, type) || other.type == type)&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,type,key,value);

@override
String toString() {
  return 'Examination(type: $type, key: $key, value: $value)';
}


}

/// @nodoc
abstract mixin class $ExaminationCopyWith<$Res>  {
  factory $ExaminationCopyWith(Examination value, $Res Function(Examination) _then) = _$ExaminationCopyWithImpl;
@useResult
$Res call({
 String type, String key, String value
});




}
/// @nodoc
class _$ExaminationCopyWithImpl<$Res>
    implements $ExaminationCopyWith<$Res> {
  _$ExaminationCopyWithImpl(this._self, this._then);

  final Examination _self;
  final $Res Function(Examination) _then;

/// Create a copy of Examination
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? key = null,Object? value = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc


class _Examination implements Examination {
  const _Examination({required this.type, required this.key, required this.value});
  

@override final  String type;
@override final  String key;
@override final  String value;

/// Create a copy of Examination
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExaminationCopyWith<_Examination> get copyWith => __$ExaminationCopyWithImpl<_Examination>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Examination&&(identical(other.type, type) || other.type == type)&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,type,key,value);

@override
String toString() {
  return 'Examination(type: $type, key: $key, value: $value)';
}


}

/// @nodoc
abstract mixin class _$ExaminationCopyWith<$Res> implements $ExaminationCopyWith<$Res> {
  factory _$ExaminationCopyWith(_Examination value, $Res Function(_Examination) _then) = __$ExaminationCopyWithImpl;
@override @useResult
$Res call({
 String type, String key, String value
});




}
/// @nodoc
class __$ExaminationCopyWithImpl<$Res>
    implements _$ExaminationCopyWith<$Res> {
  __$ExaminationCopyWithImpl(this._self, this._then);

  final _Examination _self;
  final $Res Function(_Examination) _then;

/// Create a copy of Examination
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? key = null,Object? value = null,}) {
  return _then(_Examination(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
