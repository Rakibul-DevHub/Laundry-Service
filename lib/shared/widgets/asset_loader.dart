import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../app/router/route_paths.dart';
import '../../core/utils/app_logger.dart';

enum AssetType { asset, network, svgAsset, file, assetGif, networkGif, fileGif }

class AssetLoader extends StatelessWidget {
  final dynamic assetPath;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final BoxShape? shape;
  final Color? color;
  final Alignment alignment;
  final Widget? errorWidget;
  final Widget? loadingWidget;
  final bool isClickable;

  const AssetLoader({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit,
    this.shape,
    this.color,
    this.alignment = Alignment.center,
    this.errorWidget,
    this.loadingWidget,
    this.isClickable = false,
  });

  @override
  Widget build(BuildContext context) {
    // Check if path is null or empty before anything else
    if (assetPath == null ||
        (assetPath is String && (assetPath as String).isEmpty)) {
      return _buildPlaceholder();
    }

    final AssetType assetType = _detectAssetType(assetPath);

    switch (assetType) {
      case AssetType.asset:
        return _buildAssetImage();
      case AssetType.network:
        return _buildNetworkImage(context);
      case AssetType.svgAsset:
        return _buildSvgImage();
      case AssetType.file:
        return _buildFileImage();
      case AssetType.assetGif:
        return _buildAssetGif();
      case AssetType.networkGif:
        return _buildNetworkGif();
      case AssetType.fileGif:
        return _buildFileGif();
    }
  }

  /// Centralized Placeholder/Error UI
  /// Replaces the red error icons with a clean, neutral placeholder
  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      alignment: alignment,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        // If it looks like a profile picture (width == height), make it circular
        shape: shape ?? BoxShape.circle,
        borderRadius: (width != height || width == null)
            ? BorderRadius.circular(8)
            : null,
      ),
      child:
          errorWidget ??
          Icon(
            Icons.image_not_supported_outlined,
            color: Colors.grey[400],
            size: width != null ? width! * 0.4 : 24,
          ),
    );
  }

  AssetType _detectAssetType(dynamic assetPath) {
    if (assetPath is String &&
        (assetPath.startsWith('http://') || assetPath.startsWith('https://'))) {
      return assetPath.endsWith('.gif')
          ? AssetType.networkGif
          : AssetType.network;
    }
    if (assetPath is String && assetPath.endsWith('.svg')) {
      return AssetType.svgAsset;
    }
    if (assetPath is File) {
      return assetPath.path.endsWith('.gif')
          ? AssetType.fileGif
          : AssetType.file;
    }
    return assetPath.toString().endsWith('.gif')
        ? AssetType.assetGif
        : AssetType.asset;
  }

  Widget _buildAssetGif() {
    return Image.asset(
      assetPath as String,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      alignment: alignment,
      errorBuilder: (_, _, _) => _buildPlaceholder(),
    );
  }

  Widget _buildNetworkGif() {
    return Image.network(
      assetPath as String,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      alignment: alignment,
      loadingBuilder:
          (
            BuildContext context,
            Widget child,
            ImageChunkEvent? loadingProgress,
          ) {
            if (loadingProgress == null) {
              return child;
            }
            return loadingWidget ??
                const Center(child: CircularProgressIndicator());
          },
      errorBuilder: (_, _, _) => _buildPlaceholder(),
    );
  }

  Widget _buildFileGif() {
    final File file = assetPath as File;
    if (!file.existsSync()) {
      return _buildPlaceholder();
    }
    return Image.file(
      file,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      alignment: alignment,
      errorBuilder: (_, _, _) => _buildPlaceholder(),
    );
  }

  Widget _buildAssetImage() {
    return Image.asset(
      assetPath as String,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      color: color,
      alignment: alignment,
      frameBuilder:
          (
            BuildContext context,
            Widget child,
            int? frame,
            bool wasSynchronouslyLoaded,
          ) {
            if (wasSynchronouslyLoaded) {
              return child;
            }
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: frame == null
                  ? loadingWidget ??
                        const Center(child: CircularProgressIndicator())
                  : child,
            );
          },
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
            AppLogger().e("Asset load error", error: error);
            return _buildPlaceholder();
          },
    );
  }

  Widget _buildNetworkImage(BuildContext context) {
    final Widget image = CachedNetworkImage(
      imageUrl: assetPath as String,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      color: color,
      alignment: alignment,
      placeholder: (BuildContext context, String url) {
        return loadingWidget ??
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: shape == BoxShape.rectangle
                      ? BorderRadius.circular(8)
                      : null,
                ),
              ),
            );
      },
      errorWidget: (BuildContext context, String url, Object error) {
        AppLogger().e("Network image error", error: error);
        return _buildPlaceholder();
      },
    );

    if (isClickable) {
      return GestureDetector(
        onTap: () {
          context.push(
            RoutePaths.imageFullScreen,
            extra: <String, String>{"assetPath": assetPath as String},
          );
        },
        child: image,
      );
    }

    return image;
  }

  Widget _buildSvgImage() {
    return SvgPicture.asset(
      assetPath as String,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcATop)
          : null,
      alignment: alignment,
      placeholderBuilder: (BuildContext context) {
        return loadingWidget ??
            const Center(child: CircularProgressIndicator());
      },
      errorBuilder:
          (BuildContext context, Object error, StackTrace stackTrace) {
            AppLogger().e("SVG load error", error: error);
            return _buildPlaceholder();
          },
    );
  }

  Widget _buildFileImage() {
    final File file = assetPath as File;
    if (!file.existsSync()) {
      return _buildPlaceholder();
    }

    return Image.file(
      file,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      color: color,
      alignment: alignment,
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
            AppLogger().e("File image error", error: error);
            return _buildPlaceholder();
          },
    );
  }
}
