import 'package:flutter/material.dart';

class CustomImageContainer extends StatelessWidget {
  final String? imageUrl;
  final String? assetPath;
  final double width;
  final double height;
  final BoxFit fit;
  final double borderRadius;
  final VoidCallback? onTap;
  final Widget? overlay;

  const CustomImageContainer({
    Key? key,
    this.imageUrl,
    this.assetPath,
    this.width = 100,
    this.height = 100,
    this.fit = BoxFit.cover,
    this.borderRadius = 12.0,
    this.onTap,
    this.overlay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageWidget = imageUrl != null
        ? Image.network(imageUrl!, width: width, height: height, fit: fit, errorBuilder: (context, error, stackTrace) {
      return _fallbackImage();
    })
        : assetPath != null
        ? Image.asset(assetPath!, width: width, height: height, fit: fit)
        : _fallbackImage();

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.grey[800],
              ),
              child: imageWidget,
            ),
          ),
          if (overlay != null)
            Positioned.fill(child: overlay!),
        ],
      ),
    );
  }

  Widget _fallbackImage() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[700],
      alignment: Alignment.center,
      child: Icon(Icons.image, color: Colors.white54, size: width * 0.4),
    );
  }
}
