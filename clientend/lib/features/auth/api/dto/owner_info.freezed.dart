// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'owner_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OwnerInfo {

 int get id; String? get did; String get name; String get email; String? get birth; String? get image;
/// Create a copy of OwnerInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnerInfoCopyWith<OwnerInfo> get copyWith => _$OwnerInfoCopyWithImpl<OwnerInfo>(this as OwnerInfo, _$identity);

  /// Serializes this OwnerInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnerInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.did, did) || other.did == did)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.birth, birth) || other.birth == birth)&&(identical(other.image, image) || other.image == image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,did,name,email,birth,image);

@override
String toString() {
  return 'OwnerInfo(id: $id, did: $did, name: $name, email: $email, birth: $birth, image: $image)';
}


}

/// @nodoc
abstract mixin class $OwnerInfoCopyWith<$Res>  {
  factory $OwnerInfoCopyWith(OwnerInfo value, $Res Function(OwnerInfo) _then) = _$OwnerInfoCopyWithImpl;
@useResult
$Res call({
 int id, String? did, String name, String email, String? birth, String? image
});




}
/// @nodoc
class _$OwnerInfoCopyWithImpl<$Res>
    implements $OwnerInfoCopyWith<$Res> {
  _$OwnerInfoCopyWithImpl(this._self, this._then);

  final OwnerInfo _self;
  final $Res Function(OwnerInfo) _then;

/// Create a copy of OwnerInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? did = freezed,Object? name = null,Object? email = null,Object? birth = freezed,Object? image = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,did: freezed == did ? _self.did : did // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,birth: freezed == birth ? _self.birth : birth // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _OwnerInfo implements OwnerInfo {
  const _OwnerInfo({required this.id, this.did, required this.name, required this.email, this.birth, this.image});
  factory _OwnerInfo.fromJson(Map<String, dynamic> json) => _$OwnerInfoFromJson(json);

@override final  int id;
@override final  String? did;
@override final  String name;
@override final  String email;
@override final  String? birth;
@override final  String? image;

/// Create a copy of OwnerInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnerInfoCopyWith<_OwnerInfo> get copyWith => __$OwnerInfoCopyWithImpl<_OwnerInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwnerInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwnerInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.did, did) || other.did == did)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.birth, birth) || other.birth == birth)&&(identical(other.image, image) || other.image == image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,did,name,email,birth,image);

@override
String toString() {
  return 'OwnerInfo(id: $id, did: $did, name: $name, email: $email, birth: $birth, image: $image)';
}


}

/// @nodoc
abstract mixin class _$OwnerInfoCopyWith<$Res> implements $OwnerInfoCopyWith<$Res> {
  factory _$OwnerInfoCopyWith(_OwnerInfo value, $Res Function(_OwnerInfo) _then) = __$OwnerInfoCopyWithImpl;
@override @useResult
$Res call({
 int id, String? did, String name, String email, String? birth, String? image
});




}
/// @nodoc
class __$OwnerInfoCopyWithImpl<$Res>
    implements _$OwnerInfoCopyWith<$Res> {
  __$OwnerInfoCopyWithImpl(this._self, this._then);

  final _OwnerInfo _self;
  final $Res Function(_OwnerInfo) _then;

/// Create a copy of OwnerInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? did = freezed,Object? name = null,Object? email = null,Object? birth = freezed,Object? image = freezed,}) {
  return _then(_OwnerInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,did: freezed == did ? _self.did : did // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,birth: freezed == birth ? _self.birth : birth // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
