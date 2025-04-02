// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Pet {

 String? get did;// DID
 String get name;// 이름
 String get gender;// 성별
 String get species;// 종
 String get breedName;// 품종
 DateTime? get birth;// 생일
 int? get age;// 나이 (생일 date 에서 계산)
 bool get flagNeutering;// 중성화 여부
 String? get imageUrl;
/// Create a copy of Pet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PetCopyWith<Pet> get copyWith => _$PetCopyWithImpl<Pet>(this as Pet, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Pet&&(identical(other.did, did) || other.did == did)&&(identical(other.name, name) || other.name == name)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.species, species) || other.species == species)&&(identical(other.breedName, breedName) || other.breedName == breedName)&&(identical(other.birth, birth) || other.birth == birth)&&(identical(other.age, age) || other.age == age)&&(identical(other.flagNeutering, flagNeutering) || other.flagNeutering == flagNeutering)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,did,name,gender,species,breedName,birth,age,flagNeutering,imageUrl);

@override
String toString() {
  return 'Pet(did: $did, name: $name, gender: $gender, species: $species, breedName: $breedName, birth: $birth, age: $age, flagNeutering: $flagNeutering, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $PetCopyWith<$Res>  {
  factory $PetCopyWith(Pet value, $Res Function(Pet) _then) = _$PetCopyWithImpl;
@useResult
$Res call({
 String? did, String name, String gender, String species, String breedName, DateTime? birth, int? age, bool flagNeutering, String? imageUrl
});




}
/// @nodoc
class _$PetCopyWithImpl<$Res>
    implements $PetCopyWith<$Res> {
  _$PetCopyWithImpl(this._self, this._then);

  final Pet _self;
  final $Res Function(Pet) _then;

/// Create a copy of Pet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? did = freezed,Object? name = null,Object? gender = null,Object? species = null,Object? breedName = null,Object? birth = freezed,Object? age = freezed,Object? flagNeutering = null,Object? imageUrl = freezed,}) {
  return _then(_self.copyWith(
did: freezed == did ? _self.did : did // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,species: null == species ? _self.species : species // ignore: cast_nullable_to_non_nullable
as String,breedName: null == breedName ? _self.breedName : breedName // ignore: cast_nullable_to_non_nullable
as String,birth: freezed == birth ? _self.birth : birth // ignore: cast_nullable_to_non_nullable
as DateTime?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,flagNeutering: null == flagNeutering ? _self.flagNeutering : flagNeutering // ignore: cast_nullable_to_non_nullable
as bool,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc


class _Pet implements Pet {
  const _Pet({this.did, required this.name, required this.gender, required this.species, required this.breedName, this.birth, this.age, required this.flagNeutering, this.imageUrl});
  

@override final  String? did;
// DID
@override final  String name;
// 이름
@override final  String gender;
// 성별
@override final  String species;
// 종
@override final  String breedName;
// 품종
@override final  DateTime? birth;
// 생일
@override final  int? age;
// 나이 (생일 date 에서 계산)
@override final  bool flagNeutering;
// 중성화 여부
@override final  String? imageUrl;

/// Create a copy of Pet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PetCopyWith<_Pet> get copyWith => __$PetCopyWithImpl<_Pet>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Pet&&(identical(other.did, did) || other.did == did)&&(identical(other.name, name) || other.name == name)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.species, species) || other.species == species)&&(identical(other.breedName, breedName) || other.breedName == breedName)&&(identical(other.birth, birth) || other.birth == birth)&&(identical(other.age, age) || other.age == age)&&(identical(other.flagNeutering, flagNeutering) || other.flagNeutering == flagNeutering)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,did,name,gender,species,breedName,birth,age,flagNeutering,imageUrl);

@override
String toString() {
  return 'Pet(did: $did, name: $name, gender: $gender, species: $species, breedName: $breedName, birth: $birth, age: $age, flagNeutering: $flagNeutering, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$PetCopyWith<$Res> implements $PetCopyWith<$Res> {
  factory _$PetCopyWith(_Pet value, $Res Function(_Pet) _then) = __$PetCopyWithImpl;
@override @useResult
$Res call({
 String? did, String name, String gender, String species, String breedName, DateTime? birth, int? age, bool flagNeutering, String? imageUrl
});




}
/// @nodoc
class __$PetCopyWithImpl<$Res>
    implements _$PetCopyWith<$Res> {
  __$PetCopyWithImpl(this._self, this._then);

  final _Pet _self;
  final $Res Function(_Pet) _then;

/// Create a copy of Pet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? did = freezed,Object? name = null,Object? gender = null,Object? species = null,Object? breedName = null,Object? birth = freezed,Object? age = freezed,Object? flagNeutering = null,Object? imageUrl = freezed,}) {
  return _then(_Pet(
did: freezed == did ? _self.did : did // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,species: null == species ? _self.species : species // ignore: cast_nullable_to_non_nullable
as String,breedName: null == breedName ? _self.breedName : breedName // ignore: cast_nullable_to_non_nullable
as String,birth: freezed == birth ? _self.birth : birth // ignore: cast_nullable_to_non_nullable
as DateTime?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,flagNeutering: null == flagNeutering ? _self.flagNeutering : flagNeutering // ignore: cast_nullable_to_non_nullable
as bool,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
