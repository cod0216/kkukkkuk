import 'dart:io';

/// 이미지 관련 저장소 인터페이스
abstract class ImageRepository {
  /// 이미지를 영구적으로 업로드
  ///
  /// [image] 업로드할 이미지 파일
  /// [domain] 이미지가 속한 도메인 (pet)
  ///
  /// 반환값: 업로드된 이미지 URL
  Future<String> uploadPermanentImage(File image, String domain);
}
