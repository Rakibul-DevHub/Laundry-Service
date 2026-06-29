// ignore_for_file: always_specify_types

class BagListResponse {
  final int code;
  final bool success;
  final String message;
  final List<BagModel> data;

  BagListResponse({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory BagListResponse.fromJson(Map<String, dynamic> json) {
    return BagListResponse(
      code: json['code'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((item) => BagModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'success': success,
      'message': message,
      'data': data.map((BagModel bag) => bag.toJson()).toList(),
    };
  }
}

class BagModel {
  final String id;
  final String qrCode;
  final String displayCode;
  final BagStatus status;
  final int tripCount;
  final bool flaggedForReplacement;
  final DateTime createdAt;

  BagModel({
    required this.id,
    required this.qrCode,
    required this.displayCode,
    required this.status,
    required this.tripCount,
    required this.flaggedForReplacement,
    required this.createdAt,
  });

  factory BagModel.fromJson(Map<String, dynamic> json) {
    return BagModel(
      id: json['_id'] as String,
      qrCode: json['qrCode'] as String,
      displayCode: json['displayCode'] as String,
      status: BagStatus.fromString(json['status'] as String),
      tripCount: json['tripCount'] as int,
      flaggedForReplacement: json['flaggedForReplacement'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      '_id': id,
      'qrCode': qrCode,
      'displayCode': displayCode,
      'status': status.name,
      'tripCount': tripCount,
      'flaggedForReplacement': flaggedForReplacement,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // 💡 Helper: Get formatted creation date
  String get createdAtFormatted => _formatDate(createdAt);

  // 💡 Helper: Check if bag is active/usable
  bool get isAvailable => status == BagStatus.assignedToUser;

  // 💡 Helper: Check if bag needs replacement
  bool get needsReplacement => flaggedForReplacement;

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // 💡 CopyWith for immutability
  BagModel copyWith({
    String? id,
    String? qrCode,
    String? displayCode,
    BagStatus? status,
    int? tripCount,
    bool? flaggedForReplacement,
    DateTime? createdAt,
  }) {
    return BagModel(
      id: id ?? this.id,
      qrCode: qrCode ?? this.qrCode,
      displayCode: displayCode ?? this.displayCode,
      status: status ?? this.status,
      tripCount: tripCount ?? this.tripCount,
      flaggedForReplacement:
          flaggedForReplacement ?? this.flaggedForReplacement,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum BagStatus {
  available,
  assignedToUser,
  pickedUpByRider,
  receivedAtProvider,
  inProcessing,
  readyForDelivery,
  outForDelivery,
  deliveredToUser,
  unknown;

  static BagStatus fromString(String value) {
    switch (value) {
      case 'AVAILABLE':
        return BagStatus.available;
      case 'ASSIGNED_TO_USER':
        return BagStatus.assignedToUser;
      case 'PICKED_UP_BY_RIDER':
        return BagStatus.pickedUpByRider;
      case 'RECEIVED_AT_PROVIDER':
        return BagStatus.receivedAtProvider;
      case 'IN_PROCESSING':
        return BagStatus.inProcessing;
      case 'READY_FOR_DELIVERY':
        return BagStatus.readyForDelivery;
      case 'OUT_FOR_DELIVERY':
        return BagStatus.outForDelivery;
      case 'DELIVERED_TO_USER':
        return BagStatus.deliveredToUser;
      default:
        return BagStatus.unknown;
    }
  }

  String get displayName {
    switch (this) {
      case BagStatus.available:
        return 'Available';
      case BagStatus.assignedToUser:
        return 'Assigned';
      case BagStatus.pickedUpByRider:
        return 'Picked Up';
      case BagStatus.receivedAtProvider:
        return 'At Shop';
      case BagStatus.inProcessing:
        return 'Processing';
      case BagStatus.readyForDelivery:
        return 'Ready';
      case BagStatus.outForDelivery:
        return 'Out for Delivery';
      case BagStatus.deliveredToUser:
        return 'Delivered';
      case BagStatus.unknown:
        return 'Unknown';
    }
  }
}
