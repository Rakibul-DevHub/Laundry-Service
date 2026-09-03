// features/notification/models/notification_model.dart

// ignore_for_file: always_specify_types

import 'package:flutter/foundation.dart';

//  API Response Wrapper - matches your backend structure
class NotificationsResponse {
  final int code;
  final bool success;
  final String message;
  final NotificationsData data;

  NotificationsResponse({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationsResponse(
      code: json['code'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: NotificationsData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

//  Data wrapper with notifications + pagination + unreadCount
class NotificationsData {
  final List<NotificationModel> notifications;
  final int unreadCount;
  final PaginationInfo pagination;

  NotificationsData({
    required this.notifications,
    required this.unreadCount,
    required this.pagination,
  });

  factory NotificationsData.fromJson(Map<String, dynamic> json) {
    return NotificationsData(
      notifications: (json['notifications'] as List)
          .map(
            (item) => NotificationModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      unreadCount: json['unreadCount'] as int? ?? 0,
      pagination: PaginationInfo.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );
  }
}

@immutable
class NotificationModel {
  final String id;
  final String receiverId;
  final String receiverRole;
  final String type;
  final String title;
  final String message;
  final Map<String, dynamic>? data;
  final bool isRead;
  final bool isDeleted;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NotificationModel({
    required this.id,
    required this.receiverId,
    required this.receiverRole,
    required this.type,
    required this.title,
    required this.message,
    this.data,
    required this.isRead,
    required this.isDeleted,
    this.readAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] as String,
      receiverId: json['receiverId'] as String,
      receiverRole: json['receiverRole'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      data: json['data'] as Map<String, dynamic>?,
      isRead: json['isRead'] as bool,
      isDeleted: json['isDeleted'] as bool,
      readAt: json['readAt'] != null
          ? DateTime.parse(json['readAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      '_id': id,
      'receiverId': receiverId,
      'receiverRole': receiverRole,
      'type': type,
      'title': title,
      'message': message,
      if (data != null) 'data': data,
      'isRead': isRead,
      'isDeleted': isDeleted,
      'readAt': readAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String get formattedTime {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(createdAt);

    if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays == 0) {
      return '${difference.inHours}h';
    } else if (difference.inDays == 1) {
      return '1d';
    } else {
      return '${difference.inDays}d';
    }
  }

  String? get bagDisplayCode {
    if (data == null) {
      return null;
    }
    return data!['displayCode'] as String?;
  }

  String? get bagId {
    if (data == null) {
      return null;
    }
    return data!['bagId'] as String?;
  }

  NotificationModel copyWith({
    String? id,
    String? receiverId,
    String? receiverRole,
    String? type,
    String? title,
    String? message,
    Map<String, dynamic>? data,
    bool? isRead,
    bool? isDeleted,
    DateTime? readAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      receiverId: receiverId ?? this.receiverId,
      receiverRole: receiverRole ?? this.receiverRole,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      isDeleted: isDeleted ?? this.isDeleted,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

//  Pagination Model
class PaginationInfo {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  PaginationInfo({
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
