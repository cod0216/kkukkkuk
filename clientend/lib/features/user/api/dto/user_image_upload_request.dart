import 'dart:io';

class UserImageUploadRequest {
  final File image;

  UserImageUploadRequest({required this.image});

  Map<String, dynamic> toMultipartRequestData() {
    return {'image': image};
  }
}
