import 'dart:io';

enum ImageType {
  asset,
  network,
  svgAsset,
  file,
}

class DetectImageType {
  DetectImageType._();
  static ImageType detectImageType(dynamic imagePath) {
    // Check if the imagePath contains 'http' or 'https' (network image)
    if (imagePath is String &&
        (imagePath.startsWith('http://') || imagePath.startsWith('https://'))) {
      return ImageType.network;
    }

    // Check if the imagePath ends with .svg (SVG asset image)
    if (imagePath is String && imagePath.endsWith('.svg')) {
      return ImageType.svgAsset;
    }

    // Check if the imagePath represents a local file (local file image)
    if (imagePath is File) {
      return ImageType.file;
    }

    // If it's not a network image, SVG, or file, assume it's a local asset image
    return ImageType.asset;
  }
}