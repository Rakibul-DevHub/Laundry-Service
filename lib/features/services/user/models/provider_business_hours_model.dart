// ignore_for_file: always_specify_types

import 'package:flutter/foundation.dart';

class ProviderBusinessHoursResponse {
  final int code;
  final bool success;
  final String message;
  final ProviderBusinessHoursData data;

  ProviderBusinessHoursResponse({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProviderBusinessHoursResponse.fromJson(Map<String, dynamic> json) {
    return ProviderBusinessHoursResponse(
      code: json['code'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: ProviderBusinessHoursData.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );
  }
}

class ProviderBusinessHoursData {
  final String providerId;
  final String providerName;
  final List<BusinessHour> businessHours;
  final DateTime? lastUpdated;

  ProviderBusinessHoursData({
    required this.providerId,
    required this.providerName,
    required this.businessHours,
    required this.lastUpdated,
  });

  factory ProviderBusinessHoursData.fromJson(Map<String, dynamic> json) {
    return ProviderBusinessHoursData(
      providerId: json['providerId'] as String? ?? '',
      providerName: json['providerName'] as String? ?? '',
      businessHours: (json['businessHours'] as List)
          .map((item) => BusinessHour.fromJson(item as Map<String, dynamic>))
          .toList(),
      lastUpdated: DateTime.tryParse(json['lastUpdated'] as String? ?? ''),
    );
  }

  BusinessHour? getScheduleForDay(String dayName) {
    return businessHours.firstWhere(
      (BusinessHour schedule) =>
          schedule.day.toLowerCase() == dayName.toLowerCase(),
      orElse: () => BusinessHour(
        day: dayName,
        isOpen: false,
        is24Hours: false,
      ),
    );
  }
}

@immutable
class BusinessHour {
  final String day;
  final bool isOpen;
  final bool is24Hours;
  final String? openTime;
  final String? closeTime;

  const BusinessHour({
    required this.day,
    required this.isOpen,
    required this.is24Hours,
    this.openTime,
    this.closeTime,
  });

  factory BusinessHour.fromJson(Map<String, dynamic> json) {
    return BusinessHour(
      day: json['day'] as String? ?? '',
      isOpen: json['isOpen'] as bool? ?? false,
      is24Hours: json['is24Hours'] as bool? ?? false,
      openTime: json['openTime'] as String?,
      closeTime: json['closeTime'] as String?,
    );
  }

  List<String> generateTimeSlots() {
    // If closed, no slots available
    if (!isOpen) {
      return <String>[];
    }

    // If 24 hours, return single "24 Hours" slot
    if (is24Hours) {
      return <String>['24 Hours'];
    }

    // If open but missing times, return empty
    if (openTime == null || closeTime == null) {
      return <String>[];
    }

    return <String>[_formatTimeRange(openTime!, closeTime!)];
  }

  String _formatTimeRange(String open, String close) {
    return '${_format12Hour(open)} - ${_format12Hour(close)}';
  }

  String _format12Hour(String time24) {
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
