// features/orders/provider/models/orders_model.dart

// ignore_for_file: always_specify_types

import 'package:drop_n_fresh/core/constants/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/order_status_type.dart';

@immutable
class OrdersModel {
  //  Core fields your UI expects
  final String id;
  final double amount; // pricing.total / 100
  final DateTime date; // createdAt
  final String customerProfile; // userInfo.profilePicture
  final String customerName; // userInfo.fullName
  final String customerPhone; // userInfo.phoneNumber
  final String pickUpAddress; // pickupLocation.address
  final String dropOffAddress; // dropoffLocation.address
  final List<OrderItem> items; // orderItems
  final int totalItems; // sum of quantities
  final String serviceType; // first item's serviceName
  final OrderStatusType orderStatusType; // mapped from backend status

  //  Full API data for details screen
  final String userId;
  final UserInfo userInfo;
  final String providerId;
  final List<BagInfo> bags;
  final String specialInstructions;
  final String? scheduledPickupDate;
  final String? scheduledPickupSlot;
  final String deliveryInstruction;
  final String driverType;
  final String deliveryMode;
  final String deliveryZone;
  final double distanceKm;
  final PricingInfo pricing;
  final String status; // raw backend status
  final String refundStatus;
  final LocationInfo? pickupLocation;
  final LocationInfo? dropoffLocation;
  final num deliveryPayout;
  final String paymentStatus;
  final DateTime updatedAt;

  const OrdersModel({
    required this.id,
    required this.amount,
    required this.date,
    required this.customerProfile,
    required this.customerName,
    required this.customerPhone,
    required this.pickUpAddress,
    required this.dropOffAddress,
    required this.items,
    required this.totalItems,
    required this.serviceType,
    required this.orderStatusType,
    required this.userId,
    required this.userInfo,
    required this.providerId,
    required this.bags,
    required this.specialInstructions,
    this.scheduledPickupDate,
    this.scheduledPickupSlot,
    required this.deliveryInstruction,
    required this.driverType,
    required this.deliveryMode,
    required this.deliveryZone,
    required this.distanceKm,
    required this.pricing,
    required this.status,
    required this.refundStatus,
    this.pickupLocation,
    this.dropoffLocation,
    required this.deliveryPayout,
    required this.paymentStatus,
    required this.updatedAt,
  });

  //  Map API response to your UI-friendly model
  factory OrdersModel.fromApiResponse(Map<String, dynamic> json) {
    final List<dynamic> itemsJson =
        (json['orderItems'] as List? ?? <dynamic>[]);
    final List<dynamic> bagsJson = (json['bagIds'] as List? ?? <dynamic>[]);
    final Map<String, dynamic> pricingJson =
        json['pricing'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final Map<String, dynamic> userJson =
        json['userId'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final pickupLocJson = json['pickupLocation'];
    final dropoffLocJson = json['dropoffLocation'];
    final String backendStatus = json['status'] as String? ?? 'PENDING';

    // Parse nested models
    final UserInfo userInfo = UserInfo.fromJson(userJson);
    final List<OrderItem> items = itemsJson
        .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
        .toList();
    final List<BagInfo> bags = bagsJson
        .map((bag) => BagInfo.fromJson(bag as Map<String, dynamic>))
        .toList();
    final PricingInfo pricing = PricingInfo.fromJson(pricingJson);
    final LocationInfo? pickupLocation = pickupLocJson != null
        ? LocationInfo.fromJson(pickupLocJson as Map<String, dynamic>)
        : null;
    final LocationInfo? dropoffLocation = dropoffLocJson != null
        ? LocationInfo.fromJson(dropoffLocJson as Map<String, dynamic>)
        : null;

    return OrdersModel(
      //  Core UI fields
      id: json['_id'] as String,
      amount: pricing.total / 100, // cents → dollars
      date: DateTime.parse(json['createdAt'] as String),
      customerProfile: userInfo.profilePicture ?? '',
      customerName: userInfo.fullName,
      customerPhone: userInfo.phoneNumber,
      pickUpAddress: pickupLocation?.address ?? '',
      dropOffAddress: dropoffLocation?.address ?? '',
      items: items,
      totalItems: items.fold(
        0,
        (int sum, OrderItem item) => sum + item.quantity,
      ),
      serviceType: items.isNotEmpty
          ? items.first.serviceName
          : 'Laundry Service',
      orderStatusType: _mapBackendStatusToEnum(backendStatus),

      //  Full API data for details screen
      userId: userInfo.id,
      userInfo: userInfo,
      providerId: json['providerId'] as String? ?? '',
      bags: bags,
      specialInstructions: json['specialInstructions'] as String? ?? '',
      scheduledPickupDate: json['scheduledPickupDate'] as String?,
      scheduledPickupSlot: json['scheduledPickupSlot'] as String?,
      deliveryInstruction: json['deliveryInstruction'] as String? ?? '',
      driverType: json['driverType'] as String? ?? '',
      deliveryMode: json['deliveryMode'] as String? ?? '',
      deliveryZone: json['deliveryZone'] as String? ?? '',
      distanceKm: (json['distanceKm'] as num? ?? 0).toDouble(),
      pricing: pricing,
      status: backendStatus,
      refundStatus: json['refundStatus'] as String? ?? '',
      pickupLocation: pickupLocation,
      dropoffLocation: dropoffLocation,
      deliveryPayout: json['deliveryPayout'] as num? ?? 0,
      paymentStatus: json['paymentStatus'] as String? ?? 'unpaid',
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  //  Map backend status string → your OrderStatusType enum
  static OrderStatusType _mapBackendStatusToEnum(String backendStatus) {
    switch (backendStatus.toUpperCase()) {
      case 'PENDING':
        return OrderStatusType.newBookings;
      case 'CONFIRMED':
      case 'AWAITING_PICKUP_RIDER':
      case 'PICKUP_RIDER_ASSIGNED':
        return OrderStatusType.acceptOrders;
      case 'RECEIVED_AT_PROVIDER':
        return OrderStatusType.receivedOrders;
      case 'ARRIVED_AT_PROVIDER':
        return OrderStatusType.readyToReceive;
      case 'IN_PROCESSING':
        return OrderStatusType.processingOrders;
      case 'READY_FOR_DELIVERY':
      case 'AWAITING_DELIVERY_RIDER':
        return OrderStatusType.readyForDelivery;
      case 'OUT_FOR_DELIVERY':
      case 'DELIVERED':
      case 'SELF_PICKED_UP':
        return OrderStatusType.completedOrders;
      case 'CANCELLED':
        return OrderStatusType.canceledOrders;
      default:
        return OrderStatusType.newBookings;
    }
  }

  //  Formatted date for display
  String get formattedDate {
    final DateTime now = DateTime.now();
    final Duration diff = now.difference(date);

    if (diff.inHours < 24 && diff.inDays == 0) {
      return 'Today';
    }
    if (diff.inDays == 1) {
      return 'Yesterday';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    }
    return '${date.day} ${_monthName(date.month)} ${date.year}';
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
}

// ============================================================================
//  NESTED MODELS (For parsing API)
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
class OrderItem {
  final String itemId;
  final String itemName;
  final String serviceName;
  final String productCategoryName;
  final int quantity;
  final num price; // in cents
  final num lineTotal; // in cents

  const OrderItem({
    required this.itemId,
    required this.itemName,
    required this.serviceName,
    required this.productCategoryName,
    required this.quantity,
    required this.price,
    required this.lineTotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
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
  final int itemsTotal;
  final int platformFee;
  final int pickupFee;
  final int deliveryFee;
  final int deliveryCharge;
  final int total;

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
