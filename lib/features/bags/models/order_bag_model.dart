// features/bags/models/bag_details_model.dart

// ignore_for_file: always_specify_types

import 'package:flutter/foundation.dart';

//  API Response Wrapper
@immutable
class BagDetailsResponse {
  final int code;
  final bool success;
  final String message;
  final BagDetails data;

  const BagDetailsResponse({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory BagDetailsResponse.fromJson(Map<String, dynamic> json) {
    return BagDetailsResponse(
      code: json['code'] as int,
      success: json['success'] as bool,
      message: json['message'] as String? ?? '',
      data: BagDetails.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'code': code,
    'success': success,
    'message': message,
    'data': data.toJson(),
  };
}

//  Main Bag Details Model
@immutable
class BagDetails {
  final String id;
  final String title;
  final String description;
  final int priceCents;
  final int shippingCents;
  final String currency;
  final String imageUrl;
  final List<String> benefits;
  final List<DeliveryTimelineItem> deliveryTimeline;
  final bool isPurchasable;
  final bool isActive;
  final String createdBy;
  final String updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int version; // __v
  final bool isShippingFree;
  final int totalCents;

  const BagDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.priceCents,
    required this.shippingCents,
    required this.currency,
    required this.imageUrl,
    required this.benefits,
    required this.deliveryTimeline,
    required this.isPurchasable,
    required this.isActive,
    required this.createdBy,
    required this.updatedBy,
    this.createdAt,
    this.updatedAt,
    required this.version,
    required this.isShippingFree,
    required this.totalCents,
  });

  factory BagDetails.fromJson(Map<String, dynamic> json) {
    return BagDetails(
      id: json['_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      priceCents: json['priceCents'] as int,
      shippingCents: json['shippingCents'] as int,
      currency: json['currency'] as String? ?? '',
      imageUrl: (json['imageUrl'] as String? ?? '').trim(),
      benefits: _parseStringList(json['benefits']),

      deliveryTimeline: (json['deliveryTimeline'] as List)
          .map(
            (item) =>
                DeliveryTimelineItem.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      isPurchasable: json['isPurchasable'] as bool,
      isActive: json['isActive'] as bool,
      createdBy: json['createdBy'] as String? ?? '',
      updatedBy: json['updatedBy'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(
              json['createdAt'] as String? ?? '',
            )
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(
              json['updatedAt'] as String? ?? '',
            )
          : null,
      version: json['__v'] as int? ?? 0,
      isShippingFree: json['isShippingFree'] as bool,
      totalCents: json['totalCents'] as int,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'title': title,
    'description': description,
    'priceCents': priceCents,
    'shippingCents': shippingCents,
    'currency': currency,
    'imageUrl': imageUrl,
    'benefits': benefits,
    'deliveryTimeline': deliveryTimeline
        .map((DeliveryTimelineItem item) => item.toJson())
        .toList(),
    'isPurchasable': isPurchasable,
    'isActive': isActive,
    'createdBy': createdBy,
    'updatedBy': updatedBy,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': version,
    'isShippingFree': isShippingFree,
    'totalCents': totalCents,
  };

  double get priceInDollars => priceCents / 100;
  double get shippingInDollars => shippingCents / 100;
  double get totalInDollars => totalCents / 100;

  String get formattedPrice =>
      '${currency.toUpperCase()} ${priceInDollars.toStringAsFixed(2)}';

  String get formattedTotal =>
      '${currency.toUpperCase()} ${totalInDollars.toStringAsFixed(2)}';

  List<String> get features => benefits;

  List<BagDeliveryStep> get deliverySteps =>
      deliveryTimeline.map((DeliveryTimelineItem item) {
        return BagDeliveryStep(
          key: item.key,
          title: item.title,
          description: item.eta,
          iconPath: _getIconForStep(item.key),
        );
      }).toList();

  String _getIconForStep(String key) {
    switch (key) {
      case 'processing':
        return 'assets/icons/order_processing.svg';
      case 'shipping':
        return 'assets/icons/shipping.svg';
      case 'arrival':
        return 'assets/icons/tick.svg';
      default:
        return 'assets/icons/tick.svg';
    }
  }

  static List<String> _parseStringList(dynamic value) {
    if (value == null) {
      return <String>[];
    }
    if (value is! List) {
      return <String>[];
    }

    return value
        .where((item) => item != null)
        .map((item) => item.toString())
        .where((String str) => str.isNotEmpty)
        .toList();
  }

  bool get isAvailable => isActive && isPurchasable;

  String get shippingLabel => isShippingFree
      ? 'FREE'
      : '${currency.toUpperCase()} ${shippingInDollars.toStringAsFixed(2)}';
}

@immutable
class DeliveryTimelineItem {
  final String key;
  final String title;
  final String eta;

  const DeliveryTimelineItem({
    required this.key,
    required this.title,
    required this.eta,
  });

  factory DeliveryTimelineItem.fromJson(Map<String, dynamic> json) {
    return DeliveryTimelineItem(
      key: json['key'] as String? ?? '',
      title: json['title'] as String? ?? '',
      eta: json['eta'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'key': key,
    'title': title,
    'eta': eta,
  };
}

//  UI-friendly Delivery Step (for widgets)
@immutable
class BagDeliveryStep {
  final String key;
  final String title;
  final String description; // Maps to API's 'eta'
  final String iconPath;

  const BagDeliveryStep({
    required this.key,
    required this.title,
    required this.description,
    required this.iconPath,
  });

  factory BagDeliveryStep.fromJson(Map<String, dynamic> json) {
    return BagDeliveryStep(
      key: json['key'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      iconPath: json['iconPath'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'key': key,
    'title': title,
    'description': description,
    'iconPath': iconPath,
  };
}
