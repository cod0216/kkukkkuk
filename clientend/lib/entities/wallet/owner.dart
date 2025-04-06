import 'package:freezed_annotation/freezed_annotation.dart';

part 'owner.freezed.dart';

@freezed
abstract class Owner with _$Owner {
  const factory Owner({required int id, required String name, String? image}) =
      _Owner;
}
