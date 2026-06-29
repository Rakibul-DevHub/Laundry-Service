// features/riders/jobs/models/jobs_details_model.dart

// ignore_for_file: always_specify_types

import 'package:flutter/material.dart';

import 'jobs_check_point_type.dart';

@immutable
class JobsDetailsModel {
  final String id;
  final double deliveryPayout;
  final DateTime date;
  final String customerProfile;
  final String customerName;
  final String customerPhone;
  final String pickupLocation;
  final String dropOffLocation;
  final List<JobItem> items;
  final List<JobInstruction> instructions;
  final int totalItems;
  final String serviceType;
  final JobStatusType? orderStatusType;
  final String userId;
  final String providerId;
  final String providerName;
  final String providerProfile;
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
  final String jobType;
  final double payout;
  final double pickupPayout;
  final double? latitude;
  final double? longitude;
  final QRData? qrData;
  final LocationDetails? pickupLocationDetails;
  final LocationDetails? dropoffLocationDetails;
  final PricingBreakdown? pricing;
  final JobsCheckPointType checkPointStatusType;
  final DateTime? pickupRiderAcceptedAt;
  final DateTime? riderAcceptedAt;
  final String? pickupRiderId;
  final String? riderId;
  final String refundStatus;
  final String paymentStatus;
  final DateTime updatedAt;
  final bool isDelivery;

  const JobsDetailsModel({
    required this.id,
    required this.deliveryPayout,
    required this.pickupPayout,
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
    this.orderStatusType,
    required this.userId,
    required this.providerId,
    required this.providerName,
    this.providerProfile = '',
    required this.bags,
    required this.isDelivery,
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
    required this.payout,
    this.latitude,
    this.longitude,
    this.qrData,
    this.pickupLocationDetails,
    this.dropoffLocationDetails,
    this.pricing,
    this.checkPointStatusType = JobsCheckPointType.pickupAssigned,
    this.pickupRiderAcceptedAt,
    this.riderAcceptedAt,
    this.pickupRiderId,
    this.riderId,
    this.refundStatus = 'NOT_APPLICABLE',
    this.paymentStatus = 'unpaid',
    required this.updatedAt,
  });

  factory JobsDetailsModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = json['data'] != null
        ? json['data'] as Map<String, dynamic>
        : json;
    final Map<String, dynamic> userJson =
        data['userId'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final Map<String, dynamic> providerJson =
        data['providerId'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final Map<String, dynamic>? pricingJson =
        data['pricing'] as Map<String, dynamic>?;
    final Map<String, dynamic>? pickupLocJson =
        data['pickupLocation'] as Map<String, dynamic>?;
    final Map<String, dynamic>? dropoffLocJson =
        data['dropoffLocation'] as Map<String, dynamic>?;
    final List<dynamic> itemsJson = data['orderItems'] as List? ?? <dynamic>[];
    final List<dynamic> bagsJson = data['bagIds'] as List? ?? <dynamic>[];
    final String backendStatus = data['status'] as String? ?? 'PENDING';

    return JobsDetailsModel(
      id: data['_id'] as String? ?? data['id'] as String? ?? '',
      deliveryPayout: _parseCentsToDollars(data['deliveryPayout']),
      pickupPayout: _parseCentsToDollars(data['pickupPayout']),
      date: _parseDateTime(data['createdAt']) ?? DateTime.now(),
      customerProfile: userJson['profilePicture'] as String? ?? '',
      customerName: userJson['fullName'] as String? ?? 'Unknown',
      customerPhone: userJson['phoneNumber'] as String? ?? '',
      pickupLocation: pickupLocJson?['address'] as String? ?? '',
      dropOffLocation: dropoffLocJson?['address'] as String? ?? '',
      items: itemsJson
          .map((item) => JobItem.fromApi(item as Map<String, dynamic>))
          .toList(),
      instructions: _mapDeliveryInstruction(
        data['deliveryInstruction'] as String? ?? '',
      ),
      totalItems: itemsJson.fold<int>(
        0,
        (int sum, item) =>
            sum + ((item as Map<String, dynamic>)['quantity'] as int? ?? 0),
      ),
      serviceType: itemsJson.isNotEmpty
          ? (itemsJson.first as Map<String, dynamic>)['serviceName']
                    as String? ??
                'Laundry Service'
          : 'Laundry Service',
      orderStatusType: JobStatusType.fromApiString(backendStatus),
      userId: userJson['_id'] as String? ?? '',
      providerId: providerJson['_id'] as String? ?? '',
      providerName:
          (providerJson['businessInfo']
                  as Map<String, dynamic>?)?['businessName']
              as String? ??
          providerJson['fullName'] as String? ??
          '',
      providerProfile: providerJson['profilePicture'] as String? ?? '',
      bags: bagsJson
          .map((b) => BagInfo.fromApi(b as Map<String, dynamic>))
          .toList(),
      specialInstructions: data['specialInstructions'] as String? ?? '',
      scheduledPickupDate: data['scheduledPickupDate'] as String?,
      scheduledPickupSlot: data['scheduledPickupSlot'] as String?,
      deliveryInstruction: data['deliveryInstruction'] as String? ?? '',
      driverType: data['driverType'] as String? ?? '',
      deliveryMode: data['deliveryMode'] as String? ?? '',
      deliveryZone: data['deliveryZone'] as String? ?? '',
      distanceKm: (data['distanceKm'] as num? ?? 0).toDouble(),
      status: backendStatus,
      jobType: data['jobType'] as String? ?? 'PICKUP_ONLY',
      payout: _parseCentsToDollars(data['payout']),
      latitude: pickupLocJson?['latitude'] as double?,
      longitude: pickupLocJson?['longitude'] as double?,
      qrData: bagsJson.isNotEmpty
          ? QRData.fromBag(bagsJson.first as Map<String, dynamic>, userJson)
          : null,
      pickupLocationDetails: pickupLocJson != null
          ? LocationDetails.fromJson(pickupLocJson)
          : null,
      dropoffLocationDetails: dropoffLocJson != null
          ? LocationDetails.fromJson(dropoffLocJson)
          : null,
      pricing: pricingJson != null
          ? PricingBreakdown.fromJson(pricingJson)
          : null,
      checkPointStatusType: jobsCheckPointTypeFromApiString(backendStatus),
      pickupRiderAcceptedAt: _parseDateTime(data['pickupRiderAcceptedAt']),
      riderAcceptedAt: _parseDateTime(data['riderAcceptedAt']),
      pickupRiderId: data['pickupRiderId'] as String?,
      riderId: data['riderId'] as String?,
      isDelivery: data['isDelivery'] as bool? ?? false,
      refundStatus: data['refundStatus'] as String? ?? 'NOT_APPLICABLE',
      paymentStatus: data['paymentStatus'] as String? ?? 'unpaid',
      updatedAt: _parseDateTime(data['updatedAt']) ?? DateTime.now(),
    );
  }

  static double _parseCentsToDollars(dynamic value) {
    if (value == null) {
      return 0.0;
    }
    if (value is double) {
      return value / 100;
    }
    if (value is int) {
      return value / 100.0;
    }
    if (value is String) {
      final num? numVal = num.tryParse(value);
      return numVal != null ? numVal / 100 : 0.0;
    }
    return 0.0;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static List<JobInstruction> _mapDeliveryInstruction(String instruction) {
    final Map<String, String> instructionMap = <String, String>{
      'TAKE_FROM_DOOR': 'Take from door',
      'KNOCK_AT_DOOR': 'Knock at door',
      'LEAVE_AT_DOOR': 'Leave at door',
    };
    final String label =
        instructionMap[instruction.toUpperCase()] ?? instruction;
    return <JobInstruction>[JobInstruction(label: label, icon: '')];
  }

  String get formattedDate {
    final DateTime now = DateTime.now();
    final Duration diff = now.difference(date);
    if (diff.inHours < 24 && diff.inDays == 0) {
      return 'Today';
    }
    if (diff.inDays == 1) {
      return 'Yesterday';
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

  String get formattedTime =>
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  String get formattedDeliveryPayout =>
      '\$${deliveryPayout.toStringAsFixed(2)}';
  String get formattedPayout => '\$${payout.toStringAsFixed(2)}';
  String get formattedDistance => '${distanceKm.toStringAsFixed(1)} km';

  String get formattedStatus {
    switch (status.toUpperCase()) {
      case 'PICKUP_RIDER_ASSIGNED':
        return 'Pickup Assigned';
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

  Color get statusColor => checkPointStatusType.statusColor;

  bool get canAccept => status.toUpperCase() == 'AWAITING_PICKUP_RIDER';
  bool get isInProgress => <String>[
    'PICKUP_RIDER_ASSIGNED',
    'PICKED_UP',
    'OUT_FOR_DELIVERY',
  ].contains(status.toUpperCase());
  bool get isCompleted =>
      <String>['DELIVERED', 'SELF_PICKED_UP'].contains(status.toUpperCase());

  JobsDetailsModel copyWith({
    String? id,
    double? deliveryPayout,
    double? pickupPayout,
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
    JobStatusType? orderStatusType,
    String? userId,
    String? providerId,
    String? providerName,
    String? providerProfile,
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
    double? payout,
    double? latitude,
    double? longitude,
    QRData? qrData,
    LocationDetails? pickupLocationDetails,
    LocationDetails? dropoffLocationDetails,
    PricingBreakdown? pricing,
    JobsCheckPointType? checkPointStatusType,
    DateTime? pickupRiderAcceptedAt,
    DateTime? riderAcceptedAt,
    String? pickupRiderId,
    String? riderId,
    String? refundStatus,
    String? paymentStatus,
    DateTime? updatedAt,
    bool? isDelivery,
  }) {
    return JobsDetailsModel(
      id: id ?? this.id,
      deliveryPayout: deliveryPayout ?? this.deliveryPayout,
      pickupPayout: pickupPayout ?? this.pickupPayout,
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
      orderStatusType: orderStatusType ?? this.orderStatusType,
      userId: userId ?? this.userId,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      providerProfile: providerProfile ?? this.providerProfile,
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
      payout: payout ?? this.payout,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      qrData: qrData ?? this.qrData,
      pickupLocationDetails:
          pickupLocationDetails ?? this.pickupLocationDetails,
      dropoffLocationDetails:
          dropoffLocationDetails ?? this.dropoffLocationDetails,
      pricing: pricing ?? this.pricing,
      checkPointStatusType: checkPointStatusType ?? this.checkPointStatusType,
      pickupRiderAcceptedAt:
          pickupRiderAcceptedAt ?? this.pickupRiderAcceptedAt,
      riderAcceptedAt: riderAcceptedAt ?? this.riderAcceptedAt,
      pickupRiderId: pickupRiderId ?? this.pickupRiderId,
      riderId: riderId ?? this.riderId,
      refundStatus: refundStatus ?? this.refundStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      updatedAt: updatedAt ?? this.updatedAt,
      isDelivery: isDelivery ?? this.isDelivery,
    );
  }
}

// === Supporting Models ===

@immutable
class JobItem {
  final String itemId;
  final String itemName;
  final String serviceName;
  final String productCategoryName;
  final int quantity;
  final double price;
  final double lineTotal;

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
      itemId: json['itemId'] as String? ?? '',
      itemName: json['itemName'] as String? ?? '',
      serviceName: json['serviceName'] as String? ?? '',
      productCategoryName: json['productCategoryName'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 0,
      price: (json['price'] as num? ?? 0) / 100,
      lineTotal: (json['lineTotal'] as num? ?? 0) / 100,
    );
  }

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  String get formattedLineTotal => '\$${lineTotal.toStringAsFixed(2)}';
}

@immutable
class JobInstruction {
  final String icon;
  final String label;
  const JobInstruction({required this.icon, required this.label});
  factory JobInstruction.fromApi(Map<String, dynamic> json) => JobInstruction(
    icon: json['icon'] as String? ?? '',
    label: json['label'] as String? ?? '',
  );
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
    this.status = '',
  });
  factory BagInfo.fromApi(Map<String, dynamic> json) => BagInfo(
    id: json['_id'] as String? ?? json['id'] as String? ?? '',
    displayCode: json['displayCode'] as String? ?? '',
    qrCode: json['qrCode'] as String? ?? '',
    status: json['status'] as String? ?? '',
  );
}

@immutable
class QRData {
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String bagId;
  const QRData({
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.bagId,
  });
  factory QRData.fromBag(Map<String, dynamic> bag, Map<String, dynamic> user) {
    final Map<String, dynamic>? address =
        user['address'] as Map<String, dynamic>?;
    return QRData(
      customerId: user['_id'] as String? ?? '',
      customerName: user['fullName'] as String? ?? '',
      customerPhone: user['phoneNumber'] as String? ?? '',
      customerAddress: address != null
          ? '${address['street']}, ${address['city']}'
          : '',
      bagId: bag['displayCode'] as String? ?? '',
    );
  }
}

@immutable
class LocationDetails {
  final String address;
  final double latitude;
  final double longitude;
  const LocationDetails({
    required this.address,
    required this.latitude,
    required this.longitude,
  });
  factory LocationDetails.fromJson(Map<String, dynamic> json) =>
      LocationDetails(
        address: json['address'] as String? ?? '',
        latitude: (json['latitude'] as num? ?? 0).toDouble(),
        longitude: (json['longitude'] as num? ?? 0).toDouble(),
      );
}

@immutable
class PricingBreakdown {
  final double itemsTotal;
  final double platformFee;
  final double pickupFee;
  final double deliveryFee;
  final double deliveryCharge;
  final double total;
  const PricingBreakdown({
    required this.itemsTotal,
    required this.platformFee,
    required this.pickupFee,
    required this.deliveryFee,
    required this.deliveryCharge,
    required this.total,
  });
  factory PricingBreakdown.fromJson(Map<String, dynamic> json) =>
      PricingBreakdown(
        itemsTotal: (json['itemsTotal'] as num? ?? 0) / 100,
        platformFee: (json['platformFee'] as num? ?? 0) / 100,
        pickupFee: (json['pickupFee'] as num? ?? 0) / 100,
        deliveryFee: (json['deliveryFee'] as num? ?? 0) / 100,
        deliveryCharge: (json['deliveryCharge'] as num? ?? 0) / 100,
        total: (json['total'] as num? ?? 0) / 100,
      );
  String get formattedTotal => '\$${total.toStringAsFixed(2)}';
}

// === JobStatusType (simplified) ===
enum JobStatusType {
  newOrders,
  ongoingOrders,
  completedOrders,
  canceledOrders,
  unknown;

  static JobStatusType fromApiString(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
      case 'AWAITING_PICKUP_RIDER':
        return newOrders;
      case 'PICKUP_RIDER_ASSIGNED':
      case 'PICKED_UP':
      case 'IN_PROCESSING':
        return ongoingOrders;
      case 'DELIVERED':
      case 'COMPLETED':
        return completedOrders;
      case 'CANCELLED':
        return canceledOrders;
      default:
        return unknown;
    }
  }
}
