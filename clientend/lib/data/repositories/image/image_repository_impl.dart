import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kkuk_kkuk/data/datasource/api/api_client.dart';
import 'package:kkuk_kkuk/data/dtos/image/image_upload_response.dart';
import 'package:kkuk_kkuk/domain/repositories/image_repository.dart';

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
      if (response.statusCode == 200) {
        // API 응답이 직접 URL 문자열을 반환하는 경우
        if (response.data is String) {
          return response.data;
        }

        // API 응답이 JSON 객체인 경우
        final imageResponse = ImageUploadResponse.fromJson(response.data);
        return imageResponse.data;
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
