import 'dart:io'; // dart:io import 추가
import 'package:flutter/material.dart';

class PetCardImage extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile; // 로컬 파일 추가

  const PetCardImage({
    super.key,
    this.imageUrl,
    this.imageFile, // 생성자에 추가
  });

  @override
  Widget build(BuildContext context) {
    // 1. 로컬 파일 우선 표시
    if (imageFile != null) {
      return Image.file(
        imageFile!,
        fit: BoxFit.cover, // 카드를 꽉 채우도록 fit 설정
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          // 파일 로딩 에러 처리
          print('Error loading image file: $error');
          return _buildPlaceholder();
        },
      );
    }
    // 2. 로컬 파일 없으면 네트워크 이미지 시도
    else if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover, // 카드를 꽉 채우도록 fit 설정
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value:
                  loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('Error loading network image: $error');
          return _buildPlaceholder();
        },
      );
    }
    // 3. 둘 다 없으면 플레이스홀더
    else {
      return _buildPlaceholder();
    }
  }

  // 플레이스홀더 위젯 (기존과 동일)
  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: Icon(
          Icons.pets,
          size: 60, // 크기 약간 키움
          color: Colors.grey.shade400,
        ),
      ),
    );
  }
}
