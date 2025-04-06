import 'package:freezed_annotation/freezed_annotation.dart';

part 'breed.freezed.dart';
part 'breed.g.dart';

// species, breed 통일해서 사용
@freezed
abstract class Breed with _$Breed {
  const factory Breed({required int id, required String name}) = _Breed;

  factory Breed.fromJson(Map<String, dynamic> json) => _$BreedFromJson(json);
}
