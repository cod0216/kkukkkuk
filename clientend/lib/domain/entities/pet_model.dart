import 'dart:io';

class Pet {
  final int? id;
  final String? did;
  final String name;
  final String gender;
  final bool flagNeutering;
  final String breedId;
  final String breedName;
  final DateTime? birth;
  final String age;
  final String? imageUrl;
  final String species;

  Pet({
    this.id,
    this.did,
    required this.name,
    required this.gender,
    this.flagNeutering = false,
    required this.breedId,
    required this.breedName,
    this.birth,
    required this.age,
    this.imageUrl,
    required this.species,
  });

  Pet copyWith({
    int? id,
    String? did,
    String? name,
    String? gender,
    bool? flagNeutering,
    String? breedId,
    String? breedName,
    DateTime? birth,
    String? age,
    String? imageUrl,
    File? imageFile,
    String? species,
  }) {
    return Pet(
      id: id ?? this.id,
      did: did ?? this.did,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      flagNeutering: flagNeutering ?? this.flagNeutering,
      breedId: breedId ?? this.breedId,
      breedName: breedName ?? this.breedName,
      birth: birth ?? this.birth,
      age: age ?? this.age,
      imageUrl: imageUrl ?? this.imageUrl,
      species: species ?? this.species,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'did': did,
      'name': name,
      'gender': gender,
      'flag_neutering': flagNeutering,
      'breed_id': breedId,
      'breed_name': breedName,
      'birth': birth?.toIso8601String(),
      'age': age,
      'image': imageUrl,
      'species': species,
    };
  }

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      did: json['did'],
      name: json['name'] ?? '',
      gender: json['gender'] ?? '',
      flagNeutering: json['flag_neutering'] ?? false,
      breedId: json['breed_id'] ?? '',
      breedName: json['breed_name'] ?? '',
      birth: json['birth'] != null ? DateTime.parse(json['birth']) : null,
      age: json['age'] ?? '',
      imageUrl: json['image'],
      species: json['species'] ?? '',
    );
  }
}
