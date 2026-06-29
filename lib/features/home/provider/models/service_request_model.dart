import 'package:flutter/foundation.dart';

@immutable
class ServiceRequestModel {
  final String id;
  final double amount;
  final DateTime date;
  final String customerProfile;
  final String customerName;
  final String customerPhone;
  final String pickupLocation;
  final String dropOffLocation;
  final List<Item> items;
  final int totalItems;
  final String serviceType;

  const ServiceRequestModel({
    required this.id,
    required this.amount,
    required this.date,
    required this.customerProfile,
    required this.customerName,
    required this.customerPhone,
    required this.pickupLocation,
    required this.dropOffLocation,
    required this.items,
    required this.totalItems,
    required this.serviceType,
  });

  factory ServiceRequestModel.fromJson(Map<String, dynamic> json) {
    return ServiceRequestModel(
      id: json['id'] as String,
      amount: double.parse(json['amount'].toString()),
      date: DateTime.parse(json['date'] as String),
      customerName: json['customerName'] as String,
      customerProfile: json['customerProfile'] as String,
      customerPhone: json['customerPhone'] as String,
      pickupLocation: json['pickupLocation'] as String,
      dropOffLocation: json['dropOffLocation'] as String,
      items: List<Item>.from(json['items'] as List<dynamic>),
      totalItems: json['totalItems'] as int,
      serviceType: json['serviceType'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'customerName': customerName,
      'customerProfile': customerProfile,
      'customerPhone': customerPhone,
      'pickupLocation': pickupLocation,
      'dropOffLocation': dropOffLocation,
      'items': items,
      'totalItems': totalItems,
      'serviceType': serviceType,
    };
  }

  // Helper to format date
  String get formattedDate {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${date.day} ${_getMonthName(date.month)} ${date.year}';
    }
  }

  String _getMonthName(int month) {
    final List<String> months = <String>[
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

  ServiceRequestModel copyWith({
    String? id,
    double? amount,
    DateTime? date,
    String? customerName,
    String? customerProfile,
    String? customerPhone,
    String? pickupLocation,
    String? dropOffLocation,
    List<Item>? items,
    int? totalItems,
    String? serviceType,
  }) {
    return ServiceRequestModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      customerName: customerName ?? this.customerName,
      customerProfile: customerProfile ?? this.customerProfile,
      customerPhone: customerPhone ?? this.customerPhone,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropOffLocation: dropOffLocation ?? this.dropOffLocation,
      items: items ?? this.items,
      totalItems: totalItems ?? this.totalItems,
      serviceType: serviceType ?? this.serviceType,
    );
  }
}

class Item {
  final String item;
  final String value;

  const Item({
    required this.item,
    required this.value,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      item: json['item'] as String,
      value: json['value'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'item': item,
      'value': value,
    };
  }
}
