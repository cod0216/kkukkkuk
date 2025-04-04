// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfileResponse {

 String get status; String get message; UserProfileData get data;
/// Create a copy of UserProfileResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileResponseCopyWith<UserProfileResponse> get copyWith => _$UserProfileResponseCopyWithImpl<UserProfileResponse>(this as UserProfileResponse, _$identity);

  /// Serializes this UserProfileResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfileResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,data);

@override
String toString() {
  return 'UserProfileResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $UserProfileResponseCopyWith<$Res>  {
  factory $UserProfileResponseCopyWith(UserProfileResponse value, $Res Function(UserProfileResponse) _then) = _$UserProfileResponseCopyWithImpl;
@useResult
$Res call({
 String status, String message, UserProfileData data
});


$UserProfileDataCopyWith<$Res> get data;

}
/// @nodoc
class _$UserProfileResponseCopyWithImpl<$Res>
    implements $UserProfileResponseCopyWith<$Res> {
  _$UserProfileResponseCopyWithImpl(this._self, this._then);

  final UserProfileResponse _self;
  final $Res Function(UserProfileResponse) _then;

/// Create a copy of UserProfileResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as UserProfileData,
  ));
}
/// Create a copy of UserProfileResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserProfileDataCopyWith<$Res> get data {
  
  return $UserProfileDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _UserProfileResponse implements UserProfileResponse {
  const _UserProfileResponse({required this.status, required this.message, required this.data});
  factory _UserProfileResponse.fromJson(Map<String, dynamic> json) => _$UserProfileResponseFromJson(json);

@override final  String status;
@override final  String message;
@override final  UserProfileData data;

/// Create a copy of UserProfileResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileResponseCopyWith<_UserProfileResponse> get copyWith => __$UserProfileResponseCopyWithImpl<_UserProfileResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfileResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,data);

@override
String toString() {
  return 'UserProfileResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$UserProfileResponseCopyWith<$Res> implements $UserProfileResponseCopyWith<$Res> {
  factory _$UserProfileResponseCopyWith(_UserProfileResponse value, $Res Function(_UserProfileResponse) _then) = __$UserProfileResponseCopyWithImpl;
@override @useResult
$Res call({
 String status, String message, UserProfileData data
});


@override $UserProfileDataCopyWith<$Res> get data;

}
/// @nodoc
class __$UserProfileResponseCopyWithImpl<$Res>
    implements _$UserProfileResponseCopyWith<$Res> {
  __$UserProfileResponseCopyWithImpl(this._self, this._then);

  final _UserProfileResponse _self;
  final $Res Function(_UserProfileResponse) _then;

/// Create a copy of UserProfileResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_UserProfileResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as UserProfileData,
  ));
}

/// Create a copy of UserProfileResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserProfileDataCopyWith<$Res> get data {
  
  return $UserProfileDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$UserProfileData {

 OwnerProfileInfo get owner; List<WalletProfileInfo>? get wallets;
/// Create a copy of UserProfileData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileDataCopyWith<UserProfileData> get copyWith => _$UserProfileDataCopyWithImpl<UserProfileData>(this as UserProfileData, _$identity);

  /// Serializes this UserProfileData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfileData&&(identical(other.owner, owner) || other.owner == owner)&&const DeepCollectionEquality().equals(other.wallets, wallets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,owner,const DeepCollectionEquality().hash(wallets));

@override
String toString() {
  return 'UserProfileData(owner: $owner, wallets: $wallets)';
}


}

/// @nodoc
abstract mixin class $UserProfileDataCopyWith<$Res>  {
  factory $UserProfileDataCopyWith(UserProfileData value, $Res Function(UserProfileData) _then) = _$UserProfileDataCopyWithImpl;
@useResult
$Res call({
 OwnerProfileInfo owner, List<WalletProfileInfo>? wallets
});


$OwnerProfileInfoCopyWith<$Res> get owner;

}
/// @nodoc
class _$UserProfileDataCopyWithImpl<$Res>
    implements $UserProfileDataCopyWith<$Res> {
  _$UserProfileDataCopyWithImpl(this._self, this._then);

  final UserProfileData _self;
  final $Res Function(UserProfileData) _then;

/// Create a copy of UserProfileData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? owner = null,Object? wallets = freezed,}) {
  return _then(_self.copyWith(
owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as OwnerProfileInfo,wallets: freezed == wallets ? _self.wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<WalletProfileInfo>?,
  ));
}
/// Create a copy of UserProfileData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerProfileInfoCopyWith<$Res> get owner {
  
  return $OwnerProfileInfoCopyWith<$Res>(_self.owner, (value) {
    return _then(_self.copyWith(owner: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _UserProfileData implements UserProfileData {
  const _UserProfileData({required this.owner, final  List<WalletProfileInfo>? wallets}): _wallets = wallets;
  factory _UserProfileData.fromJson(Map<String, dynamic> json) => _$UserProfileDataFromJson(json);

@override final  OwnerProfileInfo owner;
 final  List<WalletProfileInfo>? _wallets;
@override List<WalletProfileInfo>? get wallets {
  final value = _wallets;
  if (value == null) return null;
  if (_wallets is EqualUnmodifiableListView) return _wallets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of UserProfileData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileDataCopyWith<_UserProfileData> get copyWith => __$UserProfileDataCopyWithImpl<_UserProfileData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfileData&&(identical(other.owner, owner) || other.owner == owner)&&const DeepCollectionEquality().equals(other._wallets, _wallets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,owner,const DeepCollectionEquality().hash(_wallets));

@override
String toString() {
  return 'UserProfileData(owner: $owner, wallets: $wallets)';
}


}

/// @nodoc
abstract mixin class _$UserProfileDataCopyWith<$Res> implements $UserProfileDataCopyWith<$Res> {
  factory _$UserProfileDataCopyWith(_UserProfileData value, $Res Function(_UserProfileData) _then) = __$UserProfileDataCopyWithImpl;
@override @useResult
$Res call({
 OwnerProfileInfo owner, List<WalletProfileInfo>? wallets
});


@override $OwnerProfileInfoCopyWith<$Res> get owner;

}
/// @nodoc
class __$UserProfileDataCopyWithImpl<$Res>
    implements _$UserProfileDataCopyWith<$Res> {
  __$UserProfileDataCopyWithImpl(this._self, this._then);

  final _UserProfileData _self;
  final $Res Function(_UserProfileData) _then;

/// Create a copy of UserProfileData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? owner = null,Object? wallets = freezed,}) {
  return _then(_UserProfileData(
owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as OwnerProfileInfo,wallets: freezed == wallets ? _self._wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<WalletProfileInfo>?,
  ));
}

/// Create a copy of UserProfileData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerProfileInfoCopyWith<$Res> get owner {
  
  return $OwnerProfileInfoCopyWith<$Res>(_self.owner, (value) {
    return _then(_self.copyWith(owner: value));
  });
}
}


/// @nodoc
mixin _$OwnerProfileInfo {

 int get id; String? get did; String get name; String get email; String? get birth;
/// Create a copy of OwnerProfileInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnerProfileInfoCopyWith<OwnerProfileInfo> get copyWith => _$OwnerProfileInfoCopyWithImpl<OwnerProfileInfo>(this as OwnerProfileInfo, _$identity);

  /// Serializes this OwnerProfileInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnerProfileInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.did, did) || other.did == did)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.birth, birth) || other.birth == birth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,did,name,email,birth);

@override
String toString() {
  return 'OwnerProfileInfo(id: $id, did: $did, name: $name, email: $email, birth: $birth)';
}


}

/// @nodoc
abstract mixin class $OwnerProfileInfoCopyWith<$Res>  {
  factory $OwnerProfileInfoCopyWith(OwnerProfileInfo value, $Res Function(OwnerProfileInfo) _then) = _$OwnerProfileInfoCopyWithImpl;
@useResult
$Res call({
 int id, String? did, String name, String email, String? birth
});




}
/// @nodoc
class _$OwnerProfileInfoCopyWithImpl<$Res>
    implements $OwnerProfileInfoCopyWith<$Res> {
  _$OwnerProfileInfoCopyWithImpl(this._self, this._then);

  final OwnerProfileInfo _self;
  final $Res Function(OwnerProfileInfo) _then;

/// Create a copy of OwnerProfileInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? did = freezed,Object? name = null,Object? email = null,Object? birth = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,did: freezed == did ? _self.did : did // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,birth: freezed == birth ? _self.birth : birth // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _OwnerProfileInfo implements OwnerProfileInfo {
  const _OwnerProfileInfo({required this.id, this.did, required this.name, required this.email, this.birth});
  factory _OwnerProfileInfo.fromJson(Map<String, dynamic> json) => _$OwnerProfileInfoFromJson(json);

@override final  int id;
@override final  String? did;
@override final  String name;
@override final  String email;
@override final  String? birth;

/// Create a copy of OwnerProfileInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnerProfileInfoCopyWith<_OwnerProfileInfo> get copyWith => __$OwnerProfileInfoCopyWithImpl<_OwnerProfileInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwnerProfileInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwnerProfileInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.did, did) || other.did == did)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.birth, birth) || other.birth == birth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,did,name,email,birth);

@override
String toString() {
  return 'OwnerProfileInfo(id: $id, did: $did, name: $name, email: $email, birth: $birth)';
}


}

/// @nodoc
abstract mixin class _$OwnerProfileInfoCopyWith<$Res> implements $OwnerProfileInfoCopyWith<$Res> {
  factory _$OwnerProfileInfoCopyWith(_OwnerProfileInfo value, $Res Function(_OwnerProfileInfo) _then) = __$OwnerProfileInfoCopyWithImpl;
@override @useResult
$Res call({
 int id, String? did, String name, String email, String? birth
});




}
/// @nodoc
class __$OwnerProfileInfoCopyWithImpl<$Res>
    implements _$OwnerProfileInfoCopyWith<$Res> {
  __$OwnerProfileInfoCopyWithImpl(this._self, this._then);

  final _OwnerProfileInfo _self;
  final $Res Function(_OwnerProfileInfo) _then;

/// Create a copy of OwnerProfileInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? did = freezed,Object? name = null,Object? email = null,Object? birth = freezed,}) {
  return _then(_OwnerProfileInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,did: freezed == did ? _self.did : did // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,birth: freezed == birth ? _self.birth : birth // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$WalletProfileInfo {

 int get id; String get name; String get address;
/// Create a copy of WalletProfileInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletProfileInfoCopyWith<WalletProfileInfo> get copyWith => _$WalletProfileInfoCopyWithImpl<WalletProfileInfo>(this as WalletProfileInfo, _$identity);

  /// Serializes this WalletProfileInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletProfileInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address);

@override
String toString() {
  return 'WalletProfileInfo(id: $id, name: $name, address: $address)';
}


}

/// @nodoc
abstract mixin class $WalletProfileInfoCopyWith<$Res>  {
  factory $WalletProfileInfoCopyWith(WalletProfileInfo value, $Res Function(WalletProfileInfo) _then) = _$WalletProfileInfoCopyWithImpl;
@useResult
$Res call({
 int id, String name, String address
});




}
/// @nodoc
class _$WalletProfileInfoCopyWithImpl<$Res>
    implements $WalletProfileInfoCopyWith<$Res> {
  _$WalletProfileInfoCopyWithImpl(this._self, this._then);

  final WalletProfileInfo _self;
  final $Res Function(WalletProfileInfo) _then;

/// Create a copy of WalletProfileInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? address = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _WalletProfileInfo implements WalletProfileInfo {
  const _WalletProfileInfo({required this.id, required this.name, required this.address});
  factory _WalletProfileInfo.fromJson(Map<String, dynamic> json) => _$WalletProfileInfoFromJson(json);

@override final  int id;
@override final  String name;
@override final  String address;

/// Create a copy of WalletProfileInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletProfileInfoCopyWith<_WalletProfileInfo> get copyWith => __$WalletProfileInfoCopyWithImpl<_WalletProfileInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletProfileInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletProfileInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address);

@override
String toString() {
  return 'WalletProfileInfo(id: $id, name: $name, address: $address)';
}


}

/// @nodoc
abstract mixin class _$WalletProfileInfoCopyWith<$Res> implements $WalletProfileInfoCopyWith<$Res> {
  factory _$WalletProfileInfoCopyWith(_WalletProfileInfo value, $Res Function(_WalletProfileInfo) _then) = __$WalletProfileInfoCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String address
});




}
/// @nodoc
class __$WalletProfileInfoCopyWithImpl<$Res>
    implements _$WalletProfileInfoCopyWith<$Res> {
  __$WalletProfileInfoCopyWithImpl(this._self, this._then);

  final _WalletProfileInfo _self;
  final $Res Function(_WalletProfileInfo) _then;

/// Create a copy of WalletProfileInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? address = null,}) {
  return _then(_WalletProfileInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
