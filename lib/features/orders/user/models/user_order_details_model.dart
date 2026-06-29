// features/orders/user/models/user_order_details_model.dart

// ignore_for_file: always_specify_types

import 'package:flutter/material.dart';

// ============================================================================
//  MAIN ORDER DETAILS MODEL - Maps your API response
// ============================================================================

@immutable
class UserOrderDetailsModel {
  final String id;
  final String userId;
  final UserInfo userInfo;
  final ProviderInfo provider;
  final List<BagInfo> bags;
  final List<OrderItemInfo> orderItems;
  final String specialInstructions;
  final String? scheduledPickupDate;
  final String? scheduledPickupSlot;
  final String deliveryInstruction;
  final String driverType;
  final String deliveryMode;
  final String deliveryZone;
  final double distanceKm;
  final PricingInfo pricing;
  final String status;
  final String refundStatus;
  final LocationInfo? pickupLocation;
  final LocationInfo? dropoffLocation;
  final num deliveryPayout;
  final bool isDelivery;
  final String paymentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  //  For timeline display
  final List<OrderTimeline> orderTimeline;

  const UserOrderDetailsModel({
    required this.id,
    required this.userId,
    required this.userInfo,
    required this.provider,
    required this.bags,
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
    required this.isDelivery,
    required this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.orderTimeline,
  });

  //  Map API response to model
  factory UserOrderDetailsModel.fromApiResponse(Map<String, dynamic> json) {
    final List<dynamic> orderItemsJson =
        (json['orderItems'] as List? ?? <dynamic>[]);
    final List<dynamic> bagsJson = (json['bagIds'] as List? ?? <dynamic>[]);
    final Map<String, dynamic> pricingJson =
        json['pricing'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final Map<String, dynamic> providerJson =
        json['providerId'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final Map<String, dynamic> userJson =
        json['userId'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final pickupLocJson = json['pickupLocation'];
    final dropoffLocJson = json['dropoffLocation'];

    return UserOrderDetailsModel(
      id: json['_id'] as String,
      userId: json['userId'] is String
          ? json['userId'] as String
          : (userJson['_id'] as String? ?? ''),
      userInfo: UserInfo.fromJson(userJson),
      provider: ProviderInfo.fromJson(providerJson),
      bags: bagsJson
          .map((bag) => BagInfo.fromJson(bag as Map<String, dynamic>))
          .toList(),
      orderItems: orderItemsJson
          .map((item) => OrderItemInfo.fromJson(item as Map<String, dynamic>))
          .toList(),
      specialInstructions: json['specialInstructions'] as String? ?? '',
      scheduledPickupDate: json['scheduledPickupDate'] as String?,
      scheduledPickupSlot: json['scheduledPickupSlot'] as String?,
      deliveryInstruction: json['deliveryInstruction'] as String? ?? '',
      driverType: json['driverType'] as String? ?? '',
      deliveryMode: json['deliveryMode'] as String? ?? '',
      deliveryZone: json['deliveryZone'] as String? ?? '',
      distanceKm: (json['distanceKm'] as num? ?? 0).toDouble(),
      pricing: PricingInfo.fromJson(pricingJson),
      status: json['status'] as String? ?? 'PENDING',
      refundStatus: json['refundStatus'] as String? ?? '',
      pickupLocation: pickupLocJson != null
          ? LocationInfo.fromJson(pickupLocJson as Map<String, dynamic>)
          : null,
      dropoffLocation: dropoffLocJson != null
          ? LocationInfo.fromJson(dropoffLocJson as Map<String, dynamic>)
          : null,
      deliveryPayout: json['deliveryPayout'] as num? ?? 0,
      isDelivery: json['isDelivery'] as bool? ?? false,

      paymentStatus: json['paymentStatus'] as String? ?? 'unpaid',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),

      //  Generate timeline from status
      orderTimeline: generateTimeline(
        json['status'] as String? ?? 'PENDING',
        isDelivery: json['isDelivery'] as bool? ?? false,
        deliveryMode: json['deliveryMode'] as String? ?? '',
        createdAt: DateTime.parse(json['createdAt'] as String),
        pickupCompletedAt: json['pickupCompletedAt'] as String?,
        deliveryCompletedAt: json['deliveryCompletedAt'] as String?,
      ),
    );
  }

  static const List<String> _selfPickupStatuses = <String>[
    'PENDING',
    'CONFIRMED',
    'AWAITING_PICKUP_RIDER',
    'PICKUP_RIDER_ASSIGNED',
    'ARRIVED_AT_PICKUP',
    'PICKED_UP',
    'ARRIVED_AT_PROVIDER',
    'RECEIVED_AT_PROVIDER',
    'IN_PROCESSING',
    'READY_FOR_DELIVERY',
    'SELF_PICKED_UP',
  ];

  static const List<String> _deliveryStatuses = <String>[
    'PENDING',
    'CONFIRMED',
    'AWAITING_PICKUP_RIDER',
    'PICKUP_RIDER_ASSIGNED',
    'ARRIVED_AT_PICKUP',
    'PICKED_UP',
    'ARRIVED_AT_PROVIDER',
    'RECEIVED_AT_PROVIDER',
    'IN_PROCESSING',
    'READY_FOR_DELIVERY',
    'AWAITING_DELIVERY_RIDER',
    'DELIVERY_RIDER_ASSIGNED',
    'ARRIVED_AT_DROPOFF',
    'OUT_FOR_DELIVERY',
    'DELIVERED',
  ];

  static List<OrderTimeline> generateTimeline(
    String backendStatus, {
    required bool isDelivery,
    required String deliveryMode,
    required DateTime createdAt,
    String? pickupCompletedAt,
    String? deliveryCompletedAt,
  }) {
    final String status = backendStatus.toUpperCase();
    final bool isCancelled = status == 'CANCELLED';
    final bool isSelfPickup = deliveryMode.toUpperCase() == 'USER_SELF_PICKUP';

    //  Select the appropriate status list based on driver type
    final List<String> activeStatuses = isSelfPickup
        ? _selfPickupStatuses
        : _deliveryStatuses;

    //  If cancelled, return only the cancelled step
    if (isCancelled) {
      return <OrderTimeline>[
        OrderTimeline(
          step: 1,
          title: 'Cancelled',
          description: 'This order has been cancelled',
          time: createdAt,
          isCompleted: true,
          backendStatus: 'CANCELLED',
        ),
      ];
    }

    //  Find the current status index in the active list
    final int currentIndex = activeStatuses.indexOf(status);
    final bool statusFound = currentIndex != -1;

    return activeStatuses.asMap().entries.map((MapEntry<int, String> entry) {
      final int index = entry.key;
      final String stepStatus = entry.value;

      //  Determine if this step is completed
      final bool isCompleted = statusFound
          ? index <= currentIndex
          : index <
                activeStatuses.length -
                    1; // If status not found, complete all but last

      //  Assign timestamp based on step
      DateTime? time;
      switch (stepStatus) {
        case 'PENDING':
          time = createdAt;
          break;
        case 'PICKED_UP':
          if (pickupCompletedAt != null) {
            time = DateTime.tryParse(pickupCompletedAt);
          }
          break;
        case 'DELIVERED':
        case 'SELF_PICKED_UP':
          if (deliveryCompletedAt != null) {
            time = DateTime.tryParse(deliveryCompletedAt);
          }
          break;
      }

      return OrderTimeline(
        step: index + 1,
        title: _getTimelineLabel(stepStatus),
        description: _getTimelineDescription(stepStatus),
        time: time,
        isCompleted: isCompleted,
        backendStatus: stepStatus,
      );
    }).toList();
  }

  // 🏷️ Labels
  static String _getTimelineLabel(String status) {
    switch (status) {
      case 'PENDING':
        return 'Order Placed';
      case 'CONFIRMED':
        return 'Confirmed';
      case 'AWAITING_PICKUP_RIDER':
        return 'Waiting Pickup Rider';
      case 'PICKUP_RIDER_ASSIGNED':
        return 'Pickup Rider Assigned';
      case 'ARRIVED_AT_PICKUP':
        return 'Rider Arrived';
      case 'PICKED_UP':
        return 'Picked Up';
      case 'ARRIVED_AT_PROVIDER':
        return 'At Laundry';
      case 'RECEIVED_AT_PROVIDER':
        return 'Received';
      case 'IN_PROCESSING':
        return 'Processing';
      case 'READY_FOR_DELIVERY':
        return 'Ready';

      case 'AWAITING_DELIVERY_RIDER':
        return 'Waiting Delivery Rider';
      case 'DELIVERY_RIDER_ASSIGNED':
        return 'Delivery Rider Assigned';
      case 'ARRIVED_AT_DROPOFF':
        return 'Rider at Shop';
      case 'OUT_FOR_DELIVERY':
        return 'Out for Delivery';
      case 'DELIVERED':
        return 'Delivered';

      case 'SELF_PICKED_UP':
        return 'Picked by You';
      case 'CANCELLED':
        return 'Cancelled';

      default:
        return status;
    }
  }

  // 📝 Descriptions
  static String _getTimelineDescription(String status) {
    switch (status) {
      case 'PENDING':
        return 'Order created';
      case 'CONFIRMED':
        return 'Order confirmed';
      case 'AWAITING_PICKUP_RIDER':
        return 'Searching pickup rider';
      case 'PICKUP_RIDER_ASSIGNED':
        return 'Pickup rider assigned';
      case 'ARRIVED_AT_PICKUP':
        return 'Rider at your location';
      case 'PICKED_UP':
        return 'Items picked up';
      case 'ARRIVED_AT_PROVIDER':
        return 'Reached laundry';
      case 'RECEIVED_AT_PROVIDER':
        return 'Laundry received items';
      case 'IN_PROCESSING':
        return 'Cleaning in progress';
      case 'READY_FOR_DELIVERY':
        return 'Ready for delivery or pickup';

      case 'OUT_FOR_DELIVERY':
        return 'On the way';
      case 'DELIVERED':
        return 'Delivered successfully';

      case 'SELF_PICKED_UP':
        return 'You collected your order';
      case 'CANCELLED':
        return 'Order cancelled';

      default:
        return '';
    }
  }

  //  Helpers for UI
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
      profilePicture: json['profilePicture'] as String?,
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
      profilePicture: json['profilePicture'] as String?,
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
      case 'AVAILABLE':
        return 'Available';
      case 'ASSIGNED_TO_USER':
        return 'Assigned to User';
      case 'PICKED_UP_BY_RIDER':
        return 'Picked up by Rider';
      case 'RECEIVED_AT_PROVIDER':
        return 'Received at Provider';
      case 'IN_PROCESSING':
        return 'In Processing';
      case 'READY_FOR_DELIVERY':
        return 'Ready for Delivery';
      case 'OUT_FOR_DELIVERY':
        return 'Out for Delivery';
      case 'DELIVERED_TO_USER':
        return 'Delivered';
      default:
        return status;
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

@immutable
class OrderTimeline {
  final int step;
  final String title;
  final DateTime? time;
  final String description;
  final bool isCompleted;
  final String backendStatus; // For reference

  const OrderTimeline({
    required this.step,
    required this.title,
    this.time,
    required this.description,
    required this.isCompleted,
    this.backendStatus = '',
  });

  String? get formattedTime {
    if (time == null) {
      return null;
    }
    final DateTime now = DateTime.now();
    final Duration diff = now.difference(time!);

    if (diff.inHours < 1) {
      return '${diff.inMinutes}m ago';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    }
    if (diff.inDays == 1) {
      return 'Yesterday';
    }
    return '${time!.day} ${_monthName(time!.month)}';
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
