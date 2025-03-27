// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pet_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PetListResponse {

 String get status; String get message; List<PetListData> get data;
/// Create a copy of PetListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PetListResponseCopyWith<PetListResponse> get copyWith => _$PetListResponseCopyWithImpl<PetListResponse>(this as PetListResponse, _$identity);

  /// Serializes this PetListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PetListResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'PetListResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $PetListResponseCopyWith<$Res>  {
  factory $PetListResponseCopyWith(PetListResponse value, $Res Function(PetListResponse) _then) = _$PetListResponseCopyWithImpl;
@useResult
$Res call({
 String status, String message, List<PetListData> data
});




}
/// @nodoc
class _$PetListResponseCopyWithImpl<$Res>
    implements $PetListResponseCopyWith<$Res> {
  _$PetListResponseCopyWithImpl(this._self, this._then);

  final PetListResponse _self;
  final $Res Function(PetListResponse) _then;

/// Create a copy of PetListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<PetListData>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _PetListResponse implements PetListResponse {
  const _PetListResponse({required this.status, required this.message, required final  List<PetListData> data}): _data = data;
  factory _PetListResponse.fromJson(Map<String, dynamic> json) => _$PetListResponseFromJson(json);

@override final  String status;
@override final  String message;
 final  List<PetListData> _data;
@override List<PetListData> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of PetListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PetListResponseCopyWith<_PetListResponse> get copyWith => __$PetListResponseCopyWithImpl<_PetListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PetListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PetListResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'PetListResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$PetListResponseCopyWith<$Res> implements $PetListResponseCopyWith<$Res> {
  factory _$PetListResponseCopyWith(_PetListResponse value, $Res Function(_PetListResponse) _then) = __$PetListResponseCopyWithImpl;
@override @useResult
$Res call({
 String status, String message, List<PetListData> data
});




}
/// @nodoc
class __$PetListResponseCopyWithImpl<$Res>
    implements _$PetListResponseCopyWith<$Res> {
  __$PetListResponseCopyWithImpl(this._self, this._then);

  final _PetListResponse _self;
  final $Res Function(_PetListResponse) _then;

/// Create a copy of PetListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_PetListResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<PetListData>,
  ));
}


}


/// @nodoc
mixin _$PetListData {

 int get id; String get did; String get name; String get gender;@JsonKey(name: 'flag_neutering') bool get flagNeutering;@JsonKey(name: 'breed_id') int get breedId;@JsonKey(name: 'breed_name') String get breedName; String? get birth; String? get age; String? get image;
/// Create a copy of PetListData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PetListDataCopyWith<PetListData> get copyWith => _$PetListDataCopyWithImpl<PetListData>(this as PetListData, _$identity);

  /// Serializes this PetListData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PetListData&&(identical(other.id, id) || other.id == id)&&(identical(other.did, did) || other.did == did)&&(identical(other.name, name) || other.name == name)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.flagNeutering, flagNeutering) || other.flagNeutering == flagNeutering)&&(identical(other.breedId, breedId) || other.breedId == breedId)&&(identical(other.breedName, breedName) || other.breedName == breedName)&&(identical(other.birth, birth) || other.birth == birth)&&(identical(other.age, age) || other.age == age)&&(identical(other.image, image) || other.image == image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,did,name,gender,flagNeutering,breedId,breedName,birth,age,image);

@override
String toString() {
  return 'PetListData(id: $id, did: $did, name: $name, gender: $gender, flagNeutering: $flagNeutering, breedId: $breedId, breedName: $breedName, birth: $birth, age: $age, image: $image)';
}


}

/// @nodoc
abstract mixin class $PetListDataCopyWith<$Res>  {
  factory $PetListDataCopyWith(PetListData value, $Res Function(PetListData) _then) = _$PetListDataCopyWithImpl;
@useResult
$Res call({
 int id, String did, String name, String gender,@JsonKey(name: 'flag_neutering') bool flagNeutering,@JsonKey(name: 'breed_id') int breedId,@JsonKey(name: 'breed_name') String breedName, String? birth, String? age, String? image
});




}
/// @nodoc
class _$PetListDataCopyWithImpl<$Res>
    implements $PetListDataCopyWith<$Res> {
  _$PetListDataCopyWithImpl(this._self, this._then);

  final PetListData _self;
  final $Res Function(PetListData) _then;

/// Create a copy of PetListData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? did = null,Object? name = null,Object? gender = null,Object? flagNeutering = null,Object? breedId = null,Object? breedName = null,Object? birth = freezed,Object? age = freezed,Object? image = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,did: null == did ? _self.did : did // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,flagNeutering: null == flagNeutering ? _self.flagNeutering : flagNeutering // ignore: cast_nullable_to_non_nullable
as bool,breedId: null == breedId ? _self.breedId : breedId // ignore: cast_nullable_to_non_nullable
as int,breedName: null == breedName ? _self.breedName : breedName // ignore: cast_nullable_to_non_nullable
as String,birth: freezed == birth ? _self.birth : birth // ignore: cast_nullable_to_non_nullable
as String?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _PetListData implements PetListData {
  const _PetListData({required this.id, required this.did, required this.name, required this.gender, @JsonKey(name: 'flag_neutering') required this.flagNeutering, @JsonKey(name: 'breed_id') required this.breedId, @JsonKey(name: 'breed_name') required this.breedName, this.birth, this.age, this.image});
  factory _PetListData.fromJson(Map<String, dynamic> json) => _$PetListDataFromJson(json);

@override final  int id;
@override final  String did;
@override final  String name;
@override final  String gender;
@override@JsonKey(name: 'flag_neutering') final  bool flagNeutering;
@override@JsonKey(name: 'breed_id') final  int breedId;
@override@JsonKey(name: 'breed_name') final  String breedName;
@override final  String? birth;
@override final  String? age;
@override final  String? image;

/// Create a copy of PetListData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PetListDataCopyWith<_PetListData> get copyWith => __$PetListDataCopyWithImpl<_PetListData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PetListDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PetListData&&(identical(other.id, id) || other.id == id)&&(identical(other.did, did) || other.did == did)&&(identical(other.name, name) || other.name == name)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.flagNeutering, flagNeutering) || other.flagNeutering == flagNeutering)&&(identical(other.breedId, breedId) || other.breedId == breedId)&&(identical(other.breedName, breedName) || other.breedName == breedName)&&(identical(other.birth, birth) || other.birth == birth)&&(identical(other.age, age) || other.age == age)&&(identical(other.image, image) || other.image == image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,did,name,gender,flagNeutering,breedId,breedName,birth,age,image);

@override
String toString() {
  return 'PetListData(id: $id, did: $did, name: $name, gender: $gender, flagNeutering: $flagNeutering, breedId: $breedId, breedName: $breedName, birth: $birth, age: $age, image: $image)';
}


}

/// @nodoc
abstract mixin class _$PetListDataCopyWith<$Res> implements $PetListDataCopyWith<$Res> {
  factory _$PetListDataCopyWith(_PetListData value, $Res Function(_PetListData) _then) = __$PetListDataCopyWithImpl;
@override @useResult
$Res call({
 int id, String did, String name, String gender,@JsonKey(name: 'flag_neutering') bool flagNeutering,@JsonKey(name: 'breed_id') int breedId,@JsonKey(name: 'breed_name') String breedName, String? birth, String? age, String? image
});




}
/// @nodoc
class __$PetListDataCopyWithImpl<$Res>
    implements _$PetListDataCopyWith<$Res> {
  __$PetListDataCopyWithImpl(this._self, this._then);

  final _PetListData _self;
  final $Res Function(_PetListData) _then;

/// Create a copy of PetListData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? did = null,Object? name = null,Object? gender = null,Object? flagNeutering = null,Object? breedId = null,Object? breedName = null,Object? birth = freezed,Object? age = freezed,Object? image = freezed,}) {
  return _then(_PetListData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,did: null == did ? _self.did : did // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,flagNeutering: null == flagNeutering ? _self.flagNeutering : flagNeutering // ignore: cast_nullable_to_non_nullable
as bool,breedId: null == breedId ? _self.breedId : breedId // ignore: cast_nullable_to_non_nullable
as int,breedName: null == breedName ? _self.breedName : breedName // ignore: cast_nullable_to_non_nullable
as String,birth: freezed == birth ? _self.birth : birth // ignore: cast_nullable_to_non_nullable
as String?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
