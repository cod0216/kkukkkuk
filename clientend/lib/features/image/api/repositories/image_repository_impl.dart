import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/shared/api/client/api_client.dart';
import 'package:kkuk_kkuk/features/image/api/repositories/image_repository.dart';

/// 이미지 저장소 구현체
class ImageRepositoryImpl implements ImageRepository {
  final ApiClient _apiClient;

  ImageRepositoryImpl(this._apiClient);

  @override
  Future<String> uploadPermanentImage(File image, String domain) async {
    try {
      // 멀티파트 폼 데이터 생성
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
        'domain': domain,
      });

      // API 호출
      final response = await _apiClient.multipartPost(
        '/api/images/permanent',
        data: formData,
      );

      // 응답 처리
      // 서버는 201 상태 코드와 함께 직접 URL을 텍스트로 반환함
      if (response.statusCode == 201 || response.statusCode == 200) {
        if (response.data == null) {
          throw Exception('서버 응답이 없습니다.');
        }

        // 응답이 직접 URL 문자열인 경우 (text/plain)
        return response.data.toString();
      } else {
        throw Exception('이미지 업로드 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('이미지 업로드 오류: $e');
      rethrow;
    }
  }
}

/// 이미지 저장소 Provider
final imageRepositoryProvider = Provider<ImageRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ImageRepositoryImpl(apiClient);
});
