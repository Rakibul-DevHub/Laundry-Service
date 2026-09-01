// ignore_for_file: always_specify_types

import 'package:drop_n_fresh/core/constants/app_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class OrderConfirmationResponse {
  final int code;
  final bool success;
  final String message;
  final OrderConfirmationData data;

  const OrderConfirmationResponse({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory OrderConfirmationResponse.fromJson(Map<String, dynamic> json) {
    return OrderConfirmationResponse(
      code: json['code'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: OrderConfirmationData.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'code': code,
    'success': success,
    'message': message,
    'data': data.toJson(),
  };
}

@immutable
class OrderConfirmationData {
  final String id;
  final UserInfo userId;
  final ProviderInfo providerId;
  final List<BagInfo> bagIds;
  final List<OrderItemInfo> orderItems;
  final String specialInstructions;
  final String? scheduledPickupDate;
  final String? scheduledPickupSlot;
  final String deliveryInstruction;
  final String driverType;
  final String deliveryMode;
  final String? deliveryZone;
  final double? distanceKm;
  final PricingInfo pricing;
  final String status;
  final String refundStatus;
  final LocationInfo? pickupLocation;
  final LocationInfo? dropoffLocation;
  final num deliveryPayout;
  final String paymentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? v; // __v field

  const OrderConfirmationData({
    required this.id,
    required this.userId,
    required this.providerId,
    required this.bagIds,
    required this.orderItems,
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
    required this.createdAt,
    required this.updatedAt,
    this.v,
  });

  factory OrderConfirmationData.fromJson(Map<String, dynamic> json) {
    return OrderConfirmationData(
      id: json['_id'] as String,
      userId: UserInfo.fromJson(json['userId'] as Map<String, dynamic>),
      providerId: ProviderInfo.fromJson(
        json['providerId'] as Map<String, dynamic>,
      ),
      bagIds: (json['bagIds'] as List)
          .map((b) => BagInfo.fromJson(b as Map<String, dynamic>))
          .toList(),
      orderItems: (json['orderItems'] as List)
          .map((item) => OrderItemInfo.fromJson(item as Map<String, dynamic>))
          .toList(),
      specialInstructions: json['specialInstructions'] as String,
      scheduledPickupDate: json['scheduledPickupDate'] as String?,
      scheduledPickupSlot: json['scheduledPickupSlot'] as String?,
      deliveryInstruction: json['deliveryInstruction'] as String,
      driverType: json['driverType'] as String,
      deliveryMode: json['deliveryMode'] as String,
      deliveryZone: json['deliveryZone'] as String?,
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
      pricing: PricingInfo.fromJson(json['pricing'] as Map<String, dynamic>),
      status: json['status'] as String,
      refundStatus: json['refundStatus'] as String,
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
      deliveryPayout: json['deliveryPayout'] as num,
      paymentStatus: json['paymentStatus'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'userId': userId.toJson(),
    'providerId': providerId.toJson(),
    'bagIds': bagIds.map((BagInfo b) => b.toJson()).toList(),
    'orderItems': orderItems
        .map((OrderItemInfo item) => item.toJson())
        .toList(),
    'specialInstructions': specialInstructions,
    if (scheduledPickupDate != null) 'scheduledPickupDate': scheduledPickupDate,
    if (scheduledPickupSlot != null) 'scheduledPickupSlot': scheduledPickupSlot,
    'deliveryInstruction': deliveryInstruction,
    'driverType': driverType,
    'deliveryMode': deliveryMode,
    'deliveryZone': deliveryZone,
    'distanceKm': distanceKm,
    'pricing': pricing.toJson(),
    'status': status,
    'refundStatus': refundStatus,
    if (pickupLocation != null) 'pickupLocation': pickupLocation!.toJson(),
    if (dropoffLocation != null) 'dropoffLocation': dropoffLocation!.toJson(),
    'deliveryPayout': deliveryPayout,
    'paymentStatus': paymentStatus,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    if (v != null) '__v': v,
  };
}

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
      id: json['_id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      profilePicture: AppConstants.resolveMediaUrl(json['profilePicture']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'fullName': fullName,
    'email': email,
    'phoneNumber': phoneNumber,
    if (profilePicture != null) 'profilePicture': profilePicture,
  };
}

@immutable
class ProviderInfo {
  final String id;
  final String fullName;
  final BusinessInfo businessInfo;
  final String? profilePicture;

  const ProviderInfo({
    required this.id,
    required this.fullName,
    required this.businessInfo,
    this.profilePicture,
  });

  factory ProviderInfo.fromJson(Map<String, dynamic> json) {
    return ProviderInfo(
      id: json['_id'] as String,
      fullName: json['fullName'] as String,
      businessInfo: BusinessInfo.fromJson(
        json['businessInfo'] as Map<String, dynamic>,
      ),
      profilePicture: AppConstants.resolveMediaUrl(json['profilePicture']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'fullName': fullName,
    'businessInfo': businessInfo.toJson(),
    if (profilePicture != null) 'profilePicture': profilePicture,
  };
}

@immutable
class BusinessInfo {
  final String businessName;

  const BusinessInfo({required this.businessName});

  factory BusinessInfo.fromJson(Map<String, dynamic> json) {
    return BusinessInfo(businessName: json['businessName'] as String);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'businessName': businessName,
  };
}

@immutable
class BagInfo {
  final String id;
  final String qrCode;
  final String displayCode;
  final String status;

  const BagInfo({
    required this.id,
    required this.qrCode,
    required this.displayCode,
    required this.status,
  });

  factory BagInfo.fromJson(Map<String, dynamic> json) {
    return BagInfo(
      id: json['_id'] as String,
      qrCode: json['qrCode'] as String,
      displayCode: json['displayCode'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    '_id': id,
    'qrCode': qrCode,
    'displayCode': displayCode,
    'status': status,
  };
}

@immutable
class OrderItemInfo {
  final String serviceId;
  final String serviceName;
  final String productCategoryId;
  final String productCategoryName;
  final String itemId;
  final String itemName;
  final num price; // in cents
  final int quantity;
  final num lineTotal; // in cents

  const OrderItemInfo({
    required this.serviceId,
    required this.serviceName,
    required this.productCategoryId,
    required this.productCategoryName,
    required this.itemId,
    required this.itemName,
    required this.price,
    required this.quantity,
    required this.lineTotal,
  });

  factory OrderItemInfo.fromJson(Map<String, dynamic> json) {
    return OrderItemInfo(
      serviceId: json['serviceId'] as String,
      serviceName: json['serviceName'] as String,
      productCategoryId: json['productCategoryId'] as String,
      productCategoryName: json['productCategoryName'] as String,
      itemId: json['itemId'] as String,
      itemName: json['itemName'] as String,
      price: json['price'] as num,
      quantity: json['quantity'] as int,
      lineTotal: json['lineTotal'] as num,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'serviceId': serviceId,
    'serviceName': serviceName,
    'productCategoryId': productCategoryId,
    'productCategoryName': productCategoryName,
    'itemId': itemId,
    'itemName': itemName,
    'price': price,
    'quantity': quantity,
    'lineTotal': lineTotal,
  };

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
      itemsTotal: json['itemsTotal'] as int,
      platformFee: json['platformFee'] as int,
      pickupFee: json['pickupFee'] as int,
      deliveryFee: json['deliveryFee'] as int,
      deliveryCharge: json['deliveryCharge'] as int,
      total: json['total'] as int,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'itemsTotal': itemsTotal,
    'platformFee': platformFee,
    'pickupFee': pickupFee,
    'deliveryFee': deliveryFee,
    'deliveryCharge': deliveryCharge,
    'total': total,
  };
}

@immutable
class LocationInfo {
  final String? address;
  final double? latitude;
  final double? longitude;

  const LocationInfo({
    this.address,
    this.latitude,
    this.longitude,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
      address: json['address'] as String?,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    if (address != null) 'address': address,
    if (latitude != null) 'latitude': latitude,
    if (longitude != null) 'longitude': longitude,
  };
}

extension OrderStatusFormatter on String {
  String get formattedStatus {
    switch (toUpperCase()) {
      case 'PENDING':
        return 'Pending';
      case 'CONFIRMED':
        return 'Confirmed';
      case 'IN_PROGRESS':
        return 'In Progress';
      case 'COMPLETED':
        return 'Completed';
      case 'CANCELLED':
        return 'Cancelled';
      default:
        return this;
    }
  }
}

extension BagStatusFormatter on String {
  String get formattedBagStatus {
    switch (toUpperCase()) {
      case 'READY_FOR_DELIVERY':
        return 'Ready for Delivery';
      case 'ASSIGNED_TO_USER':
        return 'Assigned to User';
      case 'IN_TRANSIT':
        return 'In Transit';
      case 'DELIVERED':
        return 'Delivered';
      default:
        return this;
    }
  }
}
