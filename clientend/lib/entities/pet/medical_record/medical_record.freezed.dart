// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medical_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MedicalRecord {

 DateTime get treatmentDate; String get diagnosis; String get veterinarian; String get hospitalName; String get hospitalAddress; List<Examination>? get examinations; List<Medication>? get medications; List<Vaccination>? get vaccinations; String? get memo; String get status; bool get flagCertificated; List<String> get pictures;
/// Create a copy of MedicalRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicalRecordCopyWith<MedicalRecord> get copyWith => _$MedicalRecordCopyWithImpl<MedicalRecord>(this as MedicalRecord, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicalRecord&&(identical(other.treatmentDate, treatmentDate) || other.treatmentDate == treatmentDate)&&(identical(other.diagnosis, diagnosis) || other.diagnosis == diagnosis)&&(identical(other.veterinarian, veterinarian) || other.veterinarian == veterinarian)&&(identical(other.hospitalName, hospitalName) || other.hospitalName == hospitalName)&&(identical(other.hospitalAddress, hospitalAddress) || other.hospitalAddress == hospitalAddress)&&const DeepCollectionEquality().equals(other.examinations, examinations)&&const DeepCollectionEquality().equals(other.medications, medications)&&const DeepCollectionEquality().equals(other.vaccinations, vaccinations)&&(identical(other.memo, memo) || other.memo == memo)&&(identical(other.status, status) || other.status == status)&&(identical(other.flagCertificated, flagCertificated) || other.flagCertificated == flagCertificated)&&const DeepCollectionEquality().equals(other.pictures, pictures));
}


@override
int get hashCode => Object.hash(runtimeType,treatmentDate,diagnosis,veterinarian,hospitalName,hospitalAddress,const DeepCollectionEquality().hash(examinations),const DeepCollectionEquality().hash(medications),const DeepCollectionEquality().hash(vaccinations),memo,status,flagCertificated,const DeepCollectionEquality().hash(pictures));

@override
String toString() {
  return 'MedicalRecord(treatmentDate: $treatmentDate, diagnosis: $diagnosis, veterinarian: $veterinarian, hospitalName: $hospitalName, hospitalAddress: $hospitalAddress, examinations: $examinations, medications: $medications, vaccinations: $vaccinations, memo: $memo, status: $status, flagCertificated: $flagCertificated, pictures: $pictures)';
}


}

/// @nodoc
abstract mixin class $MedicalRecordCopyWith<$Res>  {
  factory $MedicalRecordCopyWith(MedicalRecord value, $Res Function(MedicalRecord) _then) = _$MedicalRecordCopyWithImpl;
@useResult
$Res call({
 DateTime treatmentDate, String diagnosis, String veterinarian, String hospitalName, String hospitalAddress, List<Examination>? examinations, List<Medication>? medications, List<Vaccination>? vaccinations, String? memo, String status, bool flagCertificated, List<String> pictures
});




}
/// @nodoc
class _$MedicalRecordCopyWithImpl<$Res>
    implements $MedicalRecordCopyWith<$Res> {
  _$MedicalRecordCopyWithImpl(this._self, this._then);

  final MedicalRecord _self;
  final $Res Function(MedicalRecord) _then;

/// Create a copy of MedicalRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? treatmentDate = null,Object? diagnosis = null,Object? veterinarian = null,Object? hospitalName = null,Object? hospitalAddress = null,Object? examinations = freezed,Object? medications = freezed,Object? vaccinations = freezed,Object? memo = freezed,Object? status = null,Object? flagCertificated = null,Object? pictures = null,}) {
  return _then(_self.copyWith(
treatmentDate: null == treatmentDate ? _self.treatmentDate : treatmentDate // ignore: cast_nullable_to_non_nullable
as DateTime,diagnosis: null == diagnosis ? _self.diagnosis : diagnosis // ignore: cast_nullable_to_non_nullable
as String,veterinarian: null == veterinarian ? _self.veterinarian : veterinarian // ignore: cast_nullable_to_non_nullable
as String,hospitalName: null == hospitalName ? _self.hospitalName : hospitalName // ignore: cast_nullable_to_non_nullable
as String,hospitalAddress: null == hospitalAddress ? _self.hospitalAddress : hospitalAddress // ignore: cast_nullable_to_non_nullable
as String,examinations: freezed == examinations ? _self.examinations : examinations // ignore: cast_nullable_to_non_nullable
as List<Examination>?,medications: freezed == medications ? _self.medications : medications // ignore: cast_nullable_to_non_nullable
as List<Medication>?,vaccinations: freezed == vaccinations ? _self.vaccinations : vaccinations // ignore: cast_nullable_to_non_nullable
as List<Vaccination>?,memo: freezed == memo ? _self.memo : memo // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,flagCertificated: null == flagCertificated ? _self.flagCertificated : flagCertificated // ignore: cast_nullable_to_non_nullable
as bool,pictures: null == pictures ? _self.pictures : pictures // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// @nodoc


class _MedicalRecord implements MedicalRecord {
  const _MedicalRecord({required this.treatmentDate, required this.diagnosis, required this.veterinarian, required this.hospitalName, required this.hospitalAddress, final  List<Examination>? examinations, final  List<Medication>? medications, final  List<Vaccination>? vaccinations, this.memo, required this.status, required this.flagCertificated, final  List<String> pictures = const []}): _examinations = examinations,_medications = medications,_vaccinations = vaccinations,_pictures = pictures;
  

@override final  DateTime treatmentDate;
@override final  String diagnosis;
@override final  String veterinarian;
@override final  String hospitalName;
@override final  String hospitalAddress;
 final  List<Examination>? _examinations;
@override List<Examination>? get examinations {
  final value = _examinations;
  if (value == null) return null;
  if (_examinations is EqualUnmodifiableListView) return _examinations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Medication>? _medications;
@override List<Medication>? get medications {
  final value = _medications;
  if (value == null) return null;
  if (_medications is EqualUnmodifiableListView) return _medications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Vaccination>? _vaccinations;
@override List<Vaccination>? get vaccinations {
  final value = _vaccinations;
  if (value == null) return null;
  if (_vaccinations is EqualUnmodifiableListView) return _vaccinations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? memo;
@override final  String status;
@override final  bool flagCertificated;
 final  List<String> _pictures;
@override@JsonKey() List<String> get pictures {
  if (_pictures is EqualUnmodifiableListView) return _pictures;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pictures);
}


/// Create a copy of MedicalRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicalRecordCopyWith<_MedicalRecord> get copyWith => __$MedicalRecordCopyWithImpl<_MedicalRecord>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicalRecord&&(identical(other.treatmentDate, treatmentDate) || other.treatmentDate == treatmentDate)&&(identical(other.diagnosis, diagnosis) || other.diagnosis == diagnosis)&&(identical(other.veterinarian, veterinarian) || other.veterinarian == veterinarian)&&(identical(other.hospitalName, hospitalName) || other.hospitalName == hospitalName)&&(identical(other.hospitalAddress, hospitalAddress) || other.hospitalAddress == hospitalAddress)&&const DeepCollectionEquality().equals(other._examinations, _examinations)&&const DeepCollectionEquality().equals(other._medications, _medications)&&const DeepCollectionEquality().equals(other._vaccinations, _vaccinations)&&(identical(other.memo, memo) || other.memo == memo)&&(identical(other.status, status) || other.status == status)&&(identical(other.flagCertificated, flagCertificated) || other.flagCertificated == flagCertificated)&&const DeepCollectionEquality().equals(other._pictures, _pictures));
}


@override
int get hashCode => Object.hash(runtimeType,treatmentDate,diagnosis,veterinarian,hospitalName,hospitalAddress,const DeepCollectionEquality().hash(_examinations),const DeepCollectionEquality().hash(_medications),const DeepCollectionEquality().hash(_vaccinations),memo,status,flagCertificated,const DeepCollectionEquality().hash(_pictures));

@override
String toString() {
  return 'MedicalRecord(treatmentDate: $treatmentDate, diagnosis: $diagnosis, veterinarian: $veterinarian, hospitalName: $hospitalName, hospitalAddress: $hospitalAddress, examinations: $examinations, medications: $medications, vaccinations: $vaccinations, memo: $memo, status: $status, flagCertificated: $flagCertificated, pictures: $pictures)';
}


}

/// @nodoc
abstract mixin class _$MedicalRecordCopyWith<$Res> implements $MedicalRecordCopyWith<$Res> {
  factory _$MedicalRecordCopyWith(_MedicalRecord value, $Res Function(_MedicalRecord) _then) = __$MedicalRecordCopyWithImpl;
@override @useResult
$Res call({
 DateTime treatmentDate, String diagnosis, String veterinarian, String hospitalName, String hospitalAddress, List<Examination>? examinations, List<Medication>? medications, List<Vaccination>? vaccinations, String? memo, String status, bool flagCertificated, List<String> pictures
});




}
/// @nodoc
class __$MedicalRecordCopyWithImpl<$Res>
    implements _$MedicalRecordCopyWith<$Res> {
  __$MedicalRecordCopyWithImpl(this._self, this._then);

  final _MedicalRecord _self;
  final $Res Function(_MedicalRecord) _then;

/// Create a copy of MedicalRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? treatmentDate = null,Object? diagnosis = null,Object? veterinarian = null,Object? hospitalName = null,Object? hospitalAddress = null,Object? examinations = freezed,Object? medications = freezed,Object? vaccinations = freezed,Object? memo = freezed,Object? status = null,Object? flagCertificated = null,Object? pictures = null,}) {
  return _then(_MedicalRecord(
treatmentDate: null == treatmentDate ? _self.treatmentDate : treatmentDate // ignore: cast_nullable_to_non_nullable
as DateTime,diagnosis: null == diagnosis ? _self.diagnosis : diagnosis // ignore: cast_nullable_to_non_nullable
as String,veterinarian: null == veterinarian ? _self.veterinarian : veterinarian // ignore: cast_nullable_to_non_nullable
as String,hospitalName: null == hospitalName ? _self.hospitalName : hospitalName // ignore: cast_nullable_to_non_nullable
as String,hospitalAddress: null == hospitalAddress ? _self.hospitalAddress : hospitalAddress // ignore: cast_nullable_to_non_nullable
as String,examinations: freezed == examinations ? _self._examinations : examinations // ignore: cast_nullable_to_non_nullable
as List<Examination>?,medications: freezed == medications ? _self._medications : medications // ignore: cast_nullable_to_non_nullable
as List<Medication>?,vaccinations: freezed == vaccinations ? _self._vaccinations : vaccinations // ignore: cast_nullable_to_non_nullable
as List<Vaccination>?,memo: freezed == memo ? _self.memo : memo // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,flagCertificated: null == flagCertificated ? _self.flagCertificated : flagCertificated // ignore: cast_nullable_to_non_nullable
as bool,pictures: null == pictures ? _self._pictures : pictures // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
