import 'package:flutter/foundation.dart';

enum BannerMediaKind {
  image,
  video,
  unknown;

  factory BannerMediaKind.fromString(String value) {
    return BannerMediaKind.values.firstWhere(
      (BannerMediaKind e) =>
          e.toString().split('.').last == value.toLowerCase(),
      orElse: () => BannerMediaKind.unknown,
    );
  }
}

@immutable
class BannerModel {
  final String id;
  final String mediaUrl;
  final String? thumbnailUrl;
  final BannerMediaKind mediaKind;
  final String? mimeType;
  final bool autoPlay;
  final bool loop;
  final bool muted;
  final DateTime updatedAt;

  const BannerModel({
    required this.id,
    required this.mediaUrl,
    this.thumbnailUrl,
    required this.mediaKind,
    this.mimeType,
    this.autoPlay = true,
    this.loop = true,
    this.muted = true,
    required this.updatedAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      mediaUrl: json['mediaUrl'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String?,
      mediaKind: BannerMediaKind.fromString(
        json['mediaKind'] as String? ?? 'unknown',
      ),
      mimeType: json['mimeType'] as String?,
      autoPlay: json['autoPlay'] as bool? ?? true,
      loop: json['loop'] as bool? ?? true,
      muted: json['muted'] as bool? ?? true,
      updatedAt: DateTime.parse(
        json['updatedAt'] as String? ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      '_id': id,
      'mediaUrl': mediaUrl,
      'thumbnailUrl': thumbnailUrl,
      'mediaKind': mediaKind.toString().split('.').last,
      'mimeType': mimeType,
      'autoPlay': autoPlay,
      'loop': loop,
      'muted': muted,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  BannerModel copyWith({
    String? id,
    String? mediaUrl,
    String? thumbnailUrl,
    BannerMediaKind? mediaKind,
    String? mimeType,
    bool? autoPlay,
    bool? loop,
    bool? muted,
    DateTime? updatedAt,
  }) {
    return BannerModel(
      id: id ?? this.id,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      mediaKind: mediaKind ?? this.mediaKind,
      mimeType: mimeType ?? this.mimeType,
      autoPlay: autoPlay ?? this.autoPlay,
      loop: loop ?? this.loop,
      muted: muted ?? this.muted,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if banner has a thumbnail fallback
  bool get hasThumbnail => thumbnailUrl != null && thumbnailUrl!.isNotEmpty;

  /// Check if banner is a video
  bool get isVideo => mediaKind == BannerMediaKind.video;

  /// Check if banner is an image
  bool get isImage => mediaKind == BannerMediaKind.image;
}
