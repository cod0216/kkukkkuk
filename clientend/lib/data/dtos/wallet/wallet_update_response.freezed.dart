// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_update_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WalletUpdateResponse {

 String get status; String get message; WalletData get data;
/// Create a copy of WalletUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletUpdateResponseCopyWith<WalletUpdateResponse> get copyWith => _$WalletUpdateResponseCopyWithImpl<WalletUpdateResponse>(this as WalletUpdateResponse, _$identity);

  /// Serializes this WalletUpdateResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletUpdateResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,data);

@override
String toString() {
  return 'WalletUpdateResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $WalletUpdateResponseCopyWith<$Res>  {
  factory $WalletUpdateResponseCopyWith(WalletUpdateResponse value, $Res Function(WalletUpdateResponse) _then) = _$WalletUpdateResponseCopyWithImpl;
@useResult
$Res call({
 String status, String message, WalletData data
});


$WalletDataCopyWith<$Res> get data;

}
/// @nodoc
class _$WalletUpdateResponseCopyWithImpl<$Res>
    implements $WalletUpdateResponseCopyWith<$Res> {
  _$WalletUpdateResponseCopyWithImpl(this._self, this._then);

  final WalletUpdateResponse _self;
  final $Res Function(WalletUpdateResponse) _then;

/// Create a copy of WalletUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as WalletData,
  ));
}
/// Create a copy of WalletUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletDataCopyWith<$Res> get data {
  
  return $WalletDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _WalletUpdateResponse implements WalletUpdateResponse {
  const _WalletUpdateResponse({required this.status, required this.message, required this.data});
  factory _WalletUpdateResponse.fromJson(Map<String, dynamic> json) => _$WalletUpdateResponseFromJson(json);

@override final  String status;
@override final  String message;
@override final  WalletData data;

/// Create a copy of WalletUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletUpdateResponseCopyWith<_WalletUpdateResponse> get copyWith => __$WalletUpdateResponseCopyWithImpl<_WalletUpdateResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletUpdateResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletUpdateResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,data);

@override
String toString() {
  return 'WalletUpdateResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$WalletUpdateResponseCopyWith<$Res> implements $WalletUpdateResponseCopyWith<$Res> {
  factory _$WalletUpdateResponseCopyWith(_WalletUpdateResponse value, $Res Function(_WalletUpdateResponse) _then) = __$WalletUpdateResponseCopyWithImpl;
@override @useResult
$Res call({
 String status, String message, WalletData data
});


@override $WalletDataCopyWith<$Res> get data;

}
/// @nodoc
class __$WalletUpdateResponseCopyWithImpl<$Res>
    implements _$WalletUpdateResponseCopyWith<$Res> {
  __$WalletUpdateResponseCopyWithImpl(this._self, this._then);

  final _WalletUpdateResponse _self;
  final $Res Function(_WalletUpdateResponse) _then;

/// Create a copy of WalletUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_WalletUpdateResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as WalletData,
  ));
}

/// Create a copy of WalletUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletDataCopyWith<$Res> get data {
  
  return $WalletDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$WalletData {

 int get id; String get address; String get name; List<WalletOwner> get owners;
/// Create a copy of WalletData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletDataCopyWith<WalletData> get copyWith => _$WalletDataCopyWithImpl<WalletData>(this as WalletData, _$identity);

  /// Serializes this WalletData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletData&&(identical(other.id, id) || other.id == id)&&(identical(other.address, address) || other.address == address)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.owners, owners));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,address,name,const DeepCollectionEquality().hash(owners));

@override
String toString() {
  return 'WalletData(id: $id, address: $address, name: $name, owners: $owners)';
}


}

/// @nodoc
abstract mixin class $WalletDataCopyWith<$Res>  {
  factory $WalletDataCopyWith(WalletData value, $Res Function(WalletData) _then) = _$WalletDataCopyWithImpl;
@useResult
$Res call({
 int id, String address, String name, List<WalletOwner> owners
});




}
/// @nodoc
class _$WalletDataCopyWithImpl<$Res>
    implements $WalletDataCopyWith<$Res> {
  _$WalletDataCopyWithImpl(this._self, this._then);

  final WalletData _self;
  final $Res Function(WalletData) _then;

/// Create a copy of WalletData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? address = null,Object? name = null,Object? owners = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,owners: null == owners ? _self.owners : owners // ignore: cast_nullable_to_non_nullable
as List<WalletOwner>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _WalletData implements WalletData {
  const _WalletData({required this.id, required this.address, required this.name, required final  List<WalletOwner> owners}): _owners = owners;
  factory _WalletData.fromJson(Map<String, dynamic> json) => _$WalletDataFromJson(json);

@override final  int id;
@override final  String address;
@override final  String name;
 final  List<WalletOwner> _owners;
@override List<WalletOwner> get owners {
  if (_owners is EqualUnmodifiableListView) return _owners;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_owners);
}


/// Create a copy of WalletData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletDataCopyWith<_WalletData> get copyWith => __$WalletDataCopyWithImpl<_WalletData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletData&&(identical(other.id, id) || other.id == id)&&(identical(other.address, address) || other.address == address)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._owners, _owners));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,address,name,const DeepCollectionEquality().hash(_owners));

@override
String toString() {
  return 'WalletData(id: $id, address: $address, name: $name, owners: $owners)';
}


}

/// @nodoc
abstract mixin class _$WalletDataCopyWith<$Res> implements $WalletDataCopyWith<$Res> {
  factory _$WalletDataCopyWith(_WalletData value, $Res Function(_WalletData) _then) = __$WalletDataCopyWithImpl;
@override @useResult
$Res call({
 int id, String address, String name, List<WalletOwner> owners
});




}
/// @nodoc
class __$WalletDataCopyWithImpl<$Res>
    implements _$WalletDataCopyWith<$Res> {
  __$WalletDataCopyWithImpl(this._self, this._then);

  final _WalletData _self;
  final $Res Function(_WalletData) _then;

/// Create a copy of WalletData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? address = null,Object? name = null,Object? owners = null,}) {
  return _then(_WalletData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,owners: null == owners ? _self._owners : owners // ignore: cast_nullable_to_non_nullable
as List<WalletOwner>,
  ));
}


}


/// @nodoc
mixin _$WalletOwner {

 int get id; String get name; String? get image;
/// Create a copy of WalletOwner
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletOwnerCopyWith<WalletOwner> get copyWith => _$WalletOwnerCopyWithImpl<WalletOwner>(this as WalletOwner, _$identity);

  /// Serializes this WalletOwner to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletOwner&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.image, image) || other.image == image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,image);

@override
String toString() {
  return 'WalletOwner(id: $id, name: $name, image: $image)';
}


}

/// @nodoc
abstract mixin class $WalletOwnerCopyWith<$Res>  {
  factory $WalletOwnerCopyWith(WalletOwner value, $Res Function(WalletOwner) _then) = _$WalletOwnerCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? image
});




}
/// @nodoc
class _$WalletOwnerCopyWithImpl<$Res>
    implements $WalletOwnerCopyWith<$Res> {
  _$WalletOwnerCopyWithImpl(this._self, this._then);

  final WalletOwner _self;
  final $Res Function(WalletOwner) _then;

/// Create a copy of WalletOwner
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? image = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _WalletOwner implements WalletOwner {
  const _WalletOwner({required this.id, required this.name, this.image});
  factory _WalletOwner.fromJson(Map<String, dynamic> json) => _$WalletOwnerFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? image;

/// Create a copy of WalletOwner
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletOwnerCopyWith<_WalletOwner> get copyWith => __$WalletOwnerCopyWithImpl<_WalletOwner>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletOwnerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletOwner&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.image, image) || other.image == image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,image);

@override
String toString() {
  return 'WalletOwner(id: $id, name: $name, image: $image)';
}


}

/// @nodoc
abstract mixin class _$WalletOwnerCopyWith<$Res> implements $WalletOwnerCopyWith<$Res> {
  factory _$WalletOwnerCopyWith(_WalletOwner value, $Res Function(_WalletOwner) _then) = __$WalletOwnerCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? image
});




}
/// @nodoc
class __$WalletOwnerCopyWithImpl<$Res>
    implements _$WalletOwnerCopyWith<$Res> {
  __$WalletOwnerCopyWithImpl(this._self, this._then);

  final _WalletOwner _self;
  final $Res Function(_WalletOwner) _then;

/// Create a copy of WalletOwner
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? image = freezed,}) {
  return _then(_WalletOwner(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
