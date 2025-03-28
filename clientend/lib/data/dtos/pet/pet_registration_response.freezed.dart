// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pet_registration_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PetRegistrationResponse {

 String get status; String get message; PetData? get data;
/// Create a copy of PetRegistrationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PetRegistrationResponseCopyWith<PetRegistrationResponse> get copyWith => _$PetRegistrationResponseCopyWithImpl<PetRegistrationResponse>(this as PetRegistrationResponse, _$identity);

  /// Serializes this PetRegistrationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PetRegistrationResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,data);

@override
String toString() {
  return 'PetRegistrationResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $PetRegistrationResponseCopyWith<$Res>  {
  factory $PetRegistrationResponseCopyWith(PetRegistrationResponse value, $Res Function(PetRegistrationResponse) _then) = _$PetRegistrationResponseCopyWithImpl;
@useResult
$Res call({
 String status, String message, PetData? data
});


$PetDataCopyWith<$Res>? get data;

}
/// @nodoc
class _$PetRegistrationResponseCopyWithImpl<$Res>
    implements $PetRegistrationResponseCopyWith<$Res> {
  _$PetRegistrationResponseCopyWithImpl(this._self, this._then);

  final PetRegistrationResponse _self;
  final $Res Function(PetRegistrationResponse) _then;

/// Create a copy of PetRegistrationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? message = null,Object? data = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as PetData?,
  ));
}
/// Create a copy of PetRegistrationResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PetDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $PetDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _PetRegistrationResponse implements PetRegistrationResponse {
  const _PetRegistrationResponse({required this.status, required this.message, this.data});
  factory _PetRegistrationResponse.fromJson(Map<String, dynamic> json) => _$PetRegistrationResponseFromJson(json);

@override final  String status;
@override final  String message;
@override final  PetData? data;

/// Create a copy of PetRegistrationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PetRegistrationResponseCopyWith<_PetRegistrationResponse> get copyWith => __$PetRegistrationResponseCopyWithImpl<_PetRegistrationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PetRegistrationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PetRegistrationResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,data);

@override
String toString() {
  return 'PetRegistrationResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$PetRegistrationResponseCopyWith<$Res> implements $PetRegistrationResponseCopyWith<$Res> {
  factory _$PetRegistrationResponseCopyWith(_PetRegistrationResponse value, $Res Function(_PetRegistrationResponse) _then) = __$PetRegistrationResponseCopyWithImpl;
@override @useResult
$Res call({
 String status, String message, PetData? data
});


@override $PetDataCopyWith<$Res>? get data;

}
/// @nodoc
class __$PetRegistrationResponseCopyWithImpl<$Res>
    implements _$PetRegistrationResponseCopyWith<$Res> {
  __$PetRegistrationResponseCopyWithImpl(this._self, this._then);

  final _PetRegistrationResponse _self;
  final $Res Function(_PetRegistrationResponse) _then;

/// Create a copy of PetRegistrationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? message = null,Object? data = freezed,}) {
  return _then(_PetRegistrationResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as PetData?,
  ));
}

/// Create a copy of PetRegistrationResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PetDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $PetDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$PetData {

 int get id; String get did; String get name; String get gender;@JsonKey(name: 'breed_id') int get breedId; String? get birth;@JsonKey(name: 'flag_neutering') bool get flagNeutering;
/// Create a copy of PetData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PetDataCopyWith<PetData> get copyWith => _$PetDataCopyWithImpl<PetData>(this as PetData, _$identity);

  /// Serializes this PetData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PetData&&(identical(other.id, id) || other.id == id)&&(identical(other.did, did) || other.did == did)&&(identical(other.name, name) || other.name == name)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.breedId, breedId) || other.breedId == breedId)&&(identical(other.birth, birth) || other.birth == birth)&&(identical(other.flagNeutering, flagNeutering) || other.flagNeutering == flagNeutering));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,did,name,gender,breedId,birth,flagNeutering);

@override
String toString() {
  return 'PetData(id: $id, did: $did, name: $name, gender: $gender, breedId: $breedId, birth: $birth, flagNeutering: $flagNeutering)';
}


}

/// @nodoc
abstract mixin class $PetDataCopyWith<$Res>  {
  factory $PetDataCopyWith(PetData value, $Res Function(PetData) _then) = _$PetDataCopyWithImpl;
@useResult
$Res call({
 int id, String did, String name, String gender,@JsonKey(name: 'breed_id') int breedId, String? birth,@JsonKey(name: 'flag_neutering') bool flagNeutering
});




}
/// @nodoc
class _$PetDataCopyWithImpl<$Res>
    implements $PetDataCopyWith<$Res> {
  _$PetDataCopyWithImpl(this._self, this._then);

  final PetData _self;
  final $Res Function(PetData) _then;

/// Create a copy of PetData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? did = null,Object? name = null,Object? gender = null,Object? breedId = null,Object? birth = freezed,Object? flagNeutering = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,did: null == did ? _self.did : did // ignore: cast_nullable_to_non_nullable
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

class _PetData implements PetData {
  const _PetData({required this.id, required this.did, required this.name, required this.gender, @JsonKey(name: 'breed_id') required this.breedId, this.birth, @JsonKey(name: 'flag_neutering') required this.flagNeutering});
  factory _PetData.fromJson(Map<String, dynamic> json) => _$PetDataFromJson(json);

@override final  int id;
@override final  String did;
@override final  String name;
@override final  String gender;
@override@JsonKey(name: 'breed_id') final  int breedId;
@override final  String? birth;
@override@JsonKey(name: 'flag_neutering') final  bool flagNeutering;

/// Create a copy of PetData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PetDataCopyWith<_PetData> get copyWith => __$PetDataCopyWithImpl<_PetData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PetDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PetData&&(identical(other.id, id) || other.id == id)&&(identical(other.did, did) || other.did == did)&&(identical(other.name, name) || other.name == name)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.breedId, breedId) || other.breedId == breedId)&&(identical(other.birth, birth) || other.birth == birth)&&(identical(other.flagNeutering, flagNeutering) || other.flagNeutering == flagNeutering));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,did,name,gender,breedId,birth,flagNeutering);

@override
String toString() {
  return 'PetData(id: $id, did: $did, name: $name, gender: $gender, breedId: $breedId, birth: $birth, flagNeutering: $flagNeutering)';
}


}

/// @nodoc
abstract mixin class _$PetDataCopyWith<$Res> implements $PetDataCopyWith<$Res> {
  factory _$PetDataCopyWith(_PetData value, $Res Function(_PetData) _then) = __$PetDataCopyWithImpl;
@override @useResult
$Res call({
 int id, String did, String name, String gender,@JsonKey(name: 'breed_id') int breedId, String? birth,@JsonKey(name: 'flag_neutering') bool flagNeutering
});




}
/// @nodoc
class __$PetDataCopyWithImpl<$Res>
    implements _$PetDataCopyWith<$Res> {
  __$PetDataCopyWithImpl(this._self, this._then);

  final _PetData _self;
  final $Res Function(_PetData) _then;

/// Create a copy of PetData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? did = null,Object? name = null,Object? gender = null,Object? breedId = null,Object? birth = freezed,Object? flagNeutering = null,}) {
  return _then(_PetData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,did: null == did ? _self.did : did // ignore: cast_nullable_to_non_nullable
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
