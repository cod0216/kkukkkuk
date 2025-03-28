// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_registration_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WalletRegistrationResponse {

 String get status; String get message; WalletData get data;
/// Create a copy of WalletRegistrationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletRegistrationResponseCopyWith<WalletRegistrationResponse> get copyWith => _$WalletRegistrationResponseCopyWithImpl<WalletRegistrationResponse>(this as WalletRegistrationResponse, _$identity);

  /// Serializes this WalletRegistrationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletRegistrationResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,data);

@override
String toString() {
  return 'WalletRegistrationResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $WalletRegistrationResponseCopyWith<$Res>  {
  factory $WalletRegistrationResponseCopyWith(WalletRegistrationResponse value, $Res Function(WalletRegistrationResponse) _then) = _$WalletRegistrationResponseCopyWithImpl;
@useResult
$Res call({
 String status, String message, WalletData data
});


$WalletDataCopyWith<$Res> get data;

}
/// @nodoc
class _$WalletRegistrationResponseCopyWithImpl<$Res>
    implements $WalletRegistrationResponseCopyWith<$Res> {
  _$WalletRegistrationResponseCopyWithImpl(this._self, this._then);

  final WalletRegistrationResponse _self;
  final $Res Function(WalletRegistrationResponse) _then;

/// Create a copy of WalletRegistrationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as WalletData,
  ));
}
/// Create a copy of WalletRegistrationResponse
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

class _WalletRegistrationResponse implements WalletRegistrationResponse {
  const _WalletRegistrationResponse({required this.status, required this.message, required this.data});
  factory _WalletRegistrationResponse.fromJson(Map<String, dynamic> json) => _$WalletRegistrationResponseFromJson(json);

@override final  String status;
@override final  String message;
@override final  WalletData data;

/// Create a copy of WalletRegistrationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletRegistrationResponseCopyWith<_WalletRegistrationResponse> get copyWith => __$WalletRegistrationResponseCopyWithImpl<_WalletRegistrationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletRegistrationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletRegistrationResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,data);

@override
String toString() {
  return 'WalletRegistrationResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$WalletRegistrationResponseCopyWith<$Res> implements $WalletRegistrationResponseCopyWith<$Res> {
  factory _$WalletRegistrationResponseCopyWith(_WalletRegistrationResponse value, $Res Function(_WalletRegistrationResponse) _then) = __$WalletRegistrationResponseCopyWithImpl;
@override @useResult
$Res call({
 String status, String message, WalletData data
});


@override $WalletDataCopyWith<$Res> get data;

}
/// @nodoc
class __$WalletRegistrationResponseCopyWithImpl<$Res>
    implements _$WalletRegistrationResponseCopyWith<$Res> {
  __$WalletRegistrationResponseCopyWithImpl(this._self, this._then);

  final _WalletRegistrationResponse _self;
  final $Res Function(_WalletRegistrationResponse) _then;

/// Create a copy of WalletRegistrationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_WalletRegistrationResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as WalletData,
  ));
}

/// Create a copy of WalletRegistrationResponse
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

 int get id; String get did; String get address;
/// Create a copy of WalletData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletDataCopyWith<WalletData> get copyWith => _$WalletDataCopyWithImpl<WalletData>(this as WalletData, _$identity);

  /// Serializes this WalletData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletData&&(identical(other.id, id) || other.id == id)&&(identical(other.did, did) || other.did == did)&&(identical(other.address, address) || other.address == address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,did,address);

@override
String toString() {
  return 'WalletData(id: $id, did: $did, address: $address)';
}


}

/// @nodoc
abstract mixin class $WalletDataCopyWith<$Res>  {
  factory $WalletDataCopyWith(WalletData value, $Res Function(WalletData) _then) = _$WalletDataCopyWithImpl;
@useResult
$Res call({
 int id, String did, String address
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? did = null,Object? address = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,did: null == did ? _self.did : did // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _WalletData implements WalletData {
  const _WalletData({required this.id, required this.did, required this.address});
  factory _WalletData.fromJson(Map<String, dynamic> json) => _$WalletDataFromJson(json);

@override final  int id;
@override final  String did;
@override final  String address;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletData&&(identical(other.id, id) || other.id == id)&&(identical(other.did, did) || other.did == did)&&(identical(other.address, address) || other.address == address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,did,address);

@override
String toString() {
  return 'WalletData(id: $id, did: $did, address: $address)';
}


}

/// @nodoc
abstract mixin class _$WalletDataCopyWith<$Res> implements $WalletDataCopyWith<$Res> {
  factory _$WalletDataCopyWith(_WalletData value, $Res Function(_WalletData) _then) = __$WalletDataCopyWithImpl;
@override @useResult
$Res call({
 int id, String did, String address
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? did = null,Object? address = null,}) {
  return _then(_WalletData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,did: null == did ? _self.did : did // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
