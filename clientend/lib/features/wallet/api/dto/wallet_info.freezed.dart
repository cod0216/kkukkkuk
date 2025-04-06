// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WalletInfo {

 int get id; String? get name; String get address;
/// Create a copy of WalletInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletInfoCopyWith<WalletInfo> get copyWith => _$WalletInfoCopyWithImpl<WalletInfo>(this as WalletInfo, _$identity);

  /// Serializes this WalletInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address);

@override
String toString() {
  return 'WalletInfo(id: $id, name: $name, address: $address)';
}


}

/// @nodoc
abstract mixin class $WalletInfoCopyWith<$Res>  {
  factory $WalletInfoCopyWith(WalletInfo value, $Res Function(WalletInfo) _then) = _$WalletInfoCopyWithImpl;
@useResult
$Res call({
 int id, String? name, String address
});




}
/// @nodoc
class _$WalletInfoCopyWithImpl<$Res>
    implements $WalletInfoCopyWith<$Res> {
  _$WalletInfoCopyWithImpl(this._self, this._then);

  final WalletInfo _self;
  final $Res Function(WalletInfo) _then;

/// Create a copy of WalletInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = freezed,Object? address = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _WalletInfo implements WalletInfo {
  const _WalletInfo({required this.id, this.name, required this.address});
  factory _WalletInfo.fromJson(Map<String, dynamic> json) => _$WalletInfoFromJson(json);

@override final  int id;
@override final  String? name;
@override final  String address;

/// Create a copy of WalletInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletInfoCopyWith<_WalletInfo> get copyWith => __$WalletInfoCopyWithImpl<_WalletInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address);

@override
String toString() {
  return 'WalletInfo(id: $id, name: $name, address: $address)';
}


}

/// @nodoc
abstract mixin class _$WalletInfoCopyWith<$Res> implements $WalletInfoCopyWith<$Res> {
  factory _$WalletInfoCopyWith(_WalletInfo value, $Res Function(_WalletInfo) _then) = __$WalletInfoCopyWithImpl;
@override @useResult
$Res call({
 int id, String? name, String address
});




}
/// @nodoc
class __$WalletInfoCopyWithImpl<$Res>
    implements _$WalletInfoCopyWith<$Res> {
  __$WalletInfoCopyWithImpl(this._self, this._then);

  final _WalletInfo _self;
  final $Res Function(_WalletInfo) _then;

/// Create a copy of WalletInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = freezed,Object? address = null,}) {
  return _then(_WalletInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
