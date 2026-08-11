import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;

  const CustomCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit,
    this.color,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        height: height,
        width: width,
        fit: fit,
        imageUrl: imageUrl,
        color: color,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) =>
            const Center(child: Icon(Icons.error)),
      ),
    );
  }
}
