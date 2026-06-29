// features/notification/state/notification_state.dart

import 'package:flutter/foundation.dart';
import '../models/notification_model.dart';

@immutable
class NotificationState {
  final List<NotificationModel> notifications;
  final int unreadCount;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final bool hasMore;
  final int page;
  final int totalPages;
  final bool isMarkingAllAsRead;
  final bool isDeleting;

  const NotificationState({
    this.notifications = const <NotificationModel>[],
    this.unreadCount = 0,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.hasMore = true,
    this.page = 1,
    this.totalPages = 1,
    this.isMarkingAllAsRead = false,
    this.isDeleting = false,
  });

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    int? unreadCount,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    bool? hasMore,
    int? page,
    int? totalPages,
    bool? isMarkingAllAsRead,
    bool? isDeleting,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      isMarkingAllAsRead: isMarkingAllAsRead ?? this.isMarkingAllAsRead,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }

  @override
  String toString() {
    return "notifications: ${notifications.length} | unread: $unreadCount | isLoading: $isLoading | hasMore: $hasMore";
  }
}
