// features/riders/jobs/models/jobs_request_model.dart

// ignore_for_file: avoid_dynamic_calls, always_specify_types

import 'package:drop_n_fresh/core/config/images.dart';
import 'package:flutter/material.dart';

// ============================================================================
//  MAIN JOBS REQUEST MODEL - Maps your API response
// ============================================================================

@immutable
class JobsRequestModel {
  //  Core fields for list UI
  final String id;
  final double
  payout; // Rider's earnings (from API: in cents → converted to dollars)
  final DateTime date; // createdAt
  final String customerProfile; // user.profilePicture
  final String customerName; // user.fullName
  final String customerPhone; // user.phoneNumber
  final String pickupLocation; // pickupLocation.address
  final String dropOffLocation; // dropoffLocation.address
  final List<JobItem> items; // orderItems mapped to simple items
  final List<JobInstruction> instructions; // deliveryInstruction mapped
  final int totalItems; // sum of quantities
  final String serviceType; // first item's serviceName

  //  Full API data for details/actions
  final String userId;
  final String providerId;
  final String providerName;
  final List<BagInfo> bags;
  final String specialInstructions;
  final String? scheduledPickupDate;
  final String? scheduledPickupSlot;
  final String deliveryInstruction;
  final String driverType;
  final String deliveryMode;
  final String deliveryZone;
  final double distanceKm;
  final String status;
  final String jobType; // "PICKUP_ONLY", "DELIVERY_ONLY", or "BOTH"
  final PricingInfo pricing; // Full pricing breakdown (all in dollars)
  final LocationInfo? pickupLocationInfo;
  final LocationInfo? dropoffLocationInfo;
  final double? latitude;
  final double? longitude;

  const JobsRequestModel({
    required this.id,
    required this.payout,
    required this.date,
    required this.customerProfile,
    required this.customerName,
    required this.customerPhone,
    required this.pickupLocation,
    required this.dropOffLocation,
    required this.items,
    required this.instructions,
    required this.totalItems,
    required this.serviceType,
    required this.userId,
    required this.providerId,
    required this.providerName,
    required this.bags,
    required this.specialInstructions,
    this.scheduledPickupDate,
    this.scheduledPickupSlot,
    required this.deliveryInstruction,
    required this.driverType,
    required this.deliveryMode,
    required this.deliveryZone,
    required this.distanceKm,
    required this.status,
    required this.jobType,
    required this.pricing,
    this.pickupLocationInfo,
    this.dropoffLocationInfo,
    this.latitude,
    this.longitude,
  });

  //  Map API response to model (cents → dollars conversion)
  factory JobsRequestModel.fromApiResponse(Map<String, dynamic> json) {
    final Map<String, dynamic> userJson =
        json['userId'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final Map<String, dynamic> providerJson =
        json['providerId'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final List<dynamic> itemsJson =
        (json['orderItems'] as List? ?? <dynamic>[]);
    final List<dynamic> bagsJson = (json['bagIds'] as List? ?? <dynamic>[]);
    final Map<String, dynamic> pricingJson =
        json['pricing'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final pickupLocJson = json['pickupLocation'];
    final dropoffLocJson = json['dropoffLocation'];

    return JobsRequestModel(
      // Core UI fields
      id: json['_id'] as String,

      //  PAYOUT: Convert from cents to dollars
      payout: (json['deliveryPayout'] as num? ?? 0) / 100,

      date: DateTime.parse(json['createdAt'] as String),
      customerProfile: userJson['profilePicture'] as String? ?? '',
      customerName: userJson['fullName'] as String? ?? 'Unknown',
      customerPhone: userJson['phoneNumber'] as String? ?? '',
      pickupLocation: pickupLocJson?['address'] as String? ?? '',
      dropOffLocation: dropoffLocJson?['address'] as String? ?? '',

      //  ITEMS: Map with price conversion
      items: itemsJson
          .map((item) => JobItem.fromApi(item as Map<String, dynamic>))
          .toList(),

      //  INSTRUCTIONS: Map delivery instruction to UI-friendly format
      instructions: _mapDeliveryInstruction(
        json['deliveryInstruction'] as String? ?? '',
      ),

      //  TOTAL ITEMS: Sum of all quantities
      totalItems: itemsJson.fold(
        0,
        (int sum, item) => sum + (item['quantity'] as int),
      ),

      serviceType: itemsJson.isNotEmpty
          ? itemsJson.first['serviceName'] as String
          : 'Laundry Service',

      // Full API data
      userId: userJson['_id'] as String? ?? '',
      providerId: providerJson['_id'] as String? ?? '',
      providerName:
          (providerJson['businessInfo']
                  as Map<String, dynamic>?)?['businessName']
              as String? ??
          '',
      bags: bagsJson
          .map((b) => BagInfo.fromApi(b as Map<String, dynamic>))
          .toList(),
      specialInstructions: json['specialInstructions'] as String? ?? '',
      scheduledPickupDate: json['scheduledPickupDate'] as String?,
      scheduledPickupSlot: json['scheduledPickupSlot'] as String?,
      deliveryInstruction: json['deliveryInstruction'] as String? ?? '',
      driverType: json['driverType'] as String? ?? '',
      deliveryMode: json['deliveryMode'] as String? ?? '',
      deliveryZone: json['deliveryZone'] as String? ?? '',
      distanceKm: (json['distanceKm'] as num? ?? 0).toDouble(),
      status: json['status'] as String? ?? '',
      jobType: json['jobType'] as String? ?? 'PICKUP_ONLY',

      //  PRICING: Full breakdown with cents → dollars conversion
      pricing: PricingInfo.fromApi(pricingJson),

      pickupLocationInfo: pickupLocJson != null
          ? LocationInfo.fromApi(pickupLocJson as Map<String, dynamic>)
          : null,
      dropoffLocationInfo: dropoffLocJson != null
          ? LocationInfo.fromApi(dropoffLocJson as Map<String, dynamic>)
          : null,
      latitude: pickupLocJson?['latitude'] as double?,
      longitude: pickupLocJson?['longitude'] as double?,
    );
  }

  //  Map delivery instruction string to Instructions list
  static List<JobInstruction> _mapDeliveryInstruction(String instruction) {
    final Map<String, String> instructionMap = <String, String>{
      'TAKE_FROM_DOOR': 'Take from door',
      'KNOCK_AT_DOOR': 'Knock at door',
      'LEAVE_AT_DOOR': 'Leave at door',
      'AVOID_BELL': 'Avoid bell',
    };

    final String label =
        instructionMap[instruction.toUpperCase()] ?? instruction;
    String icon =
        ''; // Default icon (can be set based on instruction if needed)
    if (instruction.toUpperCase() == 'TAKE_FROM_DOOR') {
      icon = AppImages.fromDoor;
    } else if (instruction.toUpperCase() == 'KNOCK_AT_DOOR') {
      icon = AppImages.nockDoor;
    } else if (instruction.toUpperCase() == 'LEAVE_AT_DOOR') {
      icon = AppImages.leaveDoor;
    } else if (instruction.toUpperCase() == 'AVOID_BELL') {
      icon = AppImages.avoidDoor;
    }
    return <JobInstruction>[
      JobInstruction(label: label, icon: icon),
    ]; // Add proper icon mapping if needed
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

  //  Formatted status for display
  String get formattedStatus {
    switch (status.toUpperCase()) {
      case 'AWAITING_PICKUP_RIDER':
        return 'Awaiting Pickup';
      case 'AWAITING_DELIVERY_RIDER':
        return 'Awaiting Delivery';
      case 'PICKUP_RIDER_ASSIGNED':
        return 'Pickup Assigned';
      case 'DELIVERY_RIDER_ASSIGNED':
        return 'Delivery Assigned';
      case 'PICKED_UP':
        return 'Picked Up';
      case 'OUT_FOR_DELIVERY':
        return 'Out for Delivery';
      case 'DELIVERED':
        return 'Delivered';
      default:
        return status;
    }
  }

  //  Status color for badge
  Color get statusColor {
    switch (status.toUpperCase()) {
      case 'AWAITING_PICKUP_RIDER':
      case 'AWAITING_DELIVERY_RIDER':
        return Colors.orange;
      case 'PICKUP_RIDER_ASSIGNED':
      case 'DELIVERY_RIDER_ASSIGNED':
        return Colors.blue;
      case 'PICKED_UP':
      case 'OUT_FOR_DELIVERY':
        return Colors.purple;
      case 'DELIVERED':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  //  CopyWith for immutability
  JobsRequestModel copyWith({
    String? id,
    double? payout,
    DateTime? date,
    String? customerProfile,
    String? customerName,
    String? customerPhone,
    String? pickupLocation,
    String? dropOffLocation,
    List<JobItem>? items,
    List<JobInstruction>? instructions,
    int? totalItems,
    String? serviceType,
    String? userId,
    String? providerId,
    String? providerName,
    List<BagInfo>? bags,
    String? specialInstructions,
    String? scheduledPickupDate,
    String? scheduledPickupSlot,
    String? deliveryInstruction,
    String? driverType,
    String? deliveryMode,
    String? deliveryZone,
    double? distanceKm,
    String? status,
    String? jobType,
    PricingInfo? pricing,
    LocationInfo? pickupLocationInfo,
    LocationInfo? dropoffLocationInfo,
    double? latitude,
    double? longitude,
  }) {
    return JobsRequestModel(
      id: id ?? this.id,
      payout: payout ?? this.payout,
      date: date ?? this.date,
      customerProfile: customerProfile ?? this.customerProfile,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropOffLocation: dropOffLocation ?? this.dropOffLocation,
      items: items ?? this.items,
      instructions: instructions ?? this.instructions,
      totalItems: totalItems ?? this.totalItems,
      serviceType: serviceType ?? this.serviceType,
      userId: userId ?? this.userId,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      bags: bags ?? this.bags,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      scheduledPickupDate: scheduledPickupDate ?? this.scheduledPickupDate,
      scheduledPickupSlot: scheduledPickupSlot ?? this.scheduledPickupSlot,
      deliveryInstruction: deliveryInstruction ?? this.deliveryInstruction,
      driverType: driverType ?? this.driverType,
      deliveryMode: deliveryMode ?? this.deliveryMode,
      deliveryZone: deliveryZone ?? this.deliveryZone,
      distanceKm: distanceKm ?? this.distanceKm,
      status: status ?? this.status,
      jobType: jobType ?? this.jobType,
      pricing: pricing ?? this.pricing,
      pickupLocationInfo: pickupLocationInfo ?? this.pickupLocationInfo,
      dropoffLocationInfo: dropoffLocationInfo ?? this.dropoffLocationInfo,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}

// ============================================================================
//  NESTED MODELS
// ============================================================================

@immutable
class JobItem {
  final String itemId;
  final String itemName;
  final String serviceName;
  final String productCategoryName;
  final int quantity;

  //  PRICES IN DOLLARS (converted from cents)
  final double price; // price in cents / 100
  final double lineTotal; // lineTotal in cents / 100

  const JobItem({
    required this.itemId,
    required this.itemName,
    required this.serviceName,
    required this.productCategoryName,
    required this.quantity,
    required this.price,
    required this.lineTotal,
  });

  factory JobItem.fromApi(Map<String, dynamic> json) {
    return JobItem(
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
class JobInstruction {
  final String icon; // icon path/name
  final String label; // display label

  const JobInstruction({required this.icon, required this.label});

  factory JobInstruction.fromApi(Map<String, dynamic> json) {
    return JobInstruction(
      icon: json['icon'] as String? ?? '',
      label: json['label'] as String? ?? '',
    );
  }
}

@immutable
class BagInfo {
  final String id;
  final String displayCode;

  const BagInfo({required this.id, required this.displayCode});

  factory BagInfo.fromApi(Map<String, dynamic> json) {
    return BagInfo(
      id: json['_id'] as String,
      displayCode: json['displayCode'] as String,
    );
  }
}

// ============================================================================
//  PRICING INFO - ALL VALUES IN DOLLARS
// ============================================================================

@immutable
class PricingInfo {
  //  ALL PRICES CONVERTED FROM CENTS TO DOLLARS
  final double itemsTotal; // itemsTotal / 100
  final double platformFee; // platformFee / 100
  final double pickupFee; // pickupFee / 100
  final double deliveryFee; // deliveryFee / 100
  final double deliveryCharge; // deliveryCharge / 100
  final double total; // total / 100

  const PricingInfo({
    required this.itemsTotal,
    required this.platformFee,
    required this.pickupFee,
    required this.deliveryFee,
    required this.deliveryCharge,
    required this.total,
  });

  factory PricingInfo.fromApi(Map<String, dynamic> json) {
    return PricingInfo(
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

@immutable
class LocationInfo {
  final String? address;
  final double? latitude;
  final double? longitude;

  const LocationInfo({this.address, this.latitude, this.longitude});

  factory LocationInfo.fromApi(Map<String, dynamic> json) {
    return LocationInfo(
      address: json['address'] as String?,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
    );
  }
}
