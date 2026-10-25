import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';

enum ImageType { network, asset, file }

class ImageUI extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final BorderRadius? borderRadius;
  final Color? color;
  final BlendMode? colorBlendMode;
  final Widget? placeholder;
  final Widget? errorWidget;
  final ImageType? imageType;
  final bool enableMemoryCache;
  final Duration? fadeInDuration;
  final Duration? fadeOutDuration;

  const ImageUI({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.color,
    this.colorBlendMode,
    this.placeholder,
    this.errorWidget,
    this.imageType,
    this.enableMemoryCache = true,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.fadeOutDuration = const Duration(milliseconds: 300),
  });

  /// Factory constructor for network images
  factory ImageUI.network({
    required String url,
    double? width,
    double? height,
    BoxFit? fit = BoxFit.cover,
    BorderRadius? borderRadius,
    Color? color,
    BlendMode? colorBlendMode,
    Widget? placeholder,
    Widget? errorWidget,
    bool enableMemoryCache = true,
    Duration? fadeInDuration = const Duration(milliseconds: 300),
    Duration? fadeOutDuration = const Duration(milliseconds: 300),
  }) {
    return ImageUI(
      imagePath: url,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      color: color,
      colorBlendMode: colorBlendMode,
      placeholder: placeholder,
      errorWidget: errorWidget,
      imageType: ImageType.network,
      enableMemoryCache: enableMemoryCache,
      fadeInDuration: fadeInDuration,
      fadeOutDuration: fadeOutDuration,
    );
  }

  /// Factory constructor for asset images
  factory ImageUI.asset({
    required String assetPath,
    double? width,
    double? height,
    BoxFit? fit = BoxFit.cover,
    BorderRadius? borderRadius,
    Color? color,
    BlendMode? colorBlendMode,
  }) {
    return ImageUI(
      imagePath: assetPath,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      color: color,
      colorBlendMode: colorBlendMode,
      imageType: ImageType.asset,
    );
  }

  /// Factory constructor for file images
  factory ImageUI.file({
    required String filePath,
    double? width,
    double? height,
    BoxFit? fit = BoxFit.cover,
    BorderRadius? borderRadius,
    Color? color,
    BlendMode? colorBlendMode,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return ImageUI(
      imagePath: filePath,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      color: color,
      colorBlendMode: colorBlendMode,
      placeholder: placeholder,
      errorWidget: errorWidget,
      imageType: ImageType.file,
    );
  }

  @override
  Widget build(BuildContext context) {
    final resolvedImageType = imageType ?? _detectImageType(imagePath);

    Widget imageWidget = _buildImageWidget(resolvedImageType);

    // Apply border radius if provided
    if (borderRadius != null) {
      imageWidget = ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    return imageWidget;
  }

  Widget _buildImageWidget(ImageType type) {
    switch (type) {
      case ImageType.network:
        return _buildNetworkImage();
      case ImageType.asset:
        return _buildAssetImage();
      case ImageType.file:
        return _buildFileImage();
    }
  }

  Widget _buildNetworkImage() {
    return CachedNetworkImage(
      imageUrl: imagePath,
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      memCacheWidth: enableMemoryCache ? null : 0,
      memCacheHeight: enableMemoryCache ? null : 0,
      fadeInDuration: fadeInDuration ?? const Duration(milliseconds: 300),
      fadeOutDuration: fadeOutDuration ?? const Duration(milliseconds: 300),
      placeholder: (context, url) => placeholder ?? _buildDefaultPlaceholder(),
      errorWidget: (context, url, error) {
        return errorWidget ?? _buildDefaultErrorWidget();
      },
      // errorWidget ?? _buildDefaultErrorWidget(),
    );
  }

  Widget _buildAssetImage() {
    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      errorBuilder: (context, error, stackTrace) =>
          errorWidget ?? _buildDefaultErrorWidget(),
    );
  }

  Widget _buildFileImage() {
    return Image.network(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ?? _buildDefaultPlaceholder();
      },
      errorBuilder: (context, error, stackTrace) =>
          errorWidget ?? _buildDefaultErrorWidget(),
    );
  }

  Widget _buildDefaultPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.gray.withValues(alpha: 0.3),
    );
  }

  Widget _buildDefaultErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: AppColors.gray.withValues(alpha: 0.3),
    );
  }

  ImageType _detectImageType(String path) {
    if (path.startsWith('http://') ||
        path.startsWith('https://') ||
        path.startsWith('www.')) {
      return ImageType.network;
    } else if (path.startsWith('assets/') ||
        path.startsWith('images/') ||
        !path.contains('/')) {
      return ImageType.asset;
    } else {
      return ImageType.file;
    }
  }
}

/// Extension methods for easier usage
extension ImageUIExtension on String {
  ImageUI toImageUI({
    double? width,
    double? height,
    BoxFit? fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    return ImageUI(
      imagePath: this,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
    );
  }

  ImageUI toNetworkImage({
    double? width,
    double? height,
    BoxFit? fit = BoxFit.cover,
    BorderRadius? borderRadius,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return ImageUI.network(
      url: this,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      placeholder: placeholder,
      errorWidget: errorWidget,
    );
  }

  ImageUI toAssetImage({
    double? width,
    double? height,
    BoxFit? fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    return ImageUI.asset(
      assetPath: this,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
    );
  }
}
