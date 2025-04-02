import 'package:flutter/material.dart';

class PetCardImage extends StatelessWidget {
  final String? imageUrl;

  const PetCardImage({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    // Debug print to check the image URL
    print('PetCardImage building with imageUrl: $imageUrl');
    
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / 
                    loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('Error loading image: $error');
          return _buildPlaceholder();
        },
      );
    } else {
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(child: Icon(Icons.pets, size: 40)),
    );
  }
}
