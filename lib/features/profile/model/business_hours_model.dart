// features/business/models/business_hours_model.dart

// ignore_for_file: always_specify_types

import 'package:flutter/foundation.dart';

//  API Response Wrapper - matches your backend structure
class BusinessHoursResponse {
  final int code;
  final bool success;
  final String message;
  final BusinessHoursData data;

  BusinessHoursResponse({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory BusinessHoursResponse.fromJson(Map<String, dynamic> json) {
    return BusinessHoursResponse(
      code: json['code'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: BusinessHoursData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'code': code,
    'success': success,
    'message': message,
    'data': data.toJson(),
  };
}

//  Data wrapper - matches your backend: { businessHours: [...], updatedAt: ... }
class BusinessHoursData {
  final List<DaySchedule> businessHours;
  final DateTime updatedAt;

  BusinessHoursData({
    required this.businessHours,
    required this.updatedAt,
  });

  factory BusinessHoursData.fromJson(Map<String, dynamic> json) {
    return BusinessHoursData(
      businessHours: (json['businessHours'] as List)
          .map((item) => DaySchedule.fromJson(item as Map<String, dynamic>))
          .toList(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'businessHours': businessHours.map((DaySchedule s) => s.toJson()).toList(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  BusinessHoursData copyWith({
    List<DaySchedule>? businessHours,
    DateTime? updatedAt,
  }) {
    return BusinessHoursData(
      businessHours: businessHours ?? this.businessHours,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

//  Day Schedule - matches your backend fields
@immutable
class DaySchedule {
  final String day; // Full name: "monday", "tuesday", etc.
  final bool isOpen;
  final bool is24Hours;
  final String? openTime; // Format: "HH:mm" (24-hour) - nullable when closed
  final String? closeTime; // Format: "HH:mm" (24-hour) - nullable when closed

  const DaySchedule({
    required this.day,
    required this.isOpen,
    required this.is24Hours,
    this.openTime,
    this.closeTime,
  });

  factory DaySchedule.fromJson(Map<String, dynamic> json) {
    return DaySchedule(
      day: (json['day'] as String).toLowerCase(), // Normalize to lowercase
      isOpen: json['isOpen'] as bool,
      is24Hours: json['is24Hours'] as bool,
      openTime: json['openTime'] as String?,
      closeTime: json['closeTime'] as String?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'day': day,
    'isOpen': isOpen,
    'is24Hours': is24Hours,
    if (openTime != null) 'openTime': openTime,
    if (closeTime != null) 'closeTime': closeTime,
  };

  DaySchedule copyWith({
    String? day,
    bool? isOpen,
    bool? is24Hours,
    String? openTime,
    String? closeTime,
  }) {
    return DaySchedule(
      day: day ?? this.day,
      isOpen: isOpen ?? this.isOpen,
      is24Hours: is24Hours ?? this.is24Hours,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
    );
  }

  //  Helper: Get display name (capitalize first letter)
  String get displayName {
    if (day.isEmpty) {
      return '';
    }
    return day[0].toUpperCase() + day.substring(1);
  }

  //  Helper: Get short name (first 3 letters, uppercase)
  String get shortName =>
      day.length >= 3 ? day.substring(0, 3).toUpperCase() : day.toUpperCase();

  //  Helper: Format time for display (12-hour format)
  String get timeDisplay {
    if (is24Hours) {
      return '24 Hours';
    }
    if (!isOpen) {
      return 'Closed';
    }
    if (openTime == null || closeTime == null) {
      return 'Not set';
    }
    return '${_formatTime(openTime!)} - ${_formatTime(closeTime!)}';
  }

  String _formatTime(String time24) {
    try {
      final List<String> parts = time24.split(':');
      final int hour = int.parse(parts[0]);
      final String minute = parts[1];
      final String period = hour >= 12 ? 'PM' : 'AM';
      final int displayHour = hour % 12 == 0 ? 12 : hour % 12;
      return '$displayHour:$minute $period';
    } catch (e) {
      return time24;
    }
  }

  //  Helper: Get day index for sorting (0=Sunday, 1=Monday, etc.)
  int get dayIndex {
    const List<String> days = <String>[
      'sunday',
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
    ];
    return days.indexOf(day.toLowerCase());
  }
}

//  Request model for saving
class UpdateBusinessHoursRequest {
  final List<DaySchedule> businessHours;

  UpdateBusinessHoursRequest({required this.businessHours});

  Map<String, dynamic> toJson() => <String, dynamic>{
    'businessHours': businessHours.map((DaySchedule s) => s.toJson()).toList(),
  };
}
