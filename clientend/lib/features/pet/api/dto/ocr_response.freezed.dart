// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ocr_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OcrResponse {

 String get status; String get message; OcrResponseData get data;
/// Create a copy of OcrResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OcrResponseCopyWith<OcrResponse> get copyWith => _$OcrResponseCopyWithImpl<OcrResponse>(this as OcrResponse, _$identity);

  /// Serializes this OcrResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OcrResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,data);

@override
String toString() {
  return 'OcrResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $OcrResponseCopyWith<$Res>  {
  factory $OcrResponseCopyWith(OcrResponse value, $Res Function(OcrResponse) _then) = _$OcrResponseCopyWithImpl;
@useResult
$Res call({
 String status, String message, OcrResponseData data
});


$OcrResponseDataCopyWith<$Res> get data;

}
/// @nodoc
class _$OcrResponseCopyWithImpl<$Res>
    implements $OcrResponseCopyWith<$Res> {
  _$OcrResponseCopyWithImpl(this._self, this._then);

  final OcrResponse _self;
  final $Res Function(OcrResponse) _then;

/// Create a copy of OcrResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as OcrResponseData,
  ));
}
/// Create a copy of OcrResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OcrResponseDataCopyWith<$Res> get data {
  
  return $OcrResponseDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _OcrResponse implements OcrResponse {
  const _OcrResponse({required this.status, required this.message, required this.data});
  factory _OcrResponse.fromJson(Map<String, dynamic> json) => _$OcrResponseFromJson(json);

@override final  String status;
@override final  String message;
@override final  OcrResponseData data;

/// Create a copy of OcrResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OcrResponseCopyWith<_OcrResponse> get copyWith => __$OcrResponseCopyWithImpl<_OcrResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OcrResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OcrResponse&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,data);

@override
String toString() {
  return 'OcrResponse(status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$OcrResponseCopyWith<$Res> implements $OcrResponseCopyWith<$Res> {
  factory _$OcrResponseCopyWith(_OcrResponse value, $Res Function(_OcrResponse) _then) = __$OcrResponseCopyWithImpl;
@override @useResult
$Res call({
 String status, String message, OcrResponseData data
});


@override $OcrResponseDataCopyWith<$Res> get data;

}
/// @nodoc
class __$OcrResponseCopyWithImpl<$Res>
    implements _$OcrResponseCopyWith<$Res> {
  __$OcrResponseCopyWithImpl(this._self, this._then);

  final _OcrResponse _self;
  final $Res Function(_OcrResponse) _then;

/// Create a copy of OcrResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_OcrResponse(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as OcrResponseData,
  ));
}

/// Create a copy of OcrResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OcrResponseDataCopyWith<$Res> get data {
  
  return $OcrResponseDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$OcrResponseData {

 String get date; String get diagnosis; String get notes; String get doctorName; String get hospitalName; List<ExaminationDto> get examinations; List<MedicationDto> get medications; List<VaccinationDto> get vaccinations;
/// Create a copy of OcrResponseData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OcrResponseDataCopyWith<OcrResponseData> get copyWith => _$OcrResponseDataCopyWithImpl<OcrResponseData>(this as OcrResponseData, _$identity);

  /// Serializes this OcrResponseData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OcrResponseData&&(identical(other.date, date) || other.date == date)&&(identical(other.diagnosis, diagnosis) || other.diagnosis == diagnosis)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.doctorName, doctorName) || other.doctorName == doctorName)&&(identical(other.hospitalName, hospitalName) || other.hospitalName == hospitalName)&&const DeepCollectionEquality().equals(other.examinations, examinations)&&const DeepCollectionEquality().equals(other.medications, medications)&&const DeepCollectionEquality().equals(other.vaccinations, vaccinations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,diagnosis,notes,doctorName,hospitalName,const DeepCollectionEquality().hash(examinations),const DeepCollectionEquality().hash(medications),const DeepCollectionEquality().hash(vaccinations));

@override
String toString() {
  return 'OcrResponseData(date: $date, diagnosis: $diagnosis, notes: $notes, doctorName: $doctorName, hospitalName: $hospitalName, examinations: $examinations, medications: $medications, vaccinations: $vaccinations)';
}


}

/// @nodoc
abstract mixin class $OcrResponseDataCopyWith<$Res>  {
  factory $OcrResponseDataCopyWith(OcrResponseData value, $Res Function(OcrResponseData) _then) = _$OcrResponseDataCopyWithImpl;
@useResult
$Res call({
 String date, String diagnosis, String notes, String doctorName, String hospitalName, List<ExaminationDto> examinations, List<MedicationDto> medications, List<VaccinationDto> vaccinations
});




}
/// @nodoc
class _$OcrResponseDataCopyWithImpl<$Res>
    implements $OcrResponseDataCopyWith<$Res> {
  _$OcrResponseDataCopyWithImpl(this._self, this._then);

  final OcrResponseData _self;
  final $Res Function(OcrResponseData) _then;

/// Create a copy of OcrResponseData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? diagnosis = null,Object? notes = null,Object? doctorName = null,Object? hospitalName = null,Object? examinations = null,Object? medications = null,Object? vaccinations = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,diagnosis: null == diagnosis ? _self.diagnosis : diagnosis // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,doctorName: null == doctorName ? _self.doctorName : doctorName // ignore: cast_nullable_to_non_nullable
as String,hospitalName: null == hospitalName ? _self.hospitalName : hospitalName // ignore: cast_nullable_to_non_nullable
as String,examinations: null == examinations ? _self.examinations : examinations // ignore: cast_nullable_to_non_nullable
as List<ExaminationDto>,medications: null == medications ? _self.medications : medications // ignore: cast_nullable_to_non_nullable
as List<MedicationDto>,vaccinations: null == vaccinations ? _self.vaccinations : vaccinations // ignore: cast_nullable_to_non_nullable
as List<VaccinationDto>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _OcrResponseData implements OcrResponseData {
  const _OcrResponseData({required this.date, required this.diagnosis, required this.notes, required this.doctorName, required this.hospitalName, required final  List<ExaminationDto> examinations, required final  List<MedicationDto> medications, required final  List<VaccinationDto> vaccinations}): _examinations = examinations,_medications = medications,_vaccinations = vaccinations;
  factory _OcrResponseData.fromJson(Map<String, dynamic> json) => _$OcrResponseDataFromJson(json);

@override final  String date;
@override final  String diagnosis;
@override final  String notes;
@override final  String doctorName;
@override final  String hospitalName;
 final  List<ExaminationDto> _examinations;
@override List<ExaminationDto> get examinations {
  if (_examinations is EqualUnmodifiableListView) return _examinations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_examinations);
}

 final  List<MedicationDto> _medications;
@override List<MedicationDto> get medications {
  if (_medications is EqualUnmodifiableListView) return _medications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_medications);
}

 final  List<VaccinationDto> _vaccinations;
@override List<VaccinationDto> get vaccinations {
  if (_vaccinations is EqualUnmodifiableListView) return _vaccinations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_vaccinations);
}


/// Create a copy of OcrResponseData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OcrResponseDataCopyWith<_OcrResponseData> get copyWith => __$OcrResponseDataCopyWithImpl<_OcrResponseData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OcrResponseDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OcrResponseData&&(identical(other.date, date) || other.date == date)&&(identical(other.diagnosis, diagnosis) || other.diagnosis == diagnosis)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.doctorName, doctorName) || other.doctorName == doctorName)&&(identical(other.hospitalName, hospitalName) || other.hospitalName == hospitalName)&&const DeepCollectionEquality().equals(other._examinations, _examinations)&&const DeepCollectionEquality().equals(other._medications, _medications)&&const DeepCollectionEquality().equals(other._vaccinations, _vaccinations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,diagnosis,notes,doctorName,hospitalName,const DeepCollectionEquality().hash(_examinations),const DeepCollectionEquality().hash(_medications),const DeepCollectionEquality().hash(_vaccinations));

@override
String toString() {
  return 'OcrResponseData(date: $date, diagnosis: $diagnosis, notes: $notes, doctorName: $doctorName, hospitalName: $hospitalName, examinations: $examinations, medications: $medications, vaccinations: $vaccinations)';
}


}

/// @nodoc
abstract mixin class _$OcrResponseDataCopyWith<$Res> implements $OcrResponseDataCopyWith<$Res> {
  factory _$OcrResponseDataCopyWith(_OcrResponseData value, $Res Function(_OcrResponseData) _then) = __$OcrResponseDataCopyWithImpl;
@override @useResult
$Res call({
 String date, String diagnosis, String notes, String doctorName, String hospitalName, List<ExaminationDto> examinations, List<MedicationDto> medications, List<VaccinationDto> vaccinations
});




}
/// @nodoc
class __$OcrResponseDataCopyWithImpl<$Res>
    implements _$OcrResponseDataCopyWith<$Res> {
  __$OcrResponseDataCopyWithImpl(this._self, this._then);

  final _OcrResponseData _self;
  final $Res Function(_OcrResponseData) _then;

/// Create a copy of OcrResponseData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? diagnosis = null,Object? notes = null,Object? doctorName = null,Object? hospitalName = null,Object? examinations = null,Object? medications = null,Object? vaccinations = null,}) {
  return _then(_OcrResponseData(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,diagnosis: null == diagnosis ? _self.diagnosis : diagnosis // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,doctorName: null == doctorName ? _self.doctorName : doctorName // ignore: cast_nullable_to_non_nullable
as String,hospitalName: null == hospitalName ? _self.hospitalName : hospitalName // ignore: cast_nullable_to_non_nullable
as String,examinations: null == examinations ? _self._examinations : examinations // ignore: cast_nullable_to_non_nullable
as List<ExaminationDto>,medications: null == medications ? _self._medications : medications // ignore: cast_nullable_to_non_nullable
as List<MedicationDto>,vaccinations: null == vaccinations ? _self._vaccinations : vaccinations // ignore: cast_nullable_to_non_nullable
as List<VaccinationDto>,
  ));
}


}


/// @nodoc
mixin _$ExaminationDto {

 String get type; String get key; String get value;
/// Create a copy of ExaminationDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExaminationDtoCopyWith<ExaminationDto> get copyWith => _$ExaminationDtoCopyWithImpl<ExaminationDto>(this as ExaminationDto, _$identity);

  /// Serializes this ExaminationDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExaminationDto&&(identical(other.type, type) || other.type == type)&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,key,value);

@override
String toString() {
  return 'ExaminationDto(type: $type, key: $key, value: $value)';
}


}

/// @nodoc
abstract mixin class $ExaminationDtoCopyWith<$Res>  {
  factory $ExaminationDtoCopyWith(ExaminationDto value, $Res Function(ExaminationDto) _then) = _$ExaminationDtoCopyWithImpl;
@useResult
$Res call({
 String type, String key, String value
});




}
/// @nodoc
class _$ExaminationDtoCopyWithImpl<$Res>
    implements $ExaminationDtoCopyWith<$Res> {
  _$ExaminationDtoCopyWithImpl(this._self, this._then);

  final ExaminationDto _self;
  final $Res Function(ExaminationDto) _then;

/// Create a copy of ExaminationDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? key = null,Object? value = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ExaminationDto implements ExaminationDto {
  const _ExaminationDto({required this.type, required this.key, required this.value});
  factory _ExaminationDto.fromJson(Map<String, dynamic> json) => _$ExaminationDtoFromJson(json);

@override final  String type;
@override final  String key;
@override final  String value;

/// Create a copy of ExaminationDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExaminationDtoCopyWith<_ExaminationDto> get copyWith => __$ExaminationDtoCopyWithImpl<_ExaminationDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExaminationDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExaminationDto&&(identical(other.type, type) || other.type == type)&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,key,value);

@override
String toString() {
  return 'ExaminationDto(type: $type, key: $key, value: $value)';
}


}

/// @nodoc
abstract mixin class _$ExaminationDtoCopyWith<$Res> implements $ExaminationDtoCopyWith<$Res> {
  factory _$ExaminationDtoCopyWith(_ExaminationDto value, $Res Function(_ExaminationDto) _then) = __$ExaminationDtoCopyWithImpl;
@override @useResult
$Res call({
 String type, String key, String value
});




}
/// @nodoc
class __$ExaminationDtoCopyWithImpl<$Res>
    implements _$ExaminationDtoCopyWith<$Res> {
  __$ExaminationDtoCopyWithImpl(this._self, this._then);

  final _ExaminationDto _self;
  final $Res Function(_ExaminationDto) _then;

/// Create a copy of ExaminationDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? key = null,Object? value = null,}) {
  return _then(_ExaminationDto(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$MedicationDto {

 String get key; String get value;
/// Create a copy of MedicationDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationDtoCopyWith<MedicationDto> get copyWith => _$MedicationDtoCopyWithImpl<MedicationDto>(this as MedicationDto, _$identity);

  /// Serializes this MedicationDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationDto&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,value);

@override
String toString() {
  return 'MedicationDto(key: $key, value: $value)';
}


}

/// @nodoc
abstract mixin class $MedicationDtoCopyWith<$Res>  {
  factory $MedicationDtoCopyWith(MedicationDto value, $Res Function(MedicationDto) _then) = _$MedicationDtoCopyWithImpl;
@useResult
$Res call({
 String key, String value
});




}
/// @nodoc
class _$MedicationDtoCopyWithImpl<$Res>
    implements $MedicationDtoCopyWith<$Res> {
  _$MedicationDtoCopyWithImpl(this._self, this._then);

  final MedicationDto _self;
  final $Res Function(MedicationDto) _then;

/// Create a copy of MedicationDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? value = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _MedicationDto implements MedicationDto {
  const _MedicationDto({required this.key, required this.value});
  factory _MedicationDto.fromJson(Map<String, dynamic> json) => _$MedicationDtoFromJson(json);

@override final  String key;
@override final  String value;

/// Create a copy of MedicationDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationDtoCopyWith<_MedicationDto> get copyWith => __$MedicationDtoCopyWithImpl<_MedicationDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicationDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicationDto&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,value);

@override
String toString() {
  return 'MedicationDto(key: $key, value: $value)';
}


}

/// @nodoc
abstract mixin class _$MedicationDtoCopyWith<$Res> implements $MedicationDtoCopyWith<$Res> {
  factory _$MedicationDtoCopyWith(_MedicationDto value, $Res Function(_MedicationDto) _then) = __$MedicationDtoCopyWithImpl;
@override @useResult
$Res call({
 String key, String value
});




}
/// @nodoc
class __$MedicationDtoCopyWithImpl<$Res>
    implements _$MedicationDtoCopyWith<$Res> {
  __$MedicationDtoCopyWithImpl(this._self, this._then);

  final _MedicationDto _self;
  final $Res Function(_MedicationDto) _then;

/// Create a copy of MedicationDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? value = null,}) {
  return _then(_MedicationDto(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$VaccinationDto {

 String get key; String get value;
/// Create a copy of VaccinationDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VaccinationDtoCopyWith<VaccinationDto> get copyWith => _$VaccinationDtoCopyWithImpl<VaccinationDto>(this as VaccinationDto, _$identity);

  /// Serializes this VaccinationDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VaccinationDto&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,value);

@override
String toString() {
  return 'VaccinationDto(key: $key, value: $value)';
}


}

/// @nodoc
abstract mixin class $VaccinationDtoCopyWith<$Res>  {
  factory $VaccinationDtoCopyWith(VaccinationDto value, $Res Function(VaccinationDto) _then) = _$VaccinationDtoCopyWithImpl;
@useResult
$Res call({
 String key, String value
});




}
/// @nodoc
class _$VaccinationDtoCopyWithImpl<$Res>
    implements $VaccinationDtoCopyWith<$Res> {
  _$VaccinationDtoCopyWithImpl(this._self, this._then);

  final VaccinationDto _self;
  final $Res Function(VaccinationDto) _then;

/// Create a copy of VaccinationDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? value = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _VaccinationDto implements VaccinationDto {
  const _VaccinationDto({required this.key, required this.value});
  factory _VaccinationDto.fromJson(Map<String, dynamic> json) => _$VaccinationDtoFromJson(json);

@override final  String key;
@override final  String value;

/// Create a copy of VaccinationDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VaccinationDtoCopyWith<_VaccinationDto> get copyWith => __$VaccinationDtoCopyWithImpl<_VaccinationDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VaccinationDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VaccinationDto&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,value);

@override
String toString() {
  return 'VaccinationDto(key: $key, value: $value)';
}


}

/// @nodoc
abstract mixin class _$VaccinationDtoCopyWith<$Res> implements $VaccinationDtoCopyWith<$Res> {
  factory _$VaccinationDtoCopyWith(_VaccinationDto value, $Res Function(_VaccinationDto) _then) = __$VaccinationDtoCopyWithImpl;
@override @useResult
$Res call({
 String key, String value
});




}
/// @nodoc
class __$VaccinationDtoCopyWithImpl<$Res>
    implements _$VaccinationDtoCopyWith<$Res> {
  __$VaccinationDtoCopyWithImpl(this._self, this._then);

  final _VaccinationDto _self;
  final $Res Function(_VaccinationDto) _then;

/// Create a copy of VaccinationDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? value = null,}) {
  return _then(_VaccinationDto(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
