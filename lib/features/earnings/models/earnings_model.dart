// features/earnings/models/earnings_model.dart

// ignore_for_file: always_specify_types

import 'package:drop_n_fresh/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

@immutable
class EarningsModel {
  //  Core transaction fields
  final String id; // _id
  final String transactionId; // transactionId (e.g., "7AFB441B")
  final double amount; // in dollars (converted from cents)
  final String currency; // "usd"
  final String status; // pending, completed, failed
  final String type; // DELIVERY_PAYOUT, PICKUP_PAYOUT, etc.
  final DateTime createdAt; // createdAt
  final DateTime updatedAt; // updatedAt

  //  Counterparty (customer/provider) info
  final String counterpartyName;
  final String counterpartyPhone;
  final String? counterpartyPicture;

  //  Location info
  final String pickupLocation;
  final String dropoffLocation;

  //  Order info
  final String? orderId;
  final String? orderCode; // e.g., "2C56C0"
  final String? orderStatus;
  final String? scheduledPickupSlot;
  final String? deliveryMode;
  final String? driverType;

  //  Items list
  final List<EarningsItem> items;

  //  Bags list
  final List<EarningsBag> bags;

  //  Pricing breakdown (all in dollars)
  final EarningsPricing pricing;

  const EarningsModel({
    required this.id,
    required this.transactionId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.counterpartyName,
    required this.counterpartyPhone,
    this.counterpartyPicture,
    required this.pickupLocation,
    required this.dropoffLocation,
    this.orderId,
    this.orderCode,
    this.orderStatus,
    this.scheduledPickupSlot,
    this.deliveryMode,
    this.driverType,
    required this.items,
    required this.bags,
    required this.pricing,
  });

  //  Map API response to model
  factory EarningsModel.fromApiResponse(Map<String, dynamic> json) {
    final List<dynamic> itemsJson = (json['items'] as List? ?? <dynamic>[]);
    final List<dynamic> bagsJson = (json['bags'] as List? ?? <dynamic>[]);
    final Map<String, dynamic> pricingJson =
        json['pricing'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return EarningsModel(
      id: json['_id'] as String,
      transactionId: json['transactionId'] as String,

      //  Convert cents to dollars
      amount: (json['amount'] as num) / 100,

      currency: json['currency'] as String? ?? 'usd',
      status: json['status'] as String,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),

      // Counterparty info
      counterpartyName: json['counterpartyName'] as String? ?? 'N/A',
      counterpartyPhone: json['counterpartyPhone'] as String? ?? 'N/A',
      counterpartyPicture:
          AppConstants.resolveMediaUrl(json['counterpartyPicture']) ?? '',

      // Locations
      pickupLocation: json['pickupLocation'] as String? ?? 'N/A',
      dropoffLocation: json['dropoffLocation'] as String? ?? 'N/A',

      // Order info
      orderId: json['orderId'] as String?,
      orderCode: json['orderCode'] as String?,
      orderStatus: json['orderStatus'] as String?,
      scheduledPickupSlot: json['scheduledPickupSlot'] as String?,
      deliveryMode: json['deliveryMode'] as String?,
      driverType: json['driverType'] as String?,

      // Nested models
      items: itemsJson
          .map((item) => EarningsItem.fromApi(item as Map<String, dynamic>))
          .toList(),
      bags: bagsJson
          .map((bag) => EarningsBag.fromApi(bag as Map<String, dynamic>))
          .toList(),
      pricing: EarningsPricing.fromApi(pricingJson),
    );
  }

  //  Formatted amount with currency
  String get formattedAmount {
    return '\$${amount.toStringAsFixed(2)}';
  }

  //  Formatted date for display
  String get formattedDate {
    final DateTime now = DateTime.now();
    final Duration diff = now.difference(createdAt);

    if (diff.inHours < 24 && diff.inDays == 0) {
      return 'Today';
    }
    if (diff.inDays == 1) {
      return 'Yesterday';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    }
    return '${createdAt.day} ${_monthName(createdAt.month)} ${createdAt.year}';
  }

  String _monthName(int month) {
    const List<String> months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  //  Status color for badge
  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  //  Formatted type for display
  String get formattedType {
    switch (type.toUpperCase()) {
      case 'DELIVERY_PAYOUT':
        return 'Delivery Payout';
      case 'PICKUP_PAYOUT':
        return 'Pickup Payout';
      case 'WITHDRAWAL':
        return 'Withdrawal';
      case 'BONUS':
        return 'Bonus';
      default:
        return type;
    }
  }

  //  Total items count
  int get totalItems =>
      items.fold(0, (int sum, EarningsItem item) => sum + item.quantity);

  //  CopyWith for immutability
  EarningsModel copyWith({
    String? id,
    String? transactionId,
    double? amount,
    String? currency,
    String? status,
    String? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? counterpartyName,
    String? counterpartyPhone,
    String? counterpartyPicture,
    String? pickupLocation,
    String? dropoffLocation,
    String? orderId,
    String? orderCode,
    String? orderStatus,
    String? scheduledPickupSlot,
    String? deliveryMode,
    String? driverType,
    List<EarningsItem>? items,
    List<EarningsBag>? bags,
    EarningsPricing? pricing,
  }) {
    return EarningsModel(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      counterpartyName: counterpartyName ?? this.counterpartyName,
      counterpartyPhone: counterpartyPhone ?? this.counterpartyPhone,
      counterpartyPicture: counterpartyPicture ?? this.counterpartyPicture,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropoffLocation: dropoffLocation ?? this.dropoffLocation,
      orderId: orderId ?? this.orderId,
      orderCode: orderCode ?? this.orderCode,
      orderStatus: orderStatus ?? this.orderStatus,
      scheduledPickupSlot: scheduledPickupSlot ?? this.scheduledPickupSlot,
      deliveryMode: deliveryMode ?? this.deliveryMode,
      driverType: driverType ?? this.driverType,
      items: items ?? this.items,
      bags: bags ?? this.bags,
      pricing: pricing ?? this.pricing,
    );
  }
}

// ============================================================================
//  NESTED MODELS
// ============================================================================

@immutable
class EarningsItem {
  final String itemId;
  final String itemName;
  final String serviceName;
  final String productCategoryName;
  final int quantity;

  //  PRICES IN DOLLARS (converted from cents)
  final double price;
  final double lineTotal;

  const EarningsItem({
    required this.itemId,
    required this.itemName,
    required this.serviceName,
    required this.productCategoryName,
    required this.quantity,
    required this.price,
    required this.lineTotal,
  });

  factory EarningsItem.fromApi(Map<String, dynamic> json) {
    return EarningsItem(
      itemId: json['itemId'] as String,
      itemName: json['itemName'] as String,
      serviceName: json['serviceName'] as String,
      productCategoryName: json['productCategoryName'] as String,
      quantity: json['quantity'] as int,
      //  Convert cents to dollars
      price: (json['price'] as num) / 100,
      lineTotal: (json['lineTotal'] as num) / 100,
    );
  }
}

@immutable
class EarningsBag {
  final String id;
  final String displayCode;
  final String status;

  const EarningsBag({
    required this.id,
    required this.displayCode,
    required this.status,
  });

  factory EarningsBag.fromApi(Map<String, dynamic> json) {
    return EarningsBag(
      id: json['_id'] as String,
      displayCode: json['displayCode'] as String,
      status: json['status'] as String,
    );
  }

  //  Formatted status for display
  String get formattedStatus {
    switch (status.toUpperCase()) {
      case 'DELIVERED_TO_USER':
        return 'Delivered';
      case 'ASSIGNED_TO_USER':
        return 'Assigned';
      case 'IN_TRANSIT':
        return 'In Transit';
      case 'OUT_FOR_DELIVERY':
        return 'Out for Delivery';
      default:
        return status;
    }
  }

  //  Status color for badge
  Color get statusColor {
    switch (status.toUpperCase()) {
      case 'DELIVERED_TO_USER':
        return Colors.green;
      case 'ASSIGNED_TO_USER':
        return Colors.blue;
      case 'IN_TRANSIT':
      case 'OUT_FOR_DELIVERY':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

@immutable
class EarningsPricing {
  //  ALL PRICES CONVERTED FROM CENTS TO DOLLARS
  final double itemsTotal;
  final double platformFee;
  final double pickupFee;
  final double deliveryFee;
  final double deliveryCharge;
  final double total;

  const EarningsPricing({
    required this.itemsTotal,
    required this.platformFee,
    required this.pickupFee,
    required this.deliveryFee,
    required this.deliveryCharge,
    required this.total,
  });

  factory EarningsPricing.fromApi(Map<String, dynamic> json) {
    return EarningsPricing(
      //  Convert all cents to dollars
      itemsTotal: (json['itemsTotal'] as num? ?? 0) / 100,
      platformFee: (json['platformFee'] as num? ?? 0) / 100,
      pickupFee: (json['pickupFee'] as num? ?? 0) / 100,
      deliveryFee: (json['deliveryFee'] as num? ?? 0) / 100,
      deliveryCharge: (json['deliveryCharge'] as num? ?? 0) / 100,
      total: (json['total'] as num? ?? 0) / 100,
    );
  }

  //  Formatted strings for UI display
  String get formattedItemsTotal => '\$${itemsTotal.toStringAsFixed(2)}';
  String get formattedPlatformFee =>
      platformFee > 0 ? '\$${platformFee.toStringAsFixed(2)}' : '—';
  String get formattedPickupFee =>
      pickupFee > 0 ? '\$${pickupFee.toStringAsFixed(2)}' : '—';
  String get formattedDeliveryFee =>
      deliveryFee > 0 ? '\$${deliveryFee.toStringAsFixed(2)}' : '—';
  String get formattedDeliveryCharge =>
      deliveryCharge > 0 ? '\$${deliveryCharge.toStringAsFixed(2)}' : '—';
  String get formattedTotal => '\$${total.toStringAsFixed(2)}';
}

// ============================================================================
//  EXTENSIONS
// ============================================================================

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
