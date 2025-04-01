import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/repositories/image/image_repository_impl.dart';
import 'package:kkuk_kkuk/domain/repositories/image_repository.dart';

/// 이미지 영구 업로드 유스케이스
class UploadPermanentImageUseCase {
  final ImageRepository _imageRepository;

  UploadPermanentImageUseCase(this._imageRepository);

  /// 이미지를 영구적으로 업로드
  ///
  /// [image] 업로드할 이미지 파일
  /// [domain] 이미지가 속한 도메인 (예: pet)
  ///
  /// 반환값: 업로드된 이미지 URL
  Future<String> execute(File image, String domain) async {
    return await _imageRepository.uploadPermanentImage(image, domain);
  }
}

/// 이미지 영구 업로드 유스케이스 Provider
final uploadPermanentImageUseCaseProvider =
    Provider<UploadPermanentImageUseCase>((ref) {
      final imageRepository = ref.watch(imageRepositoryProvider);
      return UploadPermanentImageUseCase(imageRepository);
    });
