// features/notification/notifiers/notification_notifier.dart

import 'package:drop_n_fresh/core/utils/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/api/api_client.dart';
import '../../../app/providers/app_providers.dart';
import '../../../app/toast/toast.dart';
import '../models/notification_model.dart';
import '../state/notification_state.dart';

class NotificationNotifier extends AutoDisposeNotifier<NotificationState> {
  late final ApiClient _apiClient;

  @override
  NotificationState build() {
    _apiClient = ref.read(apiClientProvider);
    Future<dynamic>.microtask(() => _fetchNotifications());
    return const NotificationState(isLoading: true);
  }

  Future<void> _fetchNotifications({int page = 1}) async {
    final bool isLoadingMore = page > 1;

    state = state.copyWith(
      isLoading: !isLoadingMore,
      isLoadingMore: isLoadingMore,
      error: null,
    );

    try {
      final NotificationsResponse response = await _apiClient
          .handleRequest<NotificationsResponse>(
            httpMethod: HttpMethod.get,
            endpoint: ApiEndpoints.notifications,
            fromJson: NotificationsResponse.fromJson,
            queryParameters: <String, dynamic>{
              'page': page.toString(),
              'limit': '10',
            },
          );

      final List<NotificationModel> newNotifications =
          response.data.notifications;

      if (isLoadingMore) {
        state = state.copyWith(
          notifications: <NotificationModel>[
            ...state.notifications,
            ...newNotifications,
          ],
          unreadCount: response.data.unreadCount,
          page: page,
          totalPages: response.data.pagination.totalPages,
          hasMore: response.data.pagination.hasMore,
          isLoading: false,
          isLoadingMore: false,
        );
      } else {
        state = state.copyWith(
          notifications: newNotifications,
          unreadCount: response.data.unreadCount,
          page: page,
          totalPages: response.data.pagination.totalPages,
          hasMore: response.data.pagination.hasMore,
          isLoading: false,
          isLoadingMore: false,
        );
      }
    } catch (e, stack) {
      state = state.copyWith(
        error: ExceptionHandler.errorMessage(e),
        isLoading: false,
        isLoadingMore: false,
      );
      AppLogger().e(
        'Failed to fetch notifications: $e',
        error: e,
        stackTrace: stack,
      );
    }
  }

  Future<void> refresh() async {
    await _fetchNotifications(page: 1);
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) {
      return;
    }
    await _fetchNotifications(page: state.page + 1);
  }

  Future<bool> markAsRead(String notificationId) async {
    try {
      await _apiClient.handleRequest<Map<String, dynamic>>(
        httpMethod: HttpMethod.patch,
        endpoint: '${ApiEndpoints.notifications}/$notificationId/read',
      );

      final List<NotificationModel> updatedNotifications = state.notifications
          .map((NotificationModel n) {
            if (n.id == notificationId && !n.isRead) {
              return n.copyWith(isRead: true);
            }
            return n;
          })
          .toList();

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: state.unreadCount > 0 ? state.unreadCount - 1 : 0,
      );

      return true;
    } catch (e) {
      AppLogger().e('Failed to mark as read: $e', error: e);
      return false;
    }
  }

  Future<bool> markAllAsRead() async {
    state = state.copyWith(isMarkingAllAsRead: true, error: null);

    try {
      await _apiClient.handleRequest<Map<String, dynamic>>(
        httpMethod: HttpMethod.patch,
        endpoint: '${ApiEndpoints.notifications}/read-all',
      );

      final List<NotificationModel> updatedNotifications = state.notifications
          .map((NotificationModel n) => n.copyWith(isRead: true))
          .toList();

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: 0,
        isMarkingAllAsRead: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to mark all as read: ${e.toString()}',
        isMarkingAllAsRead: false,
      );
      Toast.showError('Failed to mark all as read');
      return false;
    }
  }

  Future<bool> deleteNotification(String notificationId) async {
    try {
      await _apiClient.handleRequest<Map<String, dynamic>>(
        httpMethod: HttpMethod.delete,
        endpoint: '${ApiEndpoints.notifications}/$notificationId',
      );

      final List<NotificationModel> updatedNotifications = state.notifications
          .where((NotificationModel n) => n.id != notificationId)
          .toList();

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount:
            state.notifications
                .firstWhere(
                  (NotificationModel n) => n.id == notificationId,
                )
                .isRead
            ? state.unreadCount
            : state.unreadCount - 1,
      );

      Toast.showSuccess('Notification deleted');
      return true;
    } catch (e) {
      Toast.showError('Failed to delete notification');
      return false;
    }
  }

  Future<bool> deleteAllNotifications() async {
    state = state.copyWith(isDeleting: true, error: null);

    try {
      await _apiClient.handleRequest<Map<String, dynamic>>(
        httpMethod: HttpMethod.delete,
        endpoint: ApiEndpoints.notifications,
      );

      state = state.copyWith(
        notifications: <NotificationModel>[],
        unreadCount: 0,
        isDeleting: false,
      );

      Toast.showSuccess('All notifications deleted');
      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to delete all: ${e.toString()}',
        isDeleting: false,
      );
      Toast.showError('Failed to delete all notifications');
      return false;
    }
  }
}
