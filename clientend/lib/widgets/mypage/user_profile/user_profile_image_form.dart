import 'package:flutter/material.dart';
import 'package:kkuk_kkuk/entities/user/user.dart';
import 'package:kkuk_kkuk/pages/main/viewmodel/my_page_view_model.dart';

class UserProfileImageForm extends StatelessWidget {
  const UserProfileImageForm({
    super.key,
    required this.myPageViewModel,
    required this.user,
  });

  final MyPageViewModel myPageViewModel;
  final User user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => myPageViewModel.showProfileImageDialog(context),
      child: Stack(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[200],
            backgroundImage:
                user.profileImage != null
                    ? NetworkImage(user.profileImage!)
                    : null,
            child:
                user.profileImage == null
                    ? const Icon(Icons.person, size: 40, color: Colors.grey)
                    : null,
          ),
          // 카메라 아이콘 오버레이
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
