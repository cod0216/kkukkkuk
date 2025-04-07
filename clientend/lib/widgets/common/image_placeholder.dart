import 'package:flutter/material.dart';

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({
    super.key,
    required this.onImageTap,
    required this.imageUrl,
  });

  final VoidCallback onImageTap;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onImageTap,
      child: Stack(children: [PlaceHolder(imageUrl: imageUrl), CameraIcon()]),
    );
  }
}

class CameraIcon extends StatelessWidget {
  const CameraIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
      ),
    );
  }
}

class PlaceHolder extends StatelessWidget {
  const PlaceHolder({super.key, required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 40,
      backgroundColor: Colors.grey[200],
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child:
          imageUrl == null
              ? const Icon(Icons.person, size: 40, color: Colors.grey)
              : null,
    );
  }
}
