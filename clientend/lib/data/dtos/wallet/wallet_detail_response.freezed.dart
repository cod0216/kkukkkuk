// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_detail_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WalletDetailResponse {

 String get status; String get message; WalletDetailData get data;
/// Create a copy of WalletDetailResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletDetailResponseCopyWith<WalletDetailResponse> get copyWith => _$WalletDetailResponseCopyWithImpl<WalletDetailResponse>(this as WalletDetailResponse, _$identity);

  /// Serializes this WalletDetailResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletDetailResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,data);

@override
String toString() {
  return 'WalletDetailResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $WalletDetailResponseCopyWith<$Res>  {
  factory $WalletDetailResponseCopyWith(WalletDetailResponse value, $Res Function(WalletDetailResponse) _then) = _$WalletDetailResponseCopyWithImpl;
@useResult
$Res call({
 String status, String message, WalletDetailData data
});


$WalletDetailDataCopyWith<$Res> get data;

}
/// @nodoc
class _$WalletDetailResponseCopyWithImpl<$Res>
    implements $WalletDetailResponseCopyWith<$Res> {
  _$WalletDetailResponseCopyWithImpl(this._self, this._then);

  final WalletDetailResponse _self;
  final $Res Function(WalletDetailResponse) _then;

/// Create a copy of WalletDetailResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as WalletDetailData,
  ));
}
/// Create a copy of WalletDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletDetailDataCopyWith<$Res> get data {
  
  return $WalletDetailDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _WalletDetailResponse implements WalletDetailResponse {
  const _WalletDetailResponse({required this.status, required this.message, required this.data});
  factory _WalletDetailResponse.fromJson(Map<String, dynamic> json) => _$WalletDetailResponseFromJson(json);

@override final  String status;
@override final  String message;
@override final  WalletDetailData data;

/// Create a copy of WalletDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletDetailResponseCopyWith<_WalletDetailResponse> get copyWith => __$WalletDetailResponseCopyWithImpl<_WalletDetailResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletDetailResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletDetailResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,data);

@override
String toString() {
  return 'WalletDetailResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$WalletDetailResponseCopyWith<$Res> implements $WalletDetailResponseCopyWith<$Res> {
  factory _$WalletDetailResponseCopyWith(_WalletDetailResponse value, $Res Function(_WalletDetailResponse) _then) = __$WalletDetailResponseCopyWithImpl;
@override @useResult
$Res call({
 String status, String message, WalletDetailData data
});


@override $WalletDetailDataCopyWith<$Res> get data;

}
/// @nodoc
class __$WalletDetailResponseCopyWithImpl<$Res>
    implements _$WalletDetailResponseCopyWith<$Res> {
  __$WalletDetailResponseCopyWithImpl(this._self, this._then);

  final _WalletDetailResponse _self;
  final $Res Function(_WalletDetailResponse) _then;

/// Create a copy of WalletDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_WalletDetailResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as WalletDetailData,
  ));
}

/// Create a copy of WalletDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletDetailDataCopyWith<$Res> get data {
  
  return $WalletDetailDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$WalletDetailData {

 int get id; String get address; String get name; List<WalletOwner> get owners;
/// Create a copy of WalletDetailData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletDetailDataCopyWith<WalletDetailData> get copyWith => _$WalletDetailDataCopyWithImpl<WalletDetailData>(this as WalletDetailData, _$identity);

  /// Serializes this WalletDetailData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletDetailData&&(identical(other.id, id) || other.id == id)&&(identical(other.address, address) || other.address == address)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.owners, owners));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,address,name,const DeepCollectionEquality().hash(owners));

@override
String toString() {
  return 'WalletDetailData(id: $id, address: $address, name: $name, owners: $owners)';
}


}

/// @nodoc
abstract mixin class $WalletDetailDataCopyWith<$Res>  {
  factory $WalletDetailDataCopyWith(WalletDetailData value, $Res Function(WalletDetailData) _then) = _$WalletDetailDataCopyWithImpl;
@useResult
$Res call({
 int id, String address, String name, List<WalletOwner> owners
});




}
/// @nodoc
class _$WalletDetailDataCopyWithImpl<$Res>
    implements $WalletDetailDataCopyWith<$Res> {
  _$WalletDetailDataCopyWithImpl(this._self, this._then);

  final WalletDetailData _self;
  final $Res Function(WalletDetailData) _then;

/// Create a copy of WalletDetailData
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

class _WalletDetailData implements WalletDetailData {
  const _WalletDetailData({required this.id, required this.address, required this.name, required final  List<WalletOwner> owners}): _owners = owners;
  factory _WalletDetailData.fromJson(Map<String, dynamic> json) => _$WalletDetailDataFromJson(json);

@override final  int id;
@override final  String address;
@override final  String name;
 final  List<WalletOwner> _owners;
@override List<WalletOwner> get owners {
  if (_owners is EqualUnmodifiableListView) return _owners;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_owners);
}


/// Create a copy of WalletDetailData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletDetailDataCopyWith<_WalletDetailData> get copyWith => __$WalletDetailDataCopyWithImpl<_WalletDetailData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletDetailDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletDetailData&&(identical(other.id, id) || other.id == id)&&(identical(other.address, address) || other.address == address)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._owners, _owners));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,address,name,const DeepCollectionEquality().hash(_owners));

@override
String toString() {
  return 'WalletDetailData(id: $id, address: $address, name: $name, owners: $owners)';
}


}

/// @nodoc
abstract mixin class _$WalletDetailDataCopyWith<$Res> implements $WalletDetailDataCopyWith<$Res> {
  factory _$WalletDetailDataCopyWith(_WalletDetailData value, $Res Function(_WalletDetailData) _then) = __$WalletDetailDataCopyWithImpl;
@override @useResult
$Res call({
 int id, String address, String name, List<WalletOwner> owners
});




}
/// @nodoc
class __$WalletDetailDataCopyWithImpl<$Res>
    implements _$WalletDetailDataCopyWith<$Res> {
  __$WalletDetailDataCopyWithImpl(this._self, this._then);

  final _WalletDetailData _self;
  final $Res Function(_WalletDetailData) _then;

/// Create a copy of WalletDetailData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? address = null,Object? name = null,Object? owners = null,}) {
  return _then(_WalletDetailData(
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
