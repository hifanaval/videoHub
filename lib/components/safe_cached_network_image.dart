import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:videohub/screens/home/shimmer/base_shimmer.dart';

class SafeCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const SafeCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    // If imageUrl is empty or null, show error widget
    if (imageUrl.isEmpty) {
      return _buildErrorWidget();
    }

    try {
      return CachedNetworkImage(
        width: width,
        height: height,
        fit: fit,
        imageUrl: imageUrl,
        placeholder: (context, url) => placeholder ?? _buildPlaceholder(),
        errorWidget: (context, url, error) {
          debugPrint('CachedNetworkImage error: $error');
          return errorWidget ?? _buildErrorWidget();
        },
        // Disable cache completely to avoid path provider issues
        cacheManager: null,
        useOldImageOnUrlChange: true,
        // Disable memory cache to avoid platform issues
        memCacheWidth: null,
        memCacheHeight: null,
      );
    } catch (e) {
      debugPrint('SafeCachedNetworkImage error: $e');
      // If CachedNetworkImage fails due to path provider issues, use regular NetworkImage
      return _buildNetworkImageFallback();
    }
  }

  Widget _buildPlaceholder() {
    return BaseShimmer(
      width: width ?? 15,
      height: height ?? 15,
      borderRadius: 47,
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: borderRadius,
      ),
      child: Icon(
        Icons.image_not_supported,
        color: Colors.grey.shade600,
        size: (width != null && height != null) 
            ? (width! < height! ? width! * 0.5 : height! * 0.5)
            : 16,
      ),
    );
  }

  Widget _buildNetworkImageFallback() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: fit,
        ),
      ),
      child: placeholder ?? _buildPlaceholder(),
    );
  }

}

