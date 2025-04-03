// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$User {

 int get id; String? get did; String get name; String get email; String get birthYear; String get birthDay; String get gender; String? get profileImage; int get providerId; List<Wallet>? get wallets;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, id) || other.id == id)&&(identical(other.did, did) || other.did == did)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.birthYear, birthYear) || other.birthYear == birthYear)&&(identical(other.birthDay, birthDay) || other.birthDay == birthDay)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&const DeepCollectionEquality().equals(other.wallets, wallets));
}


@override
int get hashCode => Object.hash(runtimeType,id,did,name,email,birthYear,birthDay,gender,profileImage,providerId,const DeepCollectionEquality().hash(wallets));

@override
String toString() {
  return 'User(id: $id, did: $did, name: $name, email: $email, birthYear: $birthYear, birthDay: $birthDay, gender: $gender, profileImage: $profileImage, providerId: $providerId, wallets: $wallets)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 int id, String? did, String name, String email, String birthYear, String birthDay, String gender, String? profileImage, int providerId, List<Wallet>? wallets
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? did = freezed,Object? name = null,Object? email = null,Object? birthYear = null,Object? birthDay = null,Object? gender = null,Object? profileImage = freezed,Object? providerId = null,Object? wallets = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,did: freezed == did ? _self.did : did // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,birthYear: null == birthYear ? _self.birthYear : birthYear // ignore: cast_nullable_to_non_nullable
as String,birthDay: null == birthDay ? _self.birthDay : birthDay // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,profileImage: freezed == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String?,providerId: null == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as int,wallets: freezed == wallets ? _self.wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<Wallet>?,
  ));
}

}


/// @nodoc


class _User implements User {
  const _User({required this.id, this.did, required this.name, required this.email, required this.birthYear, required this.birthDay, required this.gender, this.profileImage, required this.providerId, final  List<Wallet>? wallets}): _wallets = wallets;
  

@override final  int id;
@override final  String? did;
@override final  String name;
@override final  String email;
@override final  String birthYear;
@override final  String birthDay;
@override final  String gender;
@override final  String? profileImage;
@override final  int providerId;
 final  List<Wallet>? _wallets;
@override List<Wallet>? get wallets {
  final value = _wallets;
  if (value == null) return null;
  if (_wallets is EqualUnmodifiableListView) return _wallets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.did, did) || other.did == did)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.birthYear, birthYear) || other.birthYear == birthYear)&&(identical(other.birthDay, birthDay) || other.birthDay == birthDay)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&const DeepCollectionEquality().equals(other._wallets, _wallets));
}


@override
int get hashCode => Object.hash(runtimeType,id,did,name,email,birthYear,birthDay,gender,profileImage,providerId,const DeepCollectionEquality().hash(_wallets));

@override
String toString() {
  return 'User(id: $id, did: $did, name: $name, email: $email, birthYear: $birthYear, birthDay: $birthDay, gender: $gender, profileImage: $profileImage, providerId: $providerId, wallets: $wallets)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 int id, String? did, String name, String email, String birthYear, String birthDay, String gender, String? profileImage, int providerId, List<Wallet>? wallets
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? did = freezed,Object? name = null,Object? email = null,Object? birthYear = null,Object? birthDay = null,Object? gender = null,Object? profileImage = freezed,Object? providerId = null,Object? wallets = freezed,}) {
  return _then(_User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,did: freezed == did ? _self.did : did // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,birthYear: null == birthYear ? _self.birthYear : birthYear // ignore: cast_nullable_to_non_nullable
as String,birthDay: null == birthDay ? _self.birthDay : birthDay // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,profileImage: freezed == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String?,providerId: null == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as int,wallets: freezed == wallets ? _self._wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<Wallet>?,
  ));
}


}

// dart format on
