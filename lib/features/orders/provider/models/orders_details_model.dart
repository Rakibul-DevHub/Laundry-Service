// features/orders/provider/models/orders_details_model.dart

// ignore_for_file: always_specify_types

import 'package:drop_n_fresh/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

import '../models/order_status_type.dart';

// ============================================================================
//  MAIN ORDER DETAILS MODEL - Maps your API response
// ============================================================================

@immutable
class OrdersDetailsModel {
  //  Core order fields
  final String id;
  final String userId;
  final String providerId;
  final String status; // Raw backend status
  final OrderStatusType orderStatusType; // Mapped enum for UI
  final String refundStatus;
  final String paymentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  //  User info
  final UserInfo userInfo;

  //  Provider info
  final ProviderInfo providerInfo;

  //  Bags
  final List<BagInfo> bags;

  //  Order items
  final List<OrderItemInfo> orderItems;

  //  Pricing
  final PricingInfo pricing;

  //  Locations
  final LocationInfo? pickupLocation;
  final LocationInfo? dropoffLocation;

  //  Delivery info
  final String specialInstructions;
  final String? scheduledPickupDate;
  final String? scheduledPickupSlot;
  final String deliveryInstruction;
  final String driverType;
  final String deliveryMode;
  final String deliveryZone;
  final double distanceKm;
  final num deliveryPayout;

  //  Cancellation/Refund fields (for cancelled orders)
  final num? cancellationFee;
  final String? cancellationRequestedAt;
  final String? cancellationRequestedBy;
  final num? refundAmount;
  final int? refundPercentage;
  final String? refundCompletedAt;

  //  Stripe payment fields
  final String? stripeCheckoutSessionId;
  final String? paidAt;
  final String? stripePaymentIntentId;
  final String? stripeRefundId;

  const OrdersDetailsModel({
    required this.id,
    required this.userId,
    required this.providerId,
    required this.status,
    required this.orderStatusType,
    required this.refundStatus,
    required this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.userInfo,
    required this.providerInfo,
    required this.bags,
    required this.orderItems,
    required this.pricing,
    this.pickupLocation,
    this.dropoffLocation,
    required this.specialInstructions,
    this.scheduledPickupDate,
    this.scheduledPickupSlot,
    required this.deliveryInstruction,
    required this.driverType,
    required this.deliveryMode,
    required this.deliveryZone,
    required this.distanceKm,
    required this.deliveryPayout,
    this.cancellationFee,
    this.cancellationRequestedAt,
    this.cancellationRequestedBy,
    this.refundAmount,
    this.refundPercentage,
    this.refundCompletedAt,
    this.stripeCheckoutSessionId,
    this.paidAt,
    this.stripePaymentIntentId,
    this.stripeRefundId,
  });

  //  Map API response to model
  factory OrdersDetailsModel.fromApiResponse(Map<String, dynamic> json) {
    final List<dynamic> itemsJson =
        (json['orderItems'] as List? ?? <dynamic>[]);
    final List<dynamic> bagsJson = (json['bagIds'] as List? ?? <dynamic>[]);
    final Map<String, dynamic> pricingJson =
        json['pricing'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final Map<String, dynamic> userJson =
        json['userId'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final Map<String, dynamic> providerJson =
        json['providerId'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final pickupLocJson = json['pickupLocation'];
    final dropoffLocJson = json['dropoffLocation'];
    final String backendStatus = json['status'] as String? ?? 'PENDING';

    return OrdersDetailsModel(
      // Core fields
      id: json['_id'] as String,
      userId: userJson['_id'] as String? ?? '',
      providerId: json['providerId'] is String
          ? json['providerId'] as String
          : (providerJson['_id'] as String? ?? ''),
      status: backendStatus,
      orderStatusType: _mapBackendStatusToEnum(backendStatus),
      refundStatus: json['refundStatus'] as String? ?? '',
      paymentStatus: json['paymentStatus'] as String? ?? 'unpaid',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),

      // Nested objects
      userInfo: UserInfo.fromJson(userJson),
      providerInfo: ProviderInfo.fromJson(providerJson),
      bags: bagsJson
          .map((b) => BagInfo.fromJson(b as Map<String, dynamic>))
          .toList(),
      orderItems: itemsJson
          .map((item) => OrderItemInfo.fromJson(item as Map<String, dynamic>))
          .toList(),
      pricing: PricingInfo.fromJson(pricingJson),

      // Locations
      pickupLocation: pickupLocJson != null
          ? LocationInfo.fromJson(pickupLocJson as Map<String, dynamic>)
          : null,
      dropoffLocation: dropoffLocJson != null
          ? LocationInfo.fromJson(dropoffLocJson as Map<String, dynamic>)
          : null,

      // Delivery info
      specialInstructions: json['specialInstructions'] as String? ?? '',
      scheduledPickupDate: json['scheduledPickupDate'] as String?,
      scheduledPickupSlot: json['scheduledPickupSlot'] as String?,
      deliveryInstruction: json['deliveryInstruction'] as String? ?? '',
      driverType: json['driverType'] as String? ?? '',
      deliveryMode: json['deliveryMode'] as String? ?? '',
      deliveryZone: json['deliveryZone'] as String? ?? '',
      distanceKm: (json['distanceKm'] as num? ?? 0).toDouble(),
      deliveryPayout: json['deliveryPayout'] as num? ?? 0,

      // Cancellation/Refund
      cancellationFee: json['cancellationFee'] as num?,
      cancellationRequestedAt: json['cancellationRequestedAt'] as String?,
      cancellationRequestedBy: json['cancellationRequestedBy'] as String?,
      refundAmount: json['refundAmount'] as num?,
      refundPercentage: json['refundPercentage'] as int?,
      refundCompletedAt: json['refundCompletedAt'] as String?,

      // Stripe
      stripeCheckoutSessionId: json['stripeCheckoutSessionId'] as String?,
      paidAt: json['paidAt'] as String?,
      stripePaymentIntentId: json['stripePaymentIntentId'] as String?,
      stripeRefundId: json['stripeRefundId'] as String?,
    );
  }

  //  Map backend status string → OrderStatusType enum
  static OrderStatusType _mapBackendStatusToEnum(String backendStatus) {
    switch (backendStatus.toUpperCase()) {
      case 'PENDING':
        return OrderStatusType.newBookings;
      case 'CONFIRMED':
      case 'AWAITING_PICKUP_RIDER':
      case 'PICKUP_RIDER_ASSIGNED':
        return OrderStatusType.acceptOrders;
      case 'PICKED_UP':
        return OrderStatusType.receivedOrders;
      case 'IN_PROCESSING':
        return OrderStatusType.processingOrders;
      case 'READY_FOR_DELIVERY':
      case 'AWAITING_DELIVERY_RIDER':
      case 'DELIVERY_RIDER_ASSIGNED':
        return OrderStatusType.readyForDelivery;
      case 'OUT_FOR_DELIVERY':
      case 'DELIVERED':
      case 'SELF_PICKED_UP':
        return OrderStatusType.completedOrders;
      case 'CANCELLED':
        return OrderStatusType.completedOrders;
      default:
        return OrderStatusType.newBookings;
    }
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

  //  Formatted backend status
  String get formattedBackendStatus {
    return _formatBackendStatus(status);
  }

  static String _formatBackendStatus(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Pending';
      case 'CONFIRMED':
        return 'Confirmed';
      case 'AWAITING_PICKUP_RIDER':
        return 'Awaiting Pickup';
      case 'PICKUP_RIDER_ASSIGNED':
        return 'Rider Assigned';
      case 'PICKED_UP':
        return 'Picked Up';
      case 'IN_PROCESSING':
        return 'In Progress';
      case 'READY_FOR_DELIVERY':
        return 'Ready';
      case 'AWAITING_DELIVERY_RIDER':
        return 'Awaiting Delivery';
      case 'DELIVERY_RIDER_ASSIGNED':
        return 'Delivery Assigned';
      case 'OUT_FOR_DELIVERY':
        return 'Out for Delivery';
      case 'DELIVERED':
        return 'Delivered';
      case 'SELF_PICKED_UP':
        return 'Self Pickup';
      case 'CANCELLED':
        return 'Cancelled';
      default:
        return status;
    }
  }

  //  Status color for badge
  Color get statusColor {
    return _getStatusColor(status);
  }

  static Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
      case 'AWAITING_PICKUP_RIDER':
      case 'AWAITING_DELIVERY_RIDER':
        return Colors.orange;
      case 'CONFIRMED':
      case 'PICKUP_RIDER_ASSIGNED':
      case 'DELIVERY_RIDER_ASSIGNED':
        return Colors.blue;
      case 'PICKED_UP':
      case 'OUT_FOR_DELIVERY':
        return Colors.purple;
      case 'IN_PROCESSING':
      case 'READY_FOR_DELIVERY':
        return Colors.teal;
      case 'DELIVERED':
      case 'SELF_PICKED_UP':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  //  CopyWith for immutability
  OrdersDetailsModel copyWith({
    String? id,
    String? userId,
    String? providerId,
    String? status,
    OrderStatusType? orderStatusType,
    String? refundStatus,
    String? paymentStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserInfo? userInfo,
    ProviderInfo? providerInfo,
    List<BagInfo>? bags,
    List<OrderItemInfo>? orderItems,
    PricingInfo? pricing,
    LocationInfo? pickupLocation,
    LocationInfo? dropoffLocation,
    String? specialInstructions,
    String? scheduledPickupDate,
    String? scheduledPickupSlot,
    String? deliveryInstruction,
    String? driverType,
    String? deliveryMode,
    String? deliveryZone,
    double? distanceKm,
    num? deliveryPayout,
    num? cancellationFee,
    String? cancellationRequestedAt,
    String? cancellationRequestedBy,
    num? refundAmount,
    int? refundPercentage,
    String? refundCompletedAt,
    String? stripeCheckoutSessionId,
    String? paidAt,
    String? stripePaymentIntentId,
    String? stripeRefundId,
  }) {
    return OrdersDetailsModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      providerId: providerId ?? this.providerId,
      status: status ?? this.status,
      orderStatusType: orderStatusType ?? this.orderStatusType,
      refundStatus: refundStatus ?? this.refundStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userInfo: userInfo ?? this.userInfo,
      providerInfo: providerInfo ?? this.providerInfo,
      bags: bags ?? this.bags,
      orderItems: orderItems ?? this.orderItems,
      pricing: pricing ?? this.pricing,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropoffLocation: dropoffLocation ?? this.dropoffLocation,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      scheduledPickupDate: scheduledPickupDate ?? this.scheduledPickupDate,
      scheduledPickupSlot: scheduledPickupSlot ?? this.scheduledPickupSlot,
      deliveryInstruction: deliveryInstruction ?? this.deliveryInstruction,
      driverType: driverType ?? this.driverType,
      deliveryMode: deliveryMode ?? this.deliveryMode,
      deliveryZone: deliveryZone ?? this.deliveryZone,
      distanceKm: distanceKm ?? this.distanceKm,
      deliveryPayout: deliveryPayout ?? this.deliveryPayout,
      cancellationFee: cancellationFee ?? this.cancellationFee,
      cancellationRequestedAt:
          cancellationRequestedAt ?? this.cancellationRequestedAt,
      cancellationRequestedBy:
          cancellationRequestedBy ?? this.cancellationRequestedBy,
      refundAmount: refundAmount ?? this.refundAmount,
      refundPercentage: refundPercentage ?? this.refundPercentage,
      refundCompletedAt: refundCompletedAt ?? this.refundCompletedAt,
      stripeCheckoutSessionId:
          stripeCheckoutSessionId ?? this.stripeCheckoutSessionId,
      paidAt: paidAt ?? this.paidAt,
      stripePaymentIntentId:
          stripePaymentIntentId ?? this.stripePaymentIntentId,
      stripeRefundId: stripeRefundId ?? this.stripeRefundId,
    );
  }
}

// ============================================================================
//  NESTED MODELS
// ============================================================================

@immutable
class UserInfo {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? profilePicture;

  const UserInfo({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.profilePicture,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['_id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      profilePicture: AppConstants.resolveMediaUrl(json['profilePicture']),
    );
  }
}

@immutable
class ProviderInfo {
  final String id;
  final String fullName;
  final String businessName;
  final String? profilePicture;

  const ProviderInfo({
    required this.id,
    required this.fullName,
    required this.businessName,
    this.profilePicture,
  });

  factory ProviderInfo.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> businessInfo =
        json['businessInfo'] as Map<String, dynamic>? ?? <String, dynamic>{};
    return ProviderInfo(
      id: json['_id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      businessName: businessInfo['businessName'] as String? ?? '',
      profilePicture: AppConstants.resolveMediaUrl(json['profilePicture']),
    );
  }
}

@immutable
class BagInfo {
  final String id;
  final String displayCode;
  final String qrCode;
  final String status;

  const BagInfo({
    required this.id,
    required this.displayCode,
    required this.qrCode,
    required this.status,
  });

  factory BagInfo.fromJson(Map<String, dynamic> json) {
    return BagInfo(
      id: json['_id'] as String,
      displayCode: json['displayCode'] as String,
      qrCode: json['qrCode'] as String,
      status: json['status'] as String? ?? '',
    );
  }

  String get formattedStatus {
    switch (status.toUpperCase()) {
      case 'DELIVERED_TO_USER':
        return 'Delivered';
      case 'ASSIGNED_TO_USER':
        return 'Assigned';
      case 'IN_TRANSIT':
        return 'In Transit';
      default:
        return status;
    }
  }

  Color get statusColor {
    switch (status.toUpperCase()) {
      case 'DELIVERED_TO_USER':
        return Colors.green;
      case 'ASSIGNED_TO_USER':
        return Colors.blue;
      case 'IN_TRANSIT':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

@immutable
class OrderItemInfo {
  final String itemId;
  final String itemName;
  final String serviceName;
  final String productCategoryName;
  final int quantity;
  final num price; // in cents
  final num lineTotal; // in cents

  const OrderItemInfo({
    required this.itemId,
    required this.itemName,
    required this.serviceName,
    required this.productCategoryName,
    required this.quantity,
    required this.price,
    required this.lineTotal,
  });

  factory OrderItemInfo.fromJson(Map<String, dynamic> json) {
    return OrderItemInfo(
      itemId: json['itemId'] as String,
      itemName: json['itemName'] as String,
      serviceName: json['serviceName'] as String,
      productCategoryName: json['productCategoryName'] as String,
      quantity: json['quantity'] as int,
      price: json['price'] as num,
      lineTotal: json['lineTotal'] as num,
    );
  }

  //  Helper: Convert cents to dollars
  double get priceDollars => price / 100;
  double get lineTotalDollars => lineTotal / 100;
}

@immutable
class PricingInfo {
  final int itemsTotal; // in cents
  final int platformFee; // in cents
  final int pickupFee; // in cents
  final int deliveryFee; // in cents
  final int deliveryCharge; // in cents
  final int total; // in cents

  const PricingInfo({
    required this.itemsTotal,
    required this.platformFee,
    required this.pickupFee,
    required this.deliveryFee,
    required this.deliveryCharge,
    required this.total,
  });

  factory PricingInfo.fromJson(Map<String, dynamic> json) {
    return PricingInfo(
      itemsTotal: json['itemsTotal'] as int? ?? 0,
      platformFee: json['platformFee'] as int? ?? 0,
      pickupFee: json['pickupFee'] as int? ?? 0,
      deliveryFee: json['deliveryFee'] as int? ?? 0,
      deliveryCharge: json['deliveryCharge'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
    );
  }

  //  Helper: Convert cents to dollars
  double get itemsTotalDollars => itemsTotal / 100;
  double get platformFeeDollars => platformFee / 100;
  double get pickupFeeDollars => pickupFee / 100;
  double get deliveryFeeDollars => deliveryFee / 100;
  double get deliveryChargeDollars => deliveryCharge / 100;
  double get totalDollars => total / 100;
}

@immutable
class LocationInfo {
  final String? address;
  final double? latitude;
  final double? longitude;

  const LocationInfo({this.address, this.latitude, this.longitude});

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
      address: json['address'] as String?,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
    );
  }
}
