// features/orders/user/models/user_order_model.dart

// ignore_for_file: avoid_dynamic_calls, always_specify_types

import 'package:drop_n_fresh/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

//  API Response Wrapper
@immutable
class UserOrdersResponse {
  final int code;
  final bool success;
  final String message;
  final UserOrdersData data;

  const UserOrdersResponse({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserOrdersResponse.fromJson(Map<String, dynamic> json) {
    return UserOrdersResponse(
      code: json['code'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: UserOrdersData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

//  Data wrapper with orders + pagination
@immutable
class UserOrdersData {
  final List<UserOrderModel> orders;
  final PaginationInfo pagination;

  const UserOrdersData({
    required this.orders,
    required this.pagination,
  });

  factory UserOrdersData.fromJson(Map<String, dynamic> json) {
    return UserOrdersData(
      orders: (json['orders'] as List)
          .map((item) => UserOrderModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      pagination: PaginationInfo.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );
  }
}

// ============================================================================
//  MAIN ORDER MODEL - Maps your API response to UI-friendly fields
// ============================================================================

@immutable
class UserOrderModel {
  //  Core fields for list view
  final String id;
  final String serviceName; // From first order item
  final String bagId; // From first bag's displayCode
  final List<String> services; // Unique category names
  final int totalItems; // Sum of all quantities
  final double totalCost; // pricing.total / 100 (cents → dollars)
  final String status; // Raw backend status (one of 13 values)
  final DateTime createdAt;

  //  Provider info for display
  final ProviderInfo provider;

  //  For details screen (optional: store raw data or parse fully)
  final List<OrderItemInfo> orderItems;
  final List<BagInfo> bags;
  final String specialInstructions;
  final String? scheduledPickupDate;
  final String? scheduledPickupSlot;
  final String deliveryInstruction;
  final String driverType;
  final PricingInfo pricing;
  final LocationInfo? pickupLocation;
  final LocationInfo? dropoffLocation;
  final String paymentStatus;

  const UserOrderModel({
    required this.id,
    required this.serviceName,
    required this.bagId,
    required this.services,
    required this.totalItems,
    required this.totalCost,
    required this.status,
    required this.createdAt,
    required this.provider,
    required this.orderItems,
    required this.bags,
    required this.specialInstructions,
    this.scheduledPickupDate,
    this.scheduledPickupSlot,
    required this.deliveryInstruction,
    required this.driverType,
    required this.pricing,
    this.pickupLocation,
    this.dropoffLocation,
    required this.paymentStatus,
  });

  //  Map complex API response → your UI model
  factory UserOrderModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> orderItemsJson =
        (json['orderItems'] as List? ?? <dynamic>[]);
    final List<dynamic> bagsJson = (json['bagIds'] as List? ?? <dynamic>[]);
    final Map<String, dynamic> pricingJson =
        json['pricing'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final Map<String, dynamic> providerJson =
        json['providerId'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return UserOrderModel(
      // Core fields
      id: json['_id'] as String,

      // serviceName: First order item's service name
      serviceName: orderItemsJson.isNotEmpty
          ? orderItemsJson.first['serviceName'] as String
          : 'Laundry Service',

      // bagId: First bag's display code
      bagId: bagsJson.isNotEmpty
          ? (bagsJson.first['displayCode'] as String?) ?? 'N/A'
          : 'N/A',

      // services: Unique category names from order items
      services: orderItemsJson
          .map((item) => item['productCategoryName'] as String)
          .toSet()
          .toList(),

      // totalItems: Sum of all quantities
      totalItems: orderItemsJson.fold(
        0,
        (int sum, item) => sum + (item['quantity'] as int),
      ),

      // totalCost: pricing.total in cents → dollars
      totalCost: (pricingJson['total'] as int? ?? 0) / 100,

      // status: Raw backend status
      status: json['status'] as String? ?? 'PENDING',

      createdAt: DateTime.parse(json['createdAt'] as String),

      // Provider info
      provider: ProviderInfo.fromJson(providerJson),

      // Full data for details screen
      orderItems: orderItemsJson
          .map((item) => OrderItemInfo.fromJson(item as Map<String, dynamic>))
          .toList(),
      bags: bagsJson
          .map((bag) => BagInfo.fromJson(bag as Map<String, dynamic>))
          .toList(),
      specialInstructions: json['specialInstructions'] as String? ?? '',
      scheduledPickupDate: json['scheduledPickupDate'] as String?,
      scheduledPickupSlot: json['scheduledPickupSlot'] as String?,
      deliveryInstruction: json['deliveryInstruction'] as String? ?? '',
      driverType: json['driverType'] as String? ?? '',
      pricing: PricingInfo.fromJson(pricingJson),
      pickupLocation: json['pickupLocation'] != null
          ? LocationInfo.fromJson(
              json['pickupLocation'] as Map<String, dynamic>,
            )
          : null,
      dropoffLocation: json['dropoffLocation'] != null
          ? LocationInfo.fromJson(
              json['dropoffLocation'] as Map<String, dynamic>,
            )
          : null,
      paymentStatus: json['paymentStatus'] as String? ?? 'unpaid',
    );
  }

  //  Formatted backend status with proper capitalization
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
}

// ============================================================================
//  NESTED MODELS (For parsing API - not exposed to UI directly)
// ============================================================================

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
class BagInfo {
  final String id;
  final String displayCode;
  final String qrCode;

  const BagInfo({
    required this.id,
    required this.displayCode,
    required this.qrCode,
  });

  factory BagInfo.fromJson(Map<String, dynamic> json) {
    return BagInfo(
      id: json['_id'] as String,
      displayCode: json['displayCode'] as String,
      qrCode: json['qrCode'] as String,
    );
  }
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

//  Pagination Info
@immutable
class PaginationInfo {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const PaginationInfo({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      total: json['total'] as int,
      page: json['page'] as int,
      limit: json['limit'] as int,
      totalPages: json['totalPages'] as int,
    );
  }

  bool get hasMore => page < totalPages;
}
