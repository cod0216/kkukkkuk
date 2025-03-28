// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pet_registration_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PetRegistrationRequest {

 String get did; String get name; String get gender;@JsonKey(name: 'breed_id') int get breedId; String? get birth;@JsonKey(name: 'flag_neutering') bool get flagNeutering;
/// Create a copy of PetRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PetRegistrationRequestCopyWith<PetRegistrationRequest> get copyWith => _$PetRegistrationRequestCopyWithImpl<PetRegistrationRequest>(this as PetRegistrationRequest, _$identity);

  /// Serializes this PetRegistrationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PetRegistrationRequest&&(identical(other.did, did) || other.did == did)&&(identical(other.name, name) || other.name == name)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.breedId, breedId) || other.breedId == breedId)&&(identical(other.birth, birth) || other.birth == birth)&&(identical(other.flagNeutering, flagNeutering) || other.flagNeutering == flagNeutering));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,did,name,gender,breedId,birth,flagNeutering);

@override
String toString() {
  return 'PetRegistrationRequest(did: $did, name: $name, gender: $gender, breedId: $breedId, birth: $birth, flagNeutering: $flagNeutering)';
}


}

/// @nodoc
abstract mixin class $PetRegistrationRequestCopyWith<$Res>  {
  factory $PetRegistrationRequestCopyWith(PetRegistrationRequest value, $Res Function(PetRegistrationRequest) _then) = _$PetRegistrationRequestCopyWithImpl;
@useResult
$Res call({
 String did, String name, String gender,@JsonKey(name: 'breed_id') int breedId, String? birth,@JsonKey(name: 'flag_neutering') bool flagNeutering
});




}
/// @nodoc
class _$PetRegistrationRequestCopyWithImpl<$Res>
    implements $PetRegistrationRequestCopyWith<$Res> {
  _$PetRegistrationRequestCopyWithImpl(this._self, this._then);

  final PetRegistrationRequest _self;
  final $Res Function(PetRegistrationRequest) _then;

/// Create a copy of PetRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? did = null,Object? name = null,Object? gender = null,Object? breedId = null,Object? birth = freezed,Object? flagNeutering = null,}) {
  return _then(_self.copyWith(
did: null == did ? _self.did : did // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,breedId: null == breedId ? _self.breedId : breedId // ignore: cast_nullable_to_non_nullable
as int,birth: freezed == birth ? _self.birth : birth // ignore: cast_nullable_to_non_nullable
as String?,flagNeutering: null == flagNeutering ? _self.flagNeutering : flagNeutering // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _PetRegistrationRequest implements PetRegistrationRequest {
  const _PetRegistrationRequest({required this.did, required this.name, required this.gender, @JsonKey(name: 'breed_id') required this.breedId, this.birth, @JsonKey(name: 'flag_neutering') required this.flagNeutering});
  factory _PetRegistrationRequest.fromJson(Map<String, dynamic> json) => _$PetRegistrationRequestFromJson(json);

@override final  String did;
@override final  String name;
@override final  String gender;
@override@JsonKey(name: 'breed_id') final  int breedId;
@override final  String? birth;
@override@JsonKey(name: 'flag_neutering') final  bool flagNeutering;

/// Create a copy of PetRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PetRegistrationRequestCopyWith<_PetRegistrationRequest> get copyWith => __$PetRegistrationRequestCopyWithImpl<_PetRegistrationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PetRegistrationRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PetRegistrationRequest&&(identical(other.did, did) || other.did == did)&&(identical(other.name, name) || other.name == name)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.breedId, breedId) || other.breedId == breedId)&&(identical(other.birth, birth) || other.birth == birth)&&(identical(other.flagNeutering, flagNeutering) || other.flagNeutering == flagNeutering));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,did,name,gender,breedId,birth,flagNeutering);

@override
String toString() {
  return 'PetRegistrationRequest(did: $did, name: $name, gender: $gender, breedId: $breedId, birth: $birth, flagNeutering: $flagNeutering)';
}


}

/// @nodoc
abstract mixin class _$PetRegistrationRequestCopyWith<$Res> implements $PetRegistrationRequestCopyWith<$Res> {
  factory _$PetRegistrationRequestCopyWith(_PetRegistrationRequest value, $Res Function(_PetRegistrationRequest) _then) = __$PetRegistrationRequestCopyWithImpl;
@override @useResult
$Res call({
 String did, String name, String gender,@JsonKey(name: 'breed_id') int breedId, String? birth,@JsonKey(name: 'flag_neutering') bool flagNeutering
});




}
/// @nodoc
class __$PetRegistrationRequestCopyWithImpl<$Res>
    implements _$PetRegistrationRequestCopyWith<$Res> {
  __$PetRegistrationRequestCopyWithImpl(this._self, this._then);

  final _PetRegistrationRequest _self;
  final $Res Function(_PetRegistrationRequest) _then;

/// Create a copy of PetRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? did = null,Object? name = null,Object? gender = null,Object? breedId = null,Object? birth = freezed,Object? flagNeutering = null,}) {
  return _then(_PetRegistrationRequest(
did: null == did ? _self.did : did // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,breedId: null == breedId ? _self.breedId : breedId // ignore: cast_nullable_to_non_nullable
as int,birth: freezed == birth ? _self.birth : birth // ignore: cast_nullable_to_non_nullable
as String?,flagNeutering: null == flagNeutering ? _self.flagNeutering : flagNeutering // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
